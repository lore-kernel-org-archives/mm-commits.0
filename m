From: akpm@linux-foundation.org
Subject: [patch 057/119] mm: remove nr_pages argument from
 pagevec_lookup{,_range}()
Date: Wed, 06 Sep 2017 16:21:43 -0700
Message-ID: <20170906232143.9kSmPD-OW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49978 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753391AbdIFXVp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:21:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jack@suse.cz, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Jan Kara <jack@suse.cz>
Subject: mm: remove nr_pages argument from pagevec_lookup{,_range}()

All users of pagevec_lookup() and pagevec_lookup_range() now pass
PAGEVEC_SIZE as a desired number of pages.  Just drop the argument.

Link: http://lkml.kernel.org/r/20170726114704.7626-11-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c             |    5 ++---
 fs/ext4/file.c          |    2 +-
 fs/ext4/inode.c         |    5 ++---
 fs/fscache/page.c       |    2 +-
 fs/hugetlbfs/inode.c    |    3 +--
 fs/nilfs2/page.c        |    2 +-
 include/linux/pagevec.h |    7 +++----
 mm/swap.c               |    5 ++---
 8 files changed, 13 insertions(+), 18 deletions(-)

diff -puN fs/buffer.c~mm-remove-nr_pages-argument-from-pagevec_lookup_range fs/buffer.c
--- a/fs/buffer.c~mm-remove-nr_pages-argument-from-pagevec_lookup_range
+++ a/fs/buffer.c
@@ -1633,8 +1633,7 @@ void clean_bdev_aliases(struct block_dev
 
 	end = (block + len - 1) >> (PAGE_SHIFT - bd_inode->i_blkbits);
 	pagevec_init(&pvec, 0);
-	while (pagevec_lookup_range(&pvec, bd_mapping, &index, end,
-				    PAGEVEC_SIZE)) {
+	while (pagevec_lookup_range(&pvec, bd_mapping, &index, end)) {
 		count = pagevec_count(&pvec);
 		for (i = 0; i < count; i++) {
 			struct page *page = pvec.pages[i];
@@ -3552,7 +3551,7 @@ page_cache_seek_hole_data(struct inode *
 		unsigned nr_pages, i;
 
 		nr_pages = pagevec_lookup_range(&pvec, inode->i_mapping, &index,
-						end - 1, PAGEVEC_SIZE);
+						end - 1);
 		if (nr_pages == 0)
 			break;
 
diff -puN fs/ext4/file.c~mm-remove-nr_pages-argument-from-pagevec_lookup_range fs/ext4/file.c
--- a/fs/ext4/file.c~mm-remove-nr_pages-argument-from-pagevec_lookup_range
+++ a/fs/ext4/file.c
@@ -468,7 +468,7 @@ static int ext4_find_unwritten_pgoff(str
 		unsigned long nr_pages;
 
 		nr_pages = pagevec_lookup_range(&pvec, inode->i_mapping,
-					&index, end, PAGEVEC_SIZE);
+					&index, end);
 		if (nr_pages == 0)
 			break;
 
diff -puN fs/ext4/inode.c~mm-remove-nr_pages-argument-from-pagevec_lookup_range fs/ext4/inode.c
--- a/fs/ext4/inode.c~mm-remove-nr_pages-argument-from-pagevec_lookup_range
+++ a/fs/ext4/inode.c
@@ -1720,8 +1720,7 @@ static void mpage_release_unused_pages(s
 
 	pagevec_init(&pvec, 0);
 	while (index <= end) {
-		nr_pages = pagevec_lookup_range(&pvec, mapping, &index, end,
-						PAGEVEC_SIZE);
+		nr_pages = pagevec_lookup_range(&pvec, mapping, &index, end);
 		if (nr_pages == 0)
 			break;
 		for (i = 0; i < nr_pages; i++) {
@@ -2348,7 +2347,7 @@ static int mpage_map_and_submit_buffers(
 	pagevec_init(&pvec, 0);
 	while (start <= end) {
 		nr_pages = pagevec_lookup_range(&pvec, inode->i_mapping,
-						&start, end, PAGEVEC_SIZE);
+						&start, end);
 		if (nr_pages == 0)
 			break;
 		for (i = 0; i < nr_pages; i++) {
diff -puN fs/fscache/page.c~mm-remove-nr_pages-argument-from-pagevec_lookup_range fs/fscache/page.c
--- a/fs/fscache/page.c~mm-remove-nr_pages-argument-from-pagevec_lookup_range
+++ a/fs/fscache/page.c
@@ -1178,7 +1178,7 @@ void __fscache_uncache_all_inode_pages(s
 	pagevec_init(&pvec, 0);
 	next = 0;
 	do {
-		if (!pagevec_lookup(&pvec, mapping, &next, PAGEVEC_SIZE))
+		if (!pagevec_lookup(&pvec, mapping, &next))
 			break;
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			struct page *page = pvec.pages[i];
diff -puN fs/hugetlbfs/inode.c~mm-remove-nr_pages-argument-from-pagevec_lookup_range fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mm-remove-nr_pages-argument-from-pagevec_lookup_range
+++ a/fs/hugetlbfs/inode.c
@@ -413,8 +413,7 @@ static void remove_inode_hugepages(struc
 		/*
 		 * When no more pages are found, we are done.
 		 */
-		if (!pagevec_lookup_range(&pvec, mapping, &next, end - 1,
-					  PAGEVEC_SIZE))
+		if (!pagevec_lookup_range(&pvec, mapping, &next, end - 1))
 			break;
 
 		for (i = 0; i < pagevec_count(&pvec); ++i) {
diff -puN fs/nilfs2/page.c~mm-remove-nr_pages-argument-from-pagevec_lookup_range fs/nilfs2/page.c
--- a/fs/nilfs2/page.c~mm-remove-nr_pages-argument-from-pagevec_lookup_range
+++ a/fs/nilfs2/page.c
@@ -312,7 +312,7 @@ void nilfs_copy_back_pages(struct addres
 
 	pagevec_init(&pvec, 0);
 repeat:
-	n = pagevec_lookup(&pvec, smap, &index, PAGEVEC_SIZE);
+	n = pagevec_lookup(&pvec, smap, &index);
 	if (!n)
 		return;
 
diff -puN include/linux/pagevec.h~mm-remove-nr_pages-argument-from-pagevec_lookup_range include/linux/pagevec.h
--- a/include/linux/pagevec.h~mm-remove-nr_pages-argument-from-pagevec_lookup_range
+++ a/include/linux/pagevec.h
@@ -29,13 +29,12 @@ unsigned pagevec_lookup_entries(struct p
 void pagevec_remove_exceptionals(struct pagevec *pvec);
 unsigned pagevec_lookup_range(struct pagevec *pvec,
 			      struct address_space *mapping,
-			      pgoff_t *start, pgoff_t end, unsigned nr_pages);
+			      pgoff_t *start, pgoff_t end);
 static inline unsigned pagevec_lookup(struct pagevec *pvec,
 				      struct address_space *mapping,
-				      pgoff_t *start, unsigned nr_pages)
+				      pgoff_t *start)
 {
-	return pagevec_lookup_range(pvec, mapping, start, (pgoff_t)-1,
-				    nr_pages);
+	return pagevec_lookup_range(pvec, mapping, start, (pgoff_t)-1);
 }
 
 unsigned pagevec_lookup_tag(struct pagevec *pvec,
diff -puN mm/swap.c~mm-remove-nr_pages-argument-from-pagevec_lookup_range mm/swap.c
--- a/mm/swap.c~mm-remove-nr_pages-argument-from-pagevec_lookup_range
+++ a/mm/swap.c
@@ -967,10 +967,9 @@ void pagevec_remove_exceptionals(struct
  * reached.
  */
 unsigned pagevec_lookup_range(struct pagevec *pvec,
-		struct address_space *mapping, pgoff_t *start, pgoff_t end,
-		unsigned nr_pages)
+		struct address_space *mapping, pgoff_t *start, pgoff_t end)
 {
-	pvec->nr = find_get_pages_range(mapping, start, end, nr_pages,
+	pvec->nr = find_get_pages_range(mapping, start, end, PAGEVEC_SIZE,
 					pvec->pages);
 	return pagevec_count(pvec);
 }
_
