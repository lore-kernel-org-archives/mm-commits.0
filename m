Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A085C3B14A1
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068049; cv=none; b=oSZL8qvhAOXM97BPE+kFK31BQIHzVitxMfqe0N2aR8limMUF2F977/d7FUbv3HRrL2+ze5vr94pTBBuYeEO3VBPO3vU0s2MWd3uIRXTekv4y6VDiQFcJZSlkjgGWJLwqhXRkCf7jZtyrg+slAUwItAXrpSbQMuVyiHVeez+CZQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068049; c=relaxed/simple;
	bh=ef1qv99/HiBcH5p1CUp9GDt/IkBJ2EG55lOV9gxRPbM=;
	h=Date:To:From:Subject:Message-Id; b=gaEyJYgf2v+7OhPNrfebeFFt4sQpbU9mLGwkNRIVeIJLwRSGlhByJJoJ5694tHS57BsVM8DfhbtYkDLHrbqrscmqOSlvaEUyp/s+8dRqnIqAE9RoXeHiqU0jxt7kZcGZZvWld9TPubOh5bUXgKT413+ybCO7k2vN5F1AAqQ6ZlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RG5EBcFf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RG5EBcFf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EA3D1F00AC4;
	Fri,  7 Aug 2026 02:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068043;
	bh=qAg5W80DHVpCEJI0aolhhSAEmNrgknOETk2aSxT7H1k=;
	h=Date:To:From:Subject;
	b=RG5EBcFfNMXPvC9smxpxe9rKC4+pY7c/QRy3pC8r2F6wmTtAxU4rEXzemfNmuxBvU
	 m5QBC/mPszOPqnUxdQVXwQqxo6eJdkC/pxL5IuCeifjnLCdUKDe6Jp4Yg5a3sxxB17
	 q9wpT65M5N9/RN0ndx43n2ACPxEoBdiD25WgBGvI=
Date: Thu, 06 Aug 2026 19:00:42 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,tzimmermann@suse.de,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,osalvador@suse.de,npache@redhat.com,muchun.song@linux.dev,lance.yang@linux.dev,jannh@google.com,jani.nikula@intel.com,jack@suse.cz,dev.jain@arm.com,david@kernel.org,brauner@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,airlied@gmail.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-update-do_mmap-to-use-vma_flags_t.patch removed from -mm tree
Message-Id: <20260807020043.1EA3D1F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: update do_mmap() to use vma_flags_t
has been removed from the -mm tree.  Its filename was
     mm-vma-update-do_mmap-to-use-vma_flags_t.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: mm/vma: update do_mmap() to use vma_flags_t
Date: Sat, 11 Jul 2026 19:44:59 +0100

The core do_mmap() function accepts a vm_flags_t parameter which it then
manipulates before passing to mmap_region() to do the heavy lifting of the
memory mapping.

Update do_mmap() to instead accept a vma_flags_t parameter, and adjust all
the logic within do_mmap() to manipulate this instead.

This is as part of the ongoing effort to convert VMA flags from a system
word size to a bitmap type which allows us to unrestrict the number of VMA
flags, as well as gain control over how VMA flag manipulation occurs.

We do not cascade these changes to all functions which accept vm_flags_t,
but rather use vma_flags_to_legacy() where necessary, specifically
deferring converting calc_vm_prot_bits(), calc_vm_flag_bits() and
__get_unmapped_area() to vma_flags_t.

Also utilise the new vma_flags_can_grow() predicate which correctly
handles the case of architectures without upward growing stacks.

As part of this change, introduce VMA_SHADOW_STACK so we can correctly
handle the case of the shadow stack not being defined.

No functional change intended.

Link: https://lore.kernel.org/20260711-b4-vma-flags-mm-v2-2-0fa2357d5431@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Dave Airlie <airlied@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nico Pache <npache@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/vdso.c |    4 +-
 fs/aio.c                |    2 -
 include/linux/memfd.h   |    6 +--
 include/linux/mm.h      |    6 ++-
 ipc/shm.c               |    3 +
 mm/memfd.c              |   15 +++-----
 mm/mmap.c               |   67 ++++++++++++++++++++++----------------
 mm/nommu.c              |    3 +
 mm/util.c               |   10 ++---
 mm/vma.c                |    7 +--
 mm/vma.h                |    2 -
 11 files changed, 69 insertions(+), 56 deletions(-)

--- a/arch/mips/kernel/vdso.c~mm-vma-update-do_mmap-to-use-vma_flags_t
+++ a/arch/mips/kernel/vdso.c
@@ -91,8 +91,8 @@ int arch_setup_additional_pages(struct l
 
 		/* Map delay slot emulation page */
 		base = do_mmap(NULL, STACK_TOP, PAGE_SIZE, PROT_READ | PROT_EXEC,
-			       MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, 0, 0, &unused,
-			       NULL);
+			       MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED,
+			       EMPTY_VMA_FLAGS, 0, &unused, NULL);
 		if (IS_ERR_VALUE(base)) {
 			ret = base;
 			goto out;
--- a/fs/aio.c~mm-vma-update-do_mmap-to-use-vma_flags_t
+++ a/fs/aio.c
@@ -604,7 +604,7 @@ static int aio_setup_ring(struct kioctx
 
 	ctx->mmap_base = do_mmap(ctx->aio_ring_file, 0, ctx->mmap_size,
 				 PROT_READ | PROT_WRITE,
-				 MAP_SHARED, 0, 0, &unused, NULL);
+				 MAP_SHARED, EMPTY_VMA_FLAGS, 0, &unused, NULL);
 	mmap_write_unlock(mm);
 	if (IS_ERR((void *)ctx->mmap_base)) {
 		ctx->mmap_size = 0;
--- a/include/linux/memfd.h~mm-vma-update-do_mmap-to-use-vma_flags_t
+++ a/include/linux/memfd.h
@@ -14,9 +14,9 @@ struct folio *memfd_alloc_folio(struct f
  * to sealing, or 0 otherwise.
  *
  * We also update VMA flags if appropriate by manipulating the VMA flags pointed
- * to by vm_flags_ptr.
+ * to by vma_flags_ptr.
  */
-int memfd_check_seals_mmap(struct file *file, vm_flags_t *vm_flags_ptr);
+int memfd_check_seals_mmap(struct file *file, vma_flags_t *vma_flags_ptr);
 struct file *memfd_alloc_file(const char *name, unsigned int flags);
 int memfd_get_seals(struct file *file);
 int memfd_add_seals(struct file *file, unsigned int seals);
@@ -30,7 +30,7 @@ static inline struct folio *memfd_alloc_
 	return ERR_PTR(-EINVAL);
 }
 static inline int memfd_check_seals_mmap(struct file *file,
-					 vm_flags_t *vm_flags_ptr)
+					 vma_flags_t *vma_flags_ptr)
 {
 	return 0;
 }
--- a/include/linux/mm.h~mm-vma-update-do_mmap-to-use-vma_flags_t
+++ a/include/linux/mm.h
@@ -465,9 +465,11 @@ enum {
 #if defined(CONFIG_X86_USER_SHADOW_STACK) || defined(CONFIG_ARM64_GCS) || \
 	defined(CONFIG_RISCV_USER_CFI)
 #define VM_SHADOW_STACK	INIT_VM_FLAG(SHADOW_STACK)
+#define VMA_SHADOW_STACK mk_vma_flags(VMA_SHADOW_STACK_BIT)
 #define VMA_STARTGAP_FLAGS mk_vma_flags(VMA_GROWSDOWN_BIT, VMA_SHADOW_STACK_BIT)
 #else
 #define VM_SHADOW_STACK	VM_NONE
+#define VMA_SHADOW_STACK EMPTY_VMA_FLAGS
 #define VMA_STARTGAP_FLAGS mk_vma_flags(VMA_GROWSDOWN_BIT)
 #endif
 #if defined(CONFIG_PPC64)
@@ -4198,9 +4200,9 @@ get_unmapped_area(struct file *file, uns
 	return __get_unmapped_area(file, addr, len, pgoff, flags, 0);
 }
 
-extern unsigned long do_mmap(struct file *file, unsigned long addr,
+unsigned long do_mmap(struct file *file, unsigned long addr,
 	unsigned long len, unsigned long prot, unsigned long flags,
-	vm_flags_t vm_flags, unsigned long pgoff, unsigned long *populate,
+	vma_flags_t vma_flags, unsigned long pgoff, unsigned long *populate,
 	struct list_head *uf);
 extern int do_vmi_munmap(struct vma_iterator *vmi, struct mm_struct *mm,
 			 unsigned long start, size_t len, struct list_head *uf,
--- a/ipc/shm.c~mm-vma-update-do_mmap-to-use-vma_flags_t
+++ a/ipc/shm.c
@@ -1661,7 +1661,8 @@ long do_shmat(int shmid, char __user *sh
 			goto invalid;
 	}
 
-	addr = do_mmap(file, addr, size, prot, flags, 0, 0, &populate, NULL);
+	addr = do_mmap(file, addr, size, prot, flags, EMPTY_VMA_FLAGS, 0,
+		       &populate, NULL);
 	*raddr = addr;
 	err = 0;
 	if (IS_ERR_VALUE(addr))
--- a/mm/memfd.c~mm-vma-update-do_mmap-to-use-vma_flags_t
+++ a/mm/memfd.c
@@ -370,39 +370,36 @@ static inline bool is_write_sealed(unsig
 	return seals & (F_SEAL_WRITE | F_SEAL_FUTURE_WRITE);
 }
 
-static int check_write_seal(vm_flags_t *vm_flags_ptr)
+static int check_write_seal(vma_flags_t *vma_flags_ptr)
 {
-	vm_flags_t vm_flags = *vm_flags_ptr;
-	vm_flags_t mask = vm_flags & (VM_SHARED | VM_WRITE);
-
 	/* If a private mapping then writability is irrelevant. */
-	if (!(mask & VM_SHARED))
+	if (!vma_flags_test(vma_flags_ptr, VMA_SHARED_BIT))
 		return 0;
 
 	/*
 	 * New PROT_WRITE and MAP_SHARED mmaps are not allowed when
 	 * write seals are active.
 	 */
-	if (mask & VM_WRITE)
+	if (vma_flags_test(vma_flags_ptr, VMA_WRITE_BIT))
 		return -EPERM;
 
 	/*
 	 * This is a read-only mapping, disallow mprotect() from making a
 	 * write-sealed mapping writable in future.
 	 */
-	*vm_flags_ptr &= ~VM_MAYWRITE;
+	vma_flags_clear(vma_flags_ptr, VMA_MAYWRITE_BIT);
 
 	return 0;
 }
 
-int memfd_check_seals_mmap(struct file *file, vm_flags_t *vm_flags_ptr)
+int memfd_check_seals_mmap(struct file *file, vma_flags_t *vma_flags_ptr)
 {
 	int err = 0;
 	unsigned int *seals_ptr = memfd_file_seals_ptr(file);
 	unsigned int seals = seals_ptr ? *seals_ptr : 0;
 
 	if (is_write_sealed(seals))
-		err = check_write_seal(vm_flags_ptr);
+		err = check_write_seal(vma_flags_ptr);
 
 	return err;
 }
--- a/mm/mmap.c~mm-vma-update-do_mmap-to-use-vma_flags_t
+++ a/mm/mmap.c
@@ -280,7 +280,7 @@ static inline bool file_mmap_ok(struct f
  * do_mmap() - Perform a userland memory mapping into the current process
  * address space of length @len with protection bits @prot, mmap flags @flags
  * (from which VMA flags will be inferred), and any additional VMA flags to
- * apply @vm_flags. If this is a file-backed mapping then the file is specified
+ * apply @vma_flags. If this is a file-backed mapping then the file is specified
  * in @file and page offset into the file via @pgoff.
  *
  * This function does not perform security checks on the file and assumes, if
@@ -320,7 +320,8 @@ static inline bool file_mmap_ok(struct f
  * (2) for details.
  * @flags: Flags specifying how the mapping should be performed, see mmap (2)
  * for details.
- * @vm_flags: VMA flags which should be set by default, or 0 otherwise.
+ * @vma_flags: VMA flags which should be set by default, or EMPTY_VMA_FLAGS
+ * otherwise.
  * @pgoff: Page offset into the @file if file-backed, should be 0 otherwise.
  * @populate: A pointer to a value which will be set to 0 if no population of
  * the range is required, or the number of bytes to populate if it is. Must be
@@ -335,7 +336,7 @@ static inline bool file_mmap_ok(struct f
  */
 unsigned long do_mmap(struct file *file, unsigned long addr,
 			unsigned long len, unsigned long prot,
-			unsigned long flags, vm_flags_t vm_flags,
+			unsigned long flags, vma_flags_t vma_flags,
 			unsigned long pgoff, unsigned long *populate,
 			struct list_head *uf)
 {
@@ -399,13 +400,19 @@ unsigned long do_mmap(struct file *file,
 	 * to. we assume access permissions have been handled by the open
 	 * of the memory object, so we don't do any here.
 	 */
-	vm_flags |= calc_vm_prot_bits(prot, pkey) | calc_vm_flag_bits(file, flags) |
-			mm->def_flags | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC;
+	vma_flags_set_mask(&vma_flags,
+			   legacy_to_vma_flags(calc_vm_prot_bits(prot, pkey)));
+	vma_flags_set_mask(&vma_flags,
+			   legacy_to_vma_flags(calc_vm_flag_bits(file, flags)));
+	vma_flags_set_mask(&vma_flags, mm->def_vma_flags);
+	vma_flags_set(&vma_flags, VMA_MAYREAD_BIT, VMA_MAYWRITE_BIT,
+		      VMA_MAYEXEC_BIT);
 
 	/* Obtain the address to map to. we verify (or select) it and ensure
 	 * that it represents a valid section of the address space.
 	 */
-	addr = __get_unmapped_area(file, addr, len, pgoff, flags, vm_flags);
+	addr = __get_unmapped_area(file, addr, len, pgoff, flags,
+				   vma_flags_to_legacy(vma_flags));
 	if (IS_ERR_VALUE(addr))
 		return addr;
 
@@ -418,7 +425,7 @@ unsigned long do_mmap(struct file *file,
 		if (!can_do_mlock())
 			return -EPERM;
 
-	if (!mlock_future_ok(mm, vm_flags & VM_LOCKED, len))
+	if (!mlock_future_ok(mm, vma_flags_test(&vma_flags, VMA_LOCKED_BIT), len))
 		return -EAGAIN;
 
 	if (file) {
@@ -461,22 +468,23 @@ unsigned long do_mmap(struct file *file,
 			if (IS_APPEND(inode) && (file->f_mode & FMODE_WRITE))
 				return -EACCES;
 
-			vm_flags |= VM_SHARED | VM_MAYSHARE;
+			vma_flags_set(&vma_flags, VMA_SHARED_BIT, VMA_MAYSHARE_BIT);
 			if (!(file->f_mode & FMODE_WRITE))
-				vm_flags &= ~(VM_MAYWRITE | VM_SHARED);
+				vma_flags_clear(&vma_flags, VMA_MAYWRITE_BIT,
+						VMA_SHARED_BIT);
 			fallthrough;
 		case MAP_PRIVATE:
 			if (!(file->f_mode & FMODE_READ))
 				return -EACCES;
 			if (path_noexec(&file->f_path)) {
-				if (vm_flags & VM_EXEC)
+				if (vma_flags_test(&vma_flags, VMA_EXEC_BIT))
 					return -EPERM;
-				vm_flags &= ~VM_MAYEXEC;
+				vma_flags_clear(&vma_flags, VMA_MAYEXEC_BIT);
 			}
 
 			if (!can_mmap_file(file))
 				return -ENODEV;
-			if (vm_flags & (VM_GROWSDOWN|VM_GROWSUP))
+			if (vma_flags_can_grow(&vma_flags))
 				return -EINVAL;
 			break;
 
@@ -488,23 +496,27 @@ unsigned long do_mmap(struct file *file,
 		 * Check to see if we are violating any seals and update VMA
 		 * flags if necessary to avoid future seal violations.
 		 */
-		err = memfd_check_seals_mmap(file, &vm_flags);
+		err = memfd_check_seals_mmap(file, &vma_flags);
 		if (err)
 			return (unsigned long)err;
 	} else {
 		switch (flags & MAP_TYPE) {
 		case MAP_SHARED:
-			if (vm_flags & (VM_GROWSDOWN|VM_GROWSUP))
+			if (vma_flags_can_grow(&vma_flags))
 				return -EINVAL;
 			/*
 			 * Ignore pgoff.
 			 */
 			pgoff = 0;
-			vm_flags |= VM_SHARED | VM_MAYSHARE;
+			vma_flags_set(&vma_flags, VMA_SHARED_BIT, VMA_MAYSHARE_BIT);
 			break;
-		case MAP_DROPPABLE:
-			if (VM_DROPPABLE == VM_NONE)
+		case MAP_DROPPABLE: {
+			vma_flags_t droppable = VMA_DROPPABLE;
+
+			if (vma_flags_empty(&droppable))
 				return -EOPNOTSUPP;
+			vma_flags_set_mask(&vma_flags, droppable);
+
 			/*
 			 * A locked or stack area makes no sense to be droppable.
 			 *
@@ -515,23 +527,24 @@ unsigned long do_mmap(struct file *file,
 			 */
 			if (flags & (MAP_LOCKED | MAP_HUGETLB))
 			        return -EINVAL;
-			if (vm_flags & (VM_GROWSDOWN | VM_GROWSUP))
+			if (vma_flags_can_grow(&vma_flags))
 			        return -EINVAL;
 
-			vm_flags |= VM_DROPPABLE;
-
 			/*
 			 * If the pages can be dropped, then it doesn't make
 			 * sense to reserve them.
 			 */
-			vm_flags |= VM_NORESERVE;
+			vma_flags_set(&vma_flags, VMA_NORESERVE_BIT);
 
 			/*
 			 * Likewise, they're volatile enough that they
 			 * shouldn't survive forks or coredumps.
 			 */
-			vm_flags |= VM_WIPEONFORK | VM_DONTDUMP;
+			vma_flags_set(&vma_flags, VMA_WIPEONFORK_BIT,
+				      VMA_DONTDUMP_BIT);
+
 			fallthrough;
+		}
 		case MAP_PRIVATE:
 			/*
 			 * Set pgoff according to addr for anon_vma.
@@ -550,16 +563,16 @@ unsigned long do_mmap(struct file *file,
 	if (flags & MAP_NORESERVE) {
 		/* We honor MAP_NORESERVE if allowed to overcommit */
 		if (sysctl_overcommit_memory != OVERCOMMIT_NEVER)
-			vm_flags |= VM_NORESERVE;
+			vma_flags_set(&vma_flags, VMA_NORESERVE_BIT);
 
 		/* hugetlb applies strict overcommit unless MAP_NORESERVE */
 		if (file && is_file_hugepages(file))
-			vm_flags |= VM_NORESERVE;
+			vma_flags_set(&vma_flags, VMA_NORESERVE_BIT);
 	}
 
-	addr = mmap_region(file, addr, len, vm_flags, pgoff, uf);
+	addr = mmap_region(file, addr, len, vma_flags, pgoff, uf);
 	if (!IS_ERR_VALUE(addr) &&
-	    ((vm_flags & VM_LOCKED) ||
+	    (vma_flags_test(&vma_flags, VMA_LOCKED_BIT) ||
 	     (flags & (MAP_POPULATE | MAP_NONBLOCK)) == MAP_POPULATE))
 		*populate = len;
 	return addr;
@@ -1191,7 +1204,7 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 	}
 
 	ret = do_mmap(vma->vm_file, start, size,
-			prot, flags, 0, pgoff, &populate, NULL);
+			prot, flags, EMPTY_VMA_FLAGS, pgoff, &populate, NULL);
 out:
 	mmap_write_unlock(mm);
 	fput(file);
--- a/mm/nommu.c~mm-vma-update-do_mmap-to-use-vma_flags_t
+++ a/mm/nommu.c
@@ -1014,11 +1014,12 @@ unsigned long do_mmap(struct file *file,
 			unsigned long len,
 			unsigned long prot,
 			unsigned long flags,
-			vm_flags_t vm_flags,
+			vma_flags_t vma_flags,
 			unsigned long pgoff,
 			unsigned long *populate,
 			struct list_head *uf)
 {
+	vm_flags_t vm_flags = vma_flags_to_legacy(vma_flags);
 	struct vm_area_struct *vma;
 	struct vm_region *region;
 	struct rb_node *rb;
--- a/mm/util.c~mm-vma-update-do_mmap-to-use-vma_flags_t
+++ a/mm/util.c
@@ -578,8 +578,8 @@ unsigned long vm_mmap_pgoff(struct file
 	if (!ret) {
 		if (mmap_write_lock_killable(mm))
 			return -EINTR;
-		ret = do_mmap(file, addr, len, prot, flag, 0, pgoff, &populate,
-			      &uf);
+		ret = do_mmap(file, addr, len, prot, flag, EMPTY_VMA_FLAGS, pgoff,
+			      &populate, &uf);
 		mmap_write_unlock(mm);
 		userfaultfd_unmap_complete(mm, &uf);
 		if (populate)
@@ -627,20 +627,20 @@ EXPORT_SYMBOL(vm_mmap);
 unsigned long vm_mmap_shadow_stack(unsigned long addr, unsigned long len,
 		unsigned long flags)
 {
+	vma_flags_t vma_flags = VMA_SHADOW_STACK;
 	struct mm_struct *mm = current->mm;
 	unsigned long ret, unused;
-	vm_flags_t vm_flags = VM_SHADOW_STACK;
 
 	flags |= MAP_ANONYMOUS | MAP_PRIVATE;
 	if (addr)
 		flags |= MAP_FIXED_NOREPLACE;
 
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
-		vm_flags |= VM_NOHUGEPAGE;
+		vma_flags_set(&vma_flags, VMA_NOHUGEPAGE_BIT);
 
 	mmap_write_lock(mm);
 	ret = do_mmap(NULL, addr, len, PROT_READ | PROT_WRITE, flags,
-		      vm_flags, 0, &unused, NULL);
+		      vma_flags, 0, &unused, NULL);
 	mmap_write_unlock(mm);
 
 	return ret;
--- a/mm/vma.c~mm-vma-update-do_mmap-to-use-vma_flags_t
+++ a/mm/vma.c
@@ -2883,7 +2883,7 @@ abort_munmap:
  * file to be mapped, otherwise NULL.
  * @addr: The page-aligned address at which to perform the mapping.
  * @len: The page-aligned, non-zero, length of the mapping.
- * @vm_flags: The VMA flags which should be applied to the mapping.
+ * @vma_flags: The VMA flags which should be applied to the mapping.
  * @pgoff: If @file is specified, the page offset into the file, if not then
  * the virtual page offset in memory of the anonymous mapping.
  * @uf: Optionally, a pointer to a list head used for tracking userfaultfd unmap
@@ -2893,12 +2893,11 @@ abort_munmap:
  * been performed.
  */
 unsigned long mmap_region(struct file *file, unsigned long addr,
-			  unsigned long len, vm_flags_t vm_flags,
+			  unsigned long len, vma_flags_t vma_flags,
 			  unsigned long pgoff, struct list_head *uf)
 {
 	unsigned long ret;
 	bool writable_file_mapping = false;
-	const vma_flags_t vma_flags = legacy_to_vma_flags(vm_flags);
 
 	mmap_assert_write_locked(current->mm);
 
@@ -2907,7 +2906,7 @@ unsigned long mmap_region(struct file *f
 		return -EACCES;
 
 	/* Allow architectures to sanity-check the vm_flags. */
-	if (!arch_validate_flags(vm_flags))
+	if (!arch_validate_flags(vma_flags_to_legacy(vma_flags)))
 		return -EINVAL;
 
 	/* Map writable and ensure this isn't a sealed memfd. */
--- a/mm/vma.h~mm-vma-update-do_mmap-to-use-vma_flags_t
+++ a/mm/vma.h
@@ -517,7 +517,7 @@ int mm_take_all_locks(struct mm_struct *
 void mm_drop_all_locks(struct mm_struct *mm);
 
 unsigned long mmap_region(struct file *file, unsigned long addr,
-		unsigned long len, vm_flags_t vm_flags, unsigned long pgoff,
+		unsigned long len, vma_flags_t vma_flags, unsigned long pgoff,
 		struct list_head *uf);
 
 int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *brkvma,
_

Patches currently in -mm which might be from ljs@kernel.org are

x86-mm-pat-acquire-init_mm-write-lock-on-collapse-to-avoid-uaf.patch
x86-mm-pat-acquire-init_mm-read-lock-on-attribute-change-to-avoid-uaf.patch
x86-mm-pat-allocate-split-page-tables-as-kernel-page-tables.patch
mm-vma-introduce-vma-anon-page-offset-field-and-add-helpers.patch
mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping.patch
mm-introduce-linear_anon_page_index.patch
mm-abstract-vma_address-and-introduce-vma_anon_address.patch
mm-update-print_bad_page_map-to-show-anon-index-if-appropriate.patch
mm-introduce-and-use-vma_filebacked_address.patch
mm-vma-fix-self-merge-check-in-copy_vma.patch
tools-testing-vma-add-tests-for-copy_vma-self-merge.patch
mm-propagate-vma-anonymous-page-offset-on-map-remap-split-merge.patch
mm-rmap-track-whether-the-page-vma-mapped-pgoff-is-anonymous.patch
mm-clean-up-vma_address_end.patch
mm-huge_memory-update-remove_migration_pmd-to-accept-a-folio.patch
mm-migrate-calculate-large-folio-page-index-using-pfn.patch
mm-rmap-use-anon-pgoff-to-track-map_private-file-backed-anon-folios.patch
tools-testing-vma-expand-vma-merge-tests-to-assert-anon-pgoff.patch
tools-testing-selftests-mm-test-anonymous-page-offset-merge-behaviour.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch
mm-add-some-missing-includes-to-mm-local-headers.patch

