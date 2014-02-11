From: akpm@linux-foundation.org
Subject: + mm-thp-fix-infinite-loop-on-memcg-oom.patch added to -mm tree
Date: Tue, 11 Feb 2014 12:35:54 -0800
Message-ID: <52fa89aa.Sw8RMnKjuSLHrWM3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41266 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886AbaBKUfz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Feb 2014 15:35:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, mhocko@suse.cz, m.mizuma@jp.fujitsu.com, hannes@cmpxchg.org, aarcange@redhat.com, kirill.shutemov@linux.intel.com

Subject: + mm-thp-fix-infinite-loop-on-memcg-oom.patch added to -mm tree
To: kirill.shutemov@linux.intel.com,aarcange@redhat.com,hannes@cmpxchg.org,m.mizuma@jp.fujitsu.com,mhocko@suse.cz,rientjes@google.com
From: akpm@linux-foundation.org
Date: Tue, 11 Feb 2014 12:35:54 -0800


The patch titled
     Subject: mm, thp: fix infinite loop on memcg OOM
has been added to the -mm tree.  Its filename is
     mm-thp-fix-infinite-loop-on-memcg-oom.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-fix-infinite-loop-on-memcg-oom.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-fix-infinite-loop-on-memcg-oom.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm, thp: fix infinite loop on memcg OOM

Masayoshi Mizuma reported a bug with the hang of an application under the
memcg limit.  It happens on write-protection fault to huge zero page

If we successfully allocate a huge page to replace zero page but hit the
memcg limit we need to split the zero page with split_huge_page_pmd() and
fallback to small pages.

The other part of the problem is that VM_FAULT_OOM has special meaning in
do_huge_pmd_wp_page() context.  __handle_mm_fault() expects the page to be
split if it sees VM_FAULT_OOM and it will will retry page fault handling. 
This causes an infinite loop if the page was not split.

do_huge_pmd_wp_zero_page_fallback() can return VM_FAULT_OOM if it failed
to allocate one small page, so fallback to small pages will not help.

The solution for this part is to replace VM_FAULT_OOM with
VM_FAULT_FALLBACK is fallback required.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    9 ++++++---
 mm/memory.c      |   14 +++-----------
 2 files changed, 9 insertions(+), 14 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-fix-infinite-loop-on-memcg-oom mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-fix-infinite-loop-on-memcg-oom
+++ a/mm/huge_memory.c
@@ -1166,8 +1166,10 @@ alloc:
 		} else {
 			ret = do_huge_pmd_wp_page_fallback(mm, vma, address,
 					pmd, orig_pmd, page, haddr);
-			if (ret & VM_FAULT_OOM)
+			if (ret & VM_FAULT_OOM) {
 				split_huge_page(page);
+				ret |= VM_FAULT_FALLBACK;
+			}
 			put_page(page);
 		}
 		count_vm_event(THP_FAULT_FALLBACK);
@@ -1179,9 +1181,10 @@ alloc:
 		if (page) {
 			split_huge_page(page);
 			put_page(page);
-		}
+		} else
+			split_huge_page_pmd(vma, address, pmd);
+		ret |= VM_FAULT_FALLBACK;
 		count_vm_event(THP_FAULT_FALLBACK);
-		ret |= VM_FAULT_OOM;
 		goto out;
 	}
 
diff -puN mm/memory.c~mm-thp-fix-infinite-loop-on-memcg-oom mm/memory.c
--- a/mm/memory.c~mm-thp-fix-infinite-loop-on-memcg-oom
+++ a/mm/memory.c
@@ -3704,7 +3704,6 @@ static int __handle_mm_fault(struct mm_s
 	if (unlikely(is_vm_hugetlb_page(vma)))
 		return hugetlb_fault(mm, vma, address, flags);
 
-retry:
 	pgd = pgd_offset(mm, address);
 	pud = pud_alloc(mm, pgd, address);
 	if (!pud)
@@ -3742,20 +3741,13 @@ retry:
 			if (dirty && !pmd_write(orig_pmd)) {
 				ret = do_huge_pmd_wp_page(mm, vma, address, pmd,
 							  orig_pmd);
-				/*
-				 * If COW results in an oom, the huge pmd will
-				 * have been split, so retry the fault on the
-				 * pte for a smaller charge.
-				 */
-				if (unlikely(ret & VM_FAULT_OOM))
-					goto retry;
-				return ret;
+				if (!(ret & VM_FAULT_FALLBACK))
+					return ret;
 			} else {
 				huge_pmd_set_accessed(mm, vma, address, pmd,
 						      orig_pmd, dirty);
+				return 0;
 			}
-
-			return 0;
 		}
 	}
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-hwpoison-release-page-on-pagehwpoison-in-__do_fault.patch
mm-thp-fix-infinite-loop-on-memcg-oom.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
madvise-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-rename-__do_fault-do_fault.patch
mm-do_fault-extract-to-call-vm_ops-do_fault-to-separate-function.patch
mm-introduce-do_read_fault.patch
mm-introduce-do_cow_fault.patch
mm-introduce-do_shared_fault-and-drop-do_fault.patch
mm-consolidate-code-to-call-vm_ops-page_mkwrite.patch
mm-consolidate-code-to-setup-pte.patch
mm-thp-drop-do_huge_pmd_wp_zero_page_fallback.patch

