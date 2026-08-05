Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D427F3C10AA
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896788; cv=none; b=g1kkP6AFZoRXFXJtETYFybylND+c0bi7k47Y4+I6NKaMFDtKMSZVwldr5yuCzwvcayQR4RcwRtRbQRDXYvT0wWtMA4MoIFeWi5S6siUBqMu5Ktxs/SoKqDz6l99l4eE1Qqi/c0r6W8OOee5wbVtLnARBQ5b9bVlTmBLqQWnCu/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896788; c=relaxed/simple;
	bh=Mb0aBNPDkMOwF9SkXSXmY7Ck2JLoxy3FWye+mDrRi8o=;
	h=Date:To:From:Subject:Message-Id; b=IBYOyY3bCqekzbflGzfXV9x4Fsx0ELWz/pqjDppA/5XRFY8uN9ANkoyUi1V0ayYeQiupjXWuuUH7IXrZPiZh+EpW28rdIiGlmsJ0D8FM56PnK+E69Prh+HyuMiPZQXSIACRqcEcaf6L3HJTUo6d38F5yk3v91nX5HGpwtxbK7pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yAcnNEZD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yAcnNEZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F631F00A3A;
	Wed,  5 Aug 2026 02:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896786;
	bh=MfbLIVHKUpJXkQb4TVWFeD3d1yAnKIWVFW2YAw5svlY=;
	h=Date:To:From:Subject;
	b=yAcnNEZDWyXXygp8W0jAE5YxsTSmFGYnvQTlwU7AFf6sXMgUMpp4qNNruaS5/Ko3L
	 15Xf8/o73kWKzAwD3Ewfl6ansHnPO72cVKvFY3WFFiD7WZ5X6ofcp87pmaluskIpSJ
	 TwQBCoeXvunCzjuvPRtxHfLJNkjerMZctedYLg4k=
Date: Tue, 04 Aug 2026 19:26:25 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,tzimmermann@suse.de,sj@kernel.org,pfalcato@suse.de,m.szyprowski@samsung.com,liam@infradead.org,kai.huang@intel.com,gourry@gourry.net,david@kernel.org,ackerleytng@google.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-make-vma_set_range-static-drop-insert_vm_struct-decl.patch removed from -mm tree
Message-Id: <20260805022626.73F631F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: make vma_set_range() static, drop insert_vm_struct() decl
has been removed from the -mm tree.  Its filename was
     mm-vma-make-vma_set_range-static-drop-insert_vm_struct-decl.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: mm/vma: make vma_set_range() static, drop insert_vm_struct() decl
Date: Fri, 10 Jul 2026 21:17:06 +0100

With __install_special_mapping() moved to vma.c, vma_set_range() can be
made into a static function there and is now completely isolated from the
rest of mm.

While we're here, we can also remove the insert_vm_struct() declaration
from mm.h - the function is implemented in vma.c and already declared in
vma.h, and has no users outside of mm.

Also update the VMA userland tests to reflect this change.

No functional change intended.

Link: https://lore.kernel.org/20260710-b4-pre-scalable-cow-v2-25-2a5aa403d977@kernel.org
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

 include/linux/mm.h         |    1 -
 mm/internal.h              |    9 ---------
 mm/vma.c                   |    8 ++++++++
 tools/testing/vma/shared.c |    9 ---------
 tools/testing/vma/shared.h |    5 -----
 5 files changed, 8 insertions(+), 24 deletions(-)

--- a/include/linux/mm.h~mm-vma-make-vma_set_range-static-drop-insert_vm_struct-decl
+++ a/include/linux/mm.h
@@ -4134,7 +4134,6 @@ void anon_rmap_tree_verify(struct anon_v
 
 /* mmap.c */
 extern int __vm_enough_memory(const struct mm_struct *mm, long pages, int cap_sys_admin);
-extern int insert_vm_struct(struct mm_struct *, struct vm_area_struct *);
 extern void exit_mmap(struct mm_struct *);
 bool mmap_read_lock_maybe_expand(struct mm_struct *mm, struct vm_area_struct *vma,
 				 unsigned long addr, bool write);
--- a/mm/internal.h~mm-vma-make-vma_set_range-static-drop-insert_vm_struct-decl
+++ a/mm/internal.h
@@ -1360,15 +1360,6 @@ static inline bool gup_must_unshare(stru
 }
 
 
-static __always_inline void vma_set_range(struct vm_area_struct *vma,
-					  unsigned long start, unsigned long end,
-					  pgoff_t pgoff)
-{
-	vma->vm_start = start;
-	vma->vm_end = end;
-	vma->vm_pgoff = pgoff;
-}
-
 static inline bool vma_soft_dirty_enabled(struct vm_area_struct *vma)
 {
 	/*
--- a/mm/vma.c~mm-vma-make-vma_set_range-static-drop-insert_vm_struct-decl
+++ a/mm/vma.c
@@ -70,6 +70,14 @@ struct mmap_state {
 		.state = VMA_MERGE_START,				\
 	}
 
+static void vma_set_range(struct vm_area_struct *vma, unsigned long start,
+			  unsigned long end, pgoff_t pgoff)
+{
+	vma->vm_start = start;
+	vma->vm_end = end;
+	vma->vm_pgoff = pgoff;
+}
+
 /* Was this VMA ever forked from a parent, i.e. maybe contains CoW mappings? */
 static bool vma_is_fork_child(struct vm_area_struct *vma)
 {
--- a/tools/testing/vma/shared.c~mm-vma-make-vma_set_range-static-drop-insert_vm_struct-decl
+++ a/tools/testing/vma/shared.c
@@ -120,12 +120,3 @@ unsigned long rlimit(unsigned int limit)
 {
 	return (unsigned long)-1;
 }
-
-void vma_set_range(struct vm_area_struct *vma,
-		   unsigned long start, unsigned long end,
-		   pgoff_t pgoff)
-{
-	vma->vm_start = start;
-	vma->vm_end = end;
-	vma->vm_pgoff = pgoff;
-}
--- a/tools/testing/vma/shared.h~mm-vma-make-vma_set_range-static-drop-insert_vm_struct-decl
+++ a/tools/testing/vma/shared.h
@@ -125,8 +125,3 @@ void __vma_set_dummy_anon_vma(struct vm_
 /* Provide a simple dummy VMA/anon_vma dummy setup for testing. */
 void vma_set_dummy_anon_vma(struct vm_area_struct *vma,
 			    struct anon_vma_chain *avc);
-
-/* Helper function to specify a VMA's range. */
-void vma_set_range(struct vm_area_struct *vma,
-		   unsigned long start, unsigned long end,
-		   pgoff_t pgoff);
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

