Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD552E822
	for <mm-commits@vger.kernel.org>; Sat,  7 Dec 2024 04:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733546139; cv=none; b=dbxnS3CNfA4J7dIHzDj9C2i4IY+q0Qt1bBCXnx2RyxewgWYT2A9ln3NQAkR/JptfmPzOVt/1S56g4A1ZW6xifrwggcmZIKYj0K7Xv5uftUSVm8ITdREwFVAC8kZhME4cwC/ThljSxyTuxg3TYmiECBSomhlxpIM0H0+MOuBnAmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733546139; c=relaxed/simple;
	bh=iZVpQ94O/VPSLUgEgSrS4sd49aftxyyPNxk7bAubbcw=;
	h=Date:To:From:Subject:Message-Id; b=DeseAvtWstxYmz9ZU+TXnCf1VdGuvC9sP4xJcxv5BTpS7E6kOlKGf7UiL0CbvzMw+XnZvRWnkP5Zda+/o0P5FZPmOwCfIoQjj7wY8D8RFGRVBkFWVTmiwvSoYE/A/7pSz63gem+2CM4z5CP2xgaM9l9EUX02pZwQWotVvOuy67k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ih/FiMIO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ih/FiMIO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B58C4CECD;
	Sat,  7 Dec 2024 04:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733546138;
	bh=iZVpQ94O/VPSLUgEgSrS4sd49aftxyyPNxk7bAubbcw=;
	h=Date:To:From:Subject:From;
	b=ih/FiMIOhDwSgLExRM2zNNU04yvb6o+rSGJzrV2VnaX8lVFO2Bw58bFTjhKm8saAR
	 azTHPIU+/y24vszzOhXjyenaS+6tDG5VKykHtvUI7+L4rEfGMXhYMAhnVIoLsud14o
	 C5Mman7ZE1J3RgvX6afDf77kipxlHcpe7cZN9Qj8=
Date: Fri, 06 Dec 2024 20:35:37 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,Liam.Howlett@Oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-correctly-reference-merged-vma.patch added to mm-hotfixes-unstable branch
Message-Id: <20241207043538.B7B58C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: correctly reference merged VMA
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-correctly-reference-merged-vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-correctly-reference-merged-vma.patch

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
Subject: mm: correctly reference merged VMA
Date: Fri, 6 Dec 2024 21:52:29 +0000

On second merge attempt on mmap() we incorrectly discard the possibly
merged VMA, resulting in a possible use-after-free (and most certainly a
reference to the wrong VMA) in this instance in the subsequent
__mmap_complete() invocation.

Correct this mistake by reassigning vma correctly if a merge succeeds in
this case.

Link: https://lkml.kernel.org/r/20241206215229.244413-1-lorenzo.stoakes@oracle.com
Fixes: 5ac87a885aec ("mm: defer second attempt at merge on mmap()")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Suggested-by: Jann Horn <jannh@google.com>
Reported-by: syzbot+91cf8da9401355f946c3@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/67536a25.050a0220.a30f1.0149.GAE@google.com/
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/vma.c~mm-correctly-reference-merged-vma
+++ a/mm/vma.c
@@ -2460,10 +2460,13 @@ unsigned long __mmap_region(struct file
 
 	/* If flags changed, we might be able to merge, so try again. */
 	if (map.retry_merge) {
+		struct vm_area_struct *merged;
 		VMG_MMAP_STATE(vmg, &map, vma);
 
 		vma_iter_config(map.vmi, map.addr, map.end);
-		vma_merge_existing_range(&vmg);
+		merged = vma_merge_existing_range(&vmg);
+		if (merged)
+			vma = merged;
 	}
 
 	__mmap_complete(&map, vma);
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

docs-mm-add-vma-locks-documentation.patch
mm-reinstate-ability-to-map-write-sealed-memfd-mappings-read-only.patch
selftests-memfd-add-test-for-mapping-write-sealed-memfd-read-only.patch
mm-correctly-reference-merged-vma.patch
mm-enforce-__must_check-on-vma-merge-and-split.patch
mm-vma-move-brk-internals-to-mm-vmac.patch
mm-vma-move-brk-internals-to-mm-vmac-fix.patch
mm-vma-move-unmapped_area-internals-to-mm-vmac.patch
mm-abstract-get_arg_page-stack-expansion-and-mmap-read-lock.patch
mm-vma-move-stack-expansion-logic-to-mm-vmac.patch
mm-vma-move-__vm_munmap-to-mm-vmac.patch
selftests-mm-add-fork-cow-guard-page-test.patch

