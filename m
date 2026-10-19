Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792423540;
	b=bXMS/p603SB1h5mt2p0CivLLW0J6fn19853b4eawe7z9ATVdIkjwMeCv0dFamzZ8+Ewu
	 itmhc6Pa0yRSgy6AeXVNVhLpgU+uBZ+3ygJG77ThgEPFwuKcH+3xcZI+uqevIWBR+vB3A
	 V2bZfXEimKa9Nh3XjrGdjK8/dQtTqkW8Xe1Zw3zbeXN3tbYV42JTbx7qxaT53/ItGUyD+
	 X0Ffxn6sj5pDFPC+FxIaVDaa3AuZAd6iE4m6gzBZSIfpzmdf4B6fmOVZL0EHSQiGqwWqA
	 baBNpm2jtILixDblBcouSyLSjDtSeCE6OVJ2XFvXth4QH8Mz8Q5a/UuCs7lPCoKkPxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792423540;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=r3gDP6UoJvGMYtPEAY65jk12MBrqbeMHCnp/Y0+eON8=;
	b=MSDbGmSpUH2dd5Y++mJE+8UAFDl52/gn/s3DesT2MVYfI/3Wb3OrL6H80l6huAuShkd8
	 0kVimG0obpfu6n4UWCQfJWhFbNK9fFFXeecU0qTSAKLz3YxyGzw7lUsul3whb7jLnFpRj
	 dPCFDoEaotygjQvaMetWYA6aFfzxcT9EHNoPTslCzJabZfx3bN2cNg0spaUtEw9B7SC3k
	 xdlawCoLyU8d5ee77U1eDvt6/N1mHIhRrrfIha8CLbDmUHTH2vBEPwGtPjGZMqjQbgqlf
	 0DXjdeE9kNy0kjRZpPh6H/FUMNq3jh5yH0ITxpQFI+cjjJFs+PCnE0FECyXMqK5wMNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=IBnuk2tm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42E860B09A2;
	Mon, 19 Oct 2026 15:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=IBnuk2tm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B15E1F000C4;
	Mon, 19 Oct 2026 15:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792423539;
	bh=r3gDP6UoJvGMYtPEAY65jk12MBrqbeMHCnp/Y0+eON8=;
	h=Date:To:From:Subject;
	b=IBnuk2tm/ELE1EOtXW6bIcshlqm5AOIuEPxIPvla5yeP1KkhlIZnSpSW0rDJ2Y6a9
	 cmuL41v8qw5oXU1XuY5M9h7KqX4qxkBiwlGOh3AYNuBhb0hwWCASBWbWVjOwWyQXNJ
	 4qFq6zuGBYKAdPTfa+yGC20mTTCV8x0dmE3wmS1I=
Date: Mon, 19 Oct 2026 08:25:38 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,pfalcato@suse.de,nickolai@csail.mit.edu,liam@infradead.org,jannh@google.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-populate-calculated-fields-in-vrm-state-correctly.patch added to mm-unstable branch
Message-Id: <20261019152539.5B15E1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mremap: populate calculated fields in vrm state correctly
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mremap-populate-calculated-fields-in-vrm-state-correctly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-populate-calculated-fields-in-vrm-state-correctly.patch

This patch will later appear in the mm-unstable branch at
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
Subject: mm/mremap: populate calculated fields in vrm state correctly
Date: Mon, 19 Oct 2026 15:28:27 +0100

Commit d5c8aec0542e ("mm/mremap: initial refactor of move_vma()")
introduced the vma_remap_struct helper to pass state sanely through
mremap() logic.

Part of this state is vrm->delta - equal to the absolute difference between
vrm->old_len and vrm->new_len (the old and new lengths of the VMA,
respectively).

This value is used to correctly charge accounted VMAs.

When shrinking a VMA, mremap_to() sets vrm->old_len equal to vrm->new_len
having performed the shrink of the VMA first, prior to any potential move
(e.g.  MREMAP_FIXED | MREMAP_MAYMOVE specified).

However it does not recalculate vrm->delta, which results in incorrectly
overcharging the VMA when both moving and shrinking a VMA.

The charge leaks to Committed_AS globally, meaning a mischievous user can
cause allocations to fail across the system in strict overcommit mode.

Resolve the issue by abstracting the update of vrm->delta to
vrm_populate_calculated() and invoking this from mremap_to() when
vrm->old_len is changed.

Additionally, update vrm->remap_type whose value depends on vrm->delta. 
The field is not read again after the shrink, but it is the logically
correct thing to do and protects against future changes which break this.

Link: https://lore.kernel.org/20261019-mremap-fix-shrink-charge-v1-1-a3ce209e5360@kernel.org
Fixes: d5c8aec0542e ("mm/mremap: initial refactor of move_vma()")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Closes: https://lore.kernel.org/all/20261017233527.797191-1-nickolai@csail.mit.edu/
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: <stable@vger.kernel.org>
---

 mm/mremap.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/mm/mremap.c~mm-mremap-populate-calculated-fields-in-vrm-state-correctly
+++ a/mm/mremap.c
@@ -887,12 +887,6 @@ again:
 	return pmc_progress(pmc);
 }
 
-/* Set vrm->delta to the difference in VMA size specified by user. */
-static void vrm_set_delta(struct vma_remap_struct *vrm)
-{
-	vrm->delta = abs_diff(vrm->old_len, vrm->new_len);
-}
-
 /* Determine what kind of remap this is - shrink, expand or no resize at all. */
 static enum mremap_type vrm_remap_type(struct vma_remap_struct *vrm)
 {
@@ -905,6 +899,13 @@ static enum mremap_type vrm_remap_type(s
 	return MREMAP_EXPAND;
 }
 
+/* Populate calculated fields. */
+static void vrm_populate_calculated(struct vma_remap_struct *vrm)
+{
+	vrm->delta = abs_diff(vrm->old_len, vrm->new_len);
+	vrm->remap_type = vrm_remap_type(vrm);
+}
+
 /*
  * When moving a VMA to vrm->new_adr, does this result in the new and old VMAs
  * overlapping?
@@ -1523,6 +1524,7 @@ static unsigned long mremap_to(struct vm
 
 		/* Set up for the move now shrink has been executed. */
 		vrm->old_len = vrm->new_len;
+		vrm_populate_calculated(vrm);
 	}
 
 	/* MREMAP_DONTUNMAP expands by old_len since old_len == new_len */
@@ -1795,8 +1797,7 @@ static int check_prep_vma(struct vma_rem
 	if (vma_is_hugetlb(vma) && !align_hugetlb(vrm))
 		return -EINVAL;
 
-	vrm_set_delta(vrm);
-	vrm->remap_type = vrm_remap_type(vrm);
+	vrm_populate_calculated(vrm);
 	/* For convenience, we set new_addr even if VMA won't move. */
 	if (!vrm_implies_new_addr(vrm))
 		vrm->new_addr = addr;
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-fix-mmap_prepare-file-handling-remove-file_doesnt_need_get.patch
mm-vma-introduce-and-use-vma_can_merge.patch
mm-consistently-validate-vma-state-after-mmap-hooks.patch
mm-vma-ensure-mmap_prepare-doesnt-set-actions-on-a-mergeable-vma.patch
mm-make-map_kernel_pages_-internal-and-unexported.patch
mm-vma-tidy-up-map-kernel-pages-enum-values.patch
mm-assert-mmap-lock-held-use-new-flags-api-in-vm_insert_page.patch
mm-add-mmap-action-for-discontiguous-kernel-page-mapping.patch
docs-filesystems-update-mmap_prepare-docs-for-discontig-kernel-pgs.patch
drivers-usb-mon-update-to-use-mmap_prepare-map-kernel-pages.patch
infiniband-update-hfi1-to-use-remap_vmalloc_range.patch
selinux-reject-writable-opens-of-policy-file-drop-mmap-shared-write-check.patch
alsa-pcm-use-vm_insert_page-to-map-pcm-status-page.patch
bpf-arena-mark-arena_map_mmap-mappings-vm_mixedmap.patch
mm-vma-add-vma_is_mm_managed-predicates.patch
mm-vma-only-allow-mmap-to-clear-vma_maywrite_bit-if-not-mm-managed.patch
mm-vma-add-and-use-vma__is_fixed_mapping.patch
scsi-sg-convert-mmap-hook-to-mmap_prepare-and-rework.patch
fbdev-defio-assert-fbinfo_virtfb-drop-vm_io-add-vm_mixedmap.patch
hsi-cmt_speech-convert-mmap-hook-to-mmap_prepare-refactor.patch
mm-gup-error-out-early-on-vma_mayread_bit-vmas.patch
uprobes-remove-vm_io-set-vm_mixedmap-for-mapped-kernel-pages.patch
mm-mlock-clear-vma_locked_mask-over-mmap-callback.patch
mm-mlock-eliminate-weird-vma_io_bit-abuse-and-simplify.patch
mm-vma-enforce-that-mm-managed-mappings-may-not-set-vma_io_bit.patch
mm-remove-vma_io_bit-check-in-vma_is_mm_managed.patch
mm-remove-hugetlb_inlineh.patch
mm-rename-is_vm_hugetlb_page-to-vma_is_hugetlb.patch
mm-drop-some-redundant-checks-around-hugetlb-vmas.patch
mm-vma-introduce-vma_is_mm_backed.patch
mm-madvise-update-is_valid_guard_vma-to-use-vma_is_mm_backed.patch
mm-uffd-use-predicates-for-userfaultfd-checks.patch
mm-madvise-use-predicates-for-madvise-madv_dofork.patch
mm-eliminate-vma_special_flags-usage-when-hugetlb-explicitly-tested.patch
mm-eliminate-vma_special_flags-check-in-lru_gen_look_around.patch
mm-avoid-use-of-vma_special_flags-in-migrate_vma_setup.patch
mm-eliminate-vm_special-vma_special_flags.patch
fuse-dax-do-not-set-vm_mixedmap.patch
mm-huge_memory-remove-vma_is_special_huge.patch
mm-vma-const-ify-vma_assert_stabilised-and-associated-functions.patch
mm-implement-and-use-vma_has_anon_rmap-silence-kcsan.patch
mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma.patch
mm-vma-dont-remove-vma-from-rmap-if-pgoff-unchanged.patch
mm-vma-avoid-spurious-write-locks-when-mm-mm_lock_seq-overflows.patch
mm-mremap-populate-calculated-fields-in-vrm-state-correctly.patch

