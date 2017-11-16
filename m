From: akpm@linux-foundation.org
Subject: [merged] f2fs-simplify-page-iteration-loops.patch removed
 from -mm tree
Date: Thu, 16 Nov 2017 12:01:41 -0800
Message-ID: <20171116200141.Eakg4wTKN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46552 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932697AbdKPUBn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 15:01:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.m.jordan@oracle.com, jack@suse.cz, jaegeuk@kernel.org, mm-commits@vger.kernel.org, yuchao0@huawei.com


The patch titled
     Subject: f2fs: simplify page iteration loops
has been removed from the -mm tree.  Its filename was
     f2fs-simplify-page-iteration-loops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: f2fs: simplify page iteration loops

In several places we want to iterate over all tagged pages in a mapping. 
However the code was apparently copied from places that iterate only over
a limited range and thus it checks for index <= end, optimizes the case
where we are coming close to range end which is all pointless when end ==
ULONG_MAX.  So just remove this dead code.

[akpm@linux-foundation.org: fix warnings]
Link: http://lkml.kernel.org/r/20171009151359.31984-7-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/f2fs/checkpoint.c |   13 +++------
 fs/f2fs/node.c       |   59 +++++++++++++----------------------------
 2 files changed, 25 insertions(+), 47 deletions(-)

diff -puN fs/f2fs/checkpoint.c~f2fs-simplify-page-iteration-loops fs/f2fs/checkpoint.c
--- a/fs/f2fs/checkpoint.c~f2fs-simplify-page-iteration-loops
+++ a/fs/f2fs/checkpoint.c
@@ -305,9 +305,10 @@ long sync_meta_pages(struct f2fs_sb_info
 				long nr_to_write, enum iostat_type io_type)
 {
 	struct address_space *mapping = META_MAPPING(sbi);
-	pgoff_t index = 0, end = ULONG_MAX, prev = ULONG_MAX;
+	pgoff_t index = 0, prev = ULONG_MAX;
 	struct pagevec pvec;
 	long nwritten = 0;
+	int nr_pages;
 	struct writeback_control wbc = {
 		.for_reclaim = 0,
 	};
@@ -317,13 +318,9 @@ long sync_meta_pages(struct f2fs_sb_info
 
 	blk_start_plug(&plug);
 
-	while (index <= end) {
-		int i, nr_pages;
-		nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
-				PAGECACHE_TAG_DIRTY,
-				min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1);
-		if (unlikely(nr_pages == 0))
-			break;
+	while ((nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
+				PAGECACHE_TAG_DIRTY, PAGEVEC_SIZE))) {
+		int i;
 
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
diff -puN fs/f2fs/node.c~f2fs-simplify-page-iteration-loops fs/f2fs/node.c
--- a/fs/f2fs/node.c~f2fs-simplify-page-iteration-loops
+++ a/fs/f2fs/node.c
@@ -1277,21 +1277,17 @@ release_page:
 
 static struct page *last_fsync_dnode(struct f2fs_sb_info *sbi, nid_t ino)
 {
-	pgoff_t index, end;
+	pgoff_t index;
 	struct pagevec pvec;
 	struct page *last_page = NULL;
+	int nr_pages;
 
 	pagevec_init(&pvec, 0);
 	index = 0;
-	end = ULONG_MAX;
 
-	while (index <= end) {
-		int i, nr_pages;
-		nr_pages = pagevec_lookup_tag(&pvec, NODE_MAPPING(sbi), &index,
-				PAGECACHE_TAG_DIRTY,
-				min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1);
-		if (nr_pages == 0)
-			break;
+	while ((nr_pages = pagevec_lookup_tag(&pvec, NODE_MAPPING(sbi), &index,
+				PAGECACHE_TAG_DIRTY, PAGEVEC_SIZE))) {
+		int i;
 
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
@@ -1425,13 +1421,14 @@ static int f2fs_write_node_page(struct p
 int fsync_node_pages(struct f2fs_sb_info *sbi, struct inode *inode,
 			struct writeback_control *wbc, bool atomic)
 {
-	pgoff_t index, end;
+	pgoff_t index;
 	pgoff_t last_idx = ULONG_MAX;
 	struct pagevec pvec;
 	int ret = 0;
 	struct page *last_page = NULL;
 	bool marked = false;
 	nid_t ino = inode->i_ino;
+	int nr_pages;
 
 	if (atomic) {
 		last_page = last_fsync_dnode(sbi, ino);
@@ -1441,15 +1438,10 @@ int fsync_node_pages(struct f2fs_sb_info
 retry:
 	pagevec_init(&pvec, 0);
 	index = 0;
-	end = ULONG_MAX;
 
-	while (index <= end) {
-		int i, nr_pages;
-		nr_pages = pagevec_lookup_tag(&pvec, NODE_MAPPING(sbi), &index,
-				PAGECACHE_TAG_DIRTY,
-				min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1);
-		if (nr_pages == 0)
-			break;
+	while ((nr_pages = pagevec_lookup_tag(&pvec, NODE_MAPPING(sbi), &index,
+				PAGECACHE_TAG_DIRTY, PAGEVEC_SIZE))) {
+		int i;
 
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
@@ -1548,25 +1540,21 @@ out:
 int sync_node_pages(struct f2fs_sb_info *sbi, struct writeback_control *wbc,
 				bool do_balance, enum iostat_type io_type)
 {
-	pgoff_t index, end;
+	pgoff_t index;
 	struct pagevec pvec;
 	int step = 0;
 	int nwritten = 0;
 	int ret = 0;
+	int nr_pages;
 
 	pagevec_init(&pvec, 0);
 
 next_step:
 	index = 0;
-	end = ULONG_MAX;
 
-	while (index <= end) {
-		int i, nr_pages;
-		nr_pages = pagevec_lookup_tag(&pvec, NODE_MAPPING(sbi), &index,
-				PAGECACHE_TAG_DIRTY,
-				min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1);
-		if (nr_pages == 0)
-			break;
+	while ((nr_pages = pagevec_lookup_tag(&pvec, NODE_MAPPING(sbi), &index,
+				PAGECACHE_TAG_DIRTY, PAGEVEC_SIZE))) {
+		int i;
 
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
@@ -1655,27 +1643,20 @@ out:
 
 int wait_on_node_pages_writeback(struct f2fs_sb_info *sbi, nid_t ino)
 {
-	pgoff_t index = 0, end = ULONG_MAX;
+	pgoff_t index = 0;
 	struct pagevec pvec;
 	int ret2, ret = 0;
+	int nr_pages;
 
 	pagevec_init(&pvec, 0);
 
-	while (index <= end) {
-		int i, nr_pages;
-		nr_pages = pagevec_lookup_tag(&pvec, NODE_MAPPING(sbi), &index,
-				PAGECACHE_TAG_WRITEBACK,
-				min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1);
-		if (nr_pages == 0)
-			break;
+	while ((nr_pages = pagevec_lookup_tag(&pvec, NODE_MAPPING(sbi), &index,
+				PAGECACHE_TAG_WRITEBACK, PAGEVEC_SIZE))) {
+		int i;
 
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
 
-			/* until radix tree lookup accepts end_index */
-			if (unlikely(page->index > end))
-				continue;
