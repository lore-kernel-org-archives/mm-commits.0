Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C58F3D75DE;
	Wed, 30 Sep 2026 22:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790806942; cv=none; b=bkINF4tHvXa5s8sRlo+ZAq7EOhhUrCPpaEcPdV6o4ytCbrRKwU1CvxrnM58qsdpqtv3HgzvpRIwE0TbQTW7qO37YmofIIRdKIyWqu380qQ/aPmH508h/vYoclo2Q2Bgi66B3XoNTWjskvRv3IqLac9yPuk+6HmLh9INa3PalyG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790806942; c=relaxed/simple;
	bh=ieqjBDF4kDq6h7ZEGKZE1JjQgOMdpcLNu1j/lge1ahU=;
	h=Date:To:From:Subject:Message-Id; b=FujOAkESsmY0d9McS9uRgf/EpqzbQThe2Jqvcu1k/vddS+cUb2S9V4N9CU9Vgu631RirNsSXFBtx9Zb041UhzoQDaCUzPqsgmjDNLjwAPOx3RIRX0TJFYHgAJTAnP9g9hAA/7mWKOD5L0UeYm5ywAeCzVIn+g8oyJtqBYN+a3Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uBaYGfrR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uBaYGfrR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55DB61F000FF;
	Wed, 30 Sep 2026 22:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790806940;
	bh=9CHkb7D4+CYkb7uBzQ0BWA8E2ei95KQK5A3b51NZwts=;
	h=Date:To:From:Subject;
	b=uBaYGfrRIy4V4euhIX09h9GCedkORAMUn/NmosIQ/tzeopx/XE5GM8ZbLo+RMS45P
	 26cU9VwNgZr6kpNBlhdZIg/I8eKqHicez53Gieo9kaCX8MDOJopOKqI1Y7pb00Q0Df
	 lnYOwtBLIBVNnHSTVNRRws/MJcx/mcFWXnS8yPZ8=
Date: Wed, 30 Sep 2026 15:22:19 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,pfalcato@suse.de,minchan@kernel.org,liam@infradead.org,kas@kernel.org,jannh@google.com,bgeffon@google.com,azpijr@gmail.com,asrinivasan@oss.tenstorrent.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-fix-locked_vm-leak-from-mremap_dontunmap-self-merge.patch added to mm-hotfixes-unstable branch
Message-Id: <20260930222220.55DB61F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mremap: fix locked_vm leak from MREMAP_DONTUNMAP self-merge
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mremap-fix-locked_vm-leak-from-mremap_dontunmap-self-merge.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-fix-locked_vm-leak-from-mremap_dontunmap-self-merge.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: mm/mremap: fix locked_vm leak from MREMAP_DONTUNMAP self-merge
Date: Wed, 30 Sep 2026 19:47:09 +0100

Patch series "mm/mremap: fix two issues with MREMAP_DONTUNMAP", v2.

The MREMAP_DONTUNMAP feature is highly unusual in that it permits mremap()
operations that keep the original VMA in place.

Historically this has led to a lot of bugs where non-obvious interactions
occur between existing mremap() operations and the original VMA.

Commit 397432cab17b ("mm/mremap: account mm->locked_vm correctly for
MREMAP_DONTUNMAP") fixed an accidentally introduced bug around
mm->locked_vm accounting, but this wasn't the only issue.

And thus history repeats itself, as it turns out that mm->locked_vm
accounting is broken by MREMAP_DONTUNMAP yet again by two further cases,
and has been broken ever since the feature was introduced.

Both relate to the fact that VMA_LOCKED_BIT is cleared on the source VMA
(it has to be as all page tables are moved):

1. If an unfaulted VMA_LOCKONFAULT_BIT anonymous VMA self-merges it
   clears the VMA_LOCKED_BIT flag and permanently leaks mm->locked_vm
   pages.

2. If a partial mremap() is performed on a locked VMA there is a leak equal
   to the number of pages not copied.

(Both for MREMAP_DONTUNMAP operations only)

Both issues can be fixed by treating the source range as distinct from the
destination range, which is the definition of what MREMAP_DONTUNMAP does
so is appropriate.

In case 1, simply disallow the self-merge, keeping adjacent source and
destination VMAs distinct.

In case 2, split the source range ahead of time if the VMA is mlock()'d,
so accounting is always correct.

Both changes were tested locally and confirmed to fix the issues.

For the purposes of a backport, the fixes are kept distinct, a follow-up
series can add self-tests.


This patch (of 2):

The MREMAP_DONTUNMAP feature is highly unusual in that it permits mremap()
operations that keep the original VMA in place.

Historically this has led to a lot of bugs where non-obvious interactions
occur between existing mremap() operations and the original VMA.

Fix another of these - self-merge.

Self-merge occurs when a VMA is moved in front of or behind itself and the
attributes of the VMA permit such a merge.

Practically this can only happen for unfaulted anonymous VMAs due to the
page offset equality requirement for merge:

                           |------------|
                           |            |
                           |            v
        |...........||-----------||...........|
        |           || unfaulted ||           |
        |...........||-----------||...........|
              ^            |
              |            |
              |------------|

This becomes problematic if the VMA is configured by the user to
mlock-on-fault, i.e. the VMA_LOCKED_BIT, VMA_LOCKONFAULT_BIT VMA flags are
set.

MREMAP_DONTUNMAP clears mlock flags for the source VMA and maintains them
for the destination VMA.

Self-merge makes this impossible (there is only one VMA) and incorrectly
clears the destination VMA's mlock flags.

This causes a leak in mm->locked_vm as clearing this flag does not
decrement the counter and the VMA no longer has VMA_LOCKED_BIT set so it
is not decremented on unmap.

Resolve this by simply disallowing a self-merge in this case - the source
and destination VMAs are kept distinct and then are able to have distinct
mlock() flags.

Update dontunmap_complete() to make the now-redundant self-merge check a
VM_WARN_ON_ONCE() instead to guard against future regressions.

Also update the VMA userland tests to reflect the change.

Link: https://lore.kernel.org/20260930-fix-dontunmap-partial-self-merge-v2-0-f388985a0f0a@kernel.org
Link: https://lore.kernel.org/20260930-fix-dontunmap-partial-self-merge-v2-1-f388985a0f0a@kernel.org
Fixes: e346b3813067 ("mm/mremap: add MREMAP_DONTUNMAP to mremap()")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Tested-by: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
---

 mm/mremap.c                   |    8 ++++++--
 mm/vma.c                      |   17 ++++++++++++++++-
 mm/vma.h                      |    2 +-
 tools/testing/vma/tests/vma.c |   10 +++++-----
 4 files changed, 28 insertions(+), 9 deletions(-)

--- a/mm/mremap.c~mm-mremap-fix-locked_vm-leak-from-mremap_dontunmap-self-merge
+++ a/mm/mremap.c
@@ -1275,7 +1275,8 @@ static int copy_vma_and_data(struct vma_
 	PAGETABLE_MOVE(pmc, NULL, NULL, vrm->addr, vrm->new_addr, vrm->old_len);
 
 	new_vma = copy_vma(&vma, vrm->new_addr, vrm->new_len, new_pgoff,
-			   new_anon_pgoff, &pmc.need_rmap_locks);
+			   new_anon_pgoff, &pmc.need_rmap_locks,
+			   vrm->flags & MREMAP_DONTUNMAP);
 	if (!new_vma) {
 		vrm_uncharge(vrm);
 		*new_vma_ptr = NULL;
@@ -1335,6 +1336,9 @@ static void dontunmap_complete(struct vm
 	unsigned long old_start = vma->vm_start;
 	unsigned long old_end = vma->vm_end;
 
+	/* Self-merge is disallowed. */
+	VM_WARN_ON_ONCE(new_vma == vma);
+
 	/* We always clear VMA_LOCKED[ONFAULT]_BIT on the old VMA. */
 	vma_clear_flags_mask(vma, VMA_LOCKED_MASK);
 
@@ -1342,7 +1346,7 @@ static void dontunmap_complete(struct vm
 	 * anon_vma links of the old vma is no longer needed after its page
 	 * table has been moved.
 	 */
-	if (new_vma != vma && start == old_start && end == old_end) {
+	if (start == old_start && end == old_end) {
 		const pgoff_t pgoff_unfaulted = vma->vm_start >> PAGE_SHIFT;
 
 		unlink_anon_vmas(vma);
--- a/mm/vma.c~mm-mremap-fix-locked_vm-leak-from-mremap_dontunmap-self-merge
+++ a/mm/vma.c
@@ -1943,7 +1943,7 @@ static int vma_link(struct mm_struct *mm
  */
 struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 	unsigned long addr, unsigned long len, pgoff_t pgoff,
-	pgoff_t anon_pgoff, bool *need_rmap_locks)
+	pgoff_t anon_pgoff, bool *need_rmap_locks, bool keep_source)
 {
 	struct vm_area_struct *vma = *vmap;
 	unsigned long old_vma_start = vma->vm_start;
@@ -1981,6 +1981,21 @@ struct vm_area_struct *copy_vma(struct v
 	vmg.pgoff = pgoff;
 	vmg.anon_pgoff = anon_pgoff;
 	vmg.next = vma_iter_next_rewind(&vmi, NULL);
+
+	/*
+	 * If the original VMA is kept (MREMAP_DONTUNMAP), the source and
+	 * destination VMA must be treated distinctly.
+	 *
+	 * A merge violates this, so in this case disallow a self-merge.
+	 */
+	if (can_self_merge && keep_source) {
+		if (vmg.prev == vma)
+			vmg.prev = NULL;
+		if (vmg.next == vma)
+			vmg.next = NULL;
+		can_self_merge = false;
+	}
+
 	new_vma = vma_merge_copied_range(&vmg);
 
 	if (new_vma) {
--- a/mm/vma.h~mm-mremap-fix-locked_vm-leak-from-mremap_dontunmap-self-merge
+++ a/mm/vma.h
@@ -535,7 +535,7 @@ void unlink_file_vma_batch_add(struct un
 
 struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 	unsigned long addr, unsigned long len, pgoff_t pgoff,
-	pgoff_t anon_pgoff, bool *need_rmap_locks);
+	pgoff_t anon_pgoff, bool *need_rmap_locks, bool keep_source);
 
 struct anon_vma *find_mergeable_anon_vma(struct vm_area_struct *vma);
 
--- a/tools/testing/vma/tests/vma.c~mm-mremap-fix-locked_vm-leak-from-mremap_dontunmap-self-merge
+++ a/tools/testing/vma/tests/vma.c
@@ -40,7 +40,7 @@ static bool test_copy_vma(void)
 	vma = alloc_and_link_vma(&mm, 0x1000, 0x2000, 1, vma_flags);
 	vma_set_anonymous(vma);
 	vma_orig = vma;
-	vma_new = copy_vma(&vma, 0x2000, 0x1000, 1, 1, &need_locks);
+	vma_new = copy_vma(&vma, 0x2000, 0x1000, 1, 1, &need_locks, false);
 	ASSERT_EQ(vma_new, vma_orig);
 	ASSERT_EQ(vma, vma_orig);
 	ASSERT_EQ(vma_new->vm_start, 0x1000);
@@ -53,7 +53,7 @@ static bool test_copy_vma(void)
 	vma = alloc_and_link_vma(&mm, 0x2000, 0x3000, 2, vma_flags);
 	vma_set_anonymous(vma);
 	vma_orig = vma;
-	vma_new = copy_vma(&vma, 0x1000, 0x1000, 2, 2, &need_locks);
+	vma_new = copy_vma(&vma, 0x1000, 0x1000, 2, 2, &need_locks, false);
 	ASSERT_EQ(vma_new, vma_orig);
 	ASSERT_EQ(vma, vma_orig);
 	ASSERT_EQ(vma_new->vm_start, 0x1000);
@@ -71,7 +71,7 @@ static bool test_copy_vma(void)
 	vma = alloc_and_link_vma(&mm, 0x3000, 0x4000, 3, vma_flags);
 	vma_set_anonymous(vma);
 	vma_orig = vma;
-	vma_new = copy_vma(&vma, 0x2000, 0x1000, 3, 3, &need_locks);
+	vma_new = copy_vma(&vma, 0x2000, 0x1000, 3, 3, &need_locks, false);
 	ASSERT_NE(vma_new, vma_orig);
 	ASSERT_EQ(vma_new, vma);
 	ASSERT_EQ(vma_new->vm_start, 0x1000);
@@ -82,7 +82,7 @@ static bool test_copy_vma(void)
 	/* Move backwards and do not merge. */
 
 	vma = alloc_and_link_vma(&mm, 0x3000, 0x5000, 3, vma_flags);
-	vma_new = copy_vma(&vma, 0, 0x2000, 0, 3, &need_locks);
+	vma_new = copy_vma(&vma, 0, 0x2000, 0, 3, &need_locks, false);
 	ASSERT_NE(vma_new, vma);
 	ASSERT_EQ(vma_new->vm_start, 0);
 	ASSERT_EQ(vma_new->vm_end, 0x2000);
@@ -95,7 +95,7 @@ static bool test_copy_vma(void)
 
 	vma = alloc_and_link_vma(&mm, 0, 0x2000, 0, vma_flags);
 	vma_next = alloc_and_link_vma(&mm, 0x6000, 0x8000, 6, vma_flags);
-	vma_new = copy_vma(&vma, 0x4000, 0x2000, 4, 4, &need_locks);
+	vma_new = copy_vma(&vma, 0x4000, 0x2000, 4, 4, &need_locks, false);
 	vma_assert_attached(vma_new);
 
 	ASSERT_EQ(vma_new, vma_next);
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-mremap-fix-locked_vm-leak-from-mremap_dontunmap-self-merge.patch
mm-mremap-fix-locked_vm-leak-by-splitting-vma-for-mremap_dontunmap.patch
drivers-char-mem-mmap-readonly-map_shared-dev-zero-correctly.patch
mm-vmpressure-remove-window-size-todo.patch
tools-testing-selftests-mm-add-missing-gitignore-entries.patch
mm-move-drivers-char-memc-to-mm-char-memc.patch
mm-implement-file_is_dev_zero-to-uniquely-identify-dev-zero.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch
mm-madvise-swap-in-cowd-map_private-file-mappings-on-madv_willneed.patch
mm-khugepaged-deposit-a-newly-allocated-page-table-on-collapse.patch
mm-enable-mmu_gather_rcu_table_free-for-most-2-level-architectures.patch
mm-enable-mmu_gather_rcu_table_free-for-mmu-riscv.patch
mm-enable-mmu_gather_rcu_table_free-for-mmu-arm.patch
mm-enable-mmu_gather_rcu_table_free-for-arc-microblaze-xtensa.patch
mm-enable-mmu_gather_rcu_table_free-for-sparc64.patch
mm-enable-mmu_gather_rcu_table_free-for-m68k-coldfire.patch
mm-enable-mmu_gather_rcu_table_free-for-sh-x2.patch
mm-enable-mmu_gather_rcu_table_free-for-m68k-motorola.patch
mm-enable-mmu_gather_rcu_table_free-for-sparc32.patch
mm-userland-pgtable-freeing-is-rcu-safe-now-remove-leftover-bits.patch
mm-change-the-contract-for-free_pgtables-update-docs.patch
mm-vma-fix-mmap_prepare-file-handling-remove-file_doesnt_need_get.patch
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
mm-vma-const-ify-vma_assert_stabilised-and-associated-functions.patch
mm-implement-and-use-vma_has_anon_rmap-silence-kcsan.patch
mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma.patch
mm-vma-dont-remove-vma-from-rmap-if-pgoff-unchanged.patch

