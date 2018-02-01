From: akpm@linux-foundation.org
Subject: [patch 061/119] arc: use generic_pmdp_establish as
 pmdp_establish
Date: Wed, 31 Jan 2018 16:17:48 -0800
Message-ID: <20180201001748.rd-FjZC-R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35056 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754177AbeBAARt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:17:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, mhocko@kernel.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, vbabka@suse.cz, vgupta@synopsys.com

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
