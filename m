Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5313746A60A
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 17:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785863517; cv=none; b=hXhUOf5r885Gy6F9W7gipFOPUkynqETNvebrBC8B8iiJW0Cujpnb+u9ILoEHCVBuXEtrPB7HExNct7HH1skw//pzt+c3ZKmypaQo5LtyTqru7iKbhpcDCCiE/hxkpgOIqrivfzucHe3j4qnWuB5pyfcIYEBdVIloT8Izn4aRUhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785863517; c=relaxed/simple;
	bh=YPADpnbnPET4pOn+qf2XLwbUTxbex3cNeMF9nw+fjgQ=;
	h=Date:To:From:Subject:Message-Id; b=A5PpyDY8ekfT3TZWdqtWb9YXjIsieI060RoJLsPilEqdoY3pBdbmXUQ1rFca9nfXUgaex6yvha4L0IFcblu2SseS0wR8xHf/OnsrZzZXb3uxOpnCO1ut3yAsmGM4rqLBRhPOqnhvgDTWDvmQcpZY5fHUR76Jtkt8vXdGlvChZVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=trw2UX8k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="trw2UX8k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE711F000E9;
	Tue,  4 Aug 2026 17:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785863501;
	bh=t62wGsfApTwMJVqM4RGbYL+ygYnA+g+R5mLqNcsViXs=;
	h=Date:To:From:Subject;
	b=trw2UX8k1GFUbcCZ/x1bZ3xLVQ+r9GMB901J92LoMehnF+EmmYk9OfCiH4Awl9uzW
	 kSBONpJcgyE2bondzHueaUphAEJs34g8k6PwJVxa/UOaYPJHs12n8cIVfevyHOVtOS
	 bkqT+egiEMBSs1pfT0px13U7bD4JIkybZjTjIAEc=
Date: Tue, 04 Aug 2026 10:11:40 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,urezki@gmail.com,surenb@google.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,osalvador@suse.de,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@kernel.org,liam@infradead.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-some-missing-includes-to-mm-local-headers.patch added to mm-new branch
Message-Id: <20260804171141.4CE711F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add some missing includes to mm-local headers
has been added to the -mm mm-new branch.  Its filename is
     mm-add-some-missing-includes-to-mm-local-headers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-some-missing-includes-to-mm-local-headers.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Subject: mm: add some missing includes to mm-local headers
Date: Tue, 04 Aug 2026 11:08:59 +0100

There are a number of internal headers local to mm/ which reference
functions and data types without including the relevant headers.

mm/vma.h is a special case that intentionally does not include additional
headers, but the others are not.

This breaks tooling like clangd (which is where I noticed this), though
the build is OK due to the C files including the headers happening to
include required dependencies.

It's better to be explicit about dependencies anyway, so add the missing
includes and fix clangd as a bonus.

Link: https://lore.kernel.org/20260804-fix-some-local-headers-v1-1-a7beb173c116@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.h           |    1 +
 mm/hugetlb_cma.h   |    2 ++
 mm/memcontrol-v1.h |    1 +
 mm/pgalloc-track.h |    3 +++
 mm/shuffle.h       |    2 ++
 mm/swap.h          |    1 +
 mm/vmalloc.h       |    2 ++
 7 files changed, 12 insertions(+)

--- a/mm/cma.h~mm-add-some-missing-includes-to-mm-local-headers
+++ a/mm/cma.h
@@ -2,6 +2,7 @@
 #ifndef __MM_CMA_H__
 #define __MM_CMA_H__
 
+#include <linux/cma.h>
 #include <linux/debugfs.h>
 #include <linux/kobject.h>
 
--- a/mm/hugetlb_cma.h~mm-add-some-missing-includes-to-mm-local-headers
+++ a/mm/hugetlb_cma.h
@@ -2,6 +2,8 @@
 #ifndef _LINUX_HUGETLB_CMA_H
 #define _LINUX_HUGETLB_CMA_H
 
+#include <linux/hugetlb.h>
+
 #ifdef CONFIG_CMA
 void hugetlb_cma_free_frozen_folio(struct folio *folio);
 struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
--- a/mm/memcontrol-v1.h~mm-add-some-missing-includes-to-mm-local-headers
+++ a/mm/memcontrol-v1.h
@@ -4,6 +4,7 @@
 #define __MM_MEMCONTROL_V1_H
 
 #include <linux/cgroup-defs.h>
+#include <linux/memcontrol.h>
 
 /* Cgroup v1 and v2 common declarations */
 
--- a/mm/pgalloc-track.h~mm-add-some-missing-includes-to-mm-local-headers
+++ a/mm/pgalloc-track.h
@@ -2,6 +2,9 @@
 #ifndef _LINUX_PGALLOC_TRACK_H
 #define _LINUX_PGALLOC_TRACK_H
 
+#include <linux/mm.h>
+#include <linux/pgtable.h>
+
 #if defined(CONFIG_MMU)
 static inline p4d_t *p4d_alloc_track(struct mm_struct *mm, pgd_t *pgd,
 				     unsigned long address,
--- a/mm/shuffle.h~mm-add-some-missing-includes-to-mm-local-headers
+++ a/mm/shuffle.h
@@ -2,7 +2,9 @@
 // Copyright(c) 2018 Intel Corporation. All rights reserved.
 #ifndef _MM_SHUFFLE_H
 #define _MM_SHUFFLE_H
+
 #include <linux/jump_label.h>
+#include <linux/mmzone.h>
 
 #define SHUFFLE_ORDER MAX_PAGE_ORDER
 
--- a/mm/swap.h~mm-add-some-missing-includes-to-mm-local-headers
+++ a/mm/swap.h
@@ -5,6 +5,7 @@
 #include <linux/atomic.h> /* for atomic_long_t */
 #include <linux/mm.h> /* for PAGE_SHIFT */
 #include <linux/memcontrol.h> /* for mem_cgroup_swappiness() */
+#include <linux/swap.h> /* for MAX_SWAPFILES_SHIFT, struct swap_info_struct */
 
 struct mempolicy;
 struct swap_iocb;
--- a/mm/vmalloc.h~mm-add-some-missing-includes-to-mm-local-headers
+++ a/mm/vmalloc.h
@@ -5,6 +5,8 @@
 #ifndef __MM_VMALLOC_H
 #define __MM_VMALLOC_H
 
+#include <linux/vmalloc.h>
+
 #ifdef CONFIG_MMU
 void __init vmalloc_init(void);
 int __must_check vmap_pages_range_noflush(unsigned long addr, unsigned long end,
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vmalloc-acquire-init_mm-lock-on-huge-vmap-to-avoid-ptdump-uaf.patch
mm-ptdump-always-stabilise-against-page-table-freeing-using-init_mm.patch
arm64-remove-redundant-concurrent-ptdump-uaf-mitigation.patch
mm-huge_memory-fix-huge_zero_pfn-race.patch
mm-huge_memory-separate-out-config_persistent_huge_zero_folio-logic.patch
x86-mm-pat-acquire-init_mm-write-lock-on-collapse-to-avoid-uaf.patch
x86-mm-pat-acquire-init_mm-read-lock-on-attribute-change-to-avoid-uaf.patch
x86-mm-pat-allocate-split-page-tables-as-kernel-page-tables.patch
mm-move-vma_start_pgoff-into-mmh-and-clean-up.patch
mm-add-kdoc-comments-for-vma_start-last_pgoff.patch
tools-testing-vma-use-vma_start_pgoff-in-merge-tests.patch
mm-introduce-and-use-vma_end_pgoff.patch
mm-rmap-update-mm-interval_treec-comments.patch
mm-rmap-parameterise-vma_interval_tree_-by-address_space.patch
mm-rmap-elide-unnecessary-static-inlines-in-interval_treec.patch
mm-rmap-rename-vma_interval_tree_-to-mapping_rmap_tree_.patch
mm-rmap-parameterise-anon_vma_interval_tree_-by-anon_vma.patch
mm-rmap-rename-anon_vma_interval_tree_-params-and-use-pgoff_t.patch
mm-rmap-rename-anon_vma_interval_tree_-to-anon_rmap_tree_.patch
maintainers-move-mm-interval_treec-to-rmap-section.patch
mm-vma-introduce-and-use-vmg_pages-vmg__pgoff.patch
mm-vma-clean-up-anon_vma_compatible.patch
mm-vma-refactor-vmg_adjust_set_range-for-clarity.patch
mm-vma-minor-cleanup-of-expand_.patch
mm-introduce-and-use-linear_page_delta.patch
mm-vma-use-vma_start_pgoff-linear_page_index-in-mm-code.patch
mm-prefer-vma__pgoff-to-vma-vm_pgoff-in-kernel.patch
mm-vma-remove-duplicative-vma_pgoff_offset-helper.patch
mm-use-linear_page_-consistently.patch
mm-vma-introduce-vma_assert_can_modify.patch
mm-vma-add-and-use-vma__pgoff.patch
mm-vma-move-__install_special_mapping-to-vmac.patch
mm-vma-make-vma_set_range-static-drop-insert_vm_struct-decl.patch
mm-vma-update-vma_shrink-to-not-pass-start-pgoff-parameters.patch
mm-vma-update-vmg_adjust_set_range-to-offset-pgoff-instead.patch
mm-vma-slightly-rework-the-anonymous-check-in-__mmap_new_vma.patch
mm-vma-introduce-and-use-vma_set_pgoff.patch
mm-vma-correct-incorrect-vmah-inclusion.patch
mm-vma-use-guard-clauses-in-can_vma_merge_.patch
tools-testing-vma-default-vma-mm-flag-bits-to-64-bit.patch
tools-testing-vma-output-compared-expression-on-assert_.patch
mm-introduce-vma_flags_can_grow-and-vma_can_grow.patch
mm-vma-update-do_mmap-to-use-vma_flags_t.patch
mm-convert-__get_unmapped_area-to-use-vma_flags_t.patch
mm-update-generic_get_unmapped_area-to-use-vma_flags_t.patch
mm-prefer-mm-def_vma_flags-in-mm-logic.patch
mm-vma-convert-vm_pgprot_modify-to-use-vma_flags_t-and-rename.patch
mm-vma-rename-vma_get_page_prot-to-vma_flags_to_page_prot.patch
mm-introduce-vma_get_page_prot-and-use-it.patch
mm-vma-update-create_init_stack_vma-to-use-vma_flags_t.patch
mm-vma-convert-miscellaneous-uses-of-vma-flags-in-core-mm.patch
mm-mlock-convert-mlock-code-to-use-vma_flags_t.patch
mm-mprotect-convert-mprotect-code-to-use-vma_flags_t.patch
mm-mremap-convert-mremap-code-to-use-vma_flags_t.patch
mm-mseal-remove-superfluous-comments-fix-confusion-around-mm.patch
mm-mseal-limit-scope-of-mseal-address-zero-to-address-zero.patch
mm-mseal-remove-further-superfluous-comments-do_mseal.patch
mm-vma-introduce-vma-virtual-page-offset-field-and-add-helpers.patch
mm-introduce-linear_virt_page_index.patch
mm-abstract-vma_address-and-introduce-vma_anon_address.patch
mm-update-print_bad_page_map-to-show-virtual-page-index.patch
mm-introduce-and-use-vma_filebacked_address.patch
mm-propagate-vma-virtual-page-offset-on-map-remap-split-merge.patch
mm-rmap-track-whether-the-page-vma-mapped-walk-is-anonymous.patch
mm-introduce-and-use-linear_folio_page_index.patch
mm-rmap-use-virt-pgoff-for-map_private-file-backed-anon-folios.patch
tools-testing-vma-expand-vma-merge-tests-to-assert-virt-pgoff.patch
tools-testing-selftests-mm-test-virtual-page-offset-merge-behaviour.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch
mm-add-some-missing-includes-to-mm-local-headers.patch

