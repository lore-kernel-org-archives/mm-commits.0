Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86775674E
	for <mm-commits@vger.kernel.org>; Fri, 13 Dec 2024 02:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734058591; cv=none; b=bBHtrs717G69zyFuGvJQq7Wh2YTacXkBGc2o//vZY/fyjlEIcGasbcOpT91diIrFOI2qW4HxwHQNQvlJ2quyMNpwPkq0n6uGurKNnbE/27HSrpIdJrPvPU7t4rp4OIT+AMNhJVG+LpGNFhar5dxn0WAL2I7hia8nQn0WwMbzTOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734058591; c=relaxed/simple;
	bh=8K42qd98/yAn5STxTUNQNa3g/zp6NVtiO9I8kN2O80A=;
	h=Date:To:From:Subject:Message-Id; b=ce2jxnfUZbKRqb6Pd9EjDWU7vr0icVDrLn39D7fyBr+gZw5Sx/rr8k+1trwa2E+t0GUK/YxBfo2aJv3Oc0XzIC91lV6b5NvOXXckTkv0gx/IPD/EzY2Ziuqv3QMNqYGBb+dzY6eHbflkHtKTXvxWnLjN7vkaX+DxNAbed2OHiis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d89IBPVh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d89IBPVh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5E1C4CEDE;
	Fri, 13 Dec 2024 02:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734058590;
	bh=8K42qd98/yAn5STxTUNQNa3g/zp6NVtiO9I8kN2O80A=;
	h=Date:To:From:Subject:From;
	b=d89IBPVhkz8y1Bkvy1w88abxSiyQx4P8eTk2Ho7jDW1oZXdMhTZHgIFZRYZ9ZFave
	 UL0vjtooO8QevijZRO4R2zuGnENBnQK6wD6gPeBKq2nh14fMnk2lMnzcEkIiavgmXV
	 jth5imWMCSuAMcD4TmloipwCpvuJ7iDUJLa7GXtk=
Date: Thu, 12 Dec 2024 18:56:29 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,Liam.Howlett@Oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-comments-to-do_mmap-mmap_region-and-vm_mmap.patch added to mm-unstable branch
Message-Id: <20241213025630.8A5E1C4CEDE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add comments to do_mmap(), mmap_region() and vm_mmap()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-comments-to-do_mmap-mmap_region-and-vm_mmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-comments-to-do_mmap-mmap_region-and-vm_mmap.patch

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
Subject: mm: add comments to do_mmap(), mmap_region() and vm_mmap()
Date: Thu, 12 Dec 2024 11:31:52 +0000

It isn't always entirely clear to users the difference between do_mmap(),
mmap_region() and vm_mmap(), so add comments to clarify what's going on in
each.

This is compounded by the fact that we actually allow callers external to
mm to invoke both do_mmap() and mmap_region() (!), the latter of which is
really strictly speaking an internal memory mapping implementation detail.

Link: https://lkml.kernel.org/r/20241212113152.28849-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   79 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 mm/util.c |   17 +++++++++++
 2 files changed, 95 insertions(+), 1 deletion(-)

--- a/mm/mmap.c~mm-add-comments-to-do_mmap-mmap_region-and-vm_mmap
+++ a/mm/mmap.c
@@ -277,8 +277,62 @@ static inline bool file_mmap_ok(struct f
 	return true;
 }
 
-/*
+/**
+ * do_mmap() - Perform a userland memory mapping into the current process
+ * address space of length @len with protection bits @prot, mmap flags @flags
+ * (from which VMA flags will be inferred), and any additional VMA flags to
+ * apply @vm_flags. If this is a file-backed mapping then the file is specified
+ * in @file and page offset into the file via @pgoff.
+ *
+ * This function does not perform security checks on the file and assumes, if
+ * @uf is non-NULL, the caller has provided a list head to track unmap events
+ * for userfaultfd @uf.
+ *
+ * It also simply indicates whether memory population is required by setting
+ * @populate, which must be non-NULL, expecting the caller to actually perform
+ * this task itself if appropriate.
+ *
+ * This function will invoke architecture-specific (and if provided and
+ * relevant, file system-specific) logic to determine the most appropriate
+ * unmapped area in which to place the mapping if not MAP_FIXED.
+ *
+ * Callers which require userland mmap() behaviour should invoke vm_mmap(),
+ * which is also exported for module use.
+ *
+ * Those which require this behaviour less security checks, userfaultfd and
+ * populate behaviour, and who handle the mmap write lock themselves, should
+ * call this function.
+ *
+ * Note that the returned address may reside within a merged VMA if an
+ * appropriate merge were to take place, so it doesn't necessarily specify the
+ * start of a VMA, rather only the start of a valid mapped range of length
+ * @len bytes, rounded down to the nearest page size.
+ *
  * The caller must write-lock current->mm->mmap_lock.
+ *
+ * @file: An optional struct file pointer describing the file which is to be
+ * mapped, if a file-backed mapping.
+ * @addr: If non-zero, hints at (or if @flags has MAP_FIXED set, specifies) the
+ * address at which to perform this mapping. See mmap (2) for details. Must be
+ * page-aligned.
+ * @len: The length of the mapping. Will be page-aligned and must be at least 1
+ * page in size.
+ * @prot: Protection bits describing access required to the mapping. See mmap
+ * (2) for details.
+ * @flags: Flags specifying how the mapping should be performed, see mmap (2)
+ * for details.
+ * @vm_flags: VMA flags which should be set by default, or 0 otherwise.
+ * @pgoff: Page offset into the @file if file-backed, should be 0 otherwise.
+ * @populate: A pointer to a value which will be set to 0 if no population of
+ * the range is required, or the number of bytes to populate if it is. Must be
+ * non-NULL. See mmap (2) for details as to under what circumstances population
+ * of the range occurs.
+ * @uf: An optional pointer to a list head to track userfaultfd unmap events
+ * should unmapping events arise. If provided, it is up to the caller to manage
+ * this.
+ *
+ * Returns: Either an error, or the address at which the requested mapping has
+ * been performed.
  */
 unsigned long do_mmap(struct file *file, unsigned long addr,
 			unsigned long len, unsigned long prot,
@@ -1018,6 +1072,29 @@ int do_munmap(struct mm_struct *mm, unsi
 	return do_vmi_munmap(&vmi, mm, start, len, uf, false);
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
 unsigned long mmap_region(struct file *file, unsigned long addr,
 			  unsigned long len, vm_flags_t vm_flags, unsigned long pgoff,
 			  struct list_head *uf)
--- a/mm/util.c~mm-add-comments-to-do_mmap-mmap_region-and-vm_mmap
+++ a/mm/util.c
@@ -587,6 +587,23 @@ unsigned long vm_mmap_pgoff(struct file
 	return ret;
 }
 
+/*
+ * Perform a userland memory mapping into the current process address space. See
+ * the comment for do_mmap() for more details on this operation in general.
+ *
+ * This differs from do_mmap() in that:
+ *
+ * a. An offset parameter is provided rather than pgoff, which is both checked
+ *    for overflow and page alignment.
+ * b. mmap locking is performed on the caller's behalf.
+ * c. Userfaultfd unmap events and memory population are handled.
+ *
+ * This means that this function performs essentially the same work as if
+ * userland were invoking mmap (2).
+ *
+ * Returns either an error, or the address at which the requested mapping has
+ * been performed.
+ */
 unsigned long vm_mmap(struct file *file, unsigned long addr,
 	unsigned long len, unsigned long prot,
 	unsigned long flag, unsigned long offset)
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

docs-mm-add-vma-locks-documentation.patch
mm-reinstate-ability-to-map-write-sealed-memfd-mappings-read-only.patch
selftests-memfd-add-test-for-mapping-write-sealed-memfd-read-only.patch
mm-correctly-reference-merged-vma.patch
fork-avoid-inappropriate-uprobe-access-to-invalid-mm.patch
mm-vma-move-brk-internals-to-mm-vmac.patch
mm-vma-move-brk-internals-to-mm-vmac-fix.patch
mm-vma-move-unmapped_area-internals-to-mm-vmac.patch
mm-abstract-get_arg_page-stack-expansion-and-mmap-read-lock.patch
mm-vma-move-stack-expansion-logic-to-mm-vmac.patch
mm-vma-move-__vm_munmap-to-mm-vmac.patch
selftests-mm-add-fork-cow-guard-page-test.patch
mm-enforce-__must_check-on-vma-merge-and-split.patch
mm-perform-all-memfd-seal-checks-in-a-single-place.patch
mm-perform-all-memfd-seal-checks-in-a-single-place-fix.patch
maintainers-update-memory-mapping-section.patch
mm-assert-mmap-write-lock-held-on-do_mmap-mmap_region.patch
mm-add-comments-to-do_mmap-mmap_region-and-vm_mmap.patch

