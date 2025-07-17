Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A9513B58A
	for <mm-commits@vger.kernel.org>; Thu, 17 Jul 2025 21:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752788145; cv=none; b=MzRP9W5/9bipo2Tgp+TDZh0JwtPHLFGVrx1oDg3L5UeTxKZsJKk7Im29EkYaluwNw2shlBbTkDYsh1u6hiwK5dHIzFKkmbn/dmIz+ybSS7LjjKnbAHB/AckeuyuKz+0lQi38nyuRhdlcN9NBFW/fxITESmW67BbN4KQWfEn7lok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752788145; c=relaxed/simple;
	bh=H7wqQ4eo+m5UKYUhGsYphmKyGJ6NhDq+4lx/h+PsY6w=;
	h=Date:To:From:Subject:Message-Id; b=mRwc9YD+owruFNh1LKGnPucHJeri3KM1QuBoIllUUfY0BjhWbmiFfCm0KCDdDOu5+EiuwHbf774mLsk1IokFqujaSE267sDtkznnLwGGELPPrtXoos7UdBoZN8zzW4/ijeIcaisVmD5xK1LCsE5QoL0x/jl65eXhGqnRnH4cDNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jr6P+M1h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jr6P+M1h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C326C4CEE3;
	Thu, 17 Jul 2025 21:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752788145;
	bh=H7wqQ4eo+m5UKYUhGsYphmKyGJ6NhDq+4lx/h+PsY6w=;
	h=Date:To:From:Subject:From;
	b=jr6P+M1hwo7q7Iugk48ZdTW8ciyN0cpvuoM7+YZLw9aomDxNSE6qQxo9taj6WBh0G
	 2psJgH3PDInAoZFLMdUMdVwCSuPT9b+6KCWxPQlEXKdveaLFHxCgH5H+a2nJ6Sebbx
	 ycl8VOAVkX3xbCyZAKGICFzhIZ79i41c1We/2ras=
Date: Thu, 17 Jul 2025 14:35:44 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,riel@surriel.com,peterx@redhat.com,liam.howlett@oracle.com,jannh@google.com,jack@suse.cz,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-put-vma-check-and-prep-logic-into-helper-function.patch added to mm-new branch
Message-Id: <20250717213545.3C326C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mremap: put VMA check and prep logic into helper function
has been added to the -mm mm-new branch.  Its filename is
     mm-mremap-put-vma-check-and-prep-logic-into-helper-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-put-vma-check-and-prep-logic-into-helper-function.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: mm/mremap: put VMA check and prep logic into helper function
Date: Thu, 17 Jul 2025 17:55:53 +0100

Rather than lumping everything together in do_mremap(), add a new helper
function, check_prep_vma(), to do the work relating to each VMA.

This further lays groundwork for subsequent patches which will allow for
batched VMA mremap().

Additionally, if we set vrm->new_addr == vrm->addr when prepping the VMA,
this avoids us needing to do so in the expand VMA mlocked case.

No functional change intended.

Link: https://lkml.kernel.org/r/15efa3c57935f7f8894094b94c1803c2f322c511.1752770784.git.lorenzo.stoakes@oracle.com
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

 mm/mremap.c |   58 ++++++++++++++++++++++++--------------------------
 1 file changed, 28 insertions(+), 30 deletions(-)

--- a/mm/mremap.c~mm-mremap-put-vma-check-and-prep-logic-into-helper-function
+++ a/mm/mremap.c
@@ -1634,7 +1634,6 @@ static bool align_hugetlb(struct vma_rem
 static unsigned long expand_vma(struct vma_remap_struct *vrm)
 {
 	unsigned long err;
-	unsigned long addr = vrm->addr;
 
 	err = remap_is_valid(vrm);
 	if (err)
@@ -1649,16 +1648,8 @@ static unsigned long expand_vma(struct v
 		if (err)
 			return err;
 
-		/*
-		 * We want to populate the newly expanded portion of the VMA to
-		 * satisfy the expectation that mlock()'ing a VMA maintains all
-		 * of its pages in memory.
-		 */
-		if (vrm->mlocked)
-			vrm->new_addr = addr;
-
 		/* OK we're done! */
-		return addr;
+		return vrm->addr;
 	}
 
 	/*
@@ -1714,10 +1705,33 @@ static unsigned long mremap_at(struct vm
 	return -EINVAL;
 }
 
+static int check_prep_vma(struct vma_remap_struct *vrm)
+{
+	struct vm_area_struct *vma = vrm->vma;
+
+	if (!vma)
+		return -EFAULT;
+
+	/* If mseal()'d, mremap() is prohibited. */
+	if (!can_modify_vma(vma))
+		return -EPERM;
+
+	/* Align to hugetlb page size, if required. */
+	if (is_vm_hugetlb_page(vma) && !align_hugetlb(vrm))
+		return -EINVAL;
+
+	vrm_set_delta(vrm);
+	vrm->remap_type = vrm_remap_type(vrm);
+	/* For convenience, we set new_addr even if VMA won't move. */
+	if (!vrm_implies_new_addr(vrm))
+		vrm->new_addr = vrm->addr;
+
+	return 0;
+}
+
 static unsigned long do_mremap(struct vma_remap_struct *vrm)
 {
 	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma;
 	unsigned long res;
 
 	vrm->old_len = PAGE_ALIGN(vrm->old_len);
@@ -1731,26 +1745,10 @@ static unsigned long do_mremap(struct vm
 		return -EINTR;
 	vrm->mmap_locked = true;
 
-	vma = vrm->vma = vma_lookup(mm, vrm->addr);
-	if (!vma) {
-		res = -EFAULT;
-		goto out;
-	}
-
-	/* If mseal()'d, mremap() is prohibited. */
-	if (!can_modify_vma(vma)) {
-		res = -EPERM;
-		goto out;
-	}
-
-	/* Align to hugetlb page size, if required. */
-	if (is_vm_hugetlb_page(vma) && !align_hugetlb(vrm)) {
-		res = -EINVAL;
+	vrm->vma = vma_lookup(current->mm, vrm->addr);
+	res = check_prep_vma(vrm);
+	if (res)
 		goto out;
-	}
-
-	vrm_set_delta(vrm);
-	vrm->remap_type = vrm_remap_type(vrm);
 
 	/* Actually execute mremap. */
 	res = vrm_implies_new_addr(vrm) ? mremap_to(vrm) : mremap_at(vrm);
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name.patch
mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name-fix.patch
mm-mremap-perform-some-simple-cleanups.patch
mm-mremap-refactor-initial-parameter-sanity-checks.patch
mm-mremap-put-vma-check-and-prep-logic-into-helper-function.patch
mm-mremap-cleanup-post-processing-stage-of-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap.patch
mm-mremap-check-remap-conditions-earlier.patch
mm-mremap-move-remap_is_valid-into-check_prep_vma.patch
mm-mremap-clean-up-mlock-populate-behaviour.patch
mm-mremap-permit-mremap-move-of-multiple-vmas.patch
tools-testing-selftests-extend-mremap_test-to-test-multi-vma-mremap.patch
mm-mseal-always-define-vm_sealed.patch
mm-mseal-update-madvise-logic.patch
mm-mseal-small-cleanups.patch
mm-mseal-simplify-and-rename-vma-gap-check.patch
mm-mseal-rework-mseal-apply-logic.patch

