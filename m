Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE59407569
	for <mm-commits@vger.kernel.org>; Fri, 10 Jul 2026 22:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783723645; cv=none; b=Ok+LXudVM5m3Hb/rq/8MVFA9ZHlZzm+HxnreyNsuOWCiwg0cFWqB8lTPITW+fOoP08Plf6RmNl/t0Win12EaH4z9TqwAanHtBzEeW8E36StasGp0Y4GVW2ZJNzQgeM4BAkoo2WmUslQOUWxhpHqH/gViWm4Qr96p/6KcWI5kNhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783723645; c=relaxed/simple;
	bh=Vxv4aiUJbpR3MFUZIswYbeECmIEq2Cywpt/VIBTMC9s=;
	h=Date:To:From:Subject:Message-Id; b=tXNjB3gfLqSS9sQU/f5U+U5Qk2efFjG37moJ4qxdjRmioMlA6QBz1QRexFc222xJrpVYDUiDN9PUBY7Z8+EziadMSkWycbXmJiDBvzyItXgke205x5vw2rN1TNEzLgbEuZ52cj50Kg5oU2GwBiWERNAwY5gb7W9EvAwoMikhn3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sBg/iYPg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sBg/iYPg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AA5B1F000E9;
	Fri, 10 Jul 2026 22:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783723644;
	bh=NUpvr6CHWAlUQqNyRfCdocjVobaaQ7YybQT7QTzJDvw=;
	h=Date:To:From:Subject;
	b=sBg/iYPgD5HciexzJ+7tKIsLzHGvryMa5EW1EKQhg8DLjqrOg+sewSMLmZTpuLq9q
	 S/r05mWzpw5y3tGmJrCvPOnTgqhglyrns2zwlafTPOx0GnXAOL78Iy3FHen7N7nGuU
	 osfKWQhO2ULi0nKmqDiAGAxzZ5IULLh5refF1Sgw=
Date: Fri, 10 Jul 2026 15:47:23 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-slightly-rework-the-anonymous-check-in-__mmap_new_vma.patch added to mm-new branch
Message-Id: <20260710224724.3AA5B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: slightly rework the anonymous check in __mmap_new_vma()
has been added to the -mm mm-new branch.  Its filename is
     mm-vma-slightly-rework-the-anonymous-check-in-__mmap_new_vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-slightly-rework-the-anonymous-check-in-__mmap_new_vma.patch

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
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Kai Huang <kai.huang@intel.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: SJ Park <sj@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Vlastimil Babka (SUSE) <vbabka@kernel.org>
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

