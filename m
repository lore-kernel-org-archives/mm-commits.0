From: akpm@linux-foundation.org
Subject: [folded-merged] dax-add-support-for-fsync-msync-v8.patch removed
 from -mm tree
Date: Fri, 22 Jan 2016 14:57:58 -0800
Message-ID: <56a2b3f6.AMPB3gCLclmwgZfJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56972 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876AbcAVW57 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Jan 2016 17:57:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, dan.j.williams@intel.com, jack@suse.com, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax-add-support-for-fsync-msync-v8
has been removed from the -mm tree.  Its filename was
     dax-add-support-for-fsync-msync-v8.patch

This patch was dropped because it was folded into dax-add-support-for-fsync-sync.patch

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: dax-add-support-for-fsync-msync-v8

2) Add a check to dax_radix_entry() so that we WARN_ON_ONCE() and exit
gracefully if we find a page cache entry still in the radix tree when
trying to insert a DAX entry.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN fs/dax.c~dax-add-support-for-fsync-msync-v8 fs/dax.c
--- a/fs/dax.c~dax-add-support-for-fsync-msync-v8
+++ a/fs/dax.c
@@ -331,7 +331,7 @@ static int dax_radix_entry(struct addres
 		sector_t sector, bool pmd_entry, bool dirty)
 {
 	struct radix_tree_root *page_tree = &mapping->page_tree;
-	int error = 0;
+	int type, error = 0;
 	void *entry;
 
 	__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
@@ -340,7 +340,14 @@ static int dax_radix_entry(struct addres
 	entry = radix_tree_lookup(page_tree, index);
 
 	if (entry) {
-		if (!pmd_entry || RADIX_DAX_TYPE(entry) == RADIX_DAX_PMD)
+		type = RADIX_DAX_TYPE(entry);
+		if (WARN_ON_ONCE(type != RADIX_DAX_PTE &&
+					type != RADIX_DAX_PMD)) {
+			error = -EIO;
+			goto unlock;
+		}
+
+		if (!pmd_entry || type == RADIX_DAX_PMD)
 			goto dirty;
 		radix_tree_delete(&mapping->page_tree, index);
 		mapping->nrexceptional--;
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

dax-fix-null-pointer-dereference-in-__dax_dbg.patch
dax-fix-conversion-of-holes-to-pmds.patch
pmem-add-wb_cache_pmem-to-the-pmem-api.patch
dax-support-dirty-dax-entries-in-radix-tree.patch
mm-add-find_get_entries_tag.patch
dax-add-support-for-fsync-sync.patch
dax-add-support-for-fsync-msync-v8-fix.patch
dax-add-support-for-fsync-msync-v8-fix-2-v2.patch
dax-add-support-for-fsync-msync-v8-fix-3-v2.patch
dax-add-support-for-fsync-sync-v8-fix-4.patch
ext2-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch
ext4-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch
xfs-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch
dax-never-rely-on-bhb_dev-being-set-by-get_block.patch

