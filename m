Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B449235CBB2
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 22:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762986038; cv=none; b=HU8O8RxF9EwVHl0EZ50gNedq5/fJgFQX1CEdGDw2dQ8+uY9WNa1GRqnQ18kNMnJp+8XE3KsLCr8znHYflDVyM1e/fCIz9rX9px2QAnX4FH6h1QTfybtygI1Fcbw6gPNo+lxG3Y+GoST/BZz2G15lSqTs0OPizIK2V+9BNzDcEHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762986038; c=relaxed/simple;
	bh=CvFhoPH7/rR2kEOV4H9HgH97l6UmokJZdwcEbEIdPzg=;
	h=Date:To:From:Subject:Message-Id; b=ZGCif/tR6xQxSfEd/jUlqkmANFlk0rIYAHqxgoO8HKi8zwmSmWqYUQG0ZWlZG6EIGl0sSwYdWmAMyQU4FR5SKI97sCdOeuwiFX3FyHYEORyqdAsRsplsa4li1WwED5+S3Q3MNrlWByYZRtSFYJdQN6CHmvWdb1K+9XunBMd8Lj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Wnum2lQu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wnum2lQu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 218A4C4CEF1;
	Wed, 12 Nov 2025 22:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762986038;
	bh=CvFhoPH7/rR2kEOV4H9HgH97l6UmokJZdwcEbEIdPzg=;
	h=Date:To:From:Subject:From;
	b=Wnum2lQuv6ZWLgr5zubrzrsqEgDqheEo2Ke/KniBfXAWDMeFI9N6ZkAQnfowYiPQq
	 G2lMe6pGhGQYUbUSwTb1UQx3QdY2z9sqXV15DmX5IZO05wjus5WTdt7xNakbThMzZx
	 r+uAJZhtKgDcecjKhRYslm5qidwMfSRyQpLjmXmI=
Date: Wed, 12 Nov 2025 14:20:37 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,hch@lst.de,hch@infradead.org,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-cleanup-gfp-flag-use-in-new_vmap_block.patch added to mm-new branch
Message-Id: <20251112222038.218A4C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: cleanup gfp flag use in new_vmap_block()
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-cleanup-gfp-flag-use-in-new_vmap_block.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-cleanup-gfp-flag-use-in-new_vmap_block.patch

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
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm/vmalloc: cleanup gfp flag use in new_vmap_block()
Date: Wed, 12 Nov 2025 10:58:33 -0800

The only caller, vb_alloc(), passes GFP_KERNEL into new_vmap_block() which
is a subset of GFP_RECLAIM_MASK.  Since there's no reason to use this mask
here, remove it.

Link: https://lkml.kernel.org/r/20251112185834.32487-5-vishal.moola@gmail.com
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

mm-vmalloc-request-large-order-pages-from-buddy-allocator.patch
mm-madvise-allow-guard-page-install-remove-under-vma-lock.patch
mm-vmalloc-warn-on-invalid-vmalloc-gfp-flags.patch
mm-vmalloc-add-a-helper-to-optimize-vmalloc-allocation-gfps.patch
mm-vmalloc-cleanup-large_gfp-in-vm_area_alloc_pages.patch
mm-vmalloc-cleanup-gfp-flag-use-in-new_vmap_block.patch

