From: akpm@osdl.org
Subject: + seq_file-conversion-apm-on-i386.patch added to -mm tree
Date: Thu, 11 Jan 2007 14:06:50 -0800
Message-ID: <200701112206.l0BM6oD8004417@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38396 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932154AbXAKWHa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jan 2007 17:07:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, ak@suse.de, sfr@canb.auug.org.au


The patch titled
     seq_file conversion: APM on i386
has been added to the -mm tree.  Its filename is
     seq_file-conversion-apm-on-i386.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: seq_file conversion: APM on i386
From: Alexey Dobriyan <adobriyan@gmail.com>

Byte-to-byte identical /proc/apm here.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/apm.c |   26 ++++++++++++++++++--------
 1 files changed, 18 insertions(+), 8 deletions(-)

diff -puN arch/i386/kernel/apm.c~seq_file-conversion-apm-on-i386 arch/i386/kernel/apm.c
--- a/arch/i386/kernel/apm.c~seq_file-conversion-apm-on-i386
+++ a/arch/i386/kernel/apm.c
@@ -211,6 +211,7 @@
 #include <linux/slab.h>
 #include <linux/stat.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/miscdevice.h>
 #include <linux/apm_bios.h>
 #include <linux/init.h>
@@ -1636,9 +1637,8 @@ static int do_open(struct inode * inode,
 	return 0;
 }
 
-static int apm_get_info(char *buf, char **start, off_t fpos, int length)
+static int proc_apm_show(struct seq_file *m, void *v)
 {
-	char *		p;
 	unsigned short	bx;
 	unsigned short	cx;
 	unsigned short	dx;
@@ -1650,8 +1650,6 @@ static int apm_get_info(char *buf, char 
 	int             time_units     = -1;
 	char            *units         = "?";
 
-	p = buf;
-
 	if ((num_online_cpus() == 1) &&
 	    !(error = apm_get_power_status(&bx, &cx, &dx))) {
 		ac_line_status = (bx >> 8) & 0xff;
@@ -1705,7 +1703,7 @@ static int apm_get_info(char *buf, char 
 	      -1: Unknown
 	   8) min = minutes; sec = seconds */
 
-	p += sprintf(p, "%s %d.%d 0x%02x 0x%02x 0x%02x 0x%02x %d%% %d %s\n",
+	seq_printf(m, "%s %d.%d 0x%02x 0x%02x 0x%02x 0x%02x %d%% %d %s\n",
 		     driver_version,
 		     (apm_info.bios.version >> 8) & 0xff,
 		     apm_info.bios.version & 0xff,
@@ -1716,10 +1714,22 @@ static int apm_get_info(char *buf, char 
 		     percentage,
 		     time_units,
 		     units);
+	return 0;
+}
 
-	return p - buf;
+static int proc_apm_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, proc_apm_show, NULL);
 }
 
+static const struct file_operations apm_file_ops = {
+	.owner		= THIS_MODULE,
+	.open		= proc_apm_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static int apm(void *unused)
 {
 	unsigned short	bx;
@@ -2341,9 +2351,9 @@ static int __init apm_init(void)
 	set_base(gdt[APM_DS >> 3],
 		 __va((unsigned long)apm_info.bios.dseg << 4));
 
-	apm_proc = create_proc_info_entry("apm", 0, NULL, apm_get_info);
+	apm_proc = create_proc_entry("apm", 0, NULL);
 	if (apm_proc)
-		apm_proc->owner = THIS_MODULE;
+		apm_proc->proc_fops = &apm_file_ops;
 
 	kapmd_task = kthread_create(apm, NULL, "kapmd");
 	if (IS_ERR(kapmd_task)) {
_

Patches currently in -mm which might be from adobriyan@gmail.com are

git-dvb.patch
cpiac-buffer-overflow.patch
git-mtd.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
seq_file-conversion-apm-on-i386.patch
proc-remove-useless-and-buggy-nlink-settings.patch
