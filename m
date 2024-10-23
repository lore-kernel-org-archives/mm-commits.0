Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46AA19EEA1
	for <mm-commits@vger.kernel.org>; Wed, 23 Oct 2024 10:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729678917; cv=none; b=cSAq8o8GuKmGjkSfs2yE27+Yw3eSRKoMVRmasDSydG8mc1edsgkbx++sO4e56CozIkwI7GOZdUwW1vi0+5tNAC6T+ZNniaQaf+oHFomAt5tn2bTtloh6r6NnElniu2sBrYwuRmHQnXE4GTO1KXeHF5WAFawRXF3hWdYRCmFykEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729678917; c=relaxed/simple;
	bh=LAvWfE8AIxwRP2WTvL5Q+FLZffw7y0BhLp666LQaumA=;
	h=Date:To:From:Subject:Message-Id; b=k1xU4YBXpuMAsYxq1emQLXDkI7YE7NJI0rOWLXh3w1hyrdSc8/uTaebjm4KhuKW/e8vl7GqPaE7tThcijQkie23l5Bewc3n88xH1CL35L8Co1cHCR+AwaUqXTpmZ2QtmwSLWeBST5zUZnmKZCR9IhC+NXNewyuM8eCE26+xpwhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TYr25HbT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TYr25HbT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48867C4CEC6;
	Wed, 23 Oct 2024 10:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729678917;
	bh=LAvWfE8AIxwRP2WTvL5Q+FLZffw7y0BhLp666LQaumA=;
	h=Date:To:From:Subject:From;
	b=TYr25HbT0m38ngsf1K3RHf+HBxw3z6grlqUUqSpg+NbZmgFn1Q2u0I5/MLprMNw69
	 dBnLNcckV0f/ZGdri2UmV3W/A7TDFRhlLPhz4cKPD2qOxKOhpN6cgFsBsr97Epnhf+
	 nYsybGikxq5R80qBZ2qaiiQKe+NsWrSABkJYuso4=
Date: Wed, 23 Oct 2024 03:21:56 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,torvalds@linux-foundation.org,stable@kernel.org,peterx@redhat.com,Liam.Howlett@Oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-add-additional-vma_internalh-stubs.patch added to mm-hotfixes-unstable branch
Message-Id: <20241023102157.48867C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools: testing: add additional vma_internal.h stubs
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     tools-testing-add-additional-vma_internalh-stubs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-add-additional-vma_internalh-stubs.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Date: Tue, 22 Oct 2024 21:40:56 +0100

Add some additional vma_internal.h stubs in preparation for
__mmap_region() being moved to mm/vma.c.  Without these the move would
result in the tests no longer compiling.

Link: https://lkml.kernel.org/r/1e039f29776bbb7df5878f3ac85ef6732f450fc6.1729628198.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/vma/vma_internal.h |  106 ++++++++++++++++++++++++++++-
 1 file changed, 105 insertions(+), 1 deletion(-)

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
@@ -920,4 +931,97 @@ static inline bool signal_pending(void *
 	return false;
 }
 
+static inline bool is_file_hugepages(struct file *)
+{
+	return false;
+}
+
+int security_vm_enough_memory_mm(struct mm_struct *, long)
+{
+	return true;
+}
+
+bool may_expand_vm(struct mm_struct *, vm_flags_t, unsigned long)
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
+static bool vma_is_dax(struct vm_area_struct *)
+{
+	return false;
+}
+
+struct vm_area_struct *get_gate_vma(struct mm_struct *)
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
 #endif	/* __MM_VMA_INTERNAL_H */
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

fork-do-not-invoke-uffd-on-fork-if-error-occurs.patch
fork-only-invoke-khugepaged-ksm-hooks-if-no-error.patch
mm-vma-add-expand-only-vma-merge-mode-and-optimise-do_brk_flags.patch
tools-testing-add-expand-only-mode-vma-test.patch
mm-avoid-unsafe-vma-hook-invocation-when-error-arises-on-mmap-hook.patch
mm-unconditionally-close-vmas-on-error.patch
mm-refactor-map_deny_write_exec.patch
mm-resolve-faulty-mmap_region-error-path-behaviour.patch
tools-testing-add-additional-vma_internalh-stubs.patch
mm-insolate-mmap-internal-logic-to-mm-vmac.patch
mm-refactor-__mmap_region.patch
mm-do-not-attempt-second-merge-for-file-backed-vmas.patch
selftests-mm-add-pkey_sighandler_xx-hugetlb_dio-to-gitignore.patch
mm-refactor-mm_access-to-not-return-null.patch
mm-refactor-mm_access-to-not-return-null-fix.patch
mm-madvise-unrestrict-process_madvise-for-current-process.patch
maple_tree-do-not-hash-pointers-on-dump-in-debug-mode.patch
tools-testing-fix-phys_addr_t-size-on-64-bit-systems.patch

