Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792425780;
	b=kKffY9aCOtsK5xbiCgrhrBUEcwspnYIN8BiBoefwXo/Tlr2KISLKM3rrPGe7QDEa8BBf
	 30RROWn8n7bkeQ051v83+Y8O/RSQmgt5Z7/zMgDHR+l9kjfPeGiwy7m327n1+e8VSTGs1
	 ImLU/Lm10UDtHBDDJkn2k/bzIFpQ+w7ihGta+leRzoVJYdptO+88doeIq3Ucg7fkZo9ZS
	 De8g4WD3reAo1clDOIojvSSYYYUnfSRkEbjd2hvWtiC8xgrXb8E0P3YJcvz/1h65vvHeg
	 GBchkQG5kHpkbBsDYKE+ZlFnF/gbv6Lpi3DiKlPH3Pbc7oP3ijQumJDG+Vz4dfais6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792425780;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=i304SC/HQYDOIv0BcT5DzauQuw5vfS8n4xRru+qlH6M=;
	b=lyWCypukdzuc+aZ9zX4KLGXkjNwOWH1elw0PGXzOaMjVLDj+PWKI/grpomvq/3MJC91z
	 DBMDm4aDFGpER35Uc/fyEGCobWg9YQ7xUqz4EwBWqoB1uGxvGafkzQTAe/ai+ZLmCbBnJ
	 2y6t50vWQp4N4z8srl+a69v9MgLPpzpxw/zJ7k1+axdTvrG7GjjvgqRRhRzJ1gph0Nnxp
	 Nu9HEuB+VG89t9EokLgwzqCM2z3J7dzVz6Qbr7mv2B9tAZ0GfUmEfrRT+nXM11xkyvoRH
	 fMLAd55acLlc9Pjdq/h6h5eiesImgWimHiPUfmsWAFTuRRcaf5/d6SSZ97Y7DQTa8XA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=j8SXMp3L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5CE16075539;
	Mon, 19 Oct 2026 16:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=j8SXMp3L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5721F000C4;
	Mon, 19 Oct 2026 16:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792425779;
	bh=i304SC/HQYDOIv0BcT5DzauQuw5vfS8n4xRru+qlH6M=;
	h=Date:To:From:Subject;
	b=j8SXMp3Lvie4k0gZzd9r800DRhbKuLBXuSNivcdW0pC7a0Sev/Sn8t0lsumoChwuR
	 46rECvsMKxt3jNFo5YtaOjJA8Gi6gUlAQR5uTLRFI6msgM2uyEVeWR1zkrqXBdjEH0
	 6jeXLkkVb+SVfLxHvehCapmS0NIqDTA8dC5fE5es=
Date: Mon, 19 Oct 2026 09:02:59 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,pfalcato@suse.de,liam@infradead.org,jannh@google.com,bgeffon@google.com,0x7f454c46@gmail.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-correctly-uncharge-accountable-vmas-in-error-path.patch added to mm-unstable branch
Message-Id: <20261019160259.7A5721F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mremap: correctly uncharge accountable VMAs in error path
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mremap-correctly-uncharge-accountable-vmas-in-error-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-correctly-uncharge-accountable-vmas-in-error-path.patch

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
Subject: mm/mremap: correctly uncharge accountable VMAs in error path
Date: Mon, 19 Oct 2026 16:57:48 +0100

The mremap error path is a fragile and unwieldy beast - it reverses the
page table move then updates vma_remap_struct state to swap VMA, length and
address between old and new VMAs in copy_vma_and_data().

If the mremap() operation didn't specify MREMAP_DONTUNMAP then its caller,
move_vma(), invokes unmap_source_vma(), which unmaps the new VMA rather
than the old one.

For accountable VMAs when MREMAP_DONTUNMAP is not specified,
unmap_source_vma() unsets VMA_ACCOUNT_BIT during this unmap in order that
only the delta of a VMA expansion is charged (performed by
vrm_calc_charge() earlier).

Therefore nothing uncharges the expanded VMA size, and there is a permanent
leak in global Committed_AS.

Resolve the issue by uncharging when MREMAP_DONTUNMAP is not specified.

Link: https://lore.kernel.org/20261019-other-mremap-charge-leak-v1-1-d94477fe6545@kernel.org
Fixes: fdbef6149135 ("mm/mremap: don't account pages in vma_to_resize()")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: <stable@vger.kernel.org>
---

 mm/mremap.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/mm/mremap.c~mm-mremap-correctly-uncharge-accountable-vmas-in-error-path
+++ a/mm/mremap.c
@@ -1339,6 +1339,20 @@ static int copy_vma_and_data(struct vma_
 		pmc_revert.need_rmap_locks = true;
 		move_page_tables(&pmc_revert);
 
+		/*
+		 * When copy_vma_and_data() returns, the new VMA will be
+		 * unmapped rather than the old one.
+		 *
+		 * When an accountable move is being performed, this unmapping
+		 * will not uncharge any expansion, so do that now.
+		 *
+		 * A move is accountable if the VMA is accountable and
+		 * MREMAP_DONTUNMAP is not specified, so only do so if the
+		 * latter is true.
+		 */
+		if (!(vrm->flags & MREMAP_DONTUNMAP))
+			vrm_uncharge(vrm);
+
 		vrm->vma = new_vma;
 		vrm->old_len = vrm->new_len;
 		vrm->addr = vrm->new_addr;
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
mm-mremap-correctly-uncharge-accountable-vmas-in-error-path.patch

