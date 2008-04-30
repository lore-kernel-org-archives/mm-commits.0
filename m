From: akpm@linux-foundation.org
Subject: - proc-convert-proc-bus-nubus-to-seq_file-interface.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:46:22 -0700
Message-ID: <200804300546.m3U5kMlK029612@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33675 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758179AbYD3Frj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:47:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     proc: convert /proc/bus/nubus to seq_file interface
has been removed from the -mm tree.  Its filename was
     proc-convert-proc-bus-nubus-to-seq_file-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
single_open-seq_release-leak-diagnostics.patch

