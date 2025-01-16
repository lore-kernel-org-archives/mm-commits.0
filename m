Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5615717BEC6
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006268; cv=none; b=gwOQlGFF9QaFyidVHQl8qR8NdHIg7NxRIKXS52vi1jFZu2jfJUQer0BM1TxD6iYqnTD1MEjjuIOlp+JTJPLjcXulPYVfqWsNMUsg+qOVrigdQ9j5wHiyTxlOd8XJ0nFXO/9PkIExQ7iMhvsS0x032gR4SHuGTpsg+fYf0PzkS80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006268; c=relaxed/simple;
	bh=gH6hmBlBQf4mWbc43mXLvieuvxlnjtSRd3zT5i8FXmo=;
	h=Date:To:From:Subject:Message-Id; b=Afa59bVLS36+MWgHHcUEytGFEH/2epyAsurNF0zIWXUIBt2AwNkvvmOCOc+chk3xm+ty2HfwPL7zLXUnzFZ+bVmNQbrFn9DbEvbED4KIb7Nw/96/1eiCQ3vdmvpdZ0hRPeX4ug5TfynzUqngWR70rjkbQhw8KhCGf8lbUUc3Oqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gPHQmZrZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gPHQmZrZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B35EC4CED6;
	Thu, 16 Jan 2025 05:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006268;
	bh=gH6hmBlBQf4mWbc43mXLvieuvxlnjtSRd3zT5i8FXmo=;
	h=Date:To:From:Subject:From;
	b=gPHQmZrZ5g7XsiECbFXczzB465KekQjqHLT7O7I4DAVXwow/BGBGl9qo/rTS2F1U3
	 fWj6qehBtp01Ecx5/UDvS9rko/DYnxpsUNDHgCgddgfQbsOhjd+V/MJWNB4Fs3WTcs
	 H1nsWdcvVboy/ntWO1v7B4IQIGOYIbMvItY/tBVw=
Date: Wed, 15 Jan 2025 21:44:27 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tsbogend@alpha.franken.de,Liam.Howlett@Oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-make-mmap_region-internal.patch removed from -mm tree
Message-Id: <20250116054428.2B35EC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: make mmap_region() internal
has been removed from the -mm tree.  Its filename was
     mm-make-mmap_region-internal.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: make mmap_region() internal
Date: Thu, 2 Jan 2025 12:10:52 +0000

Now that we have removed the one user of mmap_region() outside of mm, make
it internal and add it to vma.c so it can be userland tested.

This ensures that all external memory mappings are performed using the
appropriate interfaces and allows us to modify memory mapping logic as we
see fit.

Additionally expand test stubs to allow for the mmap_region() code to
compile and be userland testable.

Link: https://lkml.kernel.org/r/de5a3c574d35c26237edf20a1d8652d7305709c9.1735819274.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h               |    3 -
 mm/mmap.c                        |   59 --------------------------
 mm/vma.c                         |   61 ++++++++++++++++++++++++++-
 mm/vma.h                         |    2 
 tools/testing/vma/vma_internal.h |   65 +++++++++++++++++++++++++++++
 5 files changed, 126 insertions(+), 64 deletions(-)

--- a/include/linux/mm.h~mm-make-mmap_region-internal
+++ a/include/linux/mm.h
@@ -3363,9 +3363,6 @@ get_unmapped_area(struct file *file, uns
 	return __get_unmapped_area(file, addr, len, pgoff, flags, 0);
 }
 
-extern unsigned long mmap_region(struct file *file, unsigned long addr,
-	unsigned long len, vm_flags_t vm_flags, unsigned long pgoff,
-	struct list_head *uf);
 extern unsigned long do_mmap(struct file *file, unsigned long addr,
 	unsigned long len, unsigned long prot, unsigned long flags,
 	vm_flags_t vm_flags, unsigned long pgoff, unsigned long *populate,
--- a/mm/mmap.c~mm-make-mmap_region-internal
+++ a/mm/mmap.c
@@ -1072,65 +1072,6 @@ int do_munmap(struct mm_struct *mm, unsi
 	return do_vmi_munmap(&vmi, mm, start, len, uf, false);
 }
 
-/**
- * mmap_region() - Actually perform the userland mapping of a VMA into
- * current->mm with known, aligned and overflow-checked @addr and @len, and
- * correctly determined VMA flags @vm_flags and page offset @pgoff.
- *
- * This is an internal memory management function, and should not be used
- * directly.
- *
- * The caller must write-lock current->mm->mmap_lock.
- *
- * @file: If a file-backed mapping, a pointer to the struct file describing the
- * file to be mapped, otherwise NULL.
- * @addr: The page-aligned address at which to perform the mapping.
- * @len: The page-aligned, non-zero, length of the mapping.
- * @vm_flags: The VMA flags which should be applied to the mapping.
- * @pgoff: If @file is specified, the page offset into the file, if not then
- * the virtual page offset in memory of the anonymous mapping.
- * @uf: Optionally, a pointer to a list head used for tracking userfaultfd unmap
- * events.
- *
- * Returns: Either an error, or the address at which the requested mapping has
- * been performed.
- */
-unsigned long mmap_region(struct file *file, unsigned long addr,
-			  unsigned long len, vm_flags_t vm_flags, unsigned long pgoff,
-			  struct list_head *uf)
-{
-	unsigned long ret;
-	bool writable_file_mapping = false;
-
-	mmap_assert_write_locked(current->mm);
-
-	/* Check to see if MDWE is applicable. */
-	if (map_deny_write_exec(vm_flags, vm_flags))
-		return -EACCES;
-
-	/* Allow architectures to sanity-check the vm_flags. */
-	if (!arch_validate_flags(vm_flags))
-		return -EINVAL;
-
-	/* Map writable and ensure this isn't a sealed memfd. */
-	if (file && is_shared_maywrite(vm_flags)) {
-		int error = mapping_map_writable(file->f_mapping);
-
-		if (error)
-			return error;
-		writable_file_mapping = true;
-	}
-
-	ret = __mmap_region(file, addr, len, vm_flags, pgoff, uf);
-
-	/* Clear our write mapping regardless of error. */
-	if (writable_file_mapping)
-		mapping_unmap_writable(file->f_mapping);
-
-	validate_mm(current->mm);
-	return ret;
-}
-
 int vm_munmap(unsigned long start, size_t len)
 {
 	return __vm_munmap(start, len, false);
--- a/mm/vma.c~mm-make-mmap_region-internal
+++ a/mm/vma.c
@@ -2431,7 +2431,7 @@ static void __mmap_complete(struct mmap_
 	vma_set_page_prot(vma);
 }
 
-unsigned long __mmap_region(struct file *file, unsigned long addr,
+static unsigned long __mmap_region(struct file *file, unsigned long addr,
 		unsigned long len, vm_flags_t vm_flags, unsigned long pgoff,
 		struct list_head *uf)
 {
@@ -2483,6 +2483,65 @@ abort_munmap:
 	return error;
 }
 
+/**
+ * mmap_region() - Actually perform the userland mapping of a VMA into
+ * current->mm with known, aligned and overflow-checked @addr and @len, and
+ * correctly determined VMA flags @vm_flags and page offset @pgoff.
+ *
+ * This is an internal memory management function, and should not be used
+ * directly.
+ *
+ * The caller must write-lock current->mm->mmap_lock.
+ *
+ * @file: If a file-backed mapping, a pointer to the struct file describing the
+ * file to be mapped, otherwise NULL.
+ * @addr: The page-aligned address at which to perform the mapping.
+ * @len: The page-aligned, non-zero, length of the mapping.
+ * @vm_flags: The VMA flags which should be applied to the mapping.
+ * @pgoff: If @file is specified, the page offset into the file, if not then
+ * the virtual page offset in memory of the anonymous mapping.
+ * @uf: Optionally, a pointer to a list head used for tracking userfaultfd unmap
+ * events.
+ *
+ * Returns: Either an error, or the address at which the requested mapping has
+ * been performed.
+ */
+unsigned long mmap_region(struct file *file, unsigned long addr,
+			  unsigned long len, vm_flags_t vm_flags, unsigned long pgoff,
+			  struct list_head *uf)
+{
+	unsigned long ret;
+	bool writable_file_mapping = false;
+
+	mmap_assert_write_locked(current->mm);
+
+	/* Check to see if MDWE is applicable. */
+	if (map_deny_write_exec(vm_flags, vm_flags))
+		return -EACCES;
+
+	/* Allow architectures to sanity-check the vm_flags. */
+	if (!arch_validate_flags(vm_flags))
+		return -EINVAL;
+
+	/* Map writable and ensure this isn't a sealed memfd. */
+	if (file && is_shared_maywrite(vm_flags)) {
+		int error = mapping_map_writable(file->f_mapping);
+
+		if (error)
+			return error;
+		writable_file_mapping = true;
+	}
+
+	ret = __mmap_region(file, addr, len, vm_flags, pgoff, uf);
+
+	/* Clear our write mapping regardless of error. */
+	if (writable_file_mapping)
+		mapping_unmap_writable(file->f_mapping);
+
+	validate_mm(current->mm);
+	return ret;
+}
+
 /*
  * do_brk_flags() - Increase the brk vma if the flags match.
  * @vmi: The vma iterator
--- a/mm/vma.h~mm-make-mmap_region-internal
+++ a/mm/vma.h
@@ -241,7 +241,7 @@ bool vma_wants_writenotify(struct vm_are
 int mm_take_all_locks(struct mm_struct *mm);
 void mm_drop_all_locks(struct mm_struct *mm);
 
-unsigned long __mmap_region(struct file *file, unsigned long addr,
+unsigned long mmap_region(struct file *file, unsigned long addr,
 		unsigned long len, vm_flags_t vm_flags, unsigned long pgoff,
 		struct list_head *uf);
 
--- a/tools/testing/vma/vma_internal.h~mm-make-mmap_region-internal
+++ a/tools/testing/vma/vma_internal.h
@@ -41,6 +41,8 @@ extern unsigned long dac_mmap_min_addr;
 #define VM_BUG_ON(_expr) (BUG_ON(_expr))
 #define VM_BUG_ON_VMA(_expr, _vma) (BUG_ON(_expr))
 
+#define MMF_HAS_MDWE	28
+
 #define VM_NONE		0x00000000
 #define VM_READ		0x00000001
 #define VM_WRITE	0x00000002
@@ -226,6 +228,8 @@ struct mm_struct {
 	unsigned long stack_vm;	   /* VM_STACK */
 
 	unsigned long def_flags;
+
+	unsigned long flags; /* Must use atomic bitops to access */
 };
 
 struct vma_lock {
@@ -1185,4 +1189,65 @@ static inline void userfaultfd_unmap_com
 {
 }
 
+/*
+ * Denies creating a writable executable mapping or gaining executable permissions.
+ *
+ * This denies the following:
+ *
+ *     a)      mmap(PROT_WRITE | PROT_EXEC)
+ *
+ *     b)      mmap(PROT_WRITE)
+ *             mprotect(PROT_EXEC)
+ *
+ *     c)      mmap(PROT_WRITE)
+ *             mprotect(PROT_READ)
+ *             mprotect(PROT_EXEC)
+ *
+ * But allows the following:
+ *
+ *     d)      mmap(PROT_READ | PROT_EXEC)
+ *             mmap(PROT_READ | PROT_EXEC | PROT_BTI)
+ *
+ * This is only applicable if the user has set the Memory-Deny-Write-Execute
+ * (MDWE) protection mask for the current process.
+ *
+ * @old specifies the VMA flags the VMA originally possessed, and @new the ones
+ * we propose to set.
+ *
+ * Return: false if proposed change is OK, true if not ok and should be denied.
+ */
+static inline bool map_deny_write_exec(unsigned long old, unsigned long new)
+{
+	/* If MDWE is disabled, we have nothing to deny. */
+	if (!test_bit(MMF_HAS_MDWE, &current->mm->flags))
+		return false;
+
+	/* If the new VMA is not executable, we have nothing to deny. */
+	if (!(new & VM_EXEC))
+		return false;
+
+	/* Under MDWE we do not accept newly writably executable VMAs... */
+	if (new & VM_WRITE)
+		return true;
+
+	/* ...nor previously non-executable VMAs becoming executable. */
+	if (!(old & VM_EXEC))
+		return true;
+
+	return false;
+}
+
+static inline int mapping_map_writable(struct address_space *mapping)
+{
+	int c = atomic_read(&mapping->i_mmap_writable);
+
+	/* Derived from the raw_atomic_inc_unless_negative() implementation. */
+	do {
+		if (c < 0)
+			return -EPERM;
+	} while (!__sync_bool_compare_and_swap(&mapping->i_mmap_writable, c, c+1));
+
+	return 0;
+}
+
 #endif	/* __MM_VMA_INTERNAL_H */
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are


