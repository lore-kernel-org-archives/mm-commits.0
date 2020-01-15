From: akpm@linux-foundation.org
Subject: +
 =?US-ASCII?Q?mm-mempolicy-skip-walking-hugetlb-vma-if-mpol=5Fmf=5Fstrict-?=
 =?US-ASCII?Q?is-specified-alone.patch?= added to -mm tree
Date: Tue, 14 Jan 2020 16:32:48 -0800
Message-ID: <20200115003248.RCqxg793i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726495AbgAOAct (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Jan 2020 19:32:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lixinhai.lxh@gmail.com, mhocko@suse.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm/mempolicy: skip walking HUGETLB vma if MPOL_MF_STRICT is specified alone
has been added to the -mm tree.  Its filename is
     mm-mempolicy-skip-walking-hugetlb-vma-if-mpol_mf_strict-is-specified-alone.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-skip-walking-hugetlb-vma-if-mpol_mf_strict-is-specified-alone.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-skip-walking-hugetlb-vma-if-mpol_mf_strict-is-specified-alone.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Link: http://lkml.kernel.org/r/1578993378-10860-2-git-send-email-lixinhai.lxh@gmail.com
Signed-off-by: Li Xinhai <lixinhai.lxh@gmail.com>
Reviewed-by: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/mempolicy.c~mm-mempolicy-skip-walking-hugetlb-vma-if-mpol_mf_strict-is-specified-alone
+++ a/mm/mempolicy.c
@@ -656,6 +656,13 @@ static int queue_pages_test_walk(unsigne
 		return 1;
 	}
 
+	/* MPOL_MF_STRICT is ignored for huge page, skip checking
+	*  misplaced pages
+	*/
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
mm-mempolicy-checking-hstate-for-hugetlbfs-page-in-vma_migratable.patch
mm-mempolicy-skip-walking-hugetlb-vma-if-mpol_mf_strict-is-specified-alone.patch
