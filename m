From: akpm@linux-foundation.org
Subject: [merged]
 mm-page-migration-fix-pagemlocked-on-migrated-pages.patch removed from -mm
 tree
Date: Fri, 06 Nov 2015 12:16:31 -0800
Message-ID: <563d0a9f.rcsERZQ7t631qOKz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48963 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162138AbbKFUQc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:16:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, cl@linux.com, dave@stgolabs.net, dvyukov@google.com, kirill.shutemov@linux.intel.com, kosaki.motohiro@jp.fujitsu.com, oleg@redhat.com, riel@redhat.com, sasha.levin@oracle.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page migration fix PageMlocked on migrated pages
has been removed from the -mm tree.  Its filename was
     mm-page-migration-fix-pagemlocked-on-migrated-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
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
@@ -271,20 +271,19 @@ extern unsigned int munlock_vma_page(str
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

osd-fs-__r4w_get_page-rely-on-pageuptodate-for-uptodate.patch
mm-use-unsigned-int-for-page-order-fix-2.patch

