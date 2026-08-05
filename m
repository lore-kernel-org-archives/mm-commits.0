Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4A13C0611
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896791; cv=none; b=kJbYypa6oCnnuGCMCG6oaBRw1HRaUm1gx03UI7refaWODYz9mQKIYXX97+AHjJ8QvRBaXyLXZGpaO7Mrl0kBIPVDLlmxeyYrTTp8alPw3lmHzWlOIMZQORQK8GW5WQNYmItk8BkdLgbyidCg8S/yHy4odpx9NbRtc+gA+NnLdzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896791; c=relaxed/simple;
	bh=g2AyDXlBFVyptmv8MSrY62itlSjni00FNtU32e5k2IM=;
	h=Date:To:From:Subject:Message-Id; b=uCduO/yXoz/OsunVWhhU+pPFb6VOjhary5+YtZO5AFqnKHREhsYsibC8twzYhQzfrDPhzh+xRdIgVbtrQKgW/+Yj3tkhyYCMXbNrPBCE1JD5L0nkO3jhVi2gSqALZ35A+tacvarqsMgaxlZ2JQ28FKSnKW/8tILgPzhkzTS0R6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sJ5NM/FU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sJ5NM/FU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 559531F00A3A;
	Wed,  5 Aug 2026 02:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896789;
	bh=diDxDDVMnnNhmFYWU86uAkt95288iFZyBl2fK9NC6jQ=;
	h=Date:To:From:Subject;
	b=sJ5NM/FUXLyV5Esuc3k7+W0eiMgXDWNDbSAzGt//aOckiWMmsX76zQe/D2V6GvoBx
	 bZMRkOAIzDvlTJJIw1hPDQ2eITxzwI3+adicuV0zDiZsGeftzN7MlM0A09jDnT9PJN
	 PQFBbWFMGYKqVIdVheZ/bNqdPxC7g+oukmQgRjI0=
Date: Tue, 04 Aug 2026 19:26:28 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,tzimmermann@suse.de,sj@kernel.org,pfalcato@suse.de,m.szyprowski@samsung.com,liam@infradead.org,kai.huang@intel.com,gourry@gourry.net,david@kernel.org,ackerleytng@google.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-update-vmg_adjust_set_range-to-offset-pgoff-instead.patch removed from -mm tree
Message-Id: <20260805022629.559531F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: update vmg_adjust_set_range() to offset pgoff instead
has been removed from the -mm tree.  Its filename was
     mm-vma-update-vmg_adjust_set_range-to-offset-pgoff-instead.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: mm/vma: update vmg_adjust_set_range() to offset pgoff instead
Date: Fri, 10 Jul 2026 21:17:08 +0100

We are calculating the pgoff as an offset, since we have vma_add_pgoff()
and vma_sub_pgoff() available, just offset this value directly and use
__vma_set_range() for vma->vm_[start, end] values.

We take care to update the range before offsetting the page offset, so the
adjusted VMA's vm_start and vm_pgoff are mutually consistent at the point
the page offset helpers operate - this matters once vma_set_pgoff() comes
to assert invariants which relate the two.

Doing so lays the foundation for future work which allows for use of
virtual page offsets for MAP_PRIVATE-file backed mappings.

No functional change intended.

Link: https://lore.kernel.org/20260710-b4-pre-scalable-cow-v2-27-2a5aa403d977@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Kai Huang <kai.huang@intel.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: SJ Park <sj@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

--- a/mm/vma.c~mm-vma-update-vmg_adjust_set_range-to-offset-pgoff-instead
+++ a/mm/vma.c
@@ -714,9 +714,6 @@ void validate_mm(struct mm_struct *mm)
  */
 static void vmg_adjust_set_range(struct vma_merge_struct *vmg)
 {
-	struct vm_area_struct *adjust;
-	pgoff_t pgoff;
-
 	if (vmg->__adjust_middle_start) {
 		/*
 		 * vmg->start    vmg->end
@@ -735,8 +732,8 @@ static void vmg_adjust_set_range(struct
 		struct vm_area_struct *middle = vmg->middle;
 		const unsigned long delta = vmg->end - middle->vm_start;
 
-		pgoff = vma_start_pgoff(middle) + (delta >> PAGE_SHIFT);
-		adjust = middle;
+		__vma_set_range(middle, vmg->end, middle->vm_end);
+		vma_add_pgoff(middle, delta >> PAGE_SHIFT);
 	} else if (vmg->__adjust_next_start) {
 		/*
 		 *                Originally:
@@ -764,13 +761,9 @@ static void vmg_adjust_set_range(struct
 		struct vm_area_struct *next = vmg->next;
 		const unsigned long delta = next->vm_start - vmg->end;
 
-		pgoff = vma_start_pgoff(next) - (delta >> PAGE_SHIFT);
-		adjust = next;
-	} else {
-		return;
+		__vma_set_range(next, vmg->end, next->vm_end);
+		vma_sub_pgoff(next, delta >> PAGE_SHIFT);
 	}
-
-	vma_set_range(adjust, vmg->end, adjust->vm_end, pgoff);
 }
 
 /*
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

