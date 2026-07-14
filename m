Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD64C37AA92
	for <mm-commits@vger.kernel.org>; Tue, 14 Jul 2026 02:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783995975; cv=none; b=Br4Y/a+gpUU+lq0T8TsVMKtQqTPJqrB8+BTKGvQzlkGA9HYKdeYNPuOWzcguTDOppSYwoTX5Pw/B+hrmpIaLzHVkrG5aimfptslYDGLGscZJe5Xljolcxr3/OcdZ/9xwPqq2O7LrE3KCjEfLKViNBf4KX16sz+xWK+kozN9dkPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783995975; c=relaxed/simple;
	bh=A6jr49tLONH4NrnmpLSr3SbSSd26qeIXvDh7UISPtCA=;
	h=Date:To:From:Subject:Message-Id; b=do7wtLKA5tk0Pb6IDLqED+njx7asLHGQXALun5HVlrVURmzM/ERhbhkO9u++HVkEBcQ/G8K1rrVmf1aUIw5ElGO9vUTO3cIiU+PQd6e6a+hjrfChkfYfZv/kNnQtjh6C6l4iPfRXh2gl2xawRtBsmS7K1vj6Qtkkq2DbuLJ+TuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kqxBUaFD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kqxBUaFD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2C491F000E9;
	Tue, 14 Jul 2026 02:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783995973;
	bh=jhjZZL3nxtET3JPQsh+oEtA3USg8oYVwzxnl8aBxKcw=;
	h=Date:To:From:Subject;
	b=kqxBUaFDF9J81CEGh5XEREZyXRl8BimugsYGBCiZpTgtO0BQmqha4arDv4c/WIBhv
	 VtXCsY02ofRNllbY0AXSagTQbr+jGf0GF3/5BKcWZ3K5L1MUSMhWvuGOhbOubLSOqE
	 Bgb7AxsdTVMJ6ZYopADyYluv1PThFRcL7LpQw3oY=
Date: Mon, 13 Jul 2026 19:26:13 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-rename-vma_get_page_prot-to-vma_flags_to_page_prot.patch added to mm-new branch
Message-Id: <20260714022613.A2C491F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: rename vma_get_page_prot to vma_flags_to_page_prot
has been added to the -mm mm-new branch.  Its filename is
     mm-vma-rename-vma_get_page_prot-to-vma_flags_to_page_prot.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-rename-vma_get_page_prot-to-vma_flags_to_page_prot.patch

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
Subject: mm/vma: rename vma_get_page_prot to vma_flags_to_page_prot
Date: Sat, 11 Jul 2026 19:45:04 +0100

Having vma_get_page_prot() refer to VMA flags and vma_set_page_prot()
refer to a VMA is confusing.

Rename vma_get_page_prot() to vma_flags_to_page_prot() to resolve this
confusion.

No functional change intended.

Link: https://lore.kernel.org/20260711-b4-vma-flags-mm-v2-7-0fa2357d5431@kernel.org
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

 include/linux/mm.h              |    4 ++--
 mm/vma.c                        |    2 +-
 mm/vma.h                        |    2 +-
 tools/testing/vma/include/dup.h |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/mm.h~mm-vma-rename-vma_get_page_prot-to-vma_flags_to_page_prot
+++ a/include/linux/mm.h
@@ -4603,7 +4603,7 @@ static inline bool range_in_vma_desc(con
 #ifdef CONFIG_MMU
 pgprot_t vm_get_page_prot(vm_flags_t vm_flags);
 
-static inline pgprot_t vma_get_page_prot(vma_flags_t vma_flags)
+static inline pgprot_t vma_flags_to_page_prot(vma_flags_t vma_flags)
 {
 	const vm_flags_t vm_flags = vma_flags_to_legacy(vma_flags);
 
@@ -4616,7 +4616,7 @@ static inline pgprot_t vm_get_page_prot(
 {
 	return __pgprot(0);
 }
-static inline pgprot_t vma_get_page_prot(vma_flags_t vma_flags)
+static inline pgprot_t vma_flags_to_page_prot(vma_flags_t vma_flags)
 {
 	return __pgprot(0);
 }
--- a/mm/vma.c~mm-vma-rename-vma_get_page_prot-to-vma_flags_to_page_prot
+++ a/mm/vma.c
@@ -56,7 +56,7 @@ struct mmap_state {
 		.pglen = PHYS_PFN(len_),				\
 		.vma_flags = vma_flags_,				\
 		.file = file_,						\
-		.page_prot = vma_get_page_prot(vma_flags_),		\
+		.page_prot = vma_flags_to_page_prot(vma_flags_),	\
 	}
 
 #define VMG_MMAP_STATE(name, map_, vma_)				\
--- a/mm/vma.h~mm-vma-rename-vma_get_page_prot-to-vma_flags_to_page_prot
+++ a/mm/vma.h
@@ -543,7 +543,7 @@ static inline bool vma_wants_manual_pte_
 #ifdef CONFIG_MMU
 static inline pgprot_t vma_pgprot_modify(pgprot_t oldprot, vma_flags_t vma_flags)
 {
-	const pgprot_t prot = vma_get_page_prot(vma_flags);
+	const pgprot_t prot = vma_flags_to_page_prot(vma_flags);
 
 	return pgprot_modify(oldprot, prot);
 }
--- a/tools/testing/vma/include/dup.h~mm-vma-rename-vma_get_page_prot-to-vma_flags_to_page_prot
+++ a/tools/testing/vma/include/dup.h
@@ -1545,7 +1545,7 @@ static inline int get_sysctl_max_map_cou
 #define pgtable_supports_soft_dirty()	IS_ENABLED(CONFIG_MEM_SOFT_DIRTY)
 #endif
 
-static inline pgprot_t vma_get_page_prot(vma_flags_t vma_flags)
+static inline pgprot_t vma_flags_to_page_prot(vma_flags_t vma_flags)
 {
 	const vm_flags_t vm_flags = vma_flags_to_legacy(vma_flags);
 
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

