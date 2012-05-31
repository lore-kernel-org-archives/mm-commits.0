From: akpm@linux-foundation.org
Subject: [merged] thp-memcg-split-hugepage-for-memcg-oom-on-cow.patch removed from -mm tree
Date: Thu, 31 May 2012 12:14:16 -0700
Message-ID: <20120531191416.8044CA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:65415 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932849Ab2EaTOS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 May 2012 15:14:18 -0400
Received: by mail-lpp01m010-f74.google.com with SMTP id r15so75614lag.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:14:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, aarcange@redhat.com, jweiner@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: thp, memcg: split hugepage for memcg oom on cow
has been removed from the -mm tree.  Its filename was
     thp-memcg-split-hugepage-for-memcg-oom-on-cow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: thp, memcg: split hugepage for memcg oom on cow

On COW, a new hugepage is allocated and charged to the memcg.  If the
system is oom or the charge to the memcg fails, however, the fault handler
will return VM_FAULT_OOM which results in an oom kill.

Instead, it's possible to fallback to splitting the hugepage so that the
COW results only in an order-0 page being allocated and charged to the
memcg which has a higher liklihood to succeed.  This is expensive because
the hugepage must be split in the page fault handler, but it is much
better than unnecessarily oom killing a process.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 +++
 mm/memory.c      |   18 +++++++++++++++---
 2 files changed, 18 insertions(+), 3 deletions(-)

diff -puN mm/huge_memory.c~thp-memcg-split-hugepage-for-memcg-oom-on-cow mm/huge_memory.c
--- a/mm/huge_memory.c~thp-memcg-split-hugepage-for-memcg-oom-on-cow
+++ a/mm/huge_memory.c
@@ -952,6 +952,8 @@ int do_huge_pmd_wp_page(struct mm_struct
 		count_vm_event(THP_FAULT_FALLBACK);
 		ret = do_huge_pmd_wp_page_fallback(mm, vma, address,
 						   pmd, orig_pmd, page, haddr);
+		if (ret & VM_FAULT_OOM)
+			split_huge_page(page);
 		put_page(page);
 		goto out;
 	}
@@ -959,6 +961,7 @@ int do_huge_pmd_wp_page(struct mm_struct
 
 	if (unlikely(mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL))) {
 		put_page(new_page);
+		split_huge_page(page);
 		put_page(page);
 		ret |= VM_FAULT_OOM;
 		goto out;
diff -puN mm/memory.c~thp-memcg-split-hugepage-for-memcg-oom-on-cow mm/memory.c
--- a/mm/memory.c~thp-memcg-split-hugepage-for-memcg-oom-on-cow
+++ a/mm/memory.c
@@ -3486,6 +3486,7 @@ int handle_mm_fault(struct mm_struct *mm
 	if (unlikely(is_vm_hugetlb_page(vma)))
 		return hugetlb_fault(mm, vma, address, flags);
 
+retry:
 	pgd = pgd_offset(mm, address);
 	pud = pud_alloc(mm, pgd, address);
 	if (!pud)
@@ -3499,13 +3500,24 @@ int handle_mm_fault(struct mm_struct *mm
 							  pmd, flags);
 	} else {
 		pmd_t orig_pmd = *pmd;
+		int ret;
+
 		barrier();
 		if (pmd_trans_huge(orig_pmd)) {
 			if (flags & FAULT_FLAG_WRITE &&
 			    !pmd_write(orig_pmd) &&
-			    !pmd_trans_splitting(orig_pmd))
-				return do_huge_pmd_wp_page(mm, vma, address,
-							   pmd, orig_pmd);
+			    !pmd_trans_splitting(orig_pmd)) {
+				ret = do_huge_pmd_wp_page(mm, vma, address, pmd,
+							  orig_pmd);
+				/*
+				 * If COW results in an oom, the huge pmd will
+				 * have been split, so retry the fault on the
+				 * pte for a smaller charge.
+				 */
+				if (unlikely(ret & VM_FAULT_OOM))
+					goto retry;
+				return ret;
+			}
 			return 0;
 		}
 	}
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

