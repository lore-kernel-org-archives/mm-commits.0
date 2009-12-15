From: akpm@linux-foundation.org
Subject: [merged] uml-convert-to-seq_file-proc_fops.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:55:20 -0800
Message-ID: <200912152155.nBFLtKMS015479@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52771 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761282AbZLOV4B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:56:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, jdike@addtoit.com, mm-commits@vger.kernel.org


The patch titled
     uml: convert to seq_file/proc_fops
has been removed from the -mm tree.  Its filename was
     uml-convert-to-seq_file-proc_fops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: convert to seq_file/proc_fops
From: Alexey Dobriyan <adobriyan@gmail.com>

Convert code away from ->read_proc/->write_proc interfaces.  Switch to
proc_create()/proc_create_data() which make addition of proc entries
reliable wrt NULL ->proc_fops, NULL ->data and so on.

Problem with ->read_proc et al is described here commit
786d7e1612f0b0adb6046f19b906609e4fe8b1ba "Fix rmmod/read/write races in
/proc entries"

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/mconsole_kern.c |   14 +++++----
 arch/um/drivers/ubd_kern.c      |   34 +++++++++++------------
 arch/um/kernel/exitcode.c       |   43 ++++++++++++++++--------------
 arch/um/kernel/process.c        |   31 ++++++++++++++-------
 4 files changed, 69 insertions(+), 53 deletions(-)

diff -puN arch/um/drivers/mconsole_kern.c~uml-convert-to-seq_file-proc_fops arch/um/drivers/mconsole_kern.c
--- a/arch/um/drivers/mconsole_kern.c~uml-convert-to-seq_file-proc_fops
+++ a/arch/um/drivers/mconsole_kern.c
@@ -833,8 +833,8 @@ static int __init mconsole_init(void)
 
 __initcall(mconsole_init);
 
-static int write_proc_mconsole(struct file *file, const char __user *buffer,
-			       unsigned long count, void *data)
+static ssize_t mconsole_proc_write(struct file *file,
+		const char __user *buffer, size_t count, loff_t *pos)
 {
 	char *buf;
 
@@ -855,6 +855,11 @@ static int write_proc_mconsole(struct fi
 	return count;
 }
 
+static const struct file_operations mconsole_proc_fops = {
+	.owner		= THIS_MODULE,
+	.write		= mconsole_proc_write,
+};
+
 static int create_proc_mconsole(void)
 {
 	struct proc_dir_entry *ent;
@@ -862,15 +867,12 @@ static int create_proc_mconsole(void)
 	if (notify_socket == NULL)
 		return 0;
 
-	ent = create_proc_entry("mconsole", S_IFREG | 0200, NULL);
+	ent = proc_create("mconsole", 0200, NULL, &mconsole_proc_fops);
 	if (ent == NULL) {
 		printk(KERN_INFO "create_proc_mconsole : create_proc_entry "
 		       "failed\n");
 		return 0;
 	}
-
-	ent->read_proc = NULL;
-	ent->write_proc = write_proc_mconsole;
 	return 0;
 }
 
diff -puN arch/um/drivers/ubd_kern.c~uml-convert-to-seq_file-proc_fops arch/um/drivers/ubd_kern.c
--- a/arch/um/drivers/ubd_kern.c~uml-convert-to-seq_file-proc_fops
+++ a/arch/um/drivers/ubd_kern.c
@@ -27,6 +27,7 @@
 #include "linux/init.h"
 #include "linux/cdrom.h"
 #include "linux/proc_fs.h"
+#include "linux/seq_file.h"
 #include "linux/ctype.h"
 #include "linux/capability.h"
 #include "linux/mm.h"
@@ -200,23 +201,25 @@ static void make_proc_ide(void)
 	proc_ide = proc_mkdir("ide0", proc_ide_root);
 }
 
-static int proc_ide_read_media(char *page, char **start, off_t off, int count,
-			       int *eof, void *data)
+static int fake_ide_media_proc_show(struct seq_file *m, void *v)
 {
-	int len;
+	seq_puts(m, "disk\n");
+	return 0;
+}
 
-	strcpy(page, "disk\n");
-	len = strlen("disk\n");
-	len -= off;
-	if (len < count){
-		*eof = 1;
-		if (len <= 0) return 0;
-	}
-	else len = count;
-	*start = page + off;
-	return len;
+static int fake_ide_media_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, fake_ide_media_proc_show, NULL);
 }
 
+static const struct file_operations fake_ide_media_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= fake_ide_media_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static void make_ide_entries(const char *dev_name)
 {
 	struct proc_dir_entry *dir, *ent;
@@ -227,11 +230,8 @@ static void make_ide_entries(const char 
 	dir = proc_mkdir(dev_name, proc_ide);
 	if(!dir) return;
 
-	ent = create_proc_entry("media", S_IFREG|S_IRUGO, dir);
+	ent = proc_create("media", S_IRUGO, dir, &fake_ide_media_proc_fops);
 	if(!ent) return;
-	ent->data = NULL;
-	ent->read_proc = proc_ide_read_media;
-	ent->write_proc = NULL;
 	snprintf(name, sizeof(name), "ide0/%s", dev_name);
 	proc_symlink(dev_name, proc_ide_root, name);
 }
diff -puN arch/um/kernel/exitcode.c~uml-convert-to-seq_file-proc_fops arch/um/kernel/exitcode.c
--- a/arch/um/kernel/exitcode.c~uml-convert-to-seq_file-proc_fops
+++ a/arch/um/kernel/exitcode.c
@@ -6,7 +6,9 @@
 #include <linux/ctype.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/types.h>
 #include <asm/uaccess.h>
 
@@ -16,30 +18,26 @@
  */
 int uml_exitcode = 0;
 
-static int read_proc_exitcode(char *page, char **start, off_t off,
-			      int count, int *eof, void *data)
+static int exitcode_proc_show(struct seq_file *m, void *v)
 {
-	int len, val;
+	int val;
 
 	/*
 	 * Save uml_exitcode in a local so that we don't need to guarantee
 	 * that sprintf accesses it atomically.
 	 */
 	val = uml_exitcode;
-	len = sprintf(page, "%d\n", val);
-	len -= off;
-	if (len <= off+count)
-		*eof = 1;
-	*start = page + off;
-	if (len > count)
-		len = count;
-	if (len < 0)
-		len = 0;
-	return len;
+	seq_printf(m, "%d\n", val);
+	return 0;
+}
+
+static int exitcode_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, exitcode_proc_show, NULL);
 }
 
-static int write_proc_exitcode(struct file *file, const char __user *buffer,
-			       unsigned long count, void *data)
+static ssize_t exitcode_proc_write(struct file *file,
+		const char __user *buffer, size_t count, loff_t *pos)
 {
 	char *end, buf[sizeof("nnnnn\0")];
 	int tmp;
@@ -55,20 +53,25 @@ static int write_proc_exitcode(struct fi
 	return count;
 }
 
+static const struct file_operations exitcode_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= exitcode_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= exitcode_proc_write,
+};
+
 static int make_proc_exitcode(void)
 {
 	struct proc_dir_entry *ent;
 
-	ent = create_proc_entry("exitcode", 0600, NULL);
+	ent = proc_create("exitcode", 0600, NULL, &exitcode_proc_fops);
 	if (ent == NULL) {
 		printk(KERN_WARNING "make_proc_exitcode : Failed to register "
 		       "/proc/exitcode\n");
 		return 0;
 	}
-
-	ent->read_proc = read_proc_exitcode;
-	ent->write_proc = write_proc_exitcode;
-
 	return 0;
 }
 
diff -puN arch/um/kernel/process.c~uml-convert-to-seq_file-proc_fops arch/um/kernel/process.c
--- a/arch/um/kernel/process.c~uml-convert-to-seq_file-proc_fops
+++ a/arch/um/kernel/process.c
@@ -9,11 +9,13 @@
 #include <linux/hardirq.h>
 #include <linux/gfp.h>
 #include <linux/mm.h>
+#include <linux/module.h>
 #include <linux/personality.h>
 #include <linux/proc_fs.h>
 #include <linux/ptrace.h>
 #include <linux/random.h>
 #include <linux/sched.h>
+#include <linux/seq_file.h>
 #include <linux/tick.h>
 #include <linux/threads.h>
 #include <asm/current.h>
@@ -336,16 +338,19 @@ int get_using_sysemu(void)
 	return atomic_read(&using_sysemu);
 }
 
-static int proc_read_sysemu(char *buf, char **start, off_t offset, int size,int *eof, void *data)
+static int sysemu_proc_show(struct seq_file *m, void *v)
 {
-	if (snprintf(buf, size, "%d\n", get_using_sysemu()) < size)
-		/* No overflow */
-		*eof = 1;
+	seq_printf(m, "%d\n", get_using_sysemu());
+	return 0;
+}
 
-	return strlen(buf);
+static int sysemu_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, sysemu_proc_show, NULL);
 }
 
-static int proc_write_sysemu(struct file *file,const char __user *buf, unsigned long count,void *data)
+static ssize_t sysemu_proc_write(struct file *file, const char __user *buf,
+				 size_t count, loff_t *pos)
 {
 	char tmp[2];
 
@@ -358,13 +363,22 @@ static int proc_write_sysemu(struct file
 	return count;
 }
 
+static const struct file_operations sysemu_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= sysemu_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= sysemu_proc_write,
+};
+
 int __init make_proc_sysemu(void)
 {
 	struct proc_dir_entry *ent;
 	if (!sysemu_supported)
 		return 0;
 
-	ent = create_proc_entry("sysemu", 0600, NULL);
+	ent = proc_create("sysemu", 0600, NULL, &sysemu_proc_fops);
 
 	if (ent == NULL)
 	{
@@ -372,9 +386,6 @@ int __init make_proc_sysemu(void)
 		return 0;
 	}
 
-	ent->read_proc  = proc_read_sysemu;
-	ent->write_proc = proc_write_sysemu;
-
 	return 0;
 }
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
asus_acpi-convert-to-seq_file.patch
toshiba_acpi-convert-to-seq_file.patch
thinkpad_acpi-convert-to-seq_file.patch
arm-convert-proc-cpu-aligment-to-seq_file.patch
arm-convert-proc-cpu-aligment-to-seq_file-fix.patch
iseries-convert-to-proc_fops.patch
proc_fops-convert-av7110.patch
proc_fops-convert-drivers-isdn-to-seq_file.patch
proc_fops-convert-drivers-isdn-to-seq_file-fix.patch
proc_fops-convert-drivers-isdn-to-seq_file-fix2.patch
parisc-convert-proc-pdc-lcdled-to-seq_file.patch
mpt-fusion-convert-to-seq_file.patch
uml-irq-register-race-condition.patch
proc-rename-de_get-to-pde_get-and-inline-it.patch
clps711xfb-convert-to-proc_fops.patch
pnpbios-convert-to-seq_file.patch
const-constify-remaining-pipe_buf_operations.patch
ufs-pass-qstr-instead-of-dentry-where-necessary-for-nfs.patch
ufs-nfs-support.patch
reiserfs-remove-proc-fs-reiserfs-version.patch
reiserfs-dont-compile-procfso-at-all-if-no-support.patch
proc-remove-docbook-and-example.patch
seq_file-use-proc_create-in-documentation.patch

