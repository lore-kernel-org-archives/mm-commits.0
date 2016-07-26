From: akpm@linux-foundation.org
Subject: [patch 119/126] mm, thp: fix comment inconsistency for swapin
 readahead functions
Date: Tue, 26 Jul 2016 15:26:43 -0700
Message-ID: <5797e3a3.vP7SHRXsjaX5VBKq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57130 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932162AbcGZW0p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:26:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, ebru.akagunduz@gmail.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, boaz@plexistor.com, gorcunov@openvz.org, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, hughd@google.com, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, vbabka@suse.cz

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
