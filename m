From: akpm@linux-foundation.org
Subject: + proc-convert-proc-bus-nubus-to-seq_file-interface.patch added to -mm tree
Date: Thu, 10 Apr 2008 14:34:55 -0700
Message-ID: <200804102134.m3ALYteh018481@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56583 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757394AbYDJVgM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Apr 2008 17:36:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru, geert@linux-m68k.org


The patch titled
     proc: convert /proc/bus/nubus to seq_file interface
has been added to the -mm tree.  Its filename is
     proc-convert-proc-bus-nubus-to-seq_file-interface.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: convert /proc/bus/nubus to seq_file interface
From: Alexey Dobriyan <adobriyan@sw.ru>

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/nubus/proc.c |   42 +++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

diff -puN drivers/nubus/proc.c~proc-convert-proc-bus-nubus-to-seq_file-interface drivers/nubus/proc.c
--- a/drivers/nubus/proc.c~proc-convert-proc-bus-nubus-to-seq_file-interface
+++ a/drivers/nubus/proc.c
@@ -21,6 +21,7 @@
 #include <linux/kernel.h>
 #include <linux/nubus.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/init.h>
 #include <linux/module.h>
 
@@ -28,38 +29,36 @@
 #include <asm/byteorder.h>
 
 static int
-get_nubus_dev_info(char *buf, char **start, off_t pos, int count)
+nubus_devices_proc_show(struct seq_file *m, void *v)
 {
 	struct nubus_dev *dev = nubus_devices;
-	off_t at = 0;
-	int len, cnt;
 
-	cnt = 0;
-	while (dev && count > cnt) {
-		len = sprintf(buf, "%x\t%04x %04x %04x %04x",
+	while (dev) {
+		seq_printf(m, "%x\t%04x %04x %04x %04x",
 			      dev->board->slot,
 			      dev->category,
 			      dev->type,
 			      dev->dr_sw,
 			      dev->dr_hw);
-		len += sprintf(buf+len,
-			       "\t%08lx",
-			       dev->board->slot_addr);
-		buf[len++] = '\n';
-		at += len;
-		if (at >= pos) {
-			if (!*start) {
-				*start = buf + (pos - (at - len));
-				cnt = at - pos;
-			} else
-				cnt += len;
-			buf += len;
-		}
+		seq_printf(m, "\t%08lx\n", dev->board->slot_addr);
 		dev = dev->next;
 	}
-	return (count > cnt) ? cnt : count;
+	return 0;
+}
+
+static int nubus_devices_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, nubus_devices_proc_show, NULL);
 }
 
+static const struct file_operations nubus_devices_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= nubus_devices_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static struct proc_dir_entry *proc_bus_nubus_dir;
 
 static void nubus_proc_subdir(struct nubus_dev* dev,
@@ -172,7 +171,6 @@ void __init nubus_proc_init(void)
 	if (!MACH_IS_MAC)
 		return;
 	proc_bus_nubus_dir = proc_mkdir("bus/nubus", NULL);
-	create_proc_info_entry("devices", 0, proc_bus_nubus_dir,
-				get_nubus_dev_info);
+	proc_create("devices", 0, proc_bus_nubus_dir, &nubus_devices_proc_fops);
 	proc_bus_nubus_add_devices();
 }
_

Patches currently in -mm which might be from adobriyan@sw.ru are

git-x86.patch
git-net.patch
git-cryptodev.patch
keys-switch-to-proc_create.patch
proc-print-more-information-when-removing-non-empty-directories.patch
proc-switch-to-proc_create.patch
proc-switch-proc-driver-ray_cs-ray_cs-to-seq_file-interface.patch
proc-switch-proc-driver-radio-typhoon-to-seq_file-interface.patch
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

