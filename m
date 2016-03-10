From: akpm@linux-foundation.org
Subject: [merged]
 mm-thp-fix-migration-of-pte-mapped-transparent-huge-pages.patch removed
 from -mm tree
Date: Thu, 10 Mar 2016 10:58:14 -0800
Message-ID: <56e1c3c6.KISvHvyYShmwVZd1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51849 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbcCJS6P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Mar 2016 13:58:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, thp: fix migration of PTE-mapped transparent huge pages
has been removed from the -mm tree.  Its filename was
     mm-thp-fix-migration-of-pte-mapped-transparent-huge-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm, thp: fix migration of PTE-mapped transparent huge pages

We don't have native support of THP migration, so we have to split huge
page into small pages in order to migrate it to different node.  This
includes PTE-mapped huge pages.

I made mistake in refcounting patchset: we don't actually split PTE-mapped
huge page in queue_pages_pte_range(), if we step on head page.

The result is that the head page is queued for migration, but none of tail
pages: putting head page on queue takes pin on the page and any subsequent
attempts of split_huge_pages() would fail and we skip queuing tail pages.

unmap_and_move_huge_page() will eventually split the huge pages, but only
one of 512 pages would get migrated.

Let's fix the situation.

Fixes: 248db92da13f2507 ("migrate_pages: try to split pages on queuing")
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mempolicy.c~mm-thp-fix-migration-of-pte-mapped-transparent-huge-pages mm/mempolicy.c
--- a/mm/mempolicy.c~mm-thp-fix-migration-of-pte-mapped-transparent-huge-pages
+++ a/mm/mempolicy.c
@@ -532,7 +532,7 @@ retry:
 		nid = page_to_nid(page);
 		if (node_isset(nid, *qp->nmask) == !!(flags & MPOL_MF_INVERT))
 			continue;
-		if (PageTail(page) && PageAnon(page)) {
+		if (PageTransCompound(page) && PageAnon(page)) {
 			get_page(page);
 			pte_unmap_unlock(pte, ptl);
 			lock_page(page);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

thp-cleanup-split_huge_page.patch
thp-vmstats-count-deferred-split-events.patch
mm-tracing-refresh-__def_vmaflag_names.patch
mm-cleanup-pte_alloc-interfaces.patch
rmap-introduce-rmap_walk_locked.patch
rmap-extend-try_to_unmap-to-be-usable-by-split_huge_page.patch
mm-make-remove_migration_ptes-beyond-mm-migrationc.patch
thp-rewrite-freeze_page-unfreeze_page-with-generic-rmap-walkers.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

