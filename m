From: akpm@linux-foundation.org
Subject: + mm-page-migration-fix-pagemlocked-on-migrated-pages.patch added to -mm tree
Date: Mon, 19 Oct 2015 15:03:24 -0700
Message-ID: <562568ac.fe6Yna8jUZkewMHG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46601 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443AbbJSWDZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Oct 2015 18:03:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, andreyknvl@google.com, cl@linux.com, dave@stgolabs.net, dvyukov@google.com, kirill.shutemov@linux.intel.com, kosaki.motohiro@jp.fujitsu.com, oleg@redhat.com, riel@redhat.com, sasha.levin@oracle.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page migration fix PageMlocked on migrated pages
has been added to the -mm tree.  Its filename is
     mm-page-migration-fix-pagemlocked-on-migrated-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page-migration-fix-pagemlocked-on-migrated-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page-migration-fix-pagemlocked-on-migrated-pages.patch

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
Subject: mm: page migration fix PageMlocked on migrated pages

Commit e6c509f85455 ("mm: use clear_page_mlock() in page_remove_rmap()")
in v3.7 inadvertently made mlock_migrate_page() impotent: page migration
unmaps the page from userspace before migrating, and that commit clears
PageMlocked on the final unmap, leaving mlock_migrate_page() with nothing
to do.  Not a serious bug, the next attempt at reclaiming the page would
fix it up; but a betrayal of page migration's intent - the new page ought
to emerge as PageMlocked.

I don't see how to fix it for mlock_migrate_page() itself; but easily
fixed in remove_migration_pte(), by calling mlock_vma_page() when the vma
is VM_LOCKED - under pte lock as in try_to_unmap_one().

Delete mlock_migrate_page()?  Not quite, it does still serve a purpose for
migrate_misplaced_transhuge_page(): where we could replace it by a test,
clear_page_mlock(), mlock_vma_page() sequence; but would that be an
improvement?  mlock_migrate_page() is fairly lean, and let's make it
leaner by skipping the irq save/restore now clearly not needed.

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

 mm/internal.h |    9 ++++-----
 mm/migrate.c  |    6 ++++--
 2 files changed, 8 insertions(+), 7 deletions(-)

diff -puN mm/internal.h~mm-page-migration-fix-pagemlocked-on-migrated-pages mm/internal.h
--- a/mm/internal.h~mm-page-migration-fix-pagemlocked-on-migrated-pages
+++ a/mm/internal.h
@@ -295,20 +295,19 @@ extern unsigned int munlock_vma_page(str
 extern void clear_page_mlock(struct page *page);
 
 /*
- * mlock_migrate_page - called only from migrate_page_copy() to
- * migrate the Mlocked page flag; update statistics.
+ * mlock_migrate_page - called only from migrate_misplaced_transhuge_page()
+ * (because that does not go through the full procedure of migration ptes):
+ * to migrate the Mlocked page flag; update statistics.
  */
 static inline void mlock_migrate_page(struct page *newpage, struct page *page)
 {
 	if (TestClearPageMlocked(page)) {
-		unsigned long flags;
 		int nr_pages = hpage_nr_pages(page);
 
-		local_irq_save(flags);
+		/* Holding pmd lock, no change in irq context: __mod is safe */
 		__mod_zone_page_state(page_zone(page), NR_MLOCK, -nr_pages);
 		SetPageMlocked(newpage);
 		__mod_zone_page_state(page_zone(newpage), NR_MLOCK, nr_pages);
-		local_irq_restore(flags);
 	}
 }
 
diff -puN mm/migrate.c~mm-page-migration-fix-pagemlocked-on-migrated-pages mm/migrate.c
--- a/mm/migrate.c~mm-page-migration-fix-pagemlocked-on-migrated-pages
+++ a/mm/migrate.c
@@ -171,6 +171,9 @@ static int remove_migration_pte(struct p
 	else
 		page_add_file_rmap(new);
 
+	if (vma->vm_flags & VM_LOCKED)
+		mlock_vma_page(new);
+
 	/* No need to invalidate - it was non-present before */
 	update_mmu_cache(vma, addr, ptep);
 unlock:
@@ -537,7 +540,6 @@ void migrate_page_copy(struct page *newp
 	cpupid = page_cpupid_xchg_last(page, -1);
 	page_cpupid_xchg_last(newpage, cpupid);
 
-	mlock_migrate_page(newpage, page);
 	ksm_migrate_page(newpage, page);
 	/*
 	 * Please do not reorder this without considering how mm/ksm.c's
@@ -1787,7 +1789,6 @@ fail_putback:
 			SetPageActive(page);
 		if (TestClearPageUnevictable(new_page))
 			SetPageUnevictable(page);
-		mlock_migrate_page(page, new_page);
 
 		unlock_page(new_page);
 		put_page(new_page);		/* Free it */
@@ -1829,6 +1830,7 @@ fail_putback:
 		goto fail_putback;
 	}
 
+	mlock_migrate_page(new_page, page);
 	mem_cgroup_migrate(page, new_page, false);
 
 	page_remove_rmap(page);
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

