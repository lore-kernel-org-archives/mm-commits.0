From: akpm@linux-foundation.org
Subject: + proc-switch-proc-bus-zorro-devices-to-seq_file-interface.patch added to -mm tree
Date: Thu, 10 Apr 2008 14:34:41 -0700
Message-ID: <200804102134.m3ALYfXF018463@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47108 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759303AbYDJVgB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Apr 2008 17:36:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru, geert@linux-m68k.org, jsipek@fsl.cs.sunysb.edu


The patch titled
     proc: switch /proc/bus/zorro/devices to seq_file interface
has been added to the -mm tree.  Its filename is
     proc-switch-proc-bus-zorro-devices-to-seq_file-interface.patch

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
Subject: proc: switch /proc/bus/zorro/devices to seq_file interface
From: Alexey Dobriyan <adobriyan@sw.ru>

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/zorro/proc.c |   70 ++++++++++++++++++++++++++---------------
 1 file changed, 46 insertions(+), 24 deletions(-)

diff -puN drivers/zorro/proc.c~proc-switch-proc-bus-zorro-devices-to-seq_file-interface drivers/zorro/proc.c
--- a/drivers/zorro/proc.c~proc-switch-proc-bus-zorro-devices-to-seq_file-interface
+++ a/drivers/zorro/proc.c
@@ -13,6 +13,7 @@
 #include <linux/types.h>
 #include <linux/zorro.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/init.h>
 #include <linux/smp_lock.h>
 #include <asm/uaccess.h>
@@ -80,32 +81,53 @@ static const struct file_operations proc
 	.read		= proc_bus_zorro_read,
 };
 
-static int
-get_zorro_dev_info(char *buf, char **start, off_t pos, int count)
+static void * zorro_seq_start(struct seq_file *m, loff_t *pos)
 {
-	u_int slot;
-	off_t at = 0;
-	int len, cnt;
+	return (*pos < zorro_num_autocon) ? pos : NULL;
+}
 
-	for (slot = cnt = 0; slot < zorro_num_autocon && count > cnt; slot++) {
-		struct zorro_dev *z = &zorro_autocon[slot];
-		len = sprintf(buf, "%02x\t%08x\t%08lx\t%08lx\t%02x\n", slot,
-			      z->id, (unsigned long)zorro_resource_start(z),
-			      (unsigned long)zorro_resource_len(z),
-			      z->rom.er_Type);
-		at += len;
-		if (at >= pos) {
-			if (!*start) {
-				*start = buf + (pos - (at - len));
-				cnt = at - pos;
-			} else
-				cnt += len;
-			buf += len;
-		}
-	}
-	return (count > cnt) ? cnt : count;
+static void * zorro_seq_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	(*pos)++;
+	return (*pos < zorro_num_autocon) ? pos : NULL;
+}
+
+static void zorro_seq_stop(struct seq_file *m, void *v)
+{
 }
 
+static int zorro_seq_show(struct seq_file *m, void *v)
+{
+	u_int slot = *(loff_t *)v;
+	struct zorro_dev *z = &zorro_autocon[slot];
+
+	seq_printf(m, "%02x\t%08x\t%08lx\t%08lx\t%02x\n", slot, z->id,
+		   (unsigned long)zorro_resource_start(z),
+		   (unsigned long)zorro_resource_len(z),
+		   z->rom.er_Type);
+	return 0;
+}
+
+static const struct seq_operations zorro_devices_seq_ops = {
+	.start = zorro_seq_start,
+	.next  = zorro_seq_next,
+	.stop  = zorro_seq_stop,
+	.show  = zorro_seq_show,
+};
+
+static int zorro_devices_proc_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &zorro_devices_seq_ops);
+}
+
+static const struct file_operations zorro_devices_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= zorro_devices_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
 static struct proc_dir_entry *proc_bus_zorro_dir;
 
 static int __init zorro_proc_attach_device(u_int slot)
@@ -129,8 +151,8 @@ static int __init zorro_proc_init(void)
 
 	if (MACH_IS_AMIGA && AMIGAHW_PRESENT(ZORRO)) {
 		proc_bus_zorro_dir = proc_mkdir("bus/zorro", NULL);
-		create_proc_info_entry("devices", 0, proc_bus_zorro_dir,
-				       get_zorro_dev_info);
+		proc_create("devices", 0, proc_bus_zorro_dir,
+			    &zorro_devices_proc_fops);
 		for (slot = 0; slot < zorro_num_autocon; slot++)
 			zorro_proc_attach_device(slot);
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

