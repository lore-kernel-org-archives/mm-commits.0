From: akpm@linux-foundation.org
Subject: [merged] nilfs2-fix-gcc-unused-but-set-variable-warnings.patch
 removed from -mm tree
Date: Mon, 09 Nov 2015 12:13:20 -0800
Message-ID: <5640fe60.hCVuAetmWUorg6Hw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57641 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbbKIUNU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 15:13:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: fix gcc unused-but-set-variable warnings
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-gcc-unused-but-set-variable-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: fix gcc unused-but-set-variable warnings

Fix the following build warnings:

 $ make W=1
 [...]
   CC [M]  fs/nilfs2/btree.o
 fs/nilfs2/btree.c: In function 'nilfs_btree_split':
 fs/nilfs2/btree.c:923:8: warning: variable 'newptr' set but not used [-Wunused-but-set-variable]
   __u64 newptr;
         ^
 fs/nilfs2/btree.c:922:8: warning: variable 'newkey' set but not used [-Wunused-but-set-variable]
   __u64 newkey;
         ^
   CC [M]  fs/nilfs2/dat.o
 fs/nilfs2/dat.c: In function 'nilfs_dat_prepare_end':
 fs/nilfs2/dat.c:158:8: warning: variable 'start' set but not used [-Wunused-but-set-variable]
   __u64 start;
         ^
   CC [M]  fs/nilfs2/segment.o
 fs/nilfs2/segment.c: In function 'nilfs_segctor_do_immediate_flush':
 fs/nilfs2/segment.c:2433:6: warning: variable 'err' set but not used [-Wunused-but-set-variable]
   int err;
       ^
   CC [M]  fs/nilfs2/sufile.o
 fs/nilfs2/sufile.c: In function 'nilfs_sufile_alloc':
 fs/nilfs2/sufile.c:320:27: warning: variable 'ncleansegs' set but not used [-Wunused-but-set-variable]
   unsigned long nsegments, ncleansegs, nsus, cnt;
                            ^
   CC [M]  fs/nilfs2/alloc.o
 fs/nilfs2/alloc.c: In function 'nilfs_palloc_prepare_alloc_entry':
 fs/nilfs2/alloc.c:478:38: warning: variable 'groups_per_desc_block' set but not used [-Wunused-but-set-variable]
   unsigned long n, entries_per_group, groups_per_desc_block;
                                       ^

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/alloc.c   |    3 +--
 fs/nilfs2/btree.c   |    5 -----
 fs/nilfs2/dat.c     |    2 --
 fs/nilfs2/segment.c |    3 +--
 fs/nilfs2/sufile.c  |    3 +--
 5 files changed, 3 insertions(+), 13 deletions(-)

diff -puN fs/nilfs2/alloc.c~nilfs2-fix-gcc-unused-but-set-variable-warnings fs/nilfs2/alloc.c
--- a/fs/nilfs2/alloc.c~nilfs2-fix-gcc-unused-but-set-variable-warnings
+++ a/fs/nilfs2/alloc.c
@@ -514,7 +514,7 @@ int nilfs_palloc_prepare_alloc_entry(str
 	void *desc_kaddr, *bitmap_kaddr;
 	unsigned long group, maxgroup, ngroups;
 	unsigned long group_offset, maxgroup_offset;
-	unsigned long n, entries_per_group, groups_per_desc_block;
+	unsigned long n, entries_per_group;
 	unsigned long i, j;
 	spinlock_t *lock;
 	int pos, ret;
@@ -523,7 +523,6 @@ int nilfs_palloc_prepare_alloc_entry(str
 	maxgroup = ngroups - 1;
 	group = nilfs_palloc_group(inode, req->pr_entry_nr, &group_offset);
 	entries_per_group = nilfs_palloc_entries_per_group(inode);
-	groups_per_desc_block = nilfs_palloc_groups_per_desc_block(inode);
 
 	for (i = 0; i < ngroups; i += n) {
 		if (group >= ngroups) {
diff -puN fs/nilfs2/btree.c~nilfs2-fix-gcc-unused-but-set-variable-warnings fs/nilfs2/btree.c
--- a/fs/nilfs2/btree.c~nilfs2-fix-gcc-unused-but-set-variable-warnings
+++ a/fs/nilfs2/btree.c
@@ -919,8 +919,6 @@ static void nilfs_btree_split(struct nil
 			      int level, __u64 *keyp, __u64 *ptrp)
 {
 	struct nilfs_btree_node *node, *right;
-	__u64 newkey;
-	__u64 newptr;
 	int nchildren, n, move, ncblk;
 
 	node = nilfs_btree_get_nonroot_node(path, level);
@@ -942,9 +940,6 @@ static void nilfs_btree_split(struct nil
 	if (!buffer_dirty(path[level].bp_sib_bh))
 		mark_buffer_dirty(path[level].bp_sib_bh);
 
-	newkey = nilfs_btree_node_get_key(right, 0);
-	newptr = path[level].bp_newreq.bpr_ptr;
-
 	if (move) {
 		path[level].bp_index -= nilfs_btree_node_get_nchildren(node);
 		nilfs_btree_node_insert(right, path[level].bp_index,
diff -puN fs/nilfs2/dat.c~nilfs2-fix-gcc-unused-but-set-variable-warnings fs/nilfs2/dat.c
--- a/fs/nilfs2/dat.c~nilfs2-fix-gcc-unused-but-set-variable-warnings
+++ a/fs/nilfs2/dat.c
@@ -155,7 +155,6 @@ void nilfs_dat_commit_start(struct inode
 int nilfs_dat_prepare_end(struct inode *dat, struct nilfs_palloc_req *req)
 {
 	struct nilfs_dat_entry *entry;
-	__u64 start;
 	sector_t blocknr;
 	void *kaddr;
 	int ret;
@@ -169,7 +168,6 @@ int nilfs_dat_prepare_end(struct inode *
 	kaddr = kmap_atomic(req->pr_entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
 					     req->pr_entry_bh, kaddr);
-	start = le64_to_cpu(entry->de_start);
 	blocknr = le64_to_cpu(entry->de_blocknr);
 	kunmap_atomic(kaddr);
 
diff -puN fs/nilfs2/segment.c~nilfs2-fix-gcc-unused-but-set-variable-warnings fs/nilfs2/segment.c
--- a/fs/nilfs2/segment.c~nilfs2-fix-gcc-unused-but-set-variable-warnings
+++ a/fs/nilfs2/segment.c
@@ -2492,7 +2492,6 @@ static void nilfs_segctor_thread_constru
 static void nilfs_segctor_do_immediate_flush(struct nilfs_sc_info *sci)
 {
 	int mode = 0;
-	int err;
 
 	spin_lock(&sci->sc_state_lock);
 	mode = (sci->sc_flush_request & FLUSH_DAT_BIT) ?
@@ -2500,7 +2499,7 @@ static void nilfs_segctor_do_immediate_f
 	spin_unlock(&sci->sc_state_lock);
 
 	if (mode) {
-		err = nilfs_segctor_do_construct(sci, mode);
+		nilfs_segctor_do_construct(sci, mode);
 
 		spin_lock(&sci->sc_state_lock);
 		sci->sc_flush_request &= (mode == SC_FLUSH_FILE) ?
diff -puN fs/nilfs2/sufile.c~nilfs2-fix-gcc-unused-but-set-variable-warnings fs/nilfs2/sufile.c
--- a/fs/nilfs2/sufile.c~nilfs2-fix-gcc-unused-but-set-variable-warnings
+++ a/fs/nilfs2/sufile.c
@@ -319,7 +319,7 @@ int nilfs_sufile_alloc(struct inode *suf
 	size_t susz = NILFS_MDT(sufile)->mi_entry_size;
 	__u64 segnum, maxsegnum, last_alloc;
 	void *kaddr;
-	unsigned long nsegments, ncleansegs, nsus, cnt;
+	unsigned long nsegments, nsus, cnt;
 	int ret, j;
 
 	down_write(&NILFS_MDT(sufile)->mi_sem);
@@ -329,7 +329,6 @@ int nilfs_sufile_alloc(struct inode *suf
 		goto out_sem;
 	kaddr = kmap_atomic(header_bh->b_page);
 	header = kaddr + bh_offset(header_bh);
-	ncleansegs = le64_to_cpu(header->sh_ncleansegs);
 	last_alloc = le64_to_cpu(header->sh_last_alloc);
 	kunmap_atomic(kaddr);
 
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are


