Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4ED290F
	for <mm-commits@vger.kernel.org>; Mon,  4 Nov 2024 04:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730696172; cv=none; b=ezxW+57C8kotGAcggpNcUxak9USf4S0PHVKYsLmuayNjLeRP1QOlhM2LUS3cBhZ75Xklup/tsD1doyat2x6e6q1PvncKBTpy/VXaTEXZy5bEV3JgXdhaZO2r+3QW1Rewr62a3QmC/rYwJ2OicwISypkiJD0IQM63QDfD4lIxVhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730696172; c=relaxed/simple;
	bh=YyOVoGJwgZuELmdlCbXYMQD/oP+skLBQ5LgTdM1R8yU=;
	h=Date:To:From:Subject:Message-Id; b=Oyj0UiLbBEs/P47uZXOcQ9WXQiwN5xl9B6SavHzYRVjUdDtOKQ/FBath2rBXqeQWb6rfODhtuaeq08lHjdvjZq/8XjHE52qSc0BwXvJqy52tKpLFIpZLhZjGOZDLvkYt0WXyxxE9Mj9sHNhZYxn3FUwzw2hMA9R8N4tdGWD6elI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xu1tYvnP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xu1tYvnP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B47E9C4CECE;
	Mon,  4 Nov 2024 04:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730696171;
	bh=YyOVoGJwgZuELmdlCbXYMQD/oP+skLBQ5LgTdM1R8yU=;
	h=Date:To:From:Subject:From;
	b=Xu1tYvnPsY+FG1StwwcoYYthYduXTOMYoKL8DJuhpOKJPcywkGSk/kvmWYuwMbbnc
	 iBojZM//qhS/jX+bxRDuoXYMYLn6afLd8odCnjn0GFU1URXHn2RX3v5hmLnZJ/tA4b
	 Ejn6ooreafciyl4bK0piBZznSiT6hhE6aTkW8sUg=
Date: Sun, 03 Nov 2024 20:56:11 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,torvalds@linux-foundation.org,peterx@redhat.com,Liam.Howlett@Oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-defer-second-attempt-at-merge-on-mmap-fix.patch removed from -mm tree
Message-Id: <20241104045611.B47E9C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove unnecessary indirection
has been removed from the -mm tree.  Its filename was
     mm-defer-second-attempt-at-merge-on-mmap-fix.patch

This patch was dropped because it was folded into mm-defer-second-attempt-at-merge-on-mmap.patch

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: remove unnecessary indirection
Date: Sat, 26 Oct 2024 11:33:01 +0100

Now we removed the merge logic from __mmap_new_file_vma() we can simply
pass in the vma direct rather than a pointer to a VMA, as pointed out by
Vlastimil.

Link: https://lkml.kernel.org/r/5106696d-e625-4d8a-8545-9d1430301730@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/vma.c~mm-defer-second-attempt-at-merge-on-mmap-fix
+++ a/mm/vma.c
@@ -2281,10 +2281,9 @@ static int __mmap_prepare(struct mmap_st
 
 
 static int __mmap_new_file_vma(struct mmap_state *map,
-			       struct vm_area_struct **vmap)
+			       struct vm_area_struct *vma)
 {
 	struct vma_iterator *vmi = map->vmi;
-	struct vm_area_struct *vma = *vmap;
 	int error;
 
 	vma->vm_file = get_file(map->file);
@@ -2352,7 +2351,7 @@ static int __mmap_new_vma(struct mmap_st
 	}
 
 	if (map->file)
-		error = __mmap_new_file_vma(map, &vma);
+		error = __mmap_new_file_vma(map, vma);
 	else if (map->flags & VM_SHARED)
 		error = shmem_zero_setup(vma);
 	else
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-avoid-unsafe-vma-hook-invocation-when-error-arises-on-mmap-hook.patch
mm-unconditionally-close-vmas-on-error.patch
mm-refactor-map_deny_write_exec.patch
mm-refactor-arch_calc_vm_flag_bits-and-arm64-mte-handling.patch
mm-resolve-faulty-mmap_region-error-path-behaviour.patch
selftests-mm-add-pkey_sighandler_xx-hugetlb_dio-to-gitignore.patch
mm-refactor-mm_access-to-not-return-null.patch
mm-madvise-unrestrict-process_madvise-for-current-process.patch
maple_tree-do-not-hash-pointers-on-dump-in-debug-mode.patch
tools-testing-fix-phys_addr_t-size-on-64-bit-systems.patch
tools-testing-add-additional-vma_internalh-stubs.patch
mm-isolate-mmap-internal-logic-to-mm-vmac.patch
mm-refactor-__mmap_region.patch
mm-remove-unnecessary-reset-state-logic-on-merge-new-vma.patch
mm-defer-second-attempt-at-merge-on-mmap.patch
mm-pagewalk-add-the-ability-to-install-ptes.patch
mm-add-pte_marker_guard-pte-marker.patch
mm-madvise-implement-lightweight-guard-page-mechanism.patch
tools-testing-update-tools-uapi-header-for-mman-commonh.patch
selftests-mm-add-self-tests-for-guard-page-feature.patch
mm-remove-unnecessary-page_table_lock-on-stack-expansion.patch

