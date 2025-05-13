Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7A51EEA3C
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119308; cv=none; b=deZaAtiXHsBISRfmO6NwLxMWmFnHaAxKm0VoSfIWu0kvlnNEDHu9Ptg//UkYpTaMhT3jdVOPZ+3cc7HDvlCfPSAZfZEQQnhGNsVSz2I9JFDT86lpx16IOe/2GJv2aYAFsEB/KMvF5L9MhFXy2AHc/yoLglbKUBYuAhO/3TQpGq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119308; c=relaxed/simple;
	bh=wydPqJab/da/TmddqduRBPqUjERNww4xp32dzsqFR1s=;
	h=Date:To:From:Subject:Message-Id; b=VnOtB/12A4eY8+zxeDzkRvDTf87+EUfrCP20kV1vkq8FlofyP2xBVRRC2smOf0rVqhTCK658VXzpoDtvOj33o3YUJLQIKgEZvsspwS42xrptX2OlOWJbUp09JlCEophfGXe64ISznRgG6S5r9h+QRJbdHxMT+qq2wgOFrOcURHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ubywMKRH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ubywMKRH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F21C4CEE4;
	Tue, 13 May 2025 06:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119308;
	bh=wydPqJab/da/TmddqduRBPqUjERNww4xp32dzsqFR1s=;
	h=Date:To:From:Subject:From;
	b=ubywMKRHYJKypvZzgvQBxRn87PsACfSWwW+1+eS2vW43SGxLFtMCqJziRH6Y25pcy
	 Ng1p6l6dGEHkaIhedAuPaTOd42Yv10lCm+WkCLkYhzdQE8edFNTdFja8DBPhbYf4Il
	 9mBPtiaJBF1DVBMDFiD6XwJGU8toOMlm8wSD5FcI=
Date: Mon, 12 May 2025 23:55:07 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,pfalcato@suse.de,Liam.Howlett@oracle.com,kees@kernel.org,jannh@google.com,jack@suse.cz,david@redhat.com,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-abstract-initial-stack-setup-to-mm-subsystem.patch removed from -mm tree
Message-Id: <20250513065508.25F21C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: abstract initial stack setup to mm subsystem
has been removed from the -mm tree.  Its filename was
     mm-abstract-initial-stack-setup-to-mm-subsystem.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: abstract initial stack setup to mm subsystem
Date: Mon, 28 Apr 2025 16:28:15 +0100

There are peculiarities within the kernel where what is very clearly mm
code is performed elsewhere arbitrarily.

This violates separation of concerns and makes it harder to refactor code
to make changes to how fundamental initialisation and operation of mm
logic is performed.

One such case is the creation of the VMA containing the initial stack upon
execve()'ing a new process.  This is currently performed in
__bprm_mm_init() in fs/exec.c.

Abstract this operation to create_init_stack_vma().  This allows us to
limit use of vma allocation and free code to fork and mm only.

We previously did the same for the step at which we relocate the initial
stack VMA downwards via relocate_vma_down(), now we move the initial VMA
establishment too.

Take the opportunity to also move insert_vm_struct() to mm/vma.c as it's
no longer needed anywhere outside of mm.

Link: https://lkml.kernel.org/r/118c950ef7a8dd19ab20a23a68c3603751acd30e.1745853549.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Kees Cook <kees@kernel.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c                        |   66 ++-------------------------
 mm/mmap.c                        |   42 -----------------
 mm/vma.c                         |   43 ++++++++++++++++++
 mm/vma.h                         |    4 +
 mm/vma_exec.c                    |   69 +++++++++++++++++++++++++++++
 tools/testing/vma/vma_internal.h |   32 +++++++++++++
 6 files changed, 153 insertions(+), 103 deletions(-)

--- a/fs/exec.c~mm-abstract-initial-stack-setup-to-mm-subsystem
+++ a/fs/exec.c
@@ -245,60 +245,6 @@ static void flush_arg_page(struct linux_
 	flush_cache_page(bprm->vma, pos, page_to_pfn(page));
 }
 
-static int __bprm_mm_init(struct linux_binprm *bprm)
-{
-	int err;
-	struct vm_area_struct *vma = NULL;
-	struct mm_struct *mm = bprm->mm;
-
-	bprm->vma = vma = vm_area_alloc(mm);
-	if (!vma)
-		return -ENOMEM;
-	vma_set_anonymous(vma);
-
-	if (mmap_write_lock_killable(mm)) {
-		err = -EINTR;
-		goto err_free;
-	}
-
-	/*
-	 * Need to be called with mmap write lock
-	 * held, to avoid race with ksmd.
-	 */
-	err = ksm_execve(mm);
-	if (err)
-		goto err_ksm;
-
-	/*
-	 * Place the stack at the largest stack address the architecture
-	 * supports. Later, we'll move this to an appropriate place. We don't
-	 * use STACK_TOP because that can depend on attributes which aren't
-	 * configured yet.
-	 */
-	BUILD_BUG_ON(VM_STACK_FLAGS & VM_STACK_INCOMPLETE_SETUP);
-	vma->vm_end = STACK_TOP_MAX;
-	vma->vm_start = vma->vm_end - PAGE_SIZE;
-	vm_flags_init(vma, VM_SOFTDIRTY | VM_STACK_FLAGS | VM_STACK_INCOMPLETE_SETUP);
-	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
-
-	err = insert_vm_struct(mm, vma);
-	if (err)
-		goto err;
-
-	mm->stack_vm = mm->total_vm = 1;
-	mmap_write_unlock(mm);
-	bprm->p = vma->vm_end - sizeof(void *);
-	return 0;
-err:
-	ksm_exit(mm);
-err_ksm:
-	mmap_write_unlock(mm);
-err_free:
-	bprm->vma = NULL;
-	vm_area_free(vma);
-	return err;
-}
-
 static bool valid_arg_len(struct linux_binprm *bprm, long len)
 {
 	return len <= MAX_ARG_STRLEN;
@@ -351,12 +297,6 @@ static void flush_arg_page(struct linux_
 {
 }
 
-static int __bprm_mm_init(struct linux_binprm *bprm)
-{
-	bprm->p = PAGE_SIZE * MAX_ARG_PAGES - sizeof(void *);
-	return 0;
-}
-
 static bool valid_arg_len(struct linux_binprm *bprm, long len)
 {
 	return len <= bprm->p;
@@ -385,9 +325,13 @@ static int bprm_mm_init(struct linux_bin
 	bprm->rlim_stack = current->signal->rlim[RLIMIT_STACK];
 	task_unlock(current->group_leader);
 
-	err = __bprm_mm_init(bprm);
+#ifndef CONFIG_MMU
+	bprm->p = PAGE_SIZE * MAX_ARG_PAGES - sizeof(void *);
+#else
+	err = create_init_stack_vma(bprm->mm, &bprm->vma, &bprm->p);
 	if (err)
 		goto err;
+#endif
 
 	return 0;
 
--- a/mm/mmap.c~mm-abstract-initial-stack-setup-to-mm-subsystem
+++ a/mm/mmap.c
@@ -1321,48 +1321,6 @@ destroy:
 	vm_unacct_memory(nr_accounted);
 }
 
-/* Insert vm structure into process list sorted by address
- * and into the inode's i_mmap tree.  If vm_file is non-NULL
- * then i_mmap_rwsem is taken here.
- */
-int insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
-{
-	unsigned long charged = vma_pages(vma);
-
-
-	if (find_vma_intersection(mm, vma->vm_start, vma->vm_end))
-		return -ENOMEM;
-
-	if ((vma->vm_flags & VM_ACCOUNT) &&
-	     security_vm_enough_memory_mm(mm, charged))
-		return -ENOMEM;
-
-	/*
-	 * The vm_pgoff of a purely anonymous vma should be irrelevant
-	 * until its first write fault, when page's anon_vma and index
-	 * are set.  But now set the vm_pgoff it will almost certainly
-	 * end up with (unless mremap moves it elsewhere before that
-	 * first wfault), so /proc/pid/maps tells a consistent story.
-	 *
-	 * By setting it to reflect the virtual start address of the
-	 * vma, merges and splits can happen in a seamless way, just
-	 * using the existing file pgoff checks and manipulations.
-	 * Similarly in do_mmap and in do_brk_flags.
-	 */
-	if (vma_is_anonymous(vma)) {
-		BUG_ON(vma->anon_vma);
-		vma->vm_pgoff = vma->vm_start >> PAGE_SHIFT;
-	}
-
-	if (vma_link(mm, vma)) {
-		if (vma->vm_flags & VM_ACCOUNT)
-			vm_unacct_memory(charged);
-		return -ENOMEM;
-	}
-
-	return 0;
-}
-
 /*
  * Return true if the calling process may expand its vm space by the passed
  * number of pages
--- a/mm/vma.c~mm-abstract-initial-stack-setup-to-mm-subsystem
+++ a/mm/vma.c
@@ -3052,3 +3052,46 @@ int __vm_munmap(unsigned long start, siz
 	userfaultfd_unmap_complete(mm, &uf);
 	return ret;
 }
+
+
+/* Insert vm structure into process list sorted by address
+ * and into the inode's i_mmap tree.  If vm_file is non-NULL
+ * then i_mmap_rwsem is taken here.
+ */
+int insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
+{
+	unsigned long charged = vma_pages(vma);
+
+
+	if (find_vma_intersection(mm, vma->vm_start, vma->vm_end))
+		return -ENOMEM;
+
+	if ((vma->vm_flags & VM_ACCOUNT) &&
+	     security_vm_enough_memory_mm(mm, charged))
+		return -ENOMEM;
+
+	/*
+	 * The vm_pgoff of a purely anonymous vma should be irrelevant
+	 * until its first write fault, when page's anon_vma and index
+	 * are set.  But now set the vm_pgoff it will almost certainly
+	 * end up with (unless mremap moves it elsewhere before that
+	 * first wfault), so /proc/pid/maps tells a consistent story.
+	 *
+	 * By setting it to reflect the virtual start address of the
+	 * vma, merges and splits can happen in a seamless way, just
+	 * using the existing file pgoff checks and manipulations.
+	 * Similarly in do_mmap and in do_brk_flags.
+	 */
+	if (vma_is_anonymous(vma)) {
+		BUG_ON(vma->anon_vma);
+		vma->vm_pgoff = vma->vm_start >> PAGE_SHIFT;
+	}
+
+	if (vma_link(mm, vma)) {
+		if (vma->vm_flags & VM_ACCOUNT)
+			vm_unacct_memory(charged);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
--- a/mm/vma_exec.c~mm-abstract-initial-stack-setup-to-mm-subsystem
+++ a/mm/vma_exec.c
@@ -90,3 +90,72 @@ int relocate_vma_down(struct vm_area_str
 	/* Shrink the vma to just the new range */
 	return vma_shrink(&vmi, vma, new_start, new_end, vma->vm_pgoff);
 }
+
+/*
+ * Establish the stack VMA in an execve'd process, located temporarily at the
+ * maximum stack address provided by the architecture.
+ *
+ * We later relocate this downwards in relocate_vma_down().
+ *
+ * This function is almost certainly NOT what you want for anything other than
+ * early executable initialisation.
+ *
+ * On success, returns 0 and sets *vmap to the stack VMA and *top_mem_p to the
+ * maximum addressable location in the stack (that is capable of storing a
+ * system word of data).
+ */
+int create_init_stack_vma(struct mm_struct *mm, struct vm_area_struct **vmap,
+			  unsigned long *top_mem_p)
+{
+	int err;
+	struct vm_area_struct *vma = vm_area_alloc(mm);
+
+	if (!vma)
+		return -ENOMEM;
+
+	vma_set_anonymous(vma);
+
+	if (mmap_write_lock_killable(mm)) {
+		err = -EINTR;
+		goto err_free;
+	}
+
+	/*
+	 * Need to be called with mmap write lock
+	 * held, to avoid race with ksmd.
+	 */
+	err = ksm_execve(mm);
+	if (err)
+		goto err_ksm;
+
+	/*
+	 * Place the stack at the largest stack address the architecture
+	 * supports. Later, we'll move this to an appropriate place. We don't
+	 * use STACK_TOP because that can depend on attributes which aren't
+	 * configured yet.
+	 */
+	BUILD_BUG_ON(VM_STACK_FLAGS & VM_STACK_INCOMPLETE_SETUP);
+	vma->vm_end = STACK_TOP_MAX;
+	vma->vm_start = vma->vm_end - PAGE_SIZE;
+	vm_flags_init(vma, VM_SOFTDIRTY | VM_STACK_FLAGS | VM_STACK_INCOMPLETE_SETUP);
+	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
+
+	err = insert_vm_struct(mm, vma);
+	if (err)
+		goto err;
+
+	mm->stack_vm = mm->total_vm = 1;
+	mmap_write_unlock(mm);
+	*vmap = vma;
+	*top_mem_p = vma->vm_end - sizeof(void *);
+	return 0;
+
+err:
+	ksm_exit(mm);
+err_ksm:
+	mmap_write_unlock(mm);
+err_free:
+	*vmap = NULL;
+	vm_area_free(vma);
+	return err;
+}
--- a/mm/vma.h~mm-abstract-initial-stack-setup-to-mm-subsystem
+++ a/mm/vma.h
@@ -548,8 +548,12 @@ int expand_downwards(struct vm_area_stru
 
 int __vm_munmap(unsigned long start, size_t len, bool unlock);
 
+int insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma);
+
 /* vma_exec.c */
 #ifdef CONFIG_MMU
+int create_init_stack_vma(struct mm_struct *mm, struct vm_area_struct **vmap,
+			  unsigned long *top_mem_p);
 int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift);
 #endif
 
--- a/tools/testing/vma/vma_internal.h~mm-abstract-initial-stack-setup-to-mm-subsystem
+++ a/tools/testing/vma/vma_internal.h
@@ -56,6 +56,8 @@ extern unsigned long dac_mmap_min_addr;
 #define VM_PFNMAP	0x00000400
 #define VM_LOCKED	0x00002000
 #define VM_IO           0x00004000
+#define VM_SEQ_READ	0x00008000	/* App will access data sequentially */
+#define VM_RAND_READ	0x00010000	/* App will not benefit from clustered reads */
 #define VM_DONTEXPAND	0x00040000
 #define VM_LOCKONFAULT	0x00080000
 #define VM_ACCOUNT	0x00100000
@@ -70,6 +72,20 @@ extern unsigned long dac_mmap_min_addr;
 #define VM_ACCESS_FLAGS (VM_READ | VM_WRITE | VM_EXEC)
 #define VM_SPECIAL (VM_IO | VM_DONTEXPAND | VM_PFNMAP | VM_MIXEDMAP)
 
+#ifdef CONFIG_STACK_GROWSUP
+#define VM_STACK	VM_GROWSUP
+#define VM_STACK_EARLY	VM_GROWSDOWN
+#else
+#define VM_STACK	VM_GROWSDOWN
+#define VM_STACK_EARLY	0
+#endif
+
+#define DEFAULT_MAP_WINDOW	((1UL << 47) - PAGE_SIZE)
+#define TASK_SIZE_LOW		DEFAULT_MAP_WINDOW
+#define TASK_SIZE_MAX		DEFAULT_MAP_WINDOW
+#define STACK_TOP		TASK_SIZE_LOW
+#define STACK_TOP_MAX		TASK_SIZE_MAX
+
 /* This mask represents all the VMA flag bits used by mlock */
 #define VM_LOCKED_MASK	(VM_LOCKED | VM_LOCKONFAULT)
 
@@ -82,6 +98,10 @@ extern unsigned long dac_mmap_min_addr;
 
 #define VM_STARTGAP_FLAGS (VM_GROWSDOWN | VM_SHADOW_STACK)
 
+#define VM_STACK_DEFAULT_FLAGS VM_DATA_DEFAULT_FLAGS
+#define VM_STACK_FLAGS	(VM_STACK | VM_STACK_DEFAULT_FLAGS | VM_ACCOUNT)
+#define VM_STACK_INCOMPLETE_SETUP (VM_RAND_READ | VM_SEQ_READ | VM_STACK_EARLY)
+
 #define RLIMIT_STACK		3	/* max stack size */
 #define RLIMIT_MEMLOCK		8	/* max locked-in-memory address space */
 
@@ -1280,4 +1300,16 @@ static inline void free_pgd_range(struct
 	(void)ceiling;
 }
 
+static inline int ksm_execve(struct mm_struct *mm)
+{
+	(void)mm;
+
+	return 0;
+}
+
+static inline void ksm_exit(struct mm_struct *mm)
+{
+	(void)mm;
+}
+
 #endif	/* __MM_VMA_INTERNAL_H */
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-update-page-allocator-section.patch
maintainers-add-mm-reclaim-section.patch

