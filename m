Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08522C15A0
	for <mm-commits@vger.kernel.org>; Mon, 19 Jan 2026 19:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768851277; cv=none; b=MkTANhNKK7CoRg8hLT1mUbD01gKFuuYBi8cnR1Zwq1Qm1KEnMOXDNzKQSa3hRBYQ+JMkFgHEZ+0NZ6QnYcG3PP2WXToQiL/SOD1qv54pLDVTUiF0HhPkL3YGLJgJj/cN0WJUjfAIlr5IJkE3fAOIHnwvZu/HbVXWn70y7krabZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768851277; c=relaxed/simple;
	bh=mUA3KQjP8vIGN2fl3fEgoatTjtsQTVyChPhm808ZaZs=;
	h=Date:To:From:Subject:Message-Id; b=Dk8we0ZaZ0d9eCNGaiCTsjKjeFBA15EYr0IjWYwe7FUAV9IaUaZr4R5xwSJ7CX0CZkFkb2sNfL2yOYwlLCSd8NHYv01zowx2ja3j52zmjKMrUBuZGdfCVKpgkPeb9+Esqa7kk/oj2fuc5glRoBPZ6tkTQhvEdlmI7MTlSIbui7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Bbj5AfGV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bbj5AfGV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54247C116C6;
	Mon, 19 Jan 2026 19:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768851277;
	bh=mUA3KQjP8vIGN2fl3fEgoatTjtsQTVyChPhm808ZaZs=;
	h=Date:To:From:Subject:From;
	b=Bbj5AfGVcPmdtpm5QmRmMiImsJlHzo3ev0EzCUsxy5LfUZ5SS0BGuKrq6SXDklmKN
	 xjDydZ+8YEFX4BfSxIeM7HJhMfWxy+IqfuRkORGWi/G40VtembDuaWkUMNW8Q0fwf5
	 wLf5TNVqCeIw0Z23kHQnRVT4GZ0vN+kL1/yHPd3o=
Date: Mon, 19 Jan 2026 11:34:36 -0800
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-update-all-remaining-mmap_prepare-users-to-use-vma_flags_t.patch added to mm-new branch
Message-Id: <20260119193437.54247C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: update all remaining mmap_prepare users to use vma_flags_t
has been added to the -mm mm-new branch.  Its filename is
     mm-update-all-remaining-mmap_prepare-users-to-use-vma_flags_t.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-update-all-remaining-mmap_prepare-users-to-use-vma_flags_t.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: update all remaining mmap_prepare users to use vma_flags_t
Date: Mon, 19 Jan 2026 14:48:59 +0000

We will be shortly removing the vm_flags_t field from vm_area_desc so we
need to update all mmap_prepare users to only use the dessc->vma_flags
field.

This patch achieves that and makes all ancillary changes required to make
this possible.

This lays the groundwork for future work to eliminate the use of
vm_flags_t in vm_area_desc altogether and more broadly throughout the
kernel.

While we're here, we take the opportunity to replace VM_REMAP_FLAGS with
VMA_REMAP_FLAGS, the vma_flags_t equivalent.

No functional changes intended.

Link: https://lkml.kernel.org/r/f4f9bc314c27e8187cb83667b7fd88634f3c27ba.1768834061.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c       |    6 +++---
 drivers/dax/device.c     |   10 +++++-----
 fs/aio.c                 |    2 +-
 fs/erofs/data.c          |    5 +++--
 fs/ext4/file.c           |    4 ++--
 fs/ntfs3/file.c          |    2 +-
 fs/orangefs/file.c       |    4 ++--
 fs/ramfs/file-nommu.c    |    2 +-
 fs/resctrl/pseudo_lock.c |    2 +-
 fs/romfs/mmap-nommu.c    |    2 +-
 fs/xfs/xfs_file.c        |    4 ++--
 fs/zonefs/file.c         |    3 ++-
 include/linux/dax.h      |    4 ++--
 include/linux/mm.h       |   24 +++++++++++++++++++-----
 kernel/relay.c           |    2 +-
 mm/memory.c              |   17 ++++++++---------
 16 files changed, 54 insertions(+), 39 deletions(-)

--- a/drivers/char/mem.c~mm-update-all-remaining-mmap_prepare-users-to-use-vma_flags_t
+++ a/drivers/char/mem.c
@@ -306,7 +306,7 @@ static unsigned zero_mmap_capabilities(s
 /* can't do an in-place private mapping if there's no MMU */
 static inline int private_mapping_ok(struct vm_area_desc *desc)
 {
-	return is_nommu_shared_mapping(desc->vm_flags);
+	return is_nommu_shared_vma_flags(desc->vma_flags);
 }
 #else
 
@@ -360,7 +360,7 @@ static int mmap_mem_prepare(struct vm_ar
 
 	desc->vm_ops = &mmap_mem_ops;
 
-	/* Remap-pfn-range will mark the range VM_IO. */
+	/* Remap-pfn-range will mark the range with the I/O flag. */
 	mmap_action_remap_full(desc, desc->pgoff);
 	/* We filter remap errors to -EAGAIN. */
 	desc->action.error_hook = mmap_filter_error;
@@ -520,7 +520,7 @@ static int mmap_zero_prepare(struct vm_a
 #ifndef CONFIG_MMU
 	return -ENOSYS;
 #endif
-	if (desc->vm_flags & VM_SHARED)
+	if (vma_desc_test_flags(desc, VMA_SHARED_BIT))
 		return shmem_zero_setup_desc(desc);
 
 	desc->action.success_hook = mmap_zero_private_success;
--- a/drivers/dax/device.c~mm-update-all-remaining-mmap_prepare-users-to-use-vma_flags_t
+++ a/drivers/dax/device.c
@@ -13,7 +13,7 @@
 #include "dax-private.h"
 #include "bus.h"
 
-static int __check_vma(struct dev_dax *dev_dax, vm_flags_t vm_flags,
+static int __check_vma(struct dev_dax *dev_dax, vma_flags_t flags,
 		       unsigned long start, unsigned long end, struct file *file,
 		       const char *func)
 {
@@ -24,7 +24,7 @@ static int __check_vma(struct dev_dax *d
 		return -ENXIO;
 
 	/* prevent private mappings from being established */
-	if ((vm_flags & VM_MAYSHARE) != VM_MAYSHARE) {
+	if (!vma_flags_test(flags, VMA_MAYSHARE_BIT)) {
 		dev_info_ratelimited(dev,
 				"%s: %s: fail, attempted private mapping\n",
 				current->comm, func);
@@ -53,7 +53,7 @@ static int __check_vma(struct dev_dax *d
 static int check_vma(struct dev_dax *dev_dax, struct vm_area_struct *vma,
 		     const char *func)
 {
-	return __check_vma(dev_dax, vma->vm_flags, vma->vm_start, vma->vm_end,
+	return __check_vma(dev_dax, vma->flags, vma->vm_start, vma->vm_end,
 			   vma->vm_file, func);
 }
 
@@ -306,14 +306,14 @@ static int dax_mmap_prepare(struct vm_ar
 	 * fault time.
 	 */
 	id = dax_read_lock();
-	rc = __check_vma(dev_dax, desc->vm_flags, desc->start, desc->end, filp,
+	rc = __check_vma(dev_dax, desc->vma_flags, desc->start, desc->end, filp,
 			 __func__);
 	dax_read_unlock(id);
 	if (rc)
 		return rc;
 
 	desc->vm_ops = &dax_vm_ops;
-	desc->vm_flags |= VM_HUGEPAGE;
+	vma_desc_set_flags(desc, VMA_HUGEPAGE_BIT);
 	return 0;
 }
 
--- a/fs/aio.c~mm-update-all-remaining-mmap_prepare-users-to-use-vma_flags_t
+++ a/fs/aio.c
@@ -394,7 +394,7 @@ static const struct vm_operations_struct
 
 static int aio_ring_mmap_prepare(struct vm_area_desc *desc)
 {
-	desc->vm_flags |= VM_DONTEXPAND;
+	vma_desc_set_flags(desc, VMA_DONTEXPAND_BIT);
 	desc->vm_ops = &aio_ring_vm_ops;
 	return 0;
 }
--- a/fs/erofs/data.c~mm-update-all-remaining-mmap_prepare-users-to-use-vma_flags_t
+++ a/fs/erofs/data.c
@@ -438,11 +438,12 @@ static int erofs_file_mmap_prepare(struc
 	if (!IS_DAX(file_inode(desc->file)))
 		return generic_file_readonly_mmap_prepare(desc);
 
-	if ((desc->vm_flags & VM_SHARED) && (desc->vm_flags & VM_MAYWRITE))
+	if (vma_desc_test_flags(desc, VMA_SHARED_BIT) &&
+	    vma_desc_test_flags(desc, VMA_MAYWRITE_BIT))
 		return -EINVAL;
 
 	desc->vm_ops = &erofs_dax_vm_ops;
-	desc->vm_flags |= VM_HUGEPAGE;
+	vma_desc_set_flags(desc, VMA_HUGEPAGE_BIT);
 	return 0;
 }
 #else
--- a/fs/ext4/file.c~mm-update-all-remaining-mmap_prepare-users-to-use-vma_flags_t
+++ a/fs/ext4/file.c
@@ -822,13 +822,13 @@ static int ext4_file_mmap_prepare(struct
 	 * We don't support synchronous mappings for non-DAX files and
 	 * for DAX files if underneath dax_device is not synchronous.
 	 */
-	if (!daxdev_mapping_supported(desc->vm_flags, file_inode(file), dax_dev))
+	if (!daxdev_mapping_supported(desc->vma_flags, file_inode(file), dax_dev))
 		return -EOPNOTSUPP;
 
 	file_accessed(file);
 	if (IS_DAX(file_inode(file))) {
 		desc->vm_ops = &ext4_dax_vm_ops;
-		desc->vm_flags |= VM_HUGEPAGE;
+		vma_desc_set_flags(desc, VMA_HUGEPAGE_BIT);
 	} else {
 		desc->vm_ops = &ext4_file_vm_ops;
 	}
--- a/fs/ntfs3/file.c~mm-update-all-remaining-mmap_prepare-users-to-use-vma_flags_t
+++ a/fs/ntfs3/file.c
@@ -347,7 +347,7 @@ static int ntfs_file_mmap_prepare(struct
 	struct inode *inode = file_inode(file);
 	struct ntfs_inode *ni = ntfs_i(inode);
 	u64 from = ((u64)desc->pgoff << PAGE_SHIFT);
-	bool rw = desc->vm_flags & VM_WRITE;
+	const bool rw = vma_desc_test_flags(desc, VMA_WRITE_BIT);
 	int err;
 
 	/* Avoid any operation if inode is bad. */
--- a/fs/orangefs/file.c~mm-update-all-remaining-mmap_prepare-users-to-use-vma_flags_t
+++ a/fs/orangefs/file.c
@@ -411,8 +411,8 @@ static int orangefs_file_mmap_prepare(st
 		     "orangefs_file_mmap: called on %pD\n", file);
 
 	/* set the sequential readahead hint */
-	desc->vm_flags |= VM_SEQ_READ;
-	desc->vm_flags &= ~VM_RAND_READ;
+	vma_desc_set_flags(desc, VMA_SEQ_READ_BIT);
+	vma_desc_clear_flags(desc, VMA_RAND_READ_BIT);
 
 	file_accessed(file);
 	desc->vm_ops = &orangefs_file_vm_ops;
--- a/fs/ramfs/file-nommu.c~mm-update-all-remaining-mmap_prepare-users-to-use-vma_flags_t
+++ a/fs/ramfs/file-nommu.c
@@ -264,7 +264,7 @@ out:
  */
 static int ramfs_nommu_mmap_prepare(struct vm_area_desc *desc)
 {
-	if (!is_nommu_shared_mapping(desc->vm_flags))
+	if (!is_nommu_shared_vma_flags(desc->vma_flags))
 		return -ENOSYS;
 
 	file_accessed(desc->file);
--- a/fs/resctrl/pseudo_lock.c~mm-update-all-remaining-mmap_prepare-users-to-use-vma_flags_t
+++ a/fs/resctrl/pseudo_lock.c
@@ -1044,7 +1044,7 @@ static int pseudo_lock_dev_mmap_prepare(
 	 * Ensure changes are carried directly to the memory being mapped,
 	 * do not allow copy-on-write mapping.
 	 */
-	if (!(desc->vm_flags & VM_SHARED)) {
+	if (!vma_desc_test_flags(desc, VMA_SHARED_BIT)) {
 		mutex_unlock(&rdtgroup_mutex);
 		return -EINVAL;
 	}
--- a/fs/romfs/mmap-nommu.c~mm-update-all-remaining-mmap_prepare-users-to-use-vma_flags_t
+++ a/fs/romfs/mmap-nommu.c
@@ -63,7 +63,7 @@ static unsigned long romfs_get_unmapped_
  */
 static int romfs_mmap_prepare(struct vm_area_desc *desc)
 {
-	return is_nommu_shared_mapping(desc->vm_flags) ? 0 : -ENOSYS;
+	return is_nommu_shared_vma_flags(desc->vma_flags) ? 0 : -ENOSYS;
 }
 
 static unsigned romfs_mmap_capabilities(struct file *file)
--- a/fs/xfs/xfs_file.c~mm-update-all-remaining-mmap_prepare-users-to-use-vma_flags_t
+++ a/fs/xfs/xfs_file.c
@@ -1974,14 +1974,14 @@ xfs_file_mmap_prepare(
 	 * We don't support synchronous mappings for non-DAX files and
 	 * for DAX files if underneath dax_device is not synchronous.
 	 */
-	if (!daxdev_mapping_supported(desc->vm_flags, file_inode(file),
+	if (!daxdev_mapping_supported(desc->vma_flags, file_inode(file),
 				      target->bt_daxdev))
 		return -EOPNOTSUPP;
 
 	file_accessed(file);
 	desc->vm_ops = &xfs_file_vm_ops;
 	if (IS_DAX(inode))
-		desc->vm_flags |= VM_HUGEPAGE;
+		vma_desc_set_flags(desc, VMA_HUGEPAGE_BIT);
 	return 0;
 }
 
--- a/fs/zonefs/file.c~mm-update-all-remaining-mmap_prepare-users-to-use-vma_flags_t
+++ a/fs/zonefs/file.c
@@ -333,7 +333,8 @@ static int zonefs_file_mmap_prepare(stru
 	 * ordering between msync() and page cache writeback.
 	 */
 	if (zonefs_inode_is_seq(file_inode(file)) &&
-	    (desc->vm_flags & VM_SHARED) && (desc->vm_flags & VM_MAYWRITE))
+	    vma_desc_test_flags(desc, VMA_SHARED_BIT) &&
+	    vma_desc_test_flags(desc, VMA_MAYWRITE_BIT))
 		return -EINVAL;
 
 	file_accessed(file);
--- a/include/linux/dax.h~mm-update-all-remaining-mmap_prepare-users-to-use-vma_flags_t
+++ a/include/linux/dax.h
@@ -65,11 +65,11 @@ size_t dax_recovery_write(struct dax_dev
 /*
  * Check if given mapping is supported by the file / underlying device.
  */
-static inline bool daxdev_mapping_supported(vm_flags_t vm_flags,
+static inline bool daxdev_mapping_supported(vma_flags_t flags,
 					    const struct inode *inode,
 					    struct dax_device *dax_dev)
 {
-	if (!(vm_flags & VM_SYNC))
+	if (!vma_flags_test(flags, VMA_SYNC_BIT))
 		return true;
 	if (!IS_DAX(inode))
 		return false;
--- a/include/linux/mm.h~mm-update-all-remaining-mmap_prepare-users-to-use-vma_flags_t
+++ a/include/linux/mm.h
@@ -550,17 +550,18 @@ enum {
 /*
  * Physically remapped pages are special. Tell the
  * rest of the world about it:
- *   VM_IO tells people not to look at these pages
+ *   IO tells people not to look at these pages
  *	(accesses can have side effects).
- *   VM_PFNMAP tells the core MM that the base pages are just
+ *   PFNMAP tells the core MM that the base pages are just
  *	raw PFN mappings, and do not have a "struct page" associated
  *	with them.
- *   VM_DONTEXPAND
+ *   DONTEXPAND
  *      Disable vma merging and expanding with mremap().
- *   VM_DONTDUMP
+ *   DONTDUMP
  *      Omit vma from core dump, even when VM_IO turned off.
  */
-#define VM_REMAP_FLAGS (VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP)
+#define VMA_REMAP_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_PFNMAP_BIT,	\
+				     VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT)
 
 /* This mask prevents VMA from being scanned with khugepaged */
 #define VM_NO_KHUGEPAGED (VM_SPECIAL | VM_HUGETLB)
@@ -1926,6 +1927,14 @@ static inline bool is_cow_mapping(vm_fla
 	return (flags & (VM_SHARED | VM_MAYWRITE)) == VM_MAYWRITE;
 }
 
+static inline bool vma_desc_is_cow_mapping(struct vm_area_desc *desc)
+{
+	const vma_flags_t flags = desc->vma_flags;
+
+	return vma_flags_test(flags, VMA_MAYWRITE_BIT) &&
+		!vma_flags_test(flags, VMA_SHARED_BIT);
+}
+
 #ifndef CONFIG_MMU
 static inline bool is_nommu_shared_mapping(vm_flags_t flags)
 {
@@ -1939,6 +1948,11 @@ static inline bool is_nommu_shared_mappi
 	 */
 	return flags & (VM_MAYSHARE | VM_MAYOVERLAY);
 }
+
+static inline bool is_nommu_shared_vma_flags(vma_flags_t flags)
+{
+	return vma_flags_test(flags, VMA_MAYSHARE_BIT, VMA_MAYOVERLAY_BIT);
+}
 #endif
 
 #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
--- a/kernel/relay.c~mm-update-all-remaining-mmap_prepare-users-to-use-vma_flags_t
+++ a/kernel/relay.c
@@ -92,7 +92,7 @@ static int relay_mmap_prepare_buf(struct
 		return -EINVAL;
 
 	desc->vm_ops = &relay_file_mmap_ops;
-	desc->vm_flags |= VM_DONTEXPAND;
+	vma_desc_set_flags(desc, VMA_DONTEXPAND_BIT);
 	desc->private_data = buf;
 
 	return 0;
--- a/mm/memory.c~mm-update-all-remaining-mmap_prepare-users-to-use-vma_flags_t
+++ a/mm/memory.c
@@ -2897,7 +2897,7 @@ static inline int remap_p4d_range(struct
 	return 0;
 }
 
-static int get_remap_pgoff(vm_flags_t vm_flags, unsigned long addr,
+static int get_remap_pgoff(bool is_cow, unsigned long addr,
 		unsigned long end, unsigned long vm_start, unsigned long vm_end,
 		unsigned long pfn, pgoff_t *vm_pgoff_p)
 {
@@ -2907,7 +2907,7 @@ static int get_remap_pgoff(vm_flags_t vm
 	 * un-COW'ed pages by matching them up with "vma->vm_pgoff".
 	 * See vm_normal_page() for details.
 	 */
-	if (is_cow_mapping(vm_flags)) {
+	if (is_cow) {
 		if (addr != vm_start || end != vm_end)
 			return -EINVAL;
 		*vm_pgoff_p = pfn;
@@ -2928,7 +2928,7 @@ static int remap_pfn_range_internal(stru
 	if (WARN_ON_ONCE(!PAGE_ALIGNED(addr)))
 		return -EINVAL;
 
-	VM_WARN_ON_ONCE((vma->vm_flags & VM_REMAP_FLAGS) != VM_REMAP_FLAGS);
+	VM_WARN_ON_ONCE(!vma_test_all_flags_mask(vma, VMA_REMAP_FLAGS));
 
 	BUG_ON(addr >= end);
 	pfn -= addr >> PAGE_SHIFT;
@@ -3052,9 +3052,9 @@ void remap_pfn_range_prepare(struct vm_a
 	 * check it again on complete and will fail there if specified addr is
 	 * invalid.
 	 */
-	get_remap_pgoff(desc->vm_flags, desc->start, desc->end,
+	get_remap_pgoff(vma_desc_is_cow_mapping(desc), desc->start, desc->end,
 			desc->start, desc->end, pfn, &desc->pgoff);
-	desc->vm_flags |= VM_REMAP_FLAGS;
+	vma_desc_set_flags_mask(desc, VMA_REMAP_FLAGS);
 }
 
 static int remap_pfn_range_prepare_vma(struct vm_area_struct *vma, unsigned long addr,
@@ -3063,13 +3063,12 @@ static int remap_pfn_range_prepare_vma(s
 	unsigned long end = addr + PAGE_ALIGN(size);
 	int err;
 
-	err = get_remap_pgoff(vma->vm_flags, addr, end,
-			      vma->vm_start, vma->vm_end,
-			      pfn, &vma->vm_pgoff);
+	err = get_remap_pgoff(is_cow_mapping(vma->vm_flags), addr, end,
+			      vma->vm_start, vma->vm_end, pfn, &vma->vm_pgoff);
 	if (err)
 		return err;
 
-	vm_flags_set(vma, VM_REMAP_FLAGS);
+	vma_set_flags_mask(vma, VMA_REMAP_FLAGS);
 	return 0;
 }
 
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-do-not-leak-memory-when-mmap_prepare-swaps-the-file.patch
mm-remove-unnecessary-and-incorrect-mmap-lock-assert.patch
mm-do-not-copy-page-tables-unnecessarily-for-vm_uffd_wp.patch
mm-rmap-improve-anon_vma_clone-unlink_anon_vmas-comments-add-asserts.patch
mm-rmap-eliminate-partial-anon_vma-tear-down-in-anon_vma_fork.patch
mm-rmap-skip-unfaulted-vmas-on-anon_vma-clone-unlink.patch
mm-rmap-remove-unnecessary-root-lock-dance-in-anon_vma-clone-unmap.patch
mm-rmap-remove-anon_vma_merge-function.patch
mm-rmap-make-anon_vma-functions-internal.patch
mm-mmap_lock-add-vma_is_attached-helper.patch
mm-rmap-allocate-anon_vma_chain-objects-unlocked-when-possible.patch
mm-rmap-separate-out-fork-only-logic-on-anon_vma_clone.patch
locking-add-rwsem_is_write_locked-update-non-lockdep-asserts.patch
mm-vma-add-vma_is__locked-helpers.patch
mm-add-use-vma_is_stabilised-vma_assert_stabilised-helpers.patch
selftests-mm-remove-virtual_address_range-test.patch
mm-rename-vma_flag_test-set_atomic-to-vma_test-set_atomic_flag.patch
mm-add-mk_vma_flags-bitmap-flag-macro-helper.patch
tools-bitmap-add-missing-bitmap_.patch
mm-add-basic-vma-flag-operation-helper-functions.patch
mm-update-hugetlbfs-to-use-vma-flags-on-mmap_prepare.patch
mm-update-secretmem-to-use-vma-flags-on-mmap_prepare.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t.patch
mm-update-all-remaining-mmap_prepare-users-to-use-vma_flags_t.patch
mm-make-vm_area_desc-utilise-vma_flags_t-only.patch
tools-testing-vma-separate-vma-userland-tests-into-separate-files.patch
tools-testing-vma-add-vma-userland-tests-for-vma-flag-functions.patch

