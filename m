Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC20322A
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 00:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763599001; cv=none; b=QmzxG8JF3EiJevrm+cm1fXQSiMRm5CQtgDK7go2TS1s4eSA1ZxlM+GPJkjC6jffkig+D3eaCIzwp6YIGin2gYWSE+EQw3rXNS/TTdOyQBuT3uTKN4hbLfZTW9h7XGqihTqei5PEL4swYfduY6HG4eYmKMEhO/cJWEQq5kiV8oZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763599001; c=relaxed/simple;
	bh=60aS4BJBcevWhD9jyBchts96xJeyi8oWXFa8lAaVU/k=;
	h=Date:To:From:Subject:Message-Id; b=PQoH5ulf7Y0p643d+0e1Am5AIVsp139wEuDCwzQiCJJ4d8Nqkvls4u/D34J2VqYHeG6F9rRkpyTGrtmBgUCemGHG1zBQwEoFSokxiNjRzxkq5PIlHFNYcVx+ugxzw4MF7WqPmDTM5BLIc8sHXkFLrEAP6iuo2cDFi5JUXElHlDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CGQQxHIW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CGQQxHIW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C6E6C116D0;
	Thu, 20 Nov 2025 00:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763599000;
	bh=60aS4BJBcevWhD9jyBchts96xJeyi8oWXFa8lAaVU/k=;
	h=Date:To:From:Subject:From;
	b=CGQQxHIWVrBKgncrsPzYdF48LWIR15HGZ/pDu+tOMu1Fn1rmiLfneKBfFQlfu5eLG
	 jESpve/QHEmFPv7x0ZD0sVuS/tTB9IAQBNu6KUbiHaDDKacyVKUjL9/3Kmr9DJDRp+
	 UMrlKZ2t6h6aYC6kDtdmPgfNTBM62wOjetGy+Ys0=
Date: Wed, 19 Nov 2025 16:36:39 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,hch@lst.de,hch@infradead.org,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmalloc-cleanup-gfp-flag-use-in-new_vmap_block.patch removed from -mm tree
Message-Id: <20251120003640.7C6E6C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: cleanup gfp flag use in new_vmap_block()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-cleanup-gfp-flag-use-in-new_vmap_block.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm/vmalloc: cleanup gfp flag use in new_vmap_block()
Date: Mon, 17 Nov 2025 09:35:30 -0800

The only caller, vb_alloc(), passes GFP_KERNEL into new_vmap_block() which
is a subset of GFP_RECLAIM_MASK.  Since there's no reason to use this mask
here, remove it.

Link: https://lkml.kernel.org/r/20251117173530.43293-5-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
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

mm-madvise-allow-guard-page-install-remove-under-vma-lock.patch

