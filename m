From: akpm@linux-foundation.org
Subject: + thp-update-futex-compound-knowledge.patch added to -mm tree
Date: Wed, 15 Dec 2010 15:56:17 -0800
Message-ID: <201012152356.oBFNuH6c013483@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45657 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755879Ab0LPACY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Dec 2010 19:02:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, mel@csn.ul.ie, riel@redhat.com


The patch titled
     thp: update futex compound knowledge
has been added to the -mm tree.  Its filename is
     thp-update-futex-compound-knowledge.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: update futex compound knowledge
From: Andrea Arcangeli <aarcange@redhat.com>

Futex code is smarter than most other gup_fast O_DIRECT code and knows
about the compound internals.  However now doing a put_page(head_page)
will not release the pin on the tail page taken by gup-fast, leading to
all sort of refcounting bugchecks.  Getting a stable head_page is a little
tricky.

page_head = page is there because if this is not a tail page it's also the
page_head.  Only in case this is a tail page, compound_head is called,
otherwise it's guaranteed unnecessary.  And if it's a tail page
compound_head has to run atomically inside irq disabled section
__get_user_pages_fast before returning.  Otherwise ->first_page won't be a
stable pointer.

Disableing irq before __get_user_page_fast and releasing irq after running
compound_head is needed because if __get_user_page_fast returns == 1, it
means the huge pmd is established and cannot go away from under us. 
pmdp_splitting_flush_notify in __split_huge_page_splitting will have to
wait for local_irq_enable before the IPI delivery can return.  This means
__split_huge_page_refcount can't be running from under us, and in turn
when we run compound_head(page) we're not reading a dangling pointer from
tailpage->first_page.  Then after we get to stable head page, we are
always safe to call compound_lock and after taking the compound lock on
head page we can finally re-check if the page returned by gup-fast is
still a tail page.  in which case we're set and we didn't need to split
the hugepage in order to take a futex on it.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/futex.c |   55 ++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 45 insertions(+), 10 deletions(-)

diff -puN kernel/futex.c~thp-update-futex-compound-knowledge kernel/futex.c
--- a/kernel/futex.c~thp-update-futex-compound-knowledge
+++ a/kernel/futex.c
@@ -233,7 +233,7 @@ get_futex_key(u32 __user *uaddr, int fsh
 {
 	unsigned long address = (unsigned long)uaddr;
 	struct mm_struct *mm = current->mm;
-	struct page *page;
+	struct page *page, *page_head;
 	int err;
 
 	/*
@@ -265,11 +265,46 @@ again:
 	if (err < 0)
 		return err;
 
-	page = compound_head(page);
-	lock_page(page);
-	if (!page->mapping) {
-		unlock_page(page);
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	page_head = page;
+	if (unlikely(PageTail(page))) {
 		put_page(page);
+		/* serialize against __split_huge_page_splitting() */
+		local_irq_disable();
+		if (likely(__get_user_pages_fast(address, 1, 1, &page) == 1)) {
+			page_head = compound_head(page);
+			/*
+			 * page_head is valid pointer but we must pin
+			 * it before taking the PG_lock and/or
+			 * PG_compound_lock. The moment we re-enable
+			 * irqs __split_huge_page_splitting() can
+			 * return and the head page can be freed from
+			 * under us. We can't take the PG_lock and/or
+			 * PG_compound_lock on a page that could be
+			 * freed from under us.
+			 */
+			if (page != page_head) {
+				get_page(page_head);
+				put_page(page);
+			}
+			local_irq_enable();
+		} else {
+			local_irq_enable();
+			goto again;
+		}
+	}
+#else
+	page_head = compound_head(page);
+	if (page != page_head) {
+		get_page(page_head);
+		put_page(page);
+	}
+#endif
+
+	lock_page(page_head);
+	if (!page_head->mapping) {
+		unlock_page(page_head);
+		put_page(page_head);
 		goto again;
 	}
 
@@ -280,20 +315,20 @@ again:
 	 * it's a read-only handle, it's expected that futexes attach to
 	 * the object not the particular process.
 	 */
-	if (PageAnon(page)) {
+	if (PageAnon(page_head)) {
 		key->both.offset |= FUT_OFF_MMSHARED; /* ref taken on mm */
 		key->private.mm = mm;
 		key->private.address = address;
 	} else {
 		key->both.offset |= FUT_OFF_INODE; /* inode-based key */
-		key->shared.inode = page->mapping->host;
-		key->shared.pgoff = page->index;
+		key->shared.inode = page_head->mapping->host;
+		key->shared.pgoff = page_head->index;
 	}
 
 	get_futex_key_refs(key);
 
-	unlock_page(page);
-	put_page(page);
+	unlock_page(page_head);
+	put_page(page_head);
 	return 0;
 }
 
_

Patches currently in -mm which might be from aarcange@redhat.com are

mm-compaction-add-trace-events-for-memory-compaction-activity.patch
mm-vmscan-convert-lumpy_mode-into-a-bitmask.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path-fix.patch
mm-migration-cleanup-migrate_pages-api-by-matching-types-for-offlining-and-sync.patch
mm-compaction-perform-a-faster-migration-scan-when-migrating-asynchronously.patch
mm-vmscan-rename-lumpy_mode-to-reclaim_mode.patch
mm-vmscan-rename-lumpy_mode-to-reclaim_mode-fix.patch
thp-ksm-free-swap-when-swapcache-page-is-replaced.patch
thp-fix-bad_page-to-show-the-real-reason-the-page-is-bad.patch
thp-transparent-hugepage-support-documentation.patch
thp-mm-define-madv_hugepage.patch
thp-compound_lock.patch
thp-alter-compound-get_page-put_page.patch
thp-put_page-recheck-pagehead-after-releasing-the-compound_lock.patch
thp-update-futex-compound-knowledge.patch
thp-clear-compound-mapping.patch
thp-add-native_set_pmd_at.patch
thp-add-pmd-paravirt-ops.patch
thp-no-paravirt-version-of-pmd-ops.patch
thp-export-maybe_mkwrite.patch
thp-comment-reminder-in-destroy_compound_page.patch
thp-config_transparent_hugepage.patch
thp-special-pmd_trans_-functions.patch
thp-add-pmd-mangling-generic-functions.patch
thp-add-pmd-mangling-functions-to-x86.patch
thp-bail-out-gup_fast-on-splitting-pmd.patch
thp-pte-alloc-trans-splitting.patch
thp-add-pmd-mmu_notifier-helpers.patch
thp-clear-page-compound.patch
thp-add-pmd_huge_pte-to-mm_struct.patch
thp-split_huge_page_mm-vma.patch
thp-split_huge_page-paging.patch
thp-clear_copy_huge_page.patch
thp-_gfp_no_kswapd.patch
thp-dont-alloc-harder-for-gfp-nomemalloc-even-if-nowait.patch
thp-transparent-hugepage-core.patch
thp-split_huge_page-anon_vma-ordering-dependency.patch
thp-verify-pmd_trans_huge-isnt-leaking.patch
thp-madvisemadv_hugepage.patch
thp-add-pagetranscompound.patch
thp-pmd_trans_huge-migrate-bugcheck.patch
thp-memcg-compound.patch
thp-transhuge-memcg-commit-tail-pages-at-charge.patch
thp-memcg-huge-memory.patch
thp-transparent-hugepage-vmstat.patch
thp-khugepaged.patch
thp-khugepaged-vma-merge.patch
thp-skip-transhuge-pages-in-ksm-for-now.patch
thp-remove-pg_buddy.patch
thp-add-x86-32bit-support.patch
thp-mincore-transparent-hugepage-support.patch
thp-add-pmd_modify.patch
thp-mprotect-pass-vma-down-to-page-table-walkers.patch
thp-mprotect-transparent-huge-page-support.patch
thp-set-recommended-min-free-kbytes.patch
thp-enable-direct-defrag.patch
thp-add-numa-awareness-to-hugepage-allocations.patch
thp-allocate-memory-in-khugepaged-outside-of-mmap_sem-write-mode.patch
thp-transparent-hugepage-config-choice.patch
thp-select-config_compaction-if-transparent_hugepage-enabled.patch
thp-transhuge-isolate_migratepages.patch
thp-avoid-breaking-huge-pmd-invariants-in-case-of-vma_adjust-failures.patch
thp-dont-allow-transparent-hugepage-support-without-pse.patch
thp-mmu_notifier_test_young.patch
thp-freeze-khugepaged-and-ksmd.patch
thp-use-compaction-in-kswapd-for-gfp_atomic-order-0.patch
thp-use-compaction-for-all-allocation-orders.patch
thp-disable-transparent-hugepages-by-default-on-small-systems.patch
thp-fix-anon-memory-statistics-with-transparent-hugepages.patch
thp-scale-nr_rotated-to-balance-memory-pressure.patch
thp-transparent-hugepage-sysfs-meminfo.patch
thp-add-debug-checks-for-mapcount-related-invariants.patch
thp-fix-memory-failure-hugetlbfs-vs-thp-collision.patch
thp-compound_trans_order.patch
thp-mm-define-madv_nohugepage.patch
thp-madvisemadv_nohugepage.patch

