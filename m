Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54197EC5;
	Sat,  1 Jun 2024 00:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717201913; cv=none; b=tnOOvKrLp6ObqSH3F28VMA3qL0fgVc2/PcNqXX9/cjwZkDwS21PqQxwEBHmELWGKTdPT/YlNhAvGU6Cvh5fgaRof9RJXb9fJVVCJaOMf3Hvfb3fz6kon5AS9qCq4HIGGUmTHZXtf66IRvTuqi/feRuZC0TYJmMcoZ6vG7wuE30Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717201913; c=relaxed/simple;
	bh=fyYaLQCznhvziEAEHDqdDtgbI8WNIFUAbpv5kG1dZvM=;
	h=Date:To:From:Subject:Message-Id; b=BD7wfOCrw5D/EfsgBwPOm2rY9+5y3v/g1LYBKIjrhN6YBwuQESdP8WrBopsxA0HA0F6tAGpW9+0znlQqs1WS7Dzq5ZGOapnwsfTMB7CnRY1jQ9MJUvPIUTKclZA0pGm5pb2XjpKW7GpeDC0aOciYJDC2SpbT2IqsMNTgvLot3Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hO13HGcg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hO13HGcg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A898FC116B1;
	Sat,  1 Jun 2024 00:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717201912;
	bh=fyYaLQCznhvziEAEHDqdDtgbI8WNIFUAbpv5kG1dZvM=;
	h=Date:To:From:Subject:From;
	b=hO13HGcgco+ToeMfEcPNU9Brc46tuqHsHb6O3/cRog3/4GD8VmsNrdDYcXoOfEvLj
	 HHVmJoh6fGHJQ2b6TUfDu0FGvMVbjEsAWxP4ilvbeu6CE+QUGcWMvWwB6tv+mN8+m3
	 cZoxfgxFQf2krQefhR/0s7vuP70dYITaMLooHw/M=
Date: Fri, 31 May 2024 17:31:51 -0700
To: mm-commits@vger.kernel.org,zhaoyang.huang@unisoc.com,xiang@kernel.org,urezki@gmail.com,stable@vger.kernel.org,lstoakes@gmail.com,liuhailong@oppo.com,hch@infradead.org,guangye.yang@mediatek.com,21cnbao@gmail.com,hailong.liu@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmalloc-fix-vbq-free-breakage.patch removed from -mm tree
Message-Id: <20240601003152.A898FC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: fix vbq->free breakage
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-fix-vbq-free-breakage.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: "hailong.liu" <hailong.liu@oppo.com>
Subject: mm/vmalloc: fix vbq->free breakage
Date: Thu, 30 May 2024 17:31:08 +0800

The function xa_for_each() in _vm_unmap_aliases() loops through all vbs. 
However, since commit 062eacf57ad9 ("mm: vmalloc: remove a global
vmap_blocks xarray") the vb from xarray may not be on the corresponding
CPU vmap_block_queue.  Consequently, purge_fragmented_block() might use
the wrong vbq->lock to protect the free list, leading to vbq->free
breakage.

Link: https://lkml.kernel.org/r/20240530093108.4512-1-hailong.liu@oppo.com
Fixes: fc1e0d980037 ("mm/vmalloc: prevent stale TLBs in fully utilized blocks")
Signed-off-by: Hailong.Liu <liuhailong@oppo.com>
Reported-by: Guangye Yang <guangye.yang@mediatek.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Gao Xiang <xiang@kernel.org>
Cc: Guangye Yang <guangye.yang@mediatek.com>
Cc: liuhailong <liuhailong@oppo.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-fix-vbq-free-breakage
+++ a/mm/vmalloc.c
@@ -2830,10 +2830,9 @@ static void _vm_unmap_aliases(unsigned l
 	for_each_possible_cpu(cpu) {
 		struct vmap_block_queue *vbq = &per_cpu(vmap_block_queue, cpu);
 		struct vmap_block *vb;
-		unsigned long idx;
 
 		rcu_read_lock();
-		xa_for_each(&vbq->vmap_blocks, idx, vb) {
+		list_for_each_entry_rcu(vb, &vbq->free, free_list) {
 			spin_lock(&vb->lock);
 
 			/*
_

Patches currently in -mm which might be from hailong.liu@oppo.com are


