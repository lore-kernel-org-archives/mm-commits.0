From: akpm@linux-foundation.org
Subject: - s2io-add-pci-error-recovery-support.patch removed from -mm tree
Date: Mon, 26 Mar 2007 21:46:14 -0800
Message-ID: <200703270546.l2R5kEZp008233@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40077 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932493AbXC0FqY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Mar 2007 01:46:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linas@austin.ibm.com, Ananda.Raju@neterion.com, Ramkrishna.Vepa@neterion.com, raghavendra.koushik@neterion.com, wenxiong@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     s2io: add PCI error recovery support
has been removed from the -mm tree.  Its filename was
     s2io-add-pci-error-recovery-support.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: s2io: add PCI error recovery support
From: Linas Vepstas <linas@austin.ibm.com>

Add PCI error recovery support to the s2io 10-Gigabit ethernet device driver. 
Fourth revision, blocks interrupts and the watchdog.  Adds a flag to
s2io_down(), to avoid doing I/O when PCI bus is offline.

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Acked-by: Ramkrishna Vepa <Ramkrishna.Vepa@neterion.com>
Cc: Raghavendra Koushik <raghavendra.koushik@neterion.com>
Cc: Ananda Raju <Ananda.Raju@neterion.com>
Cc: Wen Xiong <wenxiong@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/s2io.c |  116 +++++++++++++++++++++++++++++++++++++++++--
 drivers/net/s2io.h |    5 +
 2 files changed, 116 insertions(+), 5 deletions(-)

diff -puN drivers/net/s2io.c~s2io-add-pci-error-recovery-support drivers/net/s2io.c
--- a/drivers/net/s2io.c~s2io-add-pci-error-recovery-support
+++ a/drivers/net/s2io.c
@@ -459,11 +459,18 @@ static struct pci_device_id s2io_tbl[] _
 
 MODULE_DEVICE_TABLE(pci, s2io_tbl);
 
+static struct pci_error_handlers s2io_err_handler = {
+	.error_detected = s2io_io_error_detected,
+	.slot_reset = s2io_io_slot_reset,
+	.resume = s2io_io_resume,
+};
+
 static struct pci_driver s2io_driver = {
       .name = "S2IO",
       .id_table = s2io_tbl,
       .probe = s2io_init_nic,
       .remove = __devexit_p(s2io_rem_nic),
+      .err_handler = &s2io_err_handler,
 };
 
 /* A simplifier macro used both by init and free shared_mem Fns(). */
@@ -2626,6 +2633,9 @@ static void s2io_netpoll(struct net_devi
 	u64 val64 = 0xFFFFFFFFFFFFFFFFULL;
 	int i;
 
+	if (pci_channel_offline(nic->pdev))
+		return;
+
 	disable_irq(dev->irq);
 
 	atomic_inc(&nic->isr_cnt);
@@ -3128,6 +3138,8 @@ static void alarm_intr_handler(struct s2
 	int i;
 	if (atomic_read(&nic->card_state) == CARD_DOWN)
 		return;
+	if (pci_channel_offline(nic->pdev))
+		return;
 	nic->mac_control.stats_info->sw_stat.ring_full_cnt = 0;
 	/* Handling the XPAK counters update */
 	if(nic->mac_control.stats_info->xpak_stat.xpak_timer_count < 72000) {
@@ -4190,6 +4202,10 @@ static irqreturn_t s2io_isr(int irq, voi
 	struct mac_info *mac_control;
 	struct config_param *config;
 
+	/* Pretend we handled any irq's from a disconnected card */
+	if (pci_channel_offline(sp->pdev))
+		return IRQ_NONE;
+
 	atomic_inc(&sp->isr_cnt);
 	mac_control = &sp->mac_control;
 	config = &sp->config;
@@ -6363,7 +6379,7 @@ static void s2io_rem_isr(struct s2io_nic
 	} while(cnt < 5);
 }
 
-static void s2io_card_down(struct s2io_nic * sp)
+static void do_s2io_card_down(struct s2io_nic * sp, int do_io)
 {
 	int cnt = 0;
 	struct XENA_dev_config __iomem *bar0 = sp->bar0;
@@ -6378,7 +6394,8 @@ static void s2io_card_down(struct s2io_n
 	atomic_set(&sp->card_state, CARD_DOWN);
 
 	/* disable Tx and Rx traffic on the NIC */
-	stop_nic(sp);
+	if (do_io)
+		stop_nic(sp);
 
 	s2io_rem_isr(sp);
 
@@ -6386,7 +6403,7 @@ static void s2io_card_down(struct s2io_n
 	tasklet_kill(&sp->task);
 
 	/* Check if the device is Quiescent and then Reset the NIC */
-	do {
+	while(do_io) {
 		/* As per the HW requirement we need to replenish the
 		 * receive buffer to avoid the ring bump. Since there is
 		 * no intention of processing the Rx frame at this pointwe are
@@ -6411,8 +6428,9 @@ static void s2io_card_down(struct s2io_n
 				  (unsigned long long) val64);
 			break;
 		}
-	} while (1);
-	s2io_reset(sp);
+	}
+	if (do_io)
+		s2io_reset(sp);
 
 	spin_lock_irqsave(&sp->tx_lock, flags);
 	/* Free all Tx buffers */
@@ -6427,6 +6445,11 @@ static void s2io_card_down(struct s2io_n
 	clear_bit(0, &(sp->link_state));
 }
 
+static void s2io_card_down(struct s2io_nic * sp)
+{
+	do_s2io_card_down(sp, 1);
+}
+
 static int s2io_card_up(struct s2io_nic * sp)
 {
 	int i, ret = 0;
@@ -7748,3 +7771,86 @@ static void lro_append_pkt(struct s2io_n
 	sp->mac_control.stats_info->sw_stat.clubbed_frms_cnt++;
 	return;
 }
+
+/**
+ * s2io_io_error_detected - called when PCI error is detected
+ * @pdev: Pointer to PCI device
+ * @state: The current pci conneection state
+ *
+ * This function is called after a PCI bus error affecting
+ * this device has been detected.
+ */
+static pci_ers_result_t s2io_io_error_detected(struct pci_dev *pdev,
+                                               pci_channel_state_t state)
+{
+	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct s2io_nic *sp = netdev->priv;
+
+	netif_device_detach(netdev);
+
+	if (netif_running(netdev)) {
+		/* Bring down the card, while avoiding PCI I/O */
+		do_s2io_card_down(sp, 0);
+		sp->device_close_flag = TRUE;	/* Device is shut down. */
+	}
+	pci_disable_device(pdev);
+
+	return PCI_ERS_RESULT_NEED_RESET;
+}
+
+/**
+ * s2io_io_slot_reset - called after the pci bus has been reset.
+ * @pdev: Pointer to PCI device
+ *
+ * Restart the card from scratch, as if from a cold-boot.
+ * At this point, the card has exprienced a hard reset,
+ * followed by fixups by BIOS, and has its config space
+ * set up identically to what it was at cold boot.
+ */
+static pci_ers_result_t s2io_io_slot_reset(struct pci_dev *pdev)
+{
+	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct s2io_nic *sp = netdev->priv;
+
+	if (pci_enable_device(pdev)) {
+		printk(KERN_ERR "s2io: "
+		       "Cannot re-enable PCI device after reset.\n");
+		return PCI_ERS_RESULT_DISCONNECT;
+	}
+
+	pci_set_master(pdev);
+	s2io_reset(sp);
+
+	return PCI_ERS_RESULT_RECOVERED;
+}
+
+/**
+ * s2io_io_resume - called when traffic can start flowing again.
+ * @pdev: Pointer to PCI device
+ *
+ * This callback is called when the error recovery driver tells
+ * us that its OK to resume normal operation.
+ */
+static void s2io_io_resume(struct pci_dev *pdev)
+{
+	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct s2io_nic *sp = netdev->priv;
+
+	if (netif_running(netdev)) {
+		if (s2io_card_up(sp)) {
+			printk(KERN_ERR "s2io: "
+			       "Can't bring device back up after reset.\n");
+			return;
+		}
+
+		if (s2io_set_mac_addr(netdev, netdev->dev_addr) == FAILURE) {
+			s2io_card_down(sp);
+			printk(KERN_ERR "s2io: "
+			       "Can't resetore mac addr after reset.\n");
+			return;
+		}
+	}
+
+	netif_device_attach(netdev);
+	netif_wake_queue(netdev);
+}
diff -puN drivers/net/s2io.h~s2io-add-pci-error-recovery-support drivers/net/s2io.h
--- a/drivers/net/s2io.h~s2io-add-pci-error-recovery-support
+++ a/drivers/net/s2io.h
@@ -1026,6 +1026,11 @@ static void lro_append_pkt(struct s2io_n
 			   struct sk_buff *skb, u32 tcp_len);
 static int rts_ds_steer(struct s2io_nic *nic, u8 ds_codepoint, u8 ring);
 
+static pci_ers_result_t s2io_io_error_detected(struct pci_dev *pdev,
+			                      pci_channel_state_t state);
+static pci_ers_result_t s2io_io_slot_reset(struct pci_dev *pdev);
+static void s2io_io_resume(struct pci_dev *pdev);
+
 #define s2io_tcp_mss(skb) skb_shinfo(skb)->gso_size
 #define s2io_udp_mss(skb) skb_shinfo(skb)->gso_size
 #define s2io_offload_type(skb) skb_shinfo(skb)->gso_type
_

Patches currently in -mm which might be from linas@austin.ibm.com are

git-powerpc.patch
s2io-add-pci-error-recovery-support.patch
git-scsi-rc-fixes.patch
