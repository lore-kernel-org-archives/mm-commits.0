From: akpm@linux-foundation.org
Subject: [merged]
 mm-migration-deposit-page-table-when-copying-a-pmd-migration-entry.patch
 removed from -mm tree
Date: Fri, 03 Nov 2017 11:54:08 -0700
Message-ID: <20171103185408.JUZKKJjLd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54444 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933020AbdKCSyJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Nov 2017 14:54:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, zi.yan@cs.rutgers.edu


The patch titled
     Subject: mm/huge_memory.c: deposit page table when copying a PMD migration entry
has been removed from the -mm tree.  Its filename was
     mm-migration-deposit-page-table-when-copying-a-pmd-migration-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zi Yan <zi.yan@cs.rutgers.edu>
Subject: mm/huge_memory.c: deposit page table when copying a PMD migration entry

We need to deposit pre-allocated PTE page table when a PMD migration entry
is copied in copy_huge_pmd().  Otherwise, we will leak the pre-allocated
page and cause a NULL pointer dereference later in zap_huge_pmd().

The missing counters during PMD migration entry copy process are added as
well.

The bug report is here: https://lkml.org/lkml/2017/10/29/214

Link: http://lkml.kernel.org/r/20171030144636.4836-1-zi.yan@sent.com
Fixes: 84c3fc4e9c563 ("mm: thp: check pmd migration entry in common path")
Signed-off-by: Zi Yan <zi.yan@cs.rutgers.edu>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/huge_memory.c~mm-migration-deposit-page-table-when-copying-a-pmd-migration-entry mm/huge_memory.c
--- a/mm/huge_memory.c~mm-migration-deposit-page-table-when-copying-a-pmd-migration-entry
+++ a/mm/huge_memory.c
@@ -941,6 +941,9 @@ int copy_huge_pmd(struct mm_struct *dst_
 				pmd = pmd_swp_mksoft_dirty(pmd);
 			set_pmd_at(src_mm, addr, src_pmd, pmd);
 		}
+		add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
+		atomic_long_inc(&dst_mm->nr_ptes);
+		pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
 		set_pmd_at(dst_mm, addr, dst_pmd, pmd);
 		ret = 0;
 		goto out_unlock;
_

Patches currently in -mm which might be from zi.yan@cs.rutgers.edu are


