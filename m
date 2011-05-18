From: akpm@linux-foundation.org
Subject: + mtd-convert-to-seq_file-interface.patch added to -mm tree
Date: Wed, 18 May 2011 12:45:20 -0700
Message-ID: <201105181945.p4IJjKCr019502@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54473 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751188Ab1ERTqQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 May 2011 15:46:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, cbouatmailru@gmail.com, dwmw2@infradead.org, vapier@gentoo.org


The patch titled
     mtd: convert to seq_file interface
has been added to the -mm tree.  Its filename is
     mtd-convert-to-seq_file-interface.patch

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
Subject: mtd: convert to seq_file interface
From: Alexey Dobriyan <adobriyan@gmail.com>

The ->read_proc interface is going away, switch to seq_file.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Mike Frysinger <vapier@gentoo.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/mtdcore.c |   50 +++++++++++++++-------------------------
 1 file changed, 19 insertions(+), 31 deletions(-)

diff -puN drivers/mtd/mtdcore.c~mtd-convert-to-seq_file-interface drivers/mtd/mtdcore.c
--- a/drivers/mtd/mtdcore.c~mtd-convert-to-seq_file-interface
+++ a/drivers/mtd/mtdcore.c
@@ -24,6 +24,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/ptrace.h>
+#include <linux/seq_file.h>
 #include <linux/string.h>
 #include <linux/timer.h>
 #include <linux/major.h>
@@ -656,44 +657,32 @@ EXPORT_SYMBOL_GPL(default_mtd_writev);
 
 static struct proc_dir_entry *proc_mtd;
 
-static inline int mtd_proc_info(char *buf, struct mtd_info *this)
-{
-	return sprintf(buf, "mtd%d: %8.8llx %8.8x \"%s\"\n", this->index,
-		       (unsigned long long)this->size,
-		       this->erasesize, this->name);
-}
-
-static int mtd_read_proc (char *page, char **start, off_t off, int count,
-			  int *eof, void *data_unused)
+static int mtd_proc_show(struct seq_file *m, void *v)
 {
 	struct mtd_info *mtd;
-	int len, l;
-        off_t   begin = 0;
 
+	seq_puts(m, "dev:    size   erasesize  name\n");
 	mutex_lock(&mtd_table_mutex);
-
-	len = sprintf(page, "dev:    size   erasesize  name\n");
 	mtd_for_each_device(mtd) {
-		l = mtd_proc_info(page + len, mtd);
-                len += l;
-                if (len+begin > off+count)
-                        goto done;
-                if (len+begin < off) {
-                        begin += len;
-                        len = 0;
-                }
+		seq_printf(m, "mtd%d: %8.8llx %8.8x \"%s\"\n",
+			   mtd->index, (unsigned long long)mtd->size,
+			   mtd->erasesize, mtd->name);
         }
-
-        *eof = 1;
-
-done:
 	mutex_unlock(&mtd_table_mutex);
-        if (off >= len+begin)
-                return 0;
-        *start = page + (off-begin);
-        return ((count < begin+len-off) ? count : begin+len-off);
+        return 0;
 }
 
+static int mtd_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, mtd_proc_show, NULL);
+}
+
+static const struct file_operations mtd_proc_ops = {
+	.open		= mtd_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 #endif /* CONFIG_PROC_FS */
 
 /*====================================================================*/
@@ -734,8 +723,7 @@ static int __init init_mtd(void)
 		goto err_bdi3;
 
 #ifdef CONFIG_PROC_FS
-	if ((proc_mtd = create_proc_entry( "mtd", 0, NULL )))
-		proc_mtd->read_proc = mtd_read_proc;
+	proc_mtd = proc_create("mtd", 0, NULL, &mtd_proc_ops);
 #endif /* CONFIG_PROC_FS */
 	return 0;
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
mtd-convert-to-seq_file-interface.patch
mm-add-__nocast-attribute-to-vm_flags.patch
fremap-convert-vm_flags-to-unsigned-long-long.patch
procfs-convert-vm_flags-to-unsigned-long-long.patch
lib-add-kstrto_from_user.patch
kstrtox-convert-fs-proc.patch
proc-constify-status-array.patch
proc-stat-use-defined-macro-kmalloc_max_size.patch
proc-put-check_mem_permission-after-__get_free_page-in-mem_write.patch
proc-fix-pagemap_read-error-case.patch
fs-proc-vmcorec-add-hook-to-read_from_oldmem-to-check-for-non-ram-pages.patch
ipmi-convert-to-seq_file-interface.patch
sysctl-add-proc_dointvec_bool-handler.patch

