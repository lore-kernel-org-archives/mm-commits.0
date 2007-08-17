From: akpm@linux-foundation.org
Subject: + seqfile-merge-duplite-code-to-seq_open_private.patch added to -mm tree
Date: Fri, 17 Aug 2007 11:25:15 -0700
Message-ID: <200708171825.l7HIPFAN023390@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59401 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750805AbXHQSZo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Aug 2007 14:25:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wfg@mail.ustc.edu.cn, viro@zeniv.linux.org.uk


The patch titled
     seqfile: merge duplicate code to seq_open_private()
has been added to the -mm tree.  Its filename is
     seqfile-merge-duplite-code-to-seq_open_private.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1188,17 +1188,7 @@ static const struct file_operations nfs_
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
@@ -1258,17 +1248,7 @@ static int nfs_server_list_show(struct s
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

fix-null-pointer-dereference-in-__vm_enough_memory.patch
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
convert-ill-defined-log2-to-ilog2.patch
seqfile-merge-duplite-code-to-seq_open_private.patch
