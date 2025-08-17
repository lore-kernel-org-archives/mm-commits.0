Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3499E27453
	for <mm-commits@vger.kernel.org>; Sun, 17 Aug 2025 17:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755452476; cv=none; b=dHCFFpNO24CSTrMpsVL3b9b781oj8p/B5r7TZabGdIc2aWGdatTw+jY/U99+FWlmPyg2811K/IKfmJsRTNpmM6fWtsw3dg/wfVTWlTd+TVgWlTSThyy0zKRge2X5ARaRfF0KwSeV6EJwtZ6BrhsU6ttEeNh6xDO9KxEFNER0kaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755452476; c=relaxed/simple;
	bh=GvdBnuNEHowu06AVWxIcrNvwee8Pzts0Dq8igudo9lc=;
	h=Date:To:From:Subject:Message-Id; b=CBzbj2RVhd0EMoY8edIi2lnvo+Oy3xi04CfzFfe8nwcEzl9LA0G0+0Z4uqjum7SwqXOFKSQ2ja5f6UZoCzciCWUbc14bW2R7ujpQau3YTwpcwnxuhYNJl/3JVReHTeGSZt9onx3Dom/rE+6ibCpLfmC1uVNjBa47MIjQdmQUhOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tQlktR/0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tQlktR/0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB38DC4CEEB;
	Sun, 17 Aug 2025 17:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755452475;
	bh=GvdBnuNEHowu06AVWxIcrNvwee8Pzts0Dq8igudo9lc=;
	h=Date:To:From:Subject:From;
	b=tQlktR/0erxwLEMXRw4VKfQptdM00f80UYVmR0ApY8A05coE9d+tHteEBTk42Mpri
	 Y4tuGWR8OWDU/2VD4mdL4ZqYK6xnVvN+irj5nvj9aPneKXLWx7rBnfrfz5MV0vJRBy
	 iDGNB6vm6Z49Y2/z9HPKqSOvC1gSZZHHpkK2b75s=
Date: Sun, 17 Aug 2025 10:41:14 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-catch-invalid-multi-vma-moves-earlier-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20250817174115.AB38DC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mremap: do not incorrectly reference invalid VMA in VM_WARN_ON_ONCE()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mremap-catch-invalid-multi-vma-moves-earlier-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-catch-invalid-multi-vma-moves-earlier-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
mm-mremap-catch-invalid-multi-vma-moves-earlier-fix.patch
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

