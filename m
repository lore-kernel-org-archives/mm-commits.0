Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F4C1862
	for <mm-commits@vger.kernel.org>; Fri, 21 Nov 2025 16:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763743434; cv=none; b=tDRXWKCVQu4QYFhrh+KrrSI2YpVLpChWrmLbp51grp0btakj8TFPVUbE3aqIKExxRfXleAGxSpIok0yWHa2jOd8VQKDQ5GCFrQtzMYDs34VidhbHeU3ozGTQsgkwLDCzwDS6sM6+S5UwGr5knrd1py1YS3XjpbMNjT4hYgAaCZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763743434; c=relaxed/simple;
	bh=j05EjTlrz4TLCuZKBsGwjEsv+L3H8u84OlBrXOGiVHk=;
	h=Date:To:From:Subject:Message-Id; b=mreUI3o3e2ZdA/pdqvTJ+AKzmr72PjewVMsvZpCgqILXqFeTNQZQZt50tM6Pcu3jsvzHfeFd5lj0Tct9WRZ5jP0TbdsBAOx7v2nKknKi+6iR9B69LSVNX9LFYzTPnLcZToepwULqbWcviHBT2qhQZLgOceyKCW5vW6s6FiS0yus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z0SeZvOO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z0SeZvOO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC89C116C6;
	Fri, 21 Nov 2025 16:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763743434;
	bh=j05EjTlrz4TLCuZKBsGwjEsv+L3H8u84OlBrXOGiVHk=;
	h=Date:To:From:Subject:From;
	b=z0SeZvOOTCStRwQdJ276FHHCLmtHYEHJRYawDpMp4moGnDK5D2glO00vPOYOCB/XO
	 MmweweZlSz8KKeGcr5RRGfoTXTjjMA4u2jp0kCoMK6VqUAto3dax4tQuxSdUBkfGD2
	 BSW6YaPMfW0pqXWwnQMTKIjB7rAHVD4TO+WtxVnY=
Date: Fri, 21 Nov 2025 08:43:53 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,sj@kernel.org,hch@infradead.org,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-cleanup-gfp-flag-use-in-new_vmap_block.patch added to mm-unstable branch
Message-Id: <20251121164354.6BC89C116C6@smtp.kernel.org>
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

mm-vmalloc-warn-on-invalid-vmalloc-gfp-flags.patch
mm-vmalloc-add-a-helper-to-optimize-vmalloc-allocation-gfps.patch
mm-vmalloc-cleanup-large_gfp-in-vm_area_alloc_pages.patch
mm-vmalloc-cleanup-gfp-flag-use-in-new_vmap_block.patch

