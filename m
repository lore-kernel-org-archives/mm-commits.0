From: akpm@linux-foundation.org
Subject: [merged] ipw2x00-convert-to-seq_file.patch removed from -mm tree
Date: Mon, 30 Nov 2009 12:34:31 -0800
Message-ID: <200911302034.nAUKYV6V023752@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36180 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752230AbZK3Uex (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Nov 2009 15:34:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     ipw2x00: convert to seq_file
has been removed from the -mm tree.  Its filename was
     ipw2x00-convert-to-seq_file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipw2x00: convert to seq_file
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/ipw2x00/libipw_module.c |   33 +++++++++++------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff -puN drivers/net/wireless/ipw2x00/libipw_module.c~ipw2x00-convert-to-seq_file drivers/net/wireless/ipw2x00/libipw_module.c
--- a/drivers/net/wireless/ipw2x00/libipw_module.c~ipw2x00-convert-to-seq_file
+++ a/drivers/net/wireless/ipw2x00/libipw_module.c
@@ -248,17 +248,22 @@ u32 libipw_debug_level = 0;
 EXPORT_SYMBOL_GPL(libipw_debug_level);
 static struct proc_dir_entry *libipw_proc = NULL;
 
-static int show_debug_level(char *page, char **start, off_t offset,
-			    int count, int *eof, void *data)
+static int debug_level_proc_show(struct seq_file *m, void *v)
 {
-	return snprintf(page, count, "0x%08X\n", libipw_debug_level);
+	seq_printf(m, "0x%08X\n", libipw_debug_level);
+	return 0;
 }
 
-static int store_debug_level(struct file *file, const char __user * buffer,
-			     unsigned long count, void *data)
+static int debug_level_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, debug_level_proc_show, NULL);
+}
+
+static ssize_t debug_level_proc_write(struct file *file,
+		const char __user *buffer, size_t count, loff_t *pos)
 {
 	char buf[] = "0x00000000\n";
-	unsigned long len = min((unsigned long)sizeof(buf) - 1, count);
+	size_t len = min(sizeof(buf) - 1, count);
 	unsigned long val;
 
 	if (copy_from_user(buf, buffer, len))
@@ -272,6 +277,15 @@ static int store_debug_level(struct file
 
 	return strnlen(buf, len);
 }
+
+static const struct file_operations debug_level_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= debug_level_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= debug_level_proc_write,
+};
 #endif				/* CONFIG_LIBIPW_DEBUG */
 
 static int __init libipw_init(void)
@@ -286,16 +300,13 @@ static int __init libipw_init(void)
 				" proc directory\n");
 		return -EIO;
 	}
-	e = create_proc_entry("debug_level", S_IFREG | S_IRUGO | S_IWUSR,
-			      libipw_proc);
+	e = proc_create("debug_level", S_IRUGO | S_IWUSR, libipw_proc,
+			&debug_level_proc_fops);
 	if (!e) {
 		remove_proc_entry(DRV_NAME, init_net.proc_net);
 		libipw_proc = NULL;
 		return -EIO;
 	}
-	e->read_proc = show_debug_level;
-	e->write_proc = store_debug_level;
-	e->data = NULL;
 #endif				/* CONFIG_LIBIPW_DEBUG */
 
 	printk(KERN_INFO DRV_NAME ": " DRV_DESCRIPTION ", " DRV_VERSION "\n");
_

Patches currently in -mm which might be from adobriyan@gmail.com are

linux-next.patch
thinkpad_acpi-convert-to-seq_file.patch
asus_acpi-convert-to-seq_file.patch
toshiba_acpi-convert-to-seq_file.patch
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

