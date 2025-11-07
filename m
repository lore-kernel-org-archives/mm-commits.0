Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E175E21CFF7
	for <mm-commits@vger.kernel.org>; Fri,  7 Nov 2025 23:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762559976; cv=none; b=t9P9DeZAkYK6Fe9xtDtLN5vMLDXHTWO3ufy/a2mHT3JnEvaS7l4MREPC1TVmIVxk9Iu+nUQfrznEkA7Nttm3jrhHIFRFI6SAe51YmaGJFQ8QUTZ2ounK+lGGuJXe1248bQXzc1UAPY5EINVIjbS+3RkXwJfghHK+4d/VHKpGJBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762559976; c=relaxed/simple;
	bh=WVpFd/fLRgNKYhSMAYoAEMIGmQQJoSOU71n873Ha/bY=;
	h=Date:To:From:Subject:Message-Id; b=sDbsJIwRJZ213t6tbaV4Jio0Fb7IJqmJF9ECX+TZh6EBbQaDTVSDPF1CSXvHF1WCOOUME9Hgu9PvO45nWDV1CmrfM2T2Qi+jAWP2hKI+/YBpbGRQ/sED0VRWXl5opZDPe0WYcVpI9lmoiHPFzXC7q7/wpv9MmfH704x0JSg2i20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oVK7hJcx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oVK7hJcx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59561C4CEF7;
	Fri,  7 Nov 2025 23:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762559975;
	bh=WVpFd/fLRgNKYhSMAYoAEMIGmQQJoSOU71n873Ha/bY=;
	h=Date:To:From:Subject:From;
	b=oVK7hJcx40ZWJYHRfrB2hQJezUBgGZRP8C2JRdyUEYALUJKgstLpFtRAm5JKojY9h
	 HpJBwSA2N4WkZKtQbFSrUs11YLvqdzZmV52+JgedVCpadP9lqXr/+4UnqxcqKYfv8D
	 J9Tioi6RYmD5oA++bXWKFkJy1B0Lw1fr4BRNYB/c=
Date: Fri, 07 Nov 2025 15:59:34 -0800
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,kevin.brodsky@arm.com,jack@suse.cz,arnd@arndb.de,chenhuacai@loongson.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-refine-__pgdp4dpudpmdpte_alloc_one_-about-highmem.patch added to mm-new branch
Message-Id: <20251107235935.59561C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: refine __{pgd,p4d,pud,pmd,pte}_alloc_one_*() about HIGHMEM
has been added to the -mm mm-new branch.  Its filename is
     mm-refine-__pgdp4dpudpmdpte_alloc_one_-about-highmem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-refine-__pgdp4dpudpmdpte_alloc_one_-about-highmem.patch

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
From: Huacai Chen <chenhuacai@loongson.cn>
Subject: mm: refine __{pgd,p4d,pud,pmd,pte}_alloc_one_*() about HIGHMEM
Date: Fri, 7 Nov 2025 17:55:36 +0800

__{pgd,p4d,pud,pmd,pte}_alloc_one_*() always allocate pages with GFP
flag GFP_PGTABLE_KERNEL/GFP_PGTABLE_USER.

Neither of these include __GFP_HIGHMEM so the clearning of __GFP_HIGHMEM
is unnecessary.

Link: https://lkml.kernel.org/r/20251107095536.3101371-1-chenhuacai@loongson.cn
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/pgalloc.h |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/include/asm-generic/pgalloc.h~mm-refine-__pgdp4dpudpmdpte_alloc_one_-about-highmem
+++ a/include/asm-generic/pgalloc.h
@@ -18,8 +18,7 @@
  */
 static inline pte_t *__pte_alloc_one_kernel_noprof(struct mm_struct *mm)
 {
-	struct ptdesc *ptdesc = pagetable_alloc_noprof(GFP_PGTABLE_KERNEL &
-			~__GFP_HIGHMEM, 0);
+	struct ptdesc *ptdesc = pagetable_alloc_noprof(GFP_PGTABLE_KERNEL, 0);
 
 	if (!ptdesc)
 		return NULL;
@@ -178,7 +177,6 @@ static inline pud_t *__pud_alloc_one_nop
 
 	if (mm == &init_mm)
 		gfp = GFP_PGTABLE_KERNEL;
-	gfp &= ~__GFP_HIGHMEM;
 
 	ptdesc = pagetable_alloc_noprof(gfp, 0);
 	if (!ptdesc)
@@ -236,7 +234,6 @@ static inline p4d_t *__p4d_alloc_one_nop
 
 	if (mm == &init_mm)
 		gfp = GFP_PGTABLE_KERNEL;
-	gfp &= ~__GFP_HIGHMEM;
 
 	ptdesc = pagetable_alloc_noprof(gfp, 0);
 	if (!ptdesc)
@@ -284,7 +281,6 @@ static inline pgd_t *__pgd_alloc_noprof(
 
 	if (mm == &init_mm)
 		gfp = GFP_PGTABLE_KERNEL;
-	gfp &= ~__GFP_HIGHMEM;
 
 	ptdesc = pagetable_alloc_noprof(gfp, order);
 	if (!ptdesc)
_

Patches currently in -mm which might be from chenhuacai@loongson.cn are

mm-remove-the-bounce-config-option.patch
mm-refine-__pgdp4dpudpmdpte_alloc_one_-about-highmem.patch

