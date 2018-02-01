From: akpm@linux-foundation.org
Subject: [merged]
 arc-use-generic_pmdp_establish-as-pmdp_establish.patch removed from -mm
 tree
Date: Thu, 01 Feb 2018 11:32:05 -0800
Message-ID: <20180201193205.i4ndAHpXA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58456 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752463AbeBATcH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:32:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, mm-commits@vger.kernel.org, vbabka@suse.cz, vgupta@synopsys.com


The patch titled
     Subject: arc: use generic_pmdp_establish as pmdp_establish
has been removed from the -mm tree.  Its filename was
     arc-use-generic_pmdp_establish-as-pmdp_establish.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: arc: use generic_pmdp_establish as pmdp_establish

ARC doesn't support hardware dirty/accessed bits. 
generic_pmdp_establish() is suitable in this case.

Link: http://lkml.kernel.org/r/20171213105756.69879-3-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/include/asm/hugepage.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/arc/include/asm/hugepage.h~arc-use-generic_pmdp_establish-as-pmdp_establish arch/arc/include/asm/hugepage.h
--- a/arch/arc/include/asm/hugepage.h~arc-use-generic_pmdp_establish-as-pmdp_establish
+++ a/arch/arc/include/asm/hugepage.h
@@ -74,4 +74,7 @@ extern pgtable_t pgtable_trans_huge_with
 extern void flush_pmd_tlb_range(struct vm_area_struct *vma, unsigned long start,
 				unsigned long end);
 
+/* We don't have hardware dirty/accessed bits, generic_pmdp_establish is fine.*/
+#define pmdp_establish generic_pmdp_establish
+
 #endif
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are


