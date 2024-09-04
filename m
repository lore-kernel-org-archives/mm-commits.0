Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38D076F1B
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423510; cv=none; b=ryoVtOjMmT3edOYn8g82mU6lL6E60f9Budoc/UvRqYt8noLrjll253ZSZoku4SGiBHc+I5EsDBtdF5RWSel/EmGcMQUVHtSWU76R5bW6rbVPzPI2zyct0gslV1Gua/c2iuOUyFK1yXP3xZjKrQLDQOxbYZgJgM383z5y9qiZJUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423510; c=relaxed/simple;
	bh=3DdhJUhzytw0t/S7T+Idw4oe2zFlYCYAJ+FZWKcZiVk=;
	h=Date:To:From:Subject:Message-Id; b=gVuOxyDfLsVlfc1MvOIkDP6FfPNBQ7TtwcHAv8qzwoH5Ji7KXMJG7xoSfIP8x+QR0Z+y2VaIMeGEEZIZr1F2JCMCbF08y5aMZAst8YGcQoSLoWdtuNLLoS0dMsVK68ddoz7QwMAZjIjZIkNUf9aIpgKB99L/S5vJNLT51jh7z3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B8Pqr1E1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B8Pqr1E1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B52C4CEC2;
	Wed,  4 Sep 2024 04:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423510;
	bh=3DdhJUhzytw0t/S7T+Idw4oe2zFlYCYAJ+FZWKcZiVk=;
	h=Date:To:From:Subject:From;
	b=B8Pqr1E1Q6x9SmxJ56jgLHYsAu8tdHAhDDmaYSAzMr9FwhJltreJna+4wVAJwzq8B
	 +vt5lN5AoNLTzPHZIQJduwyUnbO2luZFW9FW44J8QkrPylrm9iO4BrxnutmT8vDZBS
	 85C0lDRK8zXeGzAs4cMyRLcKllZzEgfdcccbDhmA=
Date: Tue, 03 Sep 2024 21:18:30 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,torvalds@linux-foundation.org,shuah@kernel.org,mpe@ellerman.id.au,Liam.Howlett@Oracle.com,kees@kernel.org,jeffxu@chromium.org,pedro.falcato@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-munmap-replace-can_modify_mm-with-can_modify_vma.patch removed from -mm tree
Message-Id: <20240904041830.95B52C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/munmap: replace can_modify_mm with can_modify_vma
has been removed from the -mm tree.  Its filename was
     mm-munmap-replace-can_modify_mm-with-can_modify_vma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pedro Falcato <pedro.falcato@gmail.com>
Subject: mm/munmap: replace can_modify_mm with can_modify_vma
Date: Sat, 17 Aug 2024 01:18:29 +0100

We were doing an extra mmap tree traversal just to check if the entire
range is modifiable.  This can be done when we iterate through the VMAs
instead.

Link: https://lkml.kernel.org/r/20240817-mseal-depessimize-v3-2-d8d2e037df30@gmail.com
Signed-off-by: Pedro Falcato <pedro.falcato@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
LGTM, Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   11 +----------
 mm/vma.c  |   19 ++++++++++++-------
 2 files changed, 13 insertions(+), 17 deletions(-)

--- a/mm/mmap.c~mm-munmap-replace-can_modify_mm-with-can_modify_vma
+++ a/mm/mmap.c
@@ -1740,16 +1740,7 @@ int do_vma_munmap(struct vma_iterator *v
 		unsigned long start, unsigned long end, struct list_head *uf,
 		bool unlock)
 {
-	struct mm_struct *mm = vma->vm_mm;
-
-	/*
-	 * Check if memory is sealed, prevent unmapping a sealed VMA.
-	 * can_modify_mm assumes we have acquired the lock on MM.
-	 */
-	if (unlikely(!can_modify_mm(mm, start, end)))
-		return -EPERM;
-
-	return do_vmi_align_munmap(vmi, vma, mm, start, end, uf, unlock);
+	return do_vmi_align_munmap(vmi, vma, vma->vm_mm, start, end, uf, unlock);
 }
 
 /*
--- a/mm/vma.c~mm-munmap-replace-can_modify_mm-with-can_modify_vma
+++ a/mm/vma.c
@@ -712,6 +712,12 @@ do_vmi_align_munmap(struct vma_iterator
 		if (end < vma->vm_end && mm->map_count >= sysctl_max_map_count)
 			goto map_count_exceeded;
 
+		/* Don't bother splitting the VMA if we can't unmap it anyway */
+		if (!can_modify_vma(vma)) {
+			error = -EPERM;
+			goto start_split_failed;
+		}
+
 		error = __split_vma(vmi, vma, start, 1);
 		if (error)
 			goto start_split_failed;
@@ -723,6 +729,11 @@ do_vmi_align_munmap(struct vma_iterator
 	 */
 	next = vma;
 	do {
+		if (!can_modify_vma(next)) {
+			error = -EPERM;
+			goto modify_vma_failed;
+		}
+
 		/* Does it split the end? */
 		if (next->vm_end > end) {
 			error = __split_vma(vmi, next, end, 0);
@@ -815,6 +826,7 @@ do_vmi_align_munmap(struct vma_iterator
 	__mt_destroy(&mt_detach);
 	return 0;
 
+modify_vma_failed:
 clear_tree_failed:
 userfaultfd_error:
 munmap_gather_failed:
@@ -860,13 +872,6 @@ int do_vmi_munmap(struct vma_iterator *v
 	if (end == start)
 		return -EINVAL;
 
-	/*
-	 * Check if memory is sealed, prevent unmapping a sealed VMA.
-	 * can_modify_mm assumes we have acquired the lock on MM.
-	 */
-	if (unlikely(!can_modify_mm(mm, start, end)))
-		return -EPERM;
-
 	/* Find the first overlapping VMA */
 	vma = vma_find(vmi, end);
 	if (!vma) {
_

Patches currently in -mm which might be from pedro.falcato@gmail.com are


