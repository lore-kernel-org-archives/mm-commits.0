From: akpm@linux-foundation.org
Subject: + mm-introduce-arch-specific-vma-flag-vm_arch_1.patch added to -mm tree
Date: Wed, 01 Aug 2012 15:28:39 -0700
Message-ID: <20120801222840.0142F1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:59553 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075Ab2HAW2m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 18:28:42 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so5494219obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 15:28:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, a.p.zijlstra@chello.nl, cmetcalf@tilera.com, cotte@de.ibm.com, eparis@redhat.com, gorcunov@openvz.org, hpa@zytor.com, hughd@google.com, james.l.morris@oracle.com, jbaron@redhat.com, matthltc@us.ibm.com, mingo@redhat.com, npiggin@kernel.dk, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, robert.richter@amd.com, suresh.b.siddha@intel.com, takedakn@nttdata.co.jp, torvalds@linux-foundation.org, venki@google.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: mm: introduce arch-specific vma flag VM_ARCH_1
has been added to the -mm tree.  Its filename is
     mm-introduce-arch-specific-vma-flag-vm_arch_1.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm: introduce arch-specific vma flag VM_ARCH_1

Combine several arch-specific vma flags into one.

before patch:

        0x00000200      0x01000000      0x20000000      0x40000000
x86     VM_NOHUGEPAGE   VM_HUGEPAGE     -               VM_PAT
powerpc -               -               VM_SAO          -
parisc  VM_GROWSUP      -               -               -
ia64    VM_GROWSUP      -               -               -
nommu   -               VM_MAPPED_COPY  -               -
others  -               -               -               -

after patch:

        0x00000200      0x01000000      0x20000000      0x40000000
x86     -               VM_PAT          VM_HUGEPAGE     VM_NOHUGEPAGE
powerpc -               VM_SAO          -               -
parisc  -               VM_GROWSUP      -               -
ia64    -               VM_GROWSUP      -               -
nommu   -               VM_MAPPED_COPY  -               -
others  -               VM_ARCH_1       -               -

And voila! One completely free bit.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Carsten Otte <cotte@de.ibm.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Eric Paris <eparis@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Morris <james.l.morris@oracle.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Venkatesh Pallipadi <venki@google.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   34 +++++++++++++++++++++-------------
 mm/huge_memory.c   |    2 +-
 mm/ksm.c           |    7 ++++++-
 3 files changed, 28 insertions(+), 15 deletions(-)

diff -puN include/linux/mm.h~mm-introduce-arch-specific-vma-flag-vm_arch_1 include/linux/mm.h
--- a/include/linux/mm.h~mm-introduce-arch-specific-vma-flag-vm_arch_1
+++ a/include/linux/mm.h
@@ -70,6 +70,8 @@ extern unsigned int kobjsize(const void 
 /*
  * vm_flags in vm_area_struct, see mm_types.h.
  */
+#define VM_NONE		0x00000000
+
 #define VM_READ		0x00000001	/* currently active flags */
 #define VM_WRITE	0x00000002
 #define VM_EXEC		0x00000004
@@ -82,12 +84,6 @@ extern unsigned int kobjsize(const void 
 #define VM_MAYSHARE	0x00000080
 
 #define VM_GROWSDOWN	0x00000100	/* general info on the segment */
-#if defined(CONFIG_STACK_GROWSUP) || defined(CONFIG_IA64)
-#define VM_GROWSUP	0x00000200
-#else
-#define VM_GROWSUP	0x00000000
-#define VM_NOHUGEPAGE	0x00000200	/* MADV_NOHUGEPAGE marked this vma */
-#endif
 #define VM_PFNMAP	0x00000400	/* Page-ranges managed without "struct page", just pure PFN */
 #define VM_DENYWRITE	0x00000800	/* ETXTBSY on write attempts.. */
 
@@ -106,20 +102,32 @@ extern unsigned int kobjsize(const void 
 #define VM_NORESERVE	0x00200000	/* should the VM suppress accounting */
 #define VM_HUGETLB	0x00400000	/* Huge TLB Page VM */
 #define VM_NONLINEAR	0x00800000	/* Is non-linear (remap_file_pages) */
-#ifndef CONFIG_TRANSPARENT_HUGEPAGE
-#define VM_MAPPED_COPY	0x01000000	/* T if mapped copy of data (nommu mmap) */
-#else
-#define VM_HUGEPAGE	0x01000000	/* MADV_HUGEPAGE marked this vma */
-#endif
+#define VM_ARCH_1	0x01000000	/* Architecture-specific flag */
 #define VM_INSERTPAGE	0x02000000	/* The vma has had "vm_insert_page()" done on it */
 #define VM_NODUMP	0x04000000	/* Do not include in the core dump */
 
 #define VM_CAN_NONLINEAR 0x08000000	/* Has ->fault & does nonlinear pages */
 #define VM_MIXEDMAP	0x10000000	/* Can contain "struct page" and pure PFN pages */
-#define VM_SAO		0x20000000	/* Strong Access Ordering (powerpc) */
-#define VM_PAT		0x40000000	/* PAT reserves whole VMA at once (x86) */
+#define VM_HUGEPAGE	0x20000000	/* MADV_HUGEPAGE marked this vma */
+#define VM_NOHUGEPAGE	0x40000000	/* MADV_NOHUGEPAGE marked this vma */
 #define VM_MERGEABLE	0x80000000	/* KSM may merge identical pages */
 
+#if defined(CONFIG_X86)
+# define VM_PAT		VM_ARCH_1	/* PAT reserves whole VMA at once (x86) */
+#elif defined(CONFIG_PPC)
+# define VM_SAO		VM_ARCH_1	/* Strong Access Ordering (powerpc) */
+#elif defined(CONFIG_PARISC)
+# define VM_GROWSUP	VM_ARCH_1
+#elif defined(CONFIG_IA64)
+# define VM_GROWSUP	VM_ARCH_1
+#elif !defined(CONFIG_MMU)
+# define VM_MAPPED_COPY	VM_ARCH_1	/* T if mapped copy of data (nommu mmap) */
+#endif
+
+#ifndef VM_GROWSUP
+# define VM_GROWSUP	VM_NONE
+#endif
+
 /* Bits set in the VMA until the stack is in its final location */
 #define VM_STACK_INCOMPLETE_SETUP	(VM_RAND_READ | VM_SEQ_READ)
 
diff -puN mm/huge_memory.c~mm-introduce-arch-specific-vma-flag-vm_arch_1 mm/huge_memory.c
--- a/mm/huge_memory.c~mm-introduce-arch-specific-vma-flag-vm_arch_1
+++ a/mm/huge_memory.c
@@ -1491,7 +1491,7 @@ out:
 	return ret;
 }
 
-#define VM_NO_THP (VM_SPECIAL|VM_INSERTPAGE|VM_MIXEDMAP|VM_SAO| \
+#define VM_NO_THP (VM_SPECIAL|VM_INSERTPAGE|VM_MIXEDMAP| \
 		   VM_HUGETLB|VM_SHARED|VM_MAYSHARE)
 
 int hugepage_madvise(struct vm_area_struct *vma,
diff -puN mm/ksm.c~mm-introduce-arch-specific-vma-flag-vm_arch_1 mm/ksm.c
--- a/mm/ksm.c~mm-introduce-arch-specific-vma-flag-vm_arch_1
+++ a/mm/ksm.c
@@ -1470,9 +1470,14 @@ int ksm_madvise(struct vm_area_struct *v
 		if (*vm_flags & (VM_MERGEABLE | VM_SHARED  | VM_MAYSHARE   |
 				 VM_PFNMAP    | VM_IO      | VM_DONTEXPAND |
 				 VM_RESERVED  | VM_HUGETLB | VM_INSERTPAGE |
-				 VM_NONLINEAR | VM_MIXEDMAP | VM_SAO))
+				 VM_NONLINEAR | VM_MIXEDMAP))
 			return 0;		/* just ignore the advice */
 
+#ifdef VM_SAO
+		if (*vm_flags & VM_SAO)
+			return 0;
+#endif
+
 		if (!test_bit(MMF_VM_MERGEABLE, &mm->flags)) {
 			err = __ksm_enter(mm);
 			if (err)
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
linux-next.patch
x86-pat-remove-the-dependency-on-vm_pgoff-in-track-untrack-pfn-vma-routines.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn-fix.patch
mm-x86-pat-rework-linear-pfn-mmap-tracking.patch
mm-introduce-arch-specific-vma-flag-vm_arch_1.patch
mm-kill-vma-flag-vm_insertpage.patch
mm-kill-vma-flag-vm_can_nonlinear.patch
mm-use-mm-exe_file-instead-of-first-vm_executable-vma-vm_file.patch
mm-kill-vma-flag-vm_executable-and-mm-num_exe_file_vmas.patch
mm-prepare-vm_dontdump-for-using-in-drivers.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter.patch

