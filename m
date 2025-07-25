Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB8D213237
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 02:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409667; cv=none; b=Zx4QPQvbiwJAzXakBe/TmITxGTpK9z/BzpAcApWfcAnDSR68eGhUcevV5bpTR21N87moMV0JAG9kavkmukisxwE+3kMhH9ZU+OhcfM7UpT7SUfV/UmRgOhXvktFVJKkyhu2ivSljGpIgDw3b8z/BoMdX5ZfhH+lNMfBLoY5/zsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409667; c=relaxed/simple;
	bh=BRMsL8cmz3efrU8QN5vX+4yyWfu0DSzEBhBXRY5GtEA=;
	h=Date:To:From:Subject:Message-Id; b=d7cFwvTBmRvWMsKCQ75e8Bl1ZgwnOXqlzn9dJQhBXA5T41VzK3S5fxulZi/xJ3ZsfrUWYzwBhakjWbFHsFuuovSHrXbcCQ1taxP5ZADiF1zoA07kPidSSooX4t0AbeYHZfBqbsKr7NDny6vlGvaTxHhjLqrweiNEIKjvsclcHmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f/lBcbTH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f/lBcbTH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48A6C4CEED;
	Fri, 25 Jul 2025 02:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409666;
	bh=BRMsL8cmz3efrU8QN5vX+4yyWfu0DSzEBhBXRY5GtEA=;
	h=Date:To:From:Subject:From;
	b=f/lBcbTHm9ciMubqymZkvGz6fPoVLd7hEzO4rkSPQEfunZm9plbG3xq5NxXZe4UJo
	 0IY8O8fZYl9wweQenBloGiBUQRmINfBP/g2/zUZO5dUoN9c948R6wQyF5v5S7zHGbE
	 5nHlBD/IDdNp9UhcBftPs9E23Ag/7GybiUHISv78=
Date: Thu, 24 Jul 2025 19:14:26 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,riel@surriel.com,peterx@redhat.com,liam.howlett@oracle.com,jannh@google.com,jack@suse.cz,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mremap-check-remap-conditions-earlier.patch removed from -mm tree
Message-Id: <20250725021426.D48A6C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mremap: check remap conditions earlier
has been removed from the -mm tree.  Its filename was
     mm-mremap-check-remap-conditions-earlier.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/mremap: check remap conditions earlier
Date: Thu, 17 Jul 2025 17:55:56 +0100

When we expand or move a VMA, this requires a number of additional checks
to be performed.

Make it really obvious under what circumstances these checks must be
performed and aggregate all the checks in one place by invoking this in
check_prep_vma().

We have to adjust the checks to account for shrink + move operations by
checking new_len <= old_len rather than new_len == old_len.

No functional change intended.

[lorenzo.stoakes@oracle.com: allow undocumented mremap() shrink behaviour]
  Link: https://lkml.kernel.org/r/8fc92a38-c636-465e-9a2f-2c6ac9cb49b8@lucifer.local
Link: https://lkml.kernel.org/r/8b4161ce074901e00602a446d81f182db92b0430.1752770784.git.lorenzo.stoakes@oracle.com
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

 mm/mremap.c |   33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

--- a/mm/mremap.c~mm-mremap-check-remap-conditions-earlier
+++ a/mm/mremap.c
@@ -1339,6 +1339,13 @@ static int remap_is_valid(struct vma_rem
 			(vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP)))
 		return -EINVAL;
 
+	/*
+	 * We permit crossing of boundaries for the range being unmapped due to
+	 * a shrink.
+	 */
+	if (vrm->remap_type == MREMAP_SHRINK)
+		old_len = new_len;
+
 	/* We can't remap across vm area boundaries */
 	if (old_len > vma->vm_end - addr)
 		return -EFAULT;
@@ -1443,10 +1450,6 @@ static unsigned long mremap_to(struct vm
 		vrm->old_len = vrm->new_len;
 	}
 
-	err = remap_is_valid(vrm);
-	if (err)
-		return err;
-
 	/* MREMAP_DONTUNMAP expands by old_len since old_len == new_len */
 	if (vrm->flags & MREMAP_DONTUNMAP) {
 		vm_flags_t vm_flags = vrm->vma->vm_flags;
@@ -1635,10 +1638,6 @@ static unsigned long expand_vma(struct v
 {
 	unsigned long err;
 
-	err = remap_is_valid(vrm);
-	if (err)
-		return err;
-
 	/*
 	 * [addr, old_len) spans precisely to the end of the VMA, so try to
 	 * expand it in-place.
@@ -1705,6 +1704,21 @@ static unsigned long mremap_at(struct vm
 	return -EINVAL;
 }
 
+/*
+ * Will this operation result in the VMA being expanded or moved and thus need
+ * to map a new portion of virtual address space?
+ */
+static bool vrm_will_map_new(struct vma_remap_struct *vrm)
+{
+	if (vrm->remap_type == MREMAP_EXPAND)
+		return true;
+
+	if (vrm_implies_new_addr(vrm))
+		return true;
+
+	return false;
+}
+
 static int check_prep_vma(struct vma_remap_struct *vrm)
 {
 	struct vm_area_struct *vma = vrm->vma;
@@ -1726,6 +1740,9 @@ static int check_prep_vma(struct vma_rem
 	if (!vrm_implies_new_addr(vrm))
 		vrm->new_addr = vrm->addr;
 
+	if (vrm_will_map_new(vrm))
+		return remap_is_valid(vrm);
+
 	return 0;
 }
 
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

