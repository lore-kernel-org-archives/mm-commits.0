Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B605478D;
	Sat,  5 Sep 2026 18:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788634092; cv=none; b=d7Psitn6zVc9txy6zM74Yi1od9tD8jpuWGcgGh72Qu/hFhKrdCQe/nn4XLXl5I7OtsANNgWm+ebz40rmBgm1ZN7kXNpJVqhR0wdbQ/OdHDB41beFH8fGgJQZSnQ/n5uvsZ6DrDdSyxNFNNXAO9TF1tM07CMWxYj8ZtnV/XztYUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788634092; c=relaxed/simple;
	bh=KBsEJnQDY4a+nrLv1oXQeMPONsp9EpSBvW1Xl5uyg2Q=;
	h=Date:To:From:Subject:Message-Id; b=rCn5JuroWFz3UUYBP9paHjjoiEPvBFOkQzmMO8G8t7kuQWLnCgJnqhRbhD3HMQL6cxm8i6EZ5enb685C38+yobU5BGIhOmKVnh44MDipX3SfbBQct9GJtWTdvSTZu0T3fsENT/bHYx8fSRTvdckg0xO2yd2Gd/qWbGA16Z/iV44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yL3vdia3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yL3vdia3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A451F00A3A;
	Sat,  5 Sep 2026 18:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788634091;
	bh=36ZwEjDgF842OsHak8WpwUeIka6ImDvOCFiua6QWSRo=;
	h=Date:To:From:Subject;
	b=yL3vdia3MSFi5Q2TPtRVgOw3j6LGQFsJkdKd9YNp2LrUOBd4JZAjN/VHLe1ZPoE+4
	 GXqfWhmYMf0o/+TdwQ8WSPY+MSxWcnbebxihMXqrMdeI7jb7Z/lk/pa+gO35/ud1Iy
	 XOSeUNxYoziWfr6xGL/2OYw9kX1IEVQWE5RTXjMg=
Date: Sat, 05 Sep 2026 11:48:10 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,sashiko-bot@kernel.org,pfalcato@suse.de,liam@infradead.org,kunwu.chan@gmail.com,jannh@google.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mremap-account-mm-locked_vm-correctly-for-mremap_dontunmap.patch removed from -mm tree
Message-Id: <20260905184811.58A451F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mremap: account mm->locked_vm correctly for MREMAP_DONTUNMAP
has been removed from the -mm tree.  Its filename was
     mm-mremap-account-mm-locked_vm-correctly-for-mremap_dontunmap.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/mremap: account mm->locked_vm correctly for MREMAP_DONTUNMAP
Date: Fri, 28 Aug 2026 12:20:37 +0100

When a VMA is mremap()'d with MREMAP_DONTUNMAP set, that results in the
VMA being copied, but the source VMA not being unmapped.

If the VMA is mlock()'d this is a legal operation, though the source VMA
has its VMA_LOCKED_BIT cleared.

However this is done in dontunmap_complete(), after mm->locked_vm was
incremented via vrm_stat_account(), resulting in double-counting.

Worse, this is not even corrected when source VMA is unmapped, due to the
VMA_LOCKED_BIT flag having been cleared.

This all works fine in the usual mremap() case (without MREMAP_DONTUNMAP),
as the source VMA is unmapped with VMA_LOCKED_BIT intact, at which time
mm->locked_vm is decremented accordingly.

Resolve the issue by invoking vrm_stat_account() only after
dontunmap_complete() has run.

Note that MREMAP_DONTUNMAP requires old_len == new_len, so no need to
account for a delta in size in this case.

The bug was introduced by commit b714ccb02a76 ("mm/mremap: complete
refactor of move_vma()") which incorrectly reordered the accounting and
the clearing of the VMA_LOCKED_BIT flag.

Link: https://lore.kernel.org/20260828-mremap-fix-locked-vm-v1-1-c80be7505d1e@kernel.org
Fixes: b714ccb02a76 ("mm/mremap: complete refactor of move_vma()")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260825-fix-mremap-dontunmap-pgoff-v1-1-39a40b2c98b3@kernel.org
Reported-by: Kunwu Chan <kunwu.chan@gmail.com>
Closes: https://lore.kernel.org/all/20260828094823.594279-1-kunwu.chan@linux.dev/
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Tested-by: Kunwu Chan <kunwu.chan@gmail.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/mremap.c~mm-mremap-account-mm-locked_vm-correctly-for-mremap_dontunmap
+++ a/mm/mremap.c
@@ -1355,12 +1355,11 @@ static void dontunmap_complete(struct vm
 		if (vma_is_anonymous(vma) && !vma->vm_file)
 			vma_set_pgoff(vma, pgoff_unfaulted);
 	}
-
-	/* Because we won't unmap we don't need to touch locked_vm. */
 }
 
 static unsigned long move_vma(struct vma_remap_struct *vrm)
 {
+	const bool is_dontunmap = vrm->flags & MREMAP_DONTUNMAP;
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *new_vma;
 	unsigned long hiwater_vm;
@@ -1401,10 +1400,10 @@ static unsigned long move_vma(struct vma
 	 */
 	hiwater_vm = mm->hiwater_vm;
 
-	vrm_stat_account(vrm, vrm->new_len);
-	if (unlikely(!err && (vrm->flags & MREMAP_DONTUNMAP)))
+	if (unlikely(is_dontunmap && !err))
 		dontunmap_complete(vrm, new_vma);
-	else
+	vrm_stat_account(vrm, vrm->new_len);
+	if (!is_dontunmap || err)
 		unmap_source_vma(vrm);
 
 	mm->hiwater_vm = hiwater_vm;
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-correctly-unaccount-on-mmap_prepare-failure.patch
mm-vmpressure-remove-window-size-todo.patch
tools-testing-selftests-mm-add-missing-gitignore-entries.patch
mm-move-drivers-char-memc-to-mm-char-memc.patch
mm-implement-file_is_dev_zero-to-uniquely-identify-dev-zero.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch

