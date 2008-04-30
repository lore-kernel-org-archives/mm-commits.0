From: akpm@linux-foundation.org
Subject: - proc-switch-proc-apm-to-seq_file-interface.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:46:08 -0700
Message-ID: <200804300546.m3U5k84h029578@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33803 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758545AbYD3Frn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:47:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, len.brown@intel.com, mingo@elte.hu, ralf@linux-mips.org, rjw@sisk.pl, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     proc: switch /proc/apm to seq_file interface
has been removed from the -mm tree.  Its filename was
     proc-switch-proc-apm-to-seq_file-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: switch /proc/apm to seq_file interface
From: Alexey Dobriyan <adobriyan@sw.ru>

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/apm-emulation.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff -puN drivers/char/apm-emulation.c~proc-switch-proc-apm-to-seq_file-interface drivers/char/apm-emulation.c
--- a/drivers/char/apm-emulation.c~proc-switch-proc-apm-to-seq_file-interface
+++ a/drivers/char/apm-emulation.c
@@ -14,6 +14,7 @@
 #include <linux/poll.h>
 #include <linux/slab.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/miscdevice.h>
 #include <linux/apm_bios.h>
 #include <linux/capability.h>
@@ -493,11 +494,10 @@ static struct miscdevice apm_device = {
  *	-1: Unknown
  *   8) min = minutes; sec = seconds
  */
-static int apm_get_info(char *buf, char **start, off_t fpos, int length)
+static int proc_apm_show(struct seq_file *m, void *v)
 {
 	struct apm_power_info info;
 	char *units;
-	int ret;
 
 	info.ac_line_status = 0xff;
 	info.battery_status = 0xff;
@@ -515,14 +515,27 @@ static int apm_get_info(char *buf, char 
 	case 1: 	units = "sec";	break;
 	}
 
-	ret = sprintf(buf, "%s 1.2 0x%02x 0x%02x 0x%02x 0x%02x %d%% %d %s\n",
+	seq_printf(m, "%s 1.2 0x%02x 0x%02x 0x%02x 0x%02x %d%% %d %s\n",
 		     driver_version, APM_32_BIT_SUPPORT,
 		     info.ac_line_status, info.battery_status,
 		     info.battery_flag, info.battery_life,
 		     info.time, units);
 
-	return ret;
+	return 0;
 }
+
+static int proc_apm_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, proc_apm_show, NULL);
+}
+
+static const struct file_operations apm_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= proc_apm_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 #endif
 
 static int kapmd(void *arg)
@@ -593,7 +606,7 @@ static int __init apm_init(void)
 	wake_up_process(kapmd_tsk);
 
 #ifdef CONFIG_PROC_FS
-	create_proc_info_entry("apm", 0, NULL, apm_get_info);
+	proc_create("apm", 0, NULL, &apm_proc_fops);
 #endif
 
 	ret = misc_register(&apm_device);
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
single_open-seq_release-leak-diagnostics.patch

