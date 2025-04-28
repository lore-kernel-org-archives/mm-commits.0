Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400D81AAA1E
	for <mm-commits@vger.kernel.org>; Mon, 28 Apr 2025 14:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745850376; cv=none; b=q3/9DG26BqVt2Q5a/ILOwWp3cKc+c8eBez1Vyle4z8Sl7ztMHwfXSpxfOB7aukLHykhSKtmDwl7NplyGIqiFaCtbMSC3XkFdeVQCqcIUx7R1s6/DCruNX34KuyjXO3JLVlDzUX9wcZGyXd4VQTvPWXyMs71LqSup7Ro6eVXXgKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745850376; c=relaxed/simple;
	bh=6//LtWHUzDvujhYO5CDnQOa1qW8OrZUPJHvPhG8v1t8=;
	h=Date:To:From:Subject:Message-Id; b=sticDLk49pSQfQz4tu75EUX/R9xlvcc5WfJjr/LMhIyS0LIu9G/M0iNoGRzyJ+KZdEbd0PT/hjQdV1fjbXJ9iqqvc9/WT8eREYnL4zwgJZdTWeeSto0dHOTwM4XiTSY9ny30Dh0ygNZ9rQpmnGt+8/VtWWiWaWWjUhZi5PNtW7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LxDWpHpQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LxDWpHpQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86CB2C4CEE4;
	Mon, 28 Apr 2025 14:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745850374;
	bh=6//LtWHUzDvujhYO5CDnQOa1qW8OrZUPJHvPhG8v1t8=;
	h=Date:To:From:Subject:From;
	b=LxDWpHpQGk1HjXtDT0UjQKQW9O2cKTFpJV+ZuLso/2jdJbxXuur5fHlCMkdmB/Ds5
	 xsifxEfy/jQbElTySBAeD0HgDhGe3c6Ttf/tj/ardElp9K/TCxew3temp/CAeEqE9U
	 0KKpqqmz1go8qCxvQpqxbkzFwV2NvHHBD5oNK8+w=
Date: Mon, 28 Apr 2025 07:26:13 -0700
To: mm-commits@vger.kernel.org,yajun.deng@linux.dev,tsbogend@alpha.franken.de,rppt@kernel.org,jiaxun.yang@flygoat.com,huangpei@loongson.cn,dwmw2@infradead.org,chenhuacai@kernel.org,bercantu@amazon.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-memblock-fix-arguments-passed-to-memblock_set_node.patch removed from -mm tree
Message-Id: <20250428142614.86CB2C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memblock: fix arguments passed to memblock_set_node()
has been removed from the -mm tree.  Its filename was
     mm-memblock-fix-arguments-passed-to-memblock_set_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


