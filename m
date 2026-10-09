Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A1D3F6C30
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525423; cv=none; b=N1mzuGyPAs+rZ49UfroTzjljH9ke3jDBlhAWzSDKcQ82s7bWzRB8jDmFopkv0VS1hICaiSKj2uNNI6nfSv4AmXSHa00GHzX6yNSTGDzBv22jBFvIycgDv7fQ3dYKLFyDF2Q2QRBBCtVEiT1CKuUOU74pRL7oYODXstBMgelu9vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525423; c=relaxed/simple;
	bh=pWGFp52wwSAdWGNzChufJ5/ZQe6/70Svua8YrISCgJs=;
	h=Date:To:From:Subject:Message-Id; b=DyZKBZnODt6hlngO51c8BvW9r5Zggw1lmE0RqkqDQGo+oKoeywZ3QhvtGxfIxqIsqaglovMtHeXGjNIY+iKtZbgh6Ocp2lSuLI73tRTfdmsiTrYPklsMKbKiVrtEB3yE0WfyfxGGW2J8B8bFTZW0naNlxYJa+7I/ZXzaak8oSMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M0Wm6aOs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M0Wm6aOs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A15B1F00893;
	Fri,  9 Oct 2026 05:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525421;
	bh=h1RrV2zPgDCCGSOnAcoiJznPSR8880JMSyE9GLVso7c=;
	h=Date:To:From:Subject;
	b=M0Wm6aOsHfUHKrGcGNP8J/0MFVaNndPVVG7iVCrSsNWxnu7X4orq+ovA9b99X8S1j
	 DQ411NV9Km25o/OHCt3QHFeOUefYNKJuQ3FBnQZeu9etpyEqwhF9IeaELgI1diEvJ7
	 75BPzcmIha6rntPfUUYtPxIC0kxS+izOaURrfMmo=
Date: Thu, 08 Oct 2026 22:57:01 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,pfalcato@suse.de,mike@recall.ai,liam@infradead.org,jannh@google.com,david@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-madvise-swap-in-cowd-map_private-file-mappings-on-madv_willneed.patch removed from -mm tree
Message-Id: <20261009055701.8A15B1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/madvise: swap in CoW'd MAP_PRIVATE-file mappings on MADV_WILLNEED
has been removed from the -mm tree.  Its filename was
     mm-madvise-swap-in-cowd-map_private-file-mappings-on-madv_willneed.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/madvise: swap in CoW'd MAP_PRIVATE-file mappings on MADV_WILLNEED
Date: Thu, 3 Sep 2026 20:08:39 +0100

Currently MADV_WILLNEED treats file-backed and pure anonymous mappings
entirely separately - using POSIX_FADV_WILLNEED (equivalent of a
readahead) for the former and a tree walk and swap in to swap cache for
the latter.

MAP_PRIVATE-file backed mappings straddle the two and currently get
treated as if they were purely file-backed, meaning any swapped out
private pages remain swapped out.

Resolve the issue by explicitly checking for CoW'd MAP_PRIVATE-file backed
mappings and performing both walks in this case.

Since the logic checks for vma->anon_vma this means un-CoW'd
MAP_PRIVATE-file backed mappings retain only the single file walk.

Link: https://lore.kernel.org/aprjOxDy3JCPb2oa@gremlin
Reported-by: Mike Kaplinskiy <mike@recall.ai>
Closes: https://lore.kernel.org/all/CABeknB_S2XJSHFgnHdgnN0rjzHhH4oQJs_APq9fvxHztQ_pgiA@mail.gmail.com/
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
---

 mm/madvise.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/madvise.c~mm-madvise-swap-in-cowd-map_private-file-mappings-on-madv_willneed
+++ a/mm/madvise.c
@@ -297,11 +297,12 @@ static long madvise_willneed(struct madv
 	loff_t offset;
 
 #ifdef CONFIG_SWAP
-	if (!file) {
+	if (vma_is_cow_mapping(vma) && vma->anon_vma) {
 		walk_page_range_vma(vma, start, end, &swapin_walk_ops, vma);
 		lru_add_drain(); /* Push any new pages onto the LRU now */
-		return 0;
 	}
+	if (!file)
+		return 0;
 
 	if (shmem_mapping(file->f_mapping)) {
 		shmem_swapin_range(vma, start, end, file->f_mapping);
_

Patches currently in -mm which might be from ljs@kernel.org are

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
mm-madvise-update-is_valid_guard_vma-to-use-vma_can_merge.patch
mm-vma-introduce-vma_is_mm_backed.patch
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

