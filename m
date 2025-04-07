Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39D0204F9B
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 01:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743988578; cv=none; b=LVsMk7C+VmsFSqmXRUiiV19qC2zSqadjktgnea8D/dL2gJJKFcwyY+DZpNQZaQ50cRLJfx4CoKyymcoV/huHMxhepoU5N7mREbL+yPl3vNucjx4qAKq0rNWelYpg+P2H6sKU4+M4j8MH3nJ38d6tXxl1uedzvag2aD9riCwqLeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743988578; c=relaxed/simple;
	bh=6MzRJg7UZV/9KNT7tvIHNO31pmhxhyUnUdsf2G+hTnA=;
	h=Date:To:From:Subject:Message-Id; b=lGT97xeVaWh3+fZnSxW3xrqwu010nOu4VXQ7OA81rGpSXRh4BCr+cL9/QTcRegKXqm+vVcckuaQ2T+INfP1cB9Sje8yNb4QItA2xawDJcKujIA4IqzA8yvb/NSHmmdocmdWp/zG2ZmXe04UCDEBwFHjzv5i80G9ZOPPHY/g9hUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dunRPuVB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dunRPuVB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E14C4CEE3;
	Mon,  7 Apr 2025 01:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743988577;
	bh=6MzRJg7UZV/9KNT7tvIHNO31pmhxhyUnUdsf2G+hTnA=;
	h=Date:To:From:Subject:From;
	b=dunRPuVB3cIJR40T0GVAtuB4hhWKtpj2v4WsLPtfW1NYF6egV0o8EcjLnb85kF2qB
	 IniYsiTHIcM2Ta7La/Z5fi1SH4CGLCNM6y5X7lzLcKlAf2ZC8xaoi7pPyVlXeRwVCh
	 ii4/IiFXGrPbAOVQ5AREDqE7N6wBGRuz++EYLkqQ=
Date: Sun, 06 Apr 2025 18:16:16 -0700
To: mm-commits@vger.kernel.org,soumish.das@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-kernel-doc-comment-for-free_pgd_range.patch added to mm-new branch
Message-Id: <20250407011617.46E14C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add kernel-doc comment for free_pgd_range()
has been added to the -mm mm-new branch.  Its filename is
     mm-add-kernel-doc-comment-for-free_pgd_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-kernel-doc-comment-for-free_pgd_range.patch

This patch will later appear in the mm-new branch at
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
From: SoumishDas <soumish.das@gmail.com>
Subject: mm: add kernel-doc comment for free_pgd_range()
Date: Tue, 25 Mar 2025 23:43:25 +0530

Provide kernel-doc for free_pgd_range() so it's easier to understand what
the function does and how it is used.

Link: https://lkml.kernel.org/r/20250325181325.5774-1-soumish.das@gmail.com
Signed-off-by: SoumishDas <soumish.das@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/mm/memory.c~mm-add-kernel-doc-comment-for-free_pgd_range
+++ a/mm/memory.c
@@ -278,8 +278,17 @@ static inline void free_p4d_range(struct
 	p4d_free_tlb(tlb, p4d, start);
 }
 
-/*
- * This function frees user-level page tables of a process.
+/**
+ * free_pgd_range - Unmap and free page tables in the range
+ * @tlb: the mmu_gather containing pending TLB flush info
+ * @addr: virtual address start
+ * @end: virtual address end
+ * @floor: lowest address boundary
+ * @ceiling: highest address boundary
+ *
+ * This function tears down all user-level page tables in the
+ * specified virtual address range [@addr..@end). It is part of
+ * the memory unmap flow.
  */
 void free_pgd_range(struct mmu_gather *tlb,
 			unsigned long addr, unsigned long end,
_

Patches currently in -mm which might be from soumish.das@gmail.com are

mm-add-kernel-doc-comment-for-free_pgd_range.patch

