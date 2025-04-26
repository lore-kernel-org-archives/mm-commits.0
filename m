Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5D7282EE
	for <mm-commits@vger.kernel.org>; Sat, 26 Apr 2025 01:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745629616; cv=none; b=nQ8s03q3ZdDZa6qakL3JMMSU1G7wAgzNqeVaDtc089sY++KgPe3ZMm28le6UV38uPDEJ6Tiyq0/czrtMBN5uOnG13IXFLcBsVbm5mLjx4F1tGNghPGxi0cw3krbs9+T+yWLMu77BE/62XQx2SbyTfarmNtZmDpmmUhtXKEBTRKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745629616; c=relaxed/simple;
	bh=+yenY8L2WRIGNuSscaI0bxZq3o9FFqytMAHvPQPsXC4=;
	h=Date:To:From:Subject:Message-Id; b=r+32zEjhwM0S0s6OTh/XjGMkUerfHxU6FLy2VI8pX2N3rhAlov2qpLSJYXqdmueZtKwR++S30ez4jmLbpr9gTvlgUKai5RJV3GAecx0e+BIq4GJ0UIM9Vxuozg3bdIVWp7VkKDhmTG6EqofPjq0GFlr9U9GB98/p6945e1VXPHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=af7Lj+Kr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="af7Lj+Kr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A31E7C4CEE4;
	Sat, 26 Apr 2025 01:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745629615;
	bh=+yenY8L2WRIGNuSscaI0bxZq3o9FFqytMAHvPQPsXC4=;
	h=Date:To:From:Subject:From;
	b=af7Lj+Krf3YiIjdsgk4O8Dq4Gp6TSvehmUDQ8XCCs9RT7LtrMCv0/k4YAF5+Cuvyz
	 NLZH/8nM9VQOyzkUQ3ppc5TvF1fHvoERGwMPWSHTyio3JD3EQS0WZGLQLLtJyZ4Yr/
	 pauQ850c3BhIu2A5HqhqIpCbfGyTErw+WFzq0fyU=
Date: Fri, 25 Apr 2025 18:06:55 -0700
To: mm-commits@vger.kernel.org,yajun.deng@linux.dev,tsbogend@alpha.franken.de,rppt@kernel.org,jiaxun.yang@flygoat.com,huangpei@loongson.cn,dwmw2@infradead.org,chenhuacai@kernel.org,bercantu@amazon.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memblock-fix-arguments-passed-to-memblock_set_node.patch added to mm-hotfixes-unstable branch
Message-Id: <20250426010655.A31E7C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memblock: fix arguments passed to memblock_set_node()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memblock-fix-arguments-passed-to-memblock_set_node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memblock-fix-arguments-passed-to-memblock_set_node.patch

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
From: "Bernardo C. Gutierrez Cantu" <bercantu@amazon.de>
Subject: mm: memblock: fix arguments passed to memblock_set_node()
Date: Fri, 25 Apr 2025 10:20:03 +0000

memblock_set_node() receives a `base` and a `size` arguments, but we are
passing the `start` and `end` of the memory regions when iterating over
them in memmap_init_reserved_pages() to set their node ids.

This results in the function setting the node ids for the reserved memory
regions in `[base, base + base + size)` instead of `[base, base + size)`.

Pass `start` and `size`, so that we iterate over the correct range.

Link: https://lkml.kernel.org/r/20250425102003.64122-1-bercantu@amazon.de
Fixes: 61167ad5fecd ("mm: pass nid to reserve_bootmem_region()")
Signed-off-by: Bernardo C. Gutierrez Cantu <bercantu@amazon.de>
Acked-by: David Woodhouse <dwmw2@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Yajun Deng <yajun.deng@linux.dev>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Huang Pei <huangpei@loongson.cn>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memblock.c~mm-memblock-fix-arguments-passed-to-memblock_set_node
+++ a/mm/memblock.c
@@ -2196,7 +2196,7 @@ static void __init memmap_init_reserved_
 		if (memblock_is_nomap(region))
 			reserve_bootmem_region(start, end, nid);
 
-		memblock_set_node(start, end, &memblock.reserved, nid);
+		memblock_set_node(start, region->size, &memblock.reserved, nid);
 	}
 
 	/*
_

Patches currently in -mm which might be from bercantu@amazon.de are

mm-memblock-fix-arguments-passed-to-memblock_set_node.patch

