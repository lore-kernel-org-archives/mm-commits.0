From: akpm@linux-foundation.org
Subject: - seqfile-merge-duplite-code-to-seq_open_private.patch removed from -mm tree
Date: Wed, 10 Oct 2007 15:58:08 -0700
Message-ID: <200710102304.l9AN4NNq030404@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47002 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756720AbXJJXEw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Oct 2007 19:04:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     seqfile: merge duplicate code to seq_open_private()
has been removed from the -mm tree.  Its filename was
     seqfile-merge-duplite-code-to-seq_open_private.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: seqfile: merge duplicate code to seq_open_private()
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

There are dozens of calls to seq_open() that need to set m->private.
Introduce seq_open_private() to remove code duplications.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/client.c          |   24 ++----------------------
 fs/seq_file.c            |   10 ++++++++++
 include/linux/seq_file.h |    1 +
 3 files changed, 13 insertions(+), 22 deletions(-)

diff -puN fs/nfs/client.c~seqfile-merge-duplite-code-to-seq_open_private fs/nfs/client.c
--- a/fs/nfs/client.c~seqfile-merge-duplite-code-to-seq_open_private
+++ a/fs/nfs/client.c
@@ -1208,17 +1208,7 @@ static const struct file_operations nfs_
  */
 static int nfs_server_list_open(struct inode *inode, struct file *file)
 {
-	struct seq_file *m;
-	int ret;
-
-	ret = seq_open(file, &nfs_server_list_ops);
-	if (ret < 0)
-		return ret;
-
-	m = file->private_data;
-	m->private = PDE(inode)->data;
-
-	return 0;
+	return seq_open_private(file, &nfs_server_list_ops, PDE(inode)->data);
 }
 
 /*
@@ -1278,17 +1268,7 @@ static int nfs_server_list_show(struct s
  */
 static int nfs_volume_list_open(struct inode *inode, struct file *file)
 {
-	struct seq_file *m;
-	int ret;
-
-	ret = seq_open(file, &nfs_volume_list_ops);
-	if (ret < 0)
-		return ret;
-
-	m = file->private_data;
-	m->private = PDE(inode)->data;
-
-	return 0;
+	return seq_open_private(file, &nfs_volume_list_ops, PDE(inode)->data);
 }
 
 /*
diff -puN fs/seq_file.c~seqfile-merge-duplite-code-to-seq_open_private fs/seq_file.c
--- a/fs/seq_file.c~seqfile-merge-duplite-code-to-seq_open_private
+++ a/fs/seq_file.c
@@ -53,6 +53,16 @@ int seq_open(struct file *file, const st
 }
 EXPORT_SYMBOL(seq_open);
 
+int seq_open_private(struct file *file, struct seq_operations *op, void *data)
+{
+	int ret = seq_open(file, op);
+
+	if (!ret)
+		((struct seq_file *)file->private_data)->private = data;
+
+	return ret;
+}
+EXPORT_SYMBOL(seq_open_private);
 /**
  *	seq_read -	->read() method for sequential files.
  *	@file: the file to read from
diff -puN include/linux/seq_file.h~seqfile-merge-duplite-code-to-seq_open_private include/linux/seq_file.h
--- a/include/linux/seq_file.h~seqfile-merge-duplite-code-to-seq_open_private
+++ a/include/linux/seq_file.h
@@ -32,6 +32,7 @@ struct seq_operations {
 };
 
 int seq_open(struct file *, const struct seq_operations *);
+int seq_open_private(struct file *, struct seq_operations *, void *);
 ssize_t seq_read(struct file *, char __user *, size_t, loff_t *);
 loff_t seq_lseek(struct file *, loff_t, int);
 int seq_release(struct inode *, struct file *);
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

readahead-compacting-file_ra_state.patch
readahead-mmap-read-around-simplification.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
radixtree-introduce-radix_tree_next_hole.patch
readahead-basic-support-of-interleaved-reads.patch
readahead-remove-the-local-copy-of-ra-in-do_generic_mapping_read.patch
readahead-remove-several-readahead-macros.patch
readahead-remove-the-limit-max_sectors_kb-imposed-on-max_readahead_kb.patch
filemap-trivial-code-cleanups.patch
filemap-convert-some-unsigned-long-to-pgoff_t.patch
make-swappiness-safer-to-use.patch
maps-pssproportional-set-size-accounting-in-smaps.patch
convert-ill-defined-log2-to-ilog2.patch
seqfile-merge-duplite-code-to-seq_open_private.patch
avoid-negative-and-full-width-shifts-in-radix-treec.patch
writeback-fix-time-ordering-of-the-per-superblock-inode-lists-8.patch
writeback-fix-ntfs-with-sb_has_dirty_inodes.patch
writeback-remove-pages_skipped-accounting-in-__block_write_full_page.patch
writeback-remove-pages_skipped-accounting-in-__block_write_full_page-fix.patch
writeback-introduce-writeback_controlmore_io-to-indicate-more-io.patch
writeback-remove-unnecessary-wait-in-throttle_vm_writeout.patch
