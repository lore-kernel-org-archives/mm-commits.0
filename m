From: akpm@linux-foundation.org
Subject: - p54-fix-misbehavings-when-firmware-cant-be-found.patch removed from -mm tree
Date: Tue, 28 Oct 2008 12:07:03 -0700
Message-ID: <200810281907.m9SJ733r023730@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37362 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752376AbYJ1TIZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Oct 2008 15:08:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chunkeey@web.de, johannes@sipsolutions.net, sean@mess.org, mm-commits@vger.kernel.org


The patch titled
     p54: fix misbehavings when firmware can't be found
has been removed from the -mm tree.  Its filename was
     p54-fix-misbehavings-when-firmware-cant-be-found.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: p54: fix misbehavings when firmware can't be found
=46rom: Christian Lamparter <chunkeey@web.de>

=46ix a double-free error in p54pci.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=3D11782.

Trying to free already-free IRQ 10
Pid: 108, comm: pccardd Not tainted 2.6.27-05577-g0cfd810-dirty #1
Call Trace:
=A0[<c01265dc>] free_irq+0xad/0xb9
=A0[<c01050dd>] dma_generic_alloc_coherent+0x0/0xd7
=A0[<c01ba8e6>] p54p_stop+0x4a/0x1fa
=A0[<c01050dd>] dma_generic_alloc_coherent+0x0/0xd7
=A0[<c02348c5>] p54p_probe+0x23e/0x302

Tested-by: Sean Young <sean@mess.org>
Signed-off-by: Christian Lamparter <chunkeey@web.de>
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/p54/p54pci.c |  132 ++++++++++++++--------------
 1 file changed, 66 insertions(+), 66 deletions(-)

diff -puN drivers/net/wireless/p54/p54pci.c~p54-fix-misbehavings-when-f=
irmware-cant-be-found drivers/net/wireless/p54/p54pci.c
--- a/drivers/net/wireless/p54/p54pci.c~p54-fix-misbehavings-when-firmw=
are-cant-be-found
+++ a/drivers/net/wireless/p54/p54pci.c
@@ -346,68 +346,6 @@ static void p54p_tx(struct ieee80211_hw=20
 		printk(KERN_INFO "%s: tx overflow.\n", wiphy_name(dev->wiphy));
 }
=20
-static int p54p_open(struct ieee80211_hw *dev)
-{
-	struct p54p_priv *priv =3D dev->priv;
-	int err;
-
-	init_completion(&priv->boot_comp);
-	err =3D request_irq(priv->pdev->irq, &p54p_interrupt,
-			  IRQF_SHARED, "p54pci", dev);
-	if (err) {
-		printk(KERN_ERR "%s: failed to register IRQ handler\n",
-		       wiphy_name(dev->wiphy));
-		return err;
-	}
-
-	memset(priv->ring_control, 0, sizeof(*priv->ring_control));
-	err =3D p54p_upload_firmware(dev);
-	if (err) {
-		free_irq(priv->pdev->irq, dev);
-		return err;
-	}
-	priv->rx_idx_data =3D priv->tx_idx_data =3D 0;
-	priv->rx_idx_mgmt =3D priv->tx_idx_mgmt =3D 0;
-
-	p54p_refill_rx_ring(dev, 0, priv->ring_control->rx_data,
-		ARRAY_SIZE(priv->ring_control->rx_data), priv->rx_buf_data);
-
-	p54p_refill_rx_ring(dev, 2, priv->ring_control->rx_mgmt,
-		ARRAY_SIZE(priv->ring_control->rx_mgmt), priv->rx_buf_mgmt);
-
-	P54P_WRITE(ring_control_base, cpu_to_le32(priv->ring_control_dma));
-	P54P_READ(ring_control_base);
-	wmb();
-	udelay(10);
-
-	P54P_WRITE(int_enable, cpu_to_le32(ISL38XX_INT_IDENT_INIT));
-	P54P_READ(int_enable);
-	wmb();
-	udelay(10);
-
-	P54P_WRITE(dev_int, cpu_to_le32(ISL38XX_DEV_INT_RESET));
-	P54P_READ(dev_int);
-
-	if (!wait_for_completion_interruptible_timeout(&priv->boot_comp, HZ))=
 {
-		printk(KERN_ERR "%s: Cannot boot firmware!\n",
-		       wiphy_name(dev->wiphy));
-		free_irq(priv->pdev->irq, dev);
-		return -ETIMEDOUT;
-	}
-
-	P54P_WRITE(int_enable, cpu_to_le32(ISL38XX_INT_IDENT_UPDATE));
-	P54P_READ(int_enable);
-	wmb();
-	udelay(10);
-
-	P54P_WRITE(dev_int, cpu_to_le32(ISL38XX_DEV_INT_UPDATE));
-	P54P_READ(dev_int);
-	wmb();
-	udelay(10);
-
-	return 0;
-}
-
 static void p54p_stop(struct ieee80211_hw *dev)
 {
 	struct p54p_priv *priv =3D dev->priv;
@@ -474,6 +412,68 @@ static void p54p_stop(struct ieee80211_h
 	memset(ring_control, 0, sizeof(*ring_control));
 }
=20
+static int p54p_open(struct ieee80211_hw *dev)
+{
+	struct p54p_priv *priv =3D dev->priv;
+	int err;
+
+	init_completion(&priv->boot_comp);
+	err =3D request_irq(priv->pdev->irq, &p54p_interrupt,
+			  IRQF_SHARED, "p54pci", dev);
+	if (err) {
+		printk(KERN_ERR "%s: failed to register IRQ handler\n",
+		       wiphy_name(dev->wiphy));
+		return err;
+	}
+
+	memset(priv->ring_control, 0, sizeof(*priv->ring_control));
+	err =3D p54p_upload_firmware(dev);
+	if (err) {
+		free_irq(priv->pdev->irq, dev);
+		return err;
+	}
+	priv->rx_idx_data =3D priv->tx_idx_data =3D 0;
+	priv->rx_idx_mgmt =3D priv->tx_idx_mgmt =3D 0;
+
+	p54p_refill_rx_ring(dev, 0, priv->ring_control->rx_data,
+		ARRAY_SIZE(priv->ring_control->rx_data), priv->rx_buf_data);
+
+	p54p_refill_rx_ring(dev, 2, priv->ring_control->rx_mgmt,
+		ARRAY_SIZE(priv->ring_control->rx_mgmt), priv->rx_buf_mgmt);
+
+	P54P_WRITE(ring_control_base, cpu_to_le32(priv->ring_control_dma));
+	P54P_READ(ring_control_base);
+	wmb();
+	udelay(10);
+
+	P54P_WRITE(int_enable, cpu_to_le32(ISL38XX_INT_IDENT_INIT));
+	P54P_READ(int_enable);
+	wmb();
+	udelay(10);
+
+	P54P_WRITE(dev_int, cpu_to_le32(ISL38XX_DEV_INT_RESET));
+	P54P_READ(dev_int);
+
+	if (!wait_for_completion_interruptible_timeout(&priv->boot_comp, HZ))=
 {
+		printk(KERN_ERR "%s: Cannot boot firmware!\n",
+		       wiphy_name(dev->wiphy));
+		p54p_stop(dev);
+		return -ETIMEDOUT;
+	}
+
+	P54P_WRITE(int_enable, cpu_to_le32(ISL38XX_INT_IDENT_UPDATE));
+	P54P_READ(int_enable);
+	wmb();
+	udelay(10);
+
+	P54P_WRITE(dev_int, cpu_to_le32(ISL38XX_DEV_INT_UPDATE));
+	P54P_READ(dev_int);
+	wmb();
+	udelay(10);
+
+	return 0;
+}
+
 static int __devinit p54p_probe(struct pci_dev *pdev,
 				const struct pci_device_id *id)
 {
@@ -556,11 +556,13 @@ static int __devinit p54p_probe(struct p
 	spin_lock_init(&priv->lock);
 	tasklet_init(&priv->rx_tasklet, p54p_rx_tasklet, (unsigned long)dev);
=20
-	p54p_open(dev);
+	err =3D p54p_open(dev);
+	if (err)
+		goto err_free_common;
 	err =3D p54_read_eeprom(dev);
 	p54p_stop(dev);
 	if (err)
-		goto err_free_desc;
+		goto err_free_common;
=20
 	err =3D ieee80211_register_hw(dev);
 	if (err) {
@@ -573,8 +575,6 @@ static int __devinit p54p_probe(struct p
=20
  err_free_common:
 	p54_free_common(dev);
