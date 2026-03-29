Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F6F261B91
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744890; cv=none; b=gVrjZQrsbbHseAyYWiN/WQvW7ShmxDSarVi+GRySXIvHZJ/e/621bLPENjOxKM6PWT9g5QPLlc5bxfoTtAsdu5x8giiG6Zt5m/MuVAVFpuUg3UjYhLJrGaqxtMc+3AE0005DytDEndgB6m0jSorYhAD9DtYCmXN7OC3XIY1iKcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744890; c=relaxed/simple;
	bh=E+GpVxrlSNFr5KYudHxemNTrtunT3fHUWJtQYghLs+s=;
	h=Date:To:From:Subject:Message-Id; b=CoTiXiFW442k3WRuLO7TtimRWA7ZNh+ZHzce/H/oqKXss8l8Aeo2CcSeq4LT9hMUBd8IF+NFEMYsVmtuB3Z0IxXqEI9yg9b3KiUk/OxHEX6PRYPHwiInAFnPnatM01VhssucyZ/O5tnuMGdiSZb0wyNh/dns5FQkLqfERttqb/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FSyXV/+h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FSyXV/+h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B14BC4CEF7;
	Sun, 29 Mar 2026 00:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744890;
	bh=E+GpVxrlSNFr5KYudHxemNTrtunT3fHUWJtQYghLs+s=;
	h=Date:To:From:Subject:From;
	b=FSyXV/+hspAkbXzXi3MMn81w45EA3Vs6KlkWWm8Ti8otlkqtehy7EyHgwjWzt534A
	 cn+w5lg5TLMG5p2xsvRAayXTm7QvI+nhad7BT72zKM83xCmCROq9srm/jArjlERO6n
	 /Pl12IFTRaz8eRBq5Ya9L6OXePKKADkoJFEGr7Hs=
Date: Sat, 28 Mar 2026 17:41:29 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,osalvador@suse.de,mhocko@suse.com,luckd0g@163.com,liam.howlett@oracle.com,jannh@google.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mremap-correct-invalid-map-count-check.patch removed from -mm tree
Message-Id: <20260329004130.2B14BC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mremap: correct invalid map count check
has been removed from the -mm tree.  Its filename was
     mm-mremap-correct-invalid-map-count-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: mm/mremap: correct invalid map count check
Date: Wed, 11 Mar 2026 17:24:36 +0000

Patch series "mm: improve map count checks".

Firstly, in mremap(), it appears that our map count checks have been overly
conservative - there is simply no reason to require that we have headroom
of 4 mappings prior to moving the VMA, we only need headroom of 2 VMAs
since commit 659ace584e7a ("mmap: don't return ENOMEM when mapcount is
temporarily exceeded in munmap()").

Likely the original headroom of 4 mappings was a mistake, and 3 was
actually intended.

Next, we access sysctl_max_map_count in a number of places without being
all that careful about how we do so.

We introduce a simple helper that READ_ONCE()'s the field
(get_sysctl_max_map_count()) to ensure that the field is accessed
correctly.  The WRITE_ONCE() side is already handled by the sysctl procfs
code in proc_int_conv().

We also move this field to internal.h as there's no reason for anybody
else to access it outside of mm.  Unfortunately we have to maintain the
extern variable, as mmap.c implements the procfs code.

Finally, we are accessing current->mm->map_count without holding the mmap
write lock, which is also not correct, so this series ensures the lock is
head before we access it.

We also abstract the check to a helper function, and add ASCII diagrams to
explain why we're doing what we're doing.


This patch (of 3):

We currently check to see, if on moving a VMA when doing mremap(), if it
might violate the sys.vm.max_map_count limit.

This was introduced in the mists of time prior to 2.6.12.

At this point in time, as now, the move_vma() operation would copy the VMA
(+1 mapping if not merged), then potentially split the source VMA upon
unmap.

Prior to commit 659ace584e7a ("mmap: don't return ENOMEM when mapcount is
temporarily exceeded in munmap()"), a VMA split would check whether
mm->map_count >= sysctl_max_map_count prior to a split before it ran.

On unmap of the source VMA, if we are moving a partial VMA, we might split
the VMA twice.

This would mean, on invocation of split_vma() (as was), we'd check whether
mm->map_count >= sysctl_max_map_count with a map count elevated by one,
then again with a map count elevated by two, ending up with a map count
elevated by three.

At this point we'd reduce the map count on unmap.

At the start of move_vma(), there was a check that has remained throughout
mremap()'s history of mm->map_count >= sysctl_max_map_count - 3 (which
implies mm->mmap_count + 4 > sysctl_max_map_count - that is, we must have
headroom for 4 additional mappings).

After mm->map_count is elevated by 3, it is decremented by one once the
unmap completes. The mmap write lock is held, so nothing else will observe
mm->map_count > sysctl_max_map_count.

It appears this check was always incorrect - it should have either be one
of 'mm->map_count > sysctl_max_map_count - 3' or 'mm->map_count >=
sysctl_max_map_count - 2'.

After commit 659ace584e7a ("mmap: don't return ENOMEM when mapcount is
temporarily exceeded in munmap()"), the map count check on split is
eliminated in the newly introduced __split_vma(), which the unmap path
uses, and has that path check whether mm->map_count >=
sysctl_max_map_count.

This is valid since, net, an unmap can only cause an increase in map count
of 1 (split both sides, unmap middle).

Since we only copy a VMA and (if MREMAP_DONTUNMAP is not set) unmap
afterwards, the maximum number of additional mappings that will actually be
subject to any check will be 2.

Therefore, update the check to assert this corrected value. Additionally,
update the check introduced by commit ea2c3f6f5545 ("mm,mremap: bail out
earlier in mremap_to under map pressure") to account for this.

While we're here, clean up the comment prior to that.

Link: https://lkml.kernel.org/r/cover.1773249037.git.ljs@kernel.org
Link: https://lkml.kernel.org/r/73e218c67dcd197c5331840fb011e2c17155bfb0.1773249037.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jianzhou Zhao <luckd0g@163.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

--- a/mm/mremap.c~mm-mremap-correct-invalid-map-count-check
+++ a/mm/mremap.c
@@ -1041,10 +1041,11 @@ static unsigned long prep_move_vma(struc
 	vm_flags_t dummy = vma->vm_flags;
 
 	/*
-	 * We'd prefer to avoid failure later on in do_munmap:
-	 * which may split one vma into three before unmapping.
+	 * We'd prefer to avoid failure later on in do_munmap: we copy a VMA,
+	 * which may not merge, then (if MREMAP_DONTUNMAP is not set) unmap the
+	 * source, which may split, causing a net increase of 2 mappings.
 	 */
-	if (current->mm->map_count >= sysctl_max_map_count - 3)
+	if (current->mm->map_count + 2 > sysctl_max_map_count)
 		return -ENOMEM;
 
 	if (vma->vm_ops && vma->vm_ops->may_split) {
@@ -1804,20 +1805,15 @@ static unsigned long check_mremap_params
 		return -EINVAL;
 
 	/*
-	 * move_vma() need us to stay 4 maps below the threshold, otherwise
-	 * it will bail out at the very beginning.
-	 * That is a problem if we have already unmapped the regions here
-	 * (new_addr, and old_addr), because userspace will not know the
-	 * state of the vma's after it gets -ENOMEM.
-	 * So, to avoid such scenario we can pre-compute if the whole
-	 * operation has high chances to success map-wise.
-	 * Worst-scenario case is when both vma's (new_addr and old_addr) get
-	 * split in 3 before unmapping it.
-	 * That means 2 more maps (1 for each) to the ones we already hold.
-	 * Check whether current map count plus 2 still leads us to 4 maps below
-	 * the threshold, otherwise return -ENOMEM here to be more safe.
+	 * We may unmap twice before invoking move_vma(), that is if new_len <
+	 * old_len (shrinking), and in the MREMAP_FIXED case, unmapping part of
+	 * a VMA located at the destination.
+	 *
+	 * In the worst case, both unmappings will cause splits, resulting in a
+	 * net increased map count of 2. In move_vma() we check for headroom of
+	 * 2 additional mappings, so check early to avoid bailing out then.
 	 */
-	if ((current->mm->map_count + 2) >= sysctl_max_map_count - 3)
+	if (current->mm->map_count + 4 > sysctl_max_map_count)
 		return -ENOMEM;
 
 	return 0;
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-add-vma_flags_empty-vma_flags_and-vma_flags_diff_pair.patch
tools-testing-vma-add-unit-tests-flag-empty-diff_pair-and.patch
mm-vma-add-further-vma_flags_t-unions.patch
tools-testing-vma-convert-bulk-of-test-code-to-vma_flags_t.patch
mm-vma-use-new-vma-flags-for-sticky-flags-logic.patch
tools-testing-vma-fix-vma-flag-tests.patch
mm-vma-add-append_vma_flags-helper.patch
tools-testing-vma-add-simple-test-for-append_vma_flags.patch
mm-unexport-vm_brk_flags-and-eliminate-vm_flags-parameter.patch
mm-vma-introduce-vma_flags_same.patch
mm-vma-introduce-_to_-helpers.patch
tools-testing-vma-test-that-legacy-flag-helpers-work-correctly.patch
mm-vma-introduce-vma_test-and-make-inlining-consistent.patch
tools-testing-vma-update-vma-flag-tests-to-test-vma_test.patch
mm-introduce-vma_flags_count-and-vma_test_single_mask.patch
tools-testing-vma-test-vma_flags_countvma_test_single_mask.patch
mm-convert-do_brk_flags-to-use-vma_flags_t.patch
mm-update-vma_supports_mlock-to-use-new-vma-flags.patch
mm-vma-introduce-vma_clear_flags.patch
tools-testing-vma-update-vma-tests-to-test-vma_clear_flags.patch
mm-vma-convert-as-much-as-we-can-in-mm-vmac-to-vma_flags_t.patch
tools-bitmap-add-missing-bitmap_copy-implementation.patch
mm-vma-convert-vma_modify_flags-to-use-vma_flags_t.patch
mm-vma-convert-__mmap_region-to-use-vma_flags_t.patch
mm-simplify-vma-flag-tests-of-excluded-flags.patch
mm-various-small-mmap_prepare-cleanups.patch
mm-add-documentation-for-the-mmap_prepare-file-operation-callback.patch
mm-document-vm_operations_struct-open-the-same-as-close.patch
mm-avoid-deadlock-when-holding-rmap-on-mmap_prepare-error.patch
mm-switch-the-rmap-lock-held-option-off-in-compat-layer.patch
mm-vma-remove-superfluous-map-hold_file_rmap_lock.patch
mm-have-mmap_action_complete-handle-the-rmap-lock-and-unmap.patch
mm-add-vm_ops-mapped-hook.patch
fs-afs-revert-mmap_prepare-change.patch
fs-afs-restore-mmap_prepare-implementation.patch
mm-add-mmap_action_simple_ioremap.patch
misc-open-dice-replace-deprecated-mmap-hook-with-mmap_prepare.patch
hpet-replace-deprecated-mmap-hook-with-mmap_prepare.patch
mtdchar-replace-deprecated-mmap-hook-with-mmap_prepare-clean-up.patch
stm-replace-deprecated-mmap-hook-with-mmap_prepare.patch
staging-vme_user-replace-deprecated-mmap-hook-with-mmap_prepare.patch
mm-allow-handling-of-stacked-mmap_prepare-hooks-in-more-drivers.patch
drivers-hv-vmbus-replace-deprecated-mmap-hook-with-mmap_prepare.patch
uio-replace-deprecated-mmap-hook-with-mmap_prepare-in-uio_info.patch
mm-add-mmap_action_map_kernel_pages.patch
mm-on-remap-assert-that-input-range-within-the-proposed-vma.patch
mm-huge_memory-simplify-vma_is_specal_huge.patch
mm-huge-avoid-big-else-branch-in-zap_huge_pmd.patch
mm-huge_memory-have-zap_huge_pmd-return-a-boolean-add-kdoc.patch
mm-huge_memory-handle-buggy-pmd-entry-in-zap_huge_pmd.patch
mm-huge_memory-add-a-common-exit-path-to-zap_huge_pmd.patch
mm-huge_memory-remove-unnecessary-vm_bug_on_page.patch
mm-huge_memory-deduplicate-zap-deposited-table-call.patch
mm-huge_memory-remove-unnecessary-sanity-checks.patch
mm-huge_memory-use-mm-instead-of-tlb-mm.patch
mm-huge_memory-separate-out-the-folio-part-of-zap_huge_pmd.patch
mm-add-softleaf_is_valid_pmd_entry-pmd_to_softleaf_folio.patch
mm-huge_memory-add-and-use-normal_or_softleaf_folio_pmd.patch
mm-huge_memory-add-and-use-has_deposited_pgtable.patch
maintainers-update-mglru-entry-to-reflect-current-status.patch

