Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415621E0B9C
	for <mm-commits@vger.kernel.org>; Tue, 19 Aug 2025 23:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755646262; cv=none; b=GpST4e0r0btiDlMlAWGjSrDcZTupb157XVBRTHIkuUbSnjfSVN3eqi80hGnCvCr4HuaavuEXXcXGDGj/rUtFpVEugh9laM3Iz4/B10WMdTnoCKVGcoBDNL4E6QXi6WK4AJeVnGvX6aOw+nnb+HJYhhHP/UCI5XrVEmsQlzD0abw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755646262; c=relaxed/simple;
	bh=XtUjXPbCFeq7V0Z5cIZDAgXJDEnJKcqbzgqSedhRb4E=;
	h=Date:To:From:Subject:Message-Id; b=OOFFOnwIUxI+gDaqkj3D9mF7yI3CAwXW7w1nIwssXe4vSc5+Mh1jrGal1/RotKdYa1fUTOtQ+ZiZRYmvmvNv3YMXClkHOXiyDrXCDbM5LtA4pxoeIiiLH0yVp0ynUsj3mdZPmGcEtF8O0x69ZDCTHMo+eOj0UKnaYF8QcecIxj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Sxr+DA/q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Sxr+DA/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B572DC4CEF1;
	Tue, 19 Aug 2025 23:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755646261;
	bh=XtUjXPbCFeq7V0Z5cIZDAgXJDEnJKcqbzgqSedhRb4E=;
	h=Date:To:From:Subject:From;
	b=Sxr+DA/qNCnOezdjnt/fNpWHwVZnY7OnRCXycHimeZS0TX0gALGjw1JkP067ELasM
	 l1RVtNEqUeIGbmvw3XVLQTfpNL4tiTTpuzi6Yn6gMQ92W2wnOQHUSwwr/05rOne0Qg
	 eHgvZReMqHCQ9ppUX2UZ/J3OM/gq9if0cjZhjtBM=
Date: Tue, 19 Aug 2025 16:31:01 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-mremap-catch-invalid-multi-vma-moves-earlier-fix.patch removed from -mm tree
Message-Id: <20250819233101.B572DC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mremap: do not incorrectly reference invalid VMA in VM_WARN_ON_ONCE()
has been removed from the -mm tree.  Its filename was
     mm-mremap-catch-invalid-multi-vma-moves-earlier-fix.patch

This patch was dropped because it was folded into mm-mremap-catch-invalid-multi-vma-moves-earlier.patch

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/mremap: do not incorrectly reference invalid VMA in VM_WARN_ON_ONCE()
Date: Sat, 16 Aug 2025 08:37:41 +0100

The VMA which is referenced here may have since been merged (which is the
entire point of the warning), and yet we still reference it.

Fix this by storing whether or not a multi move is permitted ahead of time
and have the VM_WARN_ON_ONCE() be predicated on this.

Link: https://lkml.kernel.org/r/b6dbda20-667e-4053-abae-8ed4fa84bb6c@lucifer.local
Reported-by: syzbot+4e221abf50259362f4f4@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-mm/689ff5f6.050a0220.e29e5.0030.GAE@google.com/
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/mremap.c~mm-mremap-catch-invalid-multi-vma-moves-earlier-fix
+++ a/mm/mremap.c
@@ -1837,6 +1837,7 @@ static unsigned long remap_move(struct v
 		unsigned long addr = max(vma->vm_start, start);
 		unsigned long len = min(end, vma->vm_end) - addr;
 		unsigned long offset, res_vma;
+		bool multi_allowed;
 
 		/* No gap permitted at the start of the range. */
 		if (!seen_vma && start < vma->vm_start)
@@ -1865,7 +1866,8 @@ static unsigned long remap_move(struct v
 		vrm->new_addr = target_addr + offset;
 		vrm->old_len = vrm->new_len = len;
 
-		if (!vma_multi_allowed(vma)) {
+		multi_allowed = vma_multi_allowed(vma);
+		if (!multi_allowed) {
 			/* This is not the first VMA, abort immediately. */
 			if (seen_vma)
 				return -EFAULT;
@@ -1881,8 +1883,7 @@ static unsigned long remap_move(struct v
 			return res_vma;
 
 		if (!seen_vma) {
-			VM_WARN_ON_ONCE(vma_multi_allowed(vma) &&
-					res_vma != new_addr);
+			VM_WARN_ON_ONCE(multi_allowed && res_vma != new_addr);
 			res = res_vma;
 		}
 
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

tools-testing-add-linux-argsh-header-and-fix-radix-vma-tests.patch
mm-mremap-allow-multi-vma-move-when-filesystem-uses-thp_get_unmapped_area.patch
mm-mremap-catch-invalid-multi-vma-moves-earlier.patch
selftests-mm-add-test-for-invalid-multi-vma-operations.patch
mm-add-bitmap-mm-flags-field.patch
mm-add-bitmap-mm-flags-field-fix.patch
mm-convert-core-mm-to-mm_flags_-accessors.patch
mm-convert-prctl-to-mm_flags_-accessors.patch
mm-convert-arch-specific-code-to-mm_flags_-accessors.patch
mm-convert-arch-specific-code-to-mm_flags_-accessors-fix.patch
mm-convert-uprobes-to-mm_flags_-accessors.patch
mm-update-coredump-logic-to-correctly-use-bitmap-mm-flags.patch
mm-correct-sign-extension-issue-in-mmf_-flag-masks.patch
mm-update-fork-mm-flags-initialisation-to-use-bitmap.patch
mm-convert-remaining-users-to-mm_flags_-accessors.patch
mm-replace-mm-flags-with-bitmap-entirely-and-set-to-64-bits.patch

