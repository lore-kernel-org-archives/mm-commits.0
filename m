Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF30335073
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025863; cv=none; b=qv81e9yJwI0l8welkwNxuAe0Bdh4n3J1hsGL87eJGHCTDKXMEF+SdFJYbRE+uFDraPd8Pym1Ji/65qRh3RBnqpVBrU15uhXNgDUYRYE32klsjGxNW+1jeLti7/KjNhEM2YmuonU9KzTLi6sMEuHR/GM2g2W22Ik7Z+Pb4zPKbP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025863; c=relaxed/simple;
	bh=SCLlR/O2feFu+P/7FQBqzfSPS5Tby/EaDRACwVxIZKY=;
	h=Date:To:From:Subject:Message-Id; b=qHN81e/WaFx1ZTra6qthzLpaSrJgPEdmkAqDx/+IQ0+/sBASXKeEhpf0zJlEWFVa1V+TVAxLYdTajAQidU+XJzYrVD0PnKdvsX05lCol6loeH7XiH63fqyp6hNC+IVhEkmGHYPSaBH9EFToJobKioXeyPnYHKl/WDr+MjLMT/Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IkWzWxh6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IkWzWxh6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 044C8C4CEF1;
	Mon, 24 Nov 2025 23:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025862;
	bh=SCLlR/O2feFu+P/7FQBqzfSPS5Tby/EaDRACwVxIZKY=;
	h=Date:To:From:Subject:From;
	b=IkWzWxh6EnsRuH3CRg+1kKYw9Cw1g6CV18ekmDVx4TUzk2hiXU4iVlF1x80LvPYJV
	 b3IsX1xPnwP1u2Cjsx9BLZeAW/Uv11mSsvUo/mbEJotJxDkPtwpCygEF30sCO6rKmO
	 lLQ4JASH7C7veF0/eOkF8l9KG3HygcpZZqMvoJo8=
Date: Mon, 24 Nov 2025 15:11:01 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,sj@kernel.org,hch@infradead.org,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-cleanup-gfp-flag-use-in-new_vmap_block.patch removed from -mm tree
Message-Id: <20251124231102.044C8C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: cleanup gfp flag use in new_vmap_block()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-cleanup-gfp-flag-use-in-new_vmap_block.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm/vmalloc: cleanup gfp flag use in new_vmap_block()
Date: Fri, 21 Nov 2025 01:44:05 -0800

The only caller, vb_alloc(), passes GFP_KERNEL into new_vmap_block() which
is a subset of GFP_RECLAIM_MASK.  Since there's no reason to use this mask
here, remove it.

Link: https://lkml.kernel.org/r/20251121094405.40628-5-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Acked-by: SeongJae Park <sj@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-cleanup-gfp-flag-use-in-new_vmap_block
+++ a/mm/vmalloc.c
@@ -2699,8 +2699,7 @@ static void *new_vmap_block(unsigned int
 
 	node = numa_node_id();
 
-	vb = kmalloc_node(sizeof(struct vmap_block),
-			gfp_mask & GFP_RECLAIM_MASK, node);
+	vb = kmalloc_node(sizeof(struct vmap_block), gfp_mask, node);
 	if (unlikely(!vb))
 		return ERR_PTR(-ENOMEM);
 
_

Patches currently in -mm which might be from vishal.moola@gmail.com are


