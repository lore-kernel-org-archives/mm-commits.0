Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3002248A3
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744808; cv=none; b=DE3M6h5O/bLHEv1rIGbIZcFC063Y1eQFmR+EldQKTJnmyialNh08NzG2K08lwmHDXFsfusvVqgzjwP3M+VywnSAxyK4eFiawUZPNXCCEmO/MV24ZLbdM726Tx3WU3laEkKgxH2aLy3xng4DAuzRIZkQ5ldDqzArF9M51XpoPyaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744808; c=relaxed/simple;
	bh=YHeGPVK3G3MeJdHLDv+puYnv0gUfghRJ0WUgIIdTRyY=;
	h=Date:To:From:Subject:Message-Id; b=W9iLR2/nl38G01rs/U5ExKAyvkbOWlmk0f3f8gf8qBj2QzmyRU9sOrJFwcx2KywvAGqrPDFel12vIqqacrHoXEoKpEGAacKIzkhFmpsw4ZzW1+8obUAFH2hj2btY3tplTqg7VSAoIMXZ7nnbN3tQVaEL5xYrXqNWbZI+sXDQqKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QRk9qmWV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QRk9qmWV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22402C4CEF7;
	Sun, 29 Mar 2026 00:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744808;
	bh=YHeGPVK3G3MeJdHLDv+puYnv0gUfghRJ0WUgIIdTRyY=;
	h=Date:To:From:Subject:From;
	b=QRk9qmWVt1JP3ylEjfii7pBY9MfomWoiudhObdbbU1kPSHwId6h9DphmFw3Syi8kW
	 is+5uNpAHWZ1Zt4AoWf1nrr7LE2/QtiDeT0o5Pd1vYsLFiSroDAWpWn5A2eTqLoMe7
	 NsVZXodnQswhqPZ1/01dneb7mHFBzSJto+VXAZmU=
Date: Sat, 28 Mar 2026 17:40:07 -0700
To: mm-commits@vger.kernel.org,zbestahu@gmail.com,xiang@kernel.org,willy@infradead.org,vishal.l.verma@intel.com,vbabka@kernel.org,tony.luck@intel.com,surenb@google.com,rppt@kernel.org,reinette.chatre@intel.com,pfalcato@suse.de,osalvador@suse.de,naohiro.aota@wdc.com,muchun.song@linux.dev,mhocko@suse.com,lihongbo22@huawei.com,liam.howlett@oracle.com,jth@kernel.org,jgg@ziepe.ca,jefflexu@linux.alibaba.com,jannh@google.com,james.morse@arm.com,jack@suse.cz,hughd@google.com,guochunhai@vivo.com,gregkh@linuxfoundation.org,dlemoal@kernel.org,dhavale@google.com,david@kernel.org,dave.martin@arm.com,dave.jiang@intel.com,dan.j.williams@intel.com,chao@kernel.org,baolin.wang@linux.alibaba.com,babu.moger@amd.com,arnd@arndb.de,almaz.alexandrovich@paragon-software.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-testing-vma-add-test-for-vma_flags_test-vma_desc_test.patch removed from -mm tree
Message-Id: <20260329004008.22402C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/testing/vma: add test for vma_flags_test(), vma_desc_test()
has been removed from the -mm tree.  Its filename was
     tools-testing-vma-add-test-for-vma_flags_test-vma_desc_test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: tools/testing/vma: add test for vma_flags_test(), vma_desc_test()
Date: Thu, 5 Mar 2026 10:50:19 +0000

Now we have helpers which test singular VMA flags - vma_flags_test() and
vma_desc_test() - add a test to explicitly assert that these behave as
expected.

[ljs@kernel.org: test_vma_flags_test(): use struct initializer, per David]
  Link: https://lkml.kernel.org/r/f6f396d2-1ba2-426f-b756-d8cc5985cc7c@lucifer.local
Link: https://lkml.kernel.org/r/376a39eb9e134d2c8ab10e32720dd292970b080a.1772704455.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Babu Moger <babu.moger@amd.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Chatre, Reinette <reinette.chatre@intel.com>
Cc: Chunhai Guo <guochunhai@vivo.com>
Cc: Damien Le Maol <dlemoal@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Dave Martin <dave.martin@arm.com>
Cc: Gao Xiang <xiang@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hongbo Li <lihongbo22@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Morse <james.morse@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
Cc: Johannes Thumshirn <jth@kernel.org>
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naohiro Aota <naohiro.aota@wdc.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sandeep Dhavale <dhavale@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Yue Hu <zbestahu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/vma/tests/vma.c |   36 ++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

--- a/tools/testing/vma/tests/vma.c~tools-testing-vma-add-test-for-vma_flags_test-vma_desc_test
+++ a/tools/testing/vma/tests/vma.c
@@ -159,6 +159,41 @@ static bool test_vma_flags_word(void)
 	return true;
 }
 
+/* Ensure that vma_flags_test() and friends works correctly. */
+static bool test_vma_flags_test(void)
+{
+	const vma_flags_t flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
+					       VMA_EXEC_BIT, 64, 65);
+	struct vm_area_desc desc = {
+		.vma_flags = flags,
+	};
+
+#define do_test(_flag)					\
+	ASSERT_TRUE(vma_flags_test(&flags, _flag));	\
+	ASSERT_TRUE(vma_desc_test(&desc, _flag))
+
+#define do_test_false(_flag)				\
+	ASSERT_FALSE(vma_flags_test(&flags, _flag));	\
+	ASSERT_FALSE(vma_desc_test(&desc, _flag))
+
+	do_test(VMA_READ_BIT);
+	do_test(VMA_WRITE_BIT);
+	do_test(VMA_EXEC_BIT);
+#if NUM_VMA_FLAG_BITS > 64
+	do_test(64);
+	do_test(65);
+#endif
+	do_test_false(VMA_MAYWRITE_BIT);
+#if NUM_VMA_FLAG_BITS > 64
+	do_test_false(66);
+#endif
+
+#undef do_test
+#undef do_test_false
+
+	return true;
+}
+
 /* Ensure that vma_flags_test_any() and friends works correctly. */
 static bool test_vma_flags_test_any(void)
 {
@@ -334,6 +369,7 @@ static void run_vma_tests(int *num_tests
 	TEST(vma_flags_unchanged);
 	TEST(vma_flags_cleared);
 	TEST(vma_flags_word);
+	TEST(vma_flags_test);
 	TEST(vma_flags_test_any);
 	TEST(vma_flags_clear);
 }
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

