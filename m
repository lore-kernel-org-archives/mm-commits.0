From: akpm@linux-foundation.org
Subject: [merged]
 mm-thp-count-thp_fault_fallback-anytime-thp-fault-fails.patch removed from
 -mm tree
Date: Fri, 13 Sep 2013 13:03:04 -0700
Message-ID: <52336f78.y9Ffmc6xShZTTq3Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38086 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241Ab3IMUDF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 16:03:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mgorman@suse.de, kirill.shutemov@linux.intel.com, aarcange@redhat.com, rientjes@google.com

Subject: [merged] mm-thp-count-thp_fault_fallback-anytime-thp-fault-fails.patch removed from -mm tree
To: rientjes@google.com,aarcange@redhat.com,kirill.shutemov@linux.intel.com,mgorman@suse.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 13:03:04 -0700


The patch titled
     Subject: mm, thp: count thp_fault_fallback anytime thp fault fails
has been removed from the -mm tree.  Its filename was
     mm-thp-count-thp_fault_fallback-anytime-thp-fault-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, thp: count thp_fault_fallback anytime thp fault fails

Currently, thp_fault_fallback in vmstat only gets incremented if a
hugepage allocation fails.  If current's memcg hits its limit or the page
fault handler returns an error, it is incorrectly accounted as a
successful thp_fault_alloc.

Count thp_fault_fallback anytime the page fault handler falls back to
using regular pages and only count thp_fault_alloc when a hugepage has
actually been faulted.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-count-thp_fault_fallback-anytime-thp-fault-fails mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-count-thp_fault_fallback-anytime-thp-fault-fails
+++ a/mm/huge_memory.c
@@ -820,17 +820,19 @@ int do_huge_pmd_anonymous_page(struct mm
 		count_vm_event(THP_FAULT_FALLBACK);
 		return VM_FAULT_FALLBACK;
 	}
-	count_vm_event(THP_FAULT_ALLOC);
 	if (unlikely(mem_cgroup_newpage_charge(page, mm, GFP_KERNEL))) {
 		put_page(page);
+		count_vm_event(THP_FAULT_FALLBACK);
 		return VM_FAULT_FALLBACK;
 	}
 	if (unlikely(__do_huge_pmd_anonymous_page(mm, vma, haddr, pmd, page))) {
 		mem_cgroup_uncharge_page(page);
 		put_page(page);
+		count_vm_event(THP_FAULT_FALLBACK);
 		return VM_FAULT_FALLBACK;
 	}
 
+	count_vm_event(THP_FAULT_ALLOC);
 	return 0;
 }
 
@@ -1143,7 +1145,6 @@ alloc:
 		new_page = NULL;
 
 	if (unlikely(!new_page)) {
-		count_vm_event(THP_FAULT_FALLBACK);
 		if (is_huge_zero_pmd(orig_pmd)) {
 			ret = do_huge_pmd_wp_zero_page_fallback(mm, vma,
 					address, pmd, orig_pmd, haddr);
@@ -1154,9 +1155,9 @@ alloc:
 				split_huge_page(page);
 			put_page(page);
 		}
+		count_vm_event(THP_FAULT_FALLBACK);
 		goto out;
 	}
-	count_vm_event(THP_FAULT_ALLOC);
 
 	if (unlikely(mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL))) {
 		put_page(new_page);
@@ -1164,10 +1165,13 @@ alloc:
 			split_huge_page(page);
 			put_page(page);
 		}
+		count_vm_event(THP_FAULT_FALLBACK);
 		ret |= VM_FAULT_OOM;
 		goto out;
 	}
 
+	count_vm_event(THP_FAULT_ALLOC);
+
 	if (is_huge_zero_pmd(orig_pmd))
 		clear_huge_page(new_page, haddr, HPAGE_PMD_NR);
 	else
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch

