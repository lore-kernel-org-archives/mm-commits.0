From: akpm@linux-foundation.org
Subject: [merged]
 mm-memory-failure-split-thp-earlier-in-memory-error-handling.patch removed
 from -mm tree
Date: Mon, 29 Jun 2015 13:37:54 -0700
Message-ID: <5591aca2.4QcHznqFspBGbCjz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50338 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073AbbF2Uhz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:37:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, andi@firstfloor.org, kirill@shutemov.name, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure: split thp earlier in memory error handling
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-split-thp-earlier-in-memory-error-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/memory-failure: split thp earlier in memory error handling

memory_failure() doesn't handle thp itself at this time and need to split
it before doing isolation.  Currently thp is split in the middle of
hwpoison_user_mappings(), but there're corner cases where memory_failure()
wrongly tries to handle thp without splitting.

1) "non anonymous" thp, which is not a normal operating mode of thp,
   but a memory error could hit a thp before anon_vma is initialized.  In
   such case, split_huge_page() fails and me_huge_page() (intended for
   hugetlb) is called for thp, which triggers BUG_ON in page_hstate().

2) !PageLRU case, where hwpoison_user_mappings() returns with
   SWAP_SUCCESS and the result is the same as case 1.

memory_failure() can't avoid splitting, so let's split it more earlier,
which also reduces code which are prepared for both of normal page and
thp.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   88 +++++++++++-------------------------------
 1 file changed, 25 insertions(+), 63 deletions(-)

diff -puN mm/memory-failure.c~mm-memory-failure-split-thp-earlier-in-memory-error-handling mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory-failure-split-thp-earlier-in-memory-error-handling
+++ a/mm/memory-failure.c
@@ -928,7 +928,6 @@ static int hwpoison_user_mappings(struct
 	int ret;
 	int kill = 1, forcekill;
 	struct page *hpage = *hpagep;
-	struct page *ppage;
 
 	/*
 	 * Here we are interested only in user-mapped pages, so skip any
@@ -978,59 +977,6 @@ static int hwpoison_user_mappings(struct
 	}
 
 	/*
-	 * ppage: poisoned page
-	 *   if p is regular page(4k page)
-	 *        ppage == real poisoned page;
-	 *   else p is hugetlb or THP, ppage == head page.
-	 */
-	ppage = hpage;
-
-	if (PageTransHuge(hpage)) {
-		/*
-		 * Verify that this isn't a hugetlbfs head page, the check for
-		 * PageAnon is just for avoid tripping a split_huge_page
-		 * internal debug check, as split_huge_page refuses to deal with
-		 * anything that isn't an anon page. PageAnon can't go away fro
-		 * under us because we hold a refcount on the hpage, without a
-		 * refcount on the hpage. split_huge_page can't be safely called
-		 * in the first place, having a refcount on the tail isn't
-		 * enough * to be safe.
-		 */
-		if (!PageHuge(hpage) && PageAnon(hpage)) {
-			if (unlikely(split_huge_page(hpage))) {
-				/*
-				 * FIXME: if splitting THP is failed, it is
-				 * better to stop the following operation rather
-				 * than causing panic by unmapping. System might
-				 * survive if the page is freed later.
-				 */
-				printk(KERN_INFO
-					"MCE %#lx: failed to split THP\n", pfn);
-
-				BUG_ON(!PageHWPoison(p));
-				return SWAP_FAIL;
-			}
-			/*
-			 * We pinned the head page for hwpoison handling,
-			 * now we split the thp and we are interested in
-			 * the hwpoisoned raw page, so move the refcount
-			 * to it. Similarly, page lock is shifted.
-			 */
-			if (hpage != p) {
-				if (!(flags & MF_COUNT_INCREASED)) {
-					put_page(hpage);
-					get_page(p);
-				}
-				lock_page(p);
-				unlock_page(hpage);
-				*hpagep = p;
-			}
-			/* THP is split, so ppage should be the real poisoned page. */
-			ppage = p;
-		}
-	}
-
-	/*
 	 * First collect all the processes that have the page
 	 * mapped in dirty form.  This has to be done before try_to_unmap,
 	 * because ttu takes the rmap data structures down.
@@ -1039,12 +985,12 @@ static int hwpoison_user_mappings(struct
 	 * there's nothing that can be done.
 	 */
 	if (kill)
-		collect_procs(ppage, &tokill, flags & MF_ACTION_REQUIRED);
+		collect_procs(hpage, &tokill, flags & MF_ACTION_REQUIRED);
 
-	ret = try_to_unmap(ppage, ttu);
+	ret = try_to_unmap(hpage, ttu);
 	if (ret != SWAP_SUCCESS)
 		printk(KERN_ERR "MCE %#lx: failed to unmap page (mapcount=%d)\n",
-				pfn, page_mapcount(ppage));
+				pfn, page_mapcount(hpage));
 
 	/*
 	 * Now that the dirty bit has been propagated to the
@@ -1056,7 +1002,7 @@ static int hwpoison_user_mappings(struct
 	 * use a more force-full uncatchable kill to prevent
 	 * any accesses to the poisoned memory.
 	 */
-	forcekill = PageDirty(ppage) || (flags & MF_MUST_KILL);
+	forcekill = PageDirty(hpage) || (flags & MF_MUST_KILL);
 	kill_procs(&tokill, forcekill, trapno,
 		      ret != SWAP_SUCCESS, p, pfn, flags);
 
@@ -1102,6 +1048,7 @@ int memory_failure(unsigned long pfn, in
 	struct page_state *ps;
 	struct page *p;
 	struct page *hpage;
+	struct page *orig_head;
 	int res;
 	unsigned int nr_pages;
 	unsigned long page_flags;
@@ -1117,7 +1064,7 @@ int memory_failure(unsigned long pfn, in
 	}
 
 	p = pfn_to_page(pfn);
-	hpage = compound_head(p);
+	orig_head = hpage = compound_head(p);
 	if (TestSetPageHWPoison(p)) {
 		printk(KERN_ERR "MCE %#lx: already hardware poisoned\n", pfn);
 		return 0;
@@ -1180,6 +1127,21 @@ int memory_failure(unsigned long pfn, in
 		}
 	}
 
+	if (!PageHuge(p) && PageTransHuge(hpage)) {
+		if (!PageAnon(hpage)) {
+			pr_err("MCE: %#lx: non anonymous thp\n", pfn);
+			put_page(p);
+			return -EBUSY;
+		}
+		if (unlikely(split_huge_page(hpage))) {
+			pr_err("MCE: %#lx: thp split failed\n", pfn);
+			put_page(p);
+			return -EBUSY;
+		}
+		VM_BUG_ON_PAGE(!page_count(p), p);
+		hpage = compound_head(p);
+	}
+
 	/*
 	 * We ignore non-LRU pages for good reasons.
 	 * - PG_locked is only well defined for LRU pages and a few others
@@ -1189,9 +1151,9 @@ int memory_failure(unsigned long pfn, in
 	 * walked by the page reclaim code, however that's not a big loss.
 	 */
 	if (!PageHuge(p)) {
-		if (!PageLRU(hpage))
-			shake_page(hpage, 0);
-		if (!PageLRU(hpage)) {
+		if (!PageLRU(p))
+			shake_page(p, 0);
+		if (!PageLRU(p)) {
 			/*
 			 * shake_page could have turned it free.
 			 */
@@ -1212,7 +1174,7 @@ int memory_failure(unsigned long pfn, in
 	 * The page could have changed compound pages during the locking.
 	 * If this happens just bail out.
 	 */
-	if (compound_head(p) != hpage) {
+	if (PageCompound(p) && compound_head(p) != orig_head) {
 		action_result(pfn, MSG_DIFFERENT_COMPOUND, IGNORED);
 		res = -EBUSY;
 		goto out;
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
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

