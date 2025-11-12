Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF132EB874
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 22:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762986037; cv=none; b=Ne/lqR4NTUkj6sZ4hzTuNhfqqSSZ2aYiq9uS2y7L9/Jr9aoKaXOwhRbTsVSaLVEhOX1rc2fmfnRZjCQ5xI8rUMjri5686Ok4k0aWVs0roLaTQQ1QgmxwVVEMSCOcplnhPDPWypc1vO69gdIkg2kH3QqzjpdG6lljnNSjtXM9etc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762986037; c=relaxed/simple;
	bh=Haxlrj4+vJMW6z69rOjU6sQxrzFNPmwfTAuW+/G50jU=;
	h=Date:To:From:Subject:Message-Id; b=O5xLpWyNT+BMbU2E/stXziu63JRxD9/AEdt847KW8uBk0ehq8Z7M43SEZXgHykXU/ViNTioIaWwuVt2D9hDYvG/e41u5zYhGOjL6+IYU9rH+G6Bwsw61lKmDStXB3oCnfgFJRcZboqmBzIO5+RyiSg0lDQgHxm4AfJxY9poI8hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0krxk0GF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0krxk0GF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06666C4CEF8;
	Wed, 12 Nov 2025 22:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762986037;
	bh=Haxlrj4+vJMW6z69rOjU6sQxrzFNPmwfTAuW+/G50jU=;
	h=Date:To:From:Subject:From;
	b=0krxk0GFmnbpj82/Eww9wPllysb5iJm5G42Xe13J2Es8PyiCb2bF0WkXDZVREciXF
	 gl5JJABxb7qe+urg6yc7o0vI7z1aYCfKgg0M18WYFWX6xtfkhVbYvTaB2+4L3my1/U
	 NZWJMiyZPY0Etyx1RweAH0ZlBzJfGhKmebG5EvUs=
Date: Wed, 12 Nov 2025 14:20:36 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,hch@lst.de,hch@infradead.org,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-cleanup-large_gfp-in-vm_area_alloc_pages.patch added to mm-new branch
Message-Id: <20251112222037.06666C4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: cleanup large_gfp in vm_area_alloc_pages()
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-cleanup-large_gfp-in-vm_area_alloc_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-cleanup-large_gfp-in-vm_area_alloc_pages.patch

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
Subject: mm/vmalloc: cleanup large_gfp in vm_area_alloc_pages()
Date: Wed, 12 Nov 2025 10:58:32 -0800

Now that we have already checked for unsupported flags, we can use the
helper function to set the necessary gfp flags for the large order
allocation optimization.

Link: https://lkml.kernel.org/r/20251112185834.32487-4-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-cleanup-large_gfp-in-vm_area_alloc_pages
+++ a/mm/vmalloc.c
@@ -3634,10 +3634,8 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 	unsigned int max_attempt_order = MAX_PAGE_ORDER;
 	struct page *page;
 	int i;
-	gfp_t large_gfp = (gfp &
-		~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL | __GFP_COMP))
-		| __GFP_NOWARN;
 	unsigned int large_order = ilog2(nr_remaining);
+	gfp_t large_gfp = vmalloc_gfp_adjust(gfp, large_order) & ~__GFP_DIRECT_RECLAIM;
 
 	large_order = min(max_attempt_order, large_order);
 
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-vmalloc-request-large-order-pages-from-buddy-allocator.patch
mm-madvise-allow-guard-page-install-remove-under-vma-lock.patch
mm-vmalloc-warn-on-invalid-vmalloc-gfp-flags.patch
mm-vmalloc-add-a-helper-to-optimize-vmalloc-allocation-gfps.patch
mm-vmalloc-cleanup-large_gfp-in-vm_area_alloc_pages.patch
mm-vmalloc-cleanup-gfp-flag-use-in-new_vmap_block.patch

