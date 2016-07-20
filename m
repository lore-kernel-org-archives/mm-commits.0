From: akpm@linux-foundation.org
Subject: +
 mm-thp-fix-comment-inconsistency-for-swapin-readahead-functions.patch added to -mm tree
Date: Wed, 20 Jul 2016 14:08:31 -0700
Message-ID: <578fe84f.JnAiU3QZ++TBnX9K%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51517 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbcGTVId (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jul 2016 17:08:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebru.akagunduz@gmail.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, boaz@plexistor.com, gorcunov@openvz.org, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, hughd@google.com, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, thp: fix comment inconsistency for swapin readahead functions
has been added to the -mm tree.  Its filename is
     mm-thp-fix-comment-inconsistency-for-swapin-readahead-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-fix-comment-inconsistency-for-swapin-readahead-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-fix-comment-inconsistency-for-swapin-readahead-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Subject: mm, thp: fix comment inconsistency for swapin readahead functions

After fixing swapin issues, comment lines stayed as in old version.
This patch updates the comments.

Link: http://lkml.kernel.org/r/1468109345-32258-1-git-send-email-ebru.akagunduz@gmail.com
Signed-off-by: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Boaz Harrosh <boaz@plexistor.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/khugepaged.c~mm-thp-fix-comment-inconsistency-for-swapin-readahead-functions mm/khugepaged.c
--- a/mm/khugepaged.c~mm-thp-fix-comment-inconsistency-for-swapin-readahead-functions
+++ a/mm/khugepaged.c
@@ -891,9 +891,10 @@ static bool __collapse_huge_page_swapin(
 		/* do_swap_page returns VM_FAULT_RETRY with released mmap_sem */
 		if (ret & VM_FAULT_RETRY) {
 			down_read(&mm->mmap_sem);
-			/* vma is no longer available, don't continue to swapin */
-			if (hugepage_vma_revalidate(mm, address))
+			if (hugepage_vma_revalidate(mm, address)) {
+				/* vma is no longer available, don't continue to swapin */
 				return false;
+			}
 			/* check if the pmd is still valid */
 			if (mm_find_pmd(mm, address) != pmd)
 				return false;
@@ -969,7 +970,7 @@ static void collapse_huge_page(struct mm
 
 	/*
 	 * __collapse_huge_page_swapin always returns with mmap_sem locked.
-	 * If it fails, release mmap_sem and jump directly out.
+	 * If it fails, we release mmap_sem and jump out_nolock.
 	 * Continuing to collapse causes inconsistency.
 	 */
 	if (!__collapse_huge_page_swapin(mm, vma, address, pmd)) {
_

Patches currently in -mm which might be from ebru.akagunduz@gmail.com are

mm-make-optimistic-check-for-swapin-readahead.patch
mm-make-optimistic-check-for-swapin-readahead-fix-3.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-ks.patch
mm-thp-fix-locking-inconsistency-in-collapse_huge_page.patch
mm-thp-fix-comment-inconsistency-for-swapin-readahead-functions.patch

