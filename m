From: akpm@linux-foundation.org
Subject: + thp-memcg-split-hugepage-for-memcg-oom-on-cow.patch added to -mm tree
Date: Wed, 25 Apr 2012 14:07:05 -0700
Message-ID: <20120425210705.E9169A0423@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:44491 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757504Ab2DYVHI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Apr 2012 17:07:08 -0400
Received: by wibhj13 with SMTP id hj13so24560wib.1
        for <mm-commits@vger.kernel.org>; Wed, 25 Apr 2012 14:07:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, aarcange@redhat.com, jweiner@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: thp, memcg: split hugepage for memcg oom on cow
has been added to the -mm tree.  Its filename is
     thp-memcg-split-hugepage-for-memcg-oom-on-cow.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -3492,6 +3492,7 @@ int handle_mm_fault(struct mm_struct *mm
 	if (unlikely(is_vm_hugetlb_page(vma)))
 		return hugetlb_fault(mm, vma, address, flags);
 
+retry:
 	pgd = pgd_offset(mm, address);
 	pud = pud_alloc(mm, pgd, address);
 	if (!pud)
@@ -3505,13 +3506,24 @@ int handle_mm_fault(struct mm_struct *mm
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
Subject: Subject: thp, memcg: split hugepage for memcg oom on cow

Patches currently in -mm which might be from rientjes@google.com are

mm-hugetlb-fix-warning-in-alloc_huge_page-dequeue_huge_page_vma.patch
linux-next.patch
mm-memory_failure-let-the-compiler-add-the-function-name.patch
mm-mempolicyc-use-enum-value-mpol_rebind_once-instead-of-0-in-mpol_rebind_policy.patch
mm-hugetlbc-cleanup-to-use-long-vars-instead-of-int-in-region_count.patch
mm-thp-remove-unnecessary-ret-variable.patch
mm-thp-allow-fallback-when-pte_alloc_one-fails-for-huge-pmd.patch
mm-vmstatc-remov-debug-fs-entries-on-failure-of-file-creation-and-made-extfrag_debug_root-dentry-local.patch
thp-memcg-split-hugepage-for-memcg-oom-on-cow.patch

