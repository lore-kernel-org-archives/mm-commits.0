From: akpm@linux-foundation.org
Subject: + hugetlb-call-mmu-notifiers-on-hugepage-cow.patch added to -mm tree
Date: Tue, 01 Jun 2010 23:16:07 -0700
Message-ID: <201006020616.o526G4GE008684@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40318 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752125Ab0FBGRK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jun 2010 02:17:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dougd@cray.com, aarcange@redhat.com, mel@csn.ul.ie


The patch titled
     hugetlb: call mmu notifiers on hugepage cow
has been added to the -mm tree.  Its filename is
     hugetlb-call-mmu-notifiers-on-hugepage-cow.patch

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
Subject: hugetlb: call mmu notifiers on hugepage cow
From: Doug Doan <dougd@cray.com>

When a copy-on-write occurs, we take one of two paths in handle_mm_fault:
through handle_pte_fault for normal pages, or through hugetlb_fault for
huge pages.

In the normal page case, we eventually get to do_wp_page and call mmu
notifiers via ptep_clear_flush_notify.  There is no callout to the mmmu
notifiers in the huge page case.  This patch fixes that.

Signed-off-by: Doug Doan <dougd@cray.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN mm/hugetlb.c~hugetlb-call-mmu-notifiers-on-hugepage-cow mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-call-mmu-notifiers-on-hugepage-cow
+++ a/mm/hugetlb.c
@@ -2349,11 +2349,17 @@ retry_avoidcopy:
 	ptep = huge_pte_offset(mm, address & huge_page_mask(h));
 	if (likely(pte_same(huge_ptep_get(ptep), pte))) {
 		/* Break COW */
+		mmu_notifier_invalidate_range_start(mm,
+			address & huge_page_mask(h),
+			(address & huge_page_mask(h)) + huge_page_size(h));
 		huge_ptep_clear_flush(vma, address, ptep);
 		set_huge_pte_at(mm, address, ptep,
 				make_huge_pte(vma, new_page, 1));
 		/* Make the old page be freed below */
 		new_page = old_page;
+		mmu_notifier_invalidate_range_end(mm,
+			address & huge_page_mask(h),
+			(address & huge_page_mask(h)) + huge_page_size(h));
 	}
 	page_cache_release(new_page);
 	page_cache_release(old_page);
_

Patches currently in -mm which might be from dougd@cray.com are

hugetlb-call-mmu-notifiers-on-hugepage-cow.patch

