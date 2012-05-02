From: akpm@linux-foundation.org
Subject: + mm-move-is_vma_temporary_stack-declaration-to-huge_mmh.patch added to -mm tree
Date: Wed, 02 May 2012 14:08:34 -0700
Message-ID: <20120502210834.E3AE9A0413@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:64678 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab2EBVIg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 May 2012 17:08:36 -0400
Received: by qcsp5 with SMTP id p5so122072qcs.1
        for <mm-commits@vger.kernel.org>; Wed, 02 May 2012 14:08:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alex.shi@intel.com, aarcange@redhat.com


The patch titled
     Subject: mm: move is_vma_temporary_stack() declaration to huge_mm.h
has been added to the -mm tree.  Its filename is
     mm-move-is_vma_temporary_stack-declaration-to-huge_mmh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
