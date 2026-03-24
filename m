Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F923328E3
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 23:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774394334; cv=none; b=dHonvu1V3otLROf/xWcD7A7tbAZiv3YCPl3INkaFnoohKK9wL+HIPzes24xIlglgoChqkHPFE7LOmvS5WQ8auE1OrsReUodUj1ARgqipWbSB0lfr26ZhrEEd9hde7N3d8N3+3UFeI+9hZt5aj2ZHT4gBLW8+DB9L38mKbhrGucg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774394334; c=relaxed/simple;
	bh=heDHm1KF5Tz7hP3AwB/MHXXrbYjc2Un7T4ComZiPQG4=;
	h=Date:To:From:Subject:Message-Id; b=Gex5qRwKcUitxIXq9mpgis5dtudT/ATj+orwwJAcC/FR3p0t4fVK7AHAnR2mtiUAW7yEWrFStRREogfmmJfj1Sc3hf3yD7BzvCL3t1SYf19lkYIGYo781FJdeS2DoJSMByL6D6l2RXhBzib8Sr7PD1wXdhFfcJbnIOFwKxoigCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m0i38G/W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m0i38G/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA626C19424;
	Tue, 24 Mar 2026 23:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774394334;
	bh=heDHm1KF5Tz7hP3AwB/MHXXrbYjc2Un7T4ComZiPQG4=;
	h=Date:To:From:Subject:From;
	b=m0i38G/WJ5+Dh+xYfuBpVYlaue6EA/TVH+27TTL5u+o+n7C7wHDKjroKu9pHgqyrF
	 O4UZ99UWz7c3DuzsBCgwXsA39gftl3JSysJhtJL76DwnVfnkx+qfKE0kcrU+vfFOZK
	 l026060QYDnedyEPcA/SMZPBnvA0qzNfxvMKPv2I=
Date: Tue, 24 Mar 2026 16:18:53 -0700
To: mm-commits@vger.kernel.org,zbestahu@gmail.com,xiang@kernel.org,willy@infradead.org,vishal.l.verma@intel.com,vbabka@kernel.org,tony.luck@intel.com,surenb@google.com,rppt@kernel.org,reinette.chatre@intel.com,pfalcato@suse.de,osalvador@suse.de,naohiro.aota@wdc.com,muchun.song@linux.dev,mhocko@suse.com,lihongbo22@huawei.com,liam.howlett@oracle.com,jth@kernel.org,jgg@ziepe.ca,jefflexu@linux.alibaba.com,jannh@google.com,james.morse@arm.com,jack@suse.cz,hughd@google.com,guochunhai@vivo.com,gregkh@linuxfoundation.org,dlemoal@kernel.org,dhavale@google.com,david@kernel.org,dave.martin@arm.com,dave.jiang@intel.com,dan.j.williams@intel.com,chao@kernel.org,baolin.wang@linux.alibaba.com,babu.moger@amd.com,arnd@arndb.de,almaz.alexandrovich@paragon-software.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] tools-testing-vma-add-test-for-vma_flags_test-vma_desc_test-fix.patch removed from -mm tree
Message-Id: <20260324231853.DA626C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools-testing-vma-add-test-for-vma_flags_test-vma_desc_test-fix
has been removed from the -mm tree.  Its filename was
     tools-testing-vma-add-test-for-vma_flags_test-vma_desc_test-fix.patch

This patch was dropped because it was folded into tools-testing-vma-add-test-for-vma_flags_test-vma_desc_test.patch

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: tools-testing-vma-add-test-for-vma_flags_test-vma_desc_test-fix
Date: Thu, 5 Mar 2026 14:59:58 +0000

test_vma_flags_test(): use struct initializer, per David

Link: https://lkml.kernel.org/r/f6f396d2-1ba2-426f-b756-d8cc5985cc7c@lucifer.local
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
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
Cc: David Hildenbrand (Arm) <david@kernel.org>
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
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Sandeep Dhavale <dhavale@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Yue Hu <zbestahu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/vma/tests/vma.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/vma/tests/vma.c~tools-testing-vma-add-test-for-vma_flags_test-vma_desc_test-fix
+++ a/tools/testing/vma/tests/vma.c
@@ -164,9 +164,9 @@ static bool test_vma_flags_test(void)
 {
 	const vma_flags_t flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
 					       VMA_EXEC_BIT, 64, 65);
-	struct vm_area_desc desc;
-
-	desc.vma_flags = flags;
+	struct vm_area_desc desc = {
+		.vma_flags = flags,
+	};
 
 #define do_test(_flag)					\
 	ASSERT_TRUE(vma_flags_test(&flags, _flag));	\
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-rename-vma-flag-helpers-to-be-more-readable.patch
mm-add-vma_desc_test_all-and-use-it.patch
mm-always-inline-__mk_vma_flags-and-invoked-functions.patch
mm-reintroduce-vma_flags_test-as-a-singular-flag-test.patch
mm-reintroduce-vma_desc_test-as-a-singular-flag-test.patch
tools-testing-vma-add-test-for-vma_flags_test-vma_desc_test.patch
mm-mremap-correct-invalid-map-count-check.patch
mm-abstract-reading-sysctl_max_map_count-and-read_once.patch
mm-mremap-check-map-count-under-mmap-write-lock-and-abstract.patch
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
mm-huge_memory-add-and-use-normal_or_softleaf_folio_pmd-fix.patch
mm-huge_memory-add-and-use-has_deposited_pgtable.patch
mm-huge_memory-add-and-use-has_deposited_pgtable-fix.patch

