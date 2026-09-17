Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6C04B0E58
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 21:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789679414; cv=none; b=k+EtPoHzaLEc6621AdxvJpFq1mFlRndtv9B0hy1yl5Wh/6FTT/YsnVXVseVud3I5e2yATr+V/E3WHN1g+4NTHrVgxqyhoOeluovxFDF/jXF9f6i4RVtpPdGd1p8H3ytmPFXu//OyqRxbuEu3xWKcBZTKqYY9MBOEznlPZh18s+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789679414; c=relaxed/simple;
	bh=ZKxdHJATOMxFCgiXCqIMan7fBwvI4tfIuPoWKZHzUH0=;
	h=Date:To:From:Subject:Message-Id; b=k9uQjGCfA4XQ6CxQXX/0UjtYYjof3mufMpxsK6OYb1Bmfm8BcNxQDgktQ7+cVh7y6avF60ZivpiX6nzjIONj87hNpQRlEbTKLI/TOqsB7frzG3+9+q+7mz3XjXrLxG66kO0zAD7UR6/xE7f9c9He7R93CuiUxiX5RL8oKsAUQvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NHpboaPS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NHpboaPS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 010EE1F000FF;
	Thu, 17 Sep 2026 21:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789679413;
	bh=FFo2mgy1I0QBPo7aqeGxnffnmzAE/nAmsqom3Li6JfI=;
	h=Date:To:From:Subject;
	b=NHpboaPSb4V49QLwBLbqa8MoMwQ/OoRO1zGE3n2YVo9E464abHDMY8MXi8zgqJc0m
	 mJlz3ZKwTUmrAtaugNi0BUzrSU1N3ayGQPIuI8bXnnKdHmwA0q9ouKIBDnacv6RYIf
	 X4HrWJ73Q2loqqJykmzTvRuvJnHUz/p3EBbB2UfE=
Date: Thu, 17 Sep 2026 14:10:12 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] fbdev-defio-assert-fbinfo_virtfb-drop-vm_io-add-vm_mixedmap.patch removed from -mm tree
Message-Id: <20260917211013.010EE1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fbdev: defio: assert FBINFO_VIRTFB, drop VM_IO, add VM_MIXEDMAP
has been removed from the -mm tree.  Its filename was
     fbdev-defio-assert-fbinfo_virtfb-drop-vm_io-add-vm_mixedmap.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: fbdev: defio: assert FBINFO_VIRTFB, drop VM_IO, add VM_MIXEDMAP
Date: Mon, 14 Sep 2026 15:57:39 +0100

Currently all drivers which use defio allocate system memory.  All of them
also set FBINFO_VIRTFB, other than ssd1307fb, however this driver
allocates system RAM, so simply failed to set this flag when it ought to.

This patch sets FBINFO_VIRTFB on ssd1307fb probe, then drops setting VM_IO
in fb_deferred_io_mmap() and instead requires FBINFO_VIRTFB to be set,
erroring out with a kernel warning if not.

The logic requires a page from the driver and since commit 1ecbc7dd2902
("fbdev/deferred-io: Always call get_page() for framebuffer pages") has
always required it to be refcounted, so this was implicitly already the
case.

Finally this patch sets VM_MIXEDMAP, as the logic is mapping
kernel-allocated memory so this is appropriate.

Link: https://lore.kernel.org/20260914-b4-mmap-prepare-vma-flag-sanify-v2-19-7d9781ed5361@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
---

 drivers/video/fbdev/core/fb_defio.c |    6 +++---
 drivers/video/fbdev/ssd1307fb.c     |    2 ++
 2 files changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/video/fbdev/core/fb_defio.c~fbdev-defio-assert-fbinfo_virtfb-drop-vm_io-add-vm_mixedmap
+++ a/drivers/video/fbdev/core/fb_defio.c
@@ -366,13 +366,13 @@ int fb_deferred_io_mmap(struct fb_info *
 {
 	vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
 
+	if (WARN_ON_ONCE(!(info->flags & FBINFO_VIRTFB)))
+		return -EINVAL;
 	if (!try_module_get(THIS_MODULE))
 		return -EINVAL;
 
 	vma->vm_ops = &fb_deferred_io_vm_ops;
-	vm_flags_set(vma, VM_DONTEXPAND | VM_DONTDUMP);
-	if (!(info->flags & FBINFO_VIRTFB))
-		vm_flags_set(vma, VM_IO);
+	vm_flags_set(vma, VM_MIXEDMAP | VM_DONTEXPAND | VM_DONTDUMP);
 	vma->vm_private_data = info->fbdefio_state;
 
 	fb_deferred_io_state_get(info->fbdefio_state); /* released in vma->vm_ops->close() */
--- a/drivers/video/fbdev/ssd1307fb.c~fbdev-defio-assert-fbinfo_virtfb-drop-vm_io-add-vm_mixedmap
+++ a/drivers/video/fbdev/ssd1307fb.c
@@ -763,6 +763,8 @@ static int ssd1307fb_probe(struct i2c_cl
 	info->fix.smem_start = __pa(vmem);
 	info->fix.smem_len = vmem_size;
 
+	info->flags = FBINFO_VIRTFB;
+
 	fb_deferred_io_init(info);
 
 	i2c_set_clientdata(client, info);
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

