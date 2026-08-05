Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F203E3C0A10
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896792; cv=none; b=Qj0JWvoQYDi29askhGes/t2xr6Czpsae96DDQ7pnxDl/0E2KNwvetLvTWWJhrHmd/GSm+oY0QcHRTku6rOQJc/Wh/iHZM6yK1/Si1K5gSgT6gM4QiUCTFsgJz/rV6QpZDjVyM47fN6JHtHAh+s03LC64wqojI/ZkpCQihUVvXyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896792; c=relaxed/simple;
	bh=LTOB7mQ/nC/Op4n9VX2PMtFxIzbcnVOX5yHc8q1gOow=;
	h=Date:To:From:Subject:Message-Id; b=gAy8ftqT+G0Y+2MXYm/51/aQ5KXTq0IYCUCfZtYnwEdWf1eZzrKzImuyzePDIkTVWrM4mIhj2emHjg5THxpgNTaFhNFyXh6jGM7cQPp06wBTwVgVYFWzcs3RtJ7pfoKYkm7iKQ5uNWezVewhMxPIsjcaqf7edONwaO0ufnC5Kw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F1aXinbS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F1aXinbS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA1A1F000E9;
	Wed,  5 Aug 2026 02:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896790;
	bh=Qnw/RCbCTQY878iErkyRNu32sfDoD/iK0CqPsMfEX/k=;
	h=Date:To:From:Subject;
	b=F1aXinbSewn1CDJJZZx/hSQjpZ1QyEi4B6b1d9BbQVYaTenEY1QeSaLOaWhcStc/o
	 gL1IgS+Bn6Wcm3gQDNFeztpBileagbtNXxlsu6WzRyx4gODBXIKOnpNtBl4+6LKyp7
	 9F9/oj/9NP1T/nrrVAUnXFAS6+EKqYQNPE6y8pcw=
Date: Tue, 04 Aug 2026 19:26:30 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,tzimmermann@suse.de,sj@kernel.org,pfalcato@suse.de,m.szyprowski@samsung.com,liam@infradead.org,kai.huang@intel.com,gourry@gourry.net,david@kernel.org,ackerleytng@google.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-slightly-rework-the-anonymous-check-in-__mmap_new_vma.patch removed from -mm tree
Message-Id: <20260805022630.BBA1A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: slightly rework the anonymous check in __mmap_new_vma()
has been removed from the -mm tree.  Its filename was
     mm-vma-slightly-rework-the-anonymous-check-in-__mmap_new_vma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: mm/vma: slightly rework the anonymous check in __mmap_new_vma()
Date: Fri, 10 Jul 2026 21:17:09 +0100

Determine if the VMA is anonymous early on, so we separate the logic which
invokes callbacks from the rest of the logic.

This is in order that a subsequent commit which asserts correct virtual
page offset for anonymous mappings correctly asserts this for new anonymous
mappings.

No functional change intended.

Link: https://lore.kernel.org/20260710-b4-pre-scalable-cow-v2-28-2a5aa403d977@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Kai Huang <kai.huang@intel.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: SJ Park <sj@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/mm/vma.c~mm-vma-slightly-rework-the-anonymous-check-in-__mmap_new_vma
+++ a/mm/vma.c
@@ -2587,6 +2587,8 @@ static int __mmap_new_file_vma(struct mm
 static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
 	struct mmap_action *action)
 {
+	const bool is_anon = !map->file &&
+		!vma_flags_test(&map->vma_flags, VMA_SHARED_BIT);
 	struct vma_iterator *vmi = map->vmi;
 	int error = 0;
 	struct vm_area_struct *vma;
@@ -2601,6 +2603,10 @@ static int __mmap_new_vma(struct mmap_st
 		return -ENOMEM;
 
 	vma_iter_config(vmi, map->addr, map->end);
+
+	if (is_anon)
+		vma_set_anonymous(vma);
+
 	vma_set_range(vma, map->addr, map->end, map->pgoff);
 	vma->flags = map->vma_flags;
 	vma->vm_page_prot = map->page_prot;
@@ -2610,12 +2616,11 @@ static int __mmap_new_vma(struct mmap_st
 		goto free_vma;
 	}
 
+	/* Invoke callbacks. */
 	if (map->file)
 		error = __mmap_new_file_vma(map, vma);
-	else if (vma_flags_test(&map->vma_flags, VMA_SHARED_BIT))
+	else if (!is_anon)
 		error = shmem_zero_setup(vma);
-	else
-		vma_set_anonymous(vma);
 
 	if (error)
 		goto free_iter_vma;
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

