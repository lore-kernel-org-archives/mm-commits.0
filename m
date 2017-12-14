From: akpm@linux-foundation.org
Subject: + arc-use-generic_pmdp_establish-as-pmdp_establish.patch added to -mm tree
Date: Wed, 13 Dec 2017 16:11:08 -0800
Message-ID: <5a31c19c.X6dlYa+gfehxOKFE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56830 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751839AbdLNALJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Dec 2017 19:11:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, mhocko@kernel.org, vbabka@suse.cz, vgupta@synopsys.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arc: use generic_pmdp_establish as pmdp_establish
has been added to the -mm tree.  Its filename is
     arc-use-generic_pmdp_establish-as-pmdp_establish.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arc-use-generic_pmdp_establish-as-pmdp_establish.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arc-use-generic_pmdp_establish-as-pmdp_establish.patch

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

asm-generic-provide-generic_pmdp_establish.patch
arc-use-generic_pmdp_establish-as-pmdp_establish.patch
arm-mm-provide-pmdp_establish-helper.patch
mips-use-generic_pmdp_establish-as-pmdp_establish.patch
x86-mm-provide-pmdp_establish-helper.patch
mm-do-not-lose-dirty-and-access-bits-in-pmdp_invalidate.patch
mm-use-updated-pmdp_invalidate-interface-to-track-dirty-accessed-bits.patch

