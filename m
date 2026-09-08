Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A7F4C77B1
	for <mm-commits@vger.kernel.org>; Tue,  8 Sep 2026 23:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788910434; cv=none; b=oDVU10f9iyApIDYk/qxJD20P+LcYGk9+So3a2kVy6EkRGwGKC42G56hr2e/UgzwUryXxFWwm8XkacQoKS26lMvveyEM/5KkgWGTvmdes7pgUMoTuZnb4OkNFP7y/uGmbk3VF1A1Zd+kdX+og0/NycJyrZiVA0VYSV4IRyC0W+VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788910434; c=relaxed/simple;
	bh=ITML8pPsmUZ47eZM+SrprYgyjN5rLWkiAC3LeoO+SFY=;
	h=Date:To:From:Subject:Message-Id; b=CtPJe9SlFDHgcXwMZcar4UvuE7K6eCFg/iJ41AXQ06mRKy03m3tYUjLhg+zYcvC0ptdwMe2jVjjKnD95A8euijctY6SU4Iftol5u+clvqLONPoqZiz9h8/gr7BvUltkHSFdIUn0TxCWyaQP724WlM8DuN6j/4fxnV+/oFnwz0ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bFqC/xMt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bFqC/xMt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1FE61F00A3E;
	Tue,  8 Sep 2026 23:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788910433;
	bh=mVG0pco4f1NoVlWWYtUjFCu4XIzOmRz6QevOd3v5qxE=;
	h=Date:To:From:Subject;
	b=bFqC/xMtgiwWy9DOQ9OuiiIXAsUImYwS4SVXNzaAPAMUdnxMeuNHYig48TK8CXk2M
	 M5NLHE+mo3mNjBZnvAELagfcqEcKA4XD+iIM/+msNvn98y4g4QmkxIOuirzDKE4KH7
	 ho8/aJ0l4KWDV8ao7czVXffY9p0DRGtxDGB8LlUo=
Date: Tue, 08 Sep 2026 16:33:52 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch removed from -mm tree
Message-Id: <20260908233352.E1FE61F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: only permit MAP_PRIVATE /dev/zero to be mapped anonymous
has been removed from the -mm tree.  Its filename was
     mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/vma: only permit MAP_PRIVATE /dev/zero to be mapped anonymous
Date: Wed, 02 Sep 2026 19:00:20 +0100

In order to use mmap_prepare() with MAP_PRIVATE mappings of /dev/zero
without the success_hook hack we explicitly permitted mmap_prepare
handlers to set NULL vm_ops.

However this is dangerous and we really only want to allow this for
MAP_PRIVATE-mapped /dev/zero.

Therefore use the newly introduced file_is_dev_zero() to uniquely identify
MAP_PRIVATE-/dev/zero mappings and only permit this behaviour for them.

Then, remove all ability for mmap_prepare or mmap hooks to set a VMA
anonymous and update mmap_zero_prepare() to leave it to the core mmap code
to do so.

Note that this disallows nested MAP_PRIVATE-mappings of /dev/zero regions.
Doing this would be broken in any case.

We therefore do not need to update the mmap_prepare() compatibility layer
to reflect these changes, as the mmap hook check suffices to disallow this
behaviour.

Now we're setting vma->vm_ops to NULL for an mmap_prepare-initialised
MAP_PRIVATE-/dev/zero mapping, we have to avoid a subtle issue when
updating user-defined fields via set_vma_user_defined_fields().

The default for vma->vm_ops for all mmap_prepare-initialised mappings is
vma_dummy_vm_ops, so map->vm_ops will be set to this and setting
vma->vm_ops to this will render the VMA mistakenly non-anon.

In general, we should never be setting user-defined fields for an
anonymous VMA, so explicitly check for this to avoid doing so for the one
case where a mapping can be both mmap_prepare and anonymous.

In the case of legacy ->mmap hooks some drivers may set vma->vm_ops NULL
believing this is the equivalent of setting no VMA operations.  Therefore
update mmap_file() to correct this by setting dummy VMA operations if this
occurs.

An example of this is drm_gem_shmem_mmap() which deliberately clears
vma->vm_ops before handing the VMA to dma-buf.  Cases such as this will be
updated when they are converted to mmap_prepare.

Also, in order to avoid a single commit bisection hazard, add a temporary
workaround to set the VMA anonymous only after vma->vm_file is assigned in
__mmap_new_file_vma().

This is because vma_set_range() calls vma_set_pgoff() and
assert_sane_pgoff() in turn, prior to the vma->vm_file being assigned.  If
we set the VMA anonymous early then this assert will fail.

This is removed in the subsequent commit.

Link: https://lore.kernel.org/20260902-map-private-dev-zero-v1-3-a578c730cec7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/char-mem.c |    6 +-----
 mm/internal.h |   17 ++++++++++-------
 mm/vma.c      |   33 +++++++++++++++++++++++++--------
 3 files changed, 36 insertions(+), 20 deletions(-)

--- a/mm/char-mem.c~mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous
+++ a/mm/char-mem.c
@@ -508,11 +508,7 @@ static int mmap_zero_prepare(struct vm_a
 	if (vma_desc_test(desc, VMA_SHARED_BIT))
 		return shmem_zero_setup_desc(desc);
 
-	/*
-	 * This is a highly unique situation where we mark a MAP_PRIVATE mapping
-	 * of /dev/zero anonymous, despite it not being.
-	 */
-	vma_desc_set_anonymous(desc);
+	/* MAP_PRIVATE semantics are taken care of for us by core mm. */
 	return 0;
 }
 
--- a/mm/internal.h~mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous
+++ a/mm/internal.h
@@ -226,15 +226,18 @@ static inline int mmap_file(struct file
 {
 	int err = vfs_mmap(file, vma);
 
-	if (likely(!err))
-		return 0;
-
 	/*
-	 * OK, we tried to call the file hook for mmap(), but an error
-	 * arose. The mapping is in an inconsistent state and we must not invoke
-	 * any further hooks on it.
+	 * Either we tried to call the file hook for mmap() and an error arose
+	 * or a driver set vma->vm_ops = NULL intending there to be no VMA
+	 * operations.
+	 *
+	 * In the former case the VMA is in an inconsistent state and we mustn't
+	 * invoke any further hooks on it, in the latter case the hook actually
+	 * wanted no further hooks to be invoked, so fix both by setting dummy
+	 * VMA ops.
 	 */
-	vma->vm_ops = &vma_dummy_vm_ops;
+	if (unlikely(err || !vma->vm_ops))
+		vma->vm_ops = &vma_dummy_vm_ops;
 
 	return err;
 }
--- a/mm/vma.c~mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous
+++ a/mm/vma.c
@@ -2621,6 +2621,19 @@ static int __mmap_new_file_vma(struct mm
 	return 0;
 }
 
+static bool map_is_private(const struct mmap_state *map)
+{
+	return !vma_flags_test(&map->vma_flags, VMA_SHARED_BIT);
+}
+
+static bool map_is_anon(const struct mmap_state *map)
+{
+	if (!map_is_private(map))
+		return false;
+
+	return !map->file || file_is_dev_zero(map->file);
+}
+
 /*
  * __mmap_new_vma() - Allocate a new VMA for the region, as merging was not
  * possible.
@@ -2634,8 +2647,7 @@ static int __mmap_new_file_vma(struct mm
 static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
 	struct mmap_action *action)
 {
-	const bool is_anon = !map->file &&
-		!vma_flags_test(&map->vma_flags, VMA_SHARED_BIT);
+	const bool is_anon = map_is_anon(map);
 	struct vma_iterator *vmi = map->vmi;
 	int error = 0;
 	struct vm_area_struct *vma;
@@ -2651,7 +2663,7 @@ static int __mmap_new_vma(struct mmap_st
 
 	vma_iter_config(vmi, map->addr, map->end);
 
-	if (is_anon)
+	if (is_anon && !map->file)
 		vma_set_anonymous(vma);
 
 	vma_set_range(vma, map->addr, map->end, map->pgoff, map->anon_pgoff);
@@ -2669,6 +2681,10 @@ static int __mmap_new_vma(struct mmap_st
 	else if (!is_anon)
 		error = shmem_zero_setup(vma);
 
+	/* Temporary MAP_PRIVATE-/dev/zero workaround. */
+	if (is_anon && map->file)
+		vma_set_anonymous(vma);
+
 	if (error)
 		goto free_iter_vma;
 
@@ -2777,6 +2793,10 @@ static int call_mmap_prepare(struct mmap
 	if (err)
 		return err;
 
+	/* Hooks cannot mark themselves anonymous. */
+	if (!desc->vm_ops)
+		return -EINVAL;
+
 	err = call_action_prepare(map, desc);
 	if (err)
 		return err;
@@ -2799,10 +2819,7 @@ static int call_mmap_prepare(struct mmap
 static void set_vma_user_defined_fields(struct vm_area_struct *vma,
 		struct mmap_state *map)
 {
-	if (map->vm_ops)
-		vma->vm_ops = map->vm_ops;
-	else	/* Only /dev/zero should do this. */
-		vma_set_anonymous(vma);
+	vma->vm_ops = map->vm_ops;
 	vma->vm_private_data = map->vm_private_data;
 }
 
@@ -2884,7 +2901,7 @@ static unsigned long __mmap_region(struc
 		allocated_new = true;
 	}
 
-	if (have_mmap_prepare)
+	if (have_mmap_prepare && !map_is_anon(&map))
 		set_vma_user_defined_fields(vma, &map);
 
 	__mmap_complete(&map, vma);
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-correctly-unaccount-on-mmap_prepare-failure.patch
mm-vmpressure-remove-window-size-todo.patch
tools-testing-selftests-mm-add-missing-gitignore-entries.patch
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

