From: akpm@linux-foundation.org
Subject: + alpha-convert-srm-code-to-seq_file.patch added to -mm tree
Date: Tue, 01 Dec 2009 14:05:33 -0800
Message-ID: <200912012205.nB1M5XWW025075@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37791 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752667AbZLAWGH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Dec 2009 17:06:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, ink@jurassic.park.msu.ru, rth@twiddle.net


The patch titled
     alpha: convert srm code to seq_file
has been added to the -mm tree.  Its filename is
     alpha-convert-srm-code-to-seq_file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha: convert srm code to seq_file
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/srm_env.c |   65 +++++++++++++++++-----------------
 1 file changed, 33 insertions(+), 32 deletions(-)

diff -puN arch/alpha/kernel/srm_env.c~alpha-convert-srm-code-to-seq_file arch/alpha/kernel/srm_env.c
--- a/arch/alpha/kernel/srm_env.c~alpha-convert-srm-code-to-seq_file
+++ a/arch/alpha/kernel/srm_env.c
@@ -33,6 +33,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <asm/console.h>
 #include <asm/uaccess.h>
 #include <asm/machvec.h>
@@ -79,42 +80,41 @@ static srm_env_t	srm_named_entries[] = {
 static srm_env_t	srm_numbered_entries[256];
 
 
-static int
-srm_env_read(char *page, char **start, off_t off, int count, int *eof,
-		void *data)
+static int srm_env_proc_show(struct seq_file *m, void *v)
 {
-	int		nbytes;
 	unsigned long	ret;
 	srm_env_t	*entry;
+	char		*page;
 
-	if (off != 0) {
-		*eof = 1;
-		return 0;
-	}
+	entry = (srm_env_t *)m->private;
+	page = (char *)__get_free_page(GFP_USER);
+	if (!page)
+		return -ENOMEM;
 
-	entry	= (srm_env_t *) data;
-	ret	= callback_getenv(entry->id, page, count);
+	ret = callback_getenv(entry->id, page, PAGE_SIZE);
 
 	if ((ret >> 61) == 0) {
-		nbytes = (int) ret;
-		*eof = 1;
+		seq_write(m, page, ret);
+		ret = 0;
 	} else
-		nbytes = -EFAULT;
+		ret = -EFAULT;
+	free_page((unsigned long)page);
+	return ret;
+}
 
-	return nbytes;
+static int srm_env_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, srm_env_proc_show, PDE(inode)->data);
 }
 
-static int
-srm_env_write(struct file *file, const char __user *buffer, unsigned long count,
-		void *data)
+static ssize_t srm_env_proc_write(struct file *file, const char __user *buffer,
+				  size_t count, loff_t *pos)
 {
 	int res;
-	srm_env_t	*entry;
+	srm_env_t	*entry = PDE(file->f_path.dentry->d_inode)->data;
 	char		*buf = (char *) __get_free_page(GFP_USER);
 	unsigned long	ret1, ret2;
 
-	entry = (srm_env_t *) data;
-
 	if (!buf)
 		return -ENOMEM;
 
@@ -140,6 +140,15 @@ srm_env_write(struct file *file, const c
 	return res;
 }
 
+static const struct file_operations srm_env_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= srm_env_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= srm_env_proc_write,
+};
+
 static void
 srm_env_cleanup(void)
 {
@@ -245,15 +254,10 @@ srm_env_init(void)
 	 */
 	entry = srm_named_entries;
 	while (entry->name && entry->id) {
-		entry->proc_entry = create_proc_entry(entry->name,
-				0644, named_dir);
+		entry->proc_entry = proc_create_data(entry->name, 0644, named_dir,
+						     &srm_env_proc_fops, entry);
 		if (!entry->proc_entry)
 			goto cleanup;
-
-		entry->proc_entry->data		= (void *) entry;
-		entry->proc_entry->read_proc	= srm_env_read;
-		entry->proc_entry->write_proc	= srm_env_write;
-
 		entry++;
 	}
 
@@ -264,15 +268,12 @@ srm_env_init(void)
 		entry = &srm_numbered_entries[var_num];
 		entry->name = number[var_num];
 
-		entry->proc_entry = create_proc_entry(entry->name,
-				0644, numbered_dir);
+		entry->proc_entry = proc_create_data(entry->name, 0644, numbered_dir,
+						     &srm_env_proc_fops, entry);
 		if (!entry->proc_entry)
 			goto cleanup;
 
 		entry->id			= var_num;
-		entry->proc_entry->data		= (void *) entry;
-		entry->proc_entry->read_proc	= srm_env_read;
-		entry->proc_entry->write_proc	= srm_env_write;
 	}
 
 	printk(KERN_INFO "%s: version %s loaded successfully\n", NAME,
_

Patches currently in -mm which might be from adobriyan@gmail.com are

linux-next.patch
thinkpad_acpi-convert-to-seq_file.patch
asus_acpi-convert-to-seq_file.patch
toshiba_acpi-convert-to-seq_file.patch
arm-convert-proc-cpu-aligment-to-seq_file.patch
proc_fops-convert-av7110.patch
proc_fops-convert-cpia.patch
proc_fops-convert-drivers-isdn-to-seq_file.patch
proc_fops-convert-drivers-isdn-to-seq_file-fix.patch
mpt-fusion-convert-to-seq_file.patch
const-constify-remaining-dev_pm_ops.patch
uml-irq-register-race-condition.patch
make-debug_bugverbose-default-to-y.patch
proc-rename-de_get-to-pde_get-and-inline-it.patch
pnpbios-convert-to-seq_file.patch
const-constify-remaining-pipe_buf_operations.patch
ufs-pass-qstr-instead-of-dentry-where-necessary-for-nfs.patch
ufs-nfs-support.patch
reiserfs-remove-proc-fs-reiserfs-version.patch
reiserfs-dont-compile-procfso-at-all-if-no-support.patch
uml-convert-to-seq_file-proc_fops.patch
alpha-convert-srm-code-to-seq_file.patch
iseries-convert-to-proc_fops.patch
clps711xfb-convert-to-proc_fops.patch
parisc-convert-proc-pdc-lcdled-to-seq_file.patch
via-pmu-convert-to-proc_fops-seq_file.patch

