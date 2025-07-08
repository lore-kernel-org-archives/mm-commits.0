Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2891FBCA1
	for <mm-commits@vger.kernel.org>; Tue,  8 Jul 2025 01:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751939915; cv=none; b=H3xWlpFvk54I86XQRFIfBmm/zbZSd6uxHEthOu6vF22Je5k9em7icetd8Ck/w1UZZcZ/C5blGoCJUY/suOBKKti2slmcaKfQTorKXjFRxk5t0mpGy7VON+QRsP1+BgPtPGcDJ9cQWT6BHE27zhxLmAO/S+K/DIz5uFS6OJqzwkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751939915; c=relaxed/simple;
	bh=MfxTCSJb66qPVpnTxAdHOaNJKw6W/VtleA3eZsJo578=;
	h=Date:To:From:Subject:Message-Id; b=FCFiKYXcM6cRC8FlIP2IUeOpcKriGAk7X3ptFjE/MqUGImwvFhxan2BYG98+uQbHN3YLy/NYyqml41ViMTghPrp30mMKM3MDp4a455tKM5Cdae/rHuX8MUNhUAczRrSiFcxLg7RUzlhW1B57d2x+EvscfDWCwSou/5GYk5zCABs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tB6vcHfX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tB6vcHfX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6EADC4CEE3;
	Tue,  8 Jul 2025 01:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751939914;
	bh=MfxTCSJb66qPVpnTxAdHOaNJKw6W/VtleA3eZsJo578=;
	h=Date:To:From:Subject:From;
	b=tB6vcHfXqeIIDRDkHGMsvZYL3l5SoFnYmuGX8v7nBdrFEIt/H9OlA/0liL8bHSKht
	 p+lr2YBgEcwy+c3I4YkSJCq8Peti14C+Msw5qi37TwQ6G+lFsHJCYgenfMKcfEvVAc
	 dmPRkPrTIiiwKii3f6rSLf1H2dCKLuvUtwqcfjfc=
Date: Mon, 07 Jul 2025 18:58:34 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,riel@surriel.com,peterx@redhat.com,lkp@intel.com,liam.howlett@oracle.com,jannh@google.com,jack@suse.cz,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-check-remap-conditions-earlier.patch added to mm-new branch
Message-Id: <20250708015834.C6EADC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mremap: check remap conditions earlier
has been added to the -mm mm-new branch.  Its filename is
     mm-mremap-check-remap-conditions-earlier.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-check-remap-conditions-earlier.patch

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
Subject: mm/mremap: check remap conditions earlier
Date: Mon, 7 Jul 2025 06:27:49 +0100

When we expand or move a VMA, this requires a number of additional checks
to be performed.

Make it really obvious under what circumstances these checks must be
performed and aggregate all the checks in one place by invoking this in
check_prep_vma().

We have to adjust the checks to account for shrink + move operations by
checking new_len <= old_len rather than new_len == old_len.

No functional change intended.

Link: https://lkml.kernel.org/r/3a24bca518001fea3a5f2733c55cf727e566b438.1751865330.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

--- a/mm/mremap.c~mm-mremap-check-remap-conditions-earlier
+++ a/mm/mremap.c
@@ -1343,7 +1343,7 @@ static int remap_is_valid(struct vma_rem
 	if (old_len > vma->vm_end - addr)
 		return -EFAULT;
 
-	if (new_len == old_len)
+	if (new_len <= old_len)
 		return 0;
 
 	/* Need to be careful about a growing mapping */
@@ -1443,10 +1443,6 @@ static unsigned long mremap_to(struct vm
 		vrm->old_len = vrm->new_len;
 	}
 
-	err = remap_is_valid(vrm);
-	if (err)
-		return err;
-
 	/* MREMAP_DONTUNMAP expands by old_len since old_len == new_len */
 	if (vrm->flags & MREMAP_DONTUNMAP) {
 		vm_flags_t vm_flags = vrm->vma->vm_flags;
@@ -1635,10 +1631,6 @@ static unsigned long expand_vma(struct v
 {
 	unsigned long err;
 
-	err = remap_is_valid(vrm);
-	if (err)
-		return err;
-
 	/*
 	 * [addr, old_len) spans precisely to the end of the VMA, so try to
 	 * expand it in-place.
@@ -1705,6 +1697,21 @@ static unsigned long mremap_at(struct vm
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
@@ -1726,6 +1733,9 @@ static int check_prep_vma(struct vma_rem
 	if (!vrm_implies_new_addr(vrm))
 		vrm->new_addr = vrm->addr;
 
+	if (vrm_will_map_new(vrm))
+		return remap_is_valid(vrm);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas-fix.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch
mm-use-per_vma-lock-for-madv_dontneed-fix.patch
mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch
secretmem-remove-uses-of-struct-page-fix.patch
mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge.patch
mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge-fix.patch
mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument.patch
mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument-fix.patch
mm-update-core-kernel-code-to-use-vm_flags_t-consistently.patch
mm-update-architecture-and-driver-code-to-use-vm_flags_t.patch
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
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap-fix.patch
mm-mremap-check-remap-conditions-earlier.patch
mm-mremap-move-remap_is_valid-into-check_prep_vma.patch
mm-mremap-clean-up-mlock-populate-behaviour.patch
mm-mremap-permit-mremap-move-of-multiple-vmas.patch
tools-testing-selftests-extend-mremap_test-to-test-multi-vma-mremap.patch

