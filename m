From: akpm@osdl.org
Subject: + mark-struct-file_operations-const-6.patch added to -mm tree
Date: Tue, 23 Jan 2007 11:32:08 -0800
Message-ID: <200701231932.l0NJW9fH028991@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50771 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933125AbXAWTcP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 14:32:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com


The patch titled
     mark struct file_operations const 6
has been added to the -mm tree.  Its filename is
     mark-struct-file_operations-const-6.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mark struct file_operations const 6
From: Arjan van de Ven <arjan@linux.intel.com>

Many struct file_operations in the kernel can be "const".  Marking them const
moves these to the .rodata section, which avoids false sharing with potential
dirty data.  In addition it'll catch accidental writes at compile time to
these shared resources.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/sbus/char/bpp.c              |    2 -
 drivers/sbus/char/cpwatchdog.c       |    2 -
 drivers/sbus/char/display7seg.c      |    2 -
 drivers/sbus/char/envctrl.c          |    2 -
 drivers/sbus/char/flash.c            |    2 -
 drivers/sbus/char/jsflash.c          |    2 -
 drivers/sbus/char/openprom.c         |    2 -
 drivers/sbus/char/riowatchdog.c      |    2 -
 drivers/sbus/char/rtc.c              |    2 -
 drivers/sbus/char/uctrl.c            |    2 -
 drivers/sbus/char/vfc_dev.c          |    4 +--
 drivers/scsi/3w-9xxx.c               |    2 -
 drivers/scsi/3w-xxxx.c               |    2 -
 drivers/scsi/aacraid/linit.c         |    2 -
 drivers/scsi/ch.c                    |    2 -
 drivers/scsi/dpt_i2o.c               |    2 -
 drivers/scsi/gdth.c                  |    2 -
 drivers/scsi/megaraid.c              |    2 -
 drivers/scsi/megaraid/megaraid_mm.c  |    2 -
 drivers/scsi/megaraid/megaraid_sas.c |    2 -
 drivers/scsi/osst.c                  |    2 -
 drivers/scsi/scsi_proc.c             |    2 -
 drivers/scsi/scsi_tgt_if.c           |    2 -
 drivers/scsi/st.c                    |    2 -
 drivers/telephony/ixj.c              |    2 -
 drivers/telephony/phonedev.c         |    2 -
 drivers/usb/misc/adutux.c            |    2 -
 drivers/usb/misc/ftdi-elan.c         |    2 -
 drivers/video/mbx/mbxdebugfs.c       |   12 ++++-----
 drivers/zorro/proc.c                 |    2 -
 fs/debugfs/file.c                    |    2 -
 fs/dlm/debug_fs.c                    |    4 +--
 fs/dlm/user.c                        |    6 ++--
 fs/gfs2/locking/dlm/plock.c          |    2 -
 fs/nfs/client.c                      |    4 +--
 fs/ocfs2/dlm/dlmfs.c                 |    4 +--
 fs/proc/base.c                       |   32 ++++++++++++-------------
 fs/proc/generic.c                    |    4 +--
 fs/proc/internal.h                   |   14 +++++-----
 fs/proc/nommu.c                      |    2 -
 fs/proc/proc_misc.c                  |   26 ++++++++++----------
 fs/proc/proc_tty.c                   |    2 -
 fs/proc/root.c                       |    2 -
 fs/proc/task_mmu.c                   |    6 ++--
 fs/proc/task_nommu.c                 |    2 -
 45 files changed, 92 insertions(+), 92 deletions(-)

diff -puN drivers/sbus/char/bpp.c~mark-struct-file_operations-const-6 drivers/sbus/char/bpp.c
--- a/drivers/sbus/char/bpp.c~mark-struct-file_operations-const-6
+++ a/drivers/sbus/char/bpp.c
@@ -846,7 +846,7 @@ static int bpp_ioctl(struct inode *inode
       return errno;
 }
 
-static struct file_operations bpp_fops = {
+static const struct file_operations bpp_fops = {
 	.owner =	THIS_MODULE,
 	.read =		bpp_read,
 	.write =	bpp_write,
diff -puN drivers/sbus/char/cpwatchdog.c~mark-struct-file_operations-const-6 drivers/sbus/char/cpwatchdog.c
--- a/drivers/sbus/char/cpwatchdog.c~mark-struct-file_operations-const-6
+++ a/drivers/sbus/char/cpwatchdog.c
@@ -458,7 +458,7 @@ static irqreturn_t wd_interrupt(int irq,
 	return IRQ_HANDLED;
 }
 
-static struct file_operations wd_fops = {
+static const struct file_operations wd_fops = {
 	.owner =	THIS_MODULE,
 	.ioctl =	wd_ioctl,
 	.compat_ioctl =	wd_compat_ioctl,
diff -puN drivers/sbus/char/display7seg.c~mark-struct-file_operations-const-6 drivers/sbus/char/display7seg.c
--- a/drivers/sbus/char/display7seg.c~mark-struct-file_operations-const-6
+++ a/drivers/sbus/char/display7seg.c
@@ -166,7 +166,7 @@ static long d7s_ioctl(struct file *file,
 	return error;
 }
 
-static struct file_operations d7s_fops = {
+static const struct file_operations d7s_fops = {
 	.owner =		THIS_MODULE,
 	.unlocked_ioctl =	d7s_ioctl,
 	.compat_ioctl =		d7s_ioctl,
diff -puN drivers/sbus/char/envctrl.c~mark-struct-file_operations-const-6 drivers/sbus/char/envctrl.c
--- a/drivers/sbus/char/envctrl.c~mark-struct-file_operations-const-6
+++ a/drivers/sbus/char/envctrl.c
@@ -705,7 +705,7 @@ envctrl_release(struct inode *inode, str
 	return 0;
 }
 
-static struct file_operations envctrl_fops = {
+static const struct file_operations envctrl_fops = {
 	.owner =		THIS_MODULE,
 	.read =			envctrl_read,
 	.unlocked_ioctl =	envctrl_ioctl,
diff -puN drivers/sbus/char/flash.c~mark-struct-file_operations-const-6 drivers/sbus/char/flash.c
--- a/drivers/sbus/char/flash.c~mark-struct-file_operations-const-6
+++ a/drivers/sbus/char/flash.c
@@ -142,7 +142,7 @@ flash_release(struct inode *inode, struc
 	return 0;
 }
 
-static struct file_operations flash_fops = {
+static const struct file_operations flash_fops = {
 	/* no write to the Flash, use mmap
 	 * and play flash dependent tricks.
 	 */
diff -puN drivers/sbus/char/jsflash.c~mark-struct-file_operations-const-6 drivers/sbus/char/jsflash.c
--- a/drivers/sbus/char/jsflash.c~mark-struct-file_operations-const-6
+++ a/drivers/sbus/char/jsflash.c
@@ -431,7 +431,7 @@ static int jsf_release(struct inode *ino
 	return 0;
 }
 
-static struct file_operations jsf_fops = {
+static const struct file_operations jsf_fops = {
 	.owner =	THIS_MODULE,
 	.llseek =	jsf_lseek,
 	.read =		jsf_read,
diff -puN drivers/sbus/char/openprom.c~mark-struct-file_operations-const-6 drivers/sbus/char/openprom.c
--- a/drivers/sbus/char/openprom.c~mark-struct-file_operations-const-6
+++ a/drivers/sbus/char/openprom.c
@@ -703,7 +703,7 @@ static int openprom_release(struct inode
 	return 0;
 }
 
-static struct file_operations openprom_fops = {
+static const struct file_operations openprom_fops = {
 	.owner =	THIS_MODULE,
 	.llseek =	no_llseek,
 	.ioctl =	openprom_ioctl,
diff -puN drivers/sbus/char/riowatchdog.c~mark-struct-file_operations-const-6 drivers/sbus/char/riowatchdog.c
--- a/drivers/sbus/char/riowatchdog.c~mark-struct-file_operations-const-6
+++ a/drivers/sbus/char/riowatchdog.c
@@ -193,7 +193,7 @@ static ssize_t riowd_write(struct file *
 	return 0;
 }
 
-static struct file_operations riowd_fops = {
+static const struct file_operations riowd_fops = {
 	.owner =	THIS_MODULE,
 	.ioctl =	riowd_ioctl,
 	.open =		riowd_open,
diff -puN drivers/sbus/char/rtc.c~mark-struct-file_operations-const-6 drivers/sbus/char/rtc.c
--- a/drivers/sbus/char/rtc.c~mark-struct-file_operations-const-6
+++ a/drivers/sbus/char/rtc.c
@@ -233,7 +233,7 @@ static int rtc_release(struct inode *ino
 	return 0;
 }
 
-static struct file_operations rtc_fops = {
+static const struct file_operations rtc_fops = {
 	.owner =	THIS_MODULE,
 	.llseek =	no_llseek,
 	.ioctl =	rtc_ioctl,
diff -puN drivers/sbus/char/uctrl.c~mark-struct-file_operations-const-6 drivers/sbus/char/uctrl.c
--- a/drivers/sbus/char/uctrl.c~mark-struct-file_operations-const-6
+++ a/drivers/sbus/char/uctrl.c
@@ -223,7 +223,7 @@ static irqreturn_t uctrl_interrupt(int i
 	return IRQ_HANDLED;
 }
 
-static struct file_operations uctrl_fops = {
+static const struct file_operations uctrl_fops = {
 	.owner =	THIS_MODULE,
 	.llseek =	no_llseek,
 	.ioctl =	uctrl_ioctl,
diff -puN drivers/sbus/char/vfc_dev.c~mark-struct-file_operations-const-6 drivers/sbus/char/vfc_dev.c
--- a/drivers/sbus/char/vfc_dev.c~mark-struct-file_operations-const-6
+++ a/drivers/sbus/char/vfc_dev.c
@@ -43,7 +43,7 @@
 #include "vfc.h"
 #include <asm/vfc_ioctls.h>
 
-static struct file_operations vfc_fops;
+static const struct file_operations vfc_fops;
 struct vfc_dev **vfc_dev_lst;
 static char vfcstr[]="vfc";
 static unsigned char saa9051_init_array[VFC_SAA9051_NR] = {
@@ -632,7 +632,7 @@ static int vfc_mmap(struct file *file, s
 }
 
 
-static struct file_operations vfc_fops = {
+static const struct file_operations vfc_fops = {
 	.owner =	THIS_MODULE,
 	.llseek =	no_llseek,
 	.ioctl =	vfc_ioctl,
diff -puN drivers/scsi/3w-9xxx.c~mark-struct-file_operations-const-6 drivers/scsi/3w-9xxx.c
--- a/drivers/scsi/3w-9xxx.c~mark-struct-file_operations-const-6
+++ a/drivers/scsi/3w-9xxx.c
@@ -197,7 +197,7 @@ static struct class_device_attribute *tw
 };
 
 /* File operations struct for character device */
-static struct file_operations twa_fops = {
+static const struct file_operations twa_fops = {
 	.owner		= THIS_MODULE,
 	.ioctl		= twa_chrdev_ioctl,
 	.open		= twa_chrdev_open,
diff -puN drivers/scsi/3w-xxxx.c~mark-struct-file_operations-const-6 drivers/scsi/3w-xxxx.c
--- a/drivers/scsi/3w-xxxx.c~mark-struct-file_operations-const-6
+++ a/drivers/scsi/3w-xxxx.c
@@ -1040,7 +1040,7 @@ static int tw_chrdev_open(struct inode *
 } /* End tw_chrdev_open() */
 
 /* File operations struct for character device */
-static struct file_operations tw_fops = {
+static const struct file_operations tw_fops = {
 	.owner		= THIS_MODULE,
 	.ioctl		= tw_chrdev_ioctl,
 	.open		= tw_chrdev_open,
diff -puN drivers/scsi/aacraid/linit.c~mark-struct-file_operations-const-6 drivers/scsi/aacraid/linit.c
--- a/drivers/scsi/aacraid/linit.c~mark-struct-file_operations-const-6
+++ a/drivers/scsi/aacraid/linit.c
@@ -768,7 +768,7 @@ static struct class_device_attribute *aa
 };
 
 
-static struct file_operations aac_cfg_fops = {
+static const struct file_operations aac_cfg_fops = {
 	.owner		= THIS_MODULE,
 	.ioctl		= aac_cfg_ioctl,
 #ifdef CONFIG_COMPAT
diff -puN drivers/scsi/ch.c~mark-struct-file_operations-const-6 drivers/scsi/ch.c
--- a/drivers/scsi/ch.c~mark-struct-file_operations-const-6
+++ a/drivers/scsi/ch.c
@@ -128,7 +128,7 @@ static struct scsi_driver ch_template =
 	},
 };
 
-static struct file_operations changer_fops =
+static const struct file_operations changer_fops =
 {
 	.owner        = THIS_MODULE,
 	.open         = ch_open,
diff -puN drivers/scsi/dpt_i2o.c~mark-struct-file_operations-const-6 drivers/scsi/dpt_i2o.c
--- a/drivers/scsi/dpt_i2o.c~mark-struct-file_operations-const-6
+++ a/drivers/scsi/dpt_i2o.c
@@ -116,7 +116,7 @@ static int sys_tbl_len = 0;
 static adpt_hba* hba_chain = NULL;
 static int hba_count = 0;
 
-static struct file_operations adpt_fops = {
+static const struct file_operations adpt_fops = {
 	.ioctl		= adpt_ioctl,
 	.open		= adpt_open,
 	.release	= adpt_close
diff -puN drivers/scsi/gdth.c~mark-struct-file_operations-const-6 drivers/scsi/gdth.c
--- a/drivers/scsi/gdth.c~mark-struct-file_operations-const-6
+++ a/drivers/scsi/gdth.c
@@ -686,7 +686,7 @@ MODULE_AUTHOR("Achim Leubner");
 MODULE_LICENSE("GPL");
 
 /* ioctl interface */
-static struct file_operations gdth_fops = {
+static const struct file_operations gdth_fops = {
     .ioctl   = gdth_ioctl,
     .open    = gdth_open,
     .release = gdth_close,
diff -puN drivers/scsi/megaraid.c~mark-struct-file_operations-const-6 drivers/scsi/megaraid.c
--- a/drivers/scsi/megaraid.c~mark-struct-file_operations-const-6
+++ a/drivers/scsi/megaraid.c
@@ -96,7 +96,7 @@ static struct mega_hbas mega_hbas[MAX_CO
 /*
  * The File Operations structure for the serial/ioctl interface of the driver
  */
-static struct file_operations megadev_fops = {
+static const struct file_operations megadev_fops = {
 	.owner		= THIS_MODULE,
 	.ioctl		= megadev_ioctl,
 	.open		= megadev_open,
diff -puN drivers/scsi/megaraid/megaraid_mm.c~mark-struct-file_operations-const-6 drivers/scsi/megaraid/megaraid_mm.c
--- a/drivers/scsi/megaraid/megaraid_mm.c~mark-struct-file_operations-const-6
+++ a/drivers/scsi/megaraid/megaraid_mm.c
@@ -67,7 +67,7 @@ static struct list_head adapters_list_g;
 
 static wait_queue_head_t wait_q;
 
-static struct file_operations lsi_fops = {
+static const struct file_operations lsi_fops = {
 	.open	= mraid_mm_open,
 	.ioctl	= mraid_mm_ioctl,
 #ifdef CONFIG_COMPAT
diff -puN drivers/scsi/megaraid/megaraid_sas.c~mark-struct-file_operations-const-6 drivers/scsi/megaraid/megaraid_sas.c
--- a/drivers/scsi/megaraid/megaraid_sas.c~mark-struct-file_operations-const-6
+++ a/drivers/scsi/megaraid/megaraid_sas.c
@@ -2913,7 +2913,7 @@ megasas_mgmt_compat_ioctl(struct file *f
 /*
  * File operations structure for management interface
  */
-static struct file_operations megasas_mgmt_fops = {
+static const struct file_operations megasas_mgmt_fops = {
 	.owner = THIS_MODULE,
 	.open = megasas_mgmt_open,
 	.release = megasas_mgmt_release,
diff -puN drivers/scsi/osst.c~mark-struct-file_operations-const-6 drivers/scsi/osst.c
--- a/drivers/scsi/osst.c~mark-struct-file_operations-const-6
+++ a/drivers/scsi/osst.c
@@ -5522,7 +5522,7 @@ __setup("osst=", osst_setup);
 
 #endif
 
-static struct file_operations osst_fops = {
+static const struct file_operations osst_fops = {
 	.owner =        THIS_MODULE,
 	.read =         osst_read,
 	.write =        osst_write,
diff -puN drivers/scsi/scsi_proc.c~mark-struct-file_operations-const-6 drivers/scsi/scsi_proc.c
--- a/drivers/scsi/scsi_proc.c~mark-struct-file_operations-const-6
+++ a/drivers/scsi/scsi_proc.c
@@ -308,7 +308,7 @@ static int proc_scsi_open(struct inode *
 	return single_open(file, proc_scsi_show, NULL);
 }
 
-static struct file_operations proc_scsi_operations = {
+static const struct file_operations proc_scsi_operations = {
 	.open		= proc_scsi_open,
 	.read		= seq_read,
 	.write		= proc_scsi_write,
diff -puN drivers/scsi/scsi_tgt_if.c~mark-struct-file_operations-const-6 drivers/scsi/scsi_tgt_if.c
--- a/drivers/scsi/scsi_tgt_if.c~mark-struct-file_operations-const-6
+++ a/drivers/scsi/scsi_tgt_if.c
@@ -280,7 +280,7 @@ static int tgt_open(struct inode *inode,
 	return 0;
 }
 
-static struct file_operations tgt_fops = {
+static const struct file_operations tgt_fops = {
 	.owner		= THIS_MODULE,
 	.open		= tgt_open,
 	.poll		= tgt_poll,
diff -puN drivers/scsi/st.c~mark-struct-file_operations-const-6 drivers/scsi/st.c
--- a/drivers/scsi/st.c~mark-struct-file_operations-const-6
+++ a/drivers/scsi/st.c
@@ -3858,7 +3858,7 @@ __setup("st=", st_setup);
 
 #endif
 
-static struct file_operations st_fops =
+static const struct file_operations st_fops =
 {
 	.owner =	THIS_MODULE,
 	.read =		st_read,
diff -puN drivers/telephony/ixj.c~mark-struct-file_operations-const-6 drivers/telephony/ixj.c
--- a/drivers/telephony/ixj.c~mark-struct-file_operations-const-6
+++ a/drivers/telephony/ixj.c
@@ -6662,7 +6662,7 @@ static int ixj_fasync(int fd, struct fil
 	return fasync_helper(fd, file_p, mode, &j->async_queue);
 }
 
-static struct file_operations ixj_fops =
+static const struct file_operations ixj_fops =
 {
         .owner          = THIS_MODULE,
         .read           = ixj_enhanced_read,
diff -puN drivers/telephony/phonedev.c~mark-struct-file_operations-const-6 drivers/telephony/phonedev.c
--- a/drivers/telephony/phonedev.c~mark-struct-file_operations-const-6
+++ a/drivers/telephony/phonedev.c
@@ -127,7 +127,7 @@ void phone_unregister_device(struct phon
 }
 
 
-static struct file_operations phone_fops =
+static const struct file_operations phone_fops =
 {
 	.owner		= THIS_MODULE,
 	.open		= phone_open,
diff -puN drivers/usb/misc/adutux.c~mark-struct-file_operations-const-6 drivers/usb/misc/adutux.c
--- a/drivers/usb/misc/adutux.c~mark-struct-file_operations-const-6
+++ a/drivers/usb/misc/adutux.c
@@ -644,7 +644,7 @@ exit:
 }
 
 /* file operations needed when we register this driver */
-static struct file_operations adu_fops = {
+static const struct file_operations adu_fops = {
 	.owner = THIS_MODULE,
 	.read  = adu_read,
 	.write = adu_write,
diff -puN drivers/usb/misc/ftdi-elan.c~mark-struct-file_operations-const-6 drivers/usb/misc/ftdi-elan.c
--- a/drivers/usb/misc/ftdi-elan.c~mark-struct-file_operations-const-6
+++ a/drivers/usb/misc/ftdi-elan.c
@@ -1209,7 +1209,7 @@ error_1:
 	return retval;
 }
 
-static struct file_operations ftdi_elan_fops = {
+static const struct file_operations ftdi_elan_fops = {
         .owner = THIS_MODULE,
         .llseek = no_llseek,
         .ioctl = ftdi_elan_ioctl,
diff -puN drivers/video/mbx/mbxdebugfs.c~mark-struct-file_operations-const-6 drivers/video/mbx/mbxdebugfs.c
--- a/drivers/video/mbx/mbxdebugfs.c~mark-struct-file_operations-const-6
+++ a/drivers/video/mbx/mbxdebugfs.c
@@ -170,37 +170,37 @@ static ssize_t misc_read_file(struct fil
 }
 
 
-static struct file_operations sysconf_fops = {
+static const struct file_operations sysconf_fops = {
 	.read = sysconf_read_file,
 	.write = write_file_dummy,
 	.open = open_file_generic,
 };
 
-static struct file_operations clock_fops = {
+static const struct file_operations clock_fops = {
 	.read = clock_read_file,
 	.write = write_file_dummy,
 	.open = open_file_generic,
 };
 
-static struct file_operations display_fops = {
+static const struct file_operations display_fops = {
 	.read = display_read_file,
 	.write = write_file_dummy,
 	.open = open_file_generic,
 };
 
-static struct file_operations gsctl_fops = {
+static const struct file_operations gsctl_fops = {
 	.read = gsctl_read_file,
 	.write = write_file_dummy,
 	.open = open_file_generic,
 };
 
-static struct file_operations sdram_fops = {
+static const struct file_operations sdram_fops = {
 	.read = sdram_read_file,
 	.write = write_file_dummy,
 	.open = open_file_generic,
 };
 
-static struct file_operations misc_fops = {
+static const struct file_operations misc_fops = {
 	.read = misc_read_file,
 	.write = write_file_dummy,
 	.open = open_file_generic,
diff -puN drivers/zorro/proc.c~mark-struct-file_operations-const-6 drivers/zorro/proc.c
--- a/drivers/zorro/proc.c~mark-struct-file_operations-const-6
+++ a/drivers/zorro/proc.c
@@ -75,7 +75,7 @@ proc_bus_zorro_read(struct file *file, c
 	return nbytes;
 }
 
-static struct file_operations proc_bus_zorro_operations = {
+static const struct file_operations proc_bus_zorro_operations = {
 	.llseek		= proc_bus_zorro_lseek,
 	.read		= proc_bus_zorro_read,
 };
diff -puN fs/debugfs/file.c~mark-struct-file_operations-const-6 fs/debugfs/file.c
--- a/fs/debugfs/file.c~mark-struct-file_operations-const-6
+++ a/fs/debugfs/file.c
@@ -254,7 +254,7 @@ static ssize_t read_file_blob(struct fil
 			blob->size);
 }
 
-static struct file_operations fops_blob = {
+static const struct file_operations fops_blob = {
 	.read =		read_file_blob,
 	.open =		default_open,
 };
diff -puN fs/dlm/debug_fs.c~mark-struct-file_operations-const-6 fs/dlm/debug_fs.c
--- a/fs/dlm/debug_fs.c~mark-struct-file_operations-const-6
+++ a/fs/dlm/debug_fs.c
@@ -287,7 +287,7 @@ static int rsb_open(struct inode *inode,
 	return 0;
 }
 
-static struct file_operations rsb_fops = {
+static const struct file_operations rsb_fops = {
 	.owner   = THIS_MODULE,
 	.open    = rsb_open,
 	.read    = seq_read,
@@ -331,7 +331,7 @@ static ssize_t waiters_read(struct file 
 	return rv;
 }
 
-static struct file_operations waiters_fops = {
+static const struct file_operations waiters_fops = {
 	.owner   = THIS_MODULE,
 	.open    = waiters_open,
 	.read    = waiters_read
diff -puN fs/dlm/user.c~mark-struct-file_operations-const-6 fs/dlm/user.c
--- a/fs/dlm/user.c~mark-struct-file_operations-const-6
+++ a/fs/dlm/user.c
@@ -25,7 +25,7 @@
 
 static const char *name_prefix="dlm";
 static struct miscdevice ctl_device;
-static struct file_operations device_fops;
+static const struct file_operations device_fops;
 
 #ifdef CONFIG_COMPAT
 
@@ -759,7 +759,7 @@ static int ctl_device_close(struct inode
 	return 0;
 }
 
-static struct file_operations device_fops = {
+static const struct file_operations device_fops = {
 	.open    = device_open,
 	.release = device_close,
 	.read    = device_read,
@@ -768,7 +768,7 @@ static struct file_operations device_fop
 	.owner   = THIS_MODULE,
 };
 
-static struct file_operations ctl_device_fops = {
+static const struct file_operations ctl_device_fops = {
 	.open    = ctl_device_open,
 	.release = ctl_device_close,
 	.write   = device_write,
diff -puN fs/gfs2/locking/dlm/plock.c~mark-struct-file_operations-const-6 fs/gfs2/locking/dlm/plock.c
--- a/fs/gfs2/locking/dlm/plock.c~mark-struct-file_operations-const-6
+++ a/fs/gfs2/locking/dlm/plock.c
@@ -264,7 +264,7 @@ static unsigned int dev_poll(struct file
 	return 0;
 }
 
-static struct file_operations dev_fops = {
+static const struct file_operations dev_fops = {
 	.read    = dev_read,
 	.write   = dev_write,
 	.poll    = dev_poll,
diff -puN fs/nfs/client.c~mark-struct-file_operations-const-6 fs/nfs/client.c
--- a/fs/nfs/client.c~mark-struct-file_operations-const-6
+++ a/fs/nfs/client.c
@@ -1176,7 +1176,7 @@ static struct seq_operations nfs_server_
 	.show	= nfs_server_list_show,
 };
 
-static struct file_operations nfs_server_list_fops = {
+static const struct file_operations nfs_server_list_fops = {
 	.open		= nfs_server_list_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -1196,7 +1196,7 @@ static struct seq_operations nfs_volume_
 	.show	= nfs_volume_list_show,
 };
 
-static struct file_operations nfs_volume_list_fops = {
+static const struct file_operations nfs_volume_list_fops = {
 	.open		= nfs_volume_list_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
diff -puN fs/ocfs2/dlm/dlmfs.c~mark-struct-file_operations-const-6 fs/ocfs2/dlm/dlmfs.c
--- a/fs/ocfs2/dlm/dlmfs.c~mark-struct-file_operations-const-6
+++ a/fs/ocfs2/dlm/dlmfs.c
@@ -62,7 +62,7 @@
 #include "cluster/masklog.h"
 
 static struct super_operations dlmfs_ops;
-static struct file_operations dlmfs_file_operations;
+static const struct file_operations dlmfs_file_operations;
 static struct inode_operations dlmfs_dir_inode_operations;
 static struct inode_operations dlmfs_root_inode_operations;
 static struct inode_operations dlmfs_file_inode_operations;
@@ -540,7 +540,7 @@ static int dlmfs_fill_super(struct super
 	return 0;
 }
 
-static struct file_operations dlmfs_file_operations = {
+static const struct file_operations dlmfs_file_operations = {
 	.open		= dlmfs_file_open,
 	.release	= dlmfs_file_release,
 	.read		= dlmfs_file_read,
diff -puN fs/proc/base.c~mark-struct-file_operations-const-6 fs/proc/base.c
--- a/fs/proc/base.c~mark-struct-file_operations-const-6
+++ a/fs/proc/base.c
@@ -94,7 +94,7 @@ struct pid_entry {
 	char *name;
 	mode_t mode;
 	struct inode_operations *iop;
-	struct file_operations *fop;
+	const struct file_operations *fop;
 	union proc_op op;
 };
 
@@ -422,7 +422,7 @@ static unsigned mounts_poll(struct file 
 	return res;
 }
 
-static struct file_operations proc_mounts_operations = {
+static const struct file_operations proc_mounts_operations = {
 	.open		= mounts_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -460,7 +460,7 @@ static int mountstats_open(struct inode 
 	return ret;
 }
 
-static struct file_operations proc_mountstats_operations = {
+static const struct file_operations proc_mountstats_operations = {
 	.open		= mountstats_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -499,7 +499,7 @@ out_no_task:
 	return length;
 }
 
-static struct file_operations proc_info_file_operations = {
+static const struct file_operations proc_info_file_operations = {
 	.read		= proc_info_read,
 };
 
@@ -644,7 +644,7 @@ static loff_t mem_lseek(struct file * fi
 	return file->f_pos;
 }
 
-static struct file_operations proc_mem_operations = {
+static const struct file_operations proc_mem_operations = {
 	.llseek		= mem_lseek,
 	.read		= mem_read,
 	.write		= mem_write,
@@ -708,7 +708,7 @@ static ssize_t oom_adjust_write(struct f
 	return end - buffer;
 }
 
-static struct file_operations proc_oom_adjust_operations = {
+static const struct file_operations proc_oom_adjust_operations = {
 	.read		= oom_adjust_read,
 	.write		= oom_adjust_write,
 };
@@ -775,7 +775,7 @@ out_free_page:
 	return length;
 }
 
-static struct file_operations proc_loginuid_operations = {
+static const struct file_operations proc_loginuid_operations = {
 	.read		= proc_loginuid_read,
 	.write		= proc_loginuid_write,
 };
@@ -847,7 +847,7 @@ out_no_task:
 	return result;
 }
 
-static struct file_operations proc_seccomp_operations = {
+static const struct file_operations proc_seccomp_operations = {
 	.read		= seccomp_read,
 	.write		= seccomp_write,
 };
@@ -906,7 +906,7 @@ static ssize_t proc_fault_inject_write(s
 	return end - buffer;
 }
 
-static struct file_operations proc_fault_inject_operations = {
+static const struct file_operations proc_fault_inject_operations = {
 	.read		= proc_fault_inject_read,
 	.write		= proc_fault_inject_write,
 };
@@ -1406,7 +1406,7 @@ out_no_task:
 	return retval;
 }
 
-static struct file_operations proc_fd_operations = {
+static const struct file_operations proc_fd_operations = {
 	.read		= generic_read_dir,
 	.readdir	= proc_readfd,
 };
@@ -1621,7 +1621,7 @@ out_no_task:
 	return length;
 }
 
-static struct file_operations proc_pid_attr_operations = {
+static const struct file_operations proc_pid_attr_operations = {
 	.read		= proc_pid_attr_read,
 	.write		= proc_pid_attr_write,
 };
@@ -1642,7 +1642,7 @@ static int proc_attr_dir_readdir(struct 
 				   attr_dir_stuff,ARRAY_SIZE(attr_dir_stuff));
 }
 
-static struct file_operations proc_attr_dir_operations = {
+static const struct file_operations proc_attr_dir_operations = {
 	.read		= generic_read_dir,
 	.readdir	= proc_attr_dir_readdir,
 };
@@ -1828,7 +1828,7 @@ static int proc_pid_io_accounting(struct
 /*
  * Thread groups
  */
-static struct file_operations proc_task_operations;
+static const struct file_operations proc_task_operations;
 static struct inode_operations proc_task_inode_operations;
 
 static struct pid_entry tgid_base_stuff[] = {
@@ -1888,7 +1888,7 @@ static int proc_tgid_base_readdir(struct
 				   tgid_base_stuff,ARRAY_SIZE(tgid_base_stuff));
 }
 
-static struct file_operations proc_tgid_base_operations = {
+static const struct file_operations proc_tgid_base_operations = {
 	.read		= generic_read_dir,
 	.readdir	= proc_tgid_base_readdir,
 };
@@ -2171,7 +2171,7 @@ static struct dentry *proc_tid_base_look
 				  tid_base_stuff, ARRAY_SIZE(tid_base_stuff));
 }
 
-static struct file_operations proc_tid_base_operations = {
+static const struct file_operations proc_tid_base_operations = {
 	.read		= generic_read_dir,
 	.readdir	= proc_tid_base_readdir,
 };
@@ -2398,7 +2398,7 @@ static struct inode_operations proc_task
 	.setattr	= proc_setattr,
 };
 
-static struct file_operations proc_task_operations = {
+static const struct file_operations proc_task_operations = {
 	.read		= generic_read_dir,
 	.readdir	= proc_task_readdir,
 };
diff -puN fs/proc/generic.c~mark-struct-file_operations-const-6 fs/proc/generic.c
--- a/fs/proc/generic.c~mark-struct-file_operations-const-6
+++ a/fs/proc/generic.c
@@ -39,7 +39,7 @@ int proc_match(int len, const char *name
 	return !memcmp(name, de->name, len);
 }
 
-static struct file_operations proc_file_operations = {
+static const struct file_operations proc_file_operations = {
 	.llseek		= proc_file_lseek,
 	.read		= proc_file_read,
 	.write		= proc_file_write,
@@ -500,7 +500,7 @@ out:	unlock_kernel();
  * use the in-memory "struct proc_dir_entry" tree to parse
  * the /proc directory.
  */
-static struct file_operations proc_dir_operations = {
+static const struct file_operations proc_dir_operations = {
 	.read			= generic_read_dir,
 	.readdir		= proc_readdir,
 };
diff -puN fs/proc/internal.h~mark-struct-file_operations-const-6 fs/proc/internal.h
--- a/fs/proc/internal.h~mark-struct-file_operations-const-6
+++ a/fs/proc/internal.h
@@ -38,13 +38,13 @@ extern int proc_tgid_stat(struct task_st
 extern int proc_pid_status(struct task_struct *, char *);
 extern int proc_pid_statm(struct task_struct *, char *);
 
-extern struct file_operations proc_maps_operations;
-extern struct file_operations proc_numa_maps_operations;
-extern struct file_operations proc_smaps_operations;
-
-extern struct file_operations proc_maps_operations;
-extern struct file_operations proc_numa_maps_operations;
-extern struct file_operations proc_smaps_operations;
+extern const struct file_operations proc_maps_operations;
+extern const struct file_operations proc_numa_maps_operations;
+extern const struct file_operations proc_smaps_operations;
+
+extern const struct file_operations proc_maps_operations;
+extern const struct file_operations proc_numa_maps_operations;
+extern const struct file_operations proc_smaps_operations;
 
 
 void free_proc_entry(struct proc_dir_entry *de);
diff -puN fs/proc/nommu.c~mark-struct-file_operations-const-6 fs/proc/nommu.c
--- a/fs/proc/nommu.c~mark-struct-file_operations-const-6
+++ a/fs/proc/nommu.c
@@ -128,7 +128,7 @@ static int proc_nommu_vma_list_open(stru
 	return seq_open(file, &proc_nommu_vma_list_seqop);
 }
 
-static struct file_operations proc_nommu_vma_list_operations = {
+static const struct file_operations proc_nommu_vma_list_operations = {
 	.open    = proc_nommu_vma_list_open,
 	.read    = seq_read,
 	.llseek  = seq_lseek,
diff -puN fs/proc/proc_misc.c~mark-struct-file_operations-const-6 fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~mark-struct-file_operations-const-6
+++ a/fs/proc/proc_misc.c
@@ -228,7 +228,7 @@ static int fragmentation_open(struct ino
 	return seq_open(file, &fragmentation_op);
 }
 
-static struct file_operations fragmentation_file_operations = {
+static const struct file_operations fragmentation_file_operations = {
 	.open		= fragmentation_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -241,7 +241,7 @@ static int zoneinfo_open(struct inode *i
 	return seq_open(file, &zoneinfo_op);
 }
 
-static struct file_operations proc_zoneinfo_file_operations = {
+static const struct file_operations proc_zoneinfo_file_operations = {
 	.open		= zoneinfo_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -266,7 +266,7 @@ static int cpuinfo_open(struct inode *in
 	return seq_open(file, &cpuinfo_op);
 }
 
-static struct file_operations proc_cpuinfo_operations = {
+static const struct file_operations proc_cpuinfo_operations = {
 	.open		= cpuinfo_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -325,7 +325,7 @@ static int devinfo_open(struct inode *in
 	return seq_open(filp, &devinfo_ops);
 }
 
-static struct file_operations proc_devinfo_operations = {
+static const struct file_operations proc_devinfo_operations = {
 	.open		= devinfo_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -337,7 +337,7 @@ static int vmstat_open(struct inode *ino
 {
 	return seq_open(file, &vmstat_op);
 }
-static struct file_operations proc_vmstat_file_operations = {
+static const struct file_operations proc_vmstat_file_operations = {
 	.open		= vmstat_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -368,7 +368,7 @@ static int partitions_open(struct inode 
 {
 	return seq_open(file, &partitions_op);
 }
-static struct file_operations proc_partitions_operations = {
+static const struct file_operations proc_partitions_operations = {
 	.open		= partitions_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -380,7 +380,7 @@ static int diskstats_open(struct inode *
 {
 	return seq_open(file, &diskstats_op);
 }
-static struct file_operations proc_diskstats_operations = {
+static const struct file_operations proc_diskstats_operations = {
 	.open		= diskstats_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -394,7 +394,7 @@ static int modules_open(struct inode *in
 {
 	return seq_open(file, &modules_op);
 }
-static struct file_operations proc_modules_operations = {
+static const struct file_operations proc_modules_operations = {
 	.open		= modules_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -409,7 +409,7 @@ static int slabinfo_open(struct inode *i
 {
 	return seq_open(file, &slabinfo_op);
 }
-static struct file_operations proc_slabinfo_operations = {
+static const struct file_operations proc_slabinfo_operations = {
 	.open		= slabinfo_open,
 	.read		= seq_read,
 	.write		= slabinfo_write,
@@ -443,7 +443,7 @@ static int slabstats_release(struct inod
 	return seq_release(inode, file);
 }
 
-static struct file_operations proc_slabstats_operations = {
+static const struct file_operations proc_slabstats_operations = {
 	.open		= slabstats_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -558,7 +558,7 @@ static int stat_open(struct inode *inode
 		kfree(buf);
 	return res;
 }
-static struct file_operations proc_stat_operations = {
+static const struct file_operations proc_stat_operations = {
 	.open		= stat_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -600,7 +600,7 @@ static int interrupts_open(struct inode 
 	return seq_open(filp, &int_seq_ops);
 }
 
-static struct file_operations proc_interrupts_operations = {
+static const struct file_operations proc_interrupts_operations = {
 	.open		= interrupts_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -657,7 +657,7 @@ static ssize_t write_sysrq_trigger(struc
 	return count;
 }
 
-static struct file_operations proc_sysrq_trigger_operations = {
+static const struct file_operations proc_sysrq_trigger_operations = {
 	.write		= write_sysrq_trigger,
 };
 #endif
diff -puN fs/proc/proc_tty.c~mark-struct-file_operations-const-6 fs/proc/proc_tty.c
--- a/fs/proc/proc_tty.c~mark-struct-file_operations-const-6
+++ a/fs/proc/proc_tty.c
@@ -138,7 +138,7 @@ static int tty_drivers_open(struct inode
 	return seq_open(file, &tty_drivers_op);
 }
 
-static struct file_operations proc_tty_drivers_operations = {
+static const struct file_operations proc_tty_drivers_operations = {
 	.open		= tty_drivers_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
diff -puN fs/proc/root.c~mark-struct-file_operations-const-6 fs/proc/root.c
--- a/fs/proc/root.c~mark-struct-file_operations-const-6
+++ a/fs/proc/root.c
@@ -136,7 +136,7 @@ static int proc_root_readdir(struct file
  * <pid> directories. Thus we don't use the generic
  * directory handling functions for that..
  */
-static struct file_operations proc_root_operations = {
+static const struct file_operations proc_root_operations = {
 	.read		 = generic_read_dir,
 	.readdir	 = proc_root_readdir,
 };
diff -puN fs/proc/task_mmu.c~mark-struct-file_operations-const-6 fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mark-struct-file_operations-const-6
+++ a/fs/proc/task_mmu.c
@@ -434,7 +434,7 @@ static int maps_open(struct inode *inode
 	return do_maps_open(inode, file, &proc_pid_maps_op);
 }
 
-struct file_operations proc_maps_operations = {
+const struct file_operations proc_maps_operations = {
 	.open		= maps_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -456,7 +456,7 @@ static int numa_maps_open(struct inode *
 	return do_maps_open(inode, file, &proc_pid_numa_maps_op);
 }
 
-struct file_operations proc_numa_maps_operations = {
+const struct file_operations proc_numa_maps_operations = {
 	.open		= numa_maps_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -469,7 +469,7 @@ static int smaps_open(struct inode *inod
 	return do_maps_open(inode, file, &proc_pid_smaps_op);
 }
 
-struct file_operations proc_smaps_operations = {
+const struct file_operations proc_smaps_operations = {
 	.open		= smaps_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
diff -puN fs/proc/task_nommu.c~mark-struct-file_operations-const-6 fs/proc/task_nommu.c
--- a/fs/proc/task_nommu.c~mark-struct-file_operations-const-6
+++ a/fs/proc/task_nommu.c
@@ -220,7 +220,7 @@ static int maps_open(struct inode *inode
 	return ret;
 }
 
-struct file_operations proc_maps_operations = {
+const struct file_operations proc_maps_operations = {
 	.open		= maps_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
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
