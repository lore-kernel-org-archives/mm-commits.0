Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BDB3611E
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957127; cv=none; b=Xy9KXm9Y2EmS4dzlvr4B1eHB5iSIhnQM4vj2Pj9rowyJHgl/wEF0kKgMc061QunKk+/jD1VelGYSOoNbieDmBv4Z92+VWlwbs0gUVWu/f2bx/XnAVKCh+HszkerBTLCGs4PnrqTD7hq1Ogryj11SZ8rvdIyPPTCisSvT7YsRIQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957127; c=relaxed/simple;
	bh=roO8kJlrz81mnJ2Uiuy8Uz9fvY0FqUng9eP+2QrZl7U=;
	h=Date:To:From:Subject:Message-Id; b=Zf2yxDIOdLYoRBpUwUkEyWGJWwp4odcslmQjHpA7r834Zpj+NzMP+3bb7wqH8AnDNhIYIiZseD2D8U2VlHsPWwHS0R0oQmQmIX0QSccoGmFgE3vCCFateP61pftZ5XnnkdkHhsIBPYpEqBwqPjkPNZIF6eFJPdMRwbLBP7Qaonk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sPuvJzM0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sPuvJzM0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D7EC116B1;
	Mon,  6 May 2024 00:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957127;
	bh=roO8kJlrz81mnJ2Uiuy8Uz9fvY0FqUng9eP+2QrZl7U=;
	h=Date:To:From:Subject:From;
	b=sPuvJzM05nKXeilE6WItleSTDR2VbtuskA2y4MPooe1KwenLS1g81ASLMTjykODvy
	 W4swBMWBPMyXcEd5oZvpZMDlYYtG5auXFz7osAXPOBCXIhwRbUFE6GJWh8DpzsPEp5
	 JYAPhJkvtvJB0vV6yxpkjAyg3/TzEq2Ixz7cCK0M=
Date: Sun, 05 May 2024 17:58:46 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,jannh@google.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fix-some-minor-per-vma-lock-issues-in-userfaultfd.patch removed from -mm tree
Message-Id: <20240506005847.72D7EC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix some minor per-VMA lock issues in userfaultfd
has been removed from the -mm tree.  Its filename was
     mm-fix-some-minor-per-vma-lock-issues-in-userfaultfd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: fix some minor per-VMA lock issues in userfaultfd
Date: Fri, 26 Apr 2024 15:45:02 +0100

Rename lock_vma() to uffd_lock_vma() because it really is uffd specific. 
Remove comment referencing unlock_vma() which doesn't exist.  Fix the
comment about lock_vma_under_rcu() which I just made incorrect.

Link: https://lkml.kernel.org/r/20240426144506.1290619-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--- a/mm/userfaultfd.c~mm-fix-some-minor-per-vma-lock-issues-in-userfaultfd
+++ a/mm/userfaultfd.c
@@ -56,17 +56,16 @@ struct vm_area_struct *find_vma_and_prep
 
 #ifdef CONFIG_PER_VMA_LOCK
 /*
- * lock_vma() - Lookup and lock vma corresponding to @address.
+ * uffd_lock_vma() - Lookup and lock vma corresponding to @address.
  * @mm: mm to search vma in.
  * @address: address that the vma should contain.
  *
- * Should be called without holding mmap_lock. vma should be unlocked after use
- * with unlock_vma().
+ * Should be called without holding mmap_lock.
  *
  * Return: A locked vma containing @address, -ENOENT if no vma is found, or
  * -ENOMEM if anon_vma couldn't be allocated.
  */
-static struct vm_area_struct *lock_vma(struct mm_struct *mm,
+static struct vm_area_struct *uffd_lock_vma(struct mm_struct *mm,
 				       unsigned long address)
 {
 	struct vm_area_struct *vma;
@@ -74,9 +73,8 @@ static struct vm_area_struct *lock_vma(s
 	vma = lock_vma_under_rcu(mm, address);
 	if (vma) {
 		/*
-		 * lock_vma_under_rcu() only checks anon_vma for private
-		 * anonymous mappings. But we need to ensure it is assigned in
-		 * private file-backed vmas as well.
+		 * We know we're going to need to use anon_vma, so check
+		 * that early.
 		 */
 		if (!(vma->vm_flags & VM_SHARED) && unlikely(!vma->anon_vma))
 			vma_end_read(vma);
@@ -107,7 +105,7 @@ static struct vm_area_struct *uffd_mfill
 {
 	struct vm_area_struct *dst_vma;
 
-	dst_vma = lock_vma(dst_mm, dst_start);
+	dst_vma = uffd_lock_vma(dst_mm, dst_start);
 	if (IS_ERR(dst_vma) || validate_dst_vma(dst_vma, dst_start + len))
 		return dst_vma;
 
@@ -1401,7 +1399,7 @@ static int uffd_move_lock(struct mm_stru
 	struct vm_area_struct *vma;
 	int err;
 
-	vma = lock_vma(mm, dst_start);
+	vma = uffd_lock_vma(mm, dst_start);
 	if (IS_ERR(vma))
 		return PTR_ERR(vma);
 
@@ -1416,7 +1414,7 @@ static int uffd_move_lock(struct mm_stru
 	}
 
 	/*
-	 * Using lock_vma() to get src_vma can lead to following deadlock:
+	 * Using uffd_lock_vma() to get src_vma can lead to following deadlock:
 	 *
 	 * Thread1				Thread2
 	 * -------				-------
@@ -1438,7 +1436,7 @@ static int uffd_move_lock(struct mm_stru
 	err = find_vmas_mm_locked(mm, dst_start, src_start, dst_vmap, src_vmap);
 	if (!err) {
 		/*
-		 * See comment in lock_vma() as to why not using
+		 * See comment in uffd_lock_vma() as to why not using
 		 * vma_start_read() here.
 		 */
 		down_read(&(*dst_vmap)->vm_lock->lock);
_

Patches currently in -mm which might be from willy@infradead.org are

squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch
squashfs-remove-calls-to-set-the-folio-error-flag.patch
nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch

