Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D803823C70A
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837070; cv=none; b=ijMR4cn3wAX/RqpU5z0YFD/Em5gJVQo9FxKOh80ebtqJ6fOCfJ/TmL4xu+7SmCx40Fl7fVtmmCGhAejYphGUVXsJs6mvWvkrYiJ9azazY5avNR4bA9RovEy4UQygt3MROXEIdBpKa7l73WqNJdid9AWNNfrF6BPirS67OJLb530=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837070; c=relaxed/simple;
	bh=N8A4QMhj+zs8pGTBj1KftqIMS2QP1jfHW4yRtpaUJ1U=;
	h=Date:To:From:Subject:Message-Id; b=IZGD3lx55JaGbUUvTk3woj9DJ9BtmnFBOkMtrwtMVTMc2Hf/0+7eRqOoMcQWgeRSSrMClKTWZdxovXK/Qe+FdHAq5ab5u4tRZVPdqwHE0o9cpwkqIF8t66eI7qbbhsfQrHP9nn/mE8O1QBWYBjUkrQcbLCfeulcDRF4IW2CTksc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AfazZBIA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AfazZBIA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A58BAC4CEDF;
	Tue, 14 Jan 2025 06:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837070;
	bh=N8A4QMhj+zs8pGTBj1KftqIMS2QP1jfHW4yRtpaUJ1U=;
	h=Date:To:From:Subject:From;
	b=AfazZBIAyWh1htgifxpEFa9HVI83gG5qxWb037fKZltEu7HucOclZ4W1sXbmqRgu0
	 rJgBjmdfxADo7yRqhr+XO/2+PuW1nc2V1+fnfkeE863jEpnpLlbsSILHOmHEeXho3i
	 hqKSHsEAoG79gCoP/aNgZMlY5VASUoCi8xrqLznI=
Date: Mon, 13 Jan 2025 22:44:30 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,Liam.Howlett@Oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-comments-to-do_mmap-mmap_region-and-vm_mmap.patch removed from -mm tree
Message-Id: <20250114064430.A58BAC4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add comments to do_mmap(), mmap_region() and vm_mmap()
has been removed from the -mm tree.  Its filename was
     mm-add-comments-to-do_mmap-mmap_region-and-vm_mmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -582,6 +582,23 @@ unsigned long vm_mmap_pgoff(struct file
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

mips-vdso-prefer-do_mmap-to-mmap_region.patch
mm-make-mmap_region-internal.patch

