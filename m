From: akpm@linux-foundation.org
Subject: - e1000e-test-for-unusable-msi-support.patch removed from -mm tree
Date: Thu, 14 Aug 2008 16:54:36 -0700
Message-ID: <200808142354.m7ENsaNC003953@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34427 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752123AbYHNXyi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Aug 2008 19:54:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bruce.w.allan@intel.com, jeffrey.t.kirsher@intel.com, mm-commits@vger.kernel.org


The patch titled
     e1000e: test for unusable MSI support
has been removed from the -mm tree.  Its filename was
     e1000e-test-for-unusable-msi-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: e1000e: test for unusable MSI support
From: Bruce Allan <bruce.w.allan@intel.com>

Some systems do not like 82571/2 use of 16-bit MSI messages and some other
systems claim to support MSI, but neither really works.  Setup a test MSI
handler to detect whether or not MSI is working properly, and if not,
fallback to legacy INTx interrupts.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e1000e/defines.h |    2 
 drivers/net/e1000e/e1000.h   |    1 
 drivers/net/e1000e/netdev.c  |  172 +++++++++++++++++++++++++++++++--
 3 files changed, 164 insertions(+), 11 deletions(-)

diff -puN drivers/net/e1000e/defines.h~e1000e-test-for-unusable-msi-support drivers/net/e1000e/defines.h
--- a/drivers/net/e1000e/defines.h~e1000e-test-for-unusable-msi-support
+++ a/drivers/net/e1000e/defines.h
@@ -389,7 +389,7 @@
 
 /* Interrupt Cause Set */
 #define E1000_ICS_LSC       E1000_ICR_LSC       /* Link Status Change */
-#define E1000_ICS_RXDMT0    E1000_ICR_RXDMT0    /* rx desc min. threshold */
+#define E1000_ICS_RXSEQ     E1000_ICR_RXSEQ     /* Rx sequence error */
 #define E1000_ICS_RXDMT0    E1000_ICR_RXDMT0    /* Rx desc min. threshold */
 
 /* Transmit Descriptor Control */
diff -puN drivers/net/e1000e/e1000.h~e1000e-test-for-unusable-msi-support drivers/net/e1000e/e1000.h
--- a/drivers/net/e1000e/e1000.h~e1000e-test-for-unusable-msi-support
+++ a/drivers/net/e1000e/e1000.h
@@ -326,6 +326,7 @@ struct e1000_info {
 #define FLAG_RX_CSUM_ENABLED              (1 << 28)
 #define FLAG_TSO_FORCE                    (1 << 29)
 #define FLAG_RX_RESTART_NOW               (1 << 30)
+#define FLAG_MSI_TEST_FAILED              (1 << 31)
 
 #define E1000_RX_DESC_PS(R, i)	    \
 	(&(((union e1000_rx_desc_packet_split *)((R).desc))[i]))
diff -puN drivers/net/e1000e/netdev.c~e1000e-test-for-unusable-msi-support drivers/net/e1000e/netdev.c
--- a/drivers/net/e1000e/netdev.c~e1000e-test-for-unusable-msi-support
+++ a/drivers/net/e1000e/netdev.c
@@ -1236,26 +1236,36 @@ static irqreturn_t e1000_intr(int irq, v
 	return IRQ_HANDLED;
 }
 
+/**
+ * e1000_request_irq - initialize interrupts
+ *
+ * Attempts to configure interrupts using the best available
+ * capabilities of the hardware and kernel.
+ **/
 static int e1000_request_irq(struct e1000_adapter *adapter)
 {
 	struct net_device *netdev = adapter->netdev;
-	irq_handler_t handler = e1000_intr;
 	int irq_flags = IRQF_SHARED;
 	int err;
 
-	if (!pci_enable_msi(adapter->pdev)) {
-		adapter->flags |= FLAG_MSI_ENABLED;
-		handler = e1000_intr_msi;
-		irq_flags = 0;
+	if (!(adapter->flags & FLAG_MSI_TEST_FAILED)) {
+		err = pci_enable_msi(adapter->pdev);
+		if (!err) {
+			adapter->flags |= FLAG_MSI_ENABLED;
+			irq_flags = 0;
+		}
 	}
 
-	err = request_irq(adapter->pdev->irq, handler, irq_flags, netdev->name,
-			  netdev);
+	err = request_irq(adapter->pdev->irq,
+			  ((adapter->flags & FLAG_MSI_ENABLED) ?
+				&e1000_intr_msi : &e1000_intr),
+			  irq_flags, netdev->name, netdev);
 	if (err) {
-		e_err("Unable to allocate %s interrupt (return: %d)\n",
-		      adapter->flags & FLAG_MSI_ENABLED ? "MSI":"INTx",	err);
-		if (adapter->flags & FLAG_MSI_ENABLED)
+		if (adapter->flags & FLAG_MSI_ENABLED) {
 			pci_disable_msi(adapter->pdev);
+			adapter->flags &= ~FLAG_MSI_ENABLED;
+		}
+		e_err("Unable to allocate interrupt, Error: %d\n", err);
 	}
 
 	return err;
@@ -2595,6 +2605,135 @@ err:
 }
 
 /**
+ * e1000_intr_msi_test - Interrupt Handler
+ * @irq: interrupt number
+ * @data: pointer to a network interface device structure
+ **/
+static irqreturn_t e1000_intr_msi_test(int irq, void *data)
+{
+	struct net_device *netdev = data;
+	struct e1000_adapter *adapter = netdev_priv(netdev);
+	struct e1000_hw *hw = &adapter->hw;
+	u32 icr = er32(ICR);
+
+	e_dbg("%s: icr is %08X\n", netdev->name, icr);
+	if (icr & E1000_ICR_RXSEQ) {
+		adapter->flags &= ~FLAG_MSI_TEST_FAILED;
+		wmb();
+	}
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * e1000_test_msi_interrupt - Returns 0 for successful test
+ * @adapter: board private struct
+ *
+ * code flow taken from tg3.c
+ **/
+static int e1000_test_msi_interrupt(struct e1000_adapter *adapter)
+{
+	struct net_device *netdev = adapter->netdev;
+	struct e1000_hw *hw = &adapter->hw;
+	int err;
+
+	/* poll_enable hasn't been called yet, so don't need disable */
+	/* clear any pending events */
+	er32(ICR);
+
+	/* free the real vector and request a test handler */
+	e1000_free_irq(adapter);
+
+	/* Assume that the test fails, if it succeeds then the test
+	 * MSI irq handler will unset this flag */
+	adapter->flags |= FLAG_MSI_TEST_FAILED;
+
+	err = pci_enable_msi(adapter->pdev);
+	if (err)
+		goto msi_test_failed;
+
+	err = request_irq(adapter->pdev->irq, &e1000_intr_msi_test, 0,
+			  netdev->name, netdev);
+	if (err) {
+		pci_disable_msi(adapter->pdev);
+		goto msi_test_failed;
+	}
+
+	wmb();
+
+	e1000_irq_enable(adapter);
+
+	/* fire an unusual interrupt on the test handler */
+	ew32(ICS, E1000_ICS_RXSEQ);
+	e1e_flush();
+	msleep(50);
+
+	e1000_irq_disable(adapter);
+
+	rmb();
+
+	if (adapter->flags & FLAG_MSI_TEST_FAILED) {
+		err = -EIO;
+		e_info("MSI interrupt test failed!\n");
+	}
+
+	free_irq(adapter->pdev->irq, netdev);
+	pci_disable_msi(adapter->pdev);
+
+	if (err == -EIO)
+		goto msi_test_failed;
+
+	/* okay so the test worked, restore settings */
+	e_dbg("%s: MSI interrupt test succeeded!\n", netdev->name);
+msi_test_failed:
+	/* restore the original vector, even if it failed */
+	e1000_request_irq(adapter);
+	return err;
+}
+
+/**
+ * e1000_test_msi - Returns 0 if MSI test succeeds or INTx mode is restored
+ * @adapter: board private struct
+ *
+ * code flow taken from tg3.c, called with e1000 interrupts disabled.
+ **/
+static int e1000_test_msi(struct e1000_adapter *adapter)
+{
+	int err;
+	u16 pci_cmd;
+
+	if (!(adapter->flags & FLAG_MSI_ENABLED))
+		return 0;
+
+	/* disable SERR in case the MSI write causes a master abort */
+	pci_read_config_word(adapter->pdev, PCI_COMMAND, &pci_cmd);
+	pci_write_config_word(adapter->pdev, PCI_COMMAND,
+			      pci_cmd & ~PCI_COMMAND_SERR);
+
+	err = e1000_test_msi_interrupt(adapter);
+
+	/* restore previous setting of command word */
+	pci_write_config_word(adapter->pdev, PCI_COMMAND, pci_cmd);
+
+	/* success ! */
+	if (!err)
+		return 0;
+
+	/* EIO means MSI test failed */
+	if (err != -EIO)
+		return err;
+
+	/* back to INTx mode */
+	e_warn("MSI interrupt test failed, using legacy interrupt.\n");
+
+	e1000_free_irq(adapter);
+
+	err = e1000_request_irq(adapter);
+
+	return err;
+}
+
+/**
  * e1000_open - Called when a network interface is made active
  * @netdev: network interface device structure
  *
@@ -2652,6 +2791,19 @@ static int e1000_open(struct net_device 
 	if (err)
 		goto err_req_irq;
 
+	/*
+	 * Work around PCIe errata with MSI interrupts causing some chipsets to
+	 * ignore e1000e MSI messages, which means we need to test our MSI
+	 * interrupt now
+	 */
+	{
+		err = e1000_test_msi(adapter);
+		if (err) {
+			e_err("Interrupt allocation failed\n");
+			goto err_req_irq;
+		}
+	}
+
 	/* From here on the code is the same as e1000e_up() */
 	clear_bit(__E1000_DOWN, &adapter->state);
 
_

Patches currently in -mm which might be from bruce.w.allan@intel.com are

git-net.patch
e1000e-remove-inapplicable-test-for-ioport-checkpatch-fixes.patch

