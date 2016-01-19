From: akpm@linux-foundation.org
Subject: [merged] ksm-prepare-to-new-thp-semantics.patch removed from -mm
 tree
Date: Tue, 19 Jan 2016 12:01:59 -0800
Message-ID: <569e9637.WK8qcn44xqwGdctq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42784 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932510AbcASUCA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:02:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, sasha.levin@oracle.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: prepare to new THP semantics
has been removed from the -mm tree.  Its filename was
     ksm-prepare-to-new-thp-semantics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: ksm: prepare to new THP semantics

We don't need special code to stabilize THP. If you've got reference to
any subpage of THP it will not be split under you.

New split_huge_page() also accepts tail pages: no need in special code
to get reference to head page.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Tested-by: Sasha Levin <sasha.levin@oracle.com>
Tested-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Steve Capper <steve.capper@linaro.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   57 +++++++++--------------------------------------------
 1 file changed, 10 insertions(+), 47 deletions(-)

diff -puN mm/ksm.c~ksm-prepare-to-new-thp-semantics mm/ksm.c
--- a/mm/ksm.c~ksm-prepare-to-new-thp-semantics
+++ a/mm/ksm.c
@@ -441,20 +441,6 @@ static void break_cow(struct rmap_item *
 	up_read(&mm->mmap_sem);
 }
 
-static struct page *page_trans_compound_anon(struct page *page)
-{
-	if (PageTransCompound(page)) {
-		struct page *head = compound_head(page);
-		/*
-		 * head may actually be splitted and freed from under
-		 * us but it's ok here.
-		 */
-		if (PageAnon(head))
-			return head;
-	}
-	return NULL;
-}
-
 static struct page *get_mergeable_page(struct rmap_item *rmap_item)
 {
 	struct mm_struct *mm = rmap_item->mm;
@@ -470,7 +456,7 @@ static struct page *get_mergeable_page(s
 	page = follow_page(vma, addr, FOLL_GET);
 	if (IS_ERR_OR_NULL(page))
 		goto out;
-	if (PageAnon(page) || page_trans_compound_anon(page)) {
+	if (PageAnon(page)) {
 		flush_anon_page(vma, page, addr);
 		flush_dcache_page(page);
 	} else {
@@ -975,33 +961,6 @@ out:
 	return err;
 }
 
-static int page_trans_compound_anon_split(struct page *page)
-{
-	int ret = 0;
-	struct page *transhuge_head = page_trans_compound_anon(page);
-	if (transhuge_head) {
-		/* Get the reference on the head to split it. */
-		if (get_page_unless_zero(transhuge_head)) {
-			/*
-			 * Recheck we got the reference while the head
-			 * was still anonymous.
-			 */
-			if (PageAnon(transhuge_head))
-				ret = split_huge_page(transhuge_head);
-			else
-				/*
-				 * Retry later if split_huge_page run
-				 * from under us.
-				 */
-				ret = 1;
-			put_page(transhuge_head);
-		} else
-			/* Retry later if split_huge_page run from under us. */
-			ret = 1;
-	}
-	return ret;
-}
-
 /*
  * try_to_merge_one_page - take two pages and merge them into one
  * @vma: the vma that holds the pte pointing to page
@@ -1020,9 +979,6 @@ static int try_to_merge_one_page(struct
 	if (page == kpage)			/* ksm page forked */
 		return 0;
 
-	if (PageTransCompound(page) && page_trans_compound_anon_split(page))
-		goto out;
-	BUG_ON(PageTransCompound(page));
 	if (!PageAnon(page))
 		goto out;
 
@@ -1035,6 +991,13 @@ static int try_to_merge_one_page(struct
 	 */
 	if (!trylock_page(page))
 		goto out;
+
+	if (PageTransCompound(page)) {
+		err = split_huge_page(page);
+		if (err)
+			goto out_unlock;
+	}
+
 	/*
 	 * If this anonymous page is mapped only here, its pte may need
 	 * to be write-protected.  If it's mapped elsewhere, all of its
@@ -1065,6 +1028,7 @@ static int try_to_merge_one_page(struct
 		}
 	}
 
+out_unlock:
 	unlock_page(page);
 out:
 	return err;
@@ -1635,8 +1599,7 @@ next_mm:
 				cond_resched();
 				continue;
 			}
-			if (PageAnon(*page) ||
-			    page_trans_compound_anon(*page)) {
+			if (PageAnon(*page)) {
 				flush_anon_page(vma, *page, ksm_scan.address);
 				flush_dcache_page(*page);
 				rmap_item = get_next_rmap_item(slot,
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

thp-update-documentation.patch
thp-allow-mlocked-thp-again.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting.patch
thp-add-debugfs-handle-to-split-all-huge-pages.patch
thp-increase-split_huge_page-success-rate.patch
thp-fix-split_huge_page-after-mremap-of-thp.patch
memblock-fix-section-mismatch.patch
mm-fix-locking-order-in-mm_take_all_locks.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

