Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B20E404BD2
	for <mm-commits@vger.kernel.org>; Fri, 10 Jul 2026 22:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783723630; cv=none; b=An9pKuL6GQ6i6ElUXyAFpZs9oBhsxniSAIru/2IgQ7udF5gC9DjJ8Q08mAIhlAYQCDOyW1DWVw4wFRb2jH10F8TgfGw/kfHixRzu3JnoHkJsF+/gHQFJFLm27ldTZowvfJSNIxBnkaExdXEjtk3saP8Z1kMU4AmwvwXxwCBjllw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783723630; c=relaxed/simple;
	bh=eDXYibr2SxOTejbV5joHlTUmnI1nItF8kfdySOnqC14=;
	h=Date:To:From:Subject:Message-Id; b=F7Cag+jg1RA3CaMs/S3wG7lMKLtnGUEIpwnvYjp2omR7JMkcHvKpJcCePK3sXpmcxgx/YIwVGp0sHTdqSREEH/9F7lV57EubxEIgkUZk0BKNwcj8Ifsu9rhnSElMpd4vt9BS+bA5ktNiBjmyT5ph63o1xkUs7SvmUR33BDkIdEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xEBe6i9q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xEBe6i9q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7941F000E9;
	Fri, 10 Jul 2026 22:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783723629;
	bh=bM8sLMBIAdlZ7XofCOlhc2gTYT/paofQnPOhKV9sb6Y=;
	h=Date:To:From:Subject;
	b=xEBe6i9qKGbK6dfQvHnayBEBeMlTiG26Qk7eIKScDccyaxbCWtyFAfTr5dWgiukor
	 tz55YqD9ZnfjIDbT+hsCw+5PMtKcQc67fDg6vilXiWWhsjMHFimqa+dt5hHVvJhI7a
	 Eats7IbSk/c7Shc73whuRUww0vbOHm8bKQQbsbdI=
Date: Fri, 10 Jul 2026 15:47:08 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-add-and-use-vma__pgoff.patch added to mm-new branch
Message-Id: <20260710224709.0F7941F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: add and use vma_[add/sub]_pgoff()
has been added to the -mm mm-new branch.  Its filename is
     mm-vma-add-and-use-vma__pgoff.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-add-and-use-vma__pgoff.patch

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
Subject: mm/vma: add and use vma_[add/sub]_pgoff()
Date: Fri, 10 Jul 2026 21:17:04 +0100

Add helpers for adding or subtracting to a VMA's page offset, exposed
internally for VMA users within mm in mm/vma.h.

This is to lay the foundations for tracking anonymous page offset for
MAP_PRIVATE file-backed mappings, where adding and subtracting from this
value must be reflected in both the file and anonymous offsets.

These are used on VMA split and downward stack expansion.

No functional change intended.

Link: https://lore.kernel.org/20260710-b4-pre-scalable-cow-v2-23-2a5aa403d977@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Gregory Price <gourry@gourry.net>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Kai Huang <kai.huang@intel.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: SJ Park <sj@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    6 ++++--
 mm/vma.c   |    6 +++---
 mm/vma.h   |   12 ++++++++++++
 3 files changed, 19 insertions(+), 5 deletions(-)

--- a/mm/nommu.c~mm-vma-add-and-use-vma__pgoff
+++ a/mm/nommu.c
@@ -41,6 +41,7 @@
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
 #include "internal.h"
+#include "vma.h"
 
 unsigned long highest_memmap_pfn;
 int heap_stack_gap = 0;
@@ -1361,7 +1362,8 @@ static int split_vma(struct vma_iterator
 		region->vm_top = region->vm_end = new->vm_end = addr;
 	} else {
 		region->vm_start = new->vm_start = addr;
-		region->vm_pgoff = new->vm_pgoff += npages;
+		vma_add_pgoff(new, npages);
+		region->vm_pgoff = vma_start_pgoff(new);
 	}
 
 	vma_iter_config(vmi, new->vm_start, new->vm_end);
@@ -1378,7 +1380,7 @@ static int split_vma(struct vma_iterator
 	delete_nommu_region(vma->vm_region);
 	if (new_below) {
 		vma->vm_region->vm_start = vma->vm_start = addr;
-		vma->vm_pgoff += npages;
+		vma_add_pgoff(vma, npages);
 		vma->vm_region->vm_pgoff = vma_start_pgoff(vma);
 	} else {
 		vma->vm_region->vm_end = vma->vm_end = addr;
--- a/mm/vma.c~mm-vma-add-and-use-vma__pgoff
+++ a/mm/vma.c
@@ -517,7 +517,7 @@ __split_vma(struct vma_iterator *vmi, st
 		new->vm_end = addr;
 	} else {
 		new->vm_start = addr;
-		new->vm_pgoff += linear_page_delta(vma, addr);
+		vma_add_pgoff(new, linear_page_delta(vma, addr));
 	}
 
 	err = -ENOMEM;
@@ -556,7 +556,7 @@ __split_vma(struct vma_iterator *vmi, st
 
 	if (new_below) {
 		vma->vm_start = addr;
-		vma->vm_pgoff += (addr - new->vm_start) >> PAGE_SHIFT;
+		vma_add_pgoff(vma, (addr - new->vm_start) >> PAGE_SHIFT);
 	} else {
 		vma->vm_end = addr;
 	}
@@ -3305,7 +3305,7 @@ int expand_downwards(struct vm_area_stru
 				vm_stat_account(mm, vma->vm_flags, grow);
 				anon_rmap_tree_pre_update_vma(vma);
 				vma->vm_start = address;
-				vma->vm_pgoff -= grow;
+				vma_sub_pgoff(vma, grow);
 				/* Overwrite old entry in mtree. */
 				vma_iter_store_overwrite(&vmi, vma);
 				anon_rmap_tree_post_update_vma(vma);
--- a/mm/vma.h~mm-vma-add-and-use-vma__pgoff
+++ a/mm/vma.h
@@ -247,6 +247,18 @@ static inline pgoff_t vmg_end_pgoff(cons
 	return vmg_start_pgoff(vmg) + vmg_pages(vmg);
 }
 
+static inline void vma_add_pgoff(struct vm_area_struct *vma, pgoff_t delta)
+{
+	vma_assert_can_modify(vma);
+	vma->vm_pgoff += delta;
+}
+
+static inline void vma_sub_pgoff(struct vm_area_struct *vma, pgoff_t delta)
+{
+	vma_assert_can_modify(vma);
+	vma->vm_pgoff -= delta;
+}
+
 #define VMG_STATE(name, mm_, vmi_, start_, end_, vma_flags_, pgoff_)	\
 	struct vma_merge_struct name = {				\
 		.mm = mm_,						\
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-move-alloc-tag-to-mm.patch
mm-ptdump-always-stabilise-against-page-table-freeing-using-init_mm.patch
mm-vmalloc-acquire-init_mm-read-lock-on-huge-vmap-promotion.patch
revert-arm64-enable-vmalloc-huge-with-ptdump.patch
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

