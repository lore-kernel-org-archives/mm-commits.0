Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB29235C190;
	Fri, 28 Aug 2026 17:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787936735; cv=none; b=MYb8QYFBumI9Jhq/ff6KRg5JQG+g66K7i9GvbyaijQKXuVF++j8LD9i86p9Jfnvlh/M5UwrYHVgEJQ17GAMevxPQDumi+bscHuc3ZpFtXXy9h8LLO6ipjIHkMoOp8Mxk0askduNsSo/L33DchO5fqx74NF7dXqdTqt69GwPG8jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787936735; c=relaxed/simple;
	bh=dAuVNkb480KHWftDDELN3c1TH4pvNs4aJQihawzniKg=;
	h=Date:To:From:Subject:Message-Id; b=o40gpp4IFVTwNeqdh4FmSqvg84NCONfx2ozT5La0YgC2RMK/fjBdjEkQSa1yiZAkNfx1QYCHgdJRd1JezYqAJ38qZbA2/WYsdft71htL6GFxwzA95n229R1pHNwLa5G1ZkoSsq53Na4wNTYEa91/TrWzXCaytyJR6+lWOX+og4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JARxSi47; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JARxSi47"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78AA11F000E9;
	Fri, 28 Aug 2026 17:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787936733;
	bh=96T8rpHq12AZ03fHy38EszF3qNkv40aaZSwfBLsIutI=;
	h=Date:To:From:Subject;
	b=JARxSi47G8xtKstUoNNFxPou6VWqUC7+wJXOEs0oDrV2BXJpFXXZDxy3Ja/fxB7Ej
	 1NQaG9VucxT22qv5GLgYqSQljqs2CcFOY/AXD96gYeK0dHyrLJc2Ft30k+tZUGFkX2
	 /0EFHOQg7RG/BMDBhvbOtd2rvx9ulV32fGnEdcwA=
Date: Fri, 28 Aug 2026 10:05:33 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,sashiko-bot@kernel.org,pfalcato@suse.de,liam@infradead.org,kunwu.chan@gmail.com,jannh@google.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-account-mm-locked_vm-correctly-for-mremap_dontunmap.patch added to mm-hotfixes-unstable branch
Message-Id: <20260828170533.78AA11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mremap: account mm->locked_vm correctly for MREMAP_DONTUNMAP
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mremap-account-mm-locked_vm-correctly-for-mremap_dontunmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-account-mm-locked_vm-correctly-for-mremap_dontunmap.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/mremap: account mm->locked_vm correctly for MREMAP_DONTUNMAP
Date: Fri, 28 Aug 2026 12:20:37 +0100

When a VMA is mremap()'d with MREMAP_DONTUNMAP set, that results in the
VMA being copied, but the source VMA not being unmapped.

If the VMA is mlock()'d this is a legal operation, though the source VMA
has its VMA_LOCKED_BIT cleared.

However this is done in dontunmap_complete(), after mm->locked_vm was
incremented via vrm_stat_account(), resulting in double-counting.

Worse, this is not even corrected when source VMA is unmapped, due to the
VMA_LOCKED_BIT flag having been cleared.

This all works fine in the usual mremap() case (without MREMAP_DONTUNMAP),
as the source VMA is unmapped with VMA_LOCKED_BIT intact, at which time
mm->locked_vm is decremented accordingly.

Resolve the issue by invoking vrm_stat_account() only after
dontunmap_complete() has run.

Note that MREMAP_DONTUNMAP requires old_len == new_len, so no need to
account for a delta in size in this case.

The bug was introduced by commit b714ccb02a76 ("mm/mremap: complete
refactor of move_vma()") which incorrectly reordered the accounting and
the clearing of the VMA_LOCKED_BIT flag.

Link: https://lore.kernel.org/20260828-mremap-fix-locked-vm-v1-1-c80be7505d1e@kernel.org
Fixes: b714ccb02a76 ("mm/mremap: complete refactor of move_vma()")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260825-fix-mremap-dontunmap-pgoff-v1-1-39a40b2c98b3@kernel.org
Reported-by: Kunwu Chan <kunwu.chan@gmail.com>
Closes: https://lore.kernel.org/all/20260828094823.594279-1-kunwu.chan@linux.dev/
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/mremap.c~mm-mremap-account-mm-locked_vm-correctly-for-mremap_dontunmap
+++ a/mm/mremap.c
@@ -1355,12 +1355,11 @@ static void dontunmap_complete(struct vm
 		if (vma_is_anonymous(vma) && !vma->vm_file)
 			vma_set_pgoff(vma, pgoff_unfaulted);
 	}
-
-	/* Because we won't unmap we don't need to touch locked_vm. */
 }
 
 static unsigned long move_vma(struct vma_remap_struct *vrm)
 {
+	const bool is_dontunmap = vrm->flags & MREMAP_DONTUNMAP;
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *new_vma;
 	unsigned long hiwater_vm;
@@ -1401,10 +1400,10 @@ static unsigned long move_vma(struct vma
 	 */
 	hiwater_vm = mm->hiwater_vm;
 
-	vrm_stat_account(vrm, vrm->new_len);
-	if (unlikely(!err && (vrm->flags & MREMAP_DONTUNMAP)))
+	if (unlikely(is_dontunmap && !err))
 		dontunmap_complete(vrm, new_vma);
-	else
+	vrm_stat_account(vrm, vrm->new_len);
+	if (!is_dontunmap || err)
 		unmap_source_vma(vrm);
 
 	mm->hiwater_vm = hiwater_vm;
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-mremap-reset-unfaulted-vma-page-offset-for-mremap_dontunmap.patch
mm-secretmem-properly-account-locked-pages.patch
mm-huge_memory-bypass-thp-tuneables-for-huge-pfnmap-mappings.patch
mm-mremap-account-mm-locked_vm-correctly-for-mremap_dontunmap.patch

