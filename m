Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3812EC0A7
	for <mm-commits@vger.kernel.org>; Mon, 10 Nov 2025 19:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762801913; cv=none; b=pMLVRIS4oSY3jCgY1EzI0B3iu30VqQk9bbqx5qkd8h9Zvv5zIqX5fWnLpstjTsLprsgeez7dQTDQehtNfRYti8rshnMsBH7XFEjSFlO5ef3ANkajgpPdkjsUFmfsqSN1JaHYtd0pTaiQVH7B66FY/djkc/JbzbgsAqe5wmhbu0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762801913; c=relaxed/simple;
	bh=n7zcBcJGwUowEtUGbvKQ+fB6sCoe3BuDBmFavnXTwts=;
	h=Date:To:From:Subject:Message-Id; b=q/0t3XZb0NQsTtDv5yVItJqL0x/ScE1sCokqV6dfChi5ksXxzNJ3PQZMuDLEz2bW5RWez7zKmVin1xFIFSBmJQx/i16h/4lBv4uOU59+fvvjKXRiSXfoSz3Suv/DDgJxjYU3pz8umXTuiSxjZlpNMHUDJ/mRam473vE6xNki+Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZB7dVWoz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZB7dVWoz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ABBBC4CEF5;
	Mon, 10 Nov 2025 19:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762801912;
	bh=n7zcBcJGwUowEtUGbvKQ+fB6sCoe3BuDBmFavnXTwts=;
	h=Date:To:From:Subject:From;
	b=ZB7dVWozsnCub04tqb9JE97EEjajtPEB3v4ZbyWdTVlEVoO0Q5iH9uJiA7nOHxsPa
	 nqvZlNrJaigkEjrSpmyvCvouCOX1L6nWPwPaQ9//Iy7c5rXGrwfKwY4V2zM6KjhSOA
	 /+/eYXy89pCiWB4nljcymBXpaNek+3tEwcP5gvrE=
Date: Mon, 10 Nov 2025 11:11:51 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,hch@lst.de,hch@infradead.org,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-cleanup-large_gfp-in-vm_area_alloc_pages.patch added to mm-new branch
Message-Id: <20251110191152.5ABBBC4CEF5@smtp.kernel.org>
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
Date: Mon, 10 Nov 2025 08:04:56 -0800

Now that we have already checked for unsupported flags, we can use the
helper function to set the necessary gfp flags for the large order
allocation optimization.

Link: https://lkml.kernel.org/r/20251110160457.61791-4-vishal.moola@gmail.com
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
mm-vmalloc-warn-on-invalid-vmalloc-gfp-flags.patch
mm-vmalloc-add-a-helper-to-optimize-vmalloc-allocation-gfps.patch
mm-vmalloc-cleanup-large_gfp-in-vm_area_alloc_pages.patch
mm-vmalloc-cleanup-gfp-flag-use-in-new_vmap_block.patch

