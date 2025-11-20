Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46FF33DEEB
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675098; cv=none; b=M3bHB/kyI5sI5ZCDqtSRKCCbEpgeliy9ezwho8yy0GPveJH6ohlZLpPBYIjT0it7v4DJZ+rj2wKP3+RFjWE3PnAAErDMCFfyDHEMgg3ydBvvYNnT3+/1LmKyAYQo6TD8Hjm5ndcsOFHH+ML7ccNxOPsfKV4iH3UMsbbDRjFZphw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675098; c=relaxed/simple;
	bh=5SK6ApRGwDCkk91ty4ST5yccsOwTRLfJiFDLfK+pf4I=;
	h=Date:To:From:Subject:Message-Id; b=ZXeUqbxF28Gii4I+yDIambFsgFNwur7QU59S7CJ5e5waxP979VeiNjfhwTG2kKLTQ2u9P4l4sjUwiq5tyRglsrTjVANex5sIaXJGgGbPUiOux1lMoia1pAdMXxJcWQ3hNBCdAsrWXfCPmpptqqDvCUO0yxseFJzlDEz9EReMIfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tjtPK3ad; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tjtPK3ad"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8FCEC4CEF1;
	Thu, 20 Nov 2025 21:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675097;
	bh=5SK6ApRGwDCkk91ty4ST5yccsOwTRLfJiFDLfK+pf4I=;
	h=Date:To:From:Subject:From;
	b=tjtPK3advQp0jN7V3adPHXlkvvLP8sufSoZ95vUM4j08yOJn9Rc9yZiU5rh9f7Tzf
	 9bXMkPJsoB68In0ZNIrd4a90pkvNhpHd09lOJuez56VwoC61G2t0rLDabVYFH/D2SE
	 c8mFTV8+jDjEJXrjrLCwTgTIhX0B93ChKOZqZBYg=
Date: Thu, 20 Nov 2025 13:44:57 -0800
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,rppt@kernel.org,kevin.brodsky@arm.com,jack@suse.cz,arnd@arndb.de,anshuman.khandual@arm.com,chenhuacai@loongson.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-refine-__pgdp4dpudpmdpte_alloc_one_-about-highmem.patch removed from -mm tree
Message-Id: <20251120214457.B8FCEC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove unnecessary __GFP_HIGHMEM in __p*d_alloc_one_*()
has been removed from the -mm tree.  Its filename was
     mm-refine-__pgdp4dpudpmdpte_alloc_one_-about-highmem.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Huacai Chen <chenhuacai@loongson.cn>
Subject: mm: remove unnecessary __GFP_HIGHMEM in __p*d_alloc_one_*()
Date: Fri, 7 Nov 2025 17:55:36 +0800

__{pgd,p4d,pud,pmd,pte}_alloc_one_*() always allocate pages with GFP flag
GFP_PGTABLE_KERNEL/GFP_PGTABLE_USER.  These two macros are defined as
follows:

 #define GFP_PGTABLE_KERNEL	(GFP_KERNEL | __GFP_ZERO)
 #define GFP_PGTABLE_USER	(GFP_PGTABLE_KERNEL | __GFP_ACCOUNT)

There is no __GFP_HIGHMEM in them, so we needn't to clear __GFP_HIGHMEM
explicitly.

Link: https://lkml.kernel.org/r/20251109021817.346181-1-chenhuacai@loongson.cn
Link: https://lkml.kernel.org/r/20251107095536.3101371-1-chenhuacai@loongson.cn
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jan Kara <jack@suse.cz>
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


