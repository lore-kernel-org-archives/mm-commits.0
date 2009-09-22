From: akpm@linux-foundation.org
Subject: [merged] const-make-block_device_operations-const.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:37:16 -0700
Message-ID: <200909222037.n8MKbGgu031520@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56760 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752113AbZIVUho (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:37:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     const: make block_device_operations const
has been removed from the -mm tree.  Its filename was
     const-make-block_device_operations-const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: const: make block_device_operations const
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/axonram.c       |    2 +-
 arch/um/drivers/ubd_kern.c          |    2 +-
 drivers/block/DAC960.c              |    2 +-
 drivers/block/amiflop.c             |    2 +-
 drivers/block/aoe/aoeblk.c          |    2 +-
 drivers/block/ataflop.c             |    2 +-
 drivers/block/brd.c                 |    2 +-
 drivers/block/cciss.c               |    2 +-
 drivers/block/cpqarray.c            |    2 +-
 drivers/block/floppy.c              |    2 +-
 drivers/block/hd.c                  |    2 +-
 drivers/block/loop.c                |    2 +-
 drivers/block/mg_disk.c             |    2 +-
 drivers/block/nbd.c                 |    2 +-
 drivers/block/osdblk.c              |    2 +-
 drivers/block/paride/pcd.c          |    2 +-
 drivers/block/paride/pd.c           |    2 +-
 drivers/block/paride/pf.c           |    2 +-
 drivers/block/pktcdvd.c             |    2 +-
 drivers/block/ps3disk.c             |    2 +-
 drivers/block/ps3vram.c             |    2 +-
 drivers/block/sunvdc.c              |    2 +-
 drivers/block/swim.c                |    2 +-
 drivers/block/swim3.c               |    2 +-
 drivers/block/sx8.c                 |    2 +-
 drivers/block/ub.c                  |    2 +-
 drivers/block/umem.c                |    3 +--
 drivers/block/viodasd.c             |    2 +-
 drivers/block/virtio_blk.c          |    2 +-
 drivers/block/xd.c                  |    2 +-
 drivers/block/xen-blkfront.c        |    4 ++--
 drivers/block/xsysace.c             |    2 +-
 drivers/block/z2ram.c               |    3 +--
 drivers/cdrom/gdrom.c               |    2 +-
 drivers/cdrom/viocd.c               |    2 +-
 drivers/ide/ide-cd.c                |    2 +-
 drivers/ide/ide-gd.c                |    2 +-
 drivers/ide/ide-tape.c              |    2 +-
 drivers/md/dm.c                     |    4 ++--
 drivers/md/md.c                     |    4 ++--
 drivers/memstick/core/mspro_block.c |    2 +-
 drivers/message/i2o/i2o_block.c     |    2 +-
 drivers/mmc/card/block.c            |    2 +-
 drivers/mtd/mtd_blkdevs.c           |    2 +-
 drivers/s390/block/dasd.c           |    2 +-
 drivers/s390/block/dasd_int.h       |    2 +-
 drivers/s390/block/dcssblk.c        |    2 +-
 drivers/s390/block/xpram.c          |    2 +-
 drivers/s390/char/tape_block.c      |    2 +-
 drivers/sbus/char/jsflash.c         |    2 +-
 drivers/scsi/sd.c                   |    2 +-
 drivers/scsi/sr.c                   |    2 +-
 fs/block_dev.c                      |    2 +-
 fs/ext2/xip.c                       |    2 +-
 fs/partitions/check.c               |    2 +-
 include/linux/genhd.h               |    2 +-
 56 files changed, 59 insertions(+), 61 deletions(-)

diff -puN arch/powerpc/sysdev/axonram.c~const-make-block_device_operations-const arch/powerpc/sysdev/axonram.c
--- a/arch/powerpc/sysdev/axonram.c~const-make-block_device_operations-const
+++ a/arch/powerpc/sysdev/axonram.c
@@ -165,7 +165,7 @@ axon_ram_direct_access(struct block_devi
 	return 0;
 }
 
-static struct block_device_operations axon_ram_devops = {
+static const struct block_device_operations axon_ram_devops = {
 	.owner		= THIS_MODULE,
 	.direct_access	= axon_ram_direct_access
 };
diff -puN arch/um/drivers/ubd_kern.c~const-make-block_device_operations-const arch/um/drivers/ubd_kern.c
--- a/arch/um/drivers/ubd_kern.c~const-make-block_device_operations-const
+++ a/arch/um/drivers/ubd_kern.c
@@ -106,7 +106,7 @@ static int ubd_getgeo(struct block_devic
 
 #define MAX_DEV (16)
 
-static struct block_device_operations ubd_blops = {
+static const struct block_device_operations ubd_blops = {
         .owner		= THIS_MODULE,
         .open		= ubd_open,
         .release	= ubd_release,
diff -puN drivers/block/DAC960.c~const-make-block_device_operations-const drivers/block/DAC960.c
--- a/drivers/block/DAC960.c~const-make-block_device_operations-const
+++ a/drivers/block/DAC960.c
@@ -152,7 +152,7 @@ static int DAC960_revalidate_disk(struct
 	return 0;
 }
 
-static struct block_device_operations DAC960_BlockDeviceOperations = {
+static const struct block_device_operations DAC960_BlockDeviceOperations = {
 	.owner			= THIS_MODULE,
 	.open			= DAC960_open,
 	.getgeo			= DAC960_getgeo,
diff -puN drivers/block/amiflop.c~const-make-block_device_operations-const drivers/block/amiflop.c
--- a/drivers/block/amiflop.c~const-make-block_device_operations-const
+++ a/drivers/block/amiflop.c
@@ -1632,7 +1632,7 @@ static int amiga_floppy_change(struct ge
 	return 0;
 }
 
-static struct block_device_operations floppy_fops = {
+static const struct block_device_operations floppy_fops = {
 	.owner		= THIS_MODULE,
 	.open		= floppy_open,
 	.release	= floppy_release,
diff -puN drivers/block/aoe/aoeblk.c~const-make-block_device_operations-const drivers/block/aoe/aoeblk.c
--- a/drivers/block/aoe/aoeblk.c~const-make-block_device_operations-const
+++ a/drivers/block/aoe/aoeblk.c
@@ -237,7 +237,7 @@ aoeblk_getgeo(struct block_device *bdev,
 	return 0;
 }
 
-static struct block_device_operations aoe_bdops = {
+static const struct block_device_operations aoe_bdops = {
 	.open = aoeblk_open,
 	.release = aoeblk_release,
 	.getgeo = aoeblk_getgeo,
diff -puN drivers/block/ataflop.c~const-make-block_device_operations-const drivers/block/ataflop.c
--- a/drivers/block/ataflop.c~const-make-block_device_operations-const
+++ a/drivers/block/ataflop.c
@@ -1856,7 +1856,7 @@ static int floppy_release(struct gendisk
 	return 0;
 }
 
-static struct block_device_operations floppy_fops = {
+static const struct block_device_operations floppy_fops = {
 	.owner		= THIS_MODULE,
 	.open		= floppy_open,
 	.release	= floppy_release,
diff -puN drivers/block/brd.c~const-make-block_device_operations-const drivers/block/brd.c
--- a/drivers/block/brd.c~const-make-block_device_operations-const
+++ a/drivers/block/brd.c
@@ -375,7 +375,7 @@ static int brd_ioctl(struct block_device
 	return error;
 }
 
-static struct block_device_operations brd_fops = {
+static const struct block_device_operations brd_fops = {
 	.owner =		THIS_MODULE,
 	.locked_ioctl =		brd_ioctl,
 #ifdef CONFIG_BLK_DEV_XIP
diff -puN drivers/block/cciss.c~const-make-block_device_operations-const drivers/block/cciss.c
--- a/drivers/block/cciss.c~const-make-block_device_operations-const
+++ a/drivers/block/cciss.c
@@ -205,7 +205,7 @@ static int cciss_compat_ioctl(struct blo
 			      unsigned, unsigned long);
 #endif
 
-static struct block_device_operations cciss_fops = {
+static const struct block_device_operations cciss_fops = {
 	.owner = THIS_MODULE,
 	.open = cciss_open,
 	.release = cciss_release,
diff -puN drivers/block/cpqarray.c~const-make-block_device_operations-const drivers/block/cpqarray.c
--- a/drivers/block/cpqarray.c~const-make-block_device_operations-const
+++ a/drivers/block/cpqarray.c
@@ -193,7 +193,7 @@ static inline ctlr_info_t *get_host(stru
 }
 
 
-static struct block_device_operations ida_fops  = {
+static const struct block_device_operations ida_fops  = {
 	.owner		= THIS_MODULE,
 	.open		= ida_open,
 	.release	= ida_release,
diff -puN drivers/block/floppy.c~const-make-block_device_operations-const drivers/block/floppy.c
--- a/drivers/block/floppy.c~const-make-block_device_operations-const
+++ a/drivers/block/floppy.c
@@ -3907,7 +3907,7 @@ static int floppy_revalidate(struct gend
 	return res;
 }
 
-static struct block_device_operations floppy_fops = {
+static const struct block_device_operations floppy_fops = {
 	.owner			= THIS_MODULE,
 	.open			= floppy_open,
 	.release		= floppy_release,
diff -puN drivers/block/hd.c~const-make-block_device_operations-const drivers/block/hd.c
--- a/drivers/block/hd.c~const-make-block_device_operations-const
+++ a/drivers/block/hd.c
@@ -692,7 +692,7 @@ static irqreturn_t hd_interrupt(int irq,
 	return IRQ_HANDLED;
 }
 
-static struct block_device_operations hd_fops = {
+static const struct block_device_operations hd_fops = {
 	.getgeo =	hd_getgeo,
 };
 
diff -puN drivers/block/loop.c~const-make-block_device_operations-const drivers/block/loop.c
--- a/drivers/block/loop.c~const-make-block_device_operations-const
+++ a/drivers/block/loop.c
@@ -1438,7 +1438,7 @@ out_unlocked:
 	return 0;
 }
 
-static struct block_device_operations lo_fops = {
+static const struct block_device_operations lo_fops = {
 	.owner =	THIS_MODULE,
 	.open =		lo_open,
 	.release =	lo_release,
diff -puN drivers/block/mg_disk.c~const-make-block_device_operations-const drivers/block/mg_disk.c
--- a/drivers/block/mg_disk.c~const-make-block_device_operations-const
+++ a/drivers/block/mg_disk.c
@@ -775,7 +775,7 @@ static int mg_getgeo(struct block_device
 	return 0;
 }
 
-static struct block_device_operations mg_disk_ops = {
+static const struct block_device_operations mg_disk_ops = {
 	.getgeo = mg_getgeo
 };
 
diff -puN drivers/block/nbd.c~const-make-block_device_operations-const drivers/block/nbd.c
--- a/drivers/block/nbd.c~const-make-block_device_operations-const
+++ a/drivers/block/nbd.c
@@ -722,7 +722,7 @@ static int nbd_ioctl(struct block_device
 	return error;
 }
 
-static struct block_device_operations nbd_fops =
+static const struct block_device_operations nbd_fops =
 {
 	.owner =	THIS_MODULE,
 	.locked_ioctl =	nbd_ioctl,
diff -puN drivers/block/osdblk.c~const-make-block_device_operations-const drivers/block/osdblk.c
--- a/drivers/block/osdblk.c~const-make-block_device_operations-const
+++ a/drivers/block/osdblk.c
@@ -125,7 +125,7 @@ static struct class *class_osdblk;		/* /
 static DEFINE_MUTEX(ctl_mutex);	/* Serialize open/close/setup/teardown */
 static LIST_HEAD(osdblkdev_list);
 
-static struct block_device_operations osdblk_bd_ops = {
+static const struct block_device_operations osdblk_bd_ops = {
 	.owner		= THIS_MODULE,
 };
 
diff -puN drivers/block/paride/pcd.c~const-make-block_device_operations-const drivers/block/paride/pcd.c
--- a/drivers/block/paride/pcd.c~const-make-block_device_operations-const
+++ a/drivers/block/paride/pcd.c
@@ -247,7 +247,7 @@ static int pcd_block_media_changed(struc
 	return cdrom_media_changed(&cd->info);
 }
 
-static struct block_device_operations pcd_bdops = {
+static const struct block_device_operations pcd_bdops = {
 	.owner		= THIS_MODULE,
 	.open		= pcd_block_open,
 	.release	= pcd_block_release,
diff -puN drivers/block/paride/pd.c~const-make-block_device_operations-const drivers/block/paride/pd.c
--- a/drivers/block/paride/pd.c~const-make-block_device_operations-const
+++ a/drivers/block/paride/pd.c
@@ -807,7 +807,7 @@ static int pd_revalidate(struct gendisk 
 	return 0;
 }
 
-static struct block_device_operations pd_fops = {
+static const struct block_device_operations pd_fops = {
 	.owner		= THIS_MODULE,
 	.open		= pd_open,
 	.release	= pd_release,
diff -puN drivers/block/paride/pf.c~const-make-block_device_operations-const drivers/block/paride/pf.c
--- a/drivers/block/paride/pf.c~const-make-block_device_operations-const
+++ a/drivers/block/paride/pf.c
@@ -262,7 +262,7 @@ static char *pf_buf;		/* buffer for requ
 
 /* kernel glue structures */
 
-static struct block_device_operations pf_fops = {
+static const struct block_device_operations pf_fops = {
 	.owner		= THIS_MODULE,
 	.open		= pf_open,
 	.release	= pf_release,
diff -puN drivers/block/pktcdvd.c~const-make-block_device_operations-const drivers/block/pktcdvd.c
--- a/drivers/block/pktcdvd.c~const-make-block_device_operations-const
+++ a/drivers/block/pktcdvd.c
@@ -2849,7 +2849,7 @@ static int pkt_media_changed(struct gend
 	return attached_disk->fops->media_changed(attached_disk);
 }
 
-static struct block_device_operations pktcdvd_ops = {
+static const struct block_device_operations pktcdvd_ops = {
 	.owner =		THIS_MODULE,
 	.open =			pkt_open,
 	.release =		pkt_close,
diff -puN drivers/block/ps3disk.c~const-make-block_device_operations-const drivers/block/ps3disk.c
--- a/drivers/block/ps3disk.c~const-make-block_device_operations-const
+++ a/drivers/block/ps3disk.c
@@ -82,7 +82,7 @@ enum lv1_ata_in_out {
 static int ps3disk_major;
 
 
-static struct block_device_operations ps3disk_fops = {
+static const struct block_device_operations ps3disk_fops = {
 	.owner		= THIS_MODULE,
 };
 
diff -puN drivers/block/ps3vram.c~const-make-block_device_operations-const drivers/block/ps3vram.c
--- a/drivers/block/ps3vram.c~const-make-block_device_operations-const
+++ a/drivers/block/ps3vram.c
@@ -88,7 +88,7 @@ struct ps3vram_priv {
 static int ps3vram_major;
 
 
-static struct block_device_operations ps3vram_fops = {
+static const struct block_device_operations ps3vram_fops = {
 	.owner		= THIS_MODULE,
 };
 
diff -puN drivers/block/sunvdc.c~const-make-block_device_operations-const drivers/block/sunvdc.c
--- a/drivers/block/sunvdc.c~const-make-block_device_operations-const
+++ a/drivers/block/sunvdc.c
@@ -103,7 +103,7 @@ static int vdc_getgeo(struct block_devic
 	return 0;
 }
 
-static struct block_device_operations vdc_fops = {
+static const struct block_device_operations vdc_fops = {
 	.owner		= THIS_MODULE,
 	.getgeo		= vdc_getgeo,
 };
diff -puN drivers/block/swim.c~const-make-block_device_operations-const drivers/block/swim.c
--- a/drivers/block/swim.c~const-make-block_device_operations-const
+++ a/drivers/block/swim.c
@@ -748,7 +748,7 @@ static int floppy_revalidate(struct gend
 	return !fs->disk_in;
 }
 
-static struct block_device_operations floppy_fops = {
+static const struct block_device_operations floppy_fops = {
 	.owner		 = THIS_MODULE,
 	.open		 = floppy_open,
 	.release	 = floppy_release,
diff -puN drivers/block/swim3.c~const-make-block_device_operations-const drivers/block/swim3.c
--- a/drivers/block/swim3.c~const-make-block_device_operations-const
+++ a/drivers/block/swim3.c
@@ -998,7 +998,7 @@ static int floppy_revalidate(struct gend
 	return ret;
 }
 
-static struct block_device_operations floppy_fops = {
+static const struct block_device_operations floppy_fops = {
 	.open		= floppy_open,
 	.release	= floppy_release,
 	.locked_ioctl	= floppy_ioctl,
diff -puN drivers/block/sx8.c~const-make-block_device_operations-const drivers/block/sx8.c
--- a/drivers/block/sx8.c~const-make-block_device_operations-const
+++ a/drivers/block/sx8.c
@@ -423,7 +423,7 @@ static struct pci_driver carm_driver = {
 	.remove		= carm_remove_one,
 };
 
-static struct block_device_operations carm_bd_ops = {
+static const struct block_device_operations carm_bd_ops = {
 	.owner		= THIS_MODULE,
 	.getgeo		= carm_bdev_getgeo,
 };
diff -puN drivers/block/ub.c~const-make-block_device_operations-const drivers/block/ub.c
--- a/drivers/block/ub.c~const-make-block_device_operations-const
+++ a/drivers/block/ub.c
@@ -1789,7 +1789,7 @@ static int ub_bd_media_changed(struct ge
 	return lun->changed;
 }
 
-static struct block_device_operations ub_bd_fops = {
+static const struct block_device_operations ub_bd_fops = {
 	.owner		= THIS_MODULE,
 	.open		= ub_bd_open,
 	.release	= ub_bd_release,
diff -puN drivers/block/umem.c~const-make-block_device_operations-const drivers/block/umem.c
--- a/drivers/block/umem.c~const-make-block_device_operations-const
+++ a/drivers/block/umem.c
@@ -140,7 +140,6 @@ struct cardinfo {
 };
 
 static struct cardinfo cards[MM_MAXCARDS];
-static struct block_device_operations mm_fops;
 static struct timer_list battery_timer;
 
 static int num_cards;
@@ -789,7 +788,7 @@ static int mm_check_change(struct gendis
 	return 0;
 }
 
-static struct block_device_operations mm_fops = {
+static const struct block_device_operations mm_fops = {
 	.owner		= THIS_MODULE,
 	.getgeo		= mm_getgeo,
 	.revalidate_disk = mm_revalidate,
diff -puN drivers/block/viodasd.c~const-make-block_device_operations-const drivers/block/viodasd.c
--- a/drivers/block/viodasd.c~const-make-block_device_operations-const
+++ a/drivers/block/viodasd.c
@@ -219,7 +219,7 @@ static int viodasd_getgeo(struct block_d
 /*
  * Our file operations table
  */
-static struct block_device_operations viodasd_fops = {
+static const struct block_device_operations viodasd_fops = {
 	.owner = THIS_MODULE,
 	.open = viodasd_open,
 	.release = viodasd_release,
diff -puN drivers/block/virtio_blk.c~const-make-block_device_operations-const drivers/block/virtio_blk.c
--- a/drivers/block/virtio_blk.c~const-make-block_device_operations-const
+++ a/drivers/block/virtio_blk.c
@@ -243,7 +243,7 @@ static int virtblk_getgeo(struct block_d
 	return 0;
 }
 
-static struct block_device_operations virtblk_fops = {
+static const struct block_device_operations virtblk_fops = {
 	.locked_ioctl = virtblk_ioctl,
 	.owner  = THIS_MODULE,
 	.getgeo = virtblk_getgeo,
diff -puN drivers/block/xd.c~const-make-block_device_operations-const drivers/block/xd.c
--- a/drivers/block/xd.c~const-make-block_device_operations-const
+++ a/drivers/block/xd.c
@@ -130,7 +130,7 @@ static struct gendisk *xd_gendisk[2];
 
 static int xd_getgeo(struct block_device *bdev, struct hd_geometry *geo);
 
-static struct block_device_operations xd_fops = {
+static const struct block_device_operations xd_fops = {
 	.owner	= THIS_MODULE,
 	.locked_ioctl	= xd_ioctl,
 	.getgeo = xd_getgeo,
diff -puN drivers/block/xen-blkfront.c~const-make-block_device_operations-const drivers/block/xen-blkfront.c
--- a/drivers/block/xen-blkfront.c~const-make-block_device_operations-const
+++ a/drivers/block/xen-blkfront.c
@@ -65,7 +65,7 @@ struct blk_shadow {
 	unsigned long frame[BLKIF_MAX_SEGMENTS_PER_REQUEST];
 };
 
-static struct block_device_operations xlvbd_block_fops;
+static const struct block_device_operations xlvbd_block_fops;
 
 #define BLK_RING_SIZE __RING_SIZE((struct blkif_sring *)0, PAGE_SIZE)
 
@@ -1039,7 +1039,7 @@ static int blkif_release(struct gendisk 
 	return 0;
 }
 
-static struct block_device_operations xlvbd_block_fops =
+static const struct block_device_operations xlvbd_block_fops =
 {
 	.owner = THIS_MODULE,
 	.open = blkif_open,
diff -puN drivers/block/xsysace.c~const-make-block_device_operations-const drivers/block/xsysace.c
--- a/drivers/block/xsysace.c~const-make-block_device_operations-const
+++ a/drivers/block/xsysace.c
@@ -941,7 +941,7 @@ static int ace_getgeo(struct block_devic
 	return 0;
 }
 
-static struct block_device_operations ace_fops = {
+static const struct block_device_operations ace_fops = {
 	.owner = THIS_MODULE,
 	.open = ace_open,
 	.release = ace_release,
diff -puN drivers/block/z2ram.c~const-make-block_device_operations-const drivers/block/z2ram.c
--- a/drivers/block/z2ram.c~const-make-block_device_operations-const
+++ a/drivers/block/z2ram.c
@@ -64,7 +64,6 @@ static int current_device   = -1;
 
 static DEFINE_SPINLOCK(z2ram_lock);
 
-static struct block_device_operations z2_fops;
 static struct gendisk *z2ram_gendisk;
 
 static void do_z2_request(struct request_queue *q)
@@ -315,7 +314,7 @@ z2_release(struct gendisk *disk, fmode_t
     return 0;
 }
 
-static struct block_device_operations z2_fops =
+static const struct block_device_operations z2_fops =
 {
 	.owner		= THIS_MODULE,
 	.open		= z2_open,
diff -puN drivers/cdrom/gdrom.c~const-make-block_device_operations-const drivers/cdrom/gdrom.c
--- a/drivers/cdrom/gdrom.c~const-make-block_device_operations-const
+++ a/drivers/cdrom/gdrom.c
@@ -512,7 +512,7 @@ static int gdrom_bdops_ioctl(struct bloc
 	return cdrom_ioctl(gd.cd_info, bdev, mode, cmd, arg);
 }
 
-static struct block_device_operations gdrom_bdops = {
+static const struct block_device_operations gdrom_bdops = {
 	.owner			= THIS_MODULE,
 	.open			= gdrom_bdops_open,
 	.release		= gdrom_bdops_release,
diff -puN drivers/cdrom/viocd.c~const-make-block_device_operations-const drivers/cdrom/viocd.c
--- a/drivers/cdrom/viocd.c~const-make-block_device_operations-const
+++ a/drivers/cdrom/viocd.c
@@ -177,7 +177,7 @@ static int viocd_blk_media_changed(struc
 	return cdrom_media_changed(&di->viocd_info);
 }
 
-struct block_device_operations viocd_fops = {
+static const struct block_device_operations viocd_fops = {
 	.owner =		THIS_MODULE,
 	.open =			viocd_blk_open,
 	.release =		viocd_blk_release,
diff -puN drivers/ide/ide-cd.c~const-make-block_device_operations-const drivers/ide/ide-cd.c
--- a/drivers/ide/ide-cd.c~const-make-block_device_operations-const
+++ a/drivers/ide/ide-cd.c
@@ -1686,7 +1686,7 @@ static int idecd_revalidate_disk(struct 
 	return  0;
 }
 
-static struct block_device_operations idecd_ops = {
+static const struct block_device_operations idecd_ops = {
 	.owner			= THIS_MODULE,
 	.open			= idecd_open,
 	.release		= idecd_release,
diff -puN drivers/ide/ide-gd.c~const-make-block_device_operations-const drivers/ide/ide-gd.c
--- a/drivers/ide/ide-gd.c~const-make-block_device_operations-const
+++ a/drivers/ide/ide-gd.c
@@ -321,7 +321,7 @@ static int ide_gd_ioctl(struct block_dev
 	return drive->disk_ops->ioctl(drive, bdev, mode, cmd, arg);
 }
 
-static struct block_device_operations ide_gd_ops = {
+static const struct block_device_operations ide_gd_ops = {
 	.owner			= THIS_MODULE,
 	.open			= ide_gd_open,
 	.release		= ide_gd_release,
diff -puN drivers/ide/ide-tape.c~const-make-block_device_operations-const drivers/ide/ide-tape.c
--- a/drivers/ide/ide-tape.c~const-make-block_device_operations-const
+++ a/drivers/ide/ide-tape.c
@@ -1913,7 +1913,7 @@ static int idetape_ioctl(struct block_de
 	return err;
 }
 
-static struct block_device_operations idetape_block_ops = {
+static const struct block_device_operations idetape_block_ops = {
 	.owner		= THIS_MODULE,
 	.open		= idetape_open,
 	.release	= idetape_release,
diff -puN drivers/md/dm.c~const-make-block_device_operations-const drivers/md/dm.c
--- a/drivers/md/dm.c~const-make-block_device_operations-const
+++ a/drivers/md/dm.c
@@ -1716,7 +1716,7 @@ out:
 	return r;
 }
 
-static struct block_device_operations dm_blk_dops;
+static const struct block_device_operations dm_blk_dops;
 
 static void dm_wq_work(struct work_struct *work);
 
@@ -2663,7 +2663,7 @@ void dm_free_md_mempools(struct dm_md_me
 	kfree(pools);
 }
 
-static struct block_device_operations dm_blk_dops = {
+static const struct block_device_operations dm_blk_dops = {
 	.open = dm_blk_open,
 	.release = dm_blk_close,
 	.ioctl = dm_blk_ioctl,
diff -puN drivers/md/md.c~const-make-block_device_operations-const drivers/md/md.c
--- a/drivers/md/md.c~const-make-block_device_operations-const
+++ a/drivers/md/md.c
@@ -138,7 +138,7 @@ static ctl_table raid_root_table[] = {
 	{ .ctl_name = 0 }
 };
 
-static struct block_device_operations md_fops;
+static const struct block_device_operations md_fops;
 
 static int start_readonly;
 
@@ -5556,7 +5556,7 @@ static int md_revalidate(struct gendisk 
 	mddev->changed = 0;
 	return 0;
 }
-static struct block_device_operations md_fops =
+static const struct block_device_operations md_fops =
 {
 	.owner		= THIS_MODULE,
 	.open		= md_open,
diff -puN drivers/memstick/core/mspro_block.c~const-make-block_device_operations-const drivers/memstick/core/mspro_block.c
--- a/drivers/memstick/core/mspro_block.c~const-make-block_device_operations-const
+++ a/drivers/memstick/core/mspro_block.c
@@ -235,7 +235,7 @@ static int mspro_block_bd_getgeo(struct 
 	return 0;
 }
 
-static struct block_device_operations ms_block_bdops = {
+static const struct block_device_operations ms_block_bdops = {
 	.open    = mspro_block_bd_open,
 	.release = mspro_block_bd_release,
 	.getgeo  = mspro_block_bd_getgeo,
diff -puN drivers/message/i2o/i2o_block.c~const-make-block_device_operations-const drivers/message/i2o/i2o_block.c
--- a/drivers/message/i2o/i2o_block.c~const-make-block_device_operations-const
+++ a/drivers/message/i2o/i2o_block.c
@@ -925,7 +925,7 @@ static void i2o_block_request_fn(struct 
 };
 
 /* I2O Block device operations definition */
-static struct block_device_operations i2o_block_fops = {
+static const struct block_device_operations i2o_block_fops = {
 	.owner = THIS_MODULE,
 	.open = i2o_block_open,
 	.release = i2o_block_release,
diff -puN drivers/mmc/card/block.c~const-make-block_device_operations-const drivers/mmc/card/block.c
--- a/drivers/mmc/card/block.c~const-make-block_device_operations-const
+++ a/drivers/mmc/card/block.c
@@ -130,7 +130,7 @@ mmc_blk_getgeo(struct block_device *bdev
 	return 0;
 }
 
-static struct block_device_operations mmc_bdops = {
+static const struct block_device_operations mmc_bdops = {
 	.open			= mmc_blk_open,
 	.release		= mmc_blk_release,
 	.getgeo			= mmc_blk_getgeo,
diff -puN drivers/mtd/mtd_blkdevs.c~const-make-block_device_operations-const drivers/mtd/mtd_blkdevs.c
--- a/drivers/mtd/mtd_blkdevs.c~const-make-block_device_operations-const
+++ a/drivers/mtd/mtd_blkdevs.c
@@ -210,7 +210,7 @@ static int blktrans_ioctl(struct block_d
 	}
 }
 
-static struct block_device_operations mtd_blktrans_ops = {
+static const struct block_device_operations mtd_blktrans_ops = {
 	.owner		= THIS_MODULE,
 	.open		= blktrans_open,
 	.release	= blktrans_release,
diff -puN drivers/s390/block/dasd.c~const-make-block_device_operations-const drivers/s390/block/dasd.c
--- a/drivers/s390/block/dasd.c~const-make-block_device_operations-const
+++ a/drivers/s390/block/dasd.c
@@ -2146,7 +2146,7 @@ static int dasd_getgeo(struct block_devi
 	return 0;
 }
 
-struct block_device_operations
+const struct block_device_operations
 dasd_device_operations = {
 	.owner		= THIS_MODULE,
 	.open		= dasd_open,
diff -puN drivers/s390/block/dasd_int.h~const-make-block_device_operations-const drivers/s390/block/dasd_int.h
--- a/drivers/s390/block/dasd_int.h~const-make-block_device_operations-const
+++ a/drivers/s390/block/dasd_int.h
@@ -540,7 +540,7 @@ dasd_check_blocksize(int bsize)
 extern debug_info_t *dasd_debug_area;
 extern struct dasd_profile_info_t dasd_global_profile;
 extern unsigned int dasd_profile_level;
-extern struct block_device_operations dasd_device_operations;
+extern const struct block_device_operations dasd_device_operations;
 
 extern struct kmem_cache *dasd_page_cache;
 
diff -puN drivers/s390/block/dcssblk.c~const-make-block_device_operations-const drivers/s390/block/dcssblk.c
--- a/drivers/s390/block/dcssblk.c~const-make-block_device_operations-const
+++ a/drivers/s390/block/dcssblk.c
@@ -34,7 +34,7 @@ static int dcssblk_direct_access(struct 
 static char dcssblk_segments[DCSSBLK_PARM_LEN] = "\0";
 
 static int dcssblk_major;
-static struct block_device_operations dcssblk_devops = {
+static const struct block_device_operations dcssblk_devops = {
 	.owner   	= THIS_MODULE,
 	.open    	= dcssblk_open,
 	.release 	= dcssblk_release,
diff -puN drivers/s390/block/xpram.c~const-make-block_device_operations-const drivers/s390/block/xpram.c
--- a/drivers/s390/block/xpram.c~const-make-block_device_operations-const
+++ a/drivers/s390/block/xpram.c
@@ -244,7 +244,7 @@ static int xpram_getgeo(struct block_dev
 	return 0;
 }
 
-static struct block_device_operations xpram_devops =
+static const struct block_device_operations xpram_devops =
 {
 	.owner	= THIS_MODULE,
 	.getgeo	= xpram_getgeo,
diff -puN drivers/s390/char/tape_block.c~const-make-block_device_operations-const drivers/s390/char/tape_block.c
--- a/drivers/s390/char/tape_block.c~const-make-block_device_operations-const
+++ a/drivers/s390/char/tape_block.c
@@ -50,7 +50,7 @@ static int tapeblock_ioctl(struct block_
 static int tapeblock_medium_changed(struct gendisk *);
 static int tapeblock_revalidate_disk(struct gendisk *);
 
-static struct block_device_operations tapeblock_fops = {
+static const struct block_device_operations tapeblock_fops = {
 	.owner		 = THIS_MODULE,
 	.open		 = tapeblock_open,
 	.release	 = tapeblock_release,
diff -puN drivers/sbus/char/jsflash.c~const-make-block_device_operations-const drivers/sbus/char/jsflash.c
--- a/drivers/sbus/char/jsflash.c~const-make-block_device_operations-const
+++ a/drivers/sbus/char/jsflash.c
@@ -452,7 +452,7 @@ static const struct file_operations jsf_
 
 static struct miscdevice jsf_dev = { JSF_MINOR, "jsflash", &jsf_fops };
 
-static struct block_device_operations jsfd_fops = {
+static const struct block_device_operations jsfd_fops = {
 	.owner =	THIS_MODULE,
 };
 
diff -puN drivers/scsi/sd.c~const-make-block_device_operations-const drivers/scsi/sd.c
--- a/drivers/scsi/sd.c~const-make-block_device_operations-const
+++ a/drivers/scsi/sd.c
@@ -956,7 +956,7 @@ static int sd_compat_ioctl(struct block_
 }
 #endif
 
-static struct block_device_operations sd_fops = {
+static const struct block_device_operations sd_fops = {
 	.owner			= THIS_MODULE,
 	.open			= sd_open,
 	.release		= sd_release,
diff -puN drivers/scsi/sr.c~const-make-block_device_operations-const drivers/scsi/sr.c
--- a/drivers/scsi/sr.c~const-make-block_device_operations-const
+++ a/drivers/scsi/sr.c
@@ -525,7 +525,7 @@ static int sr_block_media_changed(struct
 	return cdrom_media_changed(&cd->cdi);
 }
 
-static struct block_device_operations sr_bdops =
+static const struct block_device_operations sr_bdops =
 {
 	.owner		= THIS_MODULE,
 	.open		= sr_block_open,
diff -puN fs/block_dev.c~const-make-block_device_operations-const fs/block_dev.c
--- a/fs/block_dev.c~const-make-block_device_operations-const
+++ a/fs/block_dev.c
@@ -1114,7 +1114,7 @@ EXPORT_SYMBOL(revalidate_disk);
 int check_disk_change(struct block_device *bdev)
 {
 	struct gendisk *disk = bdev->bd_disk;
-	struct block_device_operations * bdops = disk->fops;
+	const struct block_device_operations *bdops = disk->fops;
 
 	if (!bdops->media_changed)
 		return 0;
diff -puN fs/ext2/xip.c~const-make-block_device_operations-const fs/ext2/xip.c
--- a/fs/ext2/xip.c~const-make-block_device_operations-const
+++ a/fs/ext2/xip.c
@@ -20,7 +20,7 @@ __inode_direct_access(struct inode *inod
 		      void **kaddr, unsigned long *pfn)
 {
 	struct block_device *bdev = inode->i_sb->s_bdev;
-	struct block_device_operations *ops = bdev->bd_disk->fops;
+	const struct block_device_operations *ops = bdev->bd_disk->fops;
 	sector_t sector;
 
 	sector = block * (PAGE_SIZE / 512); /* ext2 block to bdev sector */
diff -puN fs/partitions/check.c~const-make-block_device_operations-const fs/partitions/check.c
--- a/fs/partitions/check.c~const-make-block_device_operations-const
+++ a/fs/partitions/check.c
@@ -581,7 +581,7 @@ try_scan:
 		}
 
 		if (from + size > get_capacity(disk)) {
-			struct block_device_operations *bdops = disk->fops;
+			const struct block_device_operations *bdops = disk->fops;
 			unsigned long long capacity;
 
 			printk(KERN_WARNING
diff -puN include/linux/genhd.h~const-make-block_device_operations-const include/linux/genhd.h
--- a/include/linux/genhd.h~const-make-block_device_operations-const
+++ a/include/linux/genhd.h
@@ -151,7 +151,7 @@ struct gendisk {
 	struct disk_part_tbl *part_tbl;
 	struct hd_struct part0;
 
-	struct block_device_operations *fops;
+	const struct block_device_operations *fops;
 	struct request_queue *queue;
 	void *private_data;
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
acpi-switch-proc-acpi-debug_layerdebug_level-to-seq_file.patch
genirq-switch-proc-irq-spurious-to-seq_file.patch
cpqarray-switch-to-seq_file.patch
dac960-switch-to-seq_file.patch
proc_flush_task-flush-proc-tid-task-pid-when-a-sub-thread-exits.patch
procfs-provide-stack-information-for-threads-v08.patch
procfs-provide-stack-information-for-threads-v011.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
viafb-switch-to-seq_file.patch
reiserfs-remove-proc-fs-reiserfs-version.patch
reiserfs-dont-compile-procfso-at-all-if-no-support.patch
sysctl-remove-struct-file-argument-of-proc_handler.patch
aio-ifdef-fields-in-mm_struct.patch
gru-use-proc_create.patch

