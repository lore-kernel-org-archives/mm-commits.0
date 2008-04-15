From: akpm@linux-foundation.org
Subject: - proc-switch-proc-driver-radio-typhoon-to-seq_file-interface.patch removed from -mm tree
Date: Tue, 15 Apr 2008 13:44:11 -0700
Message-ID: <200804152044.m3FKiBRG014672@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33221 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752588AbYDOUo4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 16:44:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, dougsland@gmail.com, mchehab@infradead.org, xyzzy@speakeasy.org, mm-commits@vger.kernel.org


The patch titled
     proc: switch /proc/driver/radio-typhoon to seq_file interface
has been removed from the -mm tree.  Its filename was
     proc-switch-proc-driver-radio-typhoon-to-seq_file-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: switch /proc/driver/radio-typhoon to seq_file interface
From: Alexey Dobriyan <adobriyan@sw.ru>

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Douglas Schilling Landgraf <dougsland@gmail.com>
Cc: Trent Piepho <xyzzy@speakeasy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/radio/radio-typhoon.c |   40 ++++++++++++++------------
 1 file changed, 23 insertions(+), 17 deletions(-)

diff -puN drivers/media/radio/radio-typhoon.c~proc-switch-proc-driver-radio-typhoon-to-seq_file-interface drivers/media/radio/radio-typhoon.c
--- a/drivers/media/radio/radio-typhoon.c~proc-switch-proc-driver-radio-typhoon-to-seq_file-interface
+++ a/drivers/media/radio/radio-typhoon.c
@@ -35,6 +35,7 @@
 #include <linux/init.h>		/* Initdata                       */
 #include <linux/ioport.h>	/* request_region		  */
 #include <linux/proc_fs.h>	/* radio card status report	  */
+#include <linux/seq_file.h>
 #include <asm/io.h>		/* outb, outb_p                   */
 #include <asm/uaccess.h>	/* copy to/from user              */
 #include <linux/videodev2.h>	/* kernel radio structs           */
@@ -93,9 +94,6 @@ static int typhoon_setfreq(struct typhoo
 static void typhoon_mute(struct typhoon_device *dev);
 static void typhoon_unmute(struct typhoon_device *dev);
 static int typhoon_setvol(struct typhoon_device *dev, int vol);
-#ifdef CONFIG_RADIO_TYPHOON_PROC_FS
-static int typhoon_get_info(char *buf, char **start, off_t offset, int len);
-#endif
 
 static void typhoon_setvol_generic(struct typhoon_device *dev, int vol)
 {
@@ -368,30 +366,39 @@ static struct video_device typhoon_radio
 
 #ifdef CONFIG_RADIO_TYPHOON_PROC_FS
 
-static int typhoon_get_info(char *buf, char **start, off_t offset, int len)
+static int typhoon_proc_show(struct seq_file *m, void *v)
 {
-	char *out = buf;
-
 	#ifdef MODULE
 	    #define MODULEPROCSTRING "Driver loaded as a module"
 	#else
 	    #define MODULEPROCSTRING "Driver compiled into kernel"
 	#endif
 
-	/* output must be kept under PAGE_SIZE */
-	out += sprintf(out, BANNER);
-	out += sprintf(out, "Load type: " MODULEPROCSTRING "\n\n");
-	out += sprintf(out, "frequency = %lu kHz\n",
+	seq_puts(m, BANNER);
+	seq_puts(m, "Load type: " MODULEPROCSTRING "\n\n");
+	seq_printf(m, "frequency = %lu kHz\n",
 		typhoon_unit.curfreq >> 4);
-	out += sprintf(out, "volume = %d\n", typhoon_unit.curvol);
-	out += sprintf(out, "mute = %s\n", typhoon_unit.muted ?
+	seq_printf(m, "volume = %d\n", typhoon_unit.curvol);
+	seq_printf(m, "mute = %s\n", typhoon_unit.muted ?
 		"on" : "off");
-	out += sprintf(out, "iobase = 0x%x\n", typhoon_unit.iobase);
-	out += sprintf(out, "mute frequency = %lu kHz\n",
+	seq_printf(m, "iobase = 0x%x\n", typhoon_unit.iobase);
+	seq_printf(m, "mute frequency = %lu kHz\n",
 		typhoon_unit.mutefreq >> 4);
-	return out - buf;
+	return 0;
 }
 
+static int typhoon_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, typhoon_proc_show, NULL);
+}
+
+static const struct file_operations typhoon_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= typhoon_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 #endif /* CONFIG_RADIO_TYPHOON_PROC_FS */
 
 MODULE_AUTHOR("Dr. Henrik Seidel");
@@ -452,8 +459,7 @@ static int __init typhoon_init(void)
 	typhoon_mute(&typhoon_unit);
 
 #ifdef CONFIG_RADIO_TYPHOON_PROC_FS
-	if (!create_proc_info_entry("driver/radio-typhoon", 0, NULL,
-				    typhoon_get_info))
+	if (!proc_create("driver/radio-typhoon", 0, NULL, &typhoon_proc_fops))
 		printk(KERN_ERR "radio-typhoon: registering /proc/driver/radio-typhoon failed\n");
 #endif
 
_

Patches currently in -mm which might be from adobriyan@sw.ru are

git-x86.patch
git-dvb.patch
git-net.patch
git-cryptodev.patch
keys-switch-to-proc_create.patch
proc-print-more-information-when-removing-non-empty-directories.patch
proc-switch-to-proc_create.patch
proc-switch-proc-driver-ray_cs-ray_cs-to-seq_file-interface.patch
proc-switch-proc-bus-zorro-devices-to-seq_file-interface.patch
proc-switch-proc-apm-to-seq_file-interface.patch
proc-remove-proc-mac_iop.patch
proc-switch-proc-bus-ecard-devices-to-seq_file-interface.patch
proc-switch-proc-excite-unit_id-to-seq_file-interface.patch
proc-switch-proc-irda-irnet-to-seq_file-interface.patch
proc-convert-proc-bus-nubus-to-seq_file-interface.patch
proc-switch-proc-ip2mem-to-seq_file-interface.patch
proc-switch-proc-scsi-device_info-to-seq_file-interface.patch
proc-remove-get_info-infrastructure.patch
sysctl-merge-equal-proc_sys_read-and-proc_sys_write.patch
sysctl-clean-from-unneeded-extern-and-forward-declarations.patch
sysctl-add-the-permissions-callback-on-the-ctl_table_root.patch
single_open-seq_release-leak-diagnostics.patch

