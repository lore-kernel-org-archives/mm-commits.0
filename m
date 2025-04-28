Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44EF442AA6
	for <mm-commits@vger.kernel.org>; Mon, 28 Apr 2025 19:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745870026; cv=none; b=TAwWyyGBdesVgihWo37H9+baEs8HzTw0QQIV+4tRQYoIbbpiR300bo1a5Zxca6+nTDCRE35zFyfUL16pEqcnb2WrtRab55NkX0IpsONucqWS/2JqsQrDnlnYgmnd266NxVDiym6qeMmwzGTBKZsG4MA08OH2tqNn8ubLaDD+nc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745870026; c=relaxed/simple;
	bh=DUMKdGHlf0MWEowTOeLeL/eA4urg/rbcopoz8PJOPoc=;
	h=Date:To:From:Subject:Message-Id; b=bU81jgqASZ6DwMbMmESe8VfWUQ3DY3L7JKQcMbg9Y8P2n//RjHKd5MKbJyxREjH0zijpvHcn7HXcNodeDfMmk/HOqOcr2CKd+RSSi3Mkh15+D5w4OZj0UpjiuO87bpnF69E71ql44lv3WWKjd5S+sJ177Td9Raf+p+FmJF3B3q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kMJIZs24; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kMJIZs24"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6EF1C4CEE4;
	Mon, 28 Apr 2025 19:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745870025;
	bh=DUMKdGHlf0MWEowTOeLeL/eA4urg/rbcopoz8PJOPoc=;
	h=Date:To:From:Subject:From;
	b=kMJIZs24pz6zvuEh+ECxyzQGfPUJhCiSsbu/Wa5f9klRDkpmVfAKOAWbnT3MiSt2P
	 W2PWwrTYVVoilSssGZ+sMp64PlDG/QlyuSZtGYQiFt3SpWcGbQ9fWZ1Utt9CrTDzbt
	 5of9v+Z4FcgEJ8zrYqGrdL4BSXaWHv8yH0HY+nJs=
Date: Mon, 28 Apr 2025 12:53:45 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,pfalcato@suse.de,liam.howlett@oracle.com,kees@kernel.org,jannh@google.com,jack@suse.cz,david@redhat.com,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality.patch added to mm-new branch
Message-Id: <20250428195345.A6EF1C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: establish mm/vma_exec.c for shared exec/mm VMA functionality
has been added to the -mm mm-new branch.  Its filename is
     mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: establish mm/vma_exec.c for shared exec/mm VMA functionality
Date: Mon, 28 Apr 2025 16:28:14 +0100

Patch series "move all VMA allocation, freeing and duplication logic to
mm", v3.

Currently VMA allocation, freeing and duplication exist in kernel/fork.c,
which is a violation of separation of concerns, and leaves these functions
exposed to the rest of the kernel when they are in fact internal
implementation details.

Resolve this by moving this logic to mm, and making it internal to vma.c,
vma.h.

This also allows us, in future, to provide userland testing around this
functionality.

We additionally abstract dup_mmap() to mm, being careful to ensure
kernel/fork.c acceses this via the mm internal header so it is not exposed
elsewhere in the kernel.

As part of this change, also abstract initial stack allocation performed
in __bprm_mm_init() out of fs code into mm via the
create_init_stack_vma(), as this code uses vm_area_alloc() and
vm_area_free().

In order to do so sensibly, we introduce a new mm/vma_exec.c file, which
contains the code that is shared by mm and exec.  This file is added to
both memory mapping and exec sections in MAINTAINERS so both sets of
maintainers can maintain oversight.

As part of this change, we also move relocate_vma_down() to mm/vma_exec.c
so all shared mm/exec functionality is kept in one place.

We add code shared between nommu and mmu-enabled configurations in order
to share VMA allocation, freeing and duplication code correctly while also
keeping these functions available in userland VMA testing.

This is achieved by adding a mm/vma_init.c file which is also compiled by
the userland tests.


This patch (of 4):

There is functionality that overlaps the exec and memory mapping
subsystems.  While it properly belongs in mm, it is important that exec
maintainers maintain oversight of this functionality correctly.

We can establish both goals by adding a new mm/vma_exec.c file which
contains these 'glue' functions, and have fs/exec.c import them.

As a part of this change, to ensure that proper oversight is achieved, add
the file to both the MEMORY MAPPING and EXEC & BINFMT API, ELF sections.

scripts/get_maintainer.pl can correctly handle files in multiple entries
and this neatly handles the cross-over.

Link: https://lkml.kernel.org/r/cover.1745853549.git.lorenzo.stoakes@oracle.com
Link: https://lkml.kernel.org/r/91f2cee8f17d65214a9d83abb7011aa15f1ea690.1745853549.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                      |    2 
 fs/exec.c                        |    3 
 include/linux/mm.h               |    1 
 mm/Makefile                      |    2 
 mm/mmap.c                        |   83 --------------------------
 mm/vma.h                         |    5 +
 mm/vma_exec.c                    |   92 +++++++++++++++++++++++++++++
 tools/testing/vma/Makefile       |    2 
 tools/testing/vma/vma.c          |    1 
 tools/testing/vma/vma_internal.h |   40 ++++++++++++
 10 files changed, 145 insertions(+), 86 deletions(-)

--- a/fs/exec.c~mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality
+++ a/fs/exec.c
@@ -78,6 +78,9 @@
 
 #include <trace/events/sched.h>
 
+/* For vma exec functions. */
+#include "../mm/internal.h"
+
 static int bprm_creds_from_file(struct linux_binprm *bprm);
 
 int suid_dumpable = 0;
--- a/include/linux/mm.h~mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality
+++ a/include/linux/mm.h
@@ -3223,7 +3223,6 @@ void anon_vma_interval_tree_verify(struc
 extern int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin);
 extern int insert_vm_struct(struct mm_struct *, struct vm_area_struct *);
 extern void exit_mmap(struct mm_struct *);
-int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift);
 bool mmap_read_lock_maybe_expand(struct mm_struct *mm, struct vm_area_struct *vma,
 				 unsigned long addr, bool write);
 
--- a/MAINTAINERS~mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality
+++ a/MAINTAINERS
@@ -8830,6 +8830,7 @@ F:	include/linux/elf.h
 F:	include/uapi/linux/auxvec.h
 F:	include/uapi/linux/binfmts.h
 F:	include/uapi/linux/elf.h
+F:	mm/vma_exec.c
 F:	tools/testing/selftests/exec/
 N:	asm/elf.h
 N:	binfmt
@@ -15654,6 +15655,7 @@ F:	mm/mremap.c
 F:	mm/mseal.c
 F:	mm/vma.c
 F:	mm/vma.h
+F:	mm/vma_exec.c
 F:	mm/vma_internal.h
 F:	tools/testing/selftests/mm/merge.c
 F:	tools/testing/vma/
--- a/mm/Makefile~mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality
+++ a/mm/Makefile
@@ -37,7 +37,7 @@ mmu-y			:= nommu.o
 mmu-$(CONFIG_MMU)	:= highmem.o memory.o mincore.o \
 			   mlock.o mmap.o mmu_gather.o mprotect.o mremap.o \
 			   msync.o page_vma_mapped.o pagewalk.o \
-			   pgtable-generic.o rmap.o vmalloc.o vma.o
+			   pgtable-generic.o rmap.o vmalloc.o vma.o vma_exec.o
 
 
 ifdef CONFIG_CROSS_MEMORY_ATTACH
--- a/mm/mmap.c~mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality
+++ a/mm/mmap.c
@@ -1717,89 +1717,6 @@ static int __meminit init_reserve_notifi
 }
 subsys_initcall(init_reserve_notifier);
 
-/*
- * Relocate a VMA downwards by shift bytes. There cannot be any VMAs between
- * this VMA and its relocated range, which will now reside at [vma->vm_start -
- * shift, vma->vm_end - shift).
- *
- * This function is almost certainly NOT what you want for anything other than
- * early executable temporary stack relocation.
- */
-int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift)
-{
-	/*
-	 * The process proceeds as follows:
-	 *
-	 * 1) Use shift to calculate the new vma endpoints.
-	 * 2) Extend vma to cover both the old and new ranges.  This ensures the
-	 *    arguments passed to subsequent functions are consistent.
-	 * 3) Move vma's page tables to the new range.
-	 * 4) Free up any cleared pgd range.
-	 * 5) Shrink the vma to cover only the new range.
-	 */
-
-	struct mm_struct *mm = vma->vm_mm;
-	unsigned long old_start = vma->vm_start;
-	unsigned long old_end = vma->vm_end;
-	unsigned long length = old_end - old_start;
-	unsigned long new_start = old_start - shift;
-	unsigned long new_end = old_end - shift;
-	VMA_ITERATOR(vmi, mm, new_start);
-	VMG_STATE(vmg, mm, &vmi, new_start, old_end, 0, vma->vm_pgoff);
-	struct vm_area_struct *next;
-	struct mmu_gather tlb;
-	PAGETABLE_MOVE(pmc, vma, vma, old_start, new_start, length);
-
-	BUG_ON(new_start > new_end);
-
-	/*
-	 * ensure there are no vmas between where we want to go
-	 * and where we are
-	 */
-	if (vma != vma_next(&vmi))
-		return -EFAULT;
-
-	vma_iter_prev_range(&vmi);
-	/*
-	 * cover the whole range: [new_start, old_end)
-	 */
-	vmg.middle = vma;
-	if (vma_expand(&vmg))
-		return -ENOMEM;
-
-	/*
-	 * move the page tables downwards, on failure we rely on
-	 * process cleanup to remove whatever mess we made.
-	 */
-	pmc.for_stack = true;
-	if (length != move_page_tables(&pmc))
-		return -ENOMEM;
-
-	tlb_gather_mmu(&tlb, mm);
-	next = vma_next(&vmi);
-	if (new_end > old_start) {
-		/*
-		 * when the old and new regions overlap clear from new_end.
-		 */
-		free_pgd_range(&tlb, new_end, old_end, new_end,
-			next ? next->vm_start : USER_PGTABLES_CEILING);
-	} else {
-		/*
-		 * otherwise, clean from old_start; this is done to not touch
-		 * the address space in [new_end, old_start) some architectures
-		 * have constraints on va-space that make this illegal (IA64) -
-		 * for the others its just a little faster.
-		 */
-		free_pgd_range(&tlb, old_start, old_end, new_end,
-			next ? next->vm_start : USER_PGTABLES_CEILING);
-	}
-	tlb_finish_mmu(&tlb);
-
-	vma_prev(&vmi);
-	/* Shrink the vma to just the new range */
-	return vma_shrink(&vmi, vma, new_start, new_end, vma->vm_pgoff);
-}
-
 #ifdef CONFIG_MMU
 /*
  * Obtain a read lock on mm->mmap_lock, if the specified address is below the
diff --git a/mm/vma_exec.c a/mm/vma_exec.c
new file mode 100644
--- /dev/null
+++ a/mm/vma_exec.c
@@ -0,0 +1,92 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/*
+ * Functions explicitly implemented for exec functionality which however are
+ * explicitly VMA-only logic.
+ */
+
+#include "vma_internal.h"
+#include "vma.h"
+
+/*
+ * Relocate a VMA downwards by shift bytes. There cannot be any VMAs between
+ * this VMA and its relocated range, which will now reside at [vma->vm_start -
+ * shift, vma->vm_end - shift).
+ *
+ * This function is almost certainly NOT what you want for anything other than
+ * early executable temporary stack relocation.
+ */
+int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift)
+{
+	/*
+	 * The process proceeds as follows:
+	 *
+	 * 1) Use shift to calculate the new vma endpoints.
+	 * 2) Extend vma to cover both the old and new ranges.  This ensures the
+	 *    arguments passed to subsequent functions are consistent.
+	 * 3) Move vma's page tables to the new range.
+	 * 4) Free up any cleared pgd range.
+	 * 5) Shrink the vma to cover only the new range.
+	 */
+
+	struct mm_struct *mm = vma->vm_mm;
+	unsigned long old_start = vma->vm_start;
+	unsigned long old_end = vma->vm_end;
+	unsigned long length = old_end - old_start;
+	unsigned long new_start = old_start - shift;
+	unsigned long new_end = old_end - shift;
+	VMA_ITERATOR(vmi, mm, new_start);
+	VMG_STATE(vmg, mm, &vmi, new_start, old_end, 0, vma->vm_pgoff);
+	struct vm_area_struct *next;
+	struct mmu_gather tlb;
+	PAGETABLE_MOVE(pmc, vma, vma, old_start, new_start, length);
+
+	BUG_ON(new_start > new_end);
+
+	/*
+	 * ensure there are no vmas between where we want to go
+	 * and where we are
+	 */
+	if (vma != vma_next(&vmi))
+		return -EFAULT;
+
+	vma_iter_prev_range(&vmi);
+	/*
+	 * cover the whole range: [new_start, old_end)
+	 */
+	vmg.middle = vma;
+	if (vma_expand(&vmg))
+		return -ENOMEM;
+
+	/*
+	 * move the page tables downwards, on failure we rely on
+	 * process cleanup to remove whatever mess we made.
+	 */
+	pmc.for_stack = true;
+	if (length != move_page_tables(&pmc))
+		return -ENOMEM;
+
+	tlb_gather_mmu(&tlb, mm);
+	next = vma_next(&vmi);
+	if (new_end > old_start) {
+		/*
+		 * when the old and new regions overlap clear from new_end.
+		 */
+		free_pgd_range(&tlb, new_end, old_end, new_end,
+			next ? next->vm_start : USER_PGTABLES_CEILING);
+	} else {
+		/*
+		 * otherwise, clean from old_start; this is done to not touch
+		 * the address space in [new_end, old_start) some architectures
+		 * have constraints on va-space that make this illegal (IA64) -
+		 * for the others its just a little faster.
+		 */
+		free_pgd_range(&tlb, old_start, old_end, new_end,
+			next ? next->vm_start : USER_PGTABLES_CEILING);
+	}
+	tlb_finish_mmu(&tlb);
+
+	vma_prev(&vmi);
+	/* Shrink the vma to just the new range */
+	return vma_shrink(&vmi, vma, new_start, new_end, vma->vm_pgoff);
+}
--- a/mm/vma.h~mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality
+++ a/mm/vma.h
@@ -548,4 +548,9 @@ int expand_downwards(struct vm_area_stru
 
 int __vm_munmap(unsigned long start, size_t len, bool unlock);
 
+/* vma_exec.h */
+#ifdef CONFIG_MMU
+int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift);
+#endif
+
 #endif	/* __MM_VMA_H */
--- a/tools/testing/vma/Makefile~mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality
+++ a/tools/testing/vma/Makefile
@@ -9,7 +9,7 @@ include ../shared/shared.mk
 OFILES = $(SHARED_OFILES) vma.o maple-shim.o
 TARGETS = vma
 
-vma.o: vma.c vma_internal.h ../../../mm/vma.c ../../../mm/vma.h
+vma.o: vma.c vma_internal.h ../../../mm/vma.c ../../../mm/vma_exec.c ../../../mm/vma.h
 
 vma:	$(OFILES)
 	$(CC) $(CFLAGS) -o $@ $(OFILES) $(LDLIBS)
--- a/tools/testing/vma/vma.c~mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality
+++ a/tools/testing/vma/vma.c
@@ -28,6 +28,7 @@ unsigned long stack_guard_gap = 256UL<<P
  * Directly import the VMA implementation here. Our vma_internal.h wrapper
  * provides userland-equivalent functionality for everything vma.c uses.
  */
+#include "../../../mm/vma_exec.c"
 #include "../../../mm/vma.c"
 
 const struct vm_operations_struct vma_dummy_vm_ops;
--- a/tools/testing/vma/vma_internal.h~mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality
+++ a/tools/testing/vma/vma_internal.h
@@ -421,6 +421,28 @@ struct vm_unmapped_area_info {
 	unsigned long start_gap;
 };
 
+struct pagetable_move_control {
+	struct vm_area_struct *old; /* Source VMA. */
+	struct vm_area_struct *new; /* Destination VMA. */
+	unsigned long old_addr; /* Address from which the move begins. */
+	unsigned long old_end; /* Exclusive address at which old range ends. */
+	unsigned long new_addr; /* Address to move page tables to. */
+	unsigned long len_in; /* Bytes to remap specified by user. */
+
+	bool need_rmap_locks; /* Do rmap locks need to be taken? */
+	bool for_stack; /* Is this an early temp stack being moved? */
+};
+
+#define PAGETABLE_MOVE(name, old_, new_, old_addr_, new_addr_, len_)	\
+	struct pagetable_move_control name = {				\
+		.old = old_,						\
+		.new = new_,						\
+		.old_addr = old_addr_,					\
+		.old_end = (old_addr_) + (len_),			\
+		.new_addr = new_addr_,					\
+		.len_in = len_,						\
+	}
+
 static inline void vma_iter_invalidate(struct vma_iterator *vmi)
 {
 	mas_pause(&vmi->mas);
@@ -1240,4 +1262,22 @@ static inline int mapping_map_writable(s
 	return 0;
 }
 
+static inline unsigned long move_page_tables(struct pagetable_move_control *pmc)
+{
+	(void)pmc;
+
+	return 0;
+}
+
+static inline void free_pgd_range(struct mmu_gather *tlb,
+			unsigned long addr, unsigned long end,
+			unsigned long floor, unsigned long ceiling)
+{
+	(void)tlb;
+	(void)addr;
+	(void)end;
+	(void)floor;
+	(void)ceiling;
+}
+
 #endif	/* __MM_VMA_INTERNAL_H */
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-reverse-mapping-section.patch
maintainers-add-core-mm-section.patch
maintainers-add-mm-thp-section.patch
maintainers-add-mm-thp-section-fix.patch
tools-testing-selftests-fix-guard-region-test-tmpfs-assumption.patch
mm-vma-fix-incorrectly-disallowed-anonymous-vma-merges.patch
tools-testing-add-procmap_query-helper-functions-in-mm-self-tests.patch
tools-testing-selftests-assert-that-anon-merge-cases-behave-as-expected.patch
mm-move-mmap-vma-locking-logic-into-specific-files.patch
mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality.patch
mm-abstract-initial-stack-setup-to-mm-subsystem.patch
mm-move-dup_mmap-to-mm.patch
mm-perform-vma-allocation-freeing-duplication-in-mm.patch

