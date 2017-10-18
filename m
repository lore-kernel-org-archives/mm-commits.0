From: akpm@linux-foundation.org
Subject: + mm-pagevec-remove-cold-parameter-for-pagevecs.patch added to
 -mm tree
Date: Wed, 18 Oct 2017 15:16:47 -0700
Message-ID: <59e7d2cf.INHhOnXPUJTUYajg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37776 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751041AbdJRWQt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2017 18:16:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, ak@linux.intel.com, dave.hansen@intel.com, david@fromorbit.com, hannes@cmpxchg.org, jack@suse.cz, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, pagevec: remove cold parameter for pagevecs
has been added to the -mm tree.  Its filename is
     mm-pagevec-remove-cold-parameter-for-pagevecs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-pagevec-remove-cold-parameter-for-pagevecs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-pagevec-remove-cold-parameter-for-pagevecs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, pagevec: remove cold parameter for pagevecs

Every pagevec_init user claims the pages being released are hot even in
cases where it is unlikely the pages are hot.  As no one cares about the
hotness of pages being released to the allocator, just ditch the
parameter.

No performance impact is expected as the overhead is marginal.  The
parameter is removed simply because it is a bit stupid to have a useless
parameter copied everywhere.

Link: http://lkml.kernel.org/r/20171018075952.10627-6-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/i915_gem_gtt.c |    2 +-
 fs/afs/write.c                      |    4 ++--
 fs/btrfs/extent_io.c                |    4 ++--
 fs/buffer.c                         |    4 ++--
 fs/cachefiles/rdwr.c                |    4 ++--
 fs/ceph/addr.c                      |    4 ++--
 fs/dax.c                            |    2 +-
 fs/ext4/file.c                      |    2 +-
 fs/ext4/inode.c                     |    6 +++---
 fs/f2fs/checkpoint.c                |    2 +-
 fs/f2fs/data.c                      |    2 +-
 fs/f2fs/node.c                      |    8 ++++----
 fs/fscache/page.c                   |    2 +-
 fs/gfs2/aops.c                      |    2 +-
 fs/hugetlbfs/inode.c                |    2 +-
 fs/nilfs2/btree.c                   |    2 +-
 fs/nilfs2/page.c                    |    8 ++++----
 fs/nilfs2/segment.c                 |    4 ++--
 include/linux/pagevec.h             |    4 +---
 mm/filemap.c                        |    2 +-
 mm/mlock.c                          |    4 ++--
 mm/page-writeback.c                 |    2 +-
 mm/shmem.c                          |    6 +++---
 mm/swap.c                           |    4 ++--
 mm/truncate.c                       |    8 ++++----
 25 files changed, 46 insertions(+), 48 deletions(-)

diff -puN drivers/gpu/drm/i915/i915_gem_gtt.c~mm-pagevec-remove-cold-parameter-for-pagevecs drivers/gpu/drm/i915/i915_gem_gtt.c
--- a/drivers/gpu/drm/i915/i915_gem_gtt.c~mm-pagevec-remove-cold-parameter-for-pagevecs
+++ a/drivers/gpu/drm/i915/i915_gem_gtt.c
@@ -1866,7 +1866,7 @@ static void i915_address_space_init(stru
 	INIT_LIST_HEAD(&vm->unbound_list);
 
 	list_add_tail(&vm->global_link, &dev_priv->vm_list);
-	pagevec_init(&vm->free_pages, false);
+	pagevec_init(&vm->free_pages);
 }
 
 static void i915_address_space_fini(struct i915_address_space *vm)
diff -puN fs/afs/write.c~mm-pagevec-remove-cold-parameter-for-pagevecs fs/afs/write.c
--- a/fs/afs/write.c~mm-pagevec-remove-cold-parameter-for-pagevecs
+++ a/fs/afs/write.c
@@ -308,7 +308,7 @@ static void afs_kill_pages(struct afs_vn
 	_enter("{%x:%u},%lx-%lx",
 	       vnode->fid.vid, vnode->fid.vnode, first, last);
 
-	pagevec_init(&pv, 0);
+	pagevec_init(&pv);
 
 	do {
 		_debug("kill %lx-%lx", first, last);
@@ -602,7 +602,7 @@ void afs_pages_written_back(struct afs_v
 
 	ASSERT(wb != NULL);
 
-	pagevec_init(&pv, 0);
+	pagevec_init(&pv);
 
 	do {
 		_debug("done %lx-%lx", first, last);
diff -puN fs/btrfs/extent_io.c~mm-pagevec-remove-cold-parameter-for-pagevecs fs/btrfs/extent_io.c
--- a/fs/btrfs/extent_io.c~mm-pagevec-remove-cold-parameter-for-pagevecs
+++ a/fs/btrfs/extent_io.c
@@ -3801,7 +3801,7 @@ int btree_write_cache_pages(struct addre
 	int scanned = 0;
 	int tag;
 
-	pagevec_init(&pvec, 0);
+	pagevec_init(&pvec);
 	if (wbc->range_cyclic) {
 		index = mapping->writeback_index; /* Start from prev offset */
 		end = -1;
@@ -3940,7 +3940,7 @@ static int extent_write_cache_pages(stru
 	if (!igrab(inode))
 		return 0;
 
-	pagevec_init(&pvec, 0);
+	pagevec_init(&pvec);
 	if (wbc->range_cyclic) {
 		index = mapping->writeback_index; /* Start from prev offset */
 		end = -1;
diff -puN fs/buffer.c~mm-pagevec-remove-cold-parameter-for-pagevecs fs/buffer.c
--- a/fs/buffer.c~mm-pagevec-remove-cold-parameter-for-pagevecs
+++ a/fs/buffer.c
@@ -1632,7 +1632,7 @@ void clean_bdev_aliases(struct block_dev
 	struct buffer_head *head;
 
 	end = (block + len - 1) >> (PAGE_SHIFT - bd_inode->i_blkbits);
-	pagevec_init(&pvec, 0);
+	pagevec_init(&pvec);
 	while (pagevec_lookup_range(&pvec, bd_mapping, &index, end)) {
 		count = pagevec_count(&pvec);
 		for (i = 0; i < count; i++) {
@@ -3545,7 +3545,7 @@ page_cache_seek_hole_data(struct inode *
 	if (length <= 0)
 		return -ENOENT;
 
-	pagevec_init(&pvec, 0);
+	pagevec_init(&pvec);
 
 	do {
 		unsigned nr_pages, i;
diff -puN fs/cachefiles/rdwr.c~mm-pagevec-remove-cold-parameter-for-pagevecs fs/cachefiles/rdwr.c
--- a/fs/cachefiles/rdwr.c~mm-pagevec-remove-cold-parameter-for-pagevecs
+++ a/fs/cachefiles/rdwr.c
@@ -710,7 +710,7 @@ int cachefiles_read_or_alloc_pages(struc
 	/* calculate the shift required to use bmap */
 	shift = PAGE_SHIFT - inode->i_sb->s_blocksize_bits;
 
-	pagevec_init(&pagevec, 0);
+	pagevec_init(&pagevec);
 
 	op->op.flags &= FSCACHE_OP_KEEP_FLAGS;
 	op->op.flags |= FSCACHE_OP_ASYNC;
@@ -844,7 +844,7 @@ int cachefiles_allocate_pages(struct fsc
 
 	ret = cachefiles_has_space(cache, 0, *nr_pages);
 	if (ret == 0) {
-		pagevec_init(&pagevec, 0);
+		pagevec_init(&pagevec);
 
 		list_for_each_entry(page, pages, lru) {
 			if (pagevec_add(&pagevec, page) == 0)
diff -puN fs/ceph/addr.c~mm-pagevec-remove-cold-parameter-for-pagevecs fs/ceph/addr.c
--- a/fs/ceph/addr.c~mm-pagevec-remove-cold-parameter-for-pagevecs
+++ a/fs/ceph/addr.c
@@ -679,7 +679,7 @@ static void ceph_release_pages(struct pa
 	struct pagevec pvec;
 	int i;
 
-	pagevec_init(&pvec, 0);
+	pagevec_init(&pvec);
 	for (i = 0; i < num; i++) {
 		if (pagevec_add(&pvec, pages[i]) == 0)
 			pagevec_release(&pvec);
@@ -810,7 +810,7 @@ static int ceph_writepages_start(struct
 	if (fsc->mount_options->wsize < wsize)
 		wsize = fsc->mount_options->wsize;
 
-	pagevec_init(&pvec, 0);
+	pagevec_init(&pvec);
 
 	start_index = wbc->range_cyclic ? mapping->writeback_index : 0;
 	index = start_index;
diff -puN fs/dax.c~mm-pagevec-remove-cold-parameter-for-pagevecs fs/dax.c
--- a/fs/dax.c~mm-pagevec-remove-cold-parameter-for-pagevecs
+++ a/fs/dax.c
@@ -794,7 +794,7 @@ int dax_writeback_mapping_range(struct a
 
 	tag_pages_for_writeback(mapping, start_index, end_index);
 
-	pagevec_init(&pvec, 0);
+	pagevec_init(&pvec);
 	while (!done) {
 		pvec.nr = find_get_entries_tag(mapping, start_index,
 				PAGECACHE_TAG_TOWRITE, PAGEVEC_SIZE,
diff -puN fs/ext4/file.c~mm-pagevec-remove-cold-parameter-for-pagevecs fs/ext4/file.c
--- a/fs/ext4/file.c~mm-pagevec-remove-cold-parameter-for-pagevecs
+++ a/fs/ext4/file.c
@@ -475,7 +475,7 @@ static int ext4_find_unwritten_pgoff(str
 	index = startoff >> PAGE_SHIFT;
 	end = (endoff - 1) >> PAGE_SHIFT;
 
-	pagevec_init(&pvec, 0);
+	pagevec_init(&pvec);
 	do {
 		int i;
 		unsigned long nr_pages;
diff -puN fs/ext4/inode.c~mm-pagevec-remove-cold-parameter-for-pagevecs fs/ext4/inode.c
--- a/fs/ext4/inode.c~mm-pagevec-remove-cold-parameter-for-pagevecs
+++ a/fs/ext4/inode.c
@@ -1718,7 +1718,7 @@ static void mpage_release_unused_pages(s
 		ext4_es_remove_extent(inode, start, last - start + 1);
 	}
 
-	pagevec_init(&pvec, 0);
+	pagevec_init(&pvec);
 	while (index <= end) {
 		nr_pages = pagevec_lookup_range(&pvec, mapping, &index, end);
 		if (nr_pages == 0)
@@ -2344,7 +2344,7 @@ static int mpage_map_and_submit_buffers(
 	lblk = start << bpp_bits;
 	pblock = mpd->map.m_pblk;
 
-	pagevec_init(&pvec, 0);
+	pagevec_init(&pvec);
 	while (start <= end) {
 		nr_pages = pagevec_lookup_range(&pvec, inode->i_mapping,
 						&start, end);
@@ -2615,7 +2615,7 @@ static int mpage_prepare_extent_to_map(s
 	else
 		tag = PAGECACHE_TAG_DIRTY;
 
-	pagevec_init(&pvec, 0);
+	pagevec_init(&pvec);
 	mpd->map.m_len = 0;
 	mpd->next_page = index;
 	while (index <= end) {
diff -puN fs/f2fs/checkpoint.c~mm-pagevec-remove-cold-parameter-for-pagevecs fs/f2fs/checkpoint.c
--- a/fs/f2fs/checkpoint.c~mm-pagevec-remove-cold-parameter-for-pagevecs
+++ a/fs/f2fs/checkpoint.c
@@ -314,7 +314,7 @@ long sync_meta_pages(struct f2fs_sb_info
 	};
 	struct blk_plug plug;
 
-	pagevec_init(&pvec, 0);
+	pagevec_init(&pvec);
 
 	blk_start_plug(&plug);
 
diff -puN fs/f2fs/data.c~mm-pagevec-remove-cold-parameter-for-pagevecs fs/f2fs/data.c
--- a/fs/f2fs/data.c~mm-pagevec-remove-cold-parameter-for-pagevecs
+++ a/fs/f2fs/data.c
@@ -1635,7 +1635,7 @@ static int f2fs_write_cache_pages(struct
 	int range_whole = 0;
 	int tag;
 
-	pagevec_init(&pvec, 0);
+	pagevec_init(&pvec);
 
 	if (get_dirty_pages(mapping->host) <=
 				SM_I(F2FS_M_SB(mapping))->min_hot_blocks)
diff -puN fs/f2fs/node.c~mm-pagevec-remove-cold-parameter-for-pagevecs fs/f2fs/node.c
--- a/fs/f2fs/node.c~mm-pagevec-remove-cold-parameter-for-pagevecs
+++ a/fs/f2fs/node.c
@@ -1282,7 +1282,7 @@ static struct page *last_fsync_dnode(str
 	struct page *last_page = NULL;
 	int nr_pages;
 
-	pagevec_init(&pvec, 0);
+	pagevec_init(&pvec);
 	index = 0;
 
 	while ((nr_pages = pagevec_lookup_tag(&pvec, NODE_MAPPING(sbi), &index,
@@ -1436,7 +1436,7 @@ int fsync_node_pages(struct f2fs_sb_info
 			return PTR_ERR_OR_ZERO(last_page);
 	}
 retry:
-	pagevec_init(&pvec, 0);
+	pagevec_init(&pvec);
 	index = 0;
 
 	while ((nr_pages = pagevec_lookup_tag(&pvec, NODE_MAPPING(sbi), &index,
@@ -1547,7 +1547,7 @@ int sync_node_pages(struct f2fs_sb_info
 	int ret = 0;
 	int nr_pages;
 
-	pagevec_init(&pvec, 0);
+	pagevec_init(&pvec);
 
 next_step:
 	index = 0;
@@ -1648,7 +1648,7 @@ int wait_on_node_pages_writeback(struct
 	int ret2, ret = 0;
 	int nr_pages;
 
-	pagevec_init(&pvec, 0);
+	pagevec_init(&pvec);
 
 	while ((nr_pages = pagevec_lookup_tag(&pvec, NODE_MAPPING(sbi), &index,
 				PAGECACHE_TAG_WRITEBACK))) {
diff -puN fs/fscache/page.c~mm-pagevec-remove-cold-parameter-for-pagevecs fs/fscache/page.c
--- a/fs/fscache/page.c~mm-pagevec-remove-cold-parameter-for-pagevecs
+++ a/fs/fscache/page.c
@@ -1175,7 +1175,7 @@ void __fscache_uncache_all_inode_pages(s
 		return;
 	}
 
-	pagevec_init(&pvec, 0);
+	pagevec_init(&pvec);
 	next = 0;
 	do {
 		if (!pagevec_lookup(&pvec, mapping, &next))
diff -puN fs/gfs2/aops.c~mm-pagevec-remove-cold-parameter-for-pagevecs fs/gfs2/aops.c
--- a/fs/gfs2/aops.c~mm-pagevec-remove-cold-parameter-for-pagevecs
+++ a/fs/gfs2/aops.c
@@ -371,7 +371,7 @@ static int gfs2_write_cache_jdata(struct
 	int range_whole = 0;
 	int tag;
 
-	pagevec_init(&pvec, 0);
+	pagevec_init(&pvec);
 	if (wbc->range_cyclic) {
 		writeback_index = mapping->writeback_index; /* prev offset */
 		index = writeback_index;
diff -puN fs/hugetlbfs/inode.c~mm-pagevec-remove-cold-parameter-for-pagevecs fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mm-pagevec-remove-cold-parameter-for-pagevecs
+++ a/fs/hugetlbfs/inode.c
@@ -407,7 +407,7 @@ static void remove_inode_hugepages(struc
 
 	memset(&pseudo_vma, 0, sizeof(struct vm_area_struct));
 	pseudo_vma.vm_flags = (VM_HUGETLB | VM_MAYSHARE | VM_SHARED);
-	pagevec_init(&pvec, 0);
+	pagevec_init(&pvec);
 	next = start;
 	while (next < end) {
 		/*
diff -puN fs/nilfs2/btree.c~mm-pagevec-remove-cold-parameter-for-pagevecs fs/nilfs2/btree.c
--- a/fs/nilfs2/btree.c~mm-pagevec-remove-cold-parameter-for-pagevecs
+++ a/fs/nilfs2/btree.c
@@ -2156,7 +2156,7 @@ static void nilfs_btree_lookup_dirty_buf
 	     level++)
 		INIT_LIST_HEAD(&lists[level]);
 
-	pagevec_init(&pvec, 0);
+	pagevec_init(&pvec);
 
 	while (pagevec_lookup_tag(&pvec, btcache, &index,
 					PAGECACHE_TAG_DIRTY)) {
diff -puN fs/nilfs2/page.c~mm-pagevec-remove-cold-parameter-for-pagevecs fs/nilfs2/page.c
--- a/fs/nilfs2/page.c~mm-pagevec-remove-cold-parameter-for-pagevecs
+++ a/fs/nilfs2/page.c
@@ -255,7 +255,7 @@ int nilfs_copy_dirty_pages(struct addres
 	pgoff_t index = 0;
 	int err = 0;
 
-	pagevec_init(&pvec, 0);
+	pagevec_init(&pvec);
 repeat:
 	if (!pagevec_lookup_tag(&pvec, smap, &index, PAGECACHE_TAG_DIRTY))
 		return 0;
@@ -309,7 +309,7 @@ void nilfs_copy_back_pages(struct addres
 	pgoff_t index = 0;
 	int err;
 
-	pagevec_init(&pvec, 0);
+	pagevec_init(&pvec);
 repeat:
 	n = pagevec_lookup(&pvec, smap, &index);
 	if (!n)
@@ -373,7 +373,7 @@ void nilfs_clear_dirty_pages(struct addr
 	unsigned int i;
 	pgoff_t index = 0;
 
-	pagevec_init(&pvec, 0);
+	pagevec_init(&pvec);
 
 	while (pagevec_lookup_tag(&pvec, mapping, &index,
 					PAGECACHE_TAG_DIRTY)) {
@@ -518,7 +518,7 @@ unsigned long nilfs_find_uncommitted_ext
 	index = start_blk >> (PAGE_SHIFT - inode->i_blkbits);
 	nblocks_in_page = 1U << (PAGE_SHIFT - inode->i_blkbits);
 
-	pagevec_init(&pvec, 0);
+	pagevec_init(&pvec);
 
 repeat:
 	pvec.nr = find_get_pages_contig(inode->i_mapping, index, PAGEVEC_SIZE,
diff -puN fs/nilfs2/segment.c~mm-pagevec-remove-cold-parameter-for-pagevecs fs/nilfs2/segment.c
--- a/fs/nilfs2/segment.c~mm-pagevec-remove-cold-parameter-for-pagevecs
+++ a/fs/nilfs2/segment.c
@@ -708,7 +708,7 @@ static size_t nilfs_lookup_dirty_data_bu
 		index = start >> PAGE_SHIFT;
 		last = end >> PAGE_SHIFT;
 	}
-	pagevec_init(&pvec, 0);
+	pagevec_init(&pvec);
  repeat:
 	if (unlikely(index > last) ||
 	    !pagevec_lookup_range_tag(&pvec, mapping, &index, last,
@@ -753,7 +753,7 @@ static void nilfs_lookup_dirty_node_buff
 	unsigned int i;
 	pgoff_t index = 0;
 
-	pagevec_init(&pvec, 0);
+	pagevec_init(&pvec);
 
 	while (pagevec_lookup_tag(&pvec, mapping, &index,
 					PAGECACHE_TAG_DIRTY)) {
diff -puN include/linux/pagevec.h~mm-pagevec-remove-cold-parameter-for-pagevecs include/linux/pagevec.h
--- a/include/linux/pagevec.h~mm-pagevec-remove-cold-parameter-for-pagevecs
+++ a/include/linux/pagevec.h
@@ -16,7 +16,6 @@ struct address_space;
 
 struct pagevec {
 	unsigned long nr;
-	bool cold;
 	bool drained;
 	struct page *pages[PAGEVEC_SIZE];
 };
@@ -50,10 +49,9 @@ static inline unsigned pagevec_lookup_ta
 	return pagevec_lookup_range_tag(pvec, mapping, index, (pgoff_t)-1, tag);
 }
 
-static inline void pagevec_init(struct pagevec *pvec, int cold)
+static inline void pagevec_init(struct pagevec *pvec)
 {
 	pvec->nr = 0;
-	pvec->cold = cold;
 	pvec->drained = false;
 }
 
diff -puN mm/filemap.c~mm-pagevec-remove-cold-parameter-for-pagevecs mm/filemap.c
--- a/mm/filemap.c~mm-pagevec-remove-cold-parameter-for-pagevecs
+++ a/mm/filemap.c
@@ -519,7 +519,7 @@ static void __filemap_fdatawait_range(st
 	if (end_byte < start_byte)
 		return;
 
-	pagevec_init(&pvec, 0);
+	pagevec_init(&pvec);
 	while (index <= end) {
 		unsigned i;
 
diff -puN mm/mlock.c~mm-pagevec-remove-cold-parameter-for-pagevecs mm/mlock.c
--- a/mm/mlock.c~mm-pagevec-remove-cold-parameter-for-pagevecs
+++ a/mm/mlock.c
@@ -288,7 +288,7 @@ static void __munlock_pagevec(struct pag
 	struct pagevec pvec_putback;
 	int pgrescued = 0;
 
-	pagevec_init(&pvec_putback, 0);
+	pagevec_init(&pvec_putback);
 
 	/* Phase 1: page isolation */
 	spin_lock_irq(zone_lru_lock(zone));
@@ -447,7 +447,7 @@ void munlock_vma_pages_range(struct vm_a
 		struct pagevec pvec;
 		struct zone *zone;
 
-		pagevec_init(&pvec, 0);
+		pagevec_init(&pvec);
 		/*
 		 * Although FOLL_DUMP is intended for get_dump_page(),
 		 * it just so happens that its special treatment of the
diff -puN mm/page-writeback.c~mm-pagevec-remove-cold-parameter-for-pagevecs mm/page-writeback.c
--- a/mm/page-writeback.c~mm-pagevec-remove-cold-parameter-for-pagevecs
+++ a/mm/page-writeback.c
@@ -2168,7 +2168,7 @@ int write_cache_pages(struct address_spa
 	int range_whole = 0;
 	int tag;
 
-	pagevec_init(&pvec, 0);
+	pagevec_init(&pvec);
 	if (wbc->range_cyclic) {
 		writeback_index = mapping->writeback_index; /* prev offset */
 		index = writeback_index;
diff -puN mm/shmem.c~mm-pagevec-remove-cold-parameter-for-pagevecs mm/shmem.c
--- a/mm/shmem.c~mm-pagevec-remove-cold-parameter-for-pagevecs
+++ a/mm/shmem.c
@@ -747,7 +747,7 @@ void shmem_unlock_mapping(struct address
 	pgoff_t indices[PAGEVEC_SIZE];
 	pgoff_t index = 0;
 
-	pagevec_init(&pvec, 0);
+	pagevec_init(&pvec);
 	/*
 	 * Minor point, but we might as well stop if someone else SHM_LOCKs it.
 	 */
@@ -790,7 +790,7 @@ static void shmem_undo_range(struct inod
 	if (lend == -1)
 		end = -1;	/* unsigned, so actually very big */
 
-	pagevec_init(&pvec, 0);
+	pagevec_init(&pvec);
 	index = start;
 	while (index < end) {
 		pvec.nr = find_get_entries(mapping, index,
@@ -2528,7 +2528,7 @@ static pgoff_t shmem_seek_hole_data(stru
 	bool done = false;
 	int i;
 
-	pagevec_init(&pvec, 0);
+	pagevec_init(&pvec);
 	pvec.nr = 1;		/* start small: we may be there already */
 	while (!done) {
 		pvec.nr = find_get_entries(mapping, index,
diff -puN mm/swap.c~mm-pagevec-remove-cold-parameter-for-pagevecs mm/swap.c
--- a/mm/swap.c~mm-pagevec-remove-cold-parameter-for-pagevecs
+++ a/mm/swap.c
@@ -210,7 +210,7 @@ static void pagevec_lru_move_fn(struct p
 	}
 	if (pgdat)
 		spin_unlock_irqrestore(&pgdat->lru_lock, flags);
-	release_pages(pvec->pages, pvec->nr, pvec->cold);
+	release_pages(pvec->pages, pvec->nr, 0);
 	pagevec_reinit(pvec);
 }
 
@@ -837,7 +837,7 @@ void __pagevec_release(struct pagevec *p
 		lru_add_drain();
 		pvec->drained = true;
 	}
-	release_pages(pvec->pages, pagevec_count(pvec), pvec->cold);
+	release_pages(pvec->pages, pagevec_count(pvec), 0);
 	pagevec_reinit(pvec);
 }
 EXPORT_SYMBOL(__pagevec_release);
diff -puN mm/truncate.c~mm-pagevec-remove-cold-parameter-for-pagevecs mm/truncate.c
--- a/mm/truncate.c~mm-pagevec-remove-cold-parameter-for-pagevecs
+++ a/mm/truncate.c
@@ -322,7 +322,7 @@ void truncate_inode_pages_range(struct a
 	else
 		end = (lend + 1) >> PAGE_SHIFT;
 
-	pagevec_init(&pvec, 0);
+	pagevec_init(&pvec);
 	index = start;
 	while (index < end && pagevec_lookup_entries(&pvec, mapping, index,
 			min(end - index, (pgoff_t)PAGEVEC_SIZE),
@@ -335,7 +335,7 @@ void truncate_inode_pages_range(struct a
 		struct pagevec locked_pvec;
 		int ei = PAGEVEC_SIZE;
 
-		pagevec_init(&locked_pvec, 0);
+		pagevec_init(&locked_pvec);
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			struct page *page = pvec.pages[i];
 
@@ -554,7 +554,7 @@ unsigned long invalidate_mapping_pages(s
 	unsigned long count = 0;
 	int i;
 
-	pagevec_init(&pvec, 0);
+	pagevec_init(&pvec);
 	while (index <= end && pagevec_lookup_entries(&pvec, mapping, index,
 			min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1,
 			indices)) {
@@ -684,7 +684,7 @@ int invalidate_inode_pages2_range(struct
 	if (mapping->nrpages == 0 && mapping->nrexceptional == 0)
 		goto out;
 
-	pagevec_init(&pvec, 0);
+	pagevec_init(&pvec);
 	index = start;
 	while (index <= end && pagevec_lookup_entries(&pvec, mapping, index,
 			min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1,
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-enable-disable-irqs-once-when-freeing-a-list-of-pages.patch
mm-page_alloc-enable-disable-irqs-once-when-freeing-a-list-of-pages-fix.patch
mm-truncate-do-not-check-mapping-for-every-page-being-truncated.patch
mm-truncate-remove-all-exceptional-entries-from-pagevec-under-one-lock.patch
mm-only-drain-per-cpu-pagevecs-once-per-pagevec-usage.patch
mm-pagevec-remove-cold-parameter-for-pagevecs.patch
mm-remove-cold-parameter-for-release_pages.patch
mm-remove-cold-parameter-from-free_hot_cold_page.patch
mm-remove-__gfp_cold.patch

