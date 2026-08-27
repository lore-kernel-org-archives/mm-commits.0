Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E8C3F1052;
	Thu, 27 Aug 2026 20:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787861070; cv=none; b=Q7ppvIAXZxD6L2aqWQiLC68AMWHWHy+KonJ04B3EBLwd6LHOgQc8WhfFrMzsvXWqqA7vIhmV/gmY6IRv8K726qLe8pBSHFfYnMBcFDEN6ThYXgBQIShoqK5/5GRi+P4OpQv88XGIFyfZpRwce40PC1hbokjA3Pskz6o22WFYB1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787861070; c=relaxed/simple;
	bh=IQnClMi7NlCPMSD13Bv0pJ82pLqAe6LwRafF5SSgWsE=;
	h=Date:To:From:Subject:Message-Id; b=pOGZXVOA5D8CuN26CdEd+0mZBKRK9wNOPlqxN2VwDoGq+V6FTVxV4/ajEFSjq6DT9vQZq4tgFN/P8FayiQ43pUsYFR8LGXzBzMYM51UDtpEpt7gJU9pLyI1CttOPJ90xgCx2fYmJxJrTqeZYT5lrf3Qwr5mkV94o4hwngu3Qvl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D3gtQUNt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D3gtQUNt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA47C1F000E9;
	Thu, 27 Aug 2026 20:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787861069;
	bh=guBzHEuJ556yjS9/3iNHWwlxnwmPBZAdmq2SjkEaG3w=;
	h=Date:To:From:Subject;
	b=D3gtQUNt4oXMTD71LYXOuNd583puUtkS39dIePObkVL8pfUZ7TFP+sIdM/fPJj77h
	 J1eW+irzr0uVaeLRsvQHv6ns18li27GMJWFW36xjq5fziw0JU4xvDuB2Gwa2XvC2aS
	 GMGI/kc2NIOpWiwovYnXeaJV0icF/UNIVuckShm4=
Date: Thu, 27 Aug 2026 13:04:28 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,pfalcato@suse.de,lixinhai.lxh@gmail.com,liam@infradead.org,kunwu.chan@gmail.com,jannh@google.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-reset-unfaulted-vma-page-offset-for-mremap_dontunmap.patch added to mm-hotfixes-unstable branch
Message-Id: <20260827200428.EA47C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mremap: reset unfaulted VMA page offset for MREMAP_DONTUNMAP
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mremap-reset-unfaulted-vma-page-offset-for-mremap_dontunmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-reset-unfaulted-vma-page-offset-for-mremap_dontunmap.patch

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
Subject: mm/mremap: reset unfaulted VMA page offset for MREMAP_DONTUNMAP
Date: Tue, 25 Aug 2026 08:55:26 +0100

Uniquely an mremap() invocation using the MREMAP_DONTUNMAP flag can reset
a faulted VMA into an unfaulted one.

It does so after the page tables have been moved to the copied VMA with
MREMAP_DONTUNMAP leaving the old VMA in place which is naturally unfaulted
as the page tables it had are no longer present.

However, in doing so, it violates the invariant that the anonymous page
offset of an unfaulted VMA is vma->vm_start >> PAGE_SHIFT.

This is because a VMA may have been faulted in, mremap()'d (causing a
delta between its page offset and vma->vm_start >> PAGE_SHIFT), and then
mremap()'d again with MREMAP_DONTUNMAP resulting in the unfaulting.

This condition is a violation of a fundamental assumption in mm, but now
also triggers an assert in assert_sane_pgoff() which explicitly checks for
this condition.

Correct it by resetting the VMA's page offset at the point of completing
the MREMAP_DONTUNMAP operation.

Link: https://lore.kernel.org/20260825-fix-mremap-dontunmap-pgoff-v1-1-39a40b2c98b3@kernel.org
Fixes: 1583aa278f5f ("mm: mremap: unlink anon_vmas when mremap with MREMAP_DONTUNMAP success")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reported-by: syzbot+f12658786a4153df5113@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6a87853b.ae6ddae5.3da009.0023.GAE@google.com/
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Li Xinhai <lixinhai.lxh@gmail.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Kunwu Chan <kunwu.chan@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

--- a/mm/mremap.c~mm-mremap-reset-unfaulted-vma-page-offset-for-mremap_dontunmap
+++ a/mm/mremap.c
@@ -1331,18 +1331,30 @@ static void dontunmap_complete(struct vm
 {
 	unsigned long start = vrm->addr;
 	unsigned long end = vrm->addr + vrm->old_len;
-	unsigned long old_start = vrm->vma->vm_start;
-	unsigned long old_end = vrm->vma->vm_end;
+	struct vm_area_struct *vma = vrm->vma;
+	unsigned long old_start = vma->vm_start;
+	unsigned long old_end = vma->vm_end;
 
 	/* We always clear VMA_LOCKED[ONFAULT]_BIT on the old VMA. */
-	vma_clear_flags_mask(vrm->vma, VMA_LOCKED_MASK);
+	vma_clear_flags_mask(vma, VMA_LOCKED_MASK);
 
 	/*
 	 * anon_vma links of the old vma is no longer needed after its page
 	 * table has been moved.
 	 */
-	if (new_vma != vrm->vma && start == old_start && end == old_end)
-		unlink_anon_vmas(vrm->vma);
+	if (new_vma != vma && start == old_start && end == old_end) {
+		const pgoff_t pgoff_unfaulted = vma->vm_start >> PAGE_SHIFT;
+
+		unlink_anon_vmas(vma);
+		/*
+		 * The VMA is now unfaulted and it is an invariant that
+		 * unfaulted anonymous VMAs have page offset equal to
+		 * vma->vm_start >> PAGE_SHIFT.
+		 */
+		vma_set_anon_pgoff(vma, pgoff_unfaulted);
+		if (vma_is_anonymous(vma) && !vma->vm_file)
+			vma_set_pgoff(vma, pgoff_unfaulted);
+	}
 
 	/* Because we won't unmap we don't need to touch locked_vm. */
 }
_

Patches currently in -mm which might be from ljs@kernel.org are

maintainers-remove-myself-as-thp-co-maintainer.patch
mm-mremap-reset-unfaulted-vma-page-offset-for-mremap_dontunmap.patch
mm-secretmem-properly-account-locked-pages.patch

