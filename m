Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29B174040
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 02:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409671; cv=none; b=DgLxlPi+060pEs1zzDaXgF5Oy4Qq8Bb3iEGhwjbhFFzZSff/vJf+Et0LMK345B556ehEI2G4xepb9CMeZK+MNNQhYjbKdd2Hrr0J59FRuWjt8O20djYcQqILTdItIxYqXeQMTDruRz7Nxfr30JDgXL6bzZ1w0YbPb/bGGlPYtyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409671; c=relaxed/simple;
	bh=e7EcVh9XfiF0dXgwU80v2pEaO7jnSKOBqCIOvXLm4gY=;
	h=Date:To:From:Subject:Message-Id; b=dxBPLsINBT7G6sZZIHVLuMKSiShfRGKe24vLTiRZDf/8NpEcaYPOcnx+p2imQi8FJRVsh6UvqU8pzitAleWBlTLRFaXA4qK21L1362BWIfGfeSUOOEkJbMmrK3ZyWpmEtPuIWtHFi/HzyDeof6ExgkqEgmgVaYVanHWxrhV4x3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ufsT0qYp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ufsT0qYp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E281C4CEED;
	Fri, 25 Jul 2025 02:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409671;
	bh=e7EcVh9XfiF0dXgwU80v2pEaO7jnSKOBqCIOvXLm4gY=;
	h=Date:To:From:Subject:From;
	b=ufsT0qYp8w5UkOVf4Vtt5iaSnboLmfXMDGBxhjlej1zInJZBXt7h79lsOItYoYDEj
	 SzNu6uMoyw9rbZxTNf+PKHz+XPovzqOVCaKWkxPkvp3zXSmCxF2i0dplkclSFqUHko
	 GuPUwFDPJCLt5zts0AeyJL8WxDOlnNfNXw+m4tIc=
Date: Thu, 24 Jul 2025 19:14:30 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,riel@surriel.com,peterx@redhat.com,liam.howlett@oracle.com,jannh@google.com,jack@suse.cz,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mremap-clean-up-mlock-populate-behaviour.patch removed from -mm tree
Message-Id: <20250725021431.5E281C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mremap: clean up mlock populate behaviour
has been removed from the -mm tree.  Its filename was
     mm-mremap-clean-up-mlock-populate-behaviour.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/mremap: clean up mlock populate behaviour
Date: Thu, 17 Jul 2025 17:55:58 +0100

When an mlock()'d VMA is expanded, we need to populate the expanded region
to maintain the contract that all mlock()'d memory is present (albeit -
with some period after mmap unlock where the expanded part of the mapping
remains unfaulted).

The current implementation is very unclear, so make it absolutely explicit
under what circumstances we do this.

Link: https://lkml.kernel.org/r/2358b0006baa9cab83db4259817794f16fe1992e.1752770784.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/mm/mremap.c~mm-mremap-clean-up-mlock-populate-behaviour
+++ a/mm/mremap.c
@@ -65,7 +65,7 @@ struct vma_remap_struct {
 
 	/* Internal state, determined in do_mremap(). */
 	unsigned long delta;		/* Absolute delta of old_len,new_len. */
-	bool mlocked;			/* Was the VMA mlock()'d? */
+	bool populate_expand;		/* mlock()'d expanded, must populate. */
 	enum mremap_type remap_type;	/* expand, shrink, etc. */
 	bool mmap_locked;		/* Is mm currently write-locked? */
 	unsigned long charged;		/* If VM_ACCOUNT, # pages to account. */
@@ -1010,10 +1010,8 @@ static void vrm_stat_account(struct vma_
 	struct vm_area_struct *vma = vrm->vma;
 
 	vm_stat_account(mm, vma->vm_flags, pages);
-	if (vma->vm_flags & VM_LOCKED) {
+	if (vma->vm_flags & VM_LOCKED)
 		mm->locked_vm += pages;
-		vrm->mlocked = true;
-	}
 }
 
 /*
@@ -1660,6 +1658,10 @@ static int check_prep_vma(struct vma_rem
 	if (new_len == old_len)
 		return 0;
 
+	/* We are expanding and the VMA is mlock()'d so we need to populate. */
+	if (vma->vm_flags & VM_LOCKED)
+		vrm->populate_expand = true;
+
 	/* Need to be careful about a growing mapping */
 	pgoff = (addr - vma->vm_start) >> PAGE_SHIFT;
 	pgoff += vma->vm_pgoff;
@@ -1780,7 +1782,8 @@ out:
 	if (vrm->mmap_locked)
 		mmap_write_unlock(mm);
 
-	if (!failed && vrm->mlocked && vrm->new_len > vrm->old_len)
+	/* VMA mlock'd + was expanded, so populated expanded region. */
+	if (!failed && vrm->populate_expand)
 		mm_populate(vrm->new_addr + vrm->old_len, vrm->delta);
 
 	notify_uffd(vrm, failed);
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-mseal-always-define-vm_sealed.patch
mm-mseal-update-madvise-logic.patch
mm-mseal-small-cleanups.patch
mm-mseal-simplify-and-rename-vma-gap-check.patch
mm-mseal-rework-mseal-apply-logic.patch
maintainers-add-missing-percpu-internalh-file-to-per-cpu-section.patch
maintainers-add-missing-interval_treec-to-memory-mapping-section.patch
maintainers-add-missing-mm_sloth-file-thp-section.patch
maintainers-add-missing-mm_sloth-file-thp-section-fix.patch
maintainers-move-memremap-to-hotplug-section.patch
maintainers-add-missing-shrinker-files.patch
maintainers-add-missing-files-to-page-alloc-section.patch
maintainers-add-missing-zsmalloc-file.patch
maintainers-add-mm-misc-section-add-missing-files-to-misc-and-core.patch
maintainers-add-missing-file-to-cgroup-section.patch

