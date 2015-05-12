From: akpm@linux-foundation.org
Subject: +
 mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling.patch added to -mm tree
Date: Tue, 12 May 2015 15:00:42 -0700
Message-ID: <5552780a.x9oUlTjwtwZrpXtz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33304 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933812AbbELWAn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 May 2015 18:00:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, andi@firstfloor.org, kirill@shutemov.name, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure: introduce get_hwpoison_page() for consistent refcount handling
has been added to the -mm tree.  Its filename is
     mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/memory-failure: introduce get_hwpoison_page() for consistent refcount handling

memory_failure() can run in 2 different mode (specified by
MF_COUNT_INCREASED) in page refcount perspective.  When
MF_COUNT_INCREASED is set, memory_failure() assumes that the caller
takes a refcount of the target page.  And if cleared, memory_failure()
takes it in it's own.

In current code, however, refcounting is done differently in each caller. 
For example, madvise_hwpoison() uses get_user_pages_fast() and
hwpoison_inject() uses get_page_unless_zero().  So this inconsistent
refcounting causes refcount failure especially for thp tail pages. 
Typical user visible effects are like memory leak or
VM_BUG_ON_PAGE(!page_count(page)) in isolate_lru_page().

To fix this refcounting issue, this patch introduces get_hwpoison_page()
to handle thp tail pages in the same manner for each caller of hwpoison
code.

There's a non-trivial change around unpoisoning, which now returns
immediately for thp with "MCE: Memory failure is now running on %#lx\n"
message.  This is not right when split_huge_page() fails.  So this patch
also allows unpoison_memory() to handle thp.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h   |    1 
 mm/hwpoison-inject.c |    4 +--
 mm/memory-failure.c  |   50 ++++++++++++++++++++++++++---------------
 mm/swap.c            |    2 -
 4 files changed, 35 insertions(+), 22 deletions(-)

diff -puN include/linux/mm.h~mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling include/linux/mm.h
--- a/include/linux/mm.h~mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling
+++ a/include/linux/mm.h
@@ -2150,6 +2150,7 @@ enum mf_flags {
 extern int memory_failure(unsigned long pfn, int trapno, int flags);
 extern void memory_failure_queue(unsigned long pfn, int trapno, int flags);
 extern int unpoison_memory(unsigned long pfn);
+extern int get_hwpoison_page(struct page *page);
 extern int sysctl_memory_failure_early_kill;
 extern int sysctl_memory_failure_recovery;
 extern void shake_page(struct page *p, int access);
diff -puN mm/hwpoison-inject.c~mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling mm/hwpoison-inject.c
--- a/mm/hwpoison-inject.c~mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling
+++ a/mm/hwpoison-inject.c
@@ -28,7 +28,7 @@ static int hwpoison_inject(void *data, u
 	/*
 	 * This implies unable to support free buddy pages.
 	 */
-	if (!get_page_unless_zero(hpage))
+	if (!get_hwpoison_page(p))
 		return 0;
 
 	if (!hwpoison_filter_enable)
@@ -58,7 +58,7 @@ inject:
 	pr_info("Injecting memory failure at pfn %#lx\n", pfn);
 	return memory_failure(pfn, 18, MF_COUNT_INCREASED);
 put_out:
-	put_page(hpage);
+	put_page(p);
 	return 0;
 }
 
diff -puN mm/memory-failure.c~mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling
+++ a/mm/memory-failure.c
@@ -886,6 +886,28 @@ static int page_action(struct page_state
 }
 
 /*
+ * Get refcount for memory error handling:
+ * - @page: raw page
+ */
+inline int get_hwpoison_page(struct page *page)
+{
+	struct page *head = compound_head(page);
+
+	if (PageHuge(head))
+		return get_page_unless_zero(head);
+	else if (PageTransHuge(head))
+		if (get_page_unless_zero(head)) {
+			if (PageTail(page))
+				get_page(page);
+			return 1;
+		} else {
+			return 0;
+		}
+	else
+		return get_page_unless_zero(page);
+}
+
+/*
  * Do all that is necessary to remove user space mappings. Unmap
  * the pages and send SIGBUS to the processes if the data was dirty.
  */
@@ -1067,8 +1089,7 @@ int memory_failure(unsigned long pfn, in
 	 * In fact it's dangerous to directly bump up page count from 0,
 	 * that may make page_freeze_refs()/page_unfreeze_refs() mismatch.
 	 */
-	if (!(flags & MF_COUNT_INCREASED) &&
-		!get_page_unless_zero(hpage)) {
+	if (!(flags & MF_COUNT_INCREASED) && !get_hwpoison_page(p)) {
 		if (is_free_buddy_page(p)) {
 			action_result(pfn, MF_MSG_BUDDY, MF_DELAYED);
 			return 0;
@@ -1376,19 +1397,12 @@ int unpoison_memory(unsigned long pfn)
 		return 0;
 	}
 
-	/*
-	 * unpoison_memory() can encounter thp only when the thp is being
-	 * worked by memory_failure() and the page lock is not held yet.
-	 * In such case, we yield to memory_failure() and make unpoison fail.
-	 */
-	if (!PageHuge(page) && PageTransHuge(page)) {
-		pr_info("MCE: Memory failure is now running on %#lx\n", pfn);
-			return 0;
-	}
-
-	nr_pages = 1 << compound_order(page);
+	if (PageHuge(page))
+		nr_pages = 1 << compound_order(page);
+	else
+		nr_pages = 1;
 
-	if (!get_page_unless_zero(page)) {
+	if (!get_hwpoison_page(p)) {
 		/*
 		 * Since HWPoisoned hugepage should have non-zero refcount,
 		 * race between memory failure and unpoison seems to happen.
@@ -1412,7 +1426,7 @@ int unpoison_memory(unsigned long pfn)
 	 * the PG_hwpoison page will be caught and isolated on the entrance to
 	 * the free buddy page pool.
 	 */
-	if (TestClearPageHWPoison(page)) {
+	if (TestClearPageHWPoison(p)) {
 		pr_info("MCE: Software-unpoisoned page %#lx\n", pfn);
 		atomic_long_sub(nr_pages, &num_poisoned_pages);
 		freeit = 1;
@@ -1421,9 +1435,9 @@ int unpoison_memory(unsigned long pfn)
 	}
 	unlock_page(page);
 
-	put_page(page);
+	put_page(p);
 	if (freeit && !(pfn == my_zero_pfn(0) && page_count(p) == 1))
-		put_page(page);
+		put_page(p);
 
 	return 0;
 }
@@ -1456,7 +1470,7 @@ static int __get_any_page(struct page *p
 	 * When the target page is a free hugepage, just remove it
 	 * from free hugepage list.
 	 */
-	if (!get_page_unless_zero(compound_head(p))) {
+	if (!get_hwpoison_page(p)) {
 		if (PageHuge(p)) {
 			pr_info("%s: %#lx free huge page\n", __func__, pfn);
 			ret = 0;
diff -puN mm/swap.c~mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling mm/swap.c
--- a/mm/swap.c~mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling
+++ a/mm/swap.c
@@ -209,8 +209,6 @@ out_put_single:
 		 */
 		if (put_page_testzero(page_head))
 			VM_BUG_ON_PAGE(1, page_head);
-		/* __split_huge_page_refcount will wait now */
-		VM_BUG_ON_PAGE(page_mapcount(page) <= 0, page);
 		atomic_dec(&page->_mapcount);
 		VM_BUG_ON_PAGE(atomic_read(&page_head->_count) <= 0, page_head);
 		VM_BUG_ON_PAGE(atomic_read(&page->_count) != 0, page);
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

tools-vm-fix-page-flags-build.patch
mm-hwpoison-add-comment-describing-when-to-add-new-cases.patch
mm-hwpoison-remove-obsolete-notebook-todo-list.patch
memory-failure-export-page_type-and-action-result.patch
memory-failure-change-type-of-action_results-param-3-to-enum.patch
tracing-add-trace-event-for-memory-failure.patch
mm-memory-failure-split-thp-earlier-in-memory-error-handling.patch
mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling.patch
mm-soft-offline-dont-free-target-page-in-successful-page-migration.patch
mm-memory-failure-me_huge_page-does-nothing-for-thp.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

