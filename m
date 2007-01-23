From: akpm@osdl.org
Subject: + mark-struct-file_operations-const-3.patch added to -mm tree
Date: Tue, 23 Jan 2007 11:32:01 -0800
Message-ID: <200701231932.l0NJW1aG028982@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50762 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933126AbXAWTcI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 14:32:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com


The patch titled
     mark struct file_operations const 3
has been added to the -mm tree.  Its filename is
     mark-struct-file_operations-const-3.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mark struct file_operations const 3
From: Arjan van de Ven <arjan@linux.intel.com>

Many struct file_operations in the kernel can be "const".  Marking them const
moves these to the .rodata section, which avoids false sharing with potential
dirty data.  In addition it'll catch accidental writes at compile time to
these shared resources.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 block/blktrace.c                             |    2 +-
 crypto/proc.c                                |    2 +-
 drivers/acorn/char/i2c.c                     |    2 +-
 drivers/block/DAC960.c                       |    2 +-
 drivers/block/acsi_slm.c                     |    2 +-
 drivers/block/aoe/aoechr.c                   |    2 +-
 drivers/block/paride/pg.c                    |    2 +-
 drivers/block/paride/pt.c                    |    2 +-
 drivers/block/pktcdvd.c                      |    6 +++---
 drivers/bluetooth/hci_vhci.c                 |    2 +-
 drivers/cdrom/viocd.c                        |    2 +-
 drivers/char/briq_panel.c                    |    2 +-
 drivers/char/drm/drm_drv.c                   |    2 +-
 drivers/char/drm/i810_dma.c                  |    2 +-
 drivers/char/drm/i830_dma.c                  |    2 +-
 drivers/char/generic_nvram.c                 |    2 +-
 drivers/char/mbcs.c                          |    2 +-
 drivers/char/mspec.c                         |    6 +++---
 drivers/char/random.c                        |    4 ++--
 drivers/char/tpm/tpm_bios.c                  |    4 ++--
 drivers/char/viotape.c                       |    2 +-
 drivers/char/watchdog/iTCO_wdt.c             |    2 +-
 drivers/char/watchdog/omap_wdt.c             |    2 +-
 drivers/char/watchdog/pc87413_wdt.c          |    2 +-
 drivers/char/watchdog/pnx4008_wdt.c          |    2 +-
 drivers/char/watchdog/rm9k_wdt.c             |    2 +-
 drivers/char/watchdog/smsc37b787_wdt.c       |    2 +-
 drivers/char/watchdog/w83697hf_wdt.c         |    2 +-
 drivers/i2c/chips/tps65010.c                 |    2 +-
 drivers/i2c/i2c-dev.c                        |    2 +-
 drivers/ide/ide-proc.c                       |    2 +-
 drivers/ide/ide-tape.c                       |    2 +-
 drivers/ieee1394/dv1394.c                    |    2 +-
 drivers/ieee1394/raw1394.c                   |    2 +-
 drivers/ieee1394/video1394.c                 |    2 +-
 drivers/infiniband/core/ucm.c                |    2 +-
 drivers/infiniband/core/ucma.c               |    2 +-
 drivers/infiniband/core/user_mad.c           |    4 ++--
 drivers/infiniband/core/uverbs_main.c        |    6 +++---
 drivers/infiniband/hw/ipath/ipath_diag.c     |    4 ++--
 drivers/infiniband/hw/ipath/ipath_file_ops.c |    6 +++---
 drivers/infiniband/hw/ipath/ipath_fs.c       |   14 +++++++-------
 drivers/infiniband/hw/ipath/ipath_kernel.h   |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_fs.c      |    4 ++--
 drivers/input/input.c                        |    6 +++---
 drivers/input/misc/hp_sdc_rtc.c              |    2 +-
 drivers/input/misc/uinput.c                  |    2 +-
 drivers/input/serio/serio_raw.c              |    2 +-
 drivers/isdn/capi/capi.c                     |    2 +-
 drivers/isdn/capi/kcapi_proc.c               |   10 +++++-----
 drivers/isdn/divert/divert_procfs.c          |    2 +-
 drivers/isdn/hardware/eicon/divamnt.c        |    2 +-
 drivers/isdn/hardware/eicon/divasi.c         |    2 +-
 drivers/isdn/hardware/eicon/divasmain.c      |    2 +-
 drivers/isdn/hardware/eicon/divasproc.c      |    2 +-
 drivers/isdn/hysdn/hysdn_procconf.c          |    2 +-
 drivers/isdn/hysdn/hysdn_proclog.c           |    2 +-
 drivers/isdn/i4l/isdn_common.c               |    2 +-
 58 files changed, 83 insertions(+), 83 deletions(-)

diff -puN block/blktrace.c~mark-struct-file_operations-const-3 block/blktrace.c
--- a/block/blktrace.c~mark-struct-file_operations-const-3
+++ a/block/blktrace.c
@@ -264,7 +264,7 @@ static ssize_t blk_dropped_read(struct f
 	return simple_read_from_buffer(buffer, count, ppos, buf, strlen(buf));
 }
 
-static struct file_operations blk_dropped_fops = {
+static const struct file_operations blk_dropped_fops = {
 	.owner =	THIS_MODULE,
 	.open =		blk_dropped_open,
 	.read =		blk_dropped_read,
diff -puN crypto/proc.c~mark-struct-file_operations-const-3 crypto/proc.c
--- a/crypto/proc.c~mark-struct-file_operations-const-3
+++ a/crypto/proc.c
@@ -101,7 +101,7 @@ static int crypto_info_open(struct inode
 	return seq_open(file, &crypto_seq_ops);
 }
         
-static struct file_operations proc_crypto_ops = {
+static const struct file_operations proc_crypto_ops = {
 	.open		= crypto_info_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
diff -puN drivers/acorn/char/i2c.c~mark-struct-file_operations-const-3 drivers/acorn/char/i2c.c
--- a/drivers/acorn/char/i2c.c~mark-struct-file_operations-const-3
+++ a/drivers/acorn/char/i2c.c
@@ -237,7 +237,7 @@ static int rtc_ioctl(struct inode *inode
 	return -EINVAL;
 }
 
-static struct file_operations rtc_fops = {
+static const struct file_operations rtc_fops = {
 	.ioctl	= rtc_ioctl,
 };
 
diff -puN drivers/block/DAC960.c~mark-struct-file_operations-const-3 drivers/block/DAC960.c
--- a/drivers/block/DAC960.c~mark-struct-file_operations-const-3
+++ a/drivers/block/DAC960.c
@@ -7024,7 +7024,7 @@ static int DAC960_gam_ioctl(struct inode
   return -EINVAL;
 }
 
-static struct file_operations DAC960_gam_fops = {
+static const struct file_operations DAC960_gam_fops = {
 	.owner		= THIS_MODULE,
 	.ioctl		= DAC960_gam_ioctl
 };
diff -puN drivers/block/acsi_slm.c~mark-struct-file_operations-const-3 drivers/block/acsi_slm.c
--- a/drivers/block/acsi_slm.c~mark-struct-file_operations-const-3
+++ a/drivers/block/acsi_slm.c
@@ -269,7 +269,7 @@ static int slm_get_pagesize( int device,
 
 static DEFINE_TIMER(slm_timer, slm_test_ready, 0, 0);
 
-static struct file_operations slm_fops = {
+static const struct file_operations slm_fops = {
 	.owner =	THIS_MODULE,
 	.read =		slm_read,
 	.write =	slm_write,
diff -puN drivers/block/aoe/aoechr.c~mark-struct-file_operations-const-3 drivers/block/aoe/aoechr.c
--- a/drivers/block/aoe/aoechr.c~mark-struct-file_operations-const-3
+++ a/drivers/block/aoe/aoechr.c
@@ -233,7 +233,7 @@ loop:
 	}
 }
 
-static struct file_operations aoe_fops = {
+static const struct file_operations aoe_fops = {
 	.write = aoechr_write,
 	.read = aoechr_read,
 	.open = aoechr_open,
diff -puN drivers/block/paride/pg.c~mark-struct-file_operations-const-3 drivers/block/paride/pg.c
--- a/drivers/block/paride/pg.c~mark-struct-file_operations-const-3
+++ a/drivers/block/paride/pg.c
@@ -227,7 +227,7 @@ static struct class *pg_class;
 
 /* kernel glue structures */
 
-static struct file_operations pg_fops = {
+static const struct file_operations pg_fops = {
 	.owner = THIS_MODULE,
 	.read = pg_read,
 	.write = pg_write,
diff -puN drivers/block/paride/pt.c~mark-struct-file_operations-const-3 drivers/block/paride/pt.c
--- a/drivers/block/paride/pt.c~mark-struct-file_operations-const-3
+++ a/drivers/block/paride/pt.c
@@ -232,7 +232,7 @@ static char pt_scratch[512];	/* scratch 
 
 /* kernel glue structures */
 
-static struct file_operations pt_fops = {
+static const struct file_operations pt_fops = {
 	.owner = THIS_MODULE,
 	.read = pt_read,
 	.write = pt_write,
diff -puN drivers/block/pktcdvd.c~mark-struct-file_operations-const-3 drivers/block/pktcdvd.c
--- a/drivers/block/pktcdvd.c~mark-struct-file_operations-const-3
+++ a/drivers/block/pktcdvd.c
@@ -435,7 +435,7 @@ static int pkt_debugfs_fops_open(struct 
 	return single_open(file, pkt_debugfs_seq_show, inode->i_private);
 }
 
-static struct file_operations debug_fops = {
+static const struct file_operations debug_fops = {
 	.open		= pkt_debugfs_fops_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -2723,7 +2723,7 @@ static int pkt_seq_open(struct inode *in
 	return single_open(file, pkt_seq_show, PDE(inode)->data);
 }
 
-static struct file_operations pkt_proc_fops = {
+static const struct file_operations pkt_proc_fops = {
 	.open	= pkt_seq_open,
 	.read	= seq_read,
 	.llseek	= seq_lseek,
@@ -3050,7 +3050,7 @@ static int pkt_ctl_ioctl(struct inode *i
 }
 
 
-static struct file_operations pkt_ctl_fops = {
+static const struct file_operations pkt_ctl_fops = {
 	.ioctl	 = pkt_ctl_ioctl,
 	.owner	 = THIS_MODULE,
 };
diff -puN drivers/bluetooth/hci_vhci.c~mark-struct-file_operations-const-3 drivers/bluetooth/hci_vhci.c
--- a/drivers/bluetooth/hci_vhci.c~mark-struct-file_operations-const-3
+++ a/drivers/bluetooth/hci_vhci.c
@@ -332,7 +332,7 @@ static int vhci_fasync(int fd, struct fi
 	return 0;
 }
 
-static struct file_operations vhci_fops = {
+static const struct file_operations vhci_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= vhci_llseek,
 	.read		= vhci_read,
diff -puN drivers/cdrom/viocd.c~mark-struct-file_operations-const-3 drivers/cdrom/viocd.c
--- a/drivers/cdrom/viocd.c~mark-struct-file_operations-const-3
+++ a/drivers/cdrom/viocd.c
@@ -176,7 +176,7 @@ static int proc_viocd_open(struct inode 
 	return single_open(file, proc_viocd_show, NULL);
 }
 
-static struct file_operations proc_viocd_operations = {
+static const struct file_operations proc_viocd_operations = {
 	.open		= proc_viocd_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
diff -puN drivers/char/briq_panel.c~mark-struct-file_operations-const-3 drivers/char/briq_panel.c
--- a/drivers/char/briq_panel.c~mark-struct-file_operations-const-3
+++ a/drivers/char/briq_panel.c
@@ -186,7 +186,7 @@ static ssize_t briq_panel_write(struct f
 	return len;
 }
 
-static struct file_operations briq_panel_fops = {
+static const struct file_operations briq_panel_fops = {
 	.owner		= THIS_MODULE,
 	.read		= briq_panel_read,
 	.write		= briq_panel_write,
diff -puN drivers/char/drm/drm_drv.c~mark-struct-file_operations-const-3 drivers/char/drm/drm_drv.c
--- a/drivers/char/drm/drm_drv.c~mark-struct-file_operations-const-3
+++ a/drivers/char/drm/drm_drv.c
@@ -371,7 +371,7 @@ void drm_exit(struct drm_driver *driver)
 EXPORT_SYMBOL(drm_exit);
 
 /** File operations structure */
-static struct file_operations drm_stub_fops = {
+static const struct file_operations drm_stub_fops = {
 	.owner = THIS_MODULE,
 	.open = drm_stub_open
 };
diff -puN drivers/char/drm/i810_dma.c~mark-struct-file_operations-const-3 drivers/char/drm/i810_dma.c
--- a/drivers/char/drm/i810_dma.c~mark-struct-file_operations-const-3
+++ a/drivers/char/drm/i810_dma.c
@@ -112,7 +112,7 @@ static int i810_mmap_buffers(struct file
 	return 0;
 }
 
-static struct file_operations i810_buffer_fops = {
+static const struct file_operations i810_buffer_fops = {
 	.open = drm_open,
 	.release = drm_release,
 	.ioctl = drm_ioctl,
diff -puN drivers/char/drm/i830_dma.c~mark-struct-file_operations-const-3 drivers/char/drm/i830_dma.c
--- a/drivers/char/drm/i830_dma.c~mark-struct-file_operations-const-3
+++ a/drivers/char/drm/i830_dma.c
@@ -114,7 +114,7 @@ static int i830_mmap_buffers(struct file
 	return 0;
 }
 
-static struct file_operations i830_buffer_fops = {
+static const struct file_operations i830_buffer_fops = {
 	.open = drm_open,
 	.release = drm_release,
 	.ioctl = drm_ioctl,
diff -puN drivers/char/generic_nvram.c~mark-struct-file_operations-const-3 drivers/char/generic_nvram.c
--- a/drivers/char/generic_nvram.c~mark-struct-file_operations-const-3
+++ a/drivers/char/generic_nvram.c
@@ -117,7 +117,7 @@ static int nvram_ioctl(struct inode *ino
 	return 0;
 }
 
-struct file_operations nvram_fops = {
+const struct file_operations nvram_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= nvram_llseek,
 	.read		= read_nvram,
diff -puN drivers/char/mbcs.c~mark-struct-file_operations-const-3 drivers/char/mbcs.c
--- a/drivers/char/mbcs.c~mark-struct-file_operations-const-3
+++ a/drivers/char/mbcs.c
@@ -46,7 +46,7 @@ LIST_HEAD(soft_list);
 /*
  * file operations
  */
-struct file_operations mbcs_ops = {
+const struct file_operations mbcs_ops = {
 	.open = mbcs_open,
 	.llseek = mbcs_sram_llseek,
 	.read = mbcs_sram_read,
diff -puN drivers/char/mspec.c~mark-struct-file_operations-const-3 drivers/char/mspec.c
--- a/drivers/char/mspec.c~mark-struct-file_operations-const-3
+++ a/drivers/char/mspec.c
@@ -291,7 +291,7 @@ uncached_mmap(struct file *file, struct 
 	return mspec_mmap(file, vma, MSPEC_UNCACHED);
 }
 
-static struct file_operations fetchop_fops = {
+static const struct file_operations fetchop_fops = {
 	.owner = THIS_MODULE,
 	.mmap = fetchop_mmap
 };
@@ -302,7 +302,7 @@ static struct miscdevice fetchop_miscdev
 	.fops = &fetchop_fops
 };
 
-static struct file_operations cached_fops = {
+static const struct file_operations cached_fops = {
 	.owner = THIS_MODULE,
 	.mmap = cached_mmap
 };
@@ -313,7 +313,7 @@ static struct miscdevice cached_miscdev 
 	.fops = &cached_fops
 };
 
-static struct file_operations uncached_fops = {
+static const struct file_operations uncached_fops = {
 	.owner = THIS_MODULE,
 	.mmap = uncached_mmap
 };
diff -puN drivers/char/random.c~mark-struct-file_operations-const-3 drivers/char/random.c
--- a/drivers/char/random.c~mark-struct-file_operations-const-3
+++ a/drivers/char/random.c
@@ -1117,14 +1117,14 @@ random_ioctl(struct inode * inode, struc
 	}
 }
 
-struct file_operations random_fops = {
+const struct file_operations random_fops = {
 	.read  = random_read,
 	.write = random_write,
 	.poll  = random_poll,
 	.ioctl = random_ioctl,
 };
 
-struct file_operations urandom_fops = {
+const struct file_operations urandom_fops = {
 	.read  = urandom_read,
 	.write = random_write,
 	.ioctl = random_ioctl,
diff -puN drivers/char/tpm/tpm_bios.c~mark-struct-file_operations-const-3 drivers/char/tpm/tpm_bios.c
--- a/drivers/char/tpm/tpm_bios.c~mark-struct-file_operations-const-3
+++ a/drivers/char/tpm/tpm_bios.c
@@ -443,7 +443,7 @@ static int tpm_ascii_bios_measurements_o
 	return err;
 }
 
-struct file_operations tpm_ascii_bios_measurements_ops = {
+const struct file_operations tpm_ascii_bios_measurements_ops = {
 	.open = tpm_ascii_bios_measurements_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -476,7 +476,7 @@ static int tpm_binary_bios_measurements_
 	return err;
 }
 
-struct file_operations tpm_binary_bios_measurements_ops = {
+const struct file_operations tpm_binary_bios_measurements_ops = {
 	.open = tpm_binary_bios_measurements_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
diff -puN drivers/char/viotape.c~mark-struct-file_operations-const-3 drivers/char/viotape.c
--- a/drivers/char/viotape.c~mark-struct-file_operations-const-3
+++ a/drivers/char/viotape.c
@@ -872,7 +872,7 @@ free_op:
 	return ret;
 }
 
-struct file_operations viotap_fops = {
+const struct file_operations viotap_fops = {
 	owner: THIS_MODULE,
 	read: viotap_read,
 	write: viotap_write,
diff -puN drivers/char/watchdog/iTCO_wdt.c~mark-struct-file_operations-const-3 drivers/char/watchdog/iTCO_wdt.c
--- a/drivers/char/watchdog/iTCO_wdt.c~mark-struct-file_operations-const-3
+++ a/drivers/char/watchdog/iTCO_wdt.c
@@ -539,7 +539,7 @@ static int iTCO_wdt_ioctl (struct inode 
  *	Kernel Interfaces
  */
 
-static struct file_operations iTCO_wdt_fops = {
+static const struct file_operations iTCO_wdt_fops = {
 	.owner =	THIS_MODULE,
 	.llseek =	no_llseek,
 	.write =	iTCO_wdt_write,
diff -puN drivers/char/watchdog/omap_wdt.c~mark-struct-file_operations-const-3 drivers/char/watchdog/omap_wdt.c
--- a/drivers/char/watchdog/omap_wdt.c~mark-struct-file_operations-const-3
+++ a/drivers/char/watchdog/omap_wdt.c
@@ -230,7 +230,7 @@ omap_wdt_ioctl(struct inode *inode, stru
 	}
 }
 
-static struct file_operations omap_wdt_fops = {
+static const struct file_operations omap_wdt_fops = {
 	.owner = THIS_MODULE,
 	.write = omap_wdt_write,
 	.ioctl = omap_wdt_ioctl,
diff -puN drivers/char/watchdog/pc87413_wdt.c~mark-struct-file_operations-const-3 drivers/char/watchdog/pc87413_wdt.c
--- a/drivers/char/watchdog/pc87413_wdt.c~mark-struct-file_operations-const-3
+++ a/drivers/char/watchdog/pc87413_wdt.c
@@ -526,7 +526,7 @@ static int pc87413_notify_sys(struct not
 
 /* -- Module's structures ---------------------------------------*/
 
-static struct file_operations pc87413_fops = {
+static const struct file_operations pc87413_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= pc87413_write,
diff -puN drivers/char/watchdog/pnx4008_wdt.c~mark-struct-file_operations-const-3 drivers/char/watchdog/pnx4008_wdt.c
--- a/drivers/char/watchdog/pnx4008_wdt.c~mark-struct-file_operations-const-3
+++ a/drivers/char/watchdog/pnx4008_wdt.c
@@ -238,7 +238,7 @@ static int pnx4008_wdt_release(struct in
 	return 0;
 }
 
-static struct file_operations pnx4008_wdt_fops = {
+static const struct file_operations pnx4008_wdt_fops = {
 	.owner = THIS_MODULE,
 	.llseek = no_llseek,
 	.write = pnx4008_wdt_write,
diff -puN drivers/char/watchdog/rm9k_wdt.c~mark-struct-file_operations-const-3 drivers/char/watchdog/rm9k_wdt.c
--- a/drivers/char/watchdog/rm9k_wdt.c~mark-struct-file_operations-const-3
+++ a/drivers/char/watchdog/rm9k_wdt.c
@@ -95,7 +95,7 @@ MODULE_PARM_DESC(nowayout, "Watchdog can
 
 
 /* Kernel interfaces */
-static struct file_operations fops = {
+static const struct file_operations fops = {
 	.owner		= THIS_MODULE,
 	.open		= wdt_gpi_open,
 	.release	= wdt_gpi_release,
diff -puN drivers/char/watchdog/smsc37b787_wdt.c~mark-struct-file_operations-const-3 drivers/char/watchdog/smsc37b787_wdt.c
--- a/drivers/char/watchdog/smsc37b787_wdt.c~mark-struct-file_operations-const-3
+++ a/drivers/char/watchdog/smsc37b787_wdt.c
@@ -510,7 +510,7 @@ static int wb_smsc_wdt_notify_sys(struct
 
 /* -- Module's structures ---------------------------------------*/
 
-static struct file_operations wb_smsc_wdt_fops =
+static const struct file_operations wb_smsc_wdt_fops =
 {
 	.owner          = THIS_MODULE,
 	.llseek		= no_llseek,
diff -puN drivers/char/watchdog/w83697hf_wdt.c~mark-struct-file_operations-const-3 drivers/char/watchdog/w83697hf_wdt.c
--- a/drivers/char/watchdog/w83697hf_wdt.c~mark-struct-file_operations-const-3
+++ a/drivers/char/watchdog/w83697hf_wdt.c
@@ -323,7 +323,7 @@ wdt_notify_sys(struct notifier_block *th
  *	Kernel Interfaces
  */
 
-static struct file_operations wdt_fops = {
+static const struct file_operations wdt_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= wdt_write,
diff -puN drivers/i2c/chips/tps65010.c~mark-struct-file_operations-const-3 drivers/i2c/chips/tps65010.c
--- a/drivers/i2c/chips/tps65010.c~mark-struct-file_operations-const-3
+++ a/drivers/i2c/chips/tps65010.c
@@ -308,7 +308,7 @@ static int dbg_tps_open(struct inode *in
 	return single_open(file, dbg_show, inode->i_private);
 }
 
-static struct file_operations debug_fops = {
+static const struct file_operations debug_fops = {
 	.open		= dbg_tps_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
diff -puN drivers/i2c/i2c-dev.c~mark-struct-file_operations-const-3 drivers/i2c/i2c-dev.c
--- a/drivers/i2c/i2c-dev.c~mark-struct-file_operations-const-3
+++ a/drivers/i2c/i2c-dev.c
@@ -393,7 +393,7 @@ static int i2cdev_release(struct inode *
 	return 0;
 }
 
-static struct file_operations i2cdev_fops = {
+static const struct file_operations i2cdev_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.read		= i2cdev_read,
diff -puN drivers/ide/ide-proc.c~mark-struct-file_operations-const-3 drivers/ide/ide-proc.c
--- a/drivers/ide/ide-proc.c~mark-struct-file_operations-const-3
+++ a/drivers/ide/ide-proc.c
@@ -547,7 +547,7 @@ static int ide_drivers_open(struct inode
 	return single_open(file, &ide_drivers_show, NULL);
 }
 
-static struct file_operations ide_drivers_operations = {
+static const struct file_operations ide_drivers_operations = {
 	.open		= ide_drivers_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
diff -puN drivers/ide/ide-tape.c~mark-struct-file_operations-const-3 drivers/ide/ide-tape.c
--- a/drivers/ide/ide-tape.c~mark-struct-file_operations-const-3
+++ a/drivers/ide/ide-tape.c
@@ -4779,7 +4779,7 @@ static ide_driver_t idetape_driver = {
 /*
  *	Our character device supporting functions, passed to register_chrdev.
  */
-static struct file_operations idetape_fops = {
+static const struct file_operations idetape_fops = {
 	.owner		= THIS_MODULE,
 	.read		= idetape_chrdev_read,
 	.write		= idetape_chrdev_write,
diff -puN drivers/ieee1394/dv1394.c~mark-struct-file_operations-const-3 drivers/ieee1394/dv1394.c
--- a/drivers/ieee1394/dv1394.c~mark-struct-file_operations-const-3
+++ a/drivers/ieee1394/dv1394.c
@@ -2147,7 +2147,7 @@ out:
 }
 
 static struct cdev dv1394_cdev;
-static struct file_operations dv1394_fops=
+static const struct file_operations dv1394_fops=
 {
 	.owner =	THIS_MODULE,
 	.poll =         dv1394_poll,
diff -puN drivers/ieee1394/raw1394.c~mark-struct-file_operations-const-3 drivers/ieee1394/raw1394.c
--- a/drivers/ieee1394/raw1394.c~mark-struct-file_operations-const-3
+++ a/drivers/ieee1394/raw1394.c
@@ -3003,7 +3003,7 @@ static struct hpsb_highlevel raw1394_hig
 };
 
 static struct cdev raw1394_cdev;
-static struct file_operations raw1394_fops = {
+static const struct file_operations raw1394_fops = {
 	.owner = THIS_MODULE,
 	.read = raw1394_read,
 	.write = raw1394_write,
diff -puN drivers/ieee1394/video1394.c~mark-struct-file_operations-const-3 drivers/ieee1394/video1394.c
--- a/drivers/ieee1394/video1394.c~mark-struct-file_operations-const-3
+++ a/drivers/ieee1394/video1394.c
@@ -1269,7 +1269,7 @@ static long video1394_compat_ioctl(struc
 #endif
 
 static struct cdev video1394_cdev;
-static struct file_operations video1394_fops=
+static const struct file_operations video1394_fops=
 {
 	.owner =	THIS_MODULE,
 	.unlocked_ioctl = video1394_ioctl,
diff -puN drivers/infiniband/core/ucm.c~mark-struct-file_operations-const-3 drivers/infiniband/core/ucm.c
--- a/drivers/infiniband/core/ucm.c~mark-struct-file_operations-const-3
+++ a/drivers/infiniband/core/ucm.c
@@ -1221,7 +1221,7 @@ static void ib_ucm_release_class_dev(str
 	kfree(dev);
 }
 
-static struct file_operations ucm_fops = {
+static const struct file_operations ucm_fops = {
 	.owner 	 = THIS_MODULE,
 	.open 	 = ib_ucm_open,
 	.release = ib_ucm_close,
diff -puN drivers/infiniband/core/ucma.c~mark-struct-file_operations-const-3 drivers/infiniband/core/ucma.c
--- a/drivers/infiniband/core/ucma.c~mark-struct-file_operations-const-3
+++ a/drivers/infiniband/core/ucma.c
@@ -833,7 +833,7 @@ static int ucma_close(struct inode *inod
 	return 0;
 }
 
-static struct file_operations ucma_fops = {
+static const struct file_operations ucma_fops = {
 	.owner 	 = THIS_MODULE,
 	.open 	 = ucma_open,
 	.release = ucma_close,
diff -puN drivers/infiniband/core/user_mad.c~mark-struct-file_operations-const-3 drivers/infiniband/core/user_mad.c
--- a/drivers/infiniband/core/user_mad.c~mark-struct-file_operations-const-3
+++ a/drivers/infiniband/core/user_mad.c
@@ -771,7 +771,7 @@ static int ib_umad_close(struct inode *i
 	return 0;
 }
 
-static struct file_operations umad_fops = {
+static const struct file_operations umad_fops = {
 	.owner 	 	= THIS_MODULE,
 	.read 	 	= ib_umad_read,
 	.write 	 	= ib_umad_write,
@@ -846,7 +846,7 @@ static int ib_umad_sm_close(struct inode
 	return ret;
 }
 
-static struct file_operations umad_sm_fops = {
+static const struct file_operations umad_sm_fops = {
 	.owner 	 = THIS_MODULE,
 	.open 	 = ib_umad_sm_open,
 	.release = ib_umad_sm_close
diff -puN drivers/infiniband/core/uverbs_main.c~mark-struct-file_operations-const-3 drivers/infiniband/core/uverbs_main.c
--- a/drivers/infiniband/core/uverbs_main.c~mark-struct-file_operations-const-3
+++ a/drivers/infiniband/core/uverbs_main.c
@@ -375,7 +375,7 @@ static int ib_uverbs_event_close(struct 
 	return 0;
 }
 
-static struct file_operations uverbs_event_fops = {
+static const struct file_operations uverbs_event_fops = {
 	.owner	 = THIS_MODULE,
 	.read 	 = ib_uverbs_event_read,
 	.poll    = ib_uverbs_event_poll,
@@ -679,14 +679,14 @@ static int ib_uverbs_close(struct inode 
 	return 0;
 }
 
-static struct file_operations uverbs_fops = {
+static const struct file_operations uverbs_fops = {
 	.owner 	 = THIS_MODULE,
 	.write 	 = ib_uverbs_write,
 	.open 	 = ib_uverbs_open,
 	.release = ib_uverbs_close
 };
 
-static struct file_operations uverbs_mmap_fops = {
+static const struct file_operations uverbs_mmap_fops = {
 	.owner 	 = THIS_MODULE,
 	.write 	 = ib_uverbs_write,
 	.mmap    = ib_uverbs_mmap,
diff -puN drivers/infiniband/hw/ipath/ipath_diag.c~mark-struct-file_operations-const-3 drivers/infiniband/hw/ipath/ipath_diag.c
--- a/drivers/infiniband/hw/ipath/ipath_diag.c~mark-struct-file_operations-const-3
+++ a/drivers/infiniband/hw/ipath/ipath_diag.c
@@ -59,7 +59,7 @@ static ssize_t ipath_diag_read(struct fi
 static ssize_t ipath_diag_write(struct file *fp, const char __user *data,
 				size_t count, loff_t *off);
 
-static struct file_operations diag_file_ops = {
+static const struct file_operations diag_file_ops = {
 	.owner = THIS_MODULE,
 	.write = ipath_diag_write,
 	.read = ipath_diag_read,
@@ -71,7 +71,7 @@ static ssize_t ipath_diagpkt_write(struc
 				   const char __user *data,
 				   size_t count, loff_t *off);
 
-static struct file_operations diagpkt_file_ops = {
+static const struct file_operations diagpkt_file_ops = {
 	.owner = THIS_MODULE,
 	.write = ipath_diagpkt_write,
 };
diff -puN drivers/infiniband/hw/ipath/ipath_file_ops.c~mark-struct-file_operations-const-3 drivers/infiniband/hw/ipath/ipath_file_ops.c
--- a/drivers/infiniband/hw/ipath/ipath_file_ops.c~mark-struct-file_operations-const-3
+++ a/drivers/infiniband/hw/ipath/ipath_file_ops.c
@@ -54,7 +54,7 @@ static ssize_t ipath_write(struct file *
 static unsigned int ipath_poll(struct file *, struct poll_table_struct *);
 static int ipath_mmap(struct file *, struct vm_area_struct *);
 
-static struct file_operations ipath_file_ops = {
+static const struct file_operations ipath_file_ops = {
 	.owner = THIS_MODULE,
 	.write = ipath_write,
 	.open = ipath_open,
@@ -2153,7 +2153,7 @@ bail:
 
 static struct class *ipath_class;
 
-static int init_cdev(int minor, char *name, struct file_operations *fops,
+static int init_cdev(int minor, char *name, const struct file_operations *fops,
 		     struct cdev **cdevp, struct class_device **class_devp)
 {
 	const dev_t dev = MKDEV(IPATH_MAJOR, minor);
@@ -2210,7 +2210,7 @@ done:
 	return ret;
 }
 
-int ipath_cdev_init(int minor, char *name, struct file_operations *fops,
+int ipath_cdev_init(int minor, char *name, const struct file_operations *fops,
 		    struct cdev **cdevp, struct class_device **class_devp)
 {
 	return init_cdev(minor, name, fops, cdevp, class_devp);
diff -puN drivers/infiniband/hw/ipath/ipath_fs.c~mark-struct-file_operations-const-3 drivers/infiniband/hw/ipath/ipath_fs.c
--- a/drivers/infiniband/hw/ipath/ipath_fs.c~mark-struct-file_operations-const-3
+++ a/drivers/infiniband/hw/ipath/ipath_fs.c
@@ -47,7 +47,7 @@
 static struct super_block *ipath_super;
 
 static int ipathfs_mknod(struct inode *dir, struct dentry *dentry,
-			 int mode, struct file_operations *fops,
+			 int mode, const struct file_operations *fops,
 			 void *data)
 {
 	int error;
@@ -81,7 +81,7 @@ bail:
 
 static int create_file(const char *name, mode_t mode,
 		       struct dentry *parent, struct dentry **dentry,
-		       struct file_operations *fops, void *data)
+		       const struct file_operations *fops, void *data)
 {
 	int error;
 
@@ -105,7 +105,7 @@ static ssize_t atomic_stats_read(struct 
 				       sizeof ipath_stats);
 }
 
-static struct file_operations atomic_stats_ops = {
+static const struct file_operations atomic_stats_ops = {
 	.read = atomic_stats_read,
 };
 
@@ -127,7 +127,7 @@ static ssize_t atomic_counters_read(stru
 				       sizeof counters);
 }
 
-static struct file_operations atomic_counters_ops = {
+static const struct file_operations atomic_counters_ops = {
 	.read = atomic_counters_read,
 };
 
@@ -166,7 +166,7 @@ static ssize_t atomic_node_info_read(str
 				       sizeof nodeinfo);
 }
 
-static struct file_operations atomic_node_info_ops = {
+static const struct file_operations atomic_node_info_ops = {
 	.read = atomic_node_info_read,
 };
 
@@ -291,7 +291,7 @@ static ssize_t atomic_port_info_read(str
 				       sizeof portinfo);
 }
 
-static struct file_operations atomic_port_info_ops = {
+static const struct file_operations atomic_port_info_ops = {
 	.read = atomic_port_info_read,
 };
 
@@ -394,7 +394,7 @@ bail:
 	return ret;
 }
 
-static struct file_operations flash_ops = {
+static const struct file_operations flash_ops = {
 	.read = flash_read,
 	.write = flash_write,
 };
diff -puN drivers/infiniband/hw/ipath/ipath_kernel.h~mark-struct-file_operations-const-3 drivers/infiniband/hw/ipath/ipath_kernel.h
--- a/drivers/infiniband/hw/ipath/ipath_kernel.h~mark-struct-file_operations-const-3
+++ a/drivers/infiniband/hw/ipath/ipath_kernel.h
@@ -593,7 +593,7 @@ void ipath_shutdown_device(struct ipath_
 void ipath_disarm_senderrbufs(struct ipath_devdata *);
 
 struct file_operations;
-int ipath_cdev_init(int minor, char *name, struct file_operations *fops,
+int ipath_cdev_init(int minor, char *name, const struct file_operations *fops,
 		    struct cdev **cdevp, struct class_device **class_devp);
 void ipath_cdev_cleanup(struct cdev **cdevp,
 			struct class_device **class_devp);
diff -puN drivers/infiniband/ulp/ipoib/ipoib_fs.c~mark-struct-file_operations-const-3 drivers/infiniband/ulp/ipoib/ipoib_fs.c
--- a/drivers/infiniband/ulp/ipoib/ipoib_fs.c~mark-struct-file_operations-const-3
+++ a/drivers/infiniband/ulp/ipoib/ipoib_fs.c
@@ -146,7 +146,7 @@ static int ipoib_mcg_open(struct inode *
 	return 0;
 }
 
-static struct file_operations ipoib_mcg_fops = {
+static const struct file_operations ipoib_mcg_fops = {
 	.owner   = THIS_MODULE,
 	.open    = ipoib_mcg_open,
 	.read    = seq_read,
@@ -252,7 +252,7 @@ static int ipoib_path_open(struct inode 
 	return 0;
 }
 
-static struct file_operations ipoib_path_fops = {
+static const struct file_operations ipoib_path_fops = {
 	.owner   = THIS_MODULE,
 	.open    = ipoib_path_open,
 	.read    = seq_read,
diff -puN drivers/input/input.c~mark-struct-file_operations-const-3 drivers/input/input.c
--- a/drivers/input/input.c~mark-struct-file_operations-const-3
+++ a/drivers/input/input.c
@@ -481,7 +481,7 @@ static int input_proc_devices_open(struc
 	return seq_open(file, &input_devices_seq_ops);
 }
 
-static struct file_operations input_devices_fileops = {
+static const struct file_operations input_devices_fileops = {
 	.owner		= THIS_MODULE,
 	.open		= input_proc_devices_open,
 	.poll		= input_proc_devices_poll,
@@ -532,7 +532,7 @@ static int input_proc_handlers_open(stru
 	return seq_open(file, &input_handlers_seq_ops);
 }
 
-static struct file_operations input_handlers_fileops = {
+static const struct file_operations input_handlers_fileops = {
 	.owner		= THIS_MODULE,
 	.open		= input_proc_handlers_open,
 	.read		= seq_read,
@@ -1141,7 +1141,7 @@ static int input_open_file(struct inode 
 	return err;
 }
 
-static struct file_operations input_fops = {
+static const struct file_operations input_fops = {
 	.owner = THIS_MODULE,
 	.open = input_open_file,
 };
diff -puN drivers/input/misc/hp_sdc_rtc.c~mark-struct-file_operations-const-3 drivers/input/misc/hp_sdc_rtc.c
--- a/drivers/input/misc/hp_sdc_rtc.c~mark-struct-file_operations-const-3
+++ a/drivers/input/misc/hp_sdc_rtc.c
@@ -670,7 +670,7 @@ static int hp_sdc_rtc_ioctl(struct inode
 #endif
 }
 
-static struct file_operations hp_sdc_rtc_fops = {
+static const struct file_operations hp_sdc_rtc_fops = {
         .owner =	THIS_MODULE,
         .llseek =	no_llseek,
         .read =		hp_sdc_rtc_read,
diff -puN drivers/input/misc/uinput.c~mark-struct-file_operations-const-3 drivers/input/misc/uinput.c
--- a/drivers/input/misc/uinput.c~mark-struct-file_operations-const-3
+++ a/drivers/input/misc/uinput.c
@@ -627,7 +627,7 @@ static long uinput_ioctl(struct file *fi
 	return retval;
 }
 
-static struct file_operations uinput_fops = {
+static const struct file_operations uinput_fops = {
 	.owner		= THIS_MODULE,
 	.open		= uinput_open,
 	.release	= uinput_release,
diff -puN drivers/input/serio/serio_raw.c~mark-struct-file_operations-const-3 drivers/input/serio/serio_raw.c
--- a/drivers/input/serio/serio_raw.c~mark-struct-file_operations-const-3
+++ a/drivers/input/serio/serio_raw.c
@@ -234,7 +234,7 @@ static unsigned int serio_raw_poll(struc
 	return 0;
 }
 
-static struct file_operations serio_raw_fops = {
+static const struct file_operations serio_raw_fops = {
 	.owner =	THIS_MODULE,
 	.open =		serio_raw_open,
 	.release =	serio_raw_release,
diff -puN drivers/isdn/capi/capi.c~mark-struct-file_operations-const-3 drivers/isdn/capi/capi.c
--- a/drivers/isdn/capi/capi.c~mark-struct-file_operations-const-3
+++ a/drivers/isdn/capi/capi.c
@@ -988,7 +988,7 @@ capi_release(struct inode *inode, struct
 	return 0;
 }
 
-static struct file_operations capi_fops =
+static const struct file_operations capi_fops =
 {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
diff -puN drivers/isdn/capi/kcapi_proc.c~mark-struct-file_operations-const-3 drivers/isdn/capi/kcapi_proc.c
--- a/drivers/isdn/capi/kcapi_proc.c~mark-struct-file_operations-const-3
+++ a/drivers/isdn/capi/kcapi_proc.c
@@ -113,14 +113,14 @@ static int seq_contrstats_open(struct in
 	return seq_open(file, &seq_contrstats_ops);
 }
 
-static struct file_operations proc_controller_ops = {
+static const struct file_operations proc_controller_ops = {
 	.open		= seq_controller_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= seq_release,
 };
 
-static struct file_operations proc_contrstats_ops = {
+static const struct file_operations proc_contrstats_ops = {
 	.open		= seq_contrstats_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -218,14 +218,14 @@ seq_applstats_open(struct inode *inode, 
 	return seq_open(file, &seq_applstats_ops);
 }
 
-static struct file_operations proc_applications_ops = {
+static const struct file_operations proc_applications_ops = {
 	.open		= seq_applications_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= seq_release,
 };
 
-static struct file_operations proc_applstats_ops = {
+static const struct file_operations proc_applstats_ops = {
 	.open		= seq_applstats_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -302,7 +302,7 @@ seq_capi_driver_open(struct inode *inode
 	return err;
 }
 
-static struct file_operations proc_driver_ops = {
+static const struct file_operations proc_driver_ops = {
 	.open		= seq_capi_driver_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
diff -puN drivers/isdn/divert/divert_procfs.c~mark-struct-file_operations-const-3 drivers/isdn/divert/divert_procfs.c
--- a/drivers/isdn/divert/divert_procfs.c~mark-struct-file_operations-const-3
+++ a/drivers/isdn/divert/divert_procfs.c
@@ -256,7 +256,7 @@ isdn_divert_ioctl(struct inode *inode, s
 
 
 #ifdef CONFIG_PROC_FS
-static struct file_operations isdn_fops =
+static const struct file_operations isdn_fops =
 {
 	.owner          = THIS_MODULE,
 	.llseek         = no_llseek,
diff -puN drivers/isdn/hardware/eicon/divamnt.c~mark-struct-file_operations-const-3 drivers/isdn/hardware/eicon/divamnt.c
--- a/drivers/isdn/hardware/eicon/divamnt.c~mark-struct-file_operations-const-3
+++ a/drivers/isdn/hardware/eicon/divamnt.c
@@ -163,7 +163,7 @@ static ssize_t divas_maint_read(struct f
 	return (maint_read_write(buf, (int) count));
 }
 
-static struct file_operations divas_maint_fops = {
+static const struct file_operations divas_maint_fops = {
 	.owner   = THIS_MODULE,
 	.llseek  = no_llseek,
 	.read    = divas_maint_read,
diff -puN drivers/isdn/hardware/eicon/divasi.c~mark-struct-file_operations-const-3 drivers/isdn/hardware/eicon/divasi.c
--- a/drivers/isdn/hardware/eicon/divasi.c~mark-struct-file_operations-const-3
+++ a/drivers/isdn/hardware/eicon/divasi.c
@@ -131,7 +131,7 @@ static void remove_um_idi_proc(void)
 	}
 }
 
-static struct file_operations divas_idi_fops = {
+static const struct file_operations divas_idi_fops = {
 	.owner   = THIS_MODULE,
 	.llseek  = no_llseek,
 	.read    = um_idi_read,
diff -puN drivers/isdn/hardware/eicon/divasmain.c~mark-struct-file_operations-const-3 drivers/isdn/hardware/eicon/divasmain.c
--- a/drivers/isdn/hardware/eicon/divasmain.c~mark-struct-file_operations-const-3
+++ a/drivers/isdn/hardware/eicon/divasmain.c
@@ -662,7 +662,7 @@ static unsigned int divas_poll(struct fi
 	return (POLLIN | POLLRDNORM);
 }
 
-static struct file_operations divas_fops = {
+static const struct file_operations divas_fops = {
 	.owner   = THIS_MODULE,
 	.llseek  = no_llseek,
 	.read    = divas_read,
diff -puN drivers/isdn/hardware/eicon/divasproc.c~mark-struct-file_operations-const-3 drivers/isdn/hardware/eicon/divasproc.c
--- a/drivers/isdn/hardware/eicon/divasproc.c~mark-struct-file_operations-const-3
+++ a/drivers/isdn/hardware/eicon/divasproc.c
@@ -113,7 +113,7 @@ static int divas_close(struct inode *ino
 	return (0);
 }
 
-static struct file_operations divas_fops = {
+static const struct file_operations divas_fops = {
 	.owner   = THIS_MODULE,
 	.llseek  = no_llseek,
 	.read    = divas_read,
diff -puN drivers/isdn/hysdn/hysdn_procconf.c~mark-struct-file_operations-const-3 drivers/isdn/hysdn/hysdn_procconf.c
--- a/drivers/isdn/hysdn/hysdn_procconf.c~mark-struct-file_operations-const-3
+++ a/drivers/isdn/hysdn/hysdn_procconf.c
@@ -367,7 +367,7 @@ hysdn_conf_close(struct inode *ino, stru
 /******************************************************/
 /* table for conf filesystem functions defined above. */
 /******************************************************/
-static struct file_operations conf_fops =
+static const struct file_operations conf_fops =
 {
 	.llseek         = no_llseek,
 	.read           = hysdn_conf_read,
diff -puN drivers/isdn/hysdn/hysdn_proclog.c~mark-struct-file_operations-const-3 drivers/isdn/hysdn/hysdn_proclog.c
--- a/drivers/isdn/hysdn/hysdn_proclog.c~mark-struct-file_operations-const-3
+++ a/drivers/isdn/hysdn/hysdn_proclog.c
@@ -383,7 +383,7 @@ hysdn_log_poll(struct file *file, poll_t
 /**************************************************/
 /* table for log filesystem functions defined above. */
 /**************************************************/
-static struct file_operations log_fops =
+static const struct file_operations log_fops =
 {
 	.llseek         = no_llseek,
 	.read           = hysdn_log_read,
diff -puN drivers/isdn/i4l/isdn_common.c~mark-struct-file_operations-const-3 drivers/isdn/i4l/isdn_common.c
--- a/drivers/isdn/i4l/isdn_common.c~mark-struct-file_operations-const-3
+++ a/drivers/isdn/i4l/isdn_common.c
@@ -1822,7 +1822,7 @@ isdn_close(struct inode *ino, struct fil
 	return 0;
 }
 
-static struct file_operations isdn_fops =
+static const struct file_operations isdn_fops =
 {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
_

Patches currently in -mm which might be from arjan@linux.intel.com are

git-libata-all.patch
git-netdev-all.patch
user-of-the-jiffies-rounding-code-networking.patch
mmconfig-cleanup.patch
mmconfig-fix-unreachable_devices.patch
mark-struct-file_operations-const-1.patch
mark-struct-file_operations-const-2.patch
mark-struct-file_operations-const-3.patch
mark-struct-file_operations-const-4.patch
mark-struct-file_operations-const-5.patch
mark-struct-file_operations-const-6.patch
mark-struct-file_operations-const-7.patch
mark-struct-file_operations-const-8.patch
mark-struct-file_operations-const-9.patch
mark-struct-inode_operations-const-1.patch
mark-struct-inode_operations-const-2.patch
mark-struct-inode_operations-const-3.patch
