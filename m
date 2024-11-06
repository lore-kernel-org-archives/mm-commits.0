Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572E818BBAE
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855669; cv=none; b=e6svdgzRn3KFKLy4tsTW0B7OC6Gf/aG7ynisB+JXhaojydeCoFavGEKz8Ns0iH1EzEjoKuMY6SB6aHOC+c73odbmQdz8oxBTYimfUENsKCk3GkUrrHlQ/+VeepSVqzQKXECdjU2pMuGMbDhlJvJTRdAifPu2Wa7hFUfR+Ksfnpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855669; c=relaxed/simple;
	bh=cRz6kUoSaBui+LRGz54oWuYsY6fr+2xf5jRSc0FAhDo=;
	h=Date:To:From:Subject:Message-Id; b=V0oEkmDLFwXTv4/k5FYVXWUKh9IfMKBhdxjz4MlKuLcbGENDGDyUoBpNEynbpO6HnePbwA2s22GuXLHp8s8i/NlYlVMAU6s9uzy1hNkpGi+E7cDgSkL0iIMtUA6tVemqC3Mt/G/hwiKNnIIidzidJ1fEHiZeMp0uV/hJ4s6ox3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ROi47QyQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ROi47QyQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB2FC4CECF;
	Wed,  6 Nov 2024 01:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855669;
	bh=cRz6kUoSaBui+LRGz54oWuYsY6fr+2xf5jRSc0FAhDo=;
	h=Date:To:From:Subject:From;
	b=ROi47QyQB/WVZR4TZWoGxpn8F6nCEVZNuUuNrl1YO/GdgaAg+QxWWn8JtFoagOz/Q
	 PzGe/I6J/iFkAwFLnKYS3YbSU2fM9v7sPkc+sXWmyt9MpqiahW3MM8bgr3qoz4fH2B
	 Wa4qG0SkAIW5uCnXHVc5nkSD0s4U6Dpl2yz38uEY=
Date: Tue, 05 Nov 2024 17:14:28 -0800
To: mm-commits@vger.kernel.org,sui.jingfeng@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-scatterlist-use-sg_phys-helper.patch removed from -mm tree
Message-Id: <20241106011429.2DB2FC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/scatterlist: use sg_phys() helper
has been removed from the -mm tree.  Its filename was
     lib-scatterlist-use-sg_phys-helper.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sui Jingfeng <sui.jingfeng@linux.dev>
Subject: lib/scatterlist: use sg_phys() helper
Date: Tue, 29 Oct 2024 02:29:20 +0800

This shorten the length of code in horizential direction, therefore is
easier to read.

Link: https://lkml.kernel.org/r/20241028182920.1025819-1-sui.jingfeng@linux.dev
Signed-off-by: Sui Jingfeng <sui.jingfeng@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/scatterlist.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/scatterlist.c~lib-scatterlist-use-sg_phys-helper
+++ a/lib/scatterlist.c
@@ -474,14 +474,14 @@ int sg_alloc_append_table_from_pages(str
 		return -EOPNOTSUPP;
 
 	if (sgt_append->prv) {
-		unsigned long next_pfn = (page_to_phys(sg_page(sgt_append->prv)) +
-			sgt_append->prv->offset + sgt_append->prv->length) / PAGE_SIZE;
+		unsigned long next_pfn;
 
 		if (WARN_ON(offset))
 			return -EINVAL;
 
 		/* Merge contiguous pages into the last SG */
 		prv_len = sgt_append->prv->length;
+		next_pfn = (sg_phys(sgt_append->prv) + prv_len) / PAGE_SIZE;
 		if (page_to_pfn(pages[0]) == next_pfn) {
 			last_pg = pfn_to_page(next_pfn - 1);
 			while (n_pages && pages_are_mergeable(pages[0], last_pg)) {
_

Patches currently in -mm which might be from sui.jingfeng@linux.dev are


