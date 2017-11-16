From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-consolidate-page-table-accounting-fix-fix.patch removed from -mm tree
Date: Wed, 15 Nov 2017 17:02:38 -0800
Message-ID: <5a0ce3ae.Skc/o+4WcTm8njCE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35980 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932456AbdKPBCj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:02:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-consolidate-page-table-accounting-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-consolidate-page-table-accounting-fix-fix.patch

This patch was dropped because it was folded into mm-consolidate-page-table-accounting.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-consolidate-page-table-accounting-fix-fix

fix mm/huge_memory.c

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/huge_memory.c~mm-consolidate-page-table-accounting-fix-fix mm/huge_memory.c
--- a/mm/huge_memory.c~mm-consolidate-page-table-accounting-fix-fix
+++ a/mm/huge_memory.c
@@ -942,7 +942,7 @@ int copy_huge_pmd(struct mm_struct *dst_
 			set_pmd_at(src_mm, addr, src_pmd, pmd);
 		}
 		add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
-		atomic_long_inc(&dst_mm->nr_ptes);
+		mm_inc_nr_ptes(dst_mm);
 		pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
 		set_pmd_at(dst_mm, addr, dst_pmd, pmd);
 		ret = 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-consolidate-page-table-accounting.patch
mm-stop-zeroing-memory-during-allocation-in-vmemmap-fix.patch
mm-batch-radix-tree-operations-when-truncating-pages-fix-fix.patch
mm-simplify-nodemask-printing-fix.patch
mm-make-alloc_node_mem_map-a-voidcall-if-we-dont-have-config_flat_node_mem_map-fix.patch

