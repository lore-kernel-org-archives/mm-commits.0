From: akpm@linux-foundation.org
Subject: [nacked]
 =?us-ascii?Q?mm-mempolicy-skip-walking-hugetlb-vma-if-mpol=5Fmf=5Fstrict-?=
 =?us-ascii?Q?is-specified-alone.patch?= removed from -mm tree
Date: Thu, 16 Jan 2020 18:07:05 -0800
Message-ID: <20200117020705.-NRZK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729138AbgAQCHH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Jan 2020 21:07:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yang.shi@linux.alibaba.com, n-horiguchi@ah.jp.nec.com, mike.kravetz@oracle.com, mhocko@suse.com, lixinhai.lxh@gmail.com


The patch titled
     Subject: mm/mempolicy: skip walking HUGETLB vma if MPOL_MF_STRICT is specified alone
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-skip-walking-hugetlb-vma-if-mpol_mf_strict-is-specified-alone.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Li Xinhai <lixinhai.lxh@gmail.com>
Subject: mm/mempolicy: skip walking HUGETLB vma if MPOL_MF_STRICT is specified alone

Checking MPOL_MF_STRICT is ignored for HUGETLB vma according to mbind man
page:

Notes
MPOL_MF_STRICT is ignored on huge page mappings.

If MPOL_MF_STRICT is specified alone without any MOVE flag, we should
indicate, from test_walk, that walking this vma should be skipped even if
there are misplaced pages.

[akpm@linux-foundation.org: coding-style fixes]
Link: http://lkml.kernel.org/r/1578993378-10860-2-git-send-email-lixinhai.lxh@gmail.com
Signed-off-by: Li Xinhai <lixinhai.lxh@gmail.com>
Reviewed-by: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/mempolicy.c~mm-mempolicy-skip-walking-hugetlb-vma-if-mpol_mf_strict-is-specified-alone
+++ a/mm/mempolicy.c
@@ -656,6 +656,14 @@ static int queue_pages_test_walk(unsigne
 		return 1;
 	}
 
+	/*
+	 * MPOL_MF_STRICT is ignored for huge page, skip checking
+	 * misplaced pages
+	 */
+	if ((flags & MPOL_MF_VALID) == MPOL_MF_STRICT &&
+		is_vm_hugetlb_page(vma))
+		return 1;
+
 	/* queue pages from current vma */
 	if (flags & MPOL_MF_VALID)
 		return 0;
_

Patches currently in -mm which might be from lixinhai.lxh@gmail.com are

mm-page_vma_mappedc-explicitly-compare-pfn-for-normal-hugetlbfs-and-thp-page.patch
