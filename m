From: akpm@linux-foundation.org
Subject: [patch 70/78] lib/vsprintf.c: remove %Z support
Date: Mon, 27 Feb 2017 14:30:02 -0800
Message-ID: <58b4a86a.Y3/lwWQV4Ooz0vDP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44856 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751587AbdB0Wdi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 17:33:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, adobriyan@gmail.com, andy.shevchenko@gmail.com, linux@rasmusvillemoes.dk

From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: lib/vsprintf.c: remove %Z support

Now that %z is standartised in C99 there is no reason to support %Z. 
Unlike %L it doesn't even make format strings smaller.

Use BUILD_BUG_ON in a couple ATM drivers.

In case anyone didn't notice lib/vsprintf.o is about half of SLUB which is
in my opinion is quite an achievement.  Hopefully this patch inspires
someone else to trim vsprintf.c more.

Link: http://lkml.kernel.org/r/20170103230126.GA30170@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/bsg.c                                                 |    6 
 drivers/atm/ambassador.c                                    |    7 -
 drivers/atm/eni.c                                           |    6 
 drivers/atm/firestream.c                                    |   12 -
 drivers/atm/horizon.c                                       |    7 -
 drivers/atm/lanai.c                                         |   16 +-
 drivers/char/pcmcia/cm4000_cs.c                             |    2 
 drivers/char/pcmcia/cm4040_cs.c                             |    2 
 drivers/gpu/drm/mga/mga_drv.h                               |    4 
 drivers/ide/ide-acpi.c                                      |    2 
 drivers/ide/ide-tape.c                                      |    4 
 drivers/input/touchscreen/cyttsp4_core.c                    |   62 +++++-----
 drivers/media/dvb-frontends/helene.c                        |    2 
 drivers/media/dvb-frontends/or51132.c                       |    2 
 drivers/media/dvb-frontends/tda10048.c                      |    2 
 drivers/media/pci/saa7164/saa7164-fw.c                      |    2 
 drivers/media/tuners/xc5000.c                               |    2 
 drivers/media/usb/dvb-usb/dib0700_devices.c                 |    4 
 drivers/misc/vmw_vmci/vmci_context.c                        |    2 
 drivers/net/arcnet/arcnet.c                                 |    2 
 drivers/net/ethernet/cadence/macb.c                         |    2 
 drivers/net/gtp.c                                           |    2 
 drivers/net/usb/rndis_host.c                                |    2 
 drivers/net/usb/sierra_net.c                                |    2 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c |    2 
 drivers/net/wireless/intel/iwlegacy/4965-mac.c              |   30 ++--
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c                |   16 +-
 drivers/parport/ieee1284_ops.c                              |    2 
 drivers/scsi/osd/osd_initiator.c                            |    2 
 drivers/scsi/osst.c                                         |    6 
 drivers/scsi/qla2xxx/qla_init.c                             |   10 -
 drivers/tty/n_hdlc.c                                        |    2 
 drivers/usb/gadget/legacy/inode.c                           |    2 
 drivers/usb/host/ehci-hcd.c                                 |    2 
 drivers/usb/host/fotg210-hcd.c                              |    2 
 drivers/usb/host/ohci-hcd.c                                 |    2 
 drivers/usb/misc/adutux.c                                   |    6 
 drivers/usb/misc/legousbtower.c                             |    2 
 drivers/usb/misc/uss720.c                                   |    8 -
 drivers/video/fbdev/metronomefb.c                           |    2 
 fs/afs/dir.c                                                |   14 +-
 fs/ncpfs/sock.c                                             |    4 
 fs/nfs/blocklayout/blocklayout.c                            |    2 
 fs/nfs/filelayout/filelayout.c                              |    4 
 fs/nfs/flexfilelayout/flexfilelayout.c                      |    4 
 fs/nfs/objlayout/objlayout.c                                |    2 
 fs/nfsd/nfscache.c                                          |    2 
 kernel/relay.c                                              |    2 
 lib/vsprintf.c                                              |    8 -
 mm/dmapool.c                                                |    2 
 net/appletalk/ddp.c                                         |    4 
 net/atm/mpc.c                                               |    2 
 net/bridge/netfilter/ebt_among.c                            |    2 
 net/ieee802154/socket.c                                     |    4 
 net/ipv4/fib_trie.c                                         |    2 
 net/ipv4/ipmr.c                                             |    2 
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c              |    2 
 net/ipv4/netfilter/nf_log_arp.c                             |    2 
 net/ipv6/netfilter/nf_log_ipv6.c                            |    2 
 net/irda/irnet/irnet_ppp.c                                  |   12 -
 net/l2tp/l2tp_core.c                                        |    4 
 net/netfilter/ipvs/ip_vs_conn.c                             |    2 
 net/netfilter/ipvs/ip_vs_dh.c                               |    4 
 net/netfilter/ipvs/ip_vs_lblc.c                             |    4 
 net/netfilter/ipvs/ip_vs_lblcr.c                            |    4 
 net/netfilter/ipvs/ip_vs_sh.c                               |    4 
 net/netfilter/ipvs/ip_vs_sync.c                             |    2 
 net/netfilter/nf_conntrack_ftp.c                            |    2 
 net/sctp/output.c                                           |    2 
 net/sunrpc/auth_gss/auth_gss.c                              |    2 
 net/sunrpc/svc.c                                            |    2 
 net/sunrpc/svcsock.c                                        |    4 
 net/sunrpc/xprtsock.c                                       |    8 -
 security/selinux/ss/ebitmap.c                               |    2 
 security/selinux/ss/policydb.c                              |    2 
 sound/pci/korg1212/korg1212.c                               |    4 
 sound/pci/pcxhr/pcxhr_hwdep.c                               |    2 
 sound/pcmcia/vx/vxp_ops.c                                   |    2 
 sound/soc/soc-core.c                                        |    2 
 79 files changed, 187 insertions(+), 201 deletions(-)

diff -puN block/bsg.c~lib-vsprintfc-remove-%z-support block/bsg.c
--- a/block/bsg.c~lib-vsprintfc-remove-%z-support
+++ a/block/bsg.c
@@ -573,7 +573,7 @@ bsg_read(struct file *file, char __user
 	int ret;
 	ssize_t bytes_read;
 
-	dprintk("%s: read %Zd bytes\n", bd->name, count);
+	dprintk("%s: read %zd bytes\n", bd->name, count);
 
 	bsg_set_block(bd, file);
 
@@ -648,7 +648,7 @@ bsg_write(struct file *file, const char
 	ssize_t bytes_written;
 	int ret;
 
-	dprintk("%s: write %Zd bytes\n", bd->name, count);
+	dprintk("%s: write %zd bytes\n", bd->name, count);
 
 	if (unlikely(segment_eq(get_fs(), KERNEL_DS)))
 		return -EINVAL;
@@ -667,7 +667,7 @@ bsg_write(struct file *file, const char
 	if (!bytes_written || err_block_err(ret))
 		bytes_written = ret;
 
-	dprintk("%s: returning %Zd\n", bd->name, bytes_written);
+	dprintk("%s: returning %zd\n", bd->name, bytes_written);
 	return bytes_written;
 }
 
diff -puN drivers/atm/ambassador.c~lib-vsprintfc-remove-%z-support drivers/atm/ambassador.c
--- a/drivers/atm/ambassador.c~lib-vsprintfc-remove-%z-support
+++ a/drivers/atm/ambassador.c
@@ -2394,12 +2394,7 @@ static int __init amb_module_init (void)
 {
   PRINTD (DBG_FLOW|DBG_INIT, "init_module");
   
-  // sanity check - cast needed as printk does not support %Zu
-  if (sizeof(amb_mem) != 4*16 + 4*12) {
-    PRINTK (KERN_ERR, "Fix amb_mem (is %lu words).",
-	    (unsigned long) sizeof(amb_mem));
-    return -ENOMEM;
-  }
+  BUILD_BUG_ON(sizeof(amb_mem) != 4*16 + 4*12);
   
   show_version();
   
diff -puN drivers/atm/eni.c~lib-vsprintfc-remove-%z-support drivers/atm/eni.c
--- a/drivers/atm/eni.c~lib-vsprintfc-remove-%z-support
+++ a/drivers/atm/eni.c
@@ -2326,11 +2326,7 @@ static int __init eni_init(void)
 {
 	struct sk_buff *skb; /* dummy for sizeof */
 
-	if (sizeof(skb->cb) < sizeof(struct eni_skb_prv)) {
-		printk(KERN_ERR "eni_detect: skb->cb is too small (%Zd < %Zd)\n",
-		    sizeof(skb->cb),sizeof(struct eni_skb_prv));
-		return -EIO;
-	}
+	BUILD_BUG_ON(sizeof(skb->cb) < sizeof(struct eni_skb_prv));
 	return pci_register_driver(&eni_driver);
 }
 
diff -puN drivers/atm/firestream.c~lib-vsprintfc-remove-%z-support drivers/atm/firestream.c
--- a/drivers/atm/firestream.c~lib-vsprintfc-remove-%z-support
+++ a/drivers/atm/firestream.c
@@ -895,7 +895,7 @@ static int fs_open(struct atm_vcc *atm_v
 	/* XXX handle qos parameters (rate limiting) ? */
 
 	vcc = kmalloc(sizeof(struct fs_vcc), GFP_KERNEL);
-	fs_dprintk (FS_DEBUG_ALLOC, "Alloc VCC: %p(%Zd)\n", vcc, sizeof(struct fs_vcc));
+	fs_dprintk (FS_DEBUG_ALLOC, "Alloc VCC: %p(%zd)\n", vcc, sizeof(struct fs_vcc));
 	if (!vcc) {
 		clear_bit(ATM_VF_ADDR, &atm_vcc->flags);
 		return -ENOMEM;
@@ -946,7 +946,7 @@ static int fs_open(struct atm_vcc *atm_v
 
 	if (DO_DIRECTION (txtp)) {
 		tc = kmalloc (sizeof (struct fs_transmit_config), GFP_KERNEL);
-		fs_dprintk (FS_DEBUG_ALLOC, "Alloc tc: %p(%Zd)\n",
+		fs_dprintk (FS_DEBUG_ALLOC, "Alloc tc: %p(%zd)\n",
 			    tc, sizeof (struct fs_transmit_config));
 		if (!tc) {
 			fs_dprintk (FS_DEBUG_OPEN, "fs: can't alloc transmit_config.\n");
@@ -1185,7 +1185,7 @@ static int fs_send (struct atm_vcc *atm_
 	vcc->last_skb = skb;
 
 	td = kmalloc (sizeof (struct FS_BPENTRY), GFP_ATOMIC);
-	fs_dprintk (FS_DEBUG_ALLOC, "Alloc transd: %p(%Zd)\n", td, sizeof (struct FS_BPENTRY));
+	fs_dprintk (FS_DEBUG_ALLOC, "Alloc transd: %p(%zd)\n", td, sizeof (struct FS_BPENTRY));
 	if (!td) {
 		/* Oops out of mem */
 		return -ENOMEM;
@@ -1492,7 +1492,7 @@ static void top_off_fp (struct fs_dev *d
 		fs_dprintk (FS_DEBUG_ALLOC, "Alloc rec-skb: %p(%d)\n", skb, fp->bufsize);
 		if (!skb) break;
 		ne = kmalloc (sizeof (struct FS_BPENTRY), gfp_flags);
-		fs_dprintk (FS_DEBUG_ALLOC, "Alloc rec-d: %p(%Zd)\n", ne, sizeof (struct FS_BPENTRY));
+		fs_dprintk (FS_DEBUG_ALLOC, "Alloc rec-d: %p(%zd)\n", ne, sizeof (struct FS_BPENTRY));
 		if (!ne) {
 			fs_dprintk (FS_DEBUG_ALLOC, "Free rec-skb: %p\n", skb);
 			dev_kfree_skb_any (skb);
@@ -1803,7 +1803,7 @@ static int fs_init(struct fs_dev *dev)
 	}
 	dev->atm_vccs = kcalloc (dev->nchannels, sizeof (struct atm_vcc *),
 				 GFP_KERNEL);
-	fs_dprintk (FS_DEBUG_ALLOC, "Alloc atmvccs: %p(%Zd)\n",
+	fs_dprintk (FS_DEBUG_ALLOC, "Alloc atmvccs: %p(%zd)\n",
 		    dev->atm_vccs, dev->nchannels * sizeof (struct atm_vcc *));
 
 	if (!dev->atm_vccs) {
@@ -1911,7 +1911,7 @@ static int firestream_init_one(struct pc
 		goto err_out;
 
 	fs_dev = kzalloc (sizeof (struct fs_dev), GFP_KERNEL);
-	fs_dprintk (FS_DEBUG_ALLOC, "Alloc fs-dev: %p(%Zd)\n",
+	fs_dprintk (FS_DEBUG_ALLOC, "Alloc fs-dev: %p(%zd)\n",
 		    fs_dev, sizeof (struct fs_dev));
 	if (!fs_dev)
 		goto err_out;
diff -puN drivers/atm/horizon.c~lib-vsprintfc-remove-%z-support drivers/atm/horizon.c
--- a/drivers/atm/horizon.c~lib-vsprintfc-remove-%z-support
+++ a/drivers/atm/horizon.c
@@ -2884,12 +2884,7 @@ static struct pci_driver hrz_driver = {
 /********** module entry **********/
 
 static int __init hrz_module_init (void) {
-  // sanity check - cast is needed since printk does not support %Zu
-  if (sizeof(struct MEMMAP) != 128*1024/4) {
-    PRINTK (KERN_ERR, "Fix struct MEMMAP (is %lu fakewords).",
-	    (unsigned long) sizeof(struct MEMMAP));
-    return -ENOMEM;
-  }
+  BUILD_BUG_ON(sizeof(struct MEMMAP) != 128*1024/4);
   
   show_version();
   
diff -puN drivers/atm/lanai.c~lib-vsprintfc-remove-%z-support drivers/atm/lanai.c
--- a/drivers/atm/lanai.c~lib-vsprintfc-remove-%z-support
+++ a/drivers/atm/lanai.c
@@ -1389,7 +1389,7 @@ static void vcc_rx_aal5(struct lanai_vcc
 	if (n < 0)
 		n += lanai_buf_size(&lvcc->rx.buf);
 	APRINTK(n >= 0 && n < lanai_buf_size(&lvcc->rx.buf) && !(n & 15),
-	    "vcc_rx_aal5: n out of range (%d/%Zu)\n",
+	    "vcc_rx_aal5: n out of range (%d/%zu)\n",
 	    n, lanai_buf_size(&lvcc->rx.buf));
 	/* Recover the second-to-last word to get true pdu length */
 	if ((x = &end[-2]) < lvcc->rx.buf.start)
@@ -1493,9 +1493,9 @@ static int lanai_get_sized_buffer(struct
 		return -ENOMEM;
 	if (unlikely(lanai_buf_size(buf) < size))
 		printk(KERN_WARNING DEV_LABEL "(itf %d): wanted %d bytes "
-		    "for %s buffer, got only %Zu\n", lanai->number, size,
+		    "for %s buffer, got only %zu\n", lanai->number, size,
 		    name, lanai_buf_size(buf));
-	DPRINTK("Allocated %Zu byte %s buffer\n", lanai_buf_size(buf), name);
+	DPRINTK("Allocated %zu byte %s buffer\n", lanai_buf_size(buf), name);
 	return 0;
 }
 
@@ -1586,7 +1586,7 @@ static int service_buffer_allocate(struc
 	    lanai->pci);
 	if (unlikely(lanai->service.start == NULL))
 		return -ENOMEM;
-	DPRINTK("allocated service buffer at 0x%08lX, size %Zu(%d)\n",
+	DPRINTK("allocated service buffer at 0x%08lX, size %zu(%d)\n",
 	    (unsigned long) lanai->service.start,
 	    lanai_buf_size(&lanai->service),
 	    lanai_buf_size_cardorder(&lanai->service));
@@ -2467,8 +2467,8 @@ static int lanai_proc_read(struct atm_de
 		    (lanai->status & STATUS_LED) ? 1 : 0,
 		    (lanai->status & STATUS_GPIN) ? 1 : 0);
 	if (left-- == 0)
-		return sprintf(page, "global buffer sizes: service=%Zu, "
-		    "aal0_rx=%Zu\n", lanai_buf_size(&lanai->service),
+		return sprintf(page, "global buffer sizes: service=%zu, "
+		    "aal0_rx=%zu\n", lanai_buf_size(&lanai->service),
 		    lanai->naal0 ? lanai_buf_size(&lanai->aal0buf) : 0);
 	if (left-- == 0) {
 		get_statistics(lanai);
@@ -2513,7 +2513,7 @@ static int lanai_proc_read(struct atm_de
 		left += sprintf(&page[left], ",\n          rx_AAL=%d",
 		    lvcc->rx.atmvcc->qos.aal == ATM_AAL5 ? 5 : 0);
 		if (lvcc->rx.atmvcc->qos.aal == ATM_AAL5)
-			left += sprintf(&page[left], ", rx_buf_size=%Zu, "
+			left += sprintf(&page[left], ", rx_buf_size=%zu, "
 			    "rx_bad_len=%u,\n          rx_service_trash=%u, "
 			    "rx_service_stream=%u, rx_bad_crc=%u",
 			    lanai_buf_size(&lvcc->rx.buf),
@@ -2524,7 +2524,7 @@ static int lanai_proc_read(struct atm_de
 	}
 	if (lvcc->tx.atmvcc != NULL)
 		left += sprintf(&page[left], ",\n          tx_AAL=%d, "
-		    "tx_buf_size=%Zu, tx_qos=%cBR, tx_backlogged=%c",
+		    "tx_buf_size=%zu, tx_qos=%cBR, tx_backlogged=%c",
 		    lvcc->tx.atmvcc->qos.aal == ATM_AAL5 ? 5 : 0,
 		    lanai_buf_size(&lvcc->tx.buf),
 		    lvcc->tx.atmvcc == lanai->cbrvcc ? 'C' : 'U',
diff -puN drivers/char/pcmcia/cm4000_cs.c~lib-vsprintfc-remove-%z-support drivers/char/pcmcia/cm4000_cs.c
--- a/drivers/char/pcmcia/cm4000_cs.c~lib-vsprintfc-remove-%z-support
+++ a/drivers/char/pcmcia/cm4000_cs.c
@@ -1037,7 +1037,7 @@ release_io:
 	clear_bit(LOCK_IO, &dev->flags);
 	wake_up_interruptible(&dev->ioq);
 
-	DEBUGP(2, dev, "<- cmm_read returns: rc = %Zi\n",
+	DEBUGP(2, dev, "<- cmm_read returns: rc = %zi\n",
 	       (rc < 0 ? rc : count));
 	return rc < 0 ? rc : count;
 }
diff -puN drivers/char/pcmcia/cm4040_cs.c~lib-vsprintfc-remove-%z-support drivers/char/pcmcia/cm4040_cs.c
--- a/drivers/char/pcmcia/cm4040_cs.c~lib-vsprintfc-remove-%z-support
+++ a/drivers/char/pcmcia/cm4040_cs.c
@@ -331,7 +331,7 @@ static ssize_t cm4040_write(struct file
 	}
 
 	if ((count < 5) || (count > READ_WRITE_BUFFER_SIZE)) {
-		DEBUGP(2, dev, "<- cm4040_write buffersize=%Zd < 5\n", count);
+		DEBUGP(2, dev, "<- cm4040_write buffersize=%zd < 5\n", count);
 		return -EIO;
 	}
 
diff -puN drivers/gpu/drm/mga/mga_drv.h~lib-vsprintfc-remove-%z-support drivers/gpu/drm/mga/mga_drv.h
--- a/drivers/gpu/drm/mga/mga_drv.h~lib-vsprintfc-remove-%z-support
+++ a/drivers/gpu/drm/mga/mga_drv.h
@@ -266,7 +266,7 @@ do {									\
 do {									\
 	if (MGA_VERBOSE) {						\
 		DRM_INFO("BEGIN_DMA(%d)\n", (n));			\
-		DRM_INFO("   space=0x%x req=0x%Zx\n",			\
+		DRM_INFO("   space=0x%x req=0x%zx\n",			\
 			 dev_priv->prim.space, (n) * DMA_BLOCK_SIZE);	\
 	}								\
 	prim = dev_priv->prim.start;					\
@@ -313,7 +313,7 @@ do {									\
 #define DMA_WRITE(offset, val)						\
 do {									\
 	if (MGA_VERBOSE)						\
-		DRM_INFO("   DMA_WRITE( 0x%08x ) at 0x%04Zx\n",		\
+		DRM_INFO("   DMA_WRITE( 0x%08x ) at 0x%04zx\n",		\
 			 (u32)(val), write + (offset) * sizeof(u32));	\
 	*(volatile u32 *)(prim + write + (offset) * sizeof(u32)) = val;	\
 } while (0)
diff -puN drivers/ide/ide-acpi.c~lib-vsprintfc-remove-%z-support drivers/ide/ide-acpi.c
--- a/drivers/ide/ide-acpi.c~lib-vsprintfc-remove-%z-support
+++ a/drivers/ide/ide-acpi.c
@@ -447,7 +447,7 @@ void ide_acpi_get_timing(ide_hwif_t *hwi
 	memcpy(&hwif->acpidata->gtm, out_obj->buffer.pointer,
 	       sizeof(struct GTM_buffer));
 
-	DEBPRINT("_GTM info: ptr: 0x%p, len: 0x%x, exp.len: 0x%Zx\n",
+	DEBPRINT("_GTM info: ptr: 0x%p, len: 0x%x, exp.len: 0x%zx\n",
 		 out_obj->buffer.pointer, out_obj->buffer.length,
 		 sizeof(struct GTM_buffer));
 
diff -puN drivers/ide/ide-tape.c~lib-vsprintfc-remove-%z-support drivers/ide/ide-tape.c
--- a/drivers/ide/ide-tape.c~lib-vsprintfc-remove-%z-support
+++ a/drivers/ide/ide-tape.c
@@ -1136,7 +1136,7 @@ static ssize_t idetape_chrdev_read(struc
 	ssize_t ret = 0;
 	int rc;
 
-	ide_debug_log(IDE_DBG_FUNC, "count %Zd", count);
+	ide_debug_log(IDE_DBG_FUNC, "count %zd", count);
 
 	if (tape->chrdev_dir != IDETAPE_DIR_READ) {
 		if (test_bit(ilog2(IDE_AFLAG_DETECT_BS), &drive->atapi_flags))
@@ -1195,7 +1195,7 @@ static ssize_t idetape_chrdev_write(stru
 	if (tape->write_prot)
 		return -EACCES;
 
-	ide_debug_log(IDE_DBG_FUNC, "count %Zd", count);
+	ide_debug_log(IDE_DBG_FUNC, "count %zd", count);
 
 	/* Initialize write operation */
 	rc = idetape_init_rw(drive, IDETAPE_DIR_WRITE);
diff -puN drivers/input/touchscreen/cyttsp4_core.c~lib-vsprintfc-remove-%z-support drivers/input/touchscreen/cyttsp4_core.c
--- a/drivers/input/touchscreen/cyttsp4_core.c~lib-vsprintfc-remove-%z-support
+++ a/drivers/input/touchscreen/cyttsp4_core.c
@@ -202,7 +202,7 @@ static int cyttsp4_si_get_cydata(struct
 	int rc;
 
 	si->si_ofs.cydata_size = si->si_ofs.test_ofs - si->si_ofs.cydata_ofs;
-	dev_dbg(cd->dev, "%s: cydata size: %Zd\n", __func__,
+	dev_dbg(cd->dev, "%s: cydata size: %zd\n", __func__,
 			si->si_ofs.cydata_size);
 
 	p = krealloc(si->si_ptrs.cydata, si->si_ofs.cydata_size, GFP_KERNEL);
@@ -430,13 +430,13 @@ static int cyttsp4_si_get_opcfg_data(str
 	for (abs = 0; abs < CY_TCH_NUM_ABS; abs++) {
 		dev_dbg(cd->dev, "%s: tch_rec_%s\n", __func__,
 			cyttsp4_tch_abs_string[abs]);
-		dev_dbg(cd->dev, "%s:     ofs =%2Zd\n", __func__,
+		dev_dbg(cd->dev, "%s:     ofs =%2zd\n", __func__,
 			si->si_ofs.tch_abs[abs].ofs);
-		dev_dbg(cd->dev, "%s:     siz =%2Zd\n", __func__,
+		dev_dbg(cd->dev, "%s:     siz =%2zd\n", __func__,
 			si->si_ofs.tch_abs[abs].size);
-		dev_dbg(cd->dev, "%s:     max =%2Zd\n", __func__,
+		dev_dbg(cd->dev, "%s:     max =%2zd\n", __func__,
 			si->si_ofs.tch_abs[abs].max);
-		dev_dbg(cd->dev, "%s:     bofs=%2Zd\n", __func__,
+		dev_dbg(cd->dev, "%s:     bofs=%2zd\n", __func__,
 			si->si_ofs.tch_abs[abs].bofs);
 	}
 
@@ -586,62 +586,62 @@ static int cyttsp4_si_get_op_data_ptrs(s
 static void cyttsp4_si_put_log_data(struct cyttsp4 *cd)
 {
 	struct cyttsp4_sysinfo *si = &cd->sysinfo;
-	dev_dbg(cd->dev, "%s: cydata_ofs =%4Zd siz=%4Zd\n", __func__,
+	dev_dbg(cd->dev, "%s: cydata_ofs =%4zd siz=%4zd\n", __func__,
 		si->si_ofs.cydata_ofs, si->si_ofs.cydata_size);
-	dev_dbg(cd->dev, "%s: test_ofs   =%4Zd siz=%4Zd\n", __func__,
+	dev_dbg(cd->dev, "%s: test_ofs   =%4zd siz=%4zd\n", __func__,
 		si->si_ofs.test_ofs, si->si_ofs.test_size);
-	dev_dbg(cd->dev, "%s: pcfg_ofs   =%4Zd siz=%4Zd\n", __func__,
+	dev_dbg(cd->dev, "%s: pcfg_ofs   =%4zd siz=%4zd\n", __func__,
 		si->si_ofs.pcfg_ofs, si->si_ofs.pcfg_size);
-	dev_dbg(cd->dev, "%s: opcfg_ofs  =%4Zd siz=%4Zd\n", __func__,
+	dev_dbg(cd->dev, "%s: opcfg_ofs  =%4zd siz=%4zd\n", __func__,
 		si->si_ofs.opcfg_ofs, si->si_ofs.opcfg_size);
-	dev_dbg(cd->dev, "%s: ddata_ofs  =%4Zd siz=%4Zd\n", __func__,
+	dev_dbg(cd->dev, "%s: ddata_ofs  =%4zd siz=%4zd\n", __func__,
 		si->si_ofs.ddata_ofs, si->si_ofs.ddata_size);
-	dev_dbg(cd->dev, "%s: mdata_ofs  =%4Zd siz=%4Zd\n", __func__,
+	dev_dbg(cd->dev, "%s: mdata_ofs  =%4zd siz=%4zd\n", __func__,
 		si->si_ofs.mdata_ofs, si->si_ofs.mdata_size);
 
-	dev_dbg(cd->dev, "%s: cmd_ofs       =%4Zd\n", __func__,
+	dev_dbg(cd->dev, "%s: cmd_ofs       =%4zd\n", __func__,
 		si->si_ofs.cmd_ofs);
-	dev_dbg(cd->dev, "%s: rep_ofs       =%4Zd\n", __func__,
+	dev_dbg(cd->dev, "%s: rep_ofs       =%4zd\n", __func__,
 		si->si_ofs.rep_ofs);
-	dev_dbg(cd->dev, "%s: rep_sz        =%4Zd\n", __func__,
+	dev_dbg(cd->dev, "%s: rep_sz        =%4zd\n", __func__,
 		si->si_ofs.rep_sz);
-	dev_dbg(cd->dev, "%s: num_btns      =%4Zd\n", __func__,
+	dev_dbg(cd->dev, "%s: num_btns      =%4zd\n", __func__,
 		si->si_ofs.num_btns);
-	dev_dbg(cd->dev, "%s: num_btn_regs  =%4Zd\n", __func__,
+	dev_dbg(cd->dev, "%s: num_btn_regs  =%4zd\n", __func__,
 		si->si_ofs.num_btn_regs);
-	dev_dbg(cd->dev, "%s: tt_stat_ofs   =%4Zd\n", __func__,
+	dev_dbg(cd->dev, "%s: tt_stat_ofs   =%4zd\n", __func__,
 		si->si_ofs.tt_stat_ofs);
-	dev_dbg(cd->dev, "%s: tch_rec_size  =%4Zd\n", __func__,
+	dev_dbg(cd->dev, "%s: tch_rec_size  =%4zd\n", __func__,
 		si->si_ofs.tch_rec_size);
-	dev_dbg(cd->dev, "%s: max_tchs      =%4Zd\n", __func__,
+	dev_dbg(cd->dev, "%s: max_tchs      =%4zd\n", __func__,
 		si->si_ofs.max_tchs);
-	dev_dbg(cd->dev, "%s: mode_size     =%4Zd\n", __func__,
+	dev_dbg(cd->dev, "%s: mode_size     =%4zd\n", __func__,
 		si->si_ofs.mode_size);
-	dev_dbg(cd->dev, "%s: data_size     =%4Zd\n", __func__,
+	dev_dbg(cd->dev, "%s: data_size     =%4zd\n", __func__,
 		si->si_ofs.data_size);
-	dev_dbg(cd->dev, "%s: map_sz        =%4Zd\n", __func__,
+	dev_dbg(cd->dev, "%s: map_sz        =%4zd\n", __func__,
 		si->si_ofs.map_sz);
 
-	dev_dbg(cd->dev, "%s: btn_rec_size   =%2Zd\n", __func__,
+	dev_dbg(cd->dev, "%s: btn_rec_size   =%2zd\n", __func__,
 		si->si_ofs.btn_rec_size);
-	dev_dbg(cd->dev, "%s: btn_diff_ofs   =%2Zd\n", __func__,
+	dev_dbg(cd->dev, "%s: btn_diff_ofs   =%2zd\n", __func__,
 		si->si_ofs.btn_diff_ofs);
-	dev_dbg(cd->dev, "%s: btn_diff_size  =%2Zd\n", __func__,
+	dev_dbg(cd->dev, "%s: btn_diff_size  =%2zd\n", __func__,
 		si->si_ofs.btn_diff_size);
 
-	dev_dbg(cd->dev, "%s: max_x    = 0x%04ZX (%Zd)\n", __func__,
+	dev_dbg(cd->dev, "%s: max_x    = 0x%04zX (%zd)\n", __func__,
 		si->si_ofs.max_x, si->si_ofs.max_x);
-	dev_dbg(cd->dev, "%s: x_origin = %Zd (%s)\n", __func__,
+	dev_dbg(cd->dev, "%s: x_origin = %zd (%s)\n", __func__,
 		si->si_ofs.x_origin,
 		si->si_ofs.x_origin == CY_NORMAL_ORIGIN ?
 		"left corner" : "right corner");
-	dev_dbg(cd->dev, "%s: max_y    = 0x%04ZX (%Zd)\n", __func__,
+	dev_dbg(cd->dev, "%s: max_y    = 0x%04zX (%zd)\n", __func__,
 		si->si_ofs.max_y, si->si_ofs.max_y);
-	dev_dbg(cd->dev, "%s: y_origin = %Zd (%s)\n", __func__,
+	dev_dbg(cd->dev, "%s: y_origin = %zd (%s)\n", __func__,
 		si->si_ofs.y_origin,
 		si->si_ofs.y_origin == CY_NORMAL_ORIGIN ?
 		"upper corner" : "lower corner");
-	dev_dbg(cd->dev, "%s: max_p    = 0x%04ZX (%Zd)\n", __func__,
+	dev_dbg(cd->dev, "%s: max_p    = 0x%04zX (%zd)\n", __func__,
 		si->si_ofs.max_p, si->si_ofs.max_p);
 
 	dev_dbg(cd->dev, "%s: xy_mode=%p xy_data=%p\n", __func__,
@@ -1000,7 +1000,7 @@ static int cyttsp4_xy_worker(struct cytt
 		dev_dbg(dev, "%s: Large area detected\n", __func__);
 
 	if (num_cur_tch > si->si_ofs.max_tchs) {
-		dev_err(dev, "%s: too many tch; set to max tch (n=%d c=%Zd)\n",
+		dev_err(dev, "%s: too many tch; set to max tch (n=%d c=%zd)\n",
 				__func__, num_cur_tch, si->si_ofs.max_tchs);
 		num_cur_tch = si->si_ofs.max_tchs;
 	}
diff -puN drivers/media/dvb-frontends/helene.c~lib-vsprintfc-remove-%z-support drivers/media/dvb-frontends/helene.c
--- a/drivers/media/dvb-frontends/helene.c~lib-vsprintfc-remove-%z-support
+++ a/drivers/media/dvb-frontends/helene.c
@@ -309,7 +309,7 @@ static int helene_write_regs(struct hele
 
 	if (len + 1 > sizeof(buf)) {
 		dev_warn(&priv->i2c->dev,
-				"wr reg=%04x: len=%d vs %Zu is too big!\n",
+				"wr reg=%04x: len=%d vs %zu is too big!\n",
 				reg, len + 1, sizeof(buf));
 		return -E2BIG;
 	}
diff -puN drivers/media/dvb-frontends/or51132.c~lib-vsprintfc-remove-%z-support drivers/media/dvb-frontends/or51132.c
--- a/drivers/media/dvb-frontends/or51132.c~lib-vsprintfc-remove-%z-support
+++ a/drivers/media/dvb-frontends/or51132.c
@@ -133,7 +133,7 @@ static int or51132_load_firmware (struct
 	u32 firmwareAsize, firmwareBsize;
 	int i,ret;
 
-	dprintk("Firmware is %Zd bytes\n",fw->size);
+	dprintk("Firmware is %zd bytes\n",fw->size);
 
 	/* Get size of firmware A and B */
 	firmwareAsize = le32_to_cpu(*((__le32*)fw->data));
diff -puN drivers/media/dvb-frontends/tda10048.c~lib-vsprintfc-remove-%z-support drivers/media/dvb-frontends/tda10048.c
--- a/drivers/media/dvb-frontends/tda10048.c~lib-vsprintfc-remove-%z-support
+++ a/drivers/media/dvb-frontends/tda10048.c
@@ -499,7 +499,7 @@ static int tda10048_firmware_upload(stru
 			__func__);
 		return -EIO;
 	} else {
-		printk(KERN_INFO "%s: firmware read %Zu bytes.\n",
+		printk(KERN_INFO "%s: firmware read %zu bytes.\n",
 			__func__,
 			fw->size);
 		ret = 0;
diff -puN drivers/media/pci/saa7164/saa7164-fw.c~lib-vsprintfc-remove-%z-support drivers/media/pci/saa7164/saa7164-fw.c
--- a/drivers/media/pci/saa7164/saa7164-fw.c~lib-vsprintfc-remove-%z-support
+++ a/drivers/media/pci/saa7164/saa7164-fw.c
@@ -422,7 +422,7 @@ int saa7164_downloadfirmware(struct saa7
 			return -ENOMEM;
 		}
 
-		printk(KERN_INFO "%s() firmware read %Zu bytes.\n",
+		printk(KERN_INFO "%s() firmware read %zu bytes.\n",
 			__func__, fw->size);
 
 		if (fw->size != fwlength) {
diff -puN drivers/media/tuners/xc5000.c~lib-vsprintfc-remove-%z-support drivers/media/tuners/xc5000.c
--- a/drivers/media/tuners/xc5000.c~lib-vsprintfc-remove-%z-support
+++ a/drivers/media/tuners/xc5000.c
@@ -1144,7 +1144,7 @@ static int xc_load_fw_and_init_tuner(str
 			pr_err("xc5000: Upload failed. rc %d\n", ret);
 			return ret;
 		}
-		dprintk(1, "firmware read %Zu bytes.\n", fw->size);
+		dprintk(1, "firmware read %zu bytes.\n", fw->size);
 
 		if (fw->size != desired_fw->size) {
 			pr_err("xc5000: Firmware file with incorrect size\n");
diff -puN drivers/media/usb/dvb-usb/dib0700_devices.c~lib-vsprintfc-remove-%z-support drivers/media/usb/dvb-usb/dib0700_devices.c
--- a/drivers/media/usb/dvb-usb/dib0700_devices.c~lib-vsprintfc-remove-%z-support
+++ a/drivers/media/usb/dvb-usb/dib0700_devices.c
@@ -2414,7 +2414,7 @@ static int stk9090m_frontend_attach(stru
 		deb_info("%s: Upload failed. (file not found?)\n", __func__);
 		return -ENODEV;
 	} else {
-		deb_info("%s: firmware read %Zu bytes.\n", __func__, state->frontend_firmware->size);
+		deb_info("%s: firmware read %zu bytes.\n", __func__, state->frontend_firmware->size);
 	}
 	stk9090m_config.microcode_B_fe_size = state->frontend_firmware->size;
 	stk9090m_config.microcode_B_fe_buffer = state->frontend_firmware->data;
@@ -2480,7 +2480,7 @@ static int nim9090md_frontend_attach(str
 		deb_info("%s: Upload failed. (file not found?)\n", __func__);
 		return -EIO;
 	} else {
-		deb_info("%s: firmware read %Zu bytes.\n", __func__, state->frontend_firmware->size);
+		deb_info("%s: firmware read %zu bytes.\n", __func__, state->frontend_firmware->size);
 	}
 	nim9090md_config[0].microcode_B_fe_size = state->frontend_firmware->size;
 	nim9090md_config[0].microcode_B_fe_buffer = state->frontend_firmware->data;
diff -puN drivers/misc/vmw_vmci/vmci_context.c~lib-vsprintfc-remove-%z-support drivers/misc/vmw_vmci/vmci_context.c
--- a/drivers/misc/vmw_vmci/vmci_context.c~lib-vsprintfc-remove-%z-support
+++ a/drivers/misc/vmw_vmci/vmci_context.c
@@ -303,7 +303,7 @@ int vmci_ctx_enqueue_datagram(u32 cid, s
 
 	vmci_dg_size = VMCI_DG_SIZE(dg);
 	if (vmci_dg_size > VMCI_MAX_DG_SIZE) {
-		pr_devel("Datagram too large (bytes=%Zu)\n", vmci_dg_size);
+		pr_devel("Datagram too large (bytes=%zu)\n", vmci_dg_size);
 		return VMCI_ERROR_INVALID_ARGS;
 	}
 
diff -puN drivers/net/arcnet/arcnet.c~lib-vsprintfc-remove-%z-support drivers/net/arcnet/arcnet.c
--- a/drivers/net/arcnet/arcnet.c~lib-vsprintfc-remove-%z-support
+++ a/drivers/net/arcnet/arcnet.c
@@ -123,7 +123,7 @@ static int __init arcnet_init(void)
 		arc_proto_map[count] = arc_proto_default;
 
 	if (BUGLVL(D_DURING))
-		pr_info("struct sizes: %Zd %Zd %Zd %Zd %Zd\n",
+		pr_info("struct sizes: %zd %zd %zd %zd %zd\n",
 			sizeof(struct arc_hardware),
 			sizeof(struct arc_rfc1201),
 			sizeof(struct arc_rfc1051),
diff -puN drivers/net/ethernet/cadence/macb.c~lib-vsprintfc-remove-%z-support drivers/net/ethernet/cadence/macb.c
--- a/drivers/net/ethernet/cadence/macb.c~lib-vsprintfc-remove-%z-support
+++ a/drivers/net/ethernet/cadence/macb.c
@@ -1622,7 +1622,7 @@ static void macb_init_rx_buffer_size(str
 		}
 	}
 
-	netdev_dbg(bp->dev, "mtu [%u] rx_buffer_size [%Zu]\n",
+	netdev_dbg(bp->dev, "mtu [%u] rx_buffer_size [%zu]\n",
 		   bp->dev->mtu, bp->rx_buffer_size);
 }
 
diff -puN drivers/net/gtp.c~lib-vsprintfc-remove-%z-support drivers/net/gtp.c
--- a/drivers/net/gtp.c~lib-vsprintfc-remove-%z-support
+++ a/drivers/net/gtp.c
@@ -1330,7 +1330,7 @@ static int __init gtp_init(void)
 	if (err < 0)
 		goto unreg_genl_family;
 
-	pr_info("GTP module loaded (pdp ctx size %Zd bytes)\n",
+	pr_info("GTP module loaded (pdp ctx size %zd bytes)\n",
 		sizeof(struct pdp_ctx));
 	return 0;
 
diff -puN drivers/net/usb/rndis_host.c~lib-vsprintfc-remove-%z-support drivers/net/usb/rndis_host.c
--- a/drivers/net/usb/rndis_host.c~lib-vsprintfc-remove-%z-support
+++ a/drivers/net/usb/rndis_host.c
@@ -383,7 +383,7 @@ generic_rndis_bind(struct usbnet *dev, s
 
 	/* REVISIT:  peripheral "alignment" request is ignored ... */
 	dev_dbg(&intf->dev,
-		"hard mtu %u (%u from dev), rx buflen %Zu, align %d\n",
+		"hard mtu %u (%u from dev), rx buflen %zu, align %d\n",
 		dev->hard_mtu, tmp, dev->rx_urb_size,
 		1 << le32_to_cpu(u.init_c->packet_alignment));
 
diff -puN drivers/net/usb/sierra_net.c~lib-vsprintfc-remove-%z-support drivers/net/usb/sierra_net.c
--- a/drivers/net/usb/sierra_net.c~lib-vsprintfc-remove-%z-support
+++ a/drivers/net/usb/sierra_net.c
@@ -379,7 +379,7 @@ static int sierra_net_parse_lsi(struct u
 	u32 expected_length;
 
 	if (datalen < sizeof(struct lsi_umts_single)) {
-		netdev_err(dev->net, "%s: Data length %d, exp >= %Zu\n",
+		netdev_err(dev->net, "%s: Data length %d, exp >= %zu\n",
 			   __func__, datalen, sizeof(struct lsi_umts_single));
 		return -1;
 	}
diff -puN drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c~lib-vsprintfc-remove-%z-support drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c~lib-vsprintfc-remove-%z-support
+++ a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -4874,7 +4874,7 @@ brcmf_cfg80211_mgmt_tx(struct wiphy *wip
 		kfree(af_params);
 	} else {
 		brcmf_dbg(TRACE, "Unhandled, fc=%04x!!\n", mgmt->frame_control);
-		brcmf_dbg_hex_dump(true, buf, len, "payload, len=%Zu\n", len);
+		brcmf_dbg_hex_dump(true, buf, len, "payload, len=%zu\n", len);
 	}
 
 exit:
diff -puN drivers/net/wireless/intel/iwlegacy/4965-mac.c~lib-vsprintfc-remove-%z-support drivers/net/wireless/intel/iwlegacy/4965-mac.c
--- a/drivers/net/wireless/intel/iwlegacy/4965-mac.c~lib-vsprintfc-remove-%z-support
+++ a/drivers/net/wireless/intel/iwlegacy/4965-mac.c
@@ -4855,39 +4855,39 @@ il4965_ucode_callback(const struct firmw
 	 */
 
 	D_INFO("f/w package hdr ucode version raw = 0x%x\n", il->ucode_ver);
-	D_INFO("f/w package hdr runtime inst size = %Zd\n", pieces.inst_size);
-	D_INFO("f/w package hdr runtime data size = %Zd\n", pieces.data_size);
-	D_INFO("f/w package hdr init inst size = %Zd\n", pieces.init_size);
-	D_INFO("f/w package hdr init data size = %Zd\n", pieces.init_data_size);
-	D_INFO("f/w package hdr boot inst size = %Zd\n", pieces.boot_size);
+	D_INFO("f/w package hdr runtime inst size = %zd\n", pieces.inst_size);
+	D_INFO("f/w package hdr runtime data size = %zd\n", pieces.data_size);
+	D_INFO("f/w package hdr init inst size = %zd\n", pieces.init_size);
+	D_INFO("f/w package hdr init data size = %zd\n", pieces.init_data_size);
+	D_INFO("f/w package hdr boot inst size = %zd\n", pieces.boot_size);
 
 	/* Verify that uCode images will fit in card's SRAM */
 	if (pieces.inst_size > il->hw_params.max_inst_size) {
-		IL_ERR("uCode instr len %Zd too large to fit in\n",
+		IL_ERR("uCode instr len %zd too large to fit in\n",
 		       pieces.inst_size);
 		goto try_again;
 	}
 
 	if (pieces.data_size > il->hw_params.max_data_size) {
-		IL_ERR("uCode data len %Zd too large to fit in\n",
+		IL_ERR("uCode data len %zd too large to fit in\n",
 		       pieces.data_size);
 		goto try_again;
 	}
 
 	if (pieces.init_size > il->hw_params.max_inst_size) {
-		IL_ERR("uCode init instr len %Zd too large to fit in\n",
+		IL_ERR("uCode init instr len %zd too large to fit in\n",
 		       pieces.init_size);
 		goto try_again;
 	}
 
 	if (pieces.init_data_size > il->hw_params.max_data_size) {
-		IL_ERR("uCode init data len %Zd too large to fit in\n",
+		IL_ERR("uCode init data len %zd too large to fit in\n",
 		       pieces.init_data_size);
 		goto try_again;
 	}
 
 	if (pieces.boot_size > il->hw_params.max_bsm_size) {
-		IL_ERR("uCode boot instr len %Zd too large to fit in\n",
+		IL_ERR("uCode boot instr len %zd too large to fit in\n",
 		       pieces.boot_size);
 		goto try_again;
 	}
@@ -4938,7 +4938,7 @@ il4965_ucode_callback(const struct firmw
 	/* Copy images into buffers for card's bus-master reads ... */
 
 	/* Runtime instructions (first block of data in file) */
-	D_INFO("Copying (but not loading) uCode instr len %Zd\n",
+	D_INFO("Copying (but not loading) uCode instr len %zd\n",
 	       pieces.inst_size);
 	memcpy(il->ucode_code.v_addr, pieces.inst, pieces.inst_size);
 
@@ -4949,28 +4949,28 @@ il4965_ucode_callback(const struct firmw
 	 * Runtime data
 	 * NOTE:  Copy into backup buffer will be done in il_up()
 	 */
-	D_INFO("Copying (but not loading) uCode data len %Zd\n",
+	D_INFO("Copying (but not loading) uCode data len %zd\n",
 	       pieces.data_size);
 	memcpy(il->ucode_data.v_addr, pieces.data, pieces.data_size);
 	memcpy(il->ucode_data_backup.v_addr, pieces.data, pieces.data_size);
 
 	/* Initialization instructions */
 	if (pieces.init_size) {
-		D_INFO("Copying (but not loading) init instr len %Zd\n",
+		D_INFO("Copying (but not loading) init instr len %zd\n",
 		       pieces.init_size);
 		memcpy(il->ucode_init.v_addr, pieces.init, pieces.init_size);
 	}
 
 	/* Initialization data */
 	if (pieces.init_data_size) {
-		D_INFO("Copying (but not loading) init data len %Zd\n",
+		D_INFO("Copying (but not loading) init data len %zd\n",
 		       pieces.init_data_size);
 		memcpy(il->ucode_init_data.v_addr, pieces.init_data,
 		       pieces.init_data_size);
 	}
 
 	/* Bootstrap instructions */
-	D_INFO("Copying (but not loading) boot instr len %Zd\n",
+	D_INFO("Copying (but not loading) boot instr len %zd\n",
 	       pieces.boot_size);
 	memcpy(il->ucode_boot.v_addr, pieces.boot, pieces.boot_size);
 
diff -puN drivers/net/wireless/intel/iwlwifi/iwl-drv.c~lib-vsprintfc-remove-%z-support drivers/net/wireless/intel/iwlwifi/iwl-drv.c
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c~lib-vsprintfc-remove-%z-support
+++ a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1141,21 +1141,21 @@ static int validate_sec_sizes(struct iwl
 			      struct iwl_firmware_pieces *pieces,
 			      const struct iwl_cfg *cfg)
 {
-	IWL_DEBUG_INFO(drv, "f/w package hdr runtime inst size = %Zd\n",
+	IWL_DEBUG_INFO(drv, "f/w package hdr runtime inst size = %zd\n",
 		get_sec_size(pieces, IWL_UCODE_REGULAR,
 			     IWL_UCODE_SECTION_INST));
-	IWL_DEBUG_INFO(drv, "f/w package hdr runtime data size = %Zd\n",
+	IWL_DEBUG_INFO(drv, "f/w package hdr runtime data size = %zd\n",
 		get_sec_size(pieces, IWL_UCODE_REGULAR,
 			     IWL_UCODE_SECTION_DATA));
-	IWL_DEBUG_INFO(drv, "f/w package hdr init inst size = %Zd\n",
+	IWL_DEBUG_INFO(drv, "f/w package hdr init inst size = %zd\n",
 		get_sec_size(pieces, IWL_UCODE_INIT, IWL_UCODE_SECTION_INST));
-	IWL_DEBUG_INFO(drv, "f/w package hdr init data size = %Zd\n",
+	IWL_DEBUG_INFO(drv, "f/w package hdr init data size = %zd\n",
 		get_sec_size(pieces, IWL_UCODE_INIT, IWL_UCODE_SECTION_DATA));
 
 	/* Verify that uCode images will fit in card's SRAM. */
 	if (get_sec_size(pieces, IWL_UCODE_REGULAR, IWL_UCODE_SECTION_INST) >
 	    cfg->max_inst_size) {
-		IWL_ERR(drv, "uCode instr len %Zd too large to fit in\n",
+		IWL_ERR(drv, "uCode instr len %zd too large to fit in\n",
 			get_sec_size(pieces, IWL_UCODE_REGULAR,
 				     IWL_UCODE_SECTION_INST));
 		return -1;
@@ -1163,7 +1163,7 @@ static int validate_sec_sizes(struct iwl
 
 	if (get_sec_size(pieces, IWL_UCODE_REGULAR, IWL_UCODE_SECTION_DATA) >
 	    cfg->max_data_size) {
-		IWL_ERR(drv, "uCode data len %Zd too large to fit in\n",
+		IWL_ERR(drv, "uCode data len %zd too large to fit in\n",
 			get_sec_size(pieces, IWL_UCODE_REGULAR,
 				     IWL_UCODE_SECTION_DATA));
 		return -1;
@@ -1171,7 +1171,7 @@ static int validate_sec_sizes(struct iwl
 
 	if (get_sec_size(pieces, IWL_UCODE_INIT, IWL_UCODE_SECTION_INST) >
 	     cfg->max_inst_size) {
-		IWL_ERR(drv, "uCode init instr len %Zd too large to fit in\n",
+		IWL_ERR(drv, "uCode init instr len %zd too large to fit in\n",
 			get_sec_size(pieces, IWL_UCODE_INIT,
 				     IWL_UCODE_SECTION_INST));
 		return -1;
@@ -1179,7 +1179,7 @@ static int validate_sec_sizes(struct iwl
 
 	if (get_sec_size(pieces, IWL_UCODE_INIT, IWL_UCODE_SECTION_DATA) >
 	    cfg->max_data_size) {
-		IWL_ERR(drv, "uCode init data len %Zd too large to fit in\n",
+		IWL_ERR(drv, "uCode init data len %zd too large to fit in\n",
 			get_sec_size(pieces, IWL_UCODE_REGULAR,
 				     IWL_UCODE_SECTION_DATA));
 		return -1;
diff -puN drivers/parport/ieee1284_ops.c~lib-vsprintfc-remove-%z-support drivers/parport/ieee1284_ops.c
--- a/drivers/parport/ieee1284_ops.c~lib-vsprintfc-remove-%z-support
+++ a/drivers/parport/ieee1284_ops.c
@@ -307,7 +307,7 @@ size_t parport_ieee1284_read_byte (struc
 		if (parport_read_status (port) & PARPORT_STATUS_ERROR) {
 		end_of_data:
 			DPRINTK (KERN_DEBUG
-				 "%s: No more byte data (%Zd bytes)\n",
+				 "%s: No more byte data (%zd bytes)\n",
 				 port->name, count);
 
 			/* Go to reverse idle phase. */
diff -puN drivers/scsi/osd/osd_initiator.c~lib-vsprintfc-remove-%z-support drivers/scsi/osd/osd_initiator.c
--- a/drivers/scsi/osd/osd_initiator.c~lib-vsprintfc-remove-%z-support
+++ a/drivers/scsi/osd/osd_initiator.c
@@ -1290,7 +1290,7 @@ int osd_req_add_get_attr_list(struct osd
 	or->enc_get_attr.total_bytes = total_bytes;
 
 	OSD_DEBUG(
-	       "get_attr.total_bytes=%u(%u) enc_get_attr.total_bytes=%u(%Zu)\n",
+	       "get_attr.total_bytes=%u(%u) enc_get_attr.total_bytes=%u(%zu)\n",
 	       or->get_attr.total_bytes,
 	       or->get_attr.total_bytes - _osd_req_sizeof_alist_header(or),
 	       or->enc_get_attr.total_bytes,
diff -puN drivers/scsi/osst.c~lib-vsprintfc-remove-%z-support drivers/scsi/osst.c
--- a/drivers/scsi/osst.c~lib-vsprintfc-remove-%z-support
+++ a/drivers/scsi/osst.c
@@ -3435,7 +3435,7 @@ static ssize_t osst_write(struct file *
 
 	/* Write must be integral number of blocks */
 	if (STp->block_size != 0 && (count % STp->block_size) != 0) {
-		printk(KERN_ERR "%s:E: Write (%Zd bytes) not multiple of tape block size (%d%c).\n",
+		printk(KERN_ERR "%s:E: Write (%zd bytes) not multiple of tape block size (%d%c).\n",
 				       name, count, STp->block_size<1024?
 				       STp->block_size:STp->block_size/1024, STp->block_size<1024?'b':'k');
 		retval = (-EINVAL);
@@ -3756,7 +3756,7 @@ static ssize_t osst_read(struct file * f
 
 	if ((count % STp->block_size) != 0) {
 		printk(KERN_WARNING
-		    "%s:W: Read (%Zd bytes) not multiple of tape block size (%d%c).\n", name, count,
+		    "%s:W: Read (%zd bytes) not multiple of tape block size (%d%c).\n", name, count,
 		    STp->block_size<1024?STp->block_size:STp->block_size/1024, STp->block_size<1024?'b':'k');
 	}
 
@@ -3815,7 +3815,7 @@ static ssize_t osst_read(struct file * f
 
 			if (transfer == 0) {
 				printk(KERN_WARNING
-				  "%s:W: Nothing can be transferred, requested %Zd, tape block size (%d%c).\n",
+				  "%s:W: Nothing can be transferred, requested %zd, tape block size (%d%c).\n",
 			   		name, count, STp->block_size < 1024?
 					STp->block_size:STp->block_size/1024,
 				       	STp->block_size<1024?'b':'k');
diff -puN drivers/scsi/qla2xxx/qla_init.c~lib-vsprintfc-remove-%z-support drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c~lib-vsprintfc-remove-%z-support
+++ a/drivers/scsi/qla2xxx/qla_init.c
@@ -5669,7 +5669,7 @@ qla2x00_load_risc(scsi_qla_host_t *vha,
 	/* Validate firmware image by checking version. */
 	if (blob->fw->size < 8 * sizeof(uint16_t)) {
 		ql_log(ql_log_fatal, vha, 0x0085,
-		    "Unable to verify integrity of firmware image (%Zd).\n",
+		    "Unable to verify integrity of firmware image (%zd).\n",
 		    blob->fw->size);
 		goto fail_fw_integrity;
 	}
@@ -5697,7 +5697,7 @@ qla2x00_load_risc(scsi_qla_host_t *vha,
 		if (blob->fw->size < fwclen) {
 			ql_log(ql_log_fatal, vha, 0x0088,
 			    "Unable to verify integrity of firmware image "
-			    "(%Zd).\n", blob->fw->size);
+			    "(%zd).\n", blob->fw->size);
 			goto fail_fw_integrity;
 		}
 
@@ -5778,7 +5778,7 @@ qla24xx_load_risc_blob(scsi_qla_host_t *
 	/* Validate firmware image by checking version. */
 	if (blob->fw->size < 8 * sizeof(uint32_t)) {
 		ql_log(ql_log_fatal, vha, 0x0093,
-		    "Unable to verify integrity of firmware image (%Zd).\n",
+		    "Unable to verify integrity of firmware image (%zd).\n",
 		    blob->fw->size);
 		return QLA_FUNCTION_FAILED;
 	}
@@ -5789,7 +5789,7 @@ qla24xx_load_risc_blob(scsi_qla_host_t *
 	    (dcode[0] == 0 && dcode[1] == 0 && dcode[2] == 0 &&
 		dcode[3] == 0)) {
 		ql_log(ql_log_fatal, vha, 0x0094,
-		    "Unable to verify integrity of firmware image (%Zd).\n",
+		    "Unable to verify integrity of firmware image (%zd).\n",
 		    blob->fw->size);
 		ql_log(ql_log_fatal, vha, 0x0095,
 		    "Firmware data: %08x %08x %08x %08x.\n",
@@ -5807,7 +5807,7 @@ qla24xx_load_risc_blob(scsi_qla_host_t *
 		if (blob->fw->size < fwclen) {
 			ql_log(ql_log_fatal, vha, 0x0096,
 			    "Unable to verify integrity of firmware image "
-			    "(%Zd).\n", blob->fw->size);
+			    "(%zd).\n", blob->fw->size);
 			return QLA_FUNCTION_FAILED;
 		}
 
diff -puN drivers/tty/n_hdlc.c~lib-vsprintfc-remove-%z-support drivers/tty/n_hdlc.c
--- a/drivers/tty/n_hdlc.c~lib-vsprintfc-remove-%z-support
+++ a/drivers/tty/n_hdlc.c
@@ -667,7 +667,7 @@ static ssize_t n_hdlc_tty_write(struct t
 	struct n_hdlc_buf *tbuf;
 
 	if (debuglevel >= DEBUG_LEVEL_INFO)	
-		printk("%s(%d)n_hdlc_tty_write() called count=%Zd\n",
+		printk("%s(%d)n_hdlc_tty_write() called count=%zd\n",
 			__FILE__,__LINE__,count);
 		
 	/* Verify pointers */
diff -puN drivers/usb/gadget/legacy/inode.c~lib-vsprintfc-remove-%z-support drivers/usb/gadget/legacy/inode.c
--- a/drivers/usb/gadget/legacy/inode.c~lib-vsprintfc-remove-%z-support
+++ a/drivers/usb/gadget/legacy/inode.c
@@ -1848,7 +1848,7 @@ dev_config (struct file *fd, const char
 
 fail:
 	spin_unlock_irq (&dev->lock);
-	pr_debug ("%s: %s fail %Zd, %p\n", shortname, __func__, value, dev);
+	pr_debug ("%s: %s fail %zd, %p\n", shortname, __func__, value, dev);
 	kfree (dev->buf);
 	dev->buf = NULL;
 	return value;
diff -puN drivers/usb/host/ehci-hcd.c~lib-vsprintfc-remove-%z-support drivers/usb/host/ehci-hcd.c
--- a/drivers/usb/host/ehci-hcd.c~lib-vsprintfc-remove-%z-support
+++ a/drivers/usb/host/ehci-hcd.c
@@ -1322,7 +1322,7 @@ static int __init ehci_hcd_init(void)
 		printk(KERN_WARNING "Warning! ehci_hcd should always be loaded"
 				" before uhci_hcd and ohci_hcd, not after\n");
 
-	pr_debug("%s: block sizes: qh %Zd qtd %Zd itd %Zd sitd %Zd\n",
+	pr_debug("%s: block sizes: qh %zd qtd %zd itd %zd sitd %zd\n",
 		 hcd_name,
 		 sizeof(struct ehci_qh), sizeof(struct ehci_qtd),
 		 sizeof(struct ehci_itd), sizeof(struct ehci_sitd));
diff -puN drivers/usb/host/fotg210-hcd.c~lib-vsprintfc-remove-%z-support drivers/usb/host/fotg210-hcd.c
--- a/drivers/usb/host/fotg210-hcd.c~lib-vsprintfc-remove-%z-support
+++ a/drivers/usb/host/fotg210-hcd.c
@@ -5697,7 +5697,7 @@ static int __init fotg210_hcd_init(void)
 			test_bit(USB_OHCI_LOADED, &usb_hcds_loaded))
 		pr_warn("Warning! fotg210_hcd should always be loaded before uhci_hcd and ohci_hcd, not after\n");
 
-	pr_debug("%s: block sizes: qh %Zd qtd %Zd itd %Zd\n",
+	pr_debug("%s: block sizes: qh %zd qtd %zd itd %zd\n",
 			hcd_name, sizeof(struct fotg210_qh),
 			sizeof(struct fotg210_qtd),
 			sizeof(struct fotg210_itd));
diff -puN drivers/usb/host/ohci-hcd.c~lib-vsprintfc-remove-%z-support drivers/usb/host/ohci-hcd.c
--- a/drivers/usb/host/ohci-hcd.c~lib-vsprintfc-remove-%z-support
+++ a/drivers/usb/host/ohci-hcd.c
@@ -1252,7 +1252,7 @@ static int __init ohci_hcd_mod_init(void
 		return -ENODEV;
 
 	printk(KERN_INFO "%s: " DRIVER_DESC "\n", hcd_name);
-	pr_debug ("%s: block sizes: ed %Zd td %Zd\n", hcd_name,
+	pr_debug ("%s: block sizes: ed %zd td %zd\n", hcd_name,
 		sizeof (struct ed), sizeof (struct td));
 	set_bit(USB_OHCI_LOADED, &usb_hcds_loaded);
 
diff -puN drivers/usb/misc/adutux.c~lib-vsprintfc-remove-%z-support drivers/usb/misc/adutux.c
--- a/drivers/usb/misc/adutux.c~lib-vsprintfc-remove-%z-support
+++ a/drivers/usb/misc/adutux.c
@@ -563,20 +563,20 @@ static ssize_t adu_write(struct file *fi
 			}
 
 			dev_dbg(&dev->udev->dev,
-				"%s : in progress, count = %Zd\n",
+				"%s : in progress, count = %zd\n",
 				__func__, count);
 		} else {
 			spin_unlock_irqrestore(&dev->buflock, flags);
 			set_current_state(TASK_RUNNING);
 			remove_wait_queue(&dev->write_wait, &waita);
-			dev_dbg(&dev->udev->dev, "%s : sending, count = %Zd\n",
+			dev_dbg(&dev->udev->dev, "%s : sending, count = %zd\n",
 				__func__, count);
 
 			/* write the data into interrupt_out_buffer from userspace */
 			buffer_size = usb_endpoint_maxp(dev->interrupt_out_endpoint);
 			bytes_to_write = count > buffer_size ? buffer_size : count;
 			dev_dbg(&dev->udev->dev,
-				"%s : buffer_size = %Zd, count = %Zd, bytes_to_write = %Zd\n",
+				"%s : buffer_size = %zd, count = %zd, bytes_to_write = %zd\n",
 				__func__, buffer_size, count, bytes_to_write);
 
 			if (copy_from_user(dev->interrupt_out_buffer, buffer, bytes_to_write) != 0) {
diff -puN drivers/usb/misc/legousbtower.c~lib-vsprintfc-remove-%z-support drivers/usb/misc/legousbtower.c
--- a/drivers/usb/misc/legousbtower.c~lib-vsprintfc-remove-%z-support
+++ a/drivers/usb/misc/legousbtower.c
@@ -673,7 +673,7 @@ static ssize_t tower_write (struct file
 
 	/* write the data into interrupt_out_buffer from userspace */
 	bytes_to_write = min_t(int, count, write_buffer_size);
-	dev_dbg(&dev->udev->dev, "%s: count = %Zd, bytes_to_write = %Zd\n",
+	dev_dbg(&dev->udev->dev, "%s: count = %zd, bytes_to_write = %zd\n",
 		__func__, count, bytes_to_write);
 
 	if (copy_from_user (dev->interrupt_out_buffer, buffer, bytes_to_write)) {
diff -puN drivers/usb/misc/uss720.c~lib-vsprintfc-remove-%z-support drivers/usb/misc/uss720.c
--- a/drivers/usb/misc/uss720.c~lib-vsprintfc-remove-%z-support
+++ a/drivers/usb/misc/uss720.c
@@ -526,7 +526,7 @@ static size_t parport_uss720_epp_write_d
 		return 0;
 	i = usb_bulk_msg(usbdev, usb_sndbulkpipe(usbdev, 1), (void *)buf, length, &rlen, 20000);
 	if (i)
-		printk(KERN_ERR "uss720: sendbulk ep 1 buf %p len %Zu rlen %u\n", buf, length, rlen);
+		printk(KERN_ERR "uss720: sendbulk ep 1 buf %p len %zu rlen %u\n", buf, length, rlen);
 	change_mode(pp, ECR_PS2);
 	return rlen;
 #endif
@@ -587,7 +587,7 @@ static size_t parport_uss720_ecp_write_d
 		return 0;
 	i = usb_bulk_msg(usbdev, usb_sndbulkpipe(usbdev, 1), (void *)buffer, len, &rlen, 20000);
 	if (i)
-		printk(KERN_ERR "uss720: sendbulk ep 1 buf %p len %Zu rlen %u\n", buffer, len, rlen);
+		printk(KERN_ERR "uss720: sendbulk ep 1 buf %p len %zu rlen %u\n", buffer, len, rlen);
 	change_mode(pp, ECR_PS2);
 	return rlen;
 }
@@ -605,7 +605,7 @@ static size_t parport_uss720_ecp_read_da
 		return 0;
 	i = usb_bulk_msg(usbdev, usb_rcvbulkpipe(usbdev, 2), buffer, len, &rlen, 20000);
 	if (i)
-		printk(KERN_ERR "uss720: recvbulk ep 2 buf %p len %Zu rlen %u\n", buffer, len, rlen);
+		printk(KERN_ERR "uss720: recvbulk ep 2 buf %p len %zu rlen %u\n", buffer, len, rlen);
 	change_mode(pp, ECR_PS2);
 	return rlen;
 }
@@ -638,7 +638,7 @@ static size_t parport_uss720_write_compa
 		return 0;
 	i = usb_bulk_msg(usbdev, usb_sndbulkpipe(usbdev, 1), (void *)buffer, len, &rlen, 20000);
 	if (i)
-		printk(KERN_ERR "uss720: sendbulk ep 1 buf %p len %Zu rlen %u\n", buffer, len, rlen);
+		printk(KERN_ERR "uss720: sendbulk ep 1 buf %p len %zu rlen %u\n", buffer, len, rlen);
 	change_mode(pp, ECR_PS2);
 	return rlen;
 }
diff -puN drivers/video/fbdev/metronomefb.c~lib-vsprintfc-remove-%z-support drivers/video/fbdev/metronomefb.c
--- a/drivers/video/fbdev/metronomefb.c~lib-vsprintfc-remove-%z-support
+++ a/drivers/video/fbdev/metronomefb.c
@@ -187,7 +187,7 @@ static int load_waveform(u8 *mem, size_t
 		epd_frame_table[par->dt].wfm_size = user_wfm_size;
 
 	if (size != epd_frame_table[par->dt].wfm_size) {
-		dev_err(dev, "Error: unexpected size %Zd != %d\n", size,
+		dev_err(dev, "Error: unexpected size %zd != %d\n", size,
 					epd_frame_table[par->dt].wfm_size);
 		return -EINVAL;
 	}
diff -puN fs/afs/dir.c~lib-vsprintfc-remove-%z-support fs/afs/dir.c
--- a/fs/afs/dir.c~lib-vsprintfc-remove-%z-support
+++ a/fs/afs/dir.c
@@ -252,7 +252,7 @@ static int afs_dir_iterate_block(struct
 		/* skip entries marked unused in the bitmap */
 		if (!(block->pagehdr.bitmap[offset / 8] &
 		      (1 << (offset % 8)))) {
-			_debug("ENT[%Zu.%u]: unused",
+			_debug("ENT[%zu.%u]: unused",
 			       blkoff / sizeof(union afs_dir_block), offset);
 			if (offset >= curr)
 				ctx->pos = blkoff +
@@ -266,7 +266,7 @@ static int afs_dir_iterate_block(struct
 			       sizeof(*block) -
 			       offset * sizeof(union afs_dirent));
 
-		_debug("ENT[%Zu.%u]: %s %Zu \"%s\"",
+		_debug("ENT[%zu.%u]: %s %zu \"%s\"",
 		       blkoff / sizeof(union afs_dir_block), offset,
 		       (offset < curr ? "skip" : "fill"),
 		       nlen, dire->u.name);
@@ -274,23 +274,23 @@ static int afs_dir_iterate_block(struct
 		/* work out where the next possible entry is */
 		for (tmp = nlen; tmp > 15; tmp -= sizeof(union afs_dirent)) {
 			if (next >= AFS_DIRENT_PER_BLOCK) {
-				_debug("ENT[%Zu.%u]:"
+				_debug("ENT[%zu.%u]:"
 				       " %u travelled beyond end dir block"
-				       " (len %u/%Zu)",
+				       " (len %u/%zu)",
 				       blkoff / sizeof(union afs_dir_block),
 				       offset, next, tmp, nlen);
 				return -EIO;
 			}
 			if (!(block->pagehdr.bitmap[next / 8] &
 			      (1 << (next % 8)))) {
-				_debug("ENT[%Zu.%u]:"
-				       " %u unmarked extension (len %u/%Zu)",
+				_debug("ENT[%zu.%u]:"
+				       " %u unmarked extension (len %u/%zu)",
 				       blkoff / sizeof(union afs_dir_block),
 				       offset, next, tmp, nlen);
 				return -EIO;
 			}
 
-			_debug("ENT[%Zu.%u]: ext %u/%Zu",
+			_debug("ENT[%zu.%u]: ext %u/%zu",
 			       blkoff / sizeof(union afs_dir_block),
 			       next, tmp, nlen);
 			next++;
diff -puN fs/ncpfs/sock.c~lib-vsprintfc-remove-%z-support fs/ncpfs/sock.c
--- a/fs/ncpfs/sock.c~lib-vsprintfc-remove-%z-support
+++ a/fs/ncpfs/sock.c
@@ -525,7 +525,7 @@ static int do_tcp_rcv(struct ncp_server
 		return result;
 	}
 	if (result > len) {
-		pr_err("tcp: bug in recvmsg (%u > %Zu)\n", result, len);
+		pr_err("tcp: bug in recvmsg (%u > %zu)\n", result, len);
 		return -EIO;			
 	}
 	return result;
@@ -619,7 +619,7 @@ skipdata:;
 					goto skipdata2;
 				}
 				if (datalen > req->datalen + 8) {
-					pr_err("tcp: Unexpected reply len %d (expected at most %Zd)\n", datalen, req->datalen + 8);
+					pr_err("tcp: Unexpected reply len %d (expected at most %zd)\n", datalen, req->datalen + 8);
 					server->rcv.state = 3;
 					goto skipdata;
 				}
diff -puN fs/nfs/blocklayout/blocklayout.c~lib-vsprintfc-remove-%z-support fs/nfs/blocklayout/blocklayout.c
--- a/fs/nfs/blocklayout/blocklayout.c~lib-vsprintfc-remove-%z-support
+++ a/fs/nfs/blocklayout/blocklayout.c
@@ -381,7 +381,7 @@ bl_write_pagelist(struct nfs_pgio_header
 	struct blk_plug plug;
 	int i;
 
-	dprintk("%s enter, %Zu@%lld\n", __func__, count, offset);
+	dprintk("%s enter, %zu@%lld\n", __func__, count, offset);
 
 	/* At this point, header->page_aray is a (sequential) list of nfs_pages.
 	 * We want to write each, and if there is an error set pnfs_error
diff -puN fs/nfs/filelayout/filelayout.c~lib-vsprintfc-remove-%z-support fs/nfs/filelayout/filelayout.c
--- a/fs/nfs/filelayout/filelayout.c~lib-vsprintfc-remove-%z-support
+++ a/fs/nfs/filelayout/filelayout.c
@@ -482,7 +482,7 @@ filelayout_read_pagelist(struct nfs_pgio
 	u32 j, idx;
 	struct nfs_fh *fh;
 
-	dprintk("--> %s ino %lu pgbase %u req %Zu@%llu\n",
+	dprintk("--> %s ino %lu pgbase %u req %zu@%llu\n",
 		__func__, hdr->inode->i_ino,
 		hdr->args.pgbase, (size_t)hdr->args.count, offset);
 
@@ -540,7 +540,7 @@ filelayout_write_pagelist(struct nfs_pgi
 	if (IS_ERR(ds_clnt))
 		return PNFS_NOT_ATTEMPTED;
 
-	dprintk("%s ino %lu sync %d req %Zu@%llu DS: %s cl_count %d\n",
+	dprintk("%s ino %lu sync %d req %zu@%llu DS: %s cl_count %d\n",
 		__func__, hdr->inode->i_ino, sync, (size_t) hdr->args.count,
 		offset, ds->ds_remotestr, atomic_read(&ds->ds_clp->cl_count));
 
diff -puN fs/nfs/flexfilelayout/flexfilelayout.c~lib-vsprintfc-remove-%z-support fs/nfs/flexfilelayout/flexfilelayout.c
--- a/fs/nfs/flexfilelayout/flexfilelayout.c~lib-vsprintfc-remove-%z-support
+++ a/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -1751,7 +1751,7 @@ ff_layout_read_pagelist(struct nfs_pgio_
 	int vers;
 	struct nfs_fh *fh;
 
-	dprintk("--> %s ino %lu pgbase %u req %Zu@%llu\n",
+	dprintk("--> %s ino %lu pgbase %u req %zu@%llu\n",
 		__func__, hdr->inode->i_ino,
 		hdr->args.pgbase, (size_t)hdr->args.count, offset);
 
@@ -1828,7 +1828,7 @@ ff_layout_write_pagelist(struct nfs_pgio
 
 	vers = nfs4_ff_layout_ds_version(lseg, idx);
 
-	dprintk("%s ino %lu sync %d req %Zu@%llu DS: %s cl_count %d vers %d\n",
+	dprintk("%s ino %lu sync %d req %zu@%llu DS: %s cl_count %d vers %d\n",
 		__func__, hdr->inode->i_ino, sync, (size_t) hdr->args.count,
 		offset, ds->ds_remotestr, atomic_read(&ds->ds_clp->cl_count),
 		vers);
diff -puN fs/nfs/objlayout/objlayout.c~lib-vsprintfc-remove-%z-support fs/nfs/objlayout/objlayout.c
--- a/fs/nfs/objlayout/objlayout.c~lib-vsprintfc-remove-%z-support
+++ a/fs/nfs/objlayout/objlayout.c
@@ -291,7 +291,7 @@ objlayout_read_pagelist(struct nfs_pgio_
 			      &hdr->args.pgbase,
 			      hdr->args.offset, hdr->args.count);
 
-	dprintk("%s: inode(%lx) offset 0x%llx count 0x%Zx eof=%d\n",
+	dprintk("%s: inode(%lx) offset 0x%llx count 0x%zx eof=%d\n",
 		__func__, inode->i_ino, offset, count, hdr->res.eof);
 
 	err = objio_read_pagelist(hdr);
diff -puN fs/nfsd/nfscache.c~lib-vsprintfc-remove-%z-support fs/nfsd/nfscache.c
--- a/fs/nfsd/nfscache.c~lib-vsprintfc-remove-%z-support
+++ a/fs/nfsd/nfscache.c
@@ -578,7 +578,7 @@ nfsd_cache_append(struct svc_rqst *rqstp
 	struct kvec	*vec = &rqstp->rq_res.head[0];
 
 	if (vec->iov_len + data->iov_len > PAGE_SIZE) {
-		printk(KERN_WARNING "nfsd: cached reply too large (%Zd).\n",
+		printk(KERN_WARNING "nfsd: cached reply too large (%zd).\n",
 				data->iov_len);
 		return 0;
 	}
diff -puN kernel/relay.c~lib-vsprintfc-remove-%z-support kernel/relay.c
--- a/kernel/relay.c~lib-vsprintfc-remove-%z-support
+++ a/kernel/relay.c
@@ -847,7 +847,7 @@ void relay_close(struct rchan *chan)
 
 	if (chan->last_toobig)
 		printk(KERN_WARNING "relay: one or more items not logged "
-		       "[item size (%Zd) > sub-buffer size (%Zd)]\n",
+		       "[item size (%zd) > sub-buffer size (%zd)]\n",
 		       chan->last_toobig, chan->subbuf_size);
 
 	list_del(&chan->list);
diff -puN lib/vsprintf.c~lib-vsprintfc-remove-%z-support lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-remove-%z-support
+++ a/lib/vsprintf.c
@@ -1739,6 +1739,7 @@ char *pointer(const char *fmt, char *buf
  * 'h', 'l', or 'L' for integer fields
  * 'z' support added 23/7/1999 S.H.
  * 'z' changed to 'Z' --davidm 1/25/99
+ * 'Z' changed to 'z' --adobriyan 2017-01-25
  * 't' added for ptrdiff_t
  *
  * @fmt: the format string
@@ -1838,7 +1839,7 @@ qualifier:
 	/* get the conversion qualifier */
 	qualifier = 0;
 	if (*fmt == 'h' || _tolower(*fmt) == 'l' ||
-	    _tolower(*fmt) == 'z' || *fmt == 't') {
+	    *fmt == 'z' || *fmt == 't') {
 		qualifier = *fmt++;
 		if (unlikely(qualifier == *fmt)) {
 			if (qualifier == 'l') {
@@ -1907,7 +1908,7 @@ qualifier:
 	else if (qualifier == 'l') {
 		BUILD_BUG_ON(FORMAT_TYPE_ULONG + SIGN != FORMAT_TYPE_LONG);
 		spec->type = FORMAT_TYPE_ULONG + (spec->flags & SIGN);
-	} else if (_tolower(qualifier) == 'z') {
+	} else if (qualifier == 'z') {
 		spec->type = FORMAT_TYPE_SIZE_T;
 	} else if (qualifier == 't') {
 		spec->type = FORMAT_TYPE_PTRDIFF;
@@ -2657,7 +2658,7 @@ int vsscanf(const char *buf, const char
 		/* get conversion qualifier */
 		qualifier = -1;
 		if (*fmt == 'h' || _tolower(*fmt) == 'l' ||
-		    _tolower(*fmt) == 'z') {
+		    *fmt == 'z') {
 			qualifier = *fmt++;
 			if (unlikely(qualifier == *fmt)) {
 				if (qualifier == 'h') {
@@ -2851,7 +2852,6 @@ int vsscanf(const char *buf, const char
 			else
 				*va_arg(args, unsigned long long *) = val.u;
 			break;
-		case 'Z':
 		case 'z':
 			*va_arg(args, size_t *) = val.u;
 			break;
diff -puN mm/dmapool.c~lib-vsprintfc-remove-%z-support mm/dmapool.c
--- a/mm/dmapool.c~lib-vsprintfc-remove-%z-support
+++ a/mm/dmapool.c
@@ -93,7 +93,7 @@ show_pools(struct device *dev, struct de
 		spin_unlock_irq(&pool->lock);
 
 		/* per-pool info, no real statistics yet */
-		temp = scnprintf(next, size, "%-16s %4u %4Zu %4Zu %2u\n",
+		temp = scnprintf(next, size, "%-16s %4u %4zu %4zu %2u\n",
 				 pool->name, blocks,
 				 pages * (pool->allocation / pool->size),
 				 pool->size, pages);
diff -puN net/appletalk/ddp.c~lib-vsprintfc-remove-%z-support net/appletalk/ddp.c
--- a/net/appletalk/ddp.c~lib-vsprintfc-remove-%z-support
+++ a/net/appletalk/ddp.c
@@ -1656,7 +1656,7 @@ static int atalk_sendmsg(struct socket *
 	ddp->deh_dport = usat->sat_port;
 	ddp->deh_sport = at->src_port;
 
-	SOCK_DEBUG(sk, "SK %p: Copy user data (%Zd bytes).\n", sk, len);
+	SOCK_DEBUG(sk, "SK %p: Copy user data (%zd bytes).\n", sk, len);
 
 	err = memcpy_from_msg(skb_put(skb, len), msg, len);
 	if (err) {
@@ -1720,7 +1720,7 @@ static int atalk_sendmsg(struct socket *
 		 */
 		aarp_send_ddp(dev, skb, &usat->sat_addr, NULL);
 	}
-	SOCK_DEBUG(sk, "SK %p: Done write (%Zd).\n", sk, len);
+	SOCK_DEBUG(sk, "SK %p: Done write (%zd).\n", sk, len);
 
 out:
 	release_sock(sk);
diff -puN net/atm/mpc.c~lib-vsprintfc-remove-%z-support net/atm/mpc.c
--- a/net/atm/mpc.c~lib-vsprintfc-remove-%z-support
+++ a/net/atm/mpc.c
@@ -451,7 +451,7 @@ static void lane2_assoc_ind(struct net_d
 			return;
 	}
 	if (end_of_tlvs - tlvs != 0)
-		pr_info("(%s) ignoring %Zd bytes of trailing TLV garbage\n",
+		pr_info("(%s) ignoring %zd bytes of trailing TLV garbage\n",
 			dev->name, end_of_tlvs - tlvs);
 }
 
diff -puN net/bridge/netfilter/ebt_among.c~lib-vsprintfc-remove-%z-support net/bridge/netfilter/ebt_among.c
--- a/net/bridge/netfilter/ebt_among.c~lib-vsprintfc-remove-%z-support
+++ a/net/bridge/netfilter/ebt_among.c
@@ -187,7 +187,7 @@ static int ebt_among_mt_check(const stru
 	expected_length += ebt_mac_wormhash_size(wh_src);
 
 	if (em->match_size != EBT_ALIGN(expected_length)) {
-		pr_info("wrong size: %d against expected %d, rounded to %Zd\n",
+		pr_info("wrong size: %d against expected %d, rounded to %zd\n",
 			em->match_size, expected_length,
 			EBT_ALIGN(expected_length));
 		return -EINVAL;
diff -puN net/ieee802154/socket.c~lib-vsprintfc-remove-%z-support net/ieee802154/socket.c
--- a/net/ieee802154/socket.c~lib-vsprintfc-remove-%z-support
+++ a/net/ieee802154/socket.c
@@ -279,7 +279,7 @@ static int raw_sendmsg(struct sock *sk,
 	pr_debug("name = %s, mtu = %u\n", dev->name, mtu);
 
 	if (size > mtu) {
-		pr_debug("size = %Zu, mtu = %u\n", size, mtu);
+		pr_debug("size = %zu, mtu = %u\n", size, mtu);
 		err = -EMSGSIZE;
 		goto out_dev;
 	}
@@ -645,7 +645,7 @@ static int dgram_sendmsg(struct sock *sk
 	pr_debug("name = %s, mtu = %u\n", dev->name, mtu);
 
 	if (size > mtu) {
-		pr_debug("size = %Zu, mtu = %u\n", size, mtu);
+		pr_debug("size = %zu, mtu = %u\n", size, mtu);
 		err = -EMSGSIZE;
 		goto out_dev;
 	}
diff -puN net/ipv4/fib_trie.c~lib-vsprintfc-remove-%z-support net/ipv4/fib_trie.c
--- a/net/ipv4/fib_trie.c~lib-vsprintfc-remove-%z-support
+++ a/net/ipv4/fib_trie.c
@@ -2388,7 +2388,7 @@ static int fib_triestat_seq_show(struct
 
 	seq_printf(seq,
 		   "Basic info: size of leaf:"
-		   " %Zd bytes, size of tnode: %Zd bytes.\n",
+		   " %zd bytes, size of tnode: %zd bytes.\n",
 		   LEAF_SIZE, TNODE_SIZE(0));
 
 	for (h = 0; h < FIB_TABLE_HASHSZ; h++) {
diff -puN net/ipv4/ipmr.c~lib-vsprintfc-remove-%z-support net/ipv4/ipmr.c
--- a/net/ipv4/ipmr.c~lib-vsprintfc-remove-%z-support
+++ a/net/ipv4/ipmr.c
@@ -2596,7 +2596,7 @@ static int ipmr_vif_seq_show(struct seq_
 		const char *name =  vif->dev ? vif->dev->name : "none";
 
 		seq_printf(seq,
-			   "%2Zd %-10s %8ld %7ld  %8ld %7ld %05X %08X %08X\n",
+			   "%2zd %-10s %8ld %7ld  %8ld %7ld %05X %08X %08X\n",
 			   vif - mrt->vif_table,
 			   name, vif->bytes_in, vif->pkt_in,
 			   vif->bytes_out, vif->pkt_out,
diff -puN net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c~lib-vsprintfc-remove-%z-support net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c~lib-vsprintfc-remove-%z-support
+++ a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -235,7 +235,7 @@ getorigdst(struct sock *sk, int optval,
 	}
 
 	if ((unsigned int) *len < sizeof(struct sockaddr_in)) {
-		pr_debug("SO_ORIGINAL_DST: len %d not %Zu\n",
+		pr_debug("SO_ORIGINAL_DST: len %d not %zu\n",
 			 *len, sizeof(struct sockaddr_in));
 		return -EINVAL;
 	}
diff -puN net/ipv4/netfilter/nf_log_arp.c~lib-vsprintfc-remove-%z-support net/ipv4/netfilter/nf_log_arp.c
--- a/net/ipv4/netfilter/nf_log_arp.c~lib-vsprintfc-remove-%z-support
+++ a/net/ipv4/netfilter/nf_log_arp.c
@@ -69,7 +69,7 @@ static void dump_arp_packet(struct nf_lo
 
 	ap = skb_header_pointer(skb, sizeof(_arph), sizeof(_arpp), &_arpp);
 	if (ap == NULL) {
-		nf_log_buf_add(m, " INCOMPLETE [%Zu bytes]",
+		nf_log_buf_add(m, " INCOMPLETE [%zu bytes]",
 			       skb->len - sizeof(_arph));
 		return;
 	}
diff -puN net/ipv6/netfilter/nf_log_ipv6.c~lib-vsprintfc-remove-%z-support net/ipv6/netfilter/nf_log_ipv6.c
--- a/net/ipv6/netfilter/nf_log_ipv6.c~lib-vsprintfc-remove-%z-support
+++ a/net/ipv6/netfilter/nf_log_ipv6.c
@@ -64,7 +64,7 @@ static void dump_ipv6_packet(struct nf_l
 	nf_log_buf_add(m, "SRC=%pI6 DST=%pI6 ", &ih->saddr, &ih->daddr);
 
 	/* Max length: 44 "LEN=65535 TC=255 HOPLIMIT=255 FLOWLBL=FFFFF " */
-	nf_log_buf_add(m, "LEN=%Zu TC=%u HOPLIMIT=%u FLOWLBL=%u ",
+	nf_log_buf_add(m, "LEN=%zu TC=%u HOPLIMIT=%u FLOWLBL=%u ",
 	       ntohs(ih->payload_len) + sizeof(struct ipv6hdr),
 	       (ntohl(*(__be32 *)ih) & 0x0ff00000) >> 20,
 	       ih->hop_limit,
diff -puN net/irda/irnet/irnet_ppp.c~lib-vsprintfc-remove-%z-support net/irda/irnet/irnet_ppp.c
--- a/net/irda/irnet/irnet_ppp.c~lib-vsprintfc-remove-%z-support
+++ a/net/irda/irnet/irnet_ppp.c
@@ -51,7 +51,7 @@ irnet_ctrl_write(irnet_socket *	ap,
   char *	next;		/* Next command to process */
   int		length;		/* Length of current command */
 
-  DENTER(CTRL_TRACE, "(ap=0x%p, count=%Zd)\n", ap, count);
+  DENTER(CTRL_TRACE, "(ap=0x%p, count=%zd)\n", ap, count);
 
   /* Check for overflow... */
   DABORT(count >= IRNET_MAX_COMMAND, -ENOMEM,
@@ -66,7 +66,7 @@ irnet_ctrl_write(irnet_socket *	ap,
 
   /* Safe terminate the string */
   command[count] = '\0';
-  DEBUG(CTRL_INFO, "Command line received is ``%s'' (%Zd).\n",
+  DEBUG(CTRL_INFO, "Command line received is ``%s'' (%zd).\n",
 	command, count);
 
   /* Check every commands in the command line */
@@ -285,7 +285,7 @@ irnet_ctrl_read(irnet_socket *	ap,
   char		event[75];
   ssize_t	ret = 0;
 
-  DENTER(CTRL_TRACE, "(ap=0x%p, count=%Zd)\n", ap, count);
+  DENTER(CTRL_TRACE, "(ap=0x%p, count=%zd)\n", ap, count);
 
 #ifdef INITIAL_DISCOVERY
   /* Check if we have read the log */
@@ -328,7 +328,7 @@ irnet_ctrl_read(irnet_socket *	ap,
   if(ret != 0)
     {
       /* No, return the error code */
-      DEXIT(CTRL_TRACE, " - ret %Zd\n", ret);
+      DEXIT(CTRL_TRACE, " - ret %zd\n", ret);
       return ret;
     }
 
@@ -568,7 +568,7 @@ dev_irnet_write(struct file *	file,
 {
   irnet_socket *	ap = file->private_data;
 
-  DPASS(FS_TRACE, "(file=0x%p, ap=0x%p, count=%Zd)\n",
+  DPASS(FS_TRACE, "(file=0x%p, ap=0x%p, count=%zd)\n",
 	file, ap, count);
   DABORT(ap == NULL, -ENXIO, FS_ERROR, "ap is NULL !!!\n");
 
@@ -592,7 +592,7 @@ dev_irnet_read(struct file *	file,
 {
   irnet_socket *	ap = file->private_data;
 
-  DPASS(FS_TRACE, "(file=0x%p, ap=0x%p, count=%Zd)\n",
+  DPASS(FS_TRACE, "(file=0x%p, ap=0x%p, count=%zd)\n",
 	file, ap, count);
   DABORT(ap == NULL, -ENXIO, FS_ERROR, "ap is NULL !!!\n");
 
diff -puN net/l2tp/l2tp_core.c~lib-vsprintfc-remove-%z-support net/l2tp/l2tp_core.c
--- a/net/l2tp/l2tp_core.c~lib-vsprintfc-remove-%z-support
+++ a/net/l2tp/l2tp_core.c
@@ -1058,10 +1058,10 @@ static int l2tp_xmit_core(struct l2tp_se
 
 	/* Debug */
 	if (session->send_seq)
-		l2tp_dbg(session, L2TP_MSG_DATA, "%s: send %Zd bytes, ns=%u\n",
+		l2tp_dbg(session, L2TP_MSG_DATA, "%s: send %zd bytes, ns=%u\n",
 			 session->name, data_len, session->ns - 1);
 	else
-		l2tp_dbg(session, L2TP_MSG_DATA, "%s: send %Zd bytes\n",
+		l2tp_dbg(session, L2TP_MSG_DATA, "%s: send %zd bytes\n",
 			 session->name, data_len);
 
 	if (session->debug & L2TP_MSG_DATA) {
diff -puN net/netfilter/ipvs/ip_vs_conn.c~lib-vsprintfc-remove-%z-support net/netfilter/ipvs/ip_vs_conn.c
--- a/net/netfilter/ipvs/ip_vs_conn.c~lib-vsprintfc-remove-%z-support
+++ a/net/netfilter/ipvs/ip_vs_conn.c
@@ -1429,7 +1429,7 @@ int __init ip_vs_conn_init(void)
 		"(size=%d, memory=%ldKbytes)\n",
 		ip_vs_conn_tab_size,
 		(long)(ip_vs_conn_tab_size*sizeof(struct list_head))/1024);
-	IP_VS_DBG(0, "Each connection entry needs %Zd bytes at least\n",
+	IP_VS_DBG(0, "Each connection entry needs %zd bytes at least\n",
 		  sizeof(struct ip_vs_conn));
 
 	for (idx = 0; idx < ip_vs_conn_tab_size; idx++)
diff -puN net/netfilter/ipvs/ip_vs_dh.c~lib-vsprintfc-remove-%z-support net/netfilter/ipvs/ip_vs_dh.c
--- a/net/netfilter/ipvs/ip_vs_dh.c~lib-vsprintfc-remove-%z-support
+++ a/net/netfilter/ipvs/ip_vs_dh.c
@@ -163,7 +163,7 @@ static int ip_vs_dh_init_svc(struct ip_v
 		return -ENOMEM;
 
 	svc->sched_data = s;
-	IP_VS_DBG(6, "DH hash table (memory=%Zdbytes) allocated for "
+	IP_VS_DBG(6, "DH hash table (memory=%zdbytes) allocated for "
 		  "current service\n",
 		  sizeof(struct ip_vs_dh_bucket)*IP_VS_DH_TAB_SIZE);
 
@@ -183,7 +183,7 @@ static void ip_vs_dh_done_svc(struct ip_
 
 	/* release the table itself */
 	kfree_rcu(s, rcu_head);
-	IP_VS_DBG(6, "DH hash table (memory=%Zdbytes) released\n",
+	IP_VS_DBG(6, "DH hash table (memory=%zdbytes) released\n",
 		  sizeof(struct ip_vs_dh_bucket)*IP_VS_DH_TAB_SIZE);
 }
 
diff -puN net/netfilter/ipvs/ip_vs_lblc.c~lib-vsprintfc-remove-%z-support net/netfilter/ipvs/ip_vs_lblc.c
--- a/net/netfilter/ipvs/ip_vs_lblc.c~lib-vsprintfc-remove-%z-support
+++ a/net/netfilter/ipvs/ip_vs_lblc.c
@@ -356,7 +356,7 @@ static int ip_vs_lblc_init_svc(struct ip
 		return -ENOMEM;
 
 	svc->sched_data = tbl;
-	IP_VS_DBG(6, "LBLC hash table (memory=%Zdbytes) allocated for "
+	IP_VS_DBG(6, "LBLC hash table (memory=%zdbytes) allocated for "
 		  "current service\n", sizeof(*tbl));
 
 	/*
@@ -393,7 +393,7 @@ static void ip_vs_lblc_done_svc(struct i
 
 	/* release the table itself */
 	kfree_rcu(tbl, rcu_head);
-	IP_VS_DBG(6, "LBLC hash table (memory=%Zdbytes) released\n",
+	IP_VS_DBG(6, "LBLC hash table (memory=%zdbytes) released\n",
 		  sizeof(*tbl));
 }
 
diff -puN net/netfilter/ipvs/ip_vs_lblcr.c~lib-vsprintfc-remove-%z-support net/netfilter/ipvs/ip_vs_lblcr.c
--- a/net/netfilter/ipvs/ip_vs_lblcr.c~lib-vsprintfc-remove-%z-support
+++ a/net/netfilter/ipvs/ip_vs_lblcr.c
@@ -519,7 +519,7 @@ static int ip_vs_lblcr_init_svc(struct i
 		return -ENOMEM;
 
 	svc->sched_data = tbl;
-	IP_VS_DBG(6, "LBLCR hash table (memory=%Zdbytes) allocated for "
+	IP_VS_DBG(6, "LBLCR hash table (memory=%zdbytes) allocated for "
 		  "current service\n", sizeof(*tbl));
 
 	/*
@@ -556,7 +556,7 @@ static void ip_vs_lblcr_done_svc(struct
 
 	/* release the table itself */
 	kfree_rcu(tbl, rcu_head);
-	IP_VS_DBG(6, "LBLCR hash table (memory=%Zdbytes) released\n",
+	IP_VS_DBG(6, "LBLCR hash table (memory=%zdbytes) released\n",
 		  sizeof(*tbl));
 }
 
diff -puN net/netfilter/ipvs/ip_vs_sh.c~lib-vsprintfc-remove-%z-support net/netfilter/ipvs/ip_vs_sh.c
--- a/net/netfilter/ipvs/ip_vs_sh.c~lib-vsprintfc-remove-%z-support
+++ a/net/netfilter/ipvs/ip_vs_sh.c
@@ -239,7 +239,7 @@ static int ip_vs_sh_init_svc(struct ip_v
 		return -ENOMEM;
 
 	svc->sched_data = s;
-	IP_VS_DBG(6, "SH hash table (memory=%Zdbytes) allocated for "
+	IP_VS_DBG(6, "SH hash table (memory=%zdbytes) allocated for "
 		  "current service\n",
 		  sizeof(struct ip_vs_sh_bucket)*IP_VS_SH_TAB_SIZE);
 
@@ -259,7 +259,7 @@ static void ip_vs_sh_done_svc(struct ip_
 
 	/* release the table itself */
 	kfree_rcu(s, rcu_head);
-	IP_VS_DBG(6, "SH hash table (memory=%Zdbytes) released\n",
+	IP_VS_DBG(6, "SH hash table (memory=%zdbytes) released\n",
 		  sizeof(struct ip_vs_sh_bucket)*IP_VS_SH_TAB_SIZE);
 }
 
diff -puN net/netfilter/ipvs/ip_vs_sync.c~lib-vsprintfc-remove-%z-support net/netfilter/ipvs/ip_vs_sync.c
--- a/net/netfilter/ipvs/ip_vs_sync.c~lib-vsprintfc-remove-%z-support
+++ a/net/netfilter/ipvs/ip_vs_sync.c
@@ -1791,7 +1791,7 @@ int start_sync_thread(struct netns_ipvs
 	u16 mtu, min_mtu;
 
 	IP_VS_DBG(7, "%s(): pid %d\n", __func__, task_pid_nr(current));
-	IP_VS_DBG(7, "Each ip_vs_sync_conn entry needs %Zd bytes\n",
+	IP_VS_DBG(7, "Each ip_vs_sync_conn entry needs %zd bytes\n",
 		  sizeof(struct ip_vs_sync_conn_v0));
 
 	if (!ipvs->sync_state) {
diff -puN net/netfilter/nf_conntrack_ftp.c~lib-vsprintfc-remove-%z-support net/netfilter/nf_conntrack_ftp.c
--- a/net/netfilter/nf_conntrack_ftp.c~lib-vsprintfc-remove-%z-support
+++ a/net/netfilter/nf_conntrack_ftp.c
@@ -300,7 +300,7 @@ static int find_pattern(const char *data
 {
 	size_t i = plen;
 
-	pr_debug("find_pattern `%s': dlen = %Zu\n", pattern, dlen);
+	pr_debug("find_pattern `%s': dlen = %zu\n", pattern, dlen);
 
 	if (dlen <= plen) {
 		/* Short packet: try for partial? */
diff -puN net/sctp/output.c~lib-vsprintfc-remove-%z-support net/sctp/output.c
--- a/net/sctp/output.c~lib-vsprintfc-remove-%z-support
+++ a/net/sctp/output.c
@@ -177,7 +177,7 @@ sctp_xmit_t sctp_packet_transmit_chunk(s
 {
 	sctp_xmit_t retval;
 
-	pr_debug("%s: packet:%p size:%Zu chunk:%p size:%d\n", __func__,
+	pr_debug("%s: packet:%p size:%zu chunk:%p size:%d\n", __func__,
 		 packet, packet->size, chunk, chunk->skb ? chunk->skb->len : -1);
 
 	switch ((retval = (sctp_packet_append_chunk(packet, chunk)))) {
diff -puN net/sunrpc/auth_gss/auth_gss.c~lib-vsprintfc-remove-%z-support net/sunrpc/auth_gss/auth_gss.c
--- a/net/sunrpc/auth_gss/auth_gss.c~lib-vsprintfc-remove-%z-support
+++ a/net/sunrpc/auth_gss/auth_gss.c
@@ -763,7 +763,7 @@ err_put_ctx:
 err:
 	kfree(buf);
 out:
-	dprintk("RPC:       %s returning %Zd\n", __func__, err);
+	dprintk("RPC:       %s returning %zd\n", __func__, err);
 	return err;
 }
 
diff -puN net/sunrpc/svc.c~lib-vsprintfc-remove-%z-support net/sunrpc/svc.c
--- a/net/sunrpc/svc.c~lib-vsprintfc-remove-%z-support
+++ a/net/sunrpc/svc.c
@@ -1260,7 +1260,7 @@ svc_process_common(struct svc_rqst *rqst
 	return 0;
 
 err_short_len:
-	svc_printk(rqstp, "short len %Zd, dropping request\n",
+	svc_printk(rqstp, "short len %zd, dropping request\n",
 			argv->iov_len);
 	goto close;
 
diff -puN net/sunrpc/svcsock.c~lib-vsprintfc-remove-%z-support net/sunrpc/svcsock.c
--- a/net/sunrpc/svcsock.c~lib-vsprintfc-remove-%z-support
+++ a/net/sunrpc/svcsock.c
@@ -278,7 +278,7 @@ static int svc_sendto(struct svc_rqst *r
 			       rqstp->rq_respages[0], tailoff);
 
 out:
-	dprintk("svc: socket %p sendto([%p %Zu... ], %d) = %d (addr %s)\n",
+	dprintk("svc: socket %p sendto([%p %zu... ], %d) = %d (addr %s)\n",
 		svsk, xdr->head[0].iov_base, xdr->head[0].iov_len,
 		xdr->len, len, svc_print_addr(rqstp, buf, sizeof(buf)));
 
@@ -346,7 +346,7 @@ static int svc_recvfrom(struct svc_rqst
 	if (len == buflen)
 		set_bit(XPT_DATA, &svsk->sk_xprt.xpt_flags);
 
-	dprintk("svc: socket %p recvfrom(%p, %Zu) = %d\n",
+	dprintk("svc: socket %p recvfrom(%p, %zu) = %d\n",
 		svsk, iov[0].iov_base, iov[0].iov_len, len);
 	return len;
 }
diff -puN net/sunrpc/xprtsock.c~lib-vsprintfc-remove-%z-support net/sunrpc/xprtsock.c
--- a/net/sunrpc/xprtsock.c~lib-vsprintfc-remove-%z-support
+++ a/net/sunrpc/xprtsock.c
@@ -1188,7 +1188,7 @@ static inline void xs_tcp_read_xid(struc
 	char *p;
 
 	len = sizeof(transport->tcp_xid) - transport->tcp_offset;
-	dprintk("RPC:       reading XID (%Zu bytes)\n", len);
+	dprintk("RPC:       reading XID (%zu bytes)\n", len);
 	p = ((char *) &transport->tcp_xid) + transport->tcp_offset;
 	used = xdr_skb_read_bits(desc, p, len);
 	transport->tcp_offset += used;
@@ -1219,7 +1219,7 @@ static inline void xs_tcp_read_calldir(s
 	 */
 	offset = transport->tcp_offset - sizeof(transport->tcp_xid);
 	len = sizeof(transport->tcp_calldir) - offset;
-	dprintk("RPC:       reading CALL/REPLY flag (%Zu bytes)\n", len);
+	dprintk("RPC:       reading CALL/REPLY flag (%zu bytes)\n", len);
 	p = ((char *) &transport->tcp_calldir) + offset;
 	used = xdr_skb_read_bits(desc, p, len);
 	transport->tcp_offset += used;
@@ -1310,7 +1310,7 @@ static inline void xs_tcp_read_common(st
 		return;
 	}
 
-	dprintk("RPC:       XID %08x read %Zd bytes\n",
+	dprintk("RPC:       XID %08x read %zd bytes\n",
 			ntohl(transport->tcp_xid), r);
 	dprintk("RPC:       xprt = %p, tcp_copied = %lu, tcp_offset = %u, "
 			"tcp_reclen = %u\n", xprt, transport->tcp_copied,
@@ -1456,7 +1456,7 @@ static inline void xs_tcp_read_discard(s
 	desc->count -= len;
 	desc->offset += len;
 	transport->tcp_offset += len;
-	dprintk("RPC:       discarded %Zu bytes\n", len);
+	dprintk("RPC:       discarded %zu bytes\n", len);
 	xs_tcp_check_fraghdr(transport);
 }
 
diff -puN security/selinux/ss/ebitmap.c~lib-vsprintfc-remove-%z-support security/selinux/ss/ebitmap.c
--- a/security/selinux/ss/ebitmap.c~lib-vsprintfc-remove-%z-support
+++ a/security/selinux/ss/ebitmap.c
@@ -360,7 +360,7 @@ int ebitmap_read(struct ebitmap *e, void
 
 	if (mapunit != BITS_PER_U64) {
 		printk(KERN_ERR "SELinux: ebitmap: map size %u does not "
-		       "match my size %Zd (high bit was %d)\n",
+		       "match my size %zd (high bit was %d)\n",
 		       mapunit, BITS_PER_U64, e->highbit);
 		goto bad;
 	}
diff -puN security/selinux/ss/policydb.c~lib-vsprintfc-remove-%z-support security/selinux/ss/policydb.c
--- a/security/selinux/ss/policydb.c~lib-vsprintfc-remove-%z-support
+++ a/security/selinux/ss/policydb.c
@@ -2266,7 +2266,7 @@ int policydb_read(struct policydb *p, vo
 	len = le32_to_cpu(buf[1]);
 	if (len != strlen(POLICYDB_STRING)) {
 		printk(KERN_ERR "SELinux:  policydb string length %d does not "
-		       "match expected length %Zu\n",
+		       "match expected length %zu\n",
 		       len, strlen(POLICYDB_STRING));
 		goto bad;
 	}
diff -puN sound/pci/korg1212/korg1212.c~lib-vsprintfc-remove-%z-support sound/pci/korg1212/korg1212.c
--- a/sound/pci/korg1212/korg1212.c~lib-vsprintfc-remove-%z-support
+++ a/sound/pci/korg1212/korg1212.c
@@ -2051,7 +2051,7 @@ static void snd_korg1212_proc_read(struc
 	snd_iprintf(buffer, korg1212->card->longname);
 	snd_iprintf(buffer, " (index #%d)\n", korg1212->card->number + 1);
 	snd_iprintf(buffer, "\nGeneral settings\n");
-	snd_iprintf(buffer, "    period size: %Zd bytes\n", K1212_PERIOD_BYTES);
+	snd_iprintf(buffer, "    period size: %zd bytes\n", K1212_PERIOD_BYTES);
 	snd_iprintf(buffer, "     clock mode: %s\n", clockSourceName[korg1212->clkSrcRate] );
 	snd_iprintf(buffer, "  left ADC Sens: %d\n", korg1212->leftADCInSens );
 	snd_iprintf(buffer, " right ADC Sens: %d\n", korg1212->rightADCInSens );
@@ -2276,7 +2276,7 @@ static int snd_korg1212_create(struct sn
 
 	if (snd_dma_alloc_pages(SNDRV_DMA_TYPE_DEV, snd_dma_pci_data(pci),
 				sizeof(struct KorgSharedBuffer), &korg1212->dma_shared) < 0) {
-		snd_printk(KERN_ERR "korg1212: can not allocate shared buffer memory (%Zd bytes)\n", sizeof(struct KorgSharedBuffer));
+		snd_printk(KERN_ERR "korg1212: can not allocate shared buffer memory (%zd bytes)\n", sizeof(struct KorgSharedBuffer));
                 snd_korg1212_free(korg1212);
                 return -ENOMEM;
         }
diff -puN sound/pci/pcxhr/pcxhr_hwdep.c~lib-vsprintfc-remove-%z-support sound/pci/pcxhr/pcxhr_hwdep.c
--- a/sound/pci/pcxhr/pcxhr_hwdep.c~lib-vsprintfc-remove-%z-support
+++ a/sound/pci/pcxhr/pcxhr_hwdep.c
@@ -292,7 +292,7 @@ static int pcxhr_dsp_load(struct pcxhr_m
 	int err, card_index;
 
 	dev_dbg(&mgr->pci->dev,
-		"loading dsp [%d] size = %Zd\n", index, dsp->size);
+		"loading dsp [%d] size = %zd\n", index, dsp->size);
 
 	switch (index) {
 	case PCXHR_FIRMWARE_XLX_INT_INDEX:
diff -puN sound/pcmcia/vx/vxp_ops.c~lib-vsprintfc-remove-%z-support sound/pcmcia/vx/vxp_ops.c
--- a/sound/pcmcia/vx/vxp_ops.c~lib-vsprintfc-remove-%z-support
+++ a/sound/pcmcia/vx/vxp_ops.c
@@ -201,7 +201,7 @@ static int vxp_load_xilinx_binary(struct
 	c |= (int)vx_inb(chip, RXM) << 8;
 	c |= vx_inb(chip, RXL);
 
-	snd_printdd(KERN_DEBUG "xilinx: dsp size received 0x%x, orig 0x%Zx\n", c, fw->size);
+	snd_printdd(KERN_DEBUG "xilinx: dsp size received 0x%x, orig 0x%zx\n", c, fw->size);
 
 	vx_outb(chip, ICR, ICR_HF0);
 
diff -puN sound/soc/soc-core.c~lib-vsprintfc-remove-%z-support sound/soc/soc-core.c
--- a/sound/soc/soc-core.c~lib-vsprintfc-remove-%z-support
+++ a/sound/soc/soc-core.c
@@ -3041,7 +3041,7 @@ static int snd_soc_register_dais(struct
 	unsigned int i;
 	int ret;
 
-	dev_dbg(dev, "ASoC: dai register %s #%Zu\n", dev_name(dev), count);
+	dev_dbg(dev, "ASoC: dai register %s #%zu\n", dev_name(dev), count);
 
 	component->dai_drv = dai_drv;
 
_
