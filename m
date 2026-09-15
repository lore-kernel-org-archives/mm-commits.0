Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385DE2F8EBC
	for <mm-commits@vger.kernel.org>; Tue, 15 Sep 2026 01:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789434508; cv=none; b=FWDi/9mYEIXuiRUOfcG/DkoJoVYPvWITucEHju2Xpw/WcVC7+4/ovIa/AIJ+IMd/6LmMLK163TtYhb8PR3iAAapjWPVH6+FMy6N4JnYMNrZbeiPqxsRru85Of+G3a1eJArP68mtdIyhlYcaVVTB2bihbCRfOKYYp/0U0AubyUwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789434508; c=relaxed/simple;
	bh=ro3VVBJ04VFQbR5BUl0FduSXsDLJ3zcp6KCbi1EniLs=;
	h=Date:To:From:Subject:Message-Id; b=BsKN1/ChFtP23wRfVnfcFSdBxA9020oj/jsMxLP6ixaYOVOmP+QSD5fkZ3T+3TjT2uGN0OzjUM8xVF8fAiM/PvOa/obaWv3Hh8RDWs3ZMfYO5n3QGvUvV0EGxHHGUAphEiPIQrBZuuao6WuxTOGg0dxgJKt/x2WSknoRHfqjKkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TsVO+3fZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TsVO+3fZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D051F000FF;
	Tue, 15 Sep 2026 01:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789434505;
	bh=/4afcfOIRYw/D8doFMtbZT+q+XvWCeAIXI6MimaGf1M=;
	h=Date:To:From:Subject;
	b=TsVO+3fZyLG08EYpCl56JDjPNG0mEZRMW4izrXSgcz6jtXSlGVworoWgAhDCICMB1
	 Cb3yq6zo2e8+27upL5eQns7kNl7gjCAzsMi8yR2H2Pz+GSi9anIXRqp2TIw6S7oJJv
	 iYflkCqWCDcM5idcvcVTmZ8W4EdzNzml7oYO9VHw=
Date: Mon, 14 Sep 2026 18:08:25 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-fix-mmap_prepare-file-handling-remove-file_doesnt_need_get.patch added to mm-new branch
Message-Id: <20260915010825.B6D051F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: fix mmap_prepare file handling, remove file_doesnt_need_get
has been added to the -mm mm-new branch.  Its filename is
     mm-vma-fix-mmap_prepare-file-handling-remove-file_doesnt_need_get.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-fix-mmap_prepare-file-handling-remove-file_doesnt_need_get.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/vma: fix mmap_prepare file handling, remove file_doesnt_need_get
Date: Mon, 14 Sep 2026 15:57:21 +0100

Patch series "mm: make VMA flag semantics explicit, eliminate VM_SPECIAL",
v2.

The VM_SPECIAL / VMA_SPECIAL_FLAGS mask conflates several unrelated
properties:

* Is this kernel-owned, whether MMIO, kernel-allocated pages, or ordinary
  pages a driver maps itself?
* Can it be expanded or merged?
* Is this a 'weird' case like mlock where migration might race and we
  'have' to set invalid flags to notify?
* Is it another 'weird' case where we just want to stop GUP from touching
  it?

Driver writers have often been confused about this, and who can blame them?

It also interacts badly with the eternal edgecase known as hugetlb - which
sets VMA_DONTEXPAND_BIT but doesn't also want to be treated like a
'special' flag.

Another issue is that we cannot make sensible assumptions about flag use. 
It's not possible to assume VMA_IO_BIT means iommu because drivers abuse
it and mlock abuses it.

Special is also an overloaded term in mm.  VDSO and VVAR mappings are also
called 'special' but they're special in a...  special way.

Sometimes things are called special that are a subset of VMA_SPECIAL_FLAGS
(VMA_PFNMAP_BIT and VMA_MIXEDMAP_BIT for instance when it comes to zapping
or vm_normal_folio()).

There's a specific kind of special for THP too, which considers
PFN map, mixed map 'special' but DAX not.

It's all rather a mess.

This series brings some order to things by both limiting what drivers can
do with VMA flags and switching to using predicates that describe
behaviour, not arbitrary flags.

It establishes the invariant that only kernel-owned mappings may set
VMA_IO_BIT or clear VMA_MAYWRITE_BIT in an mmap hook, enforcing this by
validating VMA state after every mmap and mmap_prepare hook.

It updates usbmon and sg to mmap_prepare in order to do so, adding a new
mmap action for mapping discontiguous kernel pages, and has hfi1 and the
ALSA PCM status page map their pages eagerly instead.

It also establishes the invariant that VMA_MIXEDMAP_BIT be set when
mapping kernel memory, something that is usually the case but happens not
to be for some users - specifically defio, cmt_speech, uprobes and the bpf
arena, all of which are updated to do the right thing.

It replaces VM_SPECIAL and arbitrary flag tests with predicates that say
what is actually being tested:

   vma_is_kernel_owned()   Does a driver or kernel code manage a VMA's
                           life cycle?

  vma_is_fixed_mapping()   Is the VMA not permitted to be expanded or
                           merged?

     vma_is_persistent()   Do bytes written to the VMA stay written, and
                           bytes read stay the same unless userland changes
                           them?

         vma_can_merge()   Can the VMA be merged with a compatible
                           neighbour?

           vma_can_gup()   Can GUP obtain pages from the VMA, i.e. is it
                           neither a PFN map nor memory-mapped I/O?

Remaining raw VMA_IO_BIT, VMA_PFNMAP_BIT and VMA_MIXEDMAP_BIT tests
scattered across mm are also converted to predicates where it makes sense
to do so.

And also the opportunity is taken to eliminate THP's vma_is_special_huge()
which was an existing source of confusion.


This patch (of 40):

The map->file_doesnt_need_get flag is confusing and the existing
implementation has holes.

Drivers are permitted to change the owning file of a mapping.  If they do
so, they are required to take a reference on that file.

The mmap() operation which ultimately invokes __mmap_region() is
guaranteed to drop the refcount for the original file the mapping was made
under, but this is not true for the replaced file.

This has been addressed so far by tracking map->file_doesnt_need_get,
which is rather poorly named and unfortunately fails to correctly track
whether or not an additional put were needed in a number of cases.

Make life easier by removing this flag, and instead drop the reference for
both mmap_prepare and the deprecated mmap callback in a new function
put_map().

Track whether this needs to be done by aligning mmap_state with
vm_area_desc and store the original file in the map->file field, keeping
the updated file in map->vm_file.

In order to have the same behaviour for both types of hooks, only drop the
reference __mmap_new_file_vma() itself took in its error path, deferring
the replaced file's reference to put_map().

To make this work correctly, map->vm_file has to be updated before any
error handling, so update __mmap_new_file_vma() and call_mmap_prepare() to
set this field first.

Also when mmap_prepare() changes the file and is then merged, the
reference count also must be decremented, so update the logic to call
put_map() in this case too.

Also update __compat_vma_mmap() to manually perform this step for stacked
file systems using the compatibility layer, and update
compat_set_vma_from_desc() to replace vma_set_file() with a correct
refcount/file update.

No in-tree driver is impacted by the incorrect implementation of this
currently (no driver that does this is mergeable for one), so this does
not need to be a fix.

Link: https://lore.kernel.org/20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org
Link: https://lore.kernel.org/20260914-b4-mmap-prepare-vma-flag-sanify-v2-1-7d9781ed5361@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    1 
 mm/util.c     |    5 ++
 mm/vma.c      |   95 +++++++++++++++++++++++++++---------------------
 mm/vma.h      |    6 ++-
 4 files changed, 64 insertions(+), 43 deletions(-)

--- a/mm/internal.h~mm-vma-fix-mmap_prepare-file-handling-remove-file_doesnt_need_get
+++ a/mm/internal.h
@@ -7,6 +7,7 @@
 #ifndef __MM_INTERNAL_H
 #define __MM_INTERNAL_H
 
+#include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/khugepaged.h>
 #include <linux/mm.h>
--- a/mm/util.c~mm-vma-fix-mmap_prepare-file-handling-remove-file_doesnt_need_get
+++ a/mm/util.c
@@ -1228,8 +1228,11 @@ int __compat_vma_mmap(struct vm_area_des
 
 	/* Perform any preparatory tasks for mmap action. */
 	err = mmap_action_prepare(desc);
-	if (err)
+	if (err) {
+		if (desc->vm_file != vma->vm_file)
+			fput(desc->vm_file);
 		return err;
+	}
 	/* Update the VMA from the descriptor. */
 	compat_set_vma_from_desc(vma, desc);
 	/* Complete any specified mmap actions. */
--- a/mm/vma.c~mm-vma-fix-mmap_prepare-file-handling-remove-file_doesnt_need_get
+++ a/mm/vma.c
@@ -24,7 +24,8 @@ struct mmap_state {
 		vm_flags_t vm_flags;
 		vma_flags_t vma_flags;
 	};
-	struct file *file;
+	struct file *file;	/* mmap()-specified file. */
+	struct file *vm_file;	/* May be updated by mmap_prepare. */
 	pgprot_t page_prot;
 
 	/* User-defined fields, perhaps updated by .mmap_prepare(). */
@@ -43,8 +44,6 @@ struct mmap_state {
 
 	/* Determine if we can check KSM flags early in mmap() logic. */
 	bool check_ksm_early :1;
-	/* If .mmap_prepare changed the file, we don't need to pin. */
-	bool file_doesnt_need_get :1;
 };
 
 #define MMAP_STATE(name, mm_, vmi_, addr_, len_, pgoff_, anon_pgoff_, vma_flags_, file_) \
@@ -58,6 +57,7 @@ struct mmap_state {
 		.pglen = PHYS_PFN(len_),				\
 		.vma_flags = vma_flags_,				\
 		.file = file_,						\
+		.vm_file = file_,					\
 		.page_prot = vma_flags_to_page_prot(vma_flags_),	\
 	}
 
@@ -70,7 +70,7 @@ struct mmap_state {
 		.vma_flags = (map_)->vma_flags,				\
 		.pgoff = (map_)->pgoff,					\
 		.anon_pgoff = (map_)->anon_pgoff,			\
-		.file = (map_)->file,					\
+		.file = (map_)->vm_file,				\
 		.prev = (map_)->prev,					\
 		.middle = vma_,						\
 		.next = (vma_) ? NULL : (map_)->next,			\
@@ -2447,7 +2447,7 @@ void mm_drop_all_locks(struct mm_struct
  */
 static bool accountable_mapping(struct mmap_state *map)
 {
-	const struct file *file = map->file;
+	const struct file *file = map->vm_file;
 
 	/*
 	 * hugetlb has its own accounting separate from the core VM
@@ -2496,7 +2496,7 @@ static void vms_abort_munmap_vmas(struct
 
 static void update_ksm_flags(struct mmap_state *map)
 {
-	map->vma_flags = ksm_vma_flags(map->mm, map->file, map->vma_flags);
+	map->vma_flags = ksm_vma_flags(map->mm, map->vm_file, map->vma_flags);
 }
 
 static void set_desc_from_map(struct vm_area_desc *desc,
@@ -2506,7 +2506,7 @@ static void set_desc_from_map(struct vm_
 	desc->end = map->end;
 
 	desc->pgoff = map->pgoff;
-	desc->vm_file = map->file;
+	desc->vm_file = map->vm_file;
 	desc->vma_flags = map->vma_flags;
 	desc->page_prot = map->page_prot;
 }
@@ -2586,6 +2586,10 @@ static int __mmap_setup(struct mmap_stat
 	return 0;
 }
 
+static bool map_same_file(struct mmap_state *map)
+{
+	return map->vm_file == map->file;
+}
 
 static int __mmap_new_file_vma(struct mmap_state *map,
 			       struct vm_area_struct *vma)
@@ -2593,20 +2597,23 @@ static int __mmap_new_file_vma(struct mm
 	struct vma_iterator *vmi = map->vmi;
 	int error;
 
-	vma->vm_file = map->file;
-	if (!map->file_doesnt_need_get)
-		get_file(map->file);
+	vma->vm_file = map->vm_file;
+	if (map_same_file(map))
+		get_file(map->vm_file);
 
-	if (!map->file->f_op->mmap)
+	if (!map->vm_file->f_op->mmap)
 		return 0;
 
 	error = mmap_file(vma->vm_file, vma);
+	map->vm_file = vma->vm_file;
+
 	if (error) {
 		UNMAP_STATE(unmap, vmi, vma, vma->vm_start, vma->vm_end,
 			    map->prev, map->next);
-		fput(vma->vm_file);
-		vma->vm_file = NULL;
+		if (map_same_file(map))
+			fput(map->vm_file);
 
+		vma->vm_file = NULL;
 		vma_iter_set(vmi, vma->vm_end);
 		/* Undo any partial mapping done by a device driver. */
 		unmap_region(&unmap);
@@ -2623,7 +2630,6 @@ static int __mmap_new_file_vma(struct mm
 			!vma_flags_test(&map->vma_flags, VMA_MAYWRITE_BIT) &&
 			vma_test(vma, VMA_MAYWRITE_BIT));
 
-	map->file = vma->vm_file;
 	map->vma_flags = vma->flags;
 
 	return 0;
@@ -2631,7 +2637,7 @@ static int __mmap_new_file_vma(struct mm
 
 static void map_set_anon(struct mmap_state *map)
 {
-	map->file = NULL;
+	map->vm_file = NULL;
 	map->vm_ops = NULL;
 	map->pgoff = map->addr >> PAGE_SHIFT;
 }
@@ -2643,7 +2649,7 @@ static bool map_is_private(const struct
 
 static bool map_is_anon(const struct mmap_state *map)
 {
-	return map_is_private(map) && !map->file;
+	return map_is_private(map) && !map->vm_file;
 }
 
 /*
@@ -2688,7 +2694,7 @@ static int __mmap_new_vma(struct mmap_st
 	}
 
 	/* Invoke callbacks. */
-	if (map->file)
+	if (map->vm_file)
 		error = __mmap_new_file_vma(map, vma);
 	else if (!is_anon)
 		error = shmem_zero_setup(vma);
@@ -2797,36 +2803,34 @@ static int call_mmap_prepare(struct mmap
 	int err;
 
 	/* Invoke the hook. */
-	err = vfs_mmap_prepare(map->file, desc);
-	if (err)
-		return err;
-
-	/* It's invalid for mmap_preprare hooks to clear vm_ops. */
-	if (!desc->vm_ops)
-		return -EINVAL;
-
-	err = call_action_prepare(map, desc);
+	err = vfs_mmap_prepare(map->vm_file, desc);
 	if (err)
 		return err;
 
 	/* Update fields permitted to be changed. */
 	map->pgoff = desc->pgoff;
-	if (desc->vm_file != map->file) {
-		map->file_doesnt_need_get = true;
-		map->file = desc->vm_file;
-	}
+	if (desc->vm_file != map->vm_file)
+		map->vm_file = desc->vm_file;
 	map->vma_flags = desc->vma_flags;
 	map->page_prot = desc->page_prot;
 	/* User-defined fields. */
 	map->vm_ops = desc->vm_ops;
 	map->vm_private_data = desc->private_data;
 
+	/* It's invalid for mmap_prepare hooks to clear vm_ops. */
+	if (!desc->vm_ops)
+		return -EINVAL;
+
+	err = call_action_prepare(map, desc);
+	if (err)
+		return err;
+
 	/*
 	 * MAP_PRIVATE-/dev/zero mappings are an ancient way of getting
 	 * anonymous mappings. Rather than allowing these mappings to be odd
 	 * outliers, simply make them truly anonymous.
 	 */
-	if (map_is_private(map) && file_is_dev_zero(map->file))
+	if (map_is_private(map) && file_is_dev_zero(map->vm_file))
 		map_set_anon(map);
 
 	return 0;
@@ -2845,7 +2849,7 @@ static void set_vma_user_defined_fields(
  */
 static bool can_set_ksm_flags_early(struct mmap_state *map)
 {
-	struct file *file = map->file;
+	struct file *file = map->vm_file;
 
 	/* Anonymous mappings have no driver which can change them. */
 	if (!file)
@@ -2868,6 +2872,20 @@ static bool can_set_ksm_flags_early(stru
 	return false;
 }
 
+static void put_map(struct mmap_state *map)
+{
+	/*
+	 * An error occurred or the VMA was merged.
+	 *
+	 * If the file was changed by the driver (which is required to increment
+	 * the replacement file's reference count), drop its reference count.
+	 *
+	 * On error, the caller always drops the original file regardless.
+	 */
+	if (map->vm_file && !map_same_file(map))
+		fput(map->vm_file);
+}
+
 static unsigned long __mmap_region(struct file *file, unsigned long addr,
 		unsigned long len, vma_flags_t vma_flags,
 		unsigned long pgoff, struct list_head *uf)
@@ -2922,7 +2940,10 @@ static unsigned long __mmap_region(struc
 
 	__mmap_complete(&map, vma);
 
-	if (have_mmap_prepare && allocated_new) {
+	if (!allocated_new) {
+		/* Merged, so need to drop refcount. */
+		put_map(&map);
+	} else if (have_mmap_prepare) {
 		error = mmap_action_complete(vma, &desc.action,
 					     /*is_compat=*/false);
 		if (error)
@@ -2936,13 +2957,7 @@ unacct_error:
 	if (map.charged)
 		vm_unacct_memory(map.charged);
 abort_munmap:
-	/*
-	 * This indicates that .mmap_prepare has set a new file, differing from
-	 * desc->vm_file. But since we're aborting the operation, only the
-	 * original file will be cleaned up. Ensure we clean up both.
-	 */
-	if (map.file_doesnt_need_get)
-		fput(map.file);
+	put_map(&map);
 	vms_abort_munmap_vmas(&map.vms, &map.mas_detach);
 	return error;
 }
--- a/mm/vma.h~mm-vma-fix-mmap_prepare-file-handling-remove-file_doesnt_need_get
+++ a/mm/vma.h
@@ -394,8 +394,10 @@ static inline void compat_set_vma_from_d
 
 	/* Mutable fields. Populated with initial state. */
 	vma_set_pgoff(vma, desc->pgoff);
-	if (desc->vm_file != vma->vm_file)
-		vma_set_file(vma, desc->vm_file);
+	if (desc->vm_file != vma->vm_file) {
+		fput(vma->vm_file);
+		vma->vm_file = desc->vm_file;
+	}
 	vma->flags = desc->vma_flags;
 	vma->vm_page_prot = desc->page_prot;
 
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vmpressure-remove-window-size-todo.patch
tools-testing-selftests-mm-add-missing-gitignore-entries.patch
mm-move-drivers-char-memc-to-mm-char-memc.patch
mm-implement-file_is_dev_zero-to-uniquely-identify-dev-zero.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch
mm-madvise-swap-in-cowd-map_private-file-mappings-on-madv_willneed.patch
mm-huge_memory-zap-deposited-page-tables-after-an-rcu-grace-period.patch
mm-enable-mmu_gather_rcu_table_free-for-most-2-level-architectures.patch
mm-enable-mmu_gather_rcu_table_free-for-mmu-riscv.patch
mm-enable-mmu_gather_rcu_table_free-for-mmu-arm.patch
mm-enable-mmu_gather_rcu_table_free-for-arc-microblaze-xtensa.patch
mm-enable-mmu_gather_rcu_table_free-for-sparc64.patch
mm-enable-mmu_gather_rcu_table_free-for-m68k-coldfire.patch
mm-enable-mmu_gather_rcu_table_free-for-sh-x2.patch
mm-enable-mmu_gather_rcu_table_free-for-m68k-motorola.patch
mm-enable-mmu_gather_rcu_table_free-for-sparc32.patch
mm-make-userland-page-table-freeing-rcu-safe.patch
mm-change-the-contract-for-free_pgtables-update-docs.patch
mm-vma-fix-mmap_prepare-file-handling-remove-file_doesnt_need_get.patch
mm-vma-predicate-setting-mmap_prepare-vma-fields-on-new-vma-alloc.patch
mm-vma-introduce-and-use-vma_can_merge.patch
mm-consistently-validate-vma-state-after-mmap-hooks.patch
mm-vma-ensure-mmap_prepare-doesnt-set-actions-on-a-mergeable-vma.patch
mm-make-map_kernel_pages_-internal-and-unexported.patch
mm-vma-tidy-up-map-kernel-pages-enum-values.patch
mm-add-mmap-action-for-discontiguous-kernel-page-mapping.patch
docs-filesystems-update-mmap_prepare-docs-for-discontig-kernel-pgs.patch
drivers-usb-mon-update-to-use-mmap_prepare-map-kernel-pages.patch
infiniband-update-hfi1-to-use-remap_vmalloc_range.patch
selinux-reject-writable-opens-of-policy-file-drop-mmap-shared-write-check.patch
alsa-pcm-use-vm_insert_page-to-map-pcm-status-page.patch
bpf-arena-mark-arena_map_mmap-mappings-vm_mixedmap.patch
mm-vma-add-vma_is_kernel_owned-predicates.patch
mm-vma-only-allow-mmap-to-clear-vma_maywrite_bit-if-kernel-owned.patch
mm-vma-add-and-use-vma__is_fixed_mapping.patch
scsi-sg-convert-mmap-hook-to-mmap_prepare-and-rework.patch
fbdev-defio-assert-fbinfo_virtfb-drop-vm_io-add-vm_mixedmap.patch
hsi-cmt_speech-convert-mmap-hook-to-mmap_prepare-refactor.patch
mm-gup-error-out-early-on-vma_mayread_bit-vmas.patch
uprobes-remove-vm_io-set-vm_mixedmap-for-mapped-kernel-pages.patch
mm-mlock-clear-vma_locked_mask-over-mmap-callback.patch
mm-mlock-eliminate-weird-vma_io_bit-abuse-and-simplify.patch
mm-vma-enforce-that-only-kernel-owned-mappings-may-set-vma_io_bit.patch
mm-remove-vma_io_bit-check-in-vma_is_kernel_owned.patch
mm-remove-hugetlb_inlineh.patch
mm-rename-is_vm_hugetlb_page-to-vma_is_hugetlb.patch
mm-drop-some-redundant-checks-around-hugetlb-vmas.patch
mm-madvise-update-is_valid_guard_vma-to-use-vma_can_merge.patch
mm-vma-introduce-vma_is_persistent.patch
mm-uffd-use-predicates-for-userfaultfd-checks.patch
mm-madvise-use-predicates-for-madvise-madv_dofork.patch
mm-eliminate-vma_special_flags-usage-when-hugetlb-explicitly-tested.patch
mm-eliminate-vma_special_flags-check-in-lru_gen_look_around.patch
mm-avoid-use-of-vma_special_flags-in-migrate_vma_setup.patch
mm-eliminate-vm_special-vma_special_flags.patch
fuse-dax-do-not-set-vm_mixedmap.patch
mm-huge_memory-remove-vma_is_special_huge.patch
mm-vma-introduce-and-use-vma_can_gup.patch

