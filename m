Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E02382374
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388677; cv=none; b=tUe5pkihJWPR6nW6p3O/8mAw1APDbZxQp+PASDvV2fmV3rUNdAcV5SVFv6MtB+SLQHiQnr2QGxH2ZZ8ziZfxEh4Y6opS3AkgjlFwzSR5Q/SLCvBB5v8M8af60sOdicKcoQ1lld5msAU6QYnSSClVXxy90pVjTMcDMS1+kYVxEVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388677; c=relaxed/simple;
	bh=sRSmz7alSjkgHTFe2YuGtVcvmW5WKKFkjxpcb2DE7ew=;
	h=Date:To:From:Subject:Message-Id; b=MKRgVHwFLxa6TIkRI0oLdsupt0eE1fEcMX1rAlPJwYJSFTOddAVym6F1LGcwhLHHHUjWg2f4jq25DaNB3ZJlt4JVOG9l0GdG+w882+aET/nMNoQz2SxVBN1rOHnw3ehxlkpx4AhsXkqfEBfSRrP9Ro5d+na7JxdEkNP9xe/hXhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K8hDLKOq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K8hDLKOq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 028C7C2BC9E;
	Tue, 24 Mar 2026 21:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388677;
	bh=sRSmz7alSjkgHTFe2YuGtVcvmW5WKKFkjxpcb2DE7ew=;
	h=Date:To:From:Subject:From;
	b=K8hDLKOqDGp5l6Fb7zj1NTxETyY4strbnKzv5IiiEeoKB4polYK33RvSdQpxcV5F0
	 tMYhAdmugaBEXg3sD38rpkVtbxoYWMEpFVxcT4py5XipKLXsaMXLF3key6TRx/6S6U
	 LasXB3SWfAZ/y30KL6Lbo9m0k4LLHC4LcsbiF1qA=
Date: Tue, 24 Mar 2026 14:44:36 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,vbabka@kernel.org,skhan@linuxfoundation.org,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,corbet@lwn.net,andreyknvl@gmail.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-docs-slub-is-the-only-remaining-slab-implementation.patch removed from -mm tree
Message-Id: <20260324214437.028C7C2BC9E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: docs: SLUB is the only remaining slab implementation
has been removed from the -mm tree.  Its filename was
     kasan-docs-slub-is-the-only-remaining-slab-implementation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: kasan: docs: SLUB is the only remaining slab implementation
Date: Tue, 3 Mar 2026 13:04:16 +0100

We have only the SLUB implementation left in the kernel (referred to as
"slab").  Therefore, there is nothing special regarding KASAN modes when
it comes to the slab allocator anymore.

Drop the stale comment regarding differing SLUB vs. SLAB support.

Link: https://lkml.kernel.org/r/20260303120416.62580-1-david@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst |    3 ---
 1 file changed, 3 deletions(-)

--- a/Documentation/dev-tools/kasan.rst~kasan-docs-slub-is-the-only-remaining-slab-implementation
+++ a/Documentation/dev-tools/kasan.rst
@@ -75,9 +75,6 @@ Software Tag-Based KASAN supports slab,
 Hardware Tag-Based KASAN supports slab, page_alloc, and non-executable vmalloc
 memory.
 
-For slab, both software KASAN modes support SLUB and SLAB allocators, while
-Hardware Tag-Based KASAN only supports SLUB.
-
 Usage
 -----
 
_

Patches currently in -mm which might be from david@kernel.org are

mm-memory-fix-pmd-pud-checks-in-follow_pfnmap_start.patch
mm-madvise-drop-range-checks-in-madvise_free_single_vma.patch
mm-memory-remove-zap_details-parameter-from-zap_page_range_single.patch
mm-memory-remove-zap_details-parameter-from-zap_page_range_single-fix.patch
mm-memory-inline-unmap_mapping_range_vma-into-unmap_mapping_range_tree.patch
mm-memory-simplify-calculation-in-unmap_mapping_range_tree.patch
mm-oom_kill-use-mmu_notify_clear-in-__oom_reap_task_mm.patch
mm-oom_kill-factor-out-zapping-of-vma-into-zap_vma_for_reaping.patch
mm-memory-rename-unmap_single_vma-to-__zap_vma_range.patch
mm-memory-move-adjusting-of-address-range-to-unmap_vmas.patch
mm-memory-convert-details-even_cows-into-details-skip_cows.patch
mm-memory-use-__zap_vma_range-in-zap_vma_for_reaping.patch
mm-memory-inline-unmap_page_range-into-__zap_vma_range.patch
mm-memory-inline-unmap_page_range-into-__zap_vma_range-fix.patch
mm-rename-zap_vma_pages-to-zap_vma.patch
mm-rename-zap_page_range_single_batched-to-zap_vma_range_batched.patch
mm-rename-zap_page_range_single-to-zap_vma_range.patch
mm-rename-zap_vma_ptes-to-zap_special_vma_range.patch
mm-memory-support-vm_mixedmap-in-zap_special_vma_range.patch
mm-move-vma_kernel_pagesize-from-hugetlb-to-mmh.patch
mm-move-vma_mmu_pagesize-from-hugetlb-to-vmac.patch
kvm-remove-hugetlbh-inclusion.patch
kvm-ppc-remove-hugetlbh-inclusion.patch
mm-memory_hotplug-remove-for_each_valid_pfn-usage.patch
mm-sparse-remove-warn_ons-from-onlineoffline_mem_sections.patch
mm-kconfig-make-config_memory_hotplug-depend-on-config_sparsemem_vmemmap.patch
mm-memory_hotplug-simplify-check_pfn_span.patch
mm-sparse-remove-config_sparsemem_vmemmap-leftovers-for-config_memory_hotplug.patch
mm-bootmem_info-remove-handling-for-config_sparsemem_vmemmap.patch
mm-bootmem_info-avoid-using-sparse_decode_mem_map.patch
mm-sparse-remove-sparse_decode_mem_map.patch
mm-sparse-remove-config_memory_hotplug-specific-usemap-allocation-handling.patch
mm-prepare-to-move-subsection_map_init-to-mm-sparse-vmemmapc.patch
mm-sparse-drop-set_section_nid-from-sparse_add_section.patch
mm-sparse-move-sparse_init_one_section-to-internalh.patch
mm-sparse-move-sparse_init_one_section-to-internalh-fix.patch
mm-sparse-move-__section_mark_present-to-internalh.patch
mm-sparse-move-memory-hotplug-bits-to-sparse-vmemmapc.patch
mm-remove-config_arch_enable_memory_hotremove.patch
mm-introduce-config_numa_migration-and-simplify-config_migration.patch

