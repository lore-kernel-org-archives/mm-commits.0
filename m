Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792800306;
	b=Q5I2pVR6fBOv0zFzpJ0RUKEqdmr1l7F6QaA7NZ948rD3A3R5eU0skg2a6T3i+OFIlqGT
	 5OCrA/EqiULfq57xS8ZuB13MpZAISHXGeFtQFGQ97T8I7/LQnfIPliyfELyzLgS6MStr+
	 hLeq3Qh5dRujqHJlGThhgCL65AEjuMA4PWjCc17fH6E8J+YKgADrFamvyzCHPg8UgAYnp
	 3DkaR1fFZsz3cLpLbFrMhy9eN5WLPXPD7wrmdqvWPHUwBhzXvtTBD2uTKl59KtdoxUpu9
	 ESg2FDMvO8Vs8DMfgqHa3MKD8ScGdCesSqRftabuY+uK5u+pjY68ZfOI21sr+rhER4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792800306;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=KtG4SJTXAFr0ugmTsSNkP6HBOR4OoRJN/UEuKDJo6GM=;
	b=4YqWQZ3IHnhfns3DfTVFPtLS1ad6zpi/YY7lOqlH1JepboDS9qB8tA+qGZ6xJ40VcfYV
	 BGd7L11KiJyJkK3m0QINvaWHRipoB3FTu2M7Ep8HyJk1omysbItxVPfcQCp2X7ySJbRrJ
	 2FnNajP2RLoQuIhzbem6XMmqjsLBQikhnxlppPrWZHDnOb1Qd4wpXuN+sQtB7FSP6vxPT
	 wbH1uplcwPNAhUGYX8+a1E7XCTgEXiAOnBFEaXB4VjcDW7AS/EWlu//8QCZe+S+pud8DG
	 y/VG0XQ94QjtYNEVyuig51F7dL4uLaotI8an+RXExZuvgqXkoRJnwFtKAKWmZtx+hpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=mxbT2BJD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA54606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 00:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=mxbT2BJD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7111F01825;
	Sat, 24 Oct 2026 00:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792800305;
	bh=KtG4SJTXAFr0ugmTsSNkP6HBOR4OoRJN/UEuKDJo6GM=;
	h=Date:To:From:Subject;
	b=mxbT2BJDZc289D0RaagiHhg7WrT8PitKRf7Sty2h965vzKjOZh9qHyCelUFUwEWY4
	 lr5iVlLrLdNKraTxAyeuDmMcp2ALhoqqQnPy5dqD4vNaFUYm/cvscV8lhnR/d15qqm
	 0iNLimB+4L/82whtg7/oi5X0Tc976BATn2slvVgw=
Date: Fri, 23 Oct 2026 17:05:05 -0700
To: mm-commits@vger.kernel.org,tiwai@suse.de,perex@perex.cz,hnkz.64@gmail.com,devnexen@gmail.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alsa-us122l-mark-hwdep-mappings-vm_mixedmap.patch added to mm-unstable branch
Message-Id: <20261024000505.AC7111F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ALSA: us122l: mark hwdep mappings VM_MIXEDMAP
has been added to the -mm mm-unstable branch.  Its filename is
     alsa-us122l-mark-hwdep-mappings-vm_mixedmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alsa-us122l-mark-hwdep-mappings-vm_mixedmap.patch

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
Subject: ALSA: us122l: mark hwdep mappings VM_MIXEDMAP
Date: Fri, 23 Oct 2026 11:21:31 +0100

mm has recently moved to a strict model which requires any driver which
clears VMA_MAYWRITE_BIT to be mapping non-mm-managed memory
(VMA_PFNMAP_BIT or VMA_MIXEDMAP_BIT), failing any such mmap() with an
error and a kernel warning - see "mm/vma: only allow mmap to clear
VMA_MAYWRITE_BIT if not mm-managed".

However, simultaneous to this, commit 71c610aeb177 ("ALSA: us122l: Prevent
write upgrades for read mappings") updated us122l to clear
VMA_MAYWRITE_BIT without marking the region with either VMA_PFNMAP_BIT or
VMA_MIXEDMAP_BIT.

vm_insert_pages() and friends set this automatically, however this driver
maps its pre-allocated pages from a fault handler, so never calls these.

Simply set the flag in usb_stream_hwdep_mmap() to resolve the issue.  This
correctly marks the mapping as one whose pages core mm does not manage,
which has no meaningful impact for this driver beyond preventing the
mmap() from failing.

Link: https://lore.kernel.org/20261023-fix-us122l-mixedmap-v1-1-e7bdd053850f@kernel.org
Fixes: 71c610aeb177 ("ALSA: us122l: Prevent write upgrades for read mappings")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: David Carlier <devnexen@gmail.com>
Closes: https://lore.kernel.org/20261018025905.201296-1-devnexen@gmail.com
Acked-by: Takashi Iwai <tiwai@suse.de>
Cc: Kazuki Hanai <hnkz.64@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
---

 sound/usb/usx2y/us122l.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/usx2y/us122l.c~alsa-us122l-mark-hwdep-mappings-vm_mixedmap
+++ a/sound/usb/usx2y/us122l.c
@@ -193,7 +193,7 @@ static int usb_stream_hwdep_mmap(struct
 	}
 
 	area->vm_ops = &usb_stream_hwdep_vm_ops;
-	vm_flags_set(area, VM_DONTDUMP);
+	vm_flags_set(area, VM_MIXEDMAP | VM_DONTDUMP);
 	if (!read)
 		vm_flags_set(area, VM_DONTEXPAND);
 	area->vm_private_data = us122l;
_

Patches currently in -mm which might be from ljs@kernel.org are

alsa-us122l-mark-hwdep-mappings-vm_mixedmap.patch
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
mm-mremap-correctly-uncharge-accountable-vmas-in-error-path.patch
mm-vma-avoid-broken-uffd-merge-on-mremap.patch
mm-vma-fix-expansion-of-vma_mixedmap_bit-vmas.patch
mm-do-not-unintentionally-overwrite-atomic-vma-flags.patch
mm-vma-avoid-losing-atomic-vma-flags-when-setting-sticky-vma-flags.patch

