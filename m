Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E43F5258
	for <mm-commits@vger.kernel.org>; Sat, 12 Jul 2025 22:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752360914; cv=none; b=TJTgUdWw2fgKVfGJ+PeS+i62gbdaDuFGVSWMZLgdOb5BsFTDs5MbUj4z/O1uhaLRr1cF412504SzAl9JcM9rnoGmQPuIpZOluk3OG8H6wwLtZqBch/KxwR3I/uRFVfZWdybOZtpcjs9q8Af62MEH1MC7TF/XmiHVNosiDK4eS88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752360914; c=relaxed/simple;
	bh=jnvvqDLF57G84FuSlKpZ2dZGJMuqwWKz9gvffJdvdqk=;
	h=Date:To:From:Subject:Message-Id; b=tsxA/dBQqAE4zEBTFDp4YjltD40u11ZofdtHOilKW9S/KqrPRB/Bt9zF/tGfnetAjgaQWOzQbBY3bAYsnE197YUBs5fgVsAdY2o3oNLfd+udQFj8O4iE21sC7iip4kGZfkRdfsVwnOmuDqOKwQ+JlE60TmIeV9cIA9YZFuk+gds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yeNrO81s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yeNrO81s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265AFC4CEEF;
	Sat, 12 Jul 2025 22:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752360914;
	bh=jnvvqDLF57G84FuSlKpZ2dZGJMuqwWKz9gvffJdvdqk=;
	h=Date:To:From:Subject:From;
	b=yeNrO81sl1YF31R3QYyAu5C150uUiP21seOAEjjzPxX+7cnEZJ0EeVeBA62kvK4Zp
	 wtTTXYIDfokj4nCVawdMvhxqtG60dEGzV9lW7to2PCGvZck4mLtdEA69quuGFDsrKX
	 /k0pfSGH1ttA6BCy0F+GRrh13OMJSNzzVrzwGM6g=
Date: Sat, 12 Jul 2025 15:55:13 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,riel@surriel.com,peterx@redhat.com,liam.howlett@oracle.com,jannh@google.com,jack@suse.cz,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-permit-mremap-move-of-multiple-vmas-fix.patch added to mm-unstable branch
Message-Id: <20250712225514.265AFC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mremap: address review comments
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mremap-permit-mremap-move-of-multiple-vmas-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-permit-mremap-move-of-multiple-vmas-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/mremap: address review comments
Date: Fri, 11 Jul 2025 15:06:06 +0100

Make seen_vma a local variable, and add a comment when vmi_needs_reset is
set to explain what it's for.

Link: https://lkml.kernel.org/r/e5a58805-e621-4628-b78d-f5d6e4b6334c@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/mremap.c~mm-mremap-permit-mremap-move-of-multiple-vmas-fix
+++ a/mm/mremap.c
@@ -69,7 +69,6 @@ struct vma_remap_struct {
 	enum mremap_type remap_type;	/* expand, shrink, etc. */
 	bool mmap_locked;		/* Is mm currently write-locked? */
 	unsigned long charged;		/* If VM_ACCOUNT, # pages to account. */
-	bool seen_vma;			/* Is >1 VMA being moved? */
 	bool vmi_needs_reset;		/* Was the VMA iterator invalidated? */
 };
 
@@ -1188,6 +1187,7 @@ static int copy_vma_and_data(struct vma_
 		*new_vma_ptr = NULL;
 		return -ENOMEM;
 	}
+	/* By merging, we may have invalidated any iterator in use. */
 	if (vma != vrm->vma)
 		vrm->vmi_needs_reset = true;
 
@@ -1805,10 +1805,10 @@ static unsigned long remap_move(struct v
 	unsigned long start = vrm->addr;
 	unsigned long end = vrm->addr + vrm->old_len;
 	unsigned long new_addr = vrm->new_addr;
+	bool allowed = true, seen_vma = false;
 	unsigned long target_addr = new_addr;
 	unsigned long res = -EFAULT;
 	unsigned long last_end;
-	bool allowed = true;
 	VMA_ITERATOR(vmi, current->mm, start);
 
 	/*
@@ -1826,7 +1826,7 @@ static unsigned long remap_move(struct v
 			return -EFAULT;
 
 		/* No gap permitted at the start of the range. */
-		if (!vrm->seen_vma && start < vma->vm_start)
+		if (!seen_vma && start < vma->vm_start)
 			return -EFAULT;
 
 		/*
@@ -1844,7 +1844,7 @@ static unsigned long remap_move(struct v
 		 *
 		 * So we map B' at A'->vm_end + X, and C' at B'->vm_end + Y.
 		 */
-		offset = vrm->seen_vma ? vma->vm_start - last_end : 0;
+		offset = seen_vma ? vma->vm_start - last_end : 0;
 		last_end = vma->vm_end;
 
 		vrm->vma = vma;
@@ -1853,7 +1853,7 @@ static unsigned long remap_move(struct v
 		vrm->old_len = vrm->new_len = len;
 
 		allowed = vma_multi_allowed(vma);
-		if (vrm->seen_vma && !allowed)
+		if (seen_vma && !allowed)
 			return -EFAULT;
 
 		res_vma = check_prep_vma(vrm);
@@ -1862,7 +1862,7 @@ static unsigned long remap_move(struct v
 		if (IS_ERR_VALUE(res_vma))
 			return res_vma;
 
-		if (!vrm->seen_vma) {
+		if (!seen_vma) {
 			VM_WARN_ON_ONCE(allowed && res_vma != new_addr);
 			res = res_vma;
 		}
@@ -1876,7 +1876,7 @@ static unsigned long remap_move(struct v
 			vma_iter_reset(&vmi);
 			vrm->vmi_needs_reset = false;
 		}
-		vrm->seen_vma = true;
+		seen_vma = true;
 		target_addr = res_vma + vrm->new_len;
 	}
 
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-madvise-remove-the-visitor-pattern-and-thread-anon_vma-state.patch
mm-madvise-thread-mm_struct-through-madvise_behavior.patch
mm-madvise-thread-vma-range-state-through-madvise_behavior.patch
mm-madvise-thread-all-madvise-state-through-madv_behavior.patch
mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma.patch
mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma-fix.patch
tools-testing-selftests-add-mremap-unfaulted-faulted-test-cases.patch
mm-mremap-perform-some-simple-cleanups.patch
mm-mremap-refactor-initial-parameter-sanity-checks.patch
mm-mremap-put-vma-check-and-prep-logic-into-helper-function.patch
mm-mremap-cleanup-post-processing-stage-of-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap.patch
mm-mremap-check-remap-conditions-earlier.patch
mm-mremap-move-remap_is_valid-into-check_prep_vma.patch
mm-mremap-clean-up-mlock-populate-behaviour.patch
mm-mremap-permit-mremap-move-of-multiple-vmas.patch
mm-mremap-permit-mremap-move-of-multiple-vmas-fix.patch
tools-testing-selftests-extend-mremap_test-to-test-multi-vma-mremap.patch

