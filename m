Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B37B189919
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854887; cv=none; b=tayIt5gq0zaqyEM/Y+8g6116M/hAnW0ycuLhp5lzx1HpBEh0VwIHi0gJhw6ABfmThVmSoFfaznW8TpH/Wk5X2aKFFiBGUQRii0Ebgi/sLpmIQSwXBgkSujPVfUdL6lL8SvXImcXPnsmJdlp8ehAkpl++u1rKrvSmi3xudCYaj4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854887; c=relaxed/simple;
	bh=4h93tiUQfrRbDPt9esqsHn50UxN9mn0pW3+GxHi05uA=;
	h=Date:To:From:Subject:Message-Id; b=mS7m9EWyct/fAdaanYL/PWK8j7wpm6sDjAP0Gpxxcdw21V1JBxRCwfkZHc9MOU/XCv8WY2sEmi4fINVb2b92DVOl5cR+LTGZmlFdwIDX1vTzjD4llKT2n7yawrsaVBPvKPCocfQ+clTkQLWEY9beLxtT4cYiN/Q3bp9LbrgRb0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tfVkNd7u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tfVkNd7u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1617CC4CECF;
	Wed,  6 Nov 2024 01:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854887;
	bh=4h93tiUQfrRbDPt9esqsHn50UxN9mn0pW3+GxHi05uA=;
	h=Date:To:From:Subject:From;
	b=tfVkNd7u/LpePVuXaSyUKKZHOfwL/omvImAYUyPih0bX1MkdWfiSgHr6AOdQj8V5P
	 D7Saepz+0LvulT2S/uZ/vGmBkpfCIlypDuoJg4Uu/kc21VNDTewZN9f6vzbr0WR9zl
	 9ppRJtx3Zgw4bXiC1G/zL79NXuIpZqf0LBau5VzU=
Date: Tue, 05 Nov 2024 17:01:26 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,torvalds@linux-foundation.org,peterx@redhat.com,Liam.Howlett@Oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-defer-second-attempt-at-merge-on-mmap.patch removed from -mm tree
Message-Id: <20241106010127.1617CC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: defer second attempt at merge on mmap()
has been removed from the -mm tree.  Its filename was
     mm-defer-second-attempt-at-merge-on-mmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: defer second attempt at merge on mmap()
Date: Fri, 25 Oct 2024 13:26:27 +0100

Rather than trying to merge again when ostensibly allocating a new VMA,
instead defer until the VMA is added and attempt to merge the existing
range.

This way we have no complicated unwinding logic midway through the process
of mapping the VMA.

In addition this removes limitations on the VMA not being able to be the
first in the virtual memory address space which was previously implicitly
required.

In theory, for this very same reason, we should unconditionally attempt
merge here, however this is likely to have a performance impact so it is
better to avoid this given the unlikely outcome of a merge.

[lorenzo.stoakes@oracle.com: remove unnecessary indirection]
  Link: https://lkml.kernel.org/r/5106696d-e625-4d8a-8545-9d1430301730@lucifer.local
Link: https://lkml.kernel.org/r/d4f84502605d7651ac114587f507395c0fc76004.1729858176.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |   56 +++++++++++++----------------------------------------
 1 file changed, 14 insertions(+), 42 deletions(-)

--- a/mm/vma.c~mm-defer-second-attempt-at-merge-on-mmap
+++ a/mm/vma.c
@@ -19,6 +19,7 @@ struct mmap_state {
 	struct file *file;
 
 	unsigned long charged;
+	bool retry_merge;
 
 	struct vm_area_struct *prev;
 	struct vm_area_struct *next;
@@ -2278,11 +2279,11 @@ static int __mmap_prepare(struct mmap_st
 	return 0;
 }
 
+
 static int __mmap_new_file_vma(struct mmap_state *map,
-			       struct vm_area_struct **vmap, bool *mergedp)
+			       struct vm_area_struct *vma)
 {
 	struct vma_iterator *vmi = map->vmi;
-	struct vm_area_struct *vma = *vmap;
 	int error;
 
 	vma->vm_file = get_file(map->file);
@@ -2308,37 +2309,10 @@ static int __mmap_new_file_vma(struct mm
 			!(map->flags & VM_MAYWRITE) &&
 			(vma->vm_flags & VM_MAYWRITE));
 
-	/* mmap_file() might have changed VMA flags. */
+	/* If the flags change (and are mergeable), let's retry later. */
+	map->retry_merge = vma->vm_flags != map->flags && !(vma->vm_flags & VM_SPECIAL);
 	map->flags = vma->vm_flags;
 
-	vma_iter_config(vmi, map->addr, map->end);
-	/*
-	 * If flags changed after mmap_file(), we should try merge
-	 * vma again as we may succeed this time.
-	 */
-	if (unlikely(map->flags != vma->vm_flags && map->prev)) {
-		struct vm_area_struct *merge;
-		VMG_MMAP_STATE(vmg, map, /* vma = */ NULL);
-
-		merge = vma_merge_new_range(&vmg);
-		if (merge) {
-			/*
-			 * ->mmap() can change vma->vm_file and fput
-			 * the original file. So fput the vma->vm_file
-			 * here or we would add an extra fput for file
-			 * and cause general protection fault
-			 * ultimately.
-			 */
-			fput(vma->vm_file);
-			vm_area_free(vma);
-			vma = merge;
-			*mergedp = true;
-		} else {
-			vma_iter_config(vmi, map->addr, map->end);
-		}
-	}
-
-	*vmap = vma;
 	return 0;
 }
 
@@ -2346,10 +2320,6 @@ static int __mmap_new_file_vma(struct mm
  * __mmap_new_vma() - Allocate a new VMA for the region, as merging was not
  * possible.
  *
- * An exception to this is if the mapping is file-backed, and the underlying
- * driver changes the VMA flags, permitting a subsequent merge of the VMA, in
- * which case the returned VMA is one that was merged on a second attempt.
- *
  * @map:  Mapping state.
  * @vmap: Output pointer for the new VMA.
  *
@@ -2359,7 +2329,6 @@ static int __mmap_new_vma(struct mmap_st
 {
 	struct vma_iterator *vmi = map->vmi;
 	int error = 0;
-	bool merged = false;
 	struct vm_area_struct *vma;
 
 	/*
@@ -2382,7 +2351,7 @@ static int __mmap_new_vma(struct mmap_st
 	}
 
 	if (map->file)
-		error = __mmap_new_file_vma(map, &vma, &merged);
+		error = __mmap_new_file_vma(map, vma);
 	else if (map->flags & VM_SHARED)
 		error = shmem_zero_setup(vma);
 	else
@@ -2391,9 +2360,6 @@ static int __mmap_new_vma(struct mmap_st
 	if (error)
 		goto free_iter_vma;
 
-	if (merged)
-		goto file_expanded;
-
 #ifdef CONFIG_SPARC64
 	/* TODO: Fix SPARC ADI! */
 	WARN_ON_ONCE(!arch_validate_flags(map->flags));
@@ -2410,8 +2376,6 @@ static int __mmap_new_vma(struct mmap_st
 	 * call covers the non-merge case.
 	 */
 	khugepaged_enter_vma(vma, map->flags);
-
-file_expanded:
 	ksm_add_vma(vma);
 	*vmap = vma;
 	return 0;
@@ -2493,6 +2457,14 @@ unsigned long __mmap_region(struct file
 			goto unacct_error;
 	}
 
+	/* If flags changed, we might be able to merge, so try again. */
+	if (map.retry_merge) {
+		VMG_MMAP_STATE(vmg, &map, vma);
+
+		vma_iter_config(map.vmi, map.addr, map.end);
+		vma_merge_existing_range(&vmg);
+	}
+
 	__mmap_complete(&map, vma);
 
 	return addr;
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-pagewalk-add-the-ability-to-install-ptes.patch
mm-add-pte_marker_guard-pte-marker.patch
mm-madvise-implement-lightweight-guard-page-mechanism.patch
tools-testing-update-tools-uapi-header-for-mman-commonh.patch
selftests-mm-add-self-tests-for-guard-page-feature.patch
mm-remove-unnecessary-page_table_lock-on-stack-expansion.patch

