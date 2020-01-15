From: akpm@linux-foundation.org
Subject: +
 mm-mempolicy-checking-hstate-for-hugetlbfs-page-in-vma_migratable.patch
 added to -mm tree
Date: Tue, 14 Jan 2020 16:32:46 -0800
Message-ID: <20200115003246.ED7WmneNR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726495AbgAOAcs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Jan 2020 19:32:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lixinhai.lxh@gmail.com, mhocko@suse.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm/mempolicy: check hstate for hugetlbfs page in vma_migratable()
has been added to the -mm tree.  Its filename is
     mm-mempolicy-checking-hstate-for-hugetlbfs-page-in-vma_migratable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-checking-hstate-for-hugetlbfs-page-in-vma_migratable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-checking-hstate-for-hugetlbfs-page-in-vma_migratable.patch

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
Subject: mm/mempolicy: check hstate for hugetlbfs page in vma_migratable()

Check hstate at early phase when isolating page, instead of during unmap
and move phase, to avoid useless isolation.

Link: http://lkml.kernel.org/r/1578993378-10860-1-git-send-email-lixinhai.lxh@gmail.com
Signed-off-by: Li Xinhai <lixinhai.lxh@gmail.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/include/linux/mempolicy.h~mm-mempolicy-checking-hstate-for-hugetlbfs-page-in-vma_migratable
+++ a/include/linux/mempolicy.h
@@ -185,10 +185,9 @@ static inline bool vma_migratable(struct
 	if (vma_is_dax(vma))
 		return false;
 
-#ifndef CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION
-	if (vma->vm_flags & VM_HUGETLB)
+	if (is_vm_hugetlb_page(vma) &&
+		!hugepage_migration_supported(hstate_vma(vma)))
 		return false;
-#endif
 
 	/*
 	 * Migration allocates pages in the highest zone. If we cannot
_

Patches currently in -mm which might be from lixinhai.lxh@gmail.com are

mm-page_vma_mappedc-explicitly-compare-pfn-for-normal-hugetlbfs-and-thp-page.patch
mm-mempolicy-checking-hstate-for-hugetlbfs-page-in-vma_migratable.patch
mm-mempolicy-skip-walking-hugetlb-vma-if-mpol_mf_strict-is-specified-alone.patch
