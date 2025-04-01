Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82BED1D79B8;
	Tue,  1 Apr 2025 22:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743546078; cv=none; b=RdLZreWqg+WbnCOZeeMyMJIEjUHitIP+QIzyjCh4KdnH9SDLRxJrbhJcQEa+Tf9aL2AiIiOiFNV9qWv56uSS6y9J5HMe/o+8ZT93Dcm0A8dtukEI2xbC4YhEzgb81ev7XvqOOWvzliuMPq7Ks+5wehcASsuNR0LY56TNa2hSI1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743546078; c=relaxed/simple;
	bh=78ddjpxOz+Akg7Ngn0H50V79Nh4PJysWjECs4tKZfng=;
	h=Date:To:From:Subject:Message-Id; b=jyP4TJmmIpc3ULbmHPha7S007ive81+FT7rCQnfUaTdz9z+hixxYl8hI+btb2iDJP83Vqw1XlVxqWZ2AlJT3ulDBS4hV1TFhxCHix6h6lzoHssak1GdT6GmXMf0TLj8FUcitBGI7dCOtwPoYxDNK8UVgKP7hpc6AwMthwyDPko8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fmffdPhk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fmffdPhk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A624C4CEE4;
	Tue,  1 Apr 2025 22:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743546078;
	bh=78ddjpxOz+Akg7Ngn0H50V79Nh4PJysWjECs4tKZfng=;
	h=Date:To:From:Subject:From;
	b=fmffdPhka7JqNhsIEyyDnd8nBv+jhq8D/2ciOyixdS7IC/N94A8m3ycR7MYnD7jWr
	 bfS+j5aSgSbzIbTPZRN0f6xX1VWArHQrUUS5aCGEy6CCZRuCxo/DyuaWVFmHaofiPV
	 Xb+3LacbbyxTamR/Zi7/OKHFq/hiRP0KxkHgudAo=
Date: Tue, 01 Apr 2025 15:21:17 -0700
To: mm-commits@vger.kernel.org,vigneshr@ti.com,stable@vger.kernel.org,robert.jarzmik@free.fr,praneeth@ti.com,kamlesh@ti.com,axboe@kernel.dk,t-pratham@ti.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-scatterlist-fix-sg_split_phys-to-preserve-original-scatterlist-offsets.patch removed from -mm tree
Message-Id: <20250401222118.5A624C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: scatterlist: fix sg_split_phys to preserve original scatterlist offsets
has been removed from the -mm tree.  Its filename was
     lib-scatterlist-fix-sg_split_phys-to-preserve-original-scatterlist-offsets.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: T Pratham <t-pratham@ti.com>
Subject: lib: scatterlist: fix sg_split_phys to preserve original scatterlist offsets
Date: Wed, 19 Mar 2025 16:44:38 +0530

The split_sg_phys function was incorrectly setting the offsets of all
scatterlist entries (except the first) to 0.  Only the first scatterlist
entry's offset and length needs to be modified to account for the skip. 
Setting the rest entries' offsets to 0 could lead to incorrect data
access.

I am using this function in a crypto driver that I'm currently developing
(not yet sent to mailing list).  During testing, it was observed that the
output scatterlists (except the first one) contained incorrect garbage
data.

I narrowed this issue down to the call of sg_split().  Upon debugging
inside this function, I found that this resetting of offset is the cause
of the problem, causing the subsequent scatterlists to point to incorrect
memory locations in a page.  By removing this code, I am obtaining
expected data in all the split output scatterlists.  Thus, this was indeed
causing observable runtime effects!

This patch removes the offending code, ensuring that the page offsets in
the input scatterlist are preserved in the output scatterlist.

Link: https://lkml.kernel.org/r/20250319111437.1969903-1-t-pratham@ti.com
Fixes: f8bcbe62acd0 ("lib: scatterlist: add sg splitting function")
Signed-off-by: T Pratham <t-pratham@ti.com>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kamlesh Gurudasani <kamlesh@ti.com>
Cc: Praneeth Bajjuri <praneeth@ti.com>
Cc: Vignesh Raghavendra <vigneshr@ti.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/sg_split.c |    2 --
 1 file changed, 2 deletions(-)

--- a/lib/sg_split.c~lib-scatterlist-fix-sg_split_phys-to-preserve-original-scatterlist-offsets
+++ a/lib/sg_split.c
@@ -88,8 +88,6 @@ static void sg_split_phys(struct sg_spli
 			if (!j) {
 				out_sg->offset += split->skip_sg0;
 				out_sg->length -= split->skip_sg0;
-			} else {
-				out_sg->offset = 0;
 			}
 			sg_dma_address(out_sg) = 0;
 			sg_dma_len(out_sg) = 0;
_

Patches currently in -mm which might be from t-pratham@ti.com are


