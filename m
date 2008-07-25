From: akpm@linux-foundation.org
Subject: - mm-speculative-page-references-hugh-fix3.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:55:37 -0700
Message-ID: <200807252355.m6PNtbcC006093@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40056 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752866AbYGYXzj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:55:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nickpiggin@yahoo.com.au, cl@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     mm-speculative-page-references-hugh-fix3
has been removed from the -mm tree.  Its filename was
     mm-speculative-page-references-hugh-fix3.patch

This patch was dropped because it was folded into mm-speculative-page-references.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-speculative-page-references-hugh-fix3
From: Nick Piggin <nickpiggin@yahoo.com.au>

Fix the VM_BUG_ON assertion check to actually do what I want, noted by
Christoph.

Also, fix an error-path-leak type issue with frozen refcount not being
unfrozen.  Found by review.  In practice, this check is very rare to
hit because a page dirtier is likely to hold the refcount elevated for
much longer than it takes to check and non-racy-recheck.  So it doesn't
pose a big problem for users of -mm, but of course needs fixing.

Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    2 +-
 mm/vmscan.c             |    4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN include/linux/pagemap.h~mm-speculative-page-references-hugh-fix3 include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-speculative-page-references-hugh-fix3
+++ a/include/linux/pagemap.h
@@ -138,7 +138,7 @@ static inline int page_cache_get_specula
 		return 0;
 	}
 #endif
-	VM_BUG_ON(PageCompound(page) && (struct page *)page_private(page) != page);
+	VM_BUG_ON(PageTail(page));
 
 	return 1;
 }
diff -puN mm/vmscan.c~mm-speculative-page-references-hugh-fix3 mm/vmscan.c
--- a/mm/vmscan.c~mm-speculative-page-references-hugh-fix3
+++ a/mm/vmscan.c
@@ -428,8 +428,10 @@ static int __remove_mapping(struct addre
 	if (!page_freeze_refs(page, 2))
 		goto cannot_free;
 	/* note: atomic_cmpxchg in page_freeze_refs provides the smp_rmb */
-	if (unlikely(PageDirty(page)))
+	if (unlikely(PageDirty(page))) {
+		page_unfreeze_refs(page, 2);
 		goto cannot_free;
+	}
 
 	if (PageSwapCache(page)) {
 		swp_entry_t swap = { .val = page_private(page) };
_

Patches currently in -mm which might be from nickpiggin@yahoo.com.au are

origin.patch
mm-speculative-page-references.patch
mm-speculative-page-references-hugh-fix3.patch
mm-speculative-page-references-fix-migration_entry_wait-for-speculative-page-cache.patch
ramfs-and-ram-disk-pages-are-unevictable-undo-the-brdc-part.patch
mlock-mlocked-pages-are-unevictable-restore-patch-failure-hunk-of-mlock-mlocked-pages-are-unevictablepatch.patch
slb-drop-kmem-cache-argument-from-constructor.patch
slb-drop-kmem-cache-argument-from-constructor-fix.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix-logfs.patch
slb-drop-kmem-cache-argument-from-constructor-ubifs.patch
powerpc-hugetlb-pgtable-cache-access-cleanup.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch

