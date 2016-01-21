From: akpm@linux-foundation.org
Subject: + dax-add-support-for-fsync-msync-v8-fix-3.patch added to -mm
 tree
Date: Thu, 21 Jan 2016 12:46:04 -0800
Message-ID: <56a1438c.3ol7q0bdH96pJi38%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57425 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbcAUUqF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 15:46:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: fix PMD handling for fsync/msync
has been added to the -mm tree.  Its filename is
     dax-add-support-for-fsync-msync-v8-fix-3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-add-support-for-fsync-msync-v8-fix-3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-add-support-for-fsync-msync-v8-fix-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: dax: fix PMD handling for fsync/msync

Fix the way that DAX PMD radix tree entries are handled.  With this patch
we now check to see if a PMD entry exists in the radix tree on write, even
if we are just trying to insert a PTE.  If it exists, we dirty that
instead of inserting our own PTE entry.

Fix a bug in the PMD path in dax_writeback_mapping_range() where we were
previously passing a loff_t into radix_tree_lookup instead of a pgoff_t.

Account for the fact that multiple fsync/msync operations may be happening
at the same time and don't flush entries that are beyond end_index.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |   39 +++++++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 12 deletions(-)

diff -puN fs/dax.c~dax-add-support-for-fsync-msync-v8-fix-3 fs/dax.c
--- a/fs/dax.c~dax-add-support-for-fsync-msync-v8-fix-3
+++ a/fs/dax.c
@@ -326,19 +326,27 @@ static int copy_user_bh(struct page *to,
 }
 
 #define NO_SECTOR -1
+#define DAX_PMD_INDEX(page_index) (page_index & (PMD_MASK >> PAGE_CACHE_SHIFT))
 
 static int dax_radix_entry(struct address_space *mapping, pgoff_t index,
 		sector_t sector, bool pmd_entry, bool dirty)
 {
 	struct radix_tree_root *page_tree = &mapping->page_tree;
+	pgoff_t pmd_index = DAX_PMD_INDEX(index);
 	int type, error = 0;
 	void *entry;
 
 	__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
 
 	spin_lock_irq(&mapping->tree_lock);
-	entry = radix_tree_lookup(page_tree, index);
 
+	entry = radix_tree_lookup(page_tree, pmd_index);
+	if (RADIX_DAX_TYPE(entry) == RADIX_DAX_PMD) {
+		index = pmd_index;
+		goto dirty;
+	}
+
+	entry = radix_tree_lookup(page_tree, index);
 	if (entry) {
 		type = RADIX_DAX_TYPE(entry);
 		if (WARN_ON_ONCE(type != RADIX_DAX_PTE &&
@@ -459,31 +467,33 @@ int dax_writeback_mapping_range(struct a
 {
 	struct inode *inode = mapping->host;
 	struct block_device *bdev = inode->i_sb->s_bdev;
+	pgoff_t start_index, end_index, pmd_index;
 	pgoff_t indices[PAGEVEC_SIZE];
-	pgoff_t start_page, end_page;
 	struct pagevec pvec;
-	void *entry;
+	bool done = false;
 	int i, ret = 0;
+	void *entry;
 
 	if (WARN_ON_ONCE(inode->i_blkbits != PAGE_SHIFT))
 		return -EIO;
 
+	start_index = start >> PAGE_CACHE_SHIFT;
+	end_index = end >> PAGE_CACHE_SHIFT;
+	pmd_index = DAX_PMD_INDEX(start_index);
+
 	rcu_read_lock();
-	entry = radix_tree_lookup(&mapping->page_tree, start & PMD_MASK);
+	entry = radix_tree_lookup(&mapping->page_tree, pmd_index);
 	rcu_read_unlock();
 
 	/* see if the start of our range is covered by a PMD entry */
-	if (entry && RADIX_DAX_TYPE(entry) == RADIX_DAX_PMD)
-		start &= PMD_MASK;
+	if (RADIX_DAX_TYPE(entry) == RADIX_DAX_PMD)
+		start_index = pmd_index;
 
-	start_page = start >> PAGE_CACHE_SHIFT;
-	end_page = end >> PAGE_CACHE_SHIFT;
-
-	tag_pages_for_writeback(mapping, start_page, end_page);
+	tag_pages_for_writeback(mapping, start_index, end_index);
 
 	pagevec_init(&pvec, 0);
-	while (1) {
-		pvec.nr = find_get_entries_tag(mapping, start_page,
+	while (!done) {
+		pvec.nr = find_get_entries_tag(mapping, start_index,
 				PAGECACHE_TAG_TOWRITE, PAGEVEC_SIZE,
 				pvec.pages, indices);
 
@@ -491,6 +501,11 @@ int dax_writeback_mapping_range(struct a
 			break;
 
 		for (i = 0; i < pvec.nr; i++) {
+			if (indices[i] > end_index) {
+				done = true;
+				break;
+			}
+
 			ret = dax_writeback_one(bdev, mapping, indices[i],
 					pvec.pages[i]);
 			if (ret < 0)
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

dax-fix-null-pointer-dereference-in-__dax_dbg.patch
dax-fix-conversion-of-holes-to-pmds.patch
pmem-add-wb_cache_pmem-to-the-pmem-api.patch
pmem-add-wb_cache_pmem-to-the-pmem-api-v6.patch
dax-support-dirty-dax-entries-in-radix-tree.patch
dax-support-dirty-dax-entries-in-radix-tree-v6.patch
mm-add-find_get_entries_tag.patch
dax-add-support-for-fsync-sync.patch
dax-add-support-for-fsync-sync-v6.patch
dax-add-support-for-fsync-msync-v7.patch
dax-add-support-for-fsync-msync-v8.patch
dax-add-support-for-fsync-msync-v8-fix.patch
dax-add-support-for-fsync-msync-v8-fix-2.patch
dax-add-support-for-fsync-msync-v8-fix-3.patch
dax-add-support-for-fsync-sync-v8-fix-4.patch
ext2-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch
ext4-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch
xfs-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch
dax-never-rely-on-bhb_dev-being-set-by-get_block.patch

