From: akpm@linux-foundation.org
Subject: + some-kmalloc-memset-kzalloc-tree-wide-kcalloc-fixes.patch added to -mm tree
Date: Fri, 06 Jul 2007 23:53:52 -0700
Message-ID: <200707070653.l676rqev013826@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56947 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751916AbXGGGyj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 7 Jul 2007 02:54:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: padator@wanadoo.fr, James.Bottomley@steeleye.com, adaplas@pol.net, airlied@linux.ie, benh@kernel.crashing.org, bryan.wu@analog.com, davem@davemloft.net, drzeus-list@drzeus.cx, dtor@mail.ru, greg@kroah.com, ink@jurassic.park.msu.ru, jeff@garzik.org, jirislaby@gmail.com, jkosina@suse.cz, mchehab@infradead.org, rmk@arm.linux.org.uk, rolandd@cisco.com, rth@twiddle.net


The patch titled
     some-kmalloc-memset-kzalloc-tree-wide kcalloc fixes
has been added to the -mm tree.  Its filename is
     some-kmalloc-memset-kzalloc-tree-wide-kcalloc-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: some-kmalloc-memset-kzalloc-tree-wide kcalloc fixes
From: Yoann Padioleau <padator@wanadoo.fr>

Cosmetic, really.

Cc: Yoann Padioleau <padator@wanadoo.fr>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Bryan Wu <bryan.wu@analog.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Roland Dreier <rolandd@cisco.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Greg KH <greg@kroah.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-iop13xx/pci.c           |    2 +-
 drivers/char/drm/via_dmablit.c        |    2 +-
 drivers/net/forcedeth.c               |    4 ++--
 drivers/net/wan/cosa.c                |    2 +-
 drivers/net/wan/cycx_main.c           |    2 +-
 drivers/net/wan/x25_asy.c             |    2 +-
 drivers/sbus/char/vfc_dev.c           |    2 +-
 drivers/scsi/3w-9xxx.c                |    2 +-
 drivers/scsi/megaraid/megaraid_mbox.c |    4 ++--
 drivers/scsi/megaraid/megaraid_sas.c  |    2 +-
 drivers/video/au1200fb.c              |    2 +-
 11 files changed, 13 insertions(+), 13 deletions(-)

diff -puN arch/arm/mach-iop13xx/pci.c~some-kmalloc-memset-kzalloc-tree-wide-kcalloc-fixes arch/arm/mach-iop13xx/pci.c
--- a/arch/arm/mach-iop13xx/pci.c~some-kmalloc-memset-kzalloc-tree-wide-kcalloc-fixes
+++ a/arch/arm/mach-iop13xx/pci.c
@@ -1002,7 +1002,7 @@ int iop13xx_pci_setup(int nr, struct pci
 	if (nr > 1)
 		return 0;
 
-	res = kcalloc(sizeof(struct resource), 2, GFP_KERNEL);
+	res = kcalloc(2, sizeof(struct resource), GFP_KERNEL);
 	if (!res)
 		panic("PCI: unable to alloc resources");
 
diff -puN drivers/char/drm/via_dmablit.c~some-kmalloc-memset-kzalloc-tree-wide-kcalloc-fixes drivers/char/drm/via_dmablit.c
--- a/drivers/char/drm/via_dmablit.c~some-kmalloc-memset-kzalloc-tree-wide-kcalloc-fixes
+++ a/drivers/char/drm/via_dmablit.c
@@ -273,7 +273,7 @@ via_alloc_desc_pages(drm_via_sg_info_t *
 	vsg->num_desc_pages = (vsg->num_desc + vsg->descriptors_per_page - 1) / 
 		vsg->descriptors_per_page;
 
-	if (NULL ==  (vsg->desc_pages = kcalloc(sizeof(void *), vsg->num_desc_pages, GFP_KERNEL)))
+	if (NULL ==  (vsg->desc_pages = kcalloc(vsg->num_desc_pages, sizeof(void *), GFP_KERNEL)))
 		return DRM_ERR(ENOMEM);
 	
 	vsg->state = dr_via_desc_pages_alloc;
diff -puN drivers/net/forcedeth.c~some-kmalloc-memset-kzalloc-tree-wide-kcalloc-fixes drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~some-kmalloc-memset-kzalloc-tree-wide-kcalloc-fixes
+++ a/drivers/net/forcedeth.c
@@ -4995,8 +4995,8 @@ static int __devinit nv_probe(struct pci
 			goto out_unmap;
 		np->tx_ring.ex = &np->rx_ring.ex[np->rx_ring_size];
 	}
-	np->rx_skb = kcalloc(sizeof(struct nv_skb_map), np->rx_ring_size, GFP_KERNEL);
-	np->tx_skb = kcalloc(sizeof(struct nv_skb_map), np->tx_ring_size, GFP_KERNEL);
+	np->rx_skb = kcalloc(np->rx_ring_size, sizeof(struct nv_skb_map), GFP_KERNEL);
+	np->tx_skb = kcalloc(np->tx_ring_size, sizeof(struct nv_skb_map), GFP_KERNEL);
 	if (!np->rx_skb || !np->tx_skb)
 		goto out_freering;
 
diff -puN drivers/net/wan/cosa.c~some-kmalloc-memset-kzalloc-tree-wide-kcalloc-fixes drivers/net/wan/cosa.c
--- a/drivers/net/wan/cosa.c~some-kmalloc-memset-kzalloc-tree-wide-kcalloc-fixes
+++ a/drivers/net/wan/cosa.c
@@ -572,7 +572,7 @@ static int cosa_probe(int base, int irq,
 	sprintf(cosa->name, "cosa%d", cosa->num);
 
 	/* Initialize the per-channel data */
-	cosa->chan = kcalloc(sizeof(struct channel_data), cosa->nchannels, GFP_KERNEL);
+	cosa->chan = kcalloc(cosa->nchannels, sizeof(struct channel_data), GFP_KERNEL);
 	if (!cosa->chan) {
 	        err = -ENOMEM;
 		goto err_out3;
diff -puN drivers/net/wan/cycx_main.c~some-kmalloc-memset-kzalloc-tree-wide-kcalloc-fixes drivers/net/wan/cycx_main.c
--- a/drivers/net/wan/cycx_main.c~some-kmalloc-memset-kzalloc-tree-wide-kcalloc-fixes
+++ a/drivers/net/wan/cycx_main.c
@@ -113,7 +113,7 @@ static int __init cycx_init(void)
 	/* Verify number of cards and allocate adapter data space */
 	cycx_ncards = min_t(int, cycx_ncards, CYCX_MAX_CARDS);
 	cycx_ncards = max_t(int, cycx_ncards, 1);
-	cycx_card_array = kcalloc(sizeof(struct cycx_device), cycx_ncards, GFP_KERNEL);
+	cycx_card_array = kcalloc(cycx_ncards, sizeof(struct cycx_device), GFP_KERNEL);
 	if (!cycx_card_array)
 		goto out;
 
diff -puN drivers/net/wan/x25_asy.c~some-kmalloc-memset-kzalloc-tree-wide-kcalloc-fixes drivers/net/wan/x25_asy.c
--- a/drivers/net/wan/x25_asy.c~some-kmalloc-memset-kzalloc-tree-wide-kcalloc-fixes
+++ a/drivers/net/wan/x25_asy.c
@@ -786,7 +786,7 @@ static int __init init_x25_asy(void)
 	printk(KERN_INFO "X.25 async: version 0.00 ALPHA "
 			"(dynamic channels, max=%d).\n", x25_asy_maxdev );
 
-	x25_asy_devs = kcalloc(sizeof(struct net_device*), x25_asy_maxdev, GFP_KERNEL);
+	x25_asy_devs = kcalloc(x25_asy_maxdev, sizeof(struct net_device*), GFP_KERNEL);
 	if (!x25_asy_devs) {
 		printk(KERN_WARNING "X25 async: Can't allocate x25_asy_ctrls[] "
 				"array! Uaargh! (-> No X.25 available)\n");
diff -puN drivers/sbus/char/vfc_dev.c~some-kmalloc-memset-kzalloc-tree-wide-kcalloc-fixes drivers/sbus/char/vfc_dev.c
--- a/drivers/sbus/char/vfc_dev.c~some-kmalloc-memset-kzalloc-tree-wide-kcalloc-fixes
+++ a/drivers/sbus/char/vfc_dev.c
@@ -657,7 +657,7 @@ static int vfc_probe(void)
 	if (!cards)
 		return -ENODEV;
 
-	vfc_dev_lst = kcalloc(sizeof(struct vfc_dev*), (cards+1), GFP_KERNEL);
+	vfc_dev_lst = kcalloc(cards + 1, sizeof(struct vfc_dev*), GFP_KERNEL);
 	if (vfc_dev_lst == NULL)
 		return -ENOMEM;
 	vfc_dev_lst[cards] = NULL;
diff -puN drivers/scsi/3w-9xxx.c~some-kmalloc-memset-kzalloc-tree-wide-kcalloc-fixes drivers/scsi/3w-9xxx.c
--- a/drivers/scsi/3w-9xxx.c~some-kmalloc-memset-kzalloc-tree-wide-kcalloc-fixes
+++ a/drivers/scsi/3w-9xxx.c
@@ -1160,7 +1160,7 @@ static int twa_initialize_device_extensi
 	}
 
 	/* Allocate event info space */
-	tw_dev->event_queue[0] = kcalloc(sizeof(TW_Event), TW_Q_LENGTH, GFP_KERNEL);
+	tw_dev->event_queue[0] = kcalloc(TW_Q_LENGTH, sizeof(TW_Event), GFP_KERNEL);
 	if (!tw_dev->event_queue[0]) {
 		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x18, "Event info memory allocation failed");
 		goto out;
diff -puN drivers/scsi/megaraid/megaraid_mbox.c~some-kmalloc-memset-kzalloc-tree-wide-kcalloc-fixes drivers/scsi/megaraid/megaraid_mbox.c
--- a/drivers/scsi/megaraid/megaraid_mbox.c~some-kmalloc-memset-kzalloc-tree-wide-kcalloc-fixes
+++ a/drivers/scsi/megaraid/megaraid_mbox.c
@@ -1048,7 +1048,7 @@ megaraid_alloc_cmd_packets(adapter_t *ad
 	 * since the calling routine does not yet know the number of available
 	 * commands.
 	 */
-	adapter->kscb_list = kcalloc(sizeof(scb_t), MBOX_MAX_SCSI_CMDS, GFP_KERNEL);
+	adapter->kscb_list = kcalloc(MBOX_MAX_SCSI_CMDS, sizeof(scb_t), GFP_KERNEL);
 
 	if (adapter->kscb_list == NULL) {
 		con_log(CL_ANN, (KERN_WARNING
@@ -3491,7 +3491,7 @@ megaraid_cmm_register(adapter_t *adapter
 	int		i;
 
 	// Allocate memory for the base list of scb for management module.
-	adapter->uscb_list = kcalloc(sizeof(scb_t), MBOX_MAX_USER_CMDS, GFP_KERNEL);
+	adapter->uscb_list = kcalloc(MBOX_MAX_USER_CMDS, sizeof(scb_t), GFP_KERNEL);
 
 	if (adapter->uscb_list == NULL) {
 		con_log(CL_ANN, (KERN_WARNING
diff -puN drivers/scsi/megaraid/megaraid_sas.c~some-kmalloc-memset-kzalloc-tree-wide-kcalloc-fixes drivers/scsi/megaraid/megaraid_sas.c
--- a/drivers/scsi/megaraid/megaraid_sas.c~some-kmalloc-memset-kzalloc-tree-wide-kcalloc-fixes
+++ a/drivers/scsi/megaraid/megaraid_sas.c
@@ -1636,7 +1636,7 @@ static int megasas_alloc_cmds(struct meg
 	 * Allocate the dynamic array first and then allocate individual
 	 * commands.
 	 */
-	instance->cmd_list = kcalloc(sizeof(struct megasas_cmd*), max_cmd, GFP_KERNEL);
+	instance->cmd_list = kcalloc(max_cmd, sizeof(struct megasas_cmd*), GFP_KERNEL);
 
 	if (!instance->cmd_list) {
 		printk(KERN_DEBUG "megasas: out of memory\n");
diff -puN drivers/video/au1200fb.c~some-kmalloc-memset-kzalloc-tree-wide-kcalloc-fixes drivers/video/au1200fb.c
--- a/drivers/video/au1200fb.c~some-kmalloc-memset-kzalloc-tree-wide-kcalloc-fixes
+++ a/drivers/video/au1200fb.c
@@ -1589,7 +1589,7 @@ static int au1200fb_init_fbinfo(struct a
 		return -EFAULT;
 	}
 
-	fbi->pseudo_palette = kcalloc(sizeof(u32), 16, GFP_KERNEL);
+	fbi->pseudo_palette = kcalloc(16, sizeof(u32), GFP_KERNEL);
 	if (!fbi->pseudo_palette) {
 		return -ENOMEM;
 	}
_

Patches currently in -mm which might be from padator@wanadoo.fr are

potential-compiler-error-irqfunc-caller-sites-update.patch
atari_pamsnetc-old-declaration-ritchie-style-fix.patch
some-kmalloc-memset-kzalloc-tree-wide.patch
some-kmalloc-memset-kzalloc-tree-wide-kcalloc-fixes.patch
