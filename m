From: akpm@linux-foundation.org
Subject: + ray_cs-convert-to-proc_fops.patch added to -mm tree
Date: Wed, 25 Nov 2009 13:11:47 -0800
Message-ID: <200911252111.nAPLBlwB017701@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49104 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933251AbZKYVMX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Nov 2009 16:12:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, coreythomas@charter.net, linville@tuxdriver.com


The patch titled
     ray_cs: convert to proc_fops
has been added to the -mm tree.  Its filename is
     ray_cs-convert-to-proc_fops.patch

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
proc_fops-convert-av7110.patch
proc_fops-convert-cpia.patch
genirq-switch-proc-irq-spurious-to-seq_file.patch
proc_fops-convert-drivers-isdn-to-seq_file.patch
proc_fops-convert-drivers-isdn-to-seq_file-fix.patch
const-constify-remaining-dev_pm_ops.patch
uml-irq-register-race-condition.patch
make-debug_bugverbose-default-to-y.patch
proc-rename-de_get-to-pde_get-and-inline-it.patch
const-constify-remaining-pipe_buf_operations.patch
ufs-pass-qstr-instead-of-dentry-where-necessary-for-nfs.patch
ufs-nfs-support.patch
reiserfs-remove-proc-fs-reiserfs-version.patch
reiserfs-dont-compile-procfso-at-all-if-no-support.patch
mpt-fusion-convert-to-seq_file.patch
ray_cs-convert-to-proc_fops.patch
ipw2x00-convert-to-seq_file.patch
thinkpad_acpi-convert-to-seq_file.patch
asus_acpi-convert-to-seq_file.patch
toshiba_acpi-convert-to-seq_file.patch
pnpbios-convert-to-seq_file.patch

