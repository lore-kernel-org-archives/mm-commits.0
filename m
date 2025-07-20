Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EB5382
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 18:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753035862; cv=none; b=KM4E91ao3cMlkyv0tWr89NHFfJV9lFyQszGmBz47tg2NhlvbOlnaDSMV6vaTqLGP2QDlfwzSv4xTlDRnvCKjge1ZwMB6YwRhZWP0K/gPB/DbQR0JyhT5vssDl78Wxtzr+uoOC5cjivVk42koWIo6Ri6Fg2oGpzI3f3Cm6KfrK70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753035862; c=relaxed/simple;
	bh=x+gZ9crdC4q6u1J8vNDA2w+6NuFShMTjGG2OltOS4cw=;
	h=Date:To:From:Subject:Message-Id; b=bzRIAKVi2P71Uae34v5Hs5klGkQGujQWox5lc0Qg8Jd2Xk8EjUAabQCWMErjp5L/cnVUt97Su5Uj1Did00HO/UQnZfMJCExfluyXDGceWVeeHiDdhbxAiBSawifuyB9Yu1q7tADsPPyaT5fb9zxArczf2zKtJITyTNaMQyVf/WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aYt/Fyoa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aYt/Fyoa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB942C4CEE7;
	Sun, 20 Jul 2025 18:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753035861;
	bh=x+gZ9crdC4q6u1J8vNDA2w+6NuFShMTjGG2OltOS4cw=;
	h=Date:To:From:Subject:From;
	b=aYt/FyoaN0DqrbmiKKd3+pCIMpYKAUjSmiDApaRqmz4+InSFOzmE4NBFRpPS31KPm
	 JAOwm+Z1HXtkWrdm+oQlJQy/PxJlALNelWQWFVyZQuPxJs8YMfZI2l8cT2xA3QBNSP
	 hAcwe9rKiPqFim0hfOdBVZNLHXA1HqKDkXpauj8M=
Date: Sun, 20 Jul 2025 11:24:21 -0700
To: mm-commits@vger.kernel.org,oliver.sang@intel.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-check-remap-conditions-earlier-fix.patch added to mm-unstable branch
Message-Id: <20250720182421.CB942C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mremap: allow undocumented mremap() shrink behaviour
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mremap-check-remap-conditions-earlier-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-check-remap-conditions-earlier-fix.patch

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
Subject: mm/mremap: allow undocumented mremap() shrink behaviour
Date: Sun, 20 Jul 2025 11:41:48 +0100

It turns out that, in apparent contradiction to the man page, and at odds
with every other mremap() operation - we are allowed to specify an input
addr, old_len range that spans any number of VMAs and any number of gaps,
as long as we shrink that range to the point at which the new range spans
only one.

In order to accommodate this, adjust the remap validity check to account
for this.

Link: https://lkml.kernel.org/r/8fc92a38-c636-465e-9a2f-2c6ac9cb49b8@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202507201002.69144b74-lkp@intel.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/mremap.c~mm-mremap-check-remap-conditions-earlier-fix
+++ a/mm/mremap.c
@@ -1339,11 +1339,18 @@ static int remap_is_valid(struct vma_rem
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
 
-	if (new_len <= old_len)
+	if (new_len == old_len)
 		return 0;
 
 	/* Need to be careful about a growing mapping */
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name.patch
mm-mremap-perform-some-simple-cleanups.patch
mm-mremap-refactor-initial-parameter-sanity-checks.patch
mm-mremap-put-vma-check-and-prep-logic-into-helper-function.patch
mm-mremap-cleanup-post-processing-stage-of-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap.patch
mm-mremap-check-remap-conditions-earlier.patch
mm-mremap-check-remap-conditions-earlier-fix.patch
mm-mremap-move-remap_is_valid-into-check_prep_vma.patch
mm-mremap-clean-up-mlock-populate-behaviour.patch
mm-mremap-permit-mremap-move-of-multiple-vmas.patch
tools-testing-selftests-extend-mremap_test-to-test-multi-vma-mremap.patch
mm-mseal-always-define-vm_sealed.patch
mm-mseal-update-madvise-logic.patch
mm-mseal-small-cleanups.patch
mm-mseal-simplify-and-rename-vma-gap-check.patch
mm-mseal-rework-mseal-apply-logic.patch

