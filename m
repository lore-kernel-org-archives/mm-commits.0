Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0897A210F65
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 02:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409661; cv=none; b=NKJ8y1j+BWFUw5BhfmOpxgEhgOqWQpPXHh62QgUKZ+TokH9YINMyzrz/HoVpkObtMeovXdVRgYPPY2bQTAKgCluUmWmUyB6JpheDk9TQleDqaonL0jmgvZNJGA5b7wP6qzsy93Zdj2YFw6C9/aVXo7pii5tBzQEJ7j+dE74bKrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409661; c=relaxed/simple;
	bh=XiLpHb7U9TN1gYJoxVPmUlaijzzf0t3++cZyY6s0C8Q=;
	h=Date:To:From:Subject:Message-Id; b=kmlLRtrNYfKvTNY6yCe61s7twvGKH7f2HzGTS/V+paPEdZXKZQzA23NgMZ71rbSpnyaZ5YKM8mjH9NZRDhLqq+FHLOdEJC3VPvHHbyThk/cE5Bo1YlDbB9/szNBa74HMaVREHq8Vy+FoGss9rE4SWKZxTkSE3wU0uRaWk3Z9Gi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s+1gGZ8t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s+1gGZ8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9681C4CEEF;
	Fri, 25 Jul 2025 02:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409660;
	bh=XiLpHb7U9TN1gYJoxVPmUlaijzzf0t3++cZyY6s0C8Q=;
	h=Date:To:From:Subject:From;
	b=s+1gGZ8tn0IGLe7+u1nS58q1bhtSnEtIVwV4etb+DdYme1raY84DxCCJYRvmsujtu
	 PVEUURanGAWNm/Rcm18QSiHuhAfc8xZc+d9DjdKBiycbGv2TXIU7cShBeS9RJAPWQu
	 OZUrgh5JcX70yQ5s3rOxtd0BRxZMeGiFsOfqaBoY=
Date: Thu, 24 Jul 2025 19:14:20 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,riel@surriel.com,peterx@redhat.com,liam.howlett@oracle.com,jannh@google.com,jack@suse.cz,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mremap-refactor-initial-parameter-sanity-checks.patch removed from -mm tree
Message-Id: <20250725021420.C9681C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mremap: refactor initial parameter sanity checks
has been removed from the -mm tree.  Its filename was
     mm-mremap-refactor-initial-parameter-sanity-checks.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/mremap: refactor initial parameter sanity checks
Date: Thu, 17 Jul 2025 17:55:52 +0100

We are currently checking some things later, and some things immediately. 
Aggregate the checks and avoid ones that need not be made.

Simplify things by aligning lengths immediately.  Defer setting the delta
parameter until later, which removes some duplicate code in the hugetlb
case.

We can safely perform the checks moved from mremap_to() to
check_mremap_params() because:

* If we set a new address via vrm_set_new_addr(), then this is guaranteed
  to not overlap nor to position the new VMA past TASK_SIZE, so there's no
  need to check these later.

* We can simply page align lengths immediately. We do not need to check for
  overlap nor TASK_SIZE sanity after hugetlb alignment as this asserts
  addresses are huge-aligned, then huge-aligns lengths, rounding down. This
  means any existing overlap would have already been caught.

Moving things around like this lays the groundwork for subsequent changes
to permit operations on batches of VMAs.

No functional change intended.

Link: https://lkml.kernel.org/r/c862d625c98b1abd861c406f2bfad8baf3287f83.1752770784.git.lorenzo.stoakes@oracle.com
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

 mm/mremap.c |   29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

--- a/mm/mremap.c~mm-mremap-refactor-initial-parameter-sanity-checks
+++ a/mm/mremap.c
@@ -1413,14 +1413,6 @@ static unsigned long mremap_to(struct vm
 	struct mm_struct *mm = current->mm;
 	unsigned long err;
 
-	/* Is the new length or address silly? */
-	if (vrm->new_len > TASK_SIZE ||
-	    vrm->new_addr > TASK_SIZE - vrm->new_len)
-		return -EINVAL;
-
-	if (vrm_overlaps(vrm))
-		return -EINVAL;
-
 	if (vrm->flags & MREMAP_FIXED) {
 		/*
 		 * In mremap_to().
@@ -1525,7 +1517,12 @@ static unsigned long check_mremap_params
 	 * for DOS-emu "duplicate shm area" thing. But
 	 * a zero new-len is nonsensical.
 	 */
-	if (!PAGE_ALIGN(vrm->new_len))
+	if (!vrm->new_len)
+		return -EINVAL;
+
+	/* Is the new length or address silly? */
+	if (vrm->new_len > TASK_SIZE ||
+	    vrm->new_addr > TASK_SIZE - vrm->new_len)
 		return -EINVAL;
 
 	/* Remainder of checks are for cases with specific new_addr. */
@@ -1544,6 +1541,10 @@ static unsigned long check_mremap_params
 	if (flags & MREMAP_DONTUNMAP && vrm->old_len != vrm->new_len)
 		return -EINVAL;
 
+	/* Target VMA must not overlap source VMA. */
+	if (vrm_overlaps(vrm))
+		return -EINVAL;
+
 	/*
 	 * move_vma() need us to stay 4 maps below the threshold, otherwise
 	 * it will bail out at the very beginning.
@@ -1620,8 +1621,6 @@ static bool align_hugetlb(struct vma_rem
 	if (vrm->new_len > vrm->old_len)
 		return false;
 
-	vrm_set_delta(vrm);
-
 	return true;
 }
 
@@ -1721,14 +1720,13 @@ static unsigned long do_mremap(struct vm
 	struct vm_area_struct *vma;
 	unsigned long res;
 
+	vrm->old_len = PAGE_ALIGN(vrm->old_len);
+	vrm->new_len = PAGE_ALIGN(vrm->new_len);
+
 	res = check_mremap_params(vrm);
 	if (res)
 		return res;
 
-	vrm->old_len = PAGE_ALIGN(vrm->old_len);
-	vrm->new_len = PAGE_ALIGN(vrm->new_len);
-	vrm_set_delta(vrm);
-
 	if (mmap_write_lock_killable(mm))
 		return -EINTR;
 	vrm->mmap_locked = true;
@@ -1751,6 +1749,7 @@ static unsigned long do_mremap(struct vm
 		goto out;
 	}
 
+	vrm_set_delta(vrm);
 	vrm->remap_type = vrm_remap_type(vrm);
 
 	/* Actually execute mremap. */
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

