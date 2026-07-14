Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E121937D11C
	for <mm-commits@vger.kernel.org>; Tue, 14 Jul 2026 02:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783995971; cv=none; b=RxB4g+E9xZtiZYaCji+aVZF/oAQpuXXy2C/hAm1NYCX8r4J2mPk3sN3tVSNzmnpqTU/phcGdOjoKZzpZmAcW56hesp35I1gGYdcJ3UUe6MBBy0557jxn+RqAdB43KR12mnuOh05r5RzPFXZosZoUaxHHlXoVxLkMtGaJs0a4i80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783995971; c=relaxed/simple;
	bh=HDUx8xnOVw8j9f27F28bry+2HdAIc5jqvBXRQ6eaznk=;
	h=Date:To:From:Subject:Message-Id; b=TLf+hPVE4Kt5WGeD1dXxmNotLm51AGnvqRq9/201p8xPskcoUt9dIEOYRMVbfTgJ4bF1rrB06Y8CZ+sPseUywd2cSa27n9OzAON6MI7GgJDNHmK9/cPy/vgq+eGKxdQvdLNb0L/Ck3cZVLIHy5XwdJe0f1W2jXlW0v1qs7QZ8JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ut2shwai; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ut2shwai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B535D1F00A3A;
	Tue, 14 Jul 2026 02:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783995969;
	bh=+GGe1eqxc9KVWDB8w2WRDV3n6v5yZb5Dx4h+QzZOx2o=;
	h=Date:To:From:Subject;
	b=ut2shwaiUcPHHVhNC6jmjb+v72+71LBTElk7A77Am0AUAWreQZHLQbqQceNscwxS/
	 olT5f9vchEKg237IfEuiSZhM+mcysdmsadNUZWMLhRP+6FKn4FiZmhRZwdxQBKIuaF
	 da9iKVimY5pvfKk86JCReZnc7VU35kiu7+iMMjcA=
Date: Mon, 13 Jul 2026 19:26:09 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-convert-vm_pgprot_modify-to-use-vma_flags_t-and-rename.patch added to mm-new branch
Message-Id: <20260714022609.B535D1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: convert vm_pgprot_modify() to use vma_flags_t and rename
has been added to the -mm mm-new branch.  Its filename is
     mm-vma-convert-vm_pgprot_modify-to-use-vma_flags_t-and-rename.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-convert-vm_pgprot_modify-to-use-vma_flags_t-and-rename.patch

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
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: mm/vma: convert vm_pgprot_modify() to use vma_flags_t and rename
Date: Sat, 11 Jul 2026 19:45:03 +0100

Update vm_pgprot_modify() to use the new VMA flags type vma_flags_t, and
rename to vma_pgprot_modify() accordingly.

This is part of the ongoing work to convert vm_flags_t to vma_flags_t, in
order to eliminate the arbitrary limit of the number of bits in a system
word on available VMA flags.

Update VMA userland tests accordingly, updating vma_set_page_prot() to no
longer inline vma_pgprot_modify(), rather we can simply define
vma_pgprot_modify() as a static inline function and the tests will pick it
up from vma.h.

No functional change intended.

Link: https://lore.kernel.org/20260711-b4-vma-flags-mm-v2-6-0fa2357d5431@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Dave Airlie <airlied@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nico Pache <npache@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c                       |    8 ++++----
 mm/vma.c                        |    2 +-
 mm/vma.h                        |    6 ++++--
 tools/testing/vma/include/dup.h |   12 +++++-------
 4 files changed, 14 insertions(+), 14 deletions(-)

--- a/mm/mmap.c~mm-vma-convert-vm_pgprot_modify-to-use-vma_flags_t-and-rename
+++ a/mm/mmap.c
@@ -80,13 +80,13 @@ core_param(ignore_rlimit_data, ignore_rl
 /* Update vma->vm_page_prot to reflect vma->vm_flags. */
 void vma_set_page_prot(struct vm_area_struct *vma)
 {
-	vm_flags_t vm_flags = vma->vm_flags;
+	vma_flags_t vma_flags = vma->flags;
 	pgprot_t vm_page_prot;
 
-	vm_page_prot = vm_pgprot_modify(vma->vm_page_prot, vm_flags);
+	vm_page_prot = vma_pgprot_modify(vma->vm_page_prot, vma_flags);
 	if (vma_wants_writenotify(vma, vm_page_prot)) {
-		vm_flags &= ~VM_SHARED;
-		vm_page_prot = vm_pgprot_modify(vm_page_prot, vm_flags);
+		vma_flags_clear(&vma_flags, VMA_SHARED_BIT);
+		vm_page_prot = vma_pgprot_modify(vm_page_prot, vma_flags);
 	}
 	/* remove_protection_ptes reads vma->vm_page_prot without mmap_lock */
 	WRITE_ONCE(vma->vm_page_prot, vm_page_prot);
--- a/mm/vma.c~mm-vma-convert-vm_pgprot_modify-to-use-vma_flags_t-and-rename
+++ a/mm/vma.c
@@ -2176,7 +2176,7 @@ bool vma_wants_writenotify(struct vm_are
 	/* The open routine did something to the protections that pgprot_modify
 	 * won't preserve? */
 	if (pgprot_val(vm_page_prot) !=
-	    pgprot_val(vm_pgprot_modify(vm_page_prot, vma->vm_flags)))
+	    pgprot_val(vma_pgprot_modify(vm_page_prot, vma->flags)))
 		return false;
 
 	/*
--- a/mm/vma.h~mm-vma-convert-vm_pgprot_modify-to-use-vma_flags_t-and-rename
+++ a/mm/vma.h
@@ -541,9 +541,11 @@ static inline bool vma_wants_manual_pte_
 }
 
 #ifdef CONFIG_MMU
-static inline pgprot_t vm_pgprot_modify(pgprot_t oldprot, vm_flags_t vm_flags)
+static inline pgprot_t vma_pgprot_modify(pgprot_t oldprot, vma_flags_t vma_flags)
 {
-	return pgprot_modify(oldprot, vm_get_page_prot(vm_flags));
+	const pgprot_t prot = vma_get_page_prot(vma_flags);
+
+	return pgprot_modify(oldprot, prot);
 }
 #endif
 
--- a/tools/testing/vma/include/dup.h~mm-vma-convert-vm_pgprot_modify-to-use-vma_flags_t-and-rename
+++ a/tools/testing/vma/include/dup.h
@@ -1424,20 +1424,18 @@ struct vm_area_struct *vma_iter_next_ran
 }
 
 bool vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot);
+static inline pgprot_t vma_pgprot_modify(pgprot_t oldprot, vma_flags_t vma_flags);
 
 /* Update vma->vm_page_prot to reflect vma->vm_flags. */
 static inline void vma_set_page_prot(struct vm_area_struct *vma)
 {
-	vm_flags_t vm_flags = vma->vm_flags;
+	vma_flags_t vma_flags = vma->flags;
 	pgprot_t vm_page_prot;
 
-	/* testing: we inline vm_pgprot_modify() to avoid clash with vma.h. */
-	vm_page_prot = pgprot_modify(vma->vm_page_prot, vm_get_page_prot(vm_flags));
-
+	vm_page_prot = vma_pgprot_modify(vma->vm_page_prot, vma_flags);
 	if (vma_wants_writenotify(vma, vm_page_prot)) {
-		vm_flags &= ~VM_SHARED;
-		/* testing: we inline vm_pgprot_modify() to avoid clash with vma.h. */
-		vm_page_prot = pgprot_modify(vm_page_prot, vm_get_page_prot(vm_flags));
+		vma_flags_clear(&vma_flags, VMA_SHARED_BIT);
+		vm_page_prot = vma_pgprot_modify(vm_page_prot, vma_flags);
 	}
 	/* remove_protection_ptes reads vma->vm_page_prot without mmap_lock */
 	WRITE_ONCE(vma->vm_page_prot, vm_page_prot);
diff --git /dev/null /dev/null
new file mode 100664
diff --git /dev/null /dev/null
new file mode 100664
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vmalloc-acquire-init_mm-lock-on-huge-vmap-to-avoid-ptdump-uaf.patch
x86-mm-pat-acquire-mmap-lock-on-page-table-free-to-avoid-ptdump-uaf.patch
mm-ptdump-always-stabilise-against-page-table-freeing-using-init_mm.patch
arm64-remove-redundant-concurrent-ptdump-uaf-mitigation.patch
mm-move-alloc-tag-to-mm.patch
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

