From: akpm@linux-foundation.org
Subject: [merged] mm-thp-remove-unnecessary-ret-variable.patch removed from -mm tree
Date: Thu, 31 May 2012 12:13:42 -0700
Message-ID: <20120531191342.608AFA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:63035 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932663Ab2EaTNn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:13:43 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so76006wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:13:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, thp: remove unnecessary ret variable
has been removed from the -mm tree.  Its filename was
     mm-thp-remove-unnecessary-ret-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, thp: remove unnecessary ret variable

The "ret" variable is unnecessary in __do_huge_pmd_anonymous_page(), so
remove it.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-remove-unnecessary-ret-variable mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-remove-unnecessary-ret-variable
+++ a/mm/huge_memory.c
@@ -636,7 +636,6 @@ static int __do_huge_pmd_anonymous_page(
 					unsigned long haddr, pmd_t *pmd,
 					struct page *page)
 {
-	int ret = 0;
 	pgtable_t pgtable;
 
 	VM_BUG_ON(!PageCompound(page));
@@ -675,7 +674,7 @@ static int __do_huge_pmd_anonymous_page(
 		spin_unlock(&mm->page_table_lock);
 	}
 
-	return ret;
+	return 0;
 }
 
 static inline gfp_t alloc_hugepage_gfpmask(int defrag, gfp_t extra_gfp)
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
slab-move-full-state-transition-to-an-initcall.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlbfs-add-an-inline-helper-for-finding-hstate-index-fix.patch
hugetlb-simplify-migrate_huge_page.patch
hugetlb-simplify-migrate_huge_page-fix.patch
memcg-add-hugetlb-extension-fix.patch
memcg-add-hugetlb-extension-fix-fix.patch

