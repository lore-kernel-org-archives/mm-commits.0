From: akpm@linux-foundation.org
Subject: + mm-fs-store-shadow-entries-in-page-cache.patch added to -mm
 tree
Date: Tue, 04 Feb 2014 15:14:51 -0800
Message-ID: <52f1746b.j/OEbeXFKE5MwFb8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58440 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933800AbaBDXOw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Feb 2014 18:14:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, vbabka@suse.cz, tj@kernel.org, semenzato@google.com, rmallon@gmail.com, riel@redhat.com, peterz@infradead.org, ozgun@citusdata.com, minchan@kernel.org, mgorman@suse.de, metin@citusdata.com, kosaki.motohiro@jp.fujitsu.com, klamm@yandex-team.ru, jack@suse.cz, hughd@google.com, hch@infradead.org, gthelen@google.com, david@fromorbit.com, bob.liu@oracle.com, aarcange@redhat.com, hannes@cmpxchg.org

Subject: + mm-fs-store-shadow-entries-in-page-cache.patch added to -mm tree
To: hannes@cmpxchg.org,aarcange@redhat.com,bob.liu@oracle.com,david@fromorbit.com,gthelen@google.com,hch@infradead.org,hughd@google.com,jack@suse.cz,klamm@yandex-team.ru,kosaki.motohiro@jp.fujitsu.com,metin@citusdata.com,mgorman@suse.de,minchan@kernel.org,ozgun@citusdata.com,peterz@infradead.org,riel@redhat.com,rmallon@gmail.com,semenzato@google.com,tj@kernel.org,vbabka@suse.cz,walken@google.com
From: akpm@linux-foundation.org
Date: Tue, 04 Feb 2014 15:14:51 -0800


The patch titled
     Subject: mm + fs: store shadow entries in page cache
has been added to the -mm tree.  Its filename is
     mm-fs-store-shadow-entries-in-page-cache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fs-store-shadow-entries-in-page-cache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fs-store-shadow-entries-in-page-cache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm + fs: store shadow entries in page cache

Reclaim will be leaving shadow entries in the page cache radix tree upon
evicting the real page.  As those pages are found from the LRU, an iput()
can lead to the inode being freed concurrently.  At this point, reclaim
must no longer install shadow pages because the inode freeing code needs
to ensure the page tree is really empty.

Add an address_space flag, AS_EXITING, that the inode freeing code sets
under the tree lock before doing the final truncate.  Reclaim will check
for this flag before installing shadow pages.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Bob Liu <bob.liu@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Luigi Semenzato <semenzato@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Metin Doslu <metin@citusdata.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Ozgun Erdogan <ozgun@citusdata.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin <klamm@yandex-team.ru>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/porting               |    6 -
 drivers/staging/lustre/lustre/llite/llite_lib.c |    2 
 fs/9p/vfs_inode.c                               |    2 
 fs/affs/inode.c                                 |    2 
 fs/afs/inode.c                                  |    2 
 fs/bfs/inode.c                                  |    2 
 fs/block_dev.c                                  |    4 -
 fs/btrfs/inode.c                                |    2 
 fs/cifs/cifsfs.c                                |    2 
 fs/coda/inode.c                                 |    2 
 fs/ecryptfs/super.c                             |    2 
 fs/exofs/inode.c                                |    2 
 fs/ext2/inode.c                                 |    2 
 fs/ext3/inode.c                                 |    2 
 fs/ext4/inode.c                                 |    4 -
 fs/f2fs/inode.c                                 |    2 
 fs/fat/inode.c                                  |    2 
 fs/freevxfs/vxfs_inode.c                        |    2 
 fs/fuse/inode.c                                 |    2 
 fs/gfs2/super.c                                 |    2 
 fs/hfs/inode.c                                  |    2 
 fs/hfsplus/super.c                              |    2 
 fs/hostfs/hostfs_kern.c                         |    2 
 fs/hpfs/inode.c                                 |    2 
 fs/inode.c                                      |    4 -
 fs/jffs2/fs.c                                   |    2 
 fs/jfs/inode.c                                  |    4 -
 fs/kernfs/inode.c                               |    2 
 fs/logfs/readwrite.c                            |    2 
 fs/minix/inode.c                                |    2 
 fs/ncpfs/inode.c                                |    2 
 fs/nfs/inode.c                                  |    2 
 fs/nfs/nfs4super.c                              |    2 
 fs/nilfs2/inode.c                               |    6 -
 fs/ntfs/inode.c                                 |    2 
 fs/ocfs2/inode.c                                |    4 -
 fs/omfs/inode.c                                 |    2 
 fs/proc/inode.c                                 |    2 
 fs/reiserfs/inode.c                             |    2 
 fs/sysv/inode.c                                 |    2 
 fs/ubifs/super.c                                |    2 
 fs/udf/inode.c                                  |    4 -
 fs/ufs/inode.c                                  |    2 
 fs/xfs/xfs_super.c                              |    2 
 include/linux/fs.h                              |    1 
 include/linux/mm.h                              |    1 
 include/linux/pagemap.h                         |   13 +++
 mm/filemap.c                                    |   33 +++++++-
 mm/truncate.c                                   |   54 +++++++++++++-
 mm/vmscan.c                                     |    2 
 50 files changed, 147 insertions(+), 65 deletions(-)

diff -puN Documentation/filesystems/porting~mm-fs-store-shadow-entries-in-page-cache Documentation/filesystems/porting
--- a/Documentation/filesystems/porting~mm-fs-store-shadow-entries-in-page-cache
+++ a/Documentation/filesystems/porting
@@ -295,9 +295,9 @@ in the beginning of ->setattr unconditio
 	->clear_inode() and ->delete_inode() are gone; ->evict_inode() should
 be used instead.  It gets called whenever the inode is evicted, whether it has
 remaining links or not.  Caller does *not* evict the pagecache or inode-associated
-metadata buffers; getting rid of those is responsibility of method, as it had
-been for ->delete_inode(). Caller makes sure async writeback cannot be running
-for the inode while (or after) ->evict_inode() is called.
+metadata buffers; the method has to use truncate_inode_pages_final() to get rid
+of those. Caller makes sure async writeback cannot be running for the inode while
+(or after) ->evict_inode() is called.
 
 	->drop_inode() returns int now; it's called on final iput() with
 inode->i_lock held and it returns true if filesystems wants the inode to be
diff -puN drivers/staging/lustre/lustre/llite/llite_lib.c~mm-fs-store-shadow-entries-in-page-cache drivers/staging/lustre/lustre/llite/llite_lib.c
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -1877,7 +1877,7 @@ void ll_delete_inode(struct inode *inode
 		cl_sync_file_range(inode, 0, OBD_OBJECT_EOF,
 				   CL_FSYNC_DISCARD, 1);
 
-	truncate_inode_pages(&inode->i_data, 0);
+	truncate_inode_pages_final(&inode->i_data);
 
 	/* Workaround for LU-118 */
 	if (inode->i_data.nrpages) {
diff -puN fs/9p/vfs_inode.c~mm-fs-store-shadow-entries-in-page-cache fs/9p/vfs_inode.c
--- a/fs/9p/vfs_inode.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/fs/9p/vfs_inode.c
@@ -451,7 +451,7 @@ void v9fs_evict_inode(struct inode *inod
 {
 	struct v9fs_inode *v9inode = V9FS_I(inode);
 
-	truncate_inode_pages(inode->i_mapping, 0);
+	truncate_inode_pages_final(inode->i_mapping);
 	clear_inode(inode);
 	filemap_fdatawrite(inode->i_mapping);
 
diff -puN fs/affs/inode.c~mm-fs-store-shadow-entries-in-page-cache fs/affs/inode.c
--- a/fs/affs/inode.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/fs/affs/inode.c
@@ -259,7 +259,7 @@ affs_evict_inode(struct inode *inode)
 {
 	unsigned long cache_page;
 	pr_debug("AFFS: evict_inode(ino=%lu, nlink=%u)\n", inode->i_ino, inode->i_nlink);
-	truncate_inode_pages(&inode->i_data, 0);
+	truncate_inode_pages_final(&inode->i_data);
 
 	if (!inode->i_nlink) {
 		inode->i_size = 0;
diff -puN fs/afs/inode.c~mm-fs-store-shadow-entries-in-page-cache fs/afs/inode.c
--- a/fs/afs/inode.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/fs/afs/inode.c
@@ -422,7 +422,7 @@ void afs_evict_inode(struct inode *inode
 
 	ASSERTCMP(inode->i_ino, ==, vnode->fid.vnode);
 
-	truncate_inode_pages(&inode->i_data, 0);
+	truncate_inode_pages_final(&inode->i_data);
 	clear_inode(inode);
 
 	afs_give_up_callback(vnode);
diff -puN fs/bfs/inode.c~mm-fs-store-shadow-entries-in-page-cache fs/bfs/inode.c
--- a/fs/bfs/inode.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/fs/bfs/inode.c
@@ -172,7 +172,7 @@ static void bfs_evict_inode(struct inode
 
 	dprintf("ino=%08lx\n", ino);
 
-	truncate_inode_pages(&inode->i_data, 0);
+	truncate_inode_pages_final(&inode->i_data);
 	invalidate_inode_buffers(inode);
 	clear_inode(inode);
 
diff -puN fs/block_dev.c~mm-fs-store-shadow-entries-in-page-cache fs/block_dev.c
--- a/fs/block_dev.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/fs/block_dev.c
@@ -83,7 +83,7 @@ void kill_bdev(struct block_device *bdev
 {
 	struct address_space *mapping = bdev->bd_inode->i_mapping;
 
-	if (mapping->nrpages == 0)
+	if (mapping->nrpages == 0 && mapping->nrshadows == 0)
 		return;
 
 	invalidate_bh_lrus();
@@ -419,7 +419,7 @@ static void bdev_evict_inode(struct inod
 {
 	struct block_device *bdev = &BDEV_I(inode)->bdev;
 	struct list_head *p;
-	truncate_inode_pages(&inode->i_data, 0);
+	truncate_inode_pages_final(&inode->i_data);
 	invalidate_inode_buffers(inode); /* is it needed here? */
 	clear_inode(inode);
 	spin_lock(&bdev_lock);
diff -puN fs/btrfs/inode.c~mm-fs-store-shadow-entries-in-page-cache fs/btrfs/inode.c
--- a/fs/btrfs/inode.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/fs/btrfs/inode.c
@@ -4593,7 +4593,7 @@ static void evict_inode_truncate_pages(s
 	struct rb_node *node;
 
 	ASSERT(inode->i_state & I_FREEING);
-	truncate_inode_pages(&inode->i_data, 0);
+	truncate_inode_pages_final(&inode->i_data);
 
 	write_lock(&map_tree->lock);
 	while (!RB_EMPTY_ROOT(&map_tree->map)) {
diff -puN fs/cifs/cifsfs.c~mm-fs-store-shadow-entries-in-page-cache fs/cifs/cifsfs.c
--- a/fs/cifs/cifsfs.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/fs/cifs/cifsfs.c
@@ -286,7 +286,7 @@ cifs_destroy_inode(struct inode *inode)
 static void
 cifs_evict_inode(struct inode *inode)
 {
-	truncate_inode_pages(&inode->i_data, 0);
+	truncate_inode_pages_final(&inode->i_data);
 	clear_inode(inode);
 	cifs_fscache_release_inode_cookie(inode);
 }
diff -puN fs/coda/inode.c~mm-fs-store-shadow-entries-in-page-cache fs/coda/inode.c
--- a/fs/coda/inode.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/fs/coda/inode.c
@@ -250,7 +250,7 @@ static void coda_put_super(struct super_
 
 static void coda_evict_inode(struct inode *inode)
 {
-	truncate_inode_pages(&inode->i_data, 0);
+	truncate_inode_pages_final(&inode->i_data);
 	clear_inode(inode);
 	coda_cache_clear_inode(inode);
 }
diff -puN fs/ecryptfs/super.c~mm-fs-store-shadow-entries-in-page-cache fs/ecryptfs/super.c
--- a/fs/ecryptfs/super.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/fs/ecryptfs/super.c
@@ -132,7 +132,7 @@ static int ecryptfs_statfs(struct dentry
  */
 static void ecryptfs_evict_inode(struct inode *inode)
 {
-	truncate_inode_pages(&inode->i_data, 0);
+	truncate_inode_pages_final(&inode->i_data);
 	clear_inode(inode);
 	iput(ecryptfs_inode_to_lower(inode));
 }
diff -puN fs/exofs/inode.c~mm-fs-store-shadow-entries-in-page-cache fs/exofs/inode.c
--- a/fs/exofs/inode.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/fs/exofs/inode.c
@@ -1486,7 +1486,7 @@ void exofs_evict_inode(struct inode *ino
 	struct ore_io_state *ios;
 	int ret;
 
-	truncate_inode_pages(&inode->i_data, 0);
+	truncate_inode_pages_final(&inode->i_data);
 
 	/* TODO: should do better here */
 	if (inode->i_nlink || is_bad_inode(inode))
diff -puN fs/ext2/inode.c~mm-fs-store-shadow-entries-in-page-cache fs/ext2/inode.c
--- a/fs/ext2/inode.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/fs/ext2/inode.c
@@ -78,7 +78,7 @@ void ext2_evict_inode(struct inode * ino
 		dquot_drop(inode);
 	}
 
-	truncate_inode_pages(&inode->i_data, 0);
+	truncate_inode_pages_final(&inode->i_data);
 
 	if (want_delete) {
 		sb_start_intwrite(inode->i_sb);
diff -puN fs/ext3/inode.c~mm-fs-store-shadow-entries-in-page-cache fs/ext3/inode.c
--- a/fs/ext3/inode.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/fs/ext3/inode.c
@@ -228,7 +228,7 @@ void ext3_evict_inode (struct inode *ino
 		log_wait_commit(journal, commit_tid);
 		filemap_write_and_wait(&inode->i_data);
 	}
-	truncate_inode_pages(&inode->i_data, 0);
+	truncate_inode_pages_final(&inode->i_data);
 
 	ext3_discard_reservation(inode);
 	rsv = ei->i_block_alloc_info;
diff -puN fs/ext4/inode.c~mm-fs-store-shadow-entries-in-page-cache fs/ext4/inode.c
--- a/fs/ext4/inode.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/fs/ext4/inode.c
@@ -214,7 +214,7 @@ void ext4_evict_inode(struct inode *inod
 			jbd2_complete_transaction(journal, commit_tid);
 			filemap_write_and_wait(&inode->i_data);
 		}
-		truncate_inode_pages(&inode->i_data, 0);
+		truncate_inode_pages_final(&inode->i_data);
 
 		WARN_ON(atomic_read(&EXT4_I(inode)->i_ioend_count));
 		goto no_delete;
@@ -225,7 +225,7 @@ void ext4_evict_inode(struct inode *inod
 
 	if (ext4_should_order_data(inode))
 		ext4_begin_ordered_truncate(inode, 0);
-	truncate_inode_pages(&inode->i_data, 0);
+	truncate_inode_pages_final(&inode->i_data);
 
 	WARN_ON(atomic_read(&EXT4_I(inode)->i_ioend_count));
 	if (is_bad_inode(inode))
diff -puN fs/f2fs/inode.c~mm-fs-store-shadow-entries-in-page-cache fs/f2fs/inode.c
--- a/fs/f2fs/inode.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/fs/f2fs/inode.c
@@ -260,7 +260,7 @@ void f2fs_evict_inode(struct inode *inod
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 
 	trace_f2fs_evict_inode(inode);
-	truncate_inode_pages(&inode->i_data, 0);
+	truncate_inode_pages_final(&inode->i_data);
 
 	if (inode->i_ino == F2FS_NODE_INO(sbi) ||
 			inode->i_ino == F2FS_META_INO(sbi))
diff -puN fs/fat/inode.c~mm-fs-store-shadow-entries-in-page-cache fs/fat/inode.c
--- a/fs/fat/inode.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/fs/fat/inode.c
@@ -490,7 +490,7 @@ EXPORT_SYMBOL_GPL(fat_build_inode);
 
 static void fat_evict_inode(struct inode *inode)
 {
-	truncate_inode_pages(&inode->i_data, 0);
+	truncate_inode_pages_final(&inode->i_data);
 	if (!inode->i_nlink) {
 		inode->i_size = 0;
 		fat_truncate_blocks(inode, 0);
diff -puN fs/freevxfs/vxfs_inode.c~mm-fs-store-shadow-entries-in-page-cache fs/freevxfs/vxfs_inode.c
--- a/fs/freevxfs/vxfs_inode.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/fs/freevxfs/vxfs_inode.c
@@ -354,7 +354,7 @@ static void vxfs_i_callback(struct rcu_h
 void
 vxfs_evict_inode(struct inode *ip)
 {
-	truncate_inode_pages(&ip->i_data, 0);
+	truncate_inode_pages_final(&ip->i_data);
 	clear_inode(ip);
 	call_rcu(&ip->i_rcu, vxfs_i_callback);
 }
diff -puN fs/fuse/inode.c~mm-fs-store-shadow-entries-in-page-cache fs/fuse/inode.c
--- a/fs/fuse/inode.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/fs/fuse/inode.c
@@ -123,7 +123,7 @@ static void fuse_destroy_inode(struct in
 
 static void fuse_evict_inode(struct inode *inode)
 {
-	truncate_inode_pages(&inode->i_data, 0);
+	truncate_inode_pages_final(&inode->i_data);
 	clear_inode(inode);
 	if (inode->i_sb->s_flags & MS_ACTIVE) {
 		struct fuse_conn *fc = get_fuse_conn(inode);
diff -puN fs/gfs2/super.c~mm-fs-store-shadow-entries-in-page-cache fs/gfs2/super.c
--- a/fs/gfs2/super.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/fs/gfs2/super.c
@@ -1558,7 +1558,7 @@ out_unlock:
 		fs_warn(sdp, "gfs2_evict_inode: %d\n", error);
 out:
 	/* Case 3 starts here */
-	truncate_inode_pages(&inode->i_data, 0);
+	truncate_inode_pages_final(&inode->i_data);
 	gfs2_rs_delete(ip, NULL);
 	gfs2_ordered_del_inode(ip);
 	clear_inode(inode);
diff -puN fs/hfs/inode.c~mm-fs-store-shadow-entries-in-page-cache fs/hfs/inode.c
--- a/fs/hfs/inode.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/fs/hfs/inode.c
@@ -547,7 +547,7 @@ out:
 
 void hfs_evict_inode(struct inode *inode)
 {
-	truncate_inode_pages(&inode->i_data, 0);
+	truncate_inode_pages_final(&inode->i_data);
 	clear_inode(inode);
 	if (HFS_IS_RSRC(inode) && HFS_I(inode)->rsrc_inode) {
 		HFS_I(HFS_I(inode)->rsrc_inode)->rsrc_inode = NULL;
diff -puN fs/hfsplus/super.c~mm-fs-store-shadow-entries-in-page-cache fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/fs/hfsplus/super.c
@@ -161,7 +161,7 @@ static int hfsplus_write_inode(struct in
 static void hfsplus_evict_inode(struct inode *inode)
 {
 	hfs_dbg(INODE, "hfsplus_evict_inode: %lu\n", inode->i_ino);
-	truncate_inode_pages(&inode->i_data, 0);
+	truncate_inode_pages_final(&inode->i_data);
 	clear_inode(inode);
 	if (HFSPLUS_IS_RSRC(inode)) {
 		HFSPLUS_I(HFSPLUS_I(inode)->rsrc_inode)->rsrc_inode = NULL;
diff -puN fs/hostfs/hostfs_kern.c~mm-fs-store-shadow-entries-in-page-cache fs/hostfs/hostfs_kern.c
--- a/fs/hostfs/hostfs_kern.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/fs/hostfs/hostfs_kern.c
@@ -230,7 +230,7 @@ static struct inode *hostfs_alloc_inode(
 
 static void hostfs_evict_inode(struct inode *inode)
 {
-	truncate_inode_pages(&inode->i_data, 0);
+	truncate_inode_pages_final(&inode->i_data);
 	clear_inode(inode);
 	if (HOSTFS_I(inode)->fd != -1) {
 		close_file(&HOSTFS_I(inode)->fd);
diff -puN fs/hpfs/inode.c~mm-fs-store-shadow-entries-in-page-cache fs/hpfs/inode.c
--- a/fs/hpfs/inode.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/fs/hpfs/inode.c
@@ -304,7 +304,7 @@ void hpfs_write_if_changed(struct inode
 
 void hpfs_evict_inode(struct inode *inode)
 {
-	truncate_inode_pages(&inode->i_data, 0);
+	truncate_inode_pages_final(&inode->i_data);
 	clear_inode(inode);
 	if (!inode->i_nlink) {
 		hpfs_lock(inode->i_sb);
diff -puN fs/inode.c~mm-fs-store-shadow-entries-in-page-cache fs/inode.c
--- a/fs/inode.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/fs/inode.c
@@ -503,6 +503,7 @@ void clear_inode(struct inode *inode)
 	 */
 	spin_lock_irq(&inode->i_data.tree_lock);
 	BUG_ON(inode->i_data.nrpages);
+	BUG_ON(inode->i_data.nrshadows);
 	spin_unlock_irq(&inode->i_data.tree_lock);
 	BUG_ON(!list_empty(&inode->i_data.private_list));
 	BUG_ON(!(inode->i_state & I_FREEING));
@@ -548,8 +549,7 @@ static void evict(struct inode *inode)
 	if (op->evict_inode) {
 		op->evict_inode(inode);
 	} else {
-		if (inode->i_data.nrpages)
-			truncate_inode_pages(&inode->i_data, 0);
+		truncate_inode_pages_final(&inode->i_data);
 		clear_inode(inode);
 	}
 	if (S_ISBLK(inode->i_mode) && inode->i_bdev)
diff -puN fs/jffs2/fs.c~mm-fs-store-shadow-entries-in-page-cache fs/jffs2/fs.c
--- a/fs/jffs2/fs.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/fs/jffs2/fs.c
@@ -242,7 +242,7 @@ void jffs2_evict_inode (struct inode *in
 
 	jffs2_dbg(1, "%s(): ino #%lu mode %o\n",
 		  __func__, inode->i_ino, inode->i_mode);
-	truncate_inode_pages(&inode->i_data, 0);
+	truncate_inode_pages_final(&inode->i_data);
 	clear_inode(inode);
 	jffs2_do_clear_inode(c, f);
 }
diff -puN fs/jfs/inode.c~mm-fs-store-shadow-entries-in-page-cache fs/jfs/inode.c
--- a/fs/jfs/inode.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/fs/jfs/inode.c
@@ -154,7 +154,7 @@ void jfs_evict_inode(struct inode *inode
 		dquot_initialize(inode);
 
 		if (JFS_IP(inode)->fileset == FILESYSTEM_I) {
-			truncate_inode_pages(&inode->i_data, 0);
+			truncate_inode_pages_final(&inode->i_data);
 
 			if (test_cflag(COMMIT_Freewmap, inode))
 				jfs_free_zero_link(inode);
@@ -168,7 +168,7 @@ void jfs_evict_inode(struct inode *inode
 			dquot_free_inode(inode);
 		}
 	} else {
-		truncate_inode_pages(&inode->i_data, 0);
+		truncate_inode_pages_final(&inode->i_data);
 	}
 	clear_inode(inode);
 	dquot_drop(inode);
diff -puN fs/kernfs/inode.c~mm-fs-store-shadow-entries-in-page-cache fs/kernfs/inode.c
--- a/fs/kernfs/inode.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/fs/kernfs/inode.c
@@ -355,7 +355,7 @@ void kernfs_evict_inode(struct inode *in
 {
 	struct kernfs_node *kn = inode->i_private;
 
-	truncate_inode_pages(&inode->i_data, 0);
+	truncate_inode_pages_final(&inode->i_data);
 	clear_inode(inode);
 	kernfs_put(kn);
 }
diff -puN fs/logfs/readwrite.c~mm-fs-store-shadow-entries-in-page-cache fs/logfs/readwrite.c
--- a/fs/logfs/readwrite.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/fs/logfs/readwrite.c
@@ -2180,7 +2180,7 @@ void logfs_evict_inode(struct inode *ino
 			do_delete_inode(inode);
 		}
 	}
-	truncate_inode_pages(&inode->i_data, 0);
+	truncate_inode_pages_final(&inode->i_data);
 	clear_inode(inode);
 
 	/* Cheaper version of write_inode.  All changes are concealed in
diff -puN fs/minix/inode.c~mm-fs-store-shadow-entries-in-page-cache fs/minix/inode.c
--- a/fs/minix/inode.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/fs/minix/inode.c
@@ -26,7 +26,7 @@ static int minix_remount (struct super_b
 
 static void minix_evict_inode(struct inode *inode)
 {
-	truncate_inode_pages(&inode->i_data, 0);
+	truncate_inode_pages_final(&inode->i_data);
 	if (!inode->i_nlink) {
 		inode->i_size = 0;
 		minix_truncate(inode);
diff -puN fs/ncpfs/inode.c~mm-fs-store-shadow-entries-in-page-cache fs/ncpfs/inode.c
--- a/fs/ncpfs/inode.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/fs/ncpfs/inode.c
@@ -296,7 +296,7 @@ ncp_iget(struct super_block *sb, struct
 static void
 ncp_evict_inode(struct inode *inode)
 {
-	truncate_inode_pages(&inode->i_data, 0);
+	truncate_inode_pages_final(&inode->i_data);
 	clear_inode(inode);
 
 	if (S_ISDIR(inode->i_mode)) {
diff -puN fs/nfs/inode.c~mm-fs-store-shadow-entries-in-page-cache fs/nfs/inode.c
--- a/fs/nfs/inode.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/fs/nfs/inode.c
@@ -128,7 +128,7 @@ EXPORT_SYMBOL_GPL(nfs_clear_inode);
 
 void nfs_evict_inode(struct inode *inode)
 {
-	truncate_inode_pages(&inode->i_data, 0);
+	truncate_inode_pages_final(&inode->i_data);
 	clear_inode(inode);
 	nfs_clear_inode(inode);
 }
diff -puN fs/nfs/nfs4super.c~mm-fs-store-shadow-entries-in-page-cache fs/nfs/nfs4super.c
--- a/fs/nfs/nfs4super.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/fs/nfs/nfs4super.c
@@ -90,7 +90,7 @@ static int nfs4_write_inode(struct inode
  */
 static void nfs4_evict_inode(struct inode *inode)
 {
-	truncate_inode_pages(&inode->i_data, 0);
+	truncate_inode_pages_final(&inode->i_data);
 	clear_inode(inode);
 	pnfs_return_layout(inode);
 	pnfs_destroy_layout(NFS_I(inode));
diff -puN fs/nilfs2/inode.c~mm-fs-store-shadow-entries-in-page-cache fs/nilfs2/inode.c
--- a/fs/nilfs2/inode.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/fs/nilfs2/inode.c
@@ -783,16 +783,14 @@ void nilfs_evict_inode(struct inode *ino
 	int ret;
 
 	if (inode->i_nlink || !ii->i_root || unlikely(is_bad_inode(inode))) {
-		if (inode->i_data.nrpages)
-			truncate_inode_pages(&inode->i_data, 0);
+		truncate_inode_pages_final(&inode->i_data);
 		clear_inode(inode);
 		nilfs_clear_inode(inode);
 		return;
 	}
 	nilfs_transaction_begin(sb, &ti, 0); /* never fails */
 
-	if (inode->i_data.nrpages)
-		truncate_inode_pages(&inode->i_data, 0);
+	truncate_inode_pages_final(&inode->i_data);
 
 	/* TODO: some of the following operations may fail.  */
 	nilfs_truncate_bmap(ii, 0);
diff -puN fs/ntfs/inode.c~mm-fs-store-shadow-entries-in-page-cache fs/ntfs/inode.c
--- a/fs/ntfs/inode.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/fs/ntfs/inode.c
@@ -2259,7 +2259,7 @@ void ntfs_evict_big_inode(struct inode *
 {
 	ntfs_inode *ni = NTFS_I(vi);
 
-	truncate_inode_pages(&vi->i_data, 0);
+	truncate_inode_pages_final(&vi->i_data);
 	clear_inode(vi);
 
 #ifdef NTFS_RW
diff -puN fs/ocfs2/inode.c~mm-fs-store-shadow-entries-in-page-cache fs/ocfs2/inode.c
--- a/fs/ocfs2/inode.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/fs/ocfs2/inode.c
@@ -941,7 +941,7 @@ static void ocfs2_cleanup_delete_inode(s
 		(unsigned long long)OCFS2_I(inode)->ip_blkno, sync_data);
 	if (sync_data)
 		filemap_write_and_wait(inode->i_mapping);
-	truncate_inode_pages(&inode->i_data, 0);
+	truncate_inode_pages_final(&inode->i_data);
 }
 
 static void ocfs2_delete_inode(struct inode *inode)
@@ -1157,7 +1157,7 @@ void ocfs2_evict_inode(struct inode *ino
 	    (OCFS2_I(inode)->ip_flags & OCFS2_INODE_MAYBE_ORPHANED)) {
 		ocfs2_delete_inode(inode);
 	} else {
-		truncate_inode_pages(&inode->i_data, 0);
+		truncate_inode_pages_final(&inode->i_data);
 	}
 	ocfs2_clear_inode(inode);
 }
diff -puN fs/omfs/inode.c~mm-fs-store-shadow-entries-in-page-cache fs/omfs/inode.c
--- a/fs/omfs/inode.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/fs/omfs/inode.c
@@ -183,7 +183,7 @@ int omfs_sync_inode(struct inode *inode)
  */
 static void omfs_evict_inode(struct inode *inode)
 {
-	truncate_inode_pages(&inode->i_data, 0);
+	truncate_inode_pages_final(&inode->i_data);
 	clear_inode(inode);
 
 	if (inode->i_nlink)
diff -puN fs/proc/inode.c~mm-fs-store-shadow-entries-in-page-cache fs/proc/inode.c
--- a/fs/proc/inode.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/fs/proc/inode.c
@@ -35,7 +35,7 @@ static void proc_evict_inode(struct inod
 	const struct proc_ns_operations *ns_ops;
 	void *ns;
 
-	truncate_inode_pages(&inode->i_data, 0);
+	truncate_inode_pages_final(&inode->i_data);
 	clear_inode(inode);
 
 	/* Stop tracking associated processes */
diff -puN fs/reiserfs/inode.c~mm-fs-store-shadow-entries-in-page-cache fs/reiserfs/inode.c
--- a/fs/reiserfs/inode.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/fs/reiserfs/inode.c
@@ -35,7 +35,7 @@ void reiserfs_evict_inode(struct inode *
 	if (!inode->i_nlink && !is_bad_inode(inode))
 		dquot_initialize(inode);
 
-	truncate_inode_pages(&inode->i_data, 0);
+	truncate_inode_pages_final(&inode->i_data);
 	if (inode->i_nlink)
 		goto no_delete;
 
diff -puN fs/sysv/inode.c~mm-fs-store-shadow-entries-in-page-cache fs/sysv/inode.c
--- a/fs/sysv/inode.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/fs/sysv/inode.c
@@ -295,7 +295,7 @@ int sysv_sync_inode(struct inode *inode)
 
 static void sysv_evict_inode(struct inode *inode)
 {
-	truncate_inode_pages(&inode->i_data, 0);
+	truncate_inode_pages_final(&inode->i_data);
 	if (!inode->i_nlink) {
 		inode->i_size = 0;
 		sysv_truncate(inode);
diff -puN fs/ubifs/super.c~mm-fs-store-shadow-entries-in-page-cache fs/ubifs/super.c
--- a/fs/ubifs/super.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/fs/ubifs/super.c
@@ -351,7 +351,7 @@ static void ubifs_evict_inode(struct ino
 	dbg_gen("inode %lu, mode %#x", inode->i_ino, (int)inode->i_mode);
 	ubifs_assert(!atomic_read(&inode->i_count));
 
-	truncate_inode_pages(&inode->i_data, 0);
+	truncate_inode_pages_final(&inode->i_data);
 
 	if (inode->i_nlink)
 		goto done;
diff -puN fs/udf/inode.c~mm-fs-store-shadow-entries-in-page-cache fs/udf/inode.c
--- a/fs/udf/inode.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/fs/udf/inode.c
@@ -146,8 +146,8 @@ void udf_evict_inode(struct inode *inode
 		want_delete = 1;
 		udf_setsize(inode, 0);
 		udf_update_inode(inode, IS_SYNC(inode));
-	} else
-		truncate_inode_pages(&inode->i_data, 0);
+	}
+	truncate_inode_pages_final(&inode->i_data);
 	invalidate_inode_buffers(inode);
 	clear_inode(inode);
 	if (iinfo->i_alloc_type != ICBTAG_FLAG_AD_IN_ICB &&
diff -puN fs/ufs/inode.c~mm-fs-store-shadow-entries-in-page-cache fs/ufs/inode.c
--- a/fs/ufs/inode.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/fs/ufs/inode.c
@@ -885,7 +885,7 @@ void ufs_evict_inode(struct inode * inod
 	if (!inode->i_nlink && !is_bad_inode(inode))
 		want_delete = 1;
 
-	truncate_inode_pages(&inode->i_data, 0);
+	truncate_inode_pages_final(&inode->i_data);
 	if (want_delete) {
 		loff_t old_i_size;
 		/*UFS_I(inode)->i_dtime = CURRENT_TIME;*/
diff -puN fs/xfs/xfs_super.c~mm-fs-store-shadow-entries-in-page-cache fs/xfs/xfs_super.c
--- a/fs/xfs/xfs_super.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/fs/xfs/xfs_super.c
@@ -996,7 +996,7 @@ xfs_fs_evict_inode(
 
 	trace_xfs_evict_inode(ip);
 
-	truncate_inode_pages(&inode->i_data, 0);
+	truncate_inode_pages_final(&inode->i_data);
 	clear_inode(inode);
 	XFS_STATS_INC(vn_rele);
 	XFS_STATS_INC(vn_remove);
diff -puN include/linux/fs.h~mm-fs-store-shadow-entries-in-page-cache include/linux/fs.h
--- a/include/linux/fs.h~mm-fs-store-shadow-entries-in-page-cache
+++ a/include/linux/fs.h
@@ -416,6 +416,7 @@ struct address_space {
 	struct mutex		i_mmap_mutex;	/* protect tree, count, list */
 	/* Protected by tree_lock together with the radix tree */
 	unsigned long		nrpages;	/* number of total pages */
+	unsigned long		nrshadows;	/* number of shadow entries */
 	pgoff_t			writeback_index;/* writeback starts here */
 	const struct address_space_operations *a_ops;	/* methods */
 	unsigned long		flags;		/* error bits/gfp mask */
diff -puN include/linux/mm.h~mm-fs-store-shadow-entries-in-page-cache include/linux/mm.h
--- a/include/linux/mm.h~mm-fs-store-shadow-entries-in-page-cache
+++ a/include/linux/mm.h
@@ -1815,6 +1815,7 @@ vm_unmapped_area(struct vm_unmapped_area
 extern void truncate_inode_pages(struct address_space *, loff_t);
 extern void truncate_inode_pages_range(struct address_space *,
 				       loff_t lstart, loff_t lend);
+extern void truncate_inode_pages_final(struct address_space *);
 
 /* generic vm_area_ops exported for stackable file systems */
 extern int filemap_fault(struct vm_area_struct *, struct vm_fault *);
diff -puN include/linux/pagemap.h~mm-fs-store-shadow-entries-in-page-cache include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-fs-store-shadow-entries-in-page-cache
+++ a/include/linux/pagemap.h
@@ -25,6 +25,7 @@ enum mapping_flags {
 	AS_MM_ALL_LOCKS	= __GFP_BITS_SHIFT + 2,	/* under mm_take_all_locks() */
 	AS_UNEVICTABLE	= __GFP_BITS_SHIFT + 3,	/* e.g., ramdisk, SHM_LOCK */
 	AS_BALLOON_MAP  = __GFP_BITS_SHIFT + 4, /* balloon page special map */
+	AS_EXITING	= __GFP_BITS_SHIFT + 5, /* final truncate in progress */
 };
 
 static inline void mapping_set_error(struct address_space *mapping, int error)
@@ -69,6 +70,16 @@ static inline int mapping_balloon(struct
 	return mapping && test_bit(AS_BALLOON_MAP, &mapping->flags);
 }
 
+static inline void mapping_set_exiting(struct address_space *mapping)
+{
+	set_bit(AS_EXITING, &mapping->flags);
+}
+
+static inline int mapping_exiting(struct address_space *mapping)
+{
+	return test_bit(AS_EXITING, &mapping->flags);
+}
+
 static inline gfp_t mapping_gfp_mask(struct address_space * mapping)
 {
 	return (__force gfp_t)mapping->flags & __GFP_BITS_MASK;
@@ -547,7 +558,7 @@ int add_to_page_cache_locked(struct page
 int add_to_page_cache_lru(struct page *page, struct address_space *mapping,
 				pgoff_t index, gfp_t gfp_mask);
 extern void delete_from_page_cache(struct page *page);
-extern void __delete_from_page_cache(struct page *page);
+extern void __delete_from_page_cache(struct page *page, void *shadow);
 int replace_page_cache_page(struct page *old, struct page *new, gfp_t gfp_mask);
 
 /*
diff -puN mm/filemap.c~mm-fs-store-shadow-entries-in-page-cache mm/filemap.c
--- a/mm/filemap.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/mm/filemap.c
@@ -107,12 +107,33 @@
  *   ->tasklist_lock            (memory_failure, collect_procs_ao)
  */
 
+static void page_cache_tree_delete(struct address_space *mapping,
+				   struct page *page, void *shadow)
+{
+	if (shadow) {
+		void **slot;
+
+		slot = radix_tree_lookup_slot(&mapping->page_tree, page->index);
+		radix_tree_replace_slot(slot, shadow);
+		mapping->nrshadows++;
+		/*
+		 * Make sure the nrshadows update is committed before
+		 * the nrpages update so that final truncate racing
+		 * with reclaim does not see both counters 0 at the
+		 * same time and miss a shadow entry.
+		 */
+		smp_wmb();
+	} else
+		radix_tree_delete(&mapping->page_tree, page->index);
+	mapping->nrpages--;
+}
+
 /*
  * Delete a page from the page cache and free it. Caller has to make
  * sure the page is locked and that nobody else uses it - or that usage
  * is safe.  The caller must hold the mapping's tree_lock.
  */
-void __delete_from_page_cache(struct page *page)
+void __delete_from_page_cache(struct page *page, void *shadow)
 {
 	struct address_space *mapping = page->mapping;
 
@@ -127,10 +148,11 @@ void __delete_from_page_cache(struct pag
 	else
 		cleancache_invalidate_page(mapping, page);
 
-	radix_tree_delete(&mapping->page_tree, page->index);
+	page_cache_tree_delete(mapping, page, shadow);
+
 	page->mapping = NULL;
 	/* Leave page->index set: truncation lookup relies upon it */
-	mapping->nrpages--;
+
 	__dec_zone_page_state(page, NR_FILE_PAGES);
 	if (PageSwapBacked(page))
 		__dec_zone_page_state(page, NR_SHMEM);
@@ -166,7 +188,7 @@ void delete_from_page_cache(struct page
 
 	freepage = mapping->a_ops->freepage;
 	spin_lock_irq(&mapping->tree_lock);
-	__delete_from_page_cache(page);
+	__delete_from_page_cache(page, NULL);
 	spin_unlock_irq(&mapping->tree_lock);
 	mem_cgroup_uncharge_cache_page(page);
 
@@ -426,7 +448,7 @@ int replace_page_cache_page(struct page
 		new->index = offset;
 
 		spin_lock_irq(&mapping->tree_lock);
-		__delete_from_page_cache(old);
+		__delete_from_page_cache(old, NULL);
 		error = radix_tree_insert(&mapping->page_tree, offset, new);
 		BUG_ON(error);
 		mapping->nrpages++;
@@ -460,6 +482,7 @@ static int page_cache_tree_insert(struct
 		if (!radix_tree_exceptional_entry(p))
 			return -EEXIST;
 		radix_tree_replace_slot(slot, page);
+		mapping->nrshadows--;
 		mapping->nrpages++;
 		return 0;
 	}
diff -puN mm/truncate.c~mm-fs-store-shadow-entries-in-page-cache mm/truncate.c
--- a/mm/truncate.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/mm/truncate.c
@@ -35,7 +35,8 @@ static void clear_exceptional_entry(stru
 	 * without the tree itself locked.  These unlocked entries
 	 * need verification under the tree lock.
 	 */
-	radix_tree_delete_item(&mapping->page_tree, index, entry);
+	if (radix_tree_delete_item(&mapping->page_tree, index, entry) == entry)
+		mapping->nrshadows--;
 	spin_unlock_irq(&mapping->tree_lock);
 }
 
@@ -229,7 +230,7 @@ void truncate_inode_pages_range(struct a
 	int		i;
 
 	cleancache_invalidate_inode(mapping);
-	if (mapping->nrpages == 0)
+	if (mapping->nrpages == 0 && mapping->nrshadows == 0)
 		return;
 
 	/* Offsets within partial pages */
@@ -391,6 +392,53 @@ void truncate_inode_pages(struct address
 EXPORT_SYMBOL(truncate_inode_pages);
 
 /**
+ * truncate_inode_pages_final - truncate *all* pages before inode dies
+ * @mapping: mapping to truncate
+ *
+ * Called under (and serialized by) inode->i_mutex.
+ *
+ * Filesystems have to use this in the .evict_inode path to inform the
+ * VM that this is the final truncate and the inode is going away.
+ */
+void truncate_inode_pages_final(struct address_space *mapping)
+{
+	unsigned long nrshadows;
+	unsigned long nrpages;
+
+	/*
+	 * Page reclaim can not participate in regular inode lifetime
+	 * management (can't call iput()) and thus can race with the
+	 * inode teardown.  Tell it when the address space is exiting,
+	 * so that it does not install eviction information after the
+	 * final truncate has begun.
+	 */
+	mapping_set_exiting(mapping);
+
+	/*
+	 * When reclaim installs eviction entries, it increases
+	 * nrshadows first, then decreases nrpages.  Make sure we see
+	 * this in the right order or we might miss an entry.
+	 */
+	nrpages = mapping->nrpages;
+	smp_rmb();
+	nrshadows = mapping->nrshadows;
+
+	if (nrpages || nrshadows) {
+		/*
+		 * As truncation uses a lockless tree lookup, cycle
+		 * the tree lock to make sure any ongoing tree
+		 * modification that does not see AS_EXITING is
+		 * completed before starting the final truncate.
+		 */
+		spin_lock_irq(&mapping->tree_lock);
+		spin_unlock_irq(&mapping->tree_lock);
+
+		truncate_inode_pages(mapping, 0);
+	}
+}
+EXPORT_SYMBOL(truncate_inode_pages_final);
+
+/**
  * invalidate_mapping_pages - Invalidate all the unlocked pages of one inode
  * @mapping: the address_space which holds the pages to invalidate
  * @start: the offset 'from' which to invalidate
@@ -483,7 +531,7 @@ invalidate_complete_page2(struct address
 		goto failed;
 
 	BUG_ON(page_has_private(page));
-	__delete_from_page_cache(page);
+	__delete_from_page_cache(page, NULL);
 	spin_unlock_irq(&mapping->tree_lock);
 	mem_cgroup_uncharge_cache_page(page);
 
diff -puN mm/vmscan.c~mm-fs-store-shadow-entries-in-page-cache mm/vmscan.c
--- a/mm/vmscan.c~mm-fs-store-shadow-entries-in-page-cache
+++ a/mm/vmscan.c
@@ -572,7 +572,7 @@ static int __remove_mapping(struct addre
 
 		freepage = mapping->a_ops->freepage;
 
-		__delete_from_page_cache(page);
+		__delete_from_page_cache(page, NULL);
 		spin_unlock_irq(&mapping->tree_lock);
 		mem_cgroup_uncharge_cache_page(page);
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
mm-vmstat-fix-up-zone-state-accounting.patch
fs-cachefiles-use-add_to_page_cache_lru.patch
lib-radix-tree-radix_tree_delete_item.patch
mm-shmem-save-one-radix-tree-lookup-when-truncating-swapped-pages.patch
mm-filemap-move-radix-tree-hole-searching-here.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees.patch
mm-fs-store-shadow-entries-in-page-cache.patch
mm-thrash-detection-based-file-cache-sizing.patch
lib-radix_tree-tree-node-interface.patch
mm-keep-page-cache-radix-tree-nodes-in-check.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

