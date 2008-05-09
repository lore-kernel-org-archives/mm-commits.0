From: akpm@linux-foundation.org
Subject: + ext4-switch-to-seq_files.patch added to -mm tree
Date: Fri, 09 May 2008 12:46:05 -0700
Message-ID: <200805091946.m49Jk5PZ022720@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60697 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754154AbYEITqr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2008 15:46:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, cmm@us.ibm.com, tytso@mit.edu


The patch titled
     ext4: switch to seq_files
has been added to the -mm tree.  Its filename is
     ext4-switch-to-seq_files.patch

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
Subject: ext4: switch to seq_files
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Mingming Cao <cmm@us.ibm.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/mballoc.c |   70 ++++++++++++++++++++++----------------------
 1 file changed, 35 insertions(+), 35 deletions(-)

diff -puN fs/ext4/mballoc.c~ext4-switch-to-seq_files fs/ext4/mballoc.c
--- a/fs/ext4/mballoc.c~ext4-switch-to-seq_files
+++ a/fs/ext4/mballoc.c
@@ -2579,25 +2579,24 @@ ext4_mb_free_committed_blocks(struct sup
 
 
 
-#define MB_PROC_VALUE_READ(name)				\
-static int ext4_mb_read_##name(char *page, char **start,	\
-		off_t off, int count, int *eof, void *data)	\
+#define MB_PROC_FOPS(name)					\
+static int ext4_mb_##name##_proc_show(struct seq_file *m, void *v)	\
 {								\
-	struct ext4_sb_info *sbi = data;			\
-	int len;						\
-	*eof = 1;						\
-	if (off != 0)						\
-		return 0;					\
-	len = sprintf(page, "%ld\n", sbi->s_mb_##name);		\
-	*start = page;						\
-	return len;						\
-}
-
-#define MB_PROC_VALUE_WRITE(name)				\
-static int ext4_mb_write_##name(struct file *file,		\
-		const char __user *buf, unsigned long cnt, void *data)	\
+	struct ext4_sb_info *sbi = m->private;			\
+								\
+	seq_printf(m, "%ld\n", sbi->s_mb_##name);		\
+	return 0;						\
+}								\
+								\
+static int ext4_mb_##name##_proc_open(struct inode *inode, struct file *file)\
+{								\
+	return single_open(file, ext4_mb_##name##_proc_show, PDE(inode)->data);\
+}								\
+								\
+static ssize_t ext4_mb_##name##_proc_write(struct file *file,	\
+		const char __user *buf, size_t cnt, loff_t *ppos)	\
 {								\
-	struct ext4_sb_info *sbi = data;			\
+	struct ext4_sb_info *sbi = PDE(file->f_path.dentry->d_inode)->data;\
 	char str[32];						\
 	long value;						\
 	if (cnt >= sizeof(str))					\
@@ -2609,31 +2608,32 @@ static int ext4_mb_write_##name(struct f
 		return -ERANGE;					\
 	sbi->s_mb_##name = value;				\
 	return cnt;						\
-}
-
-MB_PROC_VALUE_READ(stats);
-MB_PROC_VALUE_WRITE(stats);
-MB_PROC_VALUE_READ(max_to_scan);
-MB_PROC_VALUE_WRITE(max_to_scan);
-MB_PROC_VALUE_READ(min_to_scan);
-MB_PROC_VALUE_WRITE(min_to_scan);
-MB_PROC_VALUE_READ(order2_reqs);
-MB_PROC_VALUE_WRITE(order2_reqs);
-MB_PROC_VALUE_READ(stream_request);
-MB_PROC_VALUE_WRITE(stream_request);
-MB_PROC_VALUE_READ(group_prealloc);
-MB_PROC_VALUE_WRITE(group_prealloc);
+}								\
+								\
+static const struct file_operations ext4_mb_##name##_proc_fops = {	\
+	.owner		= THIS_MODULE,				\
+	.open		= ext4_mb_##name##_proc_open,		\
+	.read		= seq_read,				\
+	.llseek		= seq_lseek,				\
+	.release	= single_release,			\
+	.write		= ext4_mb_##name##_proc_write,		\
+};
+
+MB_PROC_FOPS(stats);
+MB_PROC_FOPS(max_to_scan);
+MB_PROC_FOPS(min_to_scan);
+MB_PROC_FOPS(order2_reqs);
+MB_PROC_FOPS(stream_request);
+MB_PROC_FOPS(group_prealloc);
 
 #define	MB_PROC_HANDLER(name, var)					\
 do {									\
-	proc = create_proc_entry(name, mode, sbi->s_mb_proc);		\
+	proc = proc_create_data(name, mode, sbi->s_mb_proc,		\
+				&ext4_mb_##var##_proc_fops, sbi);	\
 	if (proc == NULL) {						\
 		printk(KERN_ERR "EXT4-fs: can't to create %s\n", name);	\
 		goto err_out;						\
 	}								\
-	proc->data = sbi;						\
-	proc->read_proc  = ext4_mb_read_##var ;				\
-	proc->write_proc = ext4_mb_write_##var;				\
 } while (0)
 
 static int ext4_mb_init_per_dev_proc(struct super_block *sb)
_

Patches currently in -mm which might be from adobriyan@gmail.com are

cpumask-remove-bitmap_scnprintf_len-and-cpumask_scnprintf_len.patch
linux-next.patch
arm-lubbock-fix-compilation.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
git-block.patch
kbuild-escape-meta-characters-in-regular-expression-in-make-tags.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch
ext4-switch-to-seq_files.patch
cifs-switch-to-seq_files.patch
jfs-switch-to-seq_files.patch

