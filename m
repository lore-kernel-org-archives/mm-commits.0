Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13524FDE45;
	Thu,  3 Sep 2026 17:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788458198; cv=none; b=oyokzKZM5oH2fdKWQNOee6gx0ARGloFOqcUENGRHL0TOb3XJTkvwNObJFtQbDs7RW/twjIC0fi3ARs49TFm1TujEMwDwNeesWiegTRaVUmIBNRWBW570cAq53VhBODdBq5b5zA/oZmYkIrlLgBT8NGnSYTUGRaIJsSV+uCkZbu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788458198; c=relaxed/simple;
	bh=0TT7wHP9tTZfxJQlkUsqPjvFt4cgsVGZv9c6+BoCu0Y=;
	h=Date:To:From:Subject:Message-Id; b=sZ0wJAStSM28//5NhXGRBEH508GmdRE19l7uoeAJvW6TUmj8m2lOZpE2aC4fi19Gpdvdm7ieC4/WnuD6QpQY/MPCzQx7IR2No2Dh6gSyJUGyc7LlDJmpewLUgudcBuuRyHHUo5dJ5PyGpZw3Q/OOtqALHktrxQG9v6ydtf6up4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o7xSkPYA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o7xSkPYA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43AF81F00A3E;
	Thu,  3 Sep 2026 17:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788458196;
	bh=Q3XMIDSMAqGpqZYnkkrZibzSa2/NhaJjnBHLtcGJDFg=;
	h=Date:To:From:Subject;
	b=o7xSkPYAyabUq8Yj+fxJTjPZpTVux9GxkG2J/17wAXbuzIugA64jL+8y63+/QXp9s
	 iwdplmGrR67Hwgwbp2pfDwK1RezBUcdNpJBcw+G+gsHr2C4hH0TwLj+UpqgJfp/fN4
	 NmpbNj1Ycd1EEfiO9Xp6/S0pLmT9mfUHIAkvpfdg=
Date: Thu, 03 Sep 2026 10:56:35 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,pfalcato@suse.de,lixinhai.lxh@gmail.com,liam@infradead.org,kunwu.chan@gmail.com,jannh@google.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mremap-reset-unfaulted-vma-page-offset-for-mremap_dontunmap.patch removed from -mm tree
Message-Id: <20260903175636.43AF81F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mremap: reset unfaulted VMA page offset for MREMAP_DONTUNMAP
has been removed from the -mm tree.  Its filename was
     mm-mremap-reset-unfaulted-vma-page-offset-for-mremap_dontunmap.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/mremap: reset unfaulted VMA page offset for MREMAP_DONTUNMAP
Date: Tue, 25 Aug 2026 08:55:26 +0100

Uniquely an mremap() invocation using the MREMAP_DONTUNMAP flag can reset
a faulted VMA into an unfaulted one.

It does so after the page tables have been moved to the copied VMA with
MREMAP_DONTUNMAP leaving the old VMA in place which is naturally unfaulted
as the page tables it had are no longer present.

However, in doing so, it violates the invariant that the anonymous page
offset of an unfaulted VMA is vma->vm_start >> PAGE_SHIFT.

This is because a VMA may have been faulted in, mremap()'d (causing a
delta between its page offset and vma->vm_start >> PAGE_SHIFT), and then
mremap()'d again with MREMAP_DONTUNMAP resulting in the unfaulting.

This condition is a violation of a fundamental assumption in mm, but now
also triggers an assert in assert_sane_pgoff() which explicitly checks for
this condition.

Correct it by resetting the VMA's page offset at the point of completing
the MREMAP_DONTUNMAP operation.

Link: https://lore.kernel.org/20260825-fix-mremap-dontunmap-pgoff-v1-1-39a40b2c98b3@kernel.org
Fixes: 1583aa278f5f ("mm: mremap: unlink anon_vmas when mremap with MREMAP_DONTUNMAP success")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reported-by: syzbot+f12658786a4153df5113@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6a87853b.ae6ddae5.3da009.0023.GAE@google.com/
Tested-by: syzbot+f12658786a4153df5113@syzkaller.appspotmail.com
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Li Xinhai <lixinhai.lxh@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

--- a/mm/mremap.c~mm-mremap-reset-unfaulted-vma-page-offset-for-mremap_dontunmap
+++ a/mm/mremap.c
@@ -1331,18 +1331,30 @@ static void dontunmap_complete(struct vm
 {
 	unsigned long start = vrm->addr;
 	unsigned long end = vrm->addr + vrm->old_len;
-	unsigned long old_start = vrm->vma->vm_start;
-	unsigned long old_end = vrm->vma->vm_end;
+	struct vm_area_struct *vma = vrm->vma;
+	unsigned long old_start = vma->vm_start;
+	unsigned long old_end = vma->vm_end;
 
 	/* We always clear VMA_LOCKED[ONFAULT]_BIT on the old VMA. */
-	vma_clear_flags_mask(vrm->vma, VMA_LOCKED_MASK);
+	vma_clear_flags_mask(vma, VMA_LOCKED_MASK);
 
 	/*
 	 * anon_vma links of the old vma is no longer needed after its page
 	 * table has been moved.
 	 */
-	if (new_vma != vrm->vma && start == old_start && end == old_end)
-		unlink_anon_vmas(vrm->vma);
+	if (new_vma != vma && start == old_start && end == old_end) {
+		const pgoff_t pgoff_unfaulted = vma->vm_start >> PAGE_SHIFT;
+
+		unlink_anon_vmas(vma);
+		/*
+		 * The VMA is now unfaulted and it is an invariant that
+		 * unfaulted anonymous VMAs have page offset equal to
+		 * vma->vm_start >> PAGE_SHIFT.
+		 */
+		vma_set_anon_pgoff(vma, pgoff_unfaulted);
+		if (vma_is_anonymous(vma) && !vma->vm_file)
+			vma_set_pgoff(vma, pgoff_unfaulted);
+	}
 
 	/* Because we won't unmap we don't need to touch locked_vm. */
 }
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-huge_memory-bypass-thp-tuneables-for-huge-pfnmap-mappings.patch
mm-mremap-account-mm-locked_vm-correctly-for-mremap_dontunmap.patch
mm-vma-correctly-unaccount-on-mmap_prepare-failure.patch
mm-vmpressure-remove-window-size-todo.patch
tools-testing-selftests-mm-add-missing-gitignore-entries.patch
mm-move-drivers-char-memc-to-mm-char-memc.patch
mm-implement-file_is_dev_zero-to-uniquely-identify-dev-zero.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch

