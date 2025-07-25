Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4922E21D590
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 02:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409706; cv=none; b=QJSpvFVQEYOlAeEfw72nXq0T8dfxCTM2uEdwjTM/MJerlHnEU+hM7Lj/waAUTdHXmBJCTlaGHDQaQp24wSKSLe79r0ydKR4UpopLT9MWqUCPg3SXnEmOhqa7GLEspAWjI+kjbjdaMqAmPIjQ+/0OPVEZUUPW30NL+l3ZI3eY/7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409706; c=relaxed/simple;
	bh=VU6noTiH76A/ftuFCLFXYrmUQNBx/v1qge6I+Jii+EQ=;
	h=Date:To:From:Subject:Message-Id; b=nZajNWC5AmZwXWarzOoe2sdF+49buI8AkfLaEcHD0N4OF3FKStNFYtyD61vRkP8iWsWZYGzMpzwhAU2PESXkTSSzBO8HT+s4AbSPtVl5OAZ4yY7uYk/cin1lckrHZx5OPbHnou90A5kSLNE9Bmk22TmicR3yyszLieOrIk6TH+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IBIpSDwU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IBIpSDwU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CCAFC4CEED;
	Fri, 25 Jul 2025 02:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409706;
	bh=VU6noTiH76A/ftuFCLFXYrmUQNBx/v1qge6I+Jii+EQ=;
	h=Date:To:From:Subject:From;
	b=IBIpSDwUa9z3z2z5enBkHADfaVSezdeqNQklVHjG1Rk1aJClEH/g9KcGqwa1+AfWq
	 pT7uQPBHGXQPWO+HBiDYznbt7kMZaHrVzXZqFON1HAoHeluDjZbEqU5nWGnk6u3V56
	 jiD5zGfOl/K/4iewkcheFYWfopHfSaEwqSOxxI/w=
Date: Thu, 24 Jul 2025 19:15:05 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,yury.norov@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-cma-simplify-cma_maxchunk_get.patch removed from -mm tree
Message-Id: <20250725021506.1CCAFC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: cma: simplify cma_maxchunk_get()
has been removed from the -mm tree.  Its filename was
     mm-cma-simplify-cma_maxchunk_get.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yury Norov (NVIDIA) <yury.norov@gmail.com>
Subject: mm: cma: simplify cma_maxchunk_get()
Date: Sat, 19 Jul 2025 16:54:00 -0400

The function opencodes for_each_clear_bitrange().  Fix that and drop most
of housekeeping code.

Link: https://lkml.kernel.org/r/20250719205401.399475-3-yury.norov@gmail.com
Signed-off-by: Yury Norov (NVIDIA) <yury.norov@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma_debug.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- a/mm/cma_debug.c~mm-cma-simplify-cma_maxchunk_get
+++ a/mm/cma_debug.c
@@ -56,16 +56,8 @@ static int cma_maxchunk_get(void *data,
 	for (r = 0; r < cma->nranges; r++) {
 		cmr = &cma->ranges[r];
 		bitmap_maxno = cma_bitmap_maxno(cma, cmr);
-		end = 0;
-		for (;;) {
-			start = find_next_zero_bit(cmr->bitmap,
-						   bitmap_maxno, end);
-			if (start >= bitmap_maxno)
-				break;
-			end = find_next_bit(cmr->bitmap, bitmap_maxno,
-					    start);
+		for_each_clear_bitrange(start, end, cmr->bitmap, bitmap_maxno)
 			maxchunk = max(end - start, maxchunk);
-		}
 	}
 	spin_unlock_irq(&cma->lock);
 	*val = (u64)maxchunk << cma->order_per_bit;
_

Patches currently in -mm which might be from yury.norov@gmail.com are


