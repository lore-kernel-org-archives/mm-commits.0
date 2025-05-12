Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9571553A3
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011039; cv=none; b=OScDPpLwP4RnXXGQznOBJ0x9omrY1riJ2i58YEGbPnCZmH55IDAL8x9AHwYhVcVznK6f8dbFqKjmR4Ay58ep69XgMQIlDLU7jyhZIIFvNshTWm/pEd4/oFY6dMhUdlz3uegSHFL5SrFA+tN+O/s2JRV5ISnJZM8+WP6FnjuTJrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011039; c=relaxed/simple;
	bh=Txb9JCbV9Hw4YWYAGoYQtz0tJBbEx3gFRuy7yBX2+kY=;
	h=Date:To:From:Subject:Message-Id; b=nRiZzYHRfzouSl+hgCjF+sXKkUOUk/FVX0Q6BYHeWKSaNrlFGDF0QB5mWMiHZq4cxUExEi8CHs+pcEKdMQIE4dq3+IP9SZpxl6E0pfMzFybfSFJfrpj1V9RsxiHw+zrSr7MLSL9eiF3i+DPv3zqW9saX7NGatRcHxeVpeGdF4zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=olAxCMec; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="olAxCMec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6476C4CEE4;
	Mon, 12 May 2025 00:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011038;
	bh=Txb9JCbV9Hw4YWYAGoYQtz0tJBbEx3gFRuy7yBX2+kY=;
	h=Date:To:From:Subject:From;
	b=olAxCMec1MKeOkrLa6AEFEfUbvwDBFTmeZGg+Y9mVKMgyPvoKtoWoAPBvoYk953Kb
	 qfLtmRkBpG0A4gCHXHlbgo4gjLpN4Fy4r1IX7TNKpp7uqRw8uXVaICxfOwPXmp3Qfm
	 RwJvd39LBSjbj5O56PiCc9sUdblc2W96ibRLzhdc=
Date: Sun, 11 May 2025 17:50:38 -0700
To: mm-commits@vger.kernel.org,soumish.das@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-kernel-doc-comment-for-free_pgd_range.patch removed from -mm tree
Message-Id: <20250512005038.C6476C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add kernel-doc comment for free_pgd_range()
has been removed from the -mm tree.  Its filename was
     mm-add-kernel-doc-comment-for-free_pgd_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


