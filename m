From: akpm@linux-foundation.org
Subject: + mm-simplify-page-migrations-anon_vma-comment-and-flow.patch
 added to -mm tree
Date: Mon, 19 Oct 2015 15:03:36 -0700
Message-ID: <562568b8.pzPrdvfREtZMed19%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46651 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177AbbJSWDh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Oct 2015 18:03:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, andreyknvl@google.com, cl@linux.com, dave@stgolabs.net, dvyukov@google.com, kirill.shutemov@linux.intel.com, kosaki.motohiro@jp.fujitsu.com, oleg@redhat.com, riel@redhat.com, sasha.levin@oracle.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: simplify page migration's anon_vma comment and flow
has been added to the -mm tree.  Its filename is
     mm-simplify-page-migrations-anon_vma-comment-and-flow.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-simplify-page-migrations-anon_vma-comment-and-flow.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-simplify-page-migrations-anon_vma-comment-and-flow.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Andrey Konovalov <andreyknvl@google.com>
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

memcg-simplify-and-inline-__mem_cgroup_from_kmem-fix-2.patch
mm-documentation-undoc-non-linear-vmas.patch
mm-rmap-use-pte-lock-not-mmap_sem-to-set-pagemlocked.patch
mm-page-migration-fix-pagemlocked-on-migrated-pages.patch
mm-rename-mem_cgroup_migrate-to-mem_cgroup_replace_page.patch
mm-correct-a-couple-of-page-migration-comments.patch
mm-page-migration-use-the-put_new_page-whenever-necessary.patch
mm-page-migration-trylock-newpage-at-same-level-as-oldpage.patch
mm-page-migration-remove_migration_ptes-at-lockunlock-level.patch
mm-simplify-page-migrations-anon_vma-comment-and-flow.patch
mm-page-migration-use-migration-entry-for-swapcache-too.patch
mm-page-migration-avoid-touching-newpage-until-no-going-back.patch
mm-migrate-dirty-page-without-clear_page_dirty_for_io-etc.patch
mm-use-unsigned-int-for-page-order-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-4.patch

