From: akpm@linux-foundation.org
Subject: [merged]
 mm-remove-nr_pages-argument-from-pagevec_lookup_range_tag.patch removed
 from -mm tree
Date: Thu, 16 Nov 2017 12:02:07 -0800
Message-ID: <20171116200207.Hxt4aGZmA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46612 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932697AbdKPUCI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 15:02:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.m.jordan@oracle.com, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove nr_pages argument from pagevec_lookup_{,range}_tag()
has been removed from the -mm tree.  Its filename was
     mm-remove-nr_pages-argument-from-pagevec_lookup_range_tag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: mm: remove nr_pages argument from pagevec_lookup_{,range}_tag()

All users of pagevec_lookup() and pagevec_lookup_range() now pass
PAGEVEC_SIZE as a desired number of pages.  Just drop the argument.

Link: http://lkml.kernel.org/r/20171009151359.31984-15-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/extent_io.c    |    6 +++---
 fs/ceph/addr.c          |    3 +--
 fs/ext4/inode.c         |    2 +-
 fs/f2fs/checkpoint.c    |    2 +-
 fs/f2fs/data.c          |    2 +-
 fs/f2fs/node.c          |    8 ++++----
 fs/gfs2/aops.c          |    2 +-
 fs/nilfs2/btree.c       |    4 ++--
 fs/nilfs2/page.c        |    7 +++----
 fs/nilfs2/segment.c     |    6 +++---
 include/linux/pagevec.h |    8 +++-----
 mm/filemap.c            |    2 +-
 mm/page-writeback.c     |    2 +-
 mm/swap.c               |    4 ++--
 14 files changed, 27 insertions(+), 31 deletions(-)

diff -puN fs/btrfs/extent_io.c~mm-remove-nr_pages-argument-from-pagevec_lookup_range_tag fs/btrfs/extent_io.c
--- a/fs/btrfs/extent_io.c~mm-remove-nr_pages-argument-from-pagevec_lookup_range_tag
+++ a/fs/btrfs/extent_io.c
@@ -3815,7 +3815,7 @@ retry:
 		tag_pages_for_writeback(mapping, index, end);
 	while (!done && !nr_to_write_done && (index <= end) &&
 	       (nr_pages = pagevec_lookup_range_tag(&pvec, mapping, &index, end,
-			tag, PAGEVEC_SIZE))) {
+			tag))) {
 		unsigned i;
 
 		scanned = 1;
@@ -3956,8 +3956,8 @@ retry:
 		tag_pages_for_writeback(mapping, index, end);
 	done_index = index;
 	while (!done && !nr_to_write_done && (index <= end) &&
-	       (nr_pages = pagevec_lookup_range_tag(&pvec, mapping, &index, end,
-			tag, PAGEVEC_SIZE))) {
+			(nr_pages = pagevec_lookup_range_tag(&pvec, mapping,
+						&index, end, tag))) {
 		unsigned i;
 
 		scanned = 1;
diff -puN fs/ceph/addr.c~mm-remove-nr_pages-argument-from-pagevec_lookup_range_tag fs/ceph/addr.c
--- a/fs/ceph/addr.c~mm-remove-nr_pages-argument-from-pagevec_lookup_range_tag
+++ a/fs/ceph/addr.c
@@ -1162,8 +1162,7 @@ release_pvec_pages:
 			index = 0;
 			while ((index <= end) &&
 			       (nr = pagevec_lookup_tag(&pvec, mapping, &index,
-							PAGECACHE_TAG_WRITEBACK,
-							PAGEVEC_SIZE))) {
+						PAGECACHE_TAG_WRITEBACK))) {
 				for (i = 0; i < nr; i++) {
 					page = pvec.pages[i];
 					if (page_snap_context(page) != snapc)
diff -puN fs/ext4/inode.c~mm-remove-nr_pages-argument-from-pagevec_lookup_range_tag fs/ext4/inode.c
--- a/fs/ext4/inode.c~mm-remove-nr_pages-argument-from-pagevec_lookup_range_tag
+++ a/fs/ext4/inode.c
@@ -2621,7 +2621,7 @@ static int mpage_prepare_extent_to_map(s
 	mpd->next_page = index;
 	while (index <= end) {
 		nr_pages = pagevec_lookup_range_tag(&pvec, mapping, &index, end,
-				tag, PAGEVEC_SIZE);
+				tag);
 		if (nr_pages == 0)
 			goto out;
 
diff -puN fs/f2fs/checkpoint.c~mm-remove-nr_pages-argument-from-pagevec_lookup_range_tag fs/f2fs/checkpoint.c
--- a/fs/f2fs/checkpoint.c~mm-remove-nr_pages-argument-from-pagevec_lookup_range_tag
+++ a/fs/f2fs/checkpoint.c
@@ -319,7 +319,7 @@ long sync_meta_pages(struct f2fs_sb_info
 	blk_start_plug(&plug);
 
 	while ((nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
-				PAGECACHE_TAG_DIRTY, PAGEVEC_SIZE))) {
+				PAGECACHE_TAG_DIRTY))) {
 		int i;
 
 		for (i = 0; i < nr_pages; i++) {
diff -puN fs/f2fs/data.c~mm-remove-nr_pages-argument-from-pagevec_lookup_range_tag fs/f2fs/data.c
--- a/fs/f2fs/data.c~mm-remove-nr_pages-argument-from-pagevec_lookup_range_tag
+++ a/fs/f2fs/data.c
@@ -1670,7 +1670,7 @@ retry:
 		int i;
 
 		nr_pages = pagevec_lookup_range_tag(&pvec, mapping, &index, end,
-				tag, PAGEVEC_SIZE);
+				tag);
 		if (nr_pages == 0)
 			break;
 
diff -puN fs/f2fs/node.c~mm-remove-nr_pages-argument-from-pagevec_lookup_range_tag fs/f2fs/node.c
--- a/fs/f2fs/node.c~mm-remove-nr_pages-argument-from-pagevec_lookup_range_tag
+++ a/fs/f2fs/node.c
@@ -1286,7 +1286,7 @@ static struct page *last_fsync_dnode(str
 	index = 0;
 
 	while ((nr_pages = pagevec_lookup_tag(&pvec, NODE_MAPPING(sbi), &index,
-				PAGECACHE_TAG_DIRTY, PAGEVEC_SIZE))) {
+				PAGECACHE_TAG_DIRTY))) {
 		int i;
 
 		for (i = 0; i < nr_pages; i++) {
@@ -1440,7 +1440,7 @@ retry:
 	index = 0;
 
 	while ((nr_pages = pagevec_lookup_tag(&pvec, NODE_MAPPING(sbi), &index,
-				PAGECACHE_TAG_DIRTY, PAGEVEC_SIZE))) {
+				PAGECACHE_TAG_DIRTY))) {
 		int i;
 
 		for (i = 0; i < nr_pages; i++) {
@@ -1553,7 +1553,7 @@ next_step:
 	index = 0;
 
 	while ((nr_pages = pagevec_lookup_tag(&pvec, NODE_MAPPING(sbi), &index,
-				PAGECACHE_TAG_DIRTY, PAGEVEC_SIZE))) {
+				PAGECACHE_TAG_DIRTY))) {
 		int i;
 
 		for (i = 0; i < nr_pages; i++) {
@@ -1651,7 +1651,7 @@ int wait_on_node_pages_writeback(struct
 	pagevec_init(&pvec, 0);
 
 	while ((nr_pages = pagevec_lookup_tag(&pvec, NODE_MAPPING(sbi), &index,
-				PAGECACHE_TAG_WRITEBACK, PAGEVEC_SIZE))) {
+				PAGECACHE_TAG_WRITEBACK))) {
 		int i;
 
 		for (i = 0; i < nr_pages; i++) {
diff -puN fs/gfs2/aops.c~mm-remove-nr_pages-argument-from-pagevec_lookup_range_tag fs/gfs2/aops.c
--- a/fs/gfs2/aops.c~mm-remove-nr_pages-argument-from-pagevec_lookup_range_tag
+++ a/fs/gfs2/aops.c
@@ -398,7 +398,7 @@ retry:
 	done_index = index;
 	while (!done && (index <= end)) {
 		nr_pages = pagevec_lookup_range_tag(&pvec, mapping, &index, end,
-				tag, PAGEVEC_SIZE);
+				tag);
 		if (nr_pages == 0)
 			break;
 
diff -puN fs/nilfs2/btree.c~mm-remove-nr_pages-argument-from-pagevec_lookup_range_tag fs/nilfs2/btree.c
--- a/fs/nilfs2/btree.c~mm-remove-nr_pages-argument-from-pagevec_lookup_range_tag
+++ a/fs/nilfs2/btree.c
@@ -2158,8 +2158,8 @@ static void nilfs_btree_lookup_dirty_buf
 
 	pagevec_init(&pvec, 0);
 
-	while (pagevec_lookup_tag(&pvec, btcache, &index, PAGECACHE_TAG_DIRTY,
-				  PAGEVEC_SIZE)) {
+	while (pagevec_lookup_tag(&pvec, btcache, &index,
+					PAGECACHE_TAG_DIRTY)) {
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			bh = head = page_buffers(pvec.pages[i]);
 			do {
diff -puN fs/nilfs2/page.c~mm-remove-nr_pages-argument-from-pagevec_lookup_range_tag fs/nilfs2/page.c
--- a/fs/nilfs2/page.c~mm-remove-nr_pages-argument-from-pagevec_lookup_range_tag
+++ a/fs/nilfs2/page.c
@@ -257,8 +257,7 @@ int nilfs_copy_dirty_pages(struct addres
 
 	pagevec_init(&pvec, 0);
 repeat:
-	if (!pagevec_lookup_tag(&pvec, smap, &index, PAGECACHE_TAG_DIRTY,
-				PAGEVEC_SIZE))
+	if (!pagevec_lookup_tag(&pvec, smap, &index, PAGECACHE_TAG_DIRTY))
 		return 0;
 
 	for (i = 0; i < pagevec_count(&pvec); i++) {
@@ -376,8 +375,8 @@ void nilfs_clear_dirty_pages(struct addr
 
 	pagevec_init(&pvec, 0);
 
-	while (pagevec_lookup_tag(&pvec, mapping, &index, PAGECACHE_TAG_DIRTY,
-				  PAGEVEC_SIZE)) {
+	while (pagevec_lookup_tag(&pvec, mapping, &index,
+					PAGECACHE_TAG_DIRTY)) {
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			struct page *page = pvec.pages[i];
 
diff -puN fs/nilfs2/segment.c~mm-remove-nr_pages-argument-from-pagevec_lookup_range_tag fs/nilfs2/segment.c
--- a/fs/nilfs2/segment.c~mm-remove-nr_pages-argument-from-pagevec_lookup_range_tag
+++ a/fs/nilfs2/segment.c
@@ -712,7 +712,7 @@ static size_t nilfs_lookup_dirty_data_bu
  repeat:
 	if (unlikely(index > last) ||
 	    !pagevec_lookup_range_tag(&pvec, mapping, &index, last,
-				PAGECACHE_TAG_DIRTY, PAGEVEC_SIZE))
+				PAGECACHE_TAG_DIRTY))
 		return ndirties;
 
 	for (i = 0; i < pagevec_count(&pvec); i++) {
@@ -755,8 +755,8 @@ static void nilfs_lookup_dirty_node_buff
 
 	pagevec_init(&pvec, 0);
 
-	while (pagevec_lookup_tag(&pvec, mapping, &index, PAGECACHE_TAG_DIRTY,
-				  PAGEVEC_SIZE)) {
+	while (pagevec_lookup_tag(&pvec, mapping, &index,
+					PAGECACHE_TAG_DIRTY)) {
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			bh = head = page_buffers(pvec.pages[i]);
 			do {
diff -puN include/linux/pagevec.h~mm-remove-nr_pages-argument-from-pagevec_lookup_range_tag include/linux/pagevec.h
--- a/include/linux/pagevec.h~mm-remove-nr_pages-argument-from-pagevec_lookup_range_tag
+++ a/include/linux/pagevec.h
@@ -40,16 +40,14 @@ static inline unsigned pagevec_lookup(st
 
 unsigned pagevec_lookup_range_tag(struct pagevec *pvec,
 		struct address_space *mapping, pgoff_t *index, pgoff_t end,
-		int tag, unsigned nr_pages);
+		int tag);
 unsigned pagevec_lookup_range_nr_tag(struct pagevec *pvec,
 		struct address_space *mapping, pgoff_t *index, pgoff_t end,
 		int tag, unsigned max_pages);
 static inline unsigned pagevec_lookup_tag(struct pagevec *pvec,
-		struct address_space *mapping, pgoff_t *index, int tag,
-		unsigned nr_pages)
+		struct address_space *mapping, pgoff_t *index, int tag)
 {
-	return pagevec_lookup_range_tag(pvec, mapping, index, (pgoff_t)-1, tag,
-					nr_pages);
+	return pagevec_lookup_range_tag(pvec, mapping, index, (pgoff_t)-1, tag);
 }
 
 static inline void pagevec_init(struct pagevec *pvec, int cold)
diff -puN mm/filemap.c~mm-remove-nr_pages-argument-from-pagevec_lookup_range_tag mm/filemap.c
--- a/mm/filemap.c~mm-remove-nr_pages-argument-from-pagevec_lookup_range_tag
+++ a/mm/filemap.c
@@ -424,7 +424,7 @@ static void __filemap_fdatawait_range(st
 		unsigned i;
 
 		nr_pages = pagevec_lookup_range_tag(&pvec, mapping, &index,
-				end, PAGECACHE_TAG_WRITEBACK, PAGEVEC_SIZE);
+				end, PAGECACHE_TAG_WRITEBACK);
 		if (!nr_pages)
 			break;
 
diff -puN mm/page-writeback.c~mm-remove-nr_pages-argument-from-pagevec_lookup_range_tag mm/page-writeback.c
--- a/mm/page-writeback.c~mm-remove-nr_pages-argument-from-pagevec_lookup_range_tag
+++ a/mm/page-writeback.c
@@ -2197,7 +2197,7 @@ retry:
 		int i;
 
 		nr_pages = pagevec_lookup_range_tag(&pvec, mapping, &index, end,
-				tag, PAGEVEC_SIZE);
+				tag);
 		if (nr_pages == 0)
 			break;
 
diff -puN mm/swap.c~mm-remove-nr_pages-argument-from-pagevec_lookup_range_tag mm/swap.c
--- a/mm/swap.c~mm-remove-nr_pages-argument-from-pagevec_lookup_range_tag
+++ a/mm/swap.c
@@ -988,10 +988,10 @@ EXPORT_SYMBOL(pagevec_lookup_range);
 
 unsigned pagevec_lookup_range_tag(struct pagevec *pvec,
 		struct address_space *mapping, pgoff_t *index, pgoff_t end,
-		int tag, unsigned nr_pages)
+		int tag)
 {
 	pvec->nr = find_get_pages_range_tag(mapping, index, end, tag,
-					nr_pages, pvec->pages);
+					PAGEVEC_SIZE, pvec->pages);
 	return pagevec_count(pvec);
 }
 EXPORT_SYMBOL(pagevec_lookup_range_tag);
_

Patches currently in -mm which might be from jack@suse.cz are

mm-readahead-increase-maximum-readahead-window.patch

