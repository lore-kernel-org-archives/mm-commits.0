From: akpm@linux-foundation.org
Subject: [merged]
 mm-simplify-page-migrations-anon_vma-comment-and-flow.patch removed from
 -mm tree
Date: Fri, 06 Nov 2015 12:16:49 -0800
Message-ID: <563d0ab1.sAt/0iAwvsxcjRdI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49014 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032012AbbKFUQu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:16:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, cl@linux.com, dave@stgolabs.net, dvyukov@google.com, kirill.shutemov@linux.intel.com, kosaki.motohiro@jp.fujitsu.com, oleg@redhat.com, riel@redhat.com, sasha.levin@oracle.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: simplify page migration's anon_vma comment and flow
has been removed from the -mm tree.  Its filename was
     mm-simplify-page-migrations-anon_vma-comment-and-flow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: simplify page migration's anon_vma comment and flow

__unmap_and_move() contains a long stale comment on page_get_anon_vma()
and PageSwapCache(), with an odd control flow that's hard to follow. 
Mostly this reflects our confusion about the lifetime of an anon_vma, in
the early days of page migration, before we could take a reference to one.
 Nowadays this seems quite straightforward: cut it all down to essentials.

I cannot see the relevance of swapcache here at all, so don't treat it any
differently: I believe the old comment reflects in part our anon_vma
confusions, and in part the original v2.6.16 page migration technique,
which used actual swap to migrate anon instead of swap-like migration
entries.  Why should a swapcache page not be migrated with the aid of
migration entry ptes like everything else?  So lose that comment now, and
enable migration entries for swapcache in the next patch.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   36 ++++++++++--------------------------
 1 file changed, 10 insertions(+), 26 deletions(-)

diff -puN mm/migrate.c~mm-simplify-page-migrations-anon_vma-comment-and-flow mm/migrate.c
--- a/mm/migrate.c~mm-simplify-page-migrations-anon_vma-comment-and-flow
+++ a/mm/migrate.c
@@ -819,6 +819,7 @@ static int __unmap_and_move(struct page
 			goto out_unlock;
 		wait_on_page_writeback(page);
 	}
+
 	/*
 	 * By try_to_unmap(), page->mapcount goes down to 0 here. In this case,
 	 * we cannot notice that anon_vma is freed while we migrates a page.
@@ -826,34 +827,15 @@ static int __unmap_and_move(struct page
 	 * of migration. File cache pages are no problem because of page_lock()
 	 * File Caches may use write_page() or lock_page() in migration, then,
 	 * just care Anon page here.
+	 *
+	 * Only page_get_anon_vma() understands the subtleties of
+	 * getting a hold on an anon_vma from outside one of its mms.
+	 * But if we cannot get anon_vma, then we won't need it anyway,
+	 * because that implies that the anon page is no longer mapped
+	 * (and cannot be remapped so long as we hold the page lock).
 	 */
-	if (PageAnon(page) && !PageKsm(page)) {
-		/*
-		 * Only page_lock_anon_vma_read() understands the subtleties of
-		 * getting a hold on an anon_vma from outside one of its mms.
-		 */
+	if (PageAnon(page) && !PageKsm(page))
 		anon_vma = page_get_anon_vma(page);
-		if (anon_vma) {
-			/*
-			 * Anon page
-			 */
-		} else if (PageSwapCache(page)) {
-			/*
-			 * We cannot be sure that the anon_vma of an unmapped
-			 * swapcache page is safe to use because we don't
-			 * know in advance if the VMA that this page belonged
-			 * to still exists. If the VMA and others sharing the
-			 * data have been freed, then the anon_vma could
-			 * already be invalid.
-			 *
-			 * To avoid this possibility, swapcache pages get
-			 * migrated but are not remapped when migration
-			 * completes
-			 */
-		} else {
-			goto out_unlock;
-		}
-	}
 
 	/*
 	 * Block others from accessing the new page when we get around to
@@ -898,6 +880,8 @@ static int __unmap_and_move(struct page
 		}
 	} else if (page_mapped(page)) {
 		/* Establish migration ptes */
+		VM_BUG_ON_PAGE(PageAnon(page) && !PageKsm(page) && !anon_vma,
+				page);
 		try_to_unmap(page,
 			TTU_MIGRATION|TTU_IGNORE_MLOCK|TTU_IGNORE_ACCESS);
 		page_was_mapped = 1;
_

Patches currently in -mm which might be from hughd@google.com are

osd-fs-__r4w_get_page-rely-on-pageuptodate-for-uptodate.patch
mm-use-unsigned-int-for-page-order-fix-2.patch

