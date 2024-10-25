Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B912520EA27
	for <mm-commits@vger.kernel.org>; Fri, 25 Oct 2024 22:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729895565; cv=none; b=LwpAXLk/WhwoV/5NnOmGTuimcIcogK0OrCWLdifkaPXrCqn0Lp0AUDEa0F3myIA2GyLZpEk05yH3UPuvZSlXkZKo5AY+iPAxRiVjFjnNxJROpdqTdcplGs5eIyjknGB3o9yLr3CZAyO4YO1sinopnr0jJfeKvJ8BPu4hRGouVWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729895565; c=relaxed/simple;
	bh=822UsDiu/zLWqGimxzsJsVYBC7xXJq+4aDO9A2imwME=;
	h=Date:To:From:Subject:Message-Id; b=BwW3W91TARHjNjTawHY/lxyFwcjYQwE/m2RnQIy/AQu04frZEF3oCSTaWfp+kzASyMIvdKKsC2Quk2ddVFHtwQe5JQskxTm/ret3BmBKSGM3YWPBN+ALxjHaAjvSjSb9gOH4TkjzO6VQFZFTuD9ig1BrvAbfd8O/WpPT6Jstd0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vtBp6SEx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vtBp6SEx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42CF9C4CEE7;
	Fri, 25 Oct 2024 22:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729895565;
	bh=822UsDiu/zLWqGimxzsJsVYBC7xXJq+4aDO9A2imwME=;
	h=Date:To:From:Subject:From;
	b=vtBp6SExqEpIGPw2Hj3reJaxlXB3etmGnIQpEtizj2N6+9A4Q+b/Gb3DHL95Ju74t
	 OOvTqpdyJjPbUfEyOIRLYyFV6TixfxhsP0nTyYTThxyI0oCrewON6bVu4jBCxIMz1Q
	 HTsms+HrMKFUVTUpTaQ/Q+HR+Tgv7Vf8PHfAwX0U=
Date: Fri, 25 Oct 2024 15:32:44 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,torvalds@linux-foundation.org,peterx@redhat.com,Liam.Howlett@Oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-add-additional-vma_internalh-stubs.patch added to mm-unstable branch
Message-Id: <20241025223245.42CF9C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools: testing: add additional vma_internal.h stubs
has been added to the -mm mm-unstable branch.  Its filename is
     tools-testing-add-additional-vma_internalh-stubs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-add-additional-vma_internalh-stubs.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: tools: testing: add additional vma_internal.h stubs
Date: Fri, 25 Oct 2024 13:26:23 +0100

Patch series "fix error handling in mmap_region() and refactor", v3.

The mmap_region() function is somewhat terrifying, with spaghetti-like
control flow and numerous means by which issues can arise and incomplete
state, memory leaks and other unpleasantness can occur.

This series goes to great lengths to simplify how mmap_region() works and
to avoid unwinding errors late on in the process of setting up the VMA for
the new mapping, and equally avoids such operations occurring while the
VMA is in an inconsistent state.

This series builds on the previously submitted hotfix patches (see link to
v2 below) which addresses the most critical issues around mmap_region(),
and further works to improve mmap_region() complexity, stability, and
testability.

This series moves the code to mm/vma.c to render it userland testable,
refactors and simplifies it into smaller functions that are significantly
more readable.

It additionally avoids performing an attempt at a second merge mid-way
through allocating a new VMA, a dubious proposition at best and one that
is highly subject to subtle bugs.

Rather than do this, we simply note that we ought to retry the merge and
do this as a final step.


This patch (of 3):

Add some additional vma_internal.h stubs in preparation for
__mmap_region() being moved to mm/vma.c.  Without these the move would
result in the tests no longer compiling.

Link: https://lkml.kernel.org/r/cover.1729858176.git.lorenzo.stoakes@oracle.com
Link: https://lkml.kernel.org/r/74b27e159e261d2ac1fe66a130edad1d61fdc176.1729858176.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/vma/vma_internal.h |  115 ++++++++++++++++++++++++++++-
 1 file changed, 114 insertions(+), 1 deletion(-)

--- a/tools/testing/vma/vma_internal.h~tools-testing-add-additional-vma_internalh-stubs
+++ a/tools/testing/vma/vma_internal.h
@@ -44,7 +44,9 @@
 #define VM_LOCKED	0x00002000
 #define VM_IO           0x00004000
 #define VM_DONTEXPAND	0x00040000
+#define VM_LOCKONFAULT	0x00080000
 #define VM_ACCOUNT	0x00100000
+#define VM_NORESERVE	0x00200000
 #define VM_MIXEDMAP	0x10000000
 #define VM_STACK	VM_GROWSDOWN
 #define VM_SHADOW_STACK	VM_NONE
@@ -53,6 +55,14 @@
 #define VM_ACCESS_FLAGS (VM_READ | VM_WRITE | VM_EXEC)
 #define VM_SPECIAL (VM_IO | VM_DONTEXPAND | VM_PFNMAP | VM_MIXEDMAP)
 
+/* This mask represents all the VMA flag bits used by mlock */
+#define VM_LOCKED_MASK	(VM_LOCKED | VM_LOCKONFAULT)
+
+#ifdef CONFIG_64BIT
+/* VM is sealed, in vm_flags */
+#define VM_SEALED	_BITUL(63)
+#endif
+
 #define FIRST_USER_ADDRESS	0UL
 #define USER_PGTABLES_CEILING	0UL
 
@@ -698,8 +708,9 @@ static inline void tlb_finish_mmu(struct
 {
 }
 
-static inline void get_file(struct file *)
+static inline struct file *get_file(struct file *f)
 {
+	return f;
 }
 
 static inline int vma_dup_policy(struct vm_area_struct *, struct vm_area_struct *)
@@ -920,4 +931,106 @@ static inline bool signal_pending(void *
 	return false;
 }
 
+static inline bool is_file_hugepages(struct file *)
+{
+	return false;
+}
+
+static inline int security_vm_enough_memory_mm(struct mm_struct *, long)
+{
+	return true;
+}
+
+static inline bool may_expand_vm(struct mm_struct *, vm_flags_t, unsigned long)
+{
+	return true;
+}
+
+static inline void vm_flags_init(struct vm_area_struct *vma,
+				 vm_flags_t flags)
+{
+	vma->__vm_flags = flags;
+}
+
+static inline void vm_flags_set(struct vm_area_struct *vma,
+				vm_flags_t flags)
+{
+	vma_start_write(vma);
+	vma->__vm_flags |= flags;
+}
+
+static inline void vm_flags_clear(struct vm_area_struct *vma,
+				  vm_flags_t flags)
+{
+	vma_start_write(vma);
+	vma->__vm_flags &= ~flags;
+}
+
+static inline int call_mmap(struct file *, struct vm_area_struct *)
+{
+	return 0;
+}
+
+static inline int shmem_zero_setup(struct vm_area_struct *)
+{
+	return 0;
+}
+
+static inline void vma_set_anonymous(struct vm_area_struct *vma)
+{
+	vma->vm_ops = NULL;
+}
+
+static inline void ksm_add_vma(struct vm_area_struct *)
+{
+}
+
+static inline void perf_event_mmap(struct vm_area_struct *)
+{
+}
+
+static inline bool vma_is_dax(struct vm_area_struct *)
+{
+	return false;
+}
+
+static inline struct vm_area_struct *get_gate_vma(struct mm_struct *)
+{
+	return NULL;
+}
+
+bool vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot);
+
+/* Update vma->vm_page_prot to reflect vma->vm_flags. */
+static inline void vma_set_page_prot(struct vm_area_struct *vma)
+{
+	unsigned long vm_flags = vma->vm_flags;
+	pgprot_t vm_page_prot;
+
+	/* testing: we inline vm_pgprot_modify() to avoid clash with vma.h. */
+	vm_page_prot = pgprot_modify(vma->vm_page_prot, vm_get_page_prot(vm_flags));
+
+	if (vma_wants_writenotify(vma, vm_page_prot)) {
+		vm_flags &= ~VM_SHARED;
+		/* testing: we inline vm_pgprot_modify() to avoid clash with vma.h. */
+		vm_page_prot = pgprot_modify(vm_page_prot, vm_get_page_prot(vm_flags));
+	}
+	/* remove_protection_ptes reads vma->vm_page_prot without mmap_lock */
+	WRITE_ONCE(vma->vm_page_prot, vm_page_prot);
+}
+
+static inline bool arch_validate_flags(unsigned long)
+{
+	return true;
+}
+
+static inline void vma_close(struct vm_area_struct *)
+{
+}
+
+static inline int mmap_file(struct file *, struct vm_area_struct *)
+{
+	return 0;
+}
+
 #endif	/* __MM_VMA_INTERNAL_H */
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-avoid-unsafe-vma-hook-invocation-when-error-arises-on-mmap-hook.patch
mm-unconditionally-close-vmas-on-error.patch
mm-refactor-map_deny_write_exec.patch
mm-resolve-faulty-mmap_region-error-path-behaviour.patch
selftests-mm-add-pkey_sighandler_xx-hugetlb_dio-to-gitignore.patch
mm-refactor-mm_access-to-not-return-null.patch
mm-refactor-mm_access-to-not-return-null-fix.patch
mm-madvise-unrestrict-process_madvise-for-current-process.patch
maple_tree-do-not-hash-pointers-on-dump-in-debug-mode.patch
tools-testing-fix-phys_addr_t-size-on-64-bit-systems.patch
tools-testing-fix-phys_addr_t-size-on-64-bit-systems-fix.patch
tools-testing-add-additional-vma_internalh-stubs.patch
mm-isolate-mmap-internal-logic-to-mm-vmac.patch
mm-refactor-__mmap_region.patch
mm-remove-unnecessary-reset-state-logic-on-merge-new-vma.patch
mm-defer-second-attempt-at-merge-on-mmap.patch
mm-pagewalk-add-the-ability-to-install-ptes.patch
mm-add-pte_marker_guard-pte-marker.patch
mm-madvise-implement-lightweight-guard-page-mechanism.patch
mm-madvise-implement-lightweight-guard-page-mechanism-fix.patch
tools-testing-update-tools-uapi-header-for-mman-commonh.patch
selftests-mm-add-self-tests-for-guard-page-feature.patch

