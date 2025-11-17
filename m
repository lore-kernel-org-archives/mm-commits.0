Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA295258CE2
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 19:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763406615; cv=none; b=XGQYPKE9m4w99XxNAGV1SfYj0/6Hc7yvHAwWjbXQ43hqkCx+0ahoGs1GnDHBFWbuI/kHSwPUhPm328UivroBNQwusE8z3hkMxIxSkXEusWaHYkavyXeZo+hHdBVJ/Cx82X8gdWt7t3to4MKaS6rj6RiW8WZohZg+cGda8LXQneY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763406615; c=relaxed/simple;
	bh=L5yfEWt8fCf21vM9oWXrx4+5iAoOW+VahizpjAaMkgM=;
	h=Date:To:From:Subject:Message-Id; b=VI7kYtGr8RYWf0jPeiPoSB7rRZCn0ROpv61TbTs39Ic9wXHeZR9yAY4UGR4NJFD5jHjKNtgIZ59HUhe2H3zeqYhSmSx6+VNaVuWCyo1a8ryhBAUY0zx9tEkEY7sFGXxWLvrXjBcft7143PACoHdRy1zotYFeqADjlBJ5B+a6cgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GHvLAipU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GHvLAipU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C60C19421;
	Mon, 17 Nov 2025 19:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763406615;
	bh=L5yfEWt8fCf21vM9oWXrx4+5iAoOW+VahizpjAaMkgM=;
	h=Date:To:From:Subject:From;
	b=GHvLAipUbUMqmBNao6dvpWKG7Z/QweRcP1e1ZDhLhOJay4e+ML/2ELznnhxVdwOak
	 A9r0SJsQE02KqReXO/E3X870FO0wSUPXkRomTqzxCmn22Myta0pkEt+ByCdW6AX3NJ
	 tDw15Kpj75rdC2Gxdha8q2Th38fQYl1fdFoIWcUo=
Date: Mon, 17 Nov 2025 11:10:13 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,hch@lst.de,hch@infradead.org,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-cleanup-gfp-flag-use-in-new_vmap_block.patch added to mm-unstable branch
Message-Id: <20251117191014.E0C60C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: cleanup gfp flag use in new_vmap_block()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-cleanup-gfp-flag-use-in-new_vmap_block.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-cleanup-gfp-flag-use-in-new_vmap_block.patch

This patch will later appear in the mm-unstable branch at
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
mm-vmalloc-warn-on-invalid-vmalloc-gfp-flags.patch
mm-vmalloc-add-a-helper-to-optimize-vmalloc-allocation-gfps.patch
mm-vmalloc-cleanup-large_gfp-in-vm_area_alloc_pages.patch
mm-vmalloc-cleanup-gfp-flag-use-in-new_vmap_block.patch

