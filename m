From: akpm@linux-foundation.org
Subject: + mm-hugetlb-call-huge_pte_alloc-only-if-ptep-is-null.patch added to -mm tree
Date: Mon, 30 Nov 2015 15:09:17 -0800
Message-ID: <565cd71d.jjhqXcDe9cigN/s3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33141 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbbK3XJS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Nov 2015 18:09:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, dave.hansen@intel.com, hillf.zj@alibaba-inc.com, hughd@google.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, mike.kravetz@oracle.com, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: call huge_pte_alloc() only if ptep is null
has been added to the -mm tree.  Its filename is
     mm-hugetlb-call-huge_pte_alloc-only-if-ptep-is-null.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-call-huge_pte_alloc-only-if-ptep-is-null.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-call-huge_pte_alloc-only-if-ptep-is-null.patch

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
Subject: mm: hugetlb: call huge_pte_alloc() only if ptep is null

Currently at the beginning of hugetlb_fault(), we call huge_pte_offset()
and check whether the obtained *ptep is a migration/hwpoison entry or not.
 And if not, then we get to call huge_pte_alloc().  This is racy because
the *ptep could turn into migration/hwpoison entry after the
huge_pte_offset() check.  This race results in BUG_ON in huge_pte_alloc().

We don't have to call huge_pte_alloc() when the huge_pte_offset() returns
non-NULL, so let's fix this bug with moving the code into else block.

Note that the *ptep could turn into a migration/hwpoison entry after this
block, but that's not a problem because we have another !pte_present check
later (we never go into hugetlb_no_page() in that case.)

Fixes: 290408d4a250 ("hugetlb: hugepage migration core")
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>	[2.6.36+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-call-huge_pte_alloc-only-if-ptep-is-null mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-call-huge_pte_alloc-only-if-ptep-is-null
+++ a/mm/hugetlb.c
@@ -3696,12 +3696,12 @@ int hugetlb_fault(struct mm_struct *mm,
 		} else if (unlikely(is_hugetlb_entry_hwpoisoned(entry)))
 			return VM_FAULT_HWPOISON_LARGE |
 				VM_FAULT_SET_HINDEX(hstate_index(h));
+	} else {
+		ptep = huge_pte_alloc(mm, address, huge_page_size(h));
+		if (!ptep)
+			return VM_FAULT_OOM;
 	}
 
-	ptep = huge_pte_alloc(mm, address, huge_page_size(h));
-	if (!ptep)
-		return VM_FAULT_OOM;
