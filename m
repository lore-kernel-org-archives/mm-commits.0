From: akpm@linux-foundation.org
Subject: [merged] ray_cs-convert-to-proc_fops.patch removed from -mm tree
Date: Mon, 30 Nov 2009 12:34:28 -0800
Message-ID: <200911302034.nAUKYSR7023628@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52707 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752778AbZK3Uey (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Nov 2009 15:34:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, coreythomas@charter.net, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     ray_cs: convert to proc_fops
has been removed from the -mm tree.  Its filename was
     ray_cs-convert-to-proc_fops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ray_cs: convert to proc_fops
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Corey Thomas <coreythomas@charter.net>
Cc: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/ray_cs.c |   36 ++++++++++++++++----------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff -puN drivers/net/wireless/ray_cs.c~ray_cs-convert-to-proc_fops drivers/net/wireless/ray_cs.c
--- a/drivers/net/wireless/ray_cs.c~ray_cs-convert-to-proc_fops
+++ a/drivers/net/wireless/ray_cs.c
@@ -2856,18 +2856,8 @@ static int build_auth_frame(ray_dev_t *l
 
 /*===========================================================================*/
 #ifdef CONFIG_PROC_FS
-static void raycs_write(const char *name, write_proc_t *w, void *data)
-{
-	struct proc_dir_entry *entry =
-	    create_proc_entry(name, S_IFREG | S_IWUSR, NULL);
-	if (entry) {
-		entry->write_proc = w;
-		entry->data = data;
-	}
-}
-
-static int write_essid(struct file *file, const char __user *buffer,
-		       unsigned long count, void *data)
+static ssize_t ray_cs_essid_proc_write(struct file *file,
+		const char __user *buffer, size_t count, loff_t *pos)
 {
 	static char proc_essid[33];
 	unsigned int len = count;
@@ -2881,8 +2871,13 @@ static int write_essid(struct file *file
 	return count;
 }
 
-static int write_int(struct file *file, const char __user *buffer,
-		     unsigned long count, void *data)
+static const struct file_operations ray_cs_essid_proc_fops = {
+	.owner		= THIS_MODULE,
+	.write		= ray_cs_essid_proc_write,
+};
+
+static ssize_t int_proc_write(struct file *file, const char __user *buffer,
+			      size_t count, loff_t *pos)
 {
 	static char proc_number[10];
 	char *p;
@@ -2905,9 +2900,14 @@ static int write_int(struct file *file, 
 		nr = nr * 10 + c;
 		p++;
 	} while (--len);
-	*(int *)data = nr;
+	*(int *)PDE(file->f_path.dentry->d_inode)->data = nr;
 	return count;
 }
+
+static const struct file_operations int_proc_fops = {
+	.owner		= THIS_MODULE,
+	.write		= int_proc_write,
+};
 #endif
 
 static struct pcmcia_device_id ray_ids[] = {
@@ -2942,9 +2942,9 @@ static int __init init_ray_cs(void)
 	proc_mkdir("driver/ray_cs", NULL);
 
 	proc_create("driver/ray_cs/ray_cs", 0, NULL, &ray_cs_proc_fops);
-	raycs_write("driver/ray_cs/essid", write_essid, NULL);
-	raycs_write("driver/ray_cs/net_type", write_int, &net_type);
-	raycs_write("driver/ray_cs/translate", write_int, &translate);
+	proc_create("driver/ray_cs/essid", S_IWUSR, NULL, &ray_cs_essid_proc_fops);
+	proc_create_data("driver/ray_cs/net_type", S_IWUSR, NULL, &int_proc_fops, &net_type);
+	proc_create_data("driver/ray_cs/translate", S_IWUSR, NULL, &int_proc_fops, &translate);
 #endif
 	if (translate != 0)
 		translate = 1;
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

