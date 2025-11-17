Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99DD277011
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 19:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763406612; cv=none; b=VY9nHult04naiJXw4jnxyNggsqjpOQ38O9kFmIHLMoz2U3miuRt/FdWYlmSBq2wD1TslRUsGcbScYbcN9ZNADe63w+LPrw7uTZjI1q/1VcSQjz5lh9A1e9t95G5HtDDaFA4CmKWikdDB4jYRUUnO4jD/w4pdHfU8cLSdj3AzQhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763406612; c=relaxed/simple;
	bh=5sKUlnZ1ZWwwc1tgbzizQGhrtyCku2/FBQNwDxbqBNo=;
	h=Date:To:From:Subject:Message-Id; b=EP3FjFE6OjB6dANqjJP2OOu8XvjfePAELv2+wVjzB6i/vc4qtaba5zTXqNst+F3gTxDG82YxTpEgCQf6y+Nwopio9nCAX5INCnsSNWS2tCaaCJfoSBV0lfzZ8VwFPAQU9TRbDumm7G0qVc1eVP9fzCT3jAUMMvAgUfYoDvyGRSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kDEJT9a5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kDEJT9a5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF3EC19424;
	Mon, 17 Nov 2025 19:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763406612;
	bh=5sKUlnZ1ZWwwc1tgbzizQGhrtyCku2/FBQNwDxbqBNo=;
	h=Date:To:From:Subject:From;
	b=kDEJT9a5zX2zpGnxXGAgZK4d2wMKtfUgXdtgV1OO9AupYKUXj6oYp2zU3vIwNku49
	 z0TYYs13h/nlFF8GayTVWRlX9aX/GNFDLb7lvsDusKH7Mt7ZAS0sfLSscda382IUpS
	 8/N93Ju0mz8pqxZptZIgEPkijdoJKU6+bPxBxNPU=
Date: Mon, 17 Nov 2025 11:10:10 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,hch@lst.de,hch@infradead.org,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-cleanup-large_gfp-in-vm_area_alloc_pages.patch added to mm-unstable branch
Message-Id: <20251117191011.ECF3EC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: cleanup large_gfp in vm_area_alloc_pages()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-cleanup-large_gfp-in-vm_area_alloc_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-cleanup-large_gfp-in-vm_area_alloc_pages.patch

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
Subject: mm/vmalloc: cleanup large_gfp in vm_area_alloc_pages()
Date: Mon, 17 Nov 2025 09:35:29 -0800

Now that we have already checked for unsupported flags, we can use the
helper function to set the necessary gfp flags for the large order
allocation optimization.

Link: https://lkml.kernel.org/r/20251117173530.43293-4-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
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

mm-madvise-allow-guard-page-install-remove-under-vma-lock.patch
mm-vmalloc-warn-on-invalid-vmalloc-gfp-flags.patch
mm-vmalloc-add-a-helper-to-optimize-vmalloc-allocation-gfps.patch
mm-vmalloc-cleanup-large_gfp-in-vm_area_alloc_pages.patch
mm-vmalloc-cleanup-gfp-flag-use-in-new_vmap_block.patch

