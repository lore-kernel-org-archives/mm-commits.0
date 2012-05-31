From: akpm@linux-foundation.org
Subject: [merged] mm-move-is_vma_temporary_stack-declaration-to-huge_mmh.patch removed from -mm tree
Date: Thu, 31 May 2012 12:14:56 -0700
Message-ID: <20120531191456.6B058A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:65415 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932859Ab2EaTO6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 May 2012 15:14:58 -0400
Received: by mail-lpp01m010-f74.google.com with SMTP id r15so75614lag.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:14:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.shi@intel.com, aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move is_vma_temporary_stack() declaration to huge_mm.h
has been removed from the -mm tree.  Its filename was
     mm-move-is_vma_temporary_stack-declaration-to-huge_mmh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Alex Shi <alex.shi@intel.com>
Subject: mm: move is_vma_temporary_stack() declaration to huge_mm.h

When transparent_hugepage_enabled() is used outside mm/, such as in
arch/x86/xx/tlb.c:

+       if (!cpu_has_invlpg || vma->vm_flags & VM_HUGETLB
+                       || transparent_hugepage_enabled(vma)) {
+               flush_tlb_mm(vma->vm_mm);

is_vma_temporary_stack() isn't referenced in huge_mm.h, so it has compile
errors:

arch/x86/mm/tlb.c: In function `flush_tlb_range':
arch/x86/mm/tlb.c:324:4: error: implicit declaration of function `is_vma_temporary_stack' [-Werror=implicit-function-declaration]

Since is_vma_temporay_stack() is just used in rmap.c and huge_memory.c, it
is better to move it to huge_mm.h from rmap.h to avoid such errors.

Signed-off-by: Alex Shi <alex.shi@intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    2 ++
 include/linux/rmap.h    |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/huge_mm.h~mm-move-is_vma_temporary_stack-declaration-to-huge_mmh include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-move-is_vma_temporary_stack-declaration-to-huge_mmh
+++ a/include/linux/huge_mm.h
@@ -59,6 +59,8 @@ extern pmd_t *page_check_address_pmd(str
 #define HPAGE_PMD_MASK HPAGE_MASK
 #define HPAGE_PMD_SIZE HPAGE_SIZE
 
+extern bool is_vma_temporary_stack(struct vm_area_struct *vma);
+
 #define transparent_hugepage_enabled(__vma)				\
 	((transparent_hugepage_flags &					\
 	  (1<<TRANSPARENT_HUGEPAGE_FLAG) ||				\
diff -puN include/linux/rmap.h~mm-move-is_vma_temporary_stack-declaration-to-huge_mmh include/linux/rmap.h
--- a/include/linux/rmap.h~mm-move-is_vma_temporary_stack-declaration-to-huge_mmh
+++ a/include/linux/rmap.h
@@ -173,8 +173,6 @@ enum ttu_flags {
 };
 #define TTU_ACTION(x) ((x) & TTU_ACTION_MASK)
 
-bool is_vma_temporary_stack(struct vm_area_struct *vma);
