Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2C12BF3F3
	for <mm-commits@vger.kernel.org>; Fri,  2 Oct 2026 01:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790903805; cv=none; b=jdbeH2fDp/sUGTYy90hlNqKR8X3ncNe2uoVYPDOtlEQxwKSEJHTxFBZJSywgNiNvYFpYWyO4bFeznU6Z1JO59i5WwVH9On5pmVh3NF3uMMBcPhAG8DprfXPy9S3fG6VYXzxCSu5Jtx6Gi2jkaogxAf0DQRgYbhGYaZpAwwuvdA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790903805; c=relaxed/simple;
	bh=4TcUko5cL3g8DkBag9eHYqv31jKSA16G+gbXaFuCxRw=;
	h=Date:To:From:Subject:Message-Id; b=hDkVpAbr5lFYFgvIl/T24+fpW3Zq0U6qz61OJPFc+tWJon5n+N0rf7m11ycIWAmPGzPRbRGSaBoP2+I3GzUDAjlMbh2Pjs3nJUoVaEdFpvOBQnJG4oMwQnm3CuyreewzMdu9D1VHJ9buaN7fiT3WDZNbUUmwu7nEwXhYQPQJquk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lehvXaSH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lehvXaSH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA7A1F00898;
	Fri,  2 Oct 2026 01:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790903799;
	bh=e4bFBaQ/fqKihP3WbgHw7qsiRLG+reuepD98DZTRm7s=;
	h=Date:To:From:Subject;
	b=lehvXaSHk3hT3pBTIrxrwPJJiy14eTnVvOM7C53UklBpYoWYx80D38W2v4ksb32Zp
	 uQ41u9MzUsbreSqg/MCK7grOEUHjJWfWOoZo55EB6cYkb6jVtJq4Sq8VEQa2MJZgvA
	 tgXnC6ICC1OIJ7H7Y3CVmVQxy2nVoRB4YU8OlF5Y=
Date: Thu, 01 Oct 2026 18:16:39 -0700
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,joshua.hahnjy@gmail.com,hch@lst.de,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,alex@ghiti.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-submit-the-last-readahead-batch-before-unplugging.patch added to mm-new branch
Message-Id: <20261002011639.6DA7A1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap: submit the last readahead batch before unplugging
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-submit-the-last-readahead-batch-before-unplugging.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-submit-the-last-readahead-batch-before-unplugging.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Alexandre Ghiti <alex@ghiti.fr>
Subject: mm/swap: submit the last readahead batch before unplugging
Date: Thu,  1 Oct 2026 10:57:12 +0200

Since block swap I/O is batched in struct swap_iocb, swap_add_folio() only
appends a folio to the pending batch when its slot directly follows the
previous one, and submits the pending batch otherwise.  Batches submitted
inside the readahead loop go through the plug, where the block layer can
still merge them, but the final batch is submitted after blk_finish_plug()
and always becomes a separate request.

So submit the final batch before finishing the plug.

Link: https://lore.kernel.org/20261001085730.2029773-1-alex@ghiti.fr
Fixes: dda8fb68b590 ("mm/swap: also use struct swap_iocb for block I/O")
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>
---

 mm/swap_state.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/swap_state.c~mm-swap-submit-the-last-readahead-batch-before-unplugging
+++ a/mm/swap_state.c
@@ -906,8 +906,8 @@ struct folio *swap_cluster_readahead(swp
 			continue;
 		folio_put(folio);
 	}
-	blk_finish_plug(&plug);
 	swap_read_submit(&ctx);
+	blk_finish_plug(&plug);
 skip:
 	return swap_cache_read_folio_sync(entry, gfp_mask, mpol, ilx);
 }
@@ -1019,8 +1019,8 @@ static struct folio *swap_vma_readahead(
 	}
 	if (pte)
 		pte_unmap(pte);
-	blk_finish_plug(&plug);
 	swap_read_submit(&ctx);
+	blk_finish_plug(&plug);
 skip:
 	/* The folio was likely read above, so no need for plugging here */
 	return swap_cache_read_folio_sync(targ_entry, gfp_mask, mpol, targ_ilx);
_

Patches currently in -mm which might be from alex@ghiti.fr are

mm-swap-move-lru-insertion-out-of-the-swap-cache-allocator.patch
mm-swap-drop-dropbehind-swap-cache-folios-on-writeback-completion.patch
mm-zswap-drop-cold-writeback-folios-via-swap-dropbehind.patch
mm-swap-submit-the-last-readahead-batch-before-unplugging.patch

