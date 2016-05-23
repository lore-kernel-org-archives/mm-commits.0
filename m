From: akpm@linux-foundation.org
Subject: [patch 23/84] nilfs2: add missing line spacing
Date: Mon, 23 May 2016 16:23:25 -0700
Message-ID: <574390ed.qE+JBa7zZI4uNxWT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42159 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbcEWXX1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:23:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, konishi.ryusuke@lab.ntt.co.jp

From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: add missing line spacing

Clean up checkpatch.pl warnings "WARNING: Missing a blank line after
declarations" from nilfs2.

Link: http://lkml.kernel.org/r/1461935747-10380-11-git-send-email-konishi.ryusuke@lab.ntt.co.jp
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/cpfile.c    |    2 ++
 fs/nilfs2/dir.c       |    2 ++
 fs/nilfs2/ifile.h     |    1 +
 fs/nilfs2/inode.c     |    1 +
 fs/nilfs2/namei.c     |    1 +
 fs/nilfs2/recovery.c  |    1 +
 fs/nilfs2/segment.c   |    1 +
 fs/nilfs2/sufile.c    |    2 ++
 fs/nilfs2/super.c     |    1 +
 fs/nilfs2/the_nilfs.h |    2 ++
 10 files changed, 14 insertions(+)

diff -puN fs/nilfs2/cpfile.c~nilfs2-add-missing-line-spacing fs/nilfs2/cpfile.c
--- a/fs/nilfs2/cpfile.c~nilfs2-add-missing-line-spacing
+++ a/fs/nilfs2/cpfile.c
@@ -37,6 +37,7 @@ static unsigned long
 nilfs_cpfile_get_blkoff(const struct inode *cpfile, __u64 cno)
 {
 	__u64 tcno = cno + NILFS_MDT(cpfile)->mi_first_entry_offset - 1;
+
 	do_div(tcno, nilfs_cpfile_checkpoints_per_block(cpfile));
 	return (unsigned long)tcno;
 }
@@ -46,6 +47,7 @@ static unsigned long
 nilfs_cpfile_get_offset(const struct inode *cpfile, __u64 cno)
 {
 	__u64 tcno = cno + NILFS_MDT(cpfile)->mi_first_entry_offset - 1;
+
 	return do_div(tcno, nilfs_cpfile_checkpoints_per_block(cpfile));
 }
 
diff -puN fs/nilfs2/dir.c~nilfs2-add-missing-line-spacing fs/nilfs2/dir.c
--- a/fs/nilfs2/dir.c~nilfs2-add-missing-line-spacing
+++ a/fs/nilfs2/dir.c
@@ -74,6 +74,7 @@ static unsigned nilfs_last_byte(struct i
 static int nilfs_prepare_chunk(struct page *page, unsigned from, unsigned to)
 {
 	loff_t pos = page_offset(page) + from;
+
 	return __block_write_begin(page, pos, to - from, nilfs_get_block);
 }
 
@@ -336,6 +337,7 @@ nilfs_find_entry(struct inode *dir, cons
 	n = start;
 	do {
 		char *kaddr;
+
 		page = nilfs_get_page(dir, n);
 		if (!IS_ERR(page)) {
 			kaddr = page_address(page);
diff -puN fs/nilfs2/ifile.h~nilfs2-add-missing-line-spacing fs/nilfs2/ifile.h
--- a/fs/nilfs2/ifile.h~nilfs2-add-missing-line-spacing
+++ a/fs/nilfs2/ifile.h
@@ -32,6 +32,7 @@ static inline struct nilfs_inode *
 nilfs_ifile_map_inode(struct inode *ifile, ino_t ino, struct buffer_head *ibh)
 {
 	void *kaddr = kmap(ibh->b_page);
+
 	return nilfs_palloc_block_get_entry(ifile, ino, ibh, kaddr);
 }
 
diff -puN fs/nilfs2/inode.c~nilfs2-add-missing-line-spacing fs/nilfs2/inode.c
--- a/fs/nilfs2/inode.c~nilfs2-add-missing-line-spacing
+++ a/fs/nilfs2/inode.c
@@ -851,6 +851,7 @@ out_err:
 int nilfs_permission(struct inode *inode, int mask)
 {
 	struct nilfs_root *root = NILFS_I(inode)->i_root;
+
 	if ((mask & MAY_WRITE) && root &&
 	    root->cno != NILFS_CPTREE_CURRENT_CNO)
 		return -EROFS; /* snapshot is not writable */
diff -puN fs/nilfs2/namei.c~nilfs2-add-missing-line-spacing fs/nilfs2/namei.c
--- a/fs/nilfs2/namei.c~nilfs2-add-missing-line-spacing
+++ a/fs/nilfs2/namei.c
@@ -44,6 +44,7 @@
 static inline int nilfs_add_nondir(struct dentry *dentry, struct inode *inode)
 {
 	int err = nilfs_add_link(dentry, inode);
+
 	if (!err) {
 		d_instantiate(dentry, inode);
 		unlock_new_inode(inode);
diff -puN fs/nilfs2/recovery.c~nilfs2-add-missing-line-spacing fs/nilfs2/recovery.c
--- a/fs/nilfs2/recovery.c~nilfs2-add-missing-line-spacing
+++ a/fs/nilfs2/recovery.c
@@ -522,6 +522,7 @@ static int nilfs_recover_dsync_blocks(st
 					0, &page, nilfs_get_block);
 		if (unlikely(err)) {
 			loff_t isize = inode->i_size;
+
 			if (pos + blocksize > isize)
 				nilfs_write_failed(inode->i_mapping,
 							pos + blocksize);
diff -puN fs/nilfs2/segment.c~nilfs2-add-missing-line-spacing fs/nilfs2/segment.c
--- a/fs/nilfs2/segment.c~nilfs2-add-missing-line-spacing
+++ a/fs/nilfs2/segment.c
@@ -2391,6 +2391,7 @@ static int nilfs_segctor_construct(struc
 static void nilfs_construction_timeout(unsigned long data)
 {
 	struct task_struct *p = (struct task_struct *)data;
+
 	wake_up_process(p);
 }
 
diff -puN fs/nilfs2/sufile.c~nilfs2-add-missing-line-spacing fs/nilfs2/sufile.c
--- a/fs/nilfs2/sufile.c~nilfs2-add-missing-line-spacing
+++ a/fs/nilfs2/sufile.c
@@ -57,6 +57,7 @@ static unsigned long
 nilfs_sufile_get_blkoff(const struct inode *sufile, __u64 segnum)
 {
 	__u64 t = segnum + NILFS_MDT(sufile)->mi_first_entry_offset;
+
 	do_div(t, nilfs_sufile_segment_usages_per_block(sufile));
 	return (unsigned long)t;
 }
@@ -65,6 +66,7 @@ static unsigned long
 nilfs_sufile_get_offset(const struct inode *sufile, __u64 segnum)
 {
 	__u64 t = segnum + NILFS_MDT(sufile)->mi_first_entry_offset;
+
 	return do_div(t, nilfs_sufile_segment_usages_per_block(sufile));
 }
 
diff -puN fs/nilfs2/super.c~nilfs2-add-missing-line-spacing fs/nilfs2/super.c
--- a/fs/nilfs2/super.c~nilfs2-add-missing-line-spacing
+++ a/fs/nilfs2/super.c
@@ -743,6 +743,7 @@ static int parse_options(char *options,
 
 	while ((p = strsep(&options, ",")) != NULL) {
 		int token;
+
 		if (!*p)
 			continue;
 
diff -puN fs/nilfs2/the_nilfs.h~nilfs2-add-missing-line-spacing fs/nilfs2/the_nilfs.h
--- a/fs/nilfs2/the_nilfs.h~nilfs2-add-missing-line-spacing
+++ a/fs/nilfs2/the_nilfs.h
@@ -269,6 +269,7 @@ struct nilfs_root {
 static inline int nilfs_sb_need_update(struct the_nilfs *nilfs)
 {
 	u64 t = get_seconds();
+
 	return t < nilfs->ns_sbwtime ||
 		t > nilfs->ns_sbwtime + nilfs->ns_sb_update_freq;
 }
@@ -276,6 +277,7 @@ static inline int nilfs_sb_need_update(s
 static inline int nilfs_sb_will_flip(struct the_nilfs *nilfs)
 {
 	int flip_bits = nilfs->ns_sbwcount & 0x0FL;
+
 	return (flip_bits != 0x08 && flip_bits != 0x0F);
 }
 
_
