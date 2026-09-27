Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5DF3C3F6B
	for <mm-commits@vger.kernel.org>; Sun, 27 Sep 2026 21:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790545691; cv=none; b=coe5Bdv/x7hch9SOiBbDr34ESTVBYXK1o4SV2Sf5B4k6D9nSbPPkcyeKEPO7+MDFh0UGZ0ssIb4IE6J/rIUnOFa3l0hLkZWp9Gq3qH85UHcipCH4nZSQ/8Er8LMcc+z2e2ICLUcIfY2AFni6qVjPYGS2DTYHRuntr9O/3oHU6ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790545691; c=relaxed/simple;
	bh=21ZtTmQPPgiwGcqornmC43PxhSzySv+cxExM7w2fR5k=;
	h=Date:To:From:Subject:Message-Id; b=cd5Lcqqp52Ye8THwooZNIK2ipH59WQhnJkHdBp7YL6nwo1LKXIeTPOmaOZI3WIKARbroRHOWQrfMo/23vd7cDkUXZ15/oJSPhMHbYJUzb3E4O59u9Eutgc+guAkniIvjDFOA9y/jJ97jLhUEERnI+TOt3SJJXrngoTTMDhq6/mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=URIMQzrG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="URIMQzrG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781D91F00893;
	Sun, 27 Sep 2026 21:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790545689;
	bh=YGcGeHrPzY00Aa0v0pFaeNNiUkiGLYcqfLclnUGk8A0=;
	h=Date:To:From:Subject;
	b=URIMQzrGQ2Ket31F0pHp9AuFwlSn1oav9J/0yv0o8/Aa+hX4pNvvcliMUIL5Yz0rd
	 vaUsDF1ihgJCgTXnmM4d/rMBVYhmxV+D+mFo9rIe1iioiu2URC6VdlXtfEm579ne04
	 +qIaIfCM9EbIEI694XNWtav7YF50ibA45e8UoOKo=
Date: Sun, 27 Sep 2026 14:48:09 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch removed from -mm tree
Message-Id: <20260927214809.781D91F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/testing/vma: add test to assert MAP_PRIVATE-/dev/zero is anon
has been removed from the -mm tree.  Its filename was
     tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: tools/testing/vma: add test to assert MAP_PRIVATE-/dev/zero is anon
Date: Tue, 08 Sep 2026 12:23:42 +0100

Now we've made MAP_PRIVATE-mapped /dev/zero mappings truly anonymous, add
a VMA userland test to assert that this is the case and everything is as
we would expect for an anonymous mapping.

Link: https://lore.kernel.org/20260908-map-private-dev-zero-v2-5-acc7b5625305@kernel.org
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 tools/testing/vma/tests/mmap.c |   37 +++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

--- a/tools/testing/vma/tests/mmap.c~tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon
+++ a/tools/testing/vma/tests/mmap.c
@@ -45,7 +45,44 @@ static bool test_mmap_region_basic(void)
 	return true;
 }
 
+static bool test_pure_anon_dev_zero(void)
+{
+	const vma_flags_t vma_flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
+			VMA_MAYREAD_BIT, VMA_MAYWRITE_BIT);
+	struct file file = {
+		.f_op = &zero_fops,
+	};
+	struct mm_struct mm = {};
+	struct vm_area_struct *vma;
+	unsigned long addr;
+	VMA_ITERATOR(vmi, &mm, 0);
+
+	current->mm = &mm;
+
+	/*
+	 * Map a MAP_PRIVATE-/dev/zero mapping at address 0x300000 with a page
+	 * offset of 0x10, which we expect to be reset to the anonymous page
+	 * offset.
+	 */
+	addr = __mmap_region(&file, 0x300000, 0x3000, vma_flags, 0x10, NULL);
+	ASSERT_EQ(addr, 0x300000);
+
+	/* Assert that it truly is an anonymous mapping. */
+	vma = vma_lookup(&mm, addr);
+	ASSERT_NE(vma, NULL);
+	ASSERT_TRUE(vma_is_anonymous(vma));
+	ASSERT_EQ(vma->vm_file, NULL);
+	ASSERT_EQ(vma->vm_private_data, NULL);
+	/* Expect anonymous page offsets. */
+	ASSERT_EQ(vma->vm_pgoff, 0x300);
+	ASSERT_EQ(vma_start_anon_pgoff(vma), 0x300);
+
+	cleanup_mm(&mm, &vmi);
+	return true;
+}
+
 static void run_mmap_tests(int *num_tests, int *num_fail)
 {
 	TEST(mmap_region_basic);
+	TEST(pure_anon_dev_zero);
 }
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-mremap-fix-locked_vm-leak-from-mremap_dontunmap-self-merge.patch
mm-mremap-fix-locked_vm-leak-by-splitting-vma-for-mremap_dontunmap.patch
mm-vmpressure-remove-window-size-todo.patch
tools-testing-selftests-mm-add-missing-gitignore-entries.patch
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

