Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FE049B446
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 21:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789679415; cv=none; b=AoKLAH51iQ6ALCpa22woupoKJA5hTXNC1OwXJnBOsOEm767HG0OquYBH0CyJY7jdITDgNKzuDUpUbr6et23BwGZjgjBHo81+SwQm9ujkEs6aK7Q98wRZcdWDLdYm2XMqkYkxjPlyiVIkfwHXPJ9N33iDUZatQZa+l2KHbBIAceE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789679415; c=relaxed/simple;
	bh=Yhtor6J6q4T6p7Q46rO6LbjUHDWpVyjobLaLH7UoFgk=;
	h=Date:To:From:Subject:Message-Id; b=NqbeAbW5Weh4SEnhE/1x0xQhapEpRfTlvKKtPOQelg6SSUqXrOy4buNIvSQ2OvvZRjZ8z7rxC95iR/2Tt6saffRn90pcrTE/jZ7Me/UMzem6dO3JaAyKjjimzZXBwiuyizCev+LYBAVkO/CY7gNOtxFnS8Hjo6Vk3AF0tw4uhS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dNiDea9e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dNiDea9e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28FFF1F00893;
	Thu, 17 Sep 2026 21:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789679414;
	bh=Htet/s96AwzL70gjMqN8fQi6C7aBwXFGYOG+rFdf0gg=;
	h=Date:To:From:Subject;
	b=dNiDea9eDzfYQRNo8UIoFGzYDbk63Z0WQcBJhD2ghd9REWiYftyzBKlyUN2yOSphg
	 GKZUcU5LfU32LMMXapMSrXYrtFpVSsxm2U5KsVuRu72LMoY3A1JHAt62MB+jq55nle
	 PRNbhJaAxZi8NHrXR4L1ecATjsWmtUjMo2BP45GM=
Date: Thu, 17 Sep 2026 14:10:13 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] hsi-cmt_speech-convert-mmap-hook-to-mmap_prepare-refactor.patch removed from -mm tree
Message-Id: <20260917211014.28FFF1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: HSI: cmt_speech: convert mmap hook to mmap_prepare, refactor
has been removed from the -mm tree.  Its filename was
     hsi-cmt_speech-convert-mmap-hook-to-mmap_prepare-refactor.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: HSI: cmt_speech: convert mmap hook to mmap_prepare, refactor
Date: Mon, 14 Sep 2026 15:57:40 +0100

Use the mmap_prepare in favour of the deprecated mmap hook as part of the
work to convert one to another.

Since this is simply a refcounted kernel page that has been allocated, it
should not be marked VM_IO and should be inserted using the kernel page
insertion mechanism, so convert it to do this instead.

Use the VMA descriptor's private data field as a scratch buffer to store
the page in - this stays valid throughout the kernel page mapping
operation.

Link: https://lore.kernel.org/20260914-b4-mmap-prepare-vma-flag-sanify-v2-20-7d9781ed5361@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hsi/clients/cmt_speech.c |   33 +++++++----------------------
 1 file changed, 9 insertions(+), 24 deletions(-)

--- a/drivers/hsi/clients/cmt_speech.c~hsi-cmt_speech-convert-mmap-hook-to-mmap_prepare-refactor
+++ a/drivers/hsi/clients/cmt_speech.c
@@ -1084,22 +1084,6 @@ static void cs_hsi_stop(struct cs_hsi_if
 	kfree(hi);
 }
 
-static vm_fault_t cs_char_vma_fault(struct vm_fault *vmf)
-{
-	struct cs_char *csdata = vmf->vma->vm_private_data;
-	struct page *page;
-
-	page = virt_to_page((void *)csdata->mmap_base);
-	get_page(page);
-	vmf->page = page;
-
-	return 0;
-}
-
-static const struct vm_operations_struct cs_char_vm_ops = {
-	.fault	= cs_char_vma_fault,
-};
-
 static int cs_char_fasync(int fd, struct file *file, int on)
 {
 	struct cs_char *csdata = file->private_data;
@@ -1256,18 +1240,19 @@ static long cs_char_ioctl(struct file *f
 	return r;
 }
 
-static int cs_char_mmap(struct file *file, struct vm_area_struct *vma)
+static int cs_char_mmap_prepare(struct vm_area_desc *desc)
 {
-	if (vma->vm_end < vma->vm_start)
-		return -EINVAL;
+	struct file *file = desc->file;
+	struct cs_char *csdata = file->private_data;
+	struct page **pages = (struct page **)&desc->private_data;
 
-	if (vma_pages(vma) != 1)
+	if (vma_desc_pages(desc) != 1)
 		return -EINVAL;
 
-	vm_flags_set(vma, VM_IO | VM_DONTDUMP | VM_DONTEXPAND);
-	vma->vm_ops = &cs_char_vm_ops;
-	vma->vm_private_data = file->private_data;
+	vma_desc_set_flags(desc, VMA_DONTDUMP_BIT, VMA_DONTEXPAND_BIT);
 
+	*pages = virt_to_page((void *)csdata->mmap_base);
+	mmap_action_map_kernel_pages_full(desc, pages);
 	return 0;
 }
 
@@ -1353,7 +1338,7 @@ static const struct file_operations cs_c
 	.write		= cs_char_write,
 	.poll		= cs_char_poll,
 	.unlocked_ioctl	= cs_char_ioctl,
-	.mmap		= cs_char_mmap,
+	.mmap_prepare	= cs_char_mmap_prepare,
 	.open		= cs_char_open,
 	.release	= cs_char_release,
 	.fasync		= cs_char_fasync,
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

