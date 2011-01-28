From: akpm@linux-foundation.org
Subject: + thp-fix-the-wrong-reported-address-of-hwpoisoned-hugepages.patch added to -mm tree
Date: Fri, 28 Jan 2011 15:29:44 -0800
Message-ID: <201101282329.p0SNTird001028@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55235 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752706Ab1A1Xag (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Jan 2011 18:30:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jin.dongming@np.css.fujitsu.com, aarcange@redhat.com, andi@firstfloor.org, seto.hidetoshi@jp.fujitsu.com


The patch titled
     thp: fix the wrong reported address of hwpoisoned hugepages
has been added to the -mm tree.  Its filename is
     thp-fix-the-wrong-reported-address-of-hwpoisoned-hugepages.patch

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
Subject: thp: fix the wrong reported address of hwpoisoned hugepages
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>

When the tail page of THP is poisoned, the head page will be poisoned too.
 And the wrong address, address of head page, will be sent with sigbus
always.

So when the poisoned page is used by Guest OS which is running on KVM,
after the address changing(hva->gpa) by qemu, the unexpected process on
Guest OS will be killed by sigbus.

What we expected is that the process using the poisoned tail page could be
killed on Guest OS, but not that the process using the healthy head page
is killed.

Since it is not good to poison the healthy page, avoid poisoning other
than the page which is really poisoned.
  (While we poison all pages in a huge page in case of hugetlb,
   we can do this for THP thanks to split_huge_page().)

Here we fix two parts:
  1. Isolate the poisoned page only to make sure
     the reported address is the address of poisoned page.
  2. make the poisoned page work as the poisoned regular page.

Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c    |    7 ++++++-
 mm/memory-failure.c |   27 ++++++++++++++++++++++-----
 2 files changed, 28 insertions(+), 6 deletions(-)

diff -puN mm/huge_memory.c~thp-fix-the-wrong-reported-address-of-hwpoisoned-hugepages mm/huge_memory.c
--- a/mm/huge_memory.c~thp-fix-the-wrong-reported-address-of-hwpoisoned-hugepages
+++ a/mm/huge_memory.c
@@ -1162,7 +1162,12 @@ static void __split_huge_page_refcount(s
 		/* after clearing PageTail the gup refcount can be released */
 		smp_mb();
 
-		page_tail->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
+		/*
+		 * remain hwpoison flag of the poisoned tail page:
+		 *   fix for the unsuitable process killed on Guest Machine(KVM)
+		 *   by the memory-failure.
+		 */
+		page_tail->flags &= ~PAGE_FLAGS_CHECK_AT_PREP | __PG_HWPOISON;
 		page_tail->flags |= (page->flags &
 				     ((1L << PG_referenced) |
 				      (1L << PG_swapbacked) |
diff -puN mm/memory-failure.c~thp-fix-the-wrong-reported-address-of-hwpoisoned-hugepages mm/memory-failure.c
--- a/mm/memory-failure.c~thp-fix-the-wrong-reported-address-of-hwpoisoned-hugepages
+++ a/mm/memory-failure.c
@@ -854,6 +854,7 @@ static int hwpoison_user_mappings(struct
 	int ret;
 	int kill = 1;
 	struct page *hpage = compound_head(p);
+	struct page *ppage;
 
 	if (PageReserved(p) || PageSlab(p))
 		return SWAP_SUCCESS;
@@ -894,6 +895,14 @@ static int hwpoison_user_mappings(struct
 		}
 	}
 
+	/*
+	 * ppage: poisoned page
+	 *   if p is regular page(4k page)
+	 *        ppage == real poisoned page;
+	 *   else p is hugetlb or THP, ppage == head page.
+	 */
+	ppage = hpage;
+
 	if (PageTransHuge(hpage)) {
 		/*
 		 * Verify that this isn't a hugetlbfs head page, the check for
@@ -919,6 +928,8 @@ static int hwpoison_user_mappings(struct
 				BUG_ON(!PageHWPoison(p));
 				return SWAP_FAIL;
 			}
+			/* THP is split, so ppage should be the real poisoned page. */
+			ppage = p;
 		}
 	}
 
@@ -931,12 +942,18 @@ static int hwpoison_user_mappings(struct
 	 * there's nothing that can be done.
 	 */
 	if (kill)
-		collect_procs(hpage, &tokill);
+		collect_procs(ppage, &tokill);
 
-	ret = try_to_unmap(hpage, ttu);
+	if (hpage != ppage)
+		lock_page_nosync(ppage);
+
+	ret = try_to_unmap(ppage, ttu);
 	if (ret != SWAP_SUCCESS)
 		printk(KERN_ERR "MCE %#lx: failed to unmap page (mapcount=%d)\n",
-				pfn, page_mapcount(hpage));
+				pfn, page_mapcount(ppage));
+
+	if (hpage != ppage)
+		unlock_page(ppage);
 
 	/*
 	 * Now that the dirty bit has been propagated to the
@@ -947,7 +964,7 @@ static int hwpoison_user_mappings(struct
 	 * use a more force-full uncatchable kill to prevent
 	 * any accesses to the poisoned memory.
 	 */
-	kill_procs_ao(&tokill, !!PageDirty(hpage), trapno,
+	kill_procs_ao(&tokill, !!PageDirty(ppage), trapno,
 		      ret != SWAP_SUCCESS, p, pfn);
 
 	return ret;
@@ -1090,7 +1107,7 @@ int __memory_failure(unsigned long pfn, 
 	 * For error on the tail page, we should set PG_hwpoison
 	 * on the head page to show that the hugepage is hwpoisoned
 	 */
-	if (PageTail(p) && TestSetPageHWPoison(hpage)) {
+	if (PageHuge(p) && PageTail(p) && TestSetPageHWPoison(hpage)) {
 		action_result(pfn, "hugepage already hardware poisoned",
 				IGNORED);
 		unlock_page(hpage);
_

Patches currently in -mm which might be from jin.dongming@np.css.fujitsu.com are

thp-fix-splitting-of-hwpoisoned-hugepages.patch
thp-fix-the-wrong-reported-address-of-hwpoisoned-hugepages.patch
thp-fix-the-wrong-reported-address-of-hwpoisoned-hugepages-fix.patch
thp-fix-unsuitable-behavior-for-hwpoisoned-tail-page.patch
thp-fix-unsuitable-behavior-for-hwpoisoned-tail-page-fix.patch

