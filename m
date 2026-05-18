Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42565382293
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 17:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779126859; cv=none; b=KPUa9nlwVoVu2be+OPw76BI0oZ35CYo5lYhe6/Top2BIlpAbuxKJgJJSdzXINtTukaJAYmugmTBLYFAzdd1OVtE/yQ5bG4igll1GI5s9hRG4VuarOT4HBRX4A1SeX7hPjkOQ9cRdsMIyPiJx6JEoOPxqXX2wneG1lcptFfvftiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779126859; c=relaxed/simple;
	bh=mZ99ejMd6rovr1ewQFRxBTT5Cg2IOTm7DB7RlWh4W6s=;
	h=Date:To:From:Subject:Message-Id; b=YDI6pkD7NXRuus0e2aGntTEv+yqodpDXbjZAJY/JyTUH2a1Vac9Ag+dMzxRYtLcRjrGEp9R8hiaXwGbC2PNWM12wDS5OVx+lLmJoLvwCCarc97sFxCqmcMICS+87xYHat98V7CVqj3MmwZwr6CbZ2has/7GM5uF38NphSWBRcGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FyLu2Kqd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FyLu2Kqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18977C2BCB7;
	Mon, 18 May 2026 17:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779126859;
	bh=mZ99ejMd6rovr1ewQFRxBTT5Cg2IOTm7DB7RlWh4W6s=;
	h=Date:To:From:Subject:From;
	b=FyLu2KqdQPu/9g1MbZ+M3X+ycaHl8iMa0QflxXkN001Z8Vq2rKJgExFrUYC5EMNEo
	 PKgTlGM6wv7mNFK43sBZb2QMLga7kXEjJYdwoOzF4W6Xi0LdUfAI30wMTzERktZEXj
	 v+j4CL4+tHVUjf8+Ngq7Gmn3Ha61+5q0ygYkE0Co=
Date: Mon, 18 May 2026 10:54:18 -0700
To: mm-commits@vger.kernel.org,joonwonkang@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] percpu-do-not-trust-hint-starts-when-they-are-not-set.patch removed from -mm tree
Message-Id: <20260518175419.18977C2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: percpu: do not trust hint starts when they are not set
has been removed from the -mm tree.  Its filename was
     percpu-do-not-trust-hint-starts-when-they-are-not-set.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Joonwon Kang <joonwonkang@google.com>
Subject: percpu: do not trust hint starts when they are not set
Date: Sun, 10 May 2026 07:21:47 +0000

contig_hint_start can be trusted outside the hint update function since it
will be updated everytime contig_hint is broken.  On the other hand,
scan_hint_start might still be invalid anywhere in the code due to the
broken scan_hint not being updated promptly.  If those starts are trusted
when they are not set, it could lead to false invalidation or update of
the hints.

Link: https://lore.kernel.org/20260510072149.1279887-2-joonwonkang@google.com
Signed-off-by: Joonwon Kang <joonwonkang@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: <dodam@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/mm/percpu.c~percpu-do-not-trust-hint-starts-when-they-are-not-set
+++ a/mm/percpu.c
@@ -640,12 +640,13 @@ static void pcpu_block_update(struct pcp
 
 	if (contig > block->contig_hint) {
 		/* promote the old contig_hint to be the new scan_hint */
-		if (start > block->contig_hint_start) {
+		if (block->contig_hint && start > block->contig_hint_start) {
 			if (block->contig_hint > block->scan_hint) {
 				block->scan_hint_start =
 					block->contig_hint_start;
 				block->scan_hint = block->contig_hint;
-			} else if (start < block->scan_hint_start) {
+			} else if (block->scan_hint &&
+				   start < block->scan_hint_start) {
 				/*
 				 * The old contig_hint == scan_hint.  But, the
 				 * new contig is larger so hold the invariant
@@ -664,10 +665,12 @@ static void pcpu_block_update(struct pcp
 		     __ffs(start) > __ffs(block->contig_hint_start))) {
 			/* start has a better alignment so use it */
 			block->contig_hint_start = start;
-			if (start < block->scan_hint_start &&
+			if (block->scan_hint &&
+			    start < block->scan_hint_start &&
 			    block->contig_hint > block->scan_hint)
 				block->scan_hint = 0;
-		} else if (start > block->scan_hint_start ||
+		} else if ((block->scan_hint &&
+			    start > block->scan_hint_start) ||
 			   block->contig_hint > block->scan_hint) {
 			/*
 			 * Knowing contig == contig_hint, update the scan_hint
@@ -845,7 +848,8 @@ static void pcpu_block_update_hint_alloc
 					PCPU_BITMAP_BLOCK_BITS,
 					s_off + bits);
 
-	if (pcpu_region_overlap(s_block->scan_hint_start,
+	if (s_block->scan_hint &&
+	    pcpu_region_overlap(s_block->scan_hint_start,
 				s_block->scan_hint_start + s_block->scan_hint,
 				s_off,
 				s_off + bits))
@@ -889,7 +893,8 @@ static void pcpu_block_update_hint_alloc
 			/* reset the block */
 			e_block++;
 		} else {
-			if (e_off > e_block->scan_hint_start)
+			if (e_block->scan_hint &&
+			    e_off > e_block->scan_hint_start)
 				e_block->scan_hint = 0;
 
 			e_block->left_free = 0;
@@ -922,7 +927,8 @@ static void pcpu_block_update_hint_alloc
 	if (nr_empty_pages)
 		pcpu_update_empty_pages(chunk, -nr_empty_pages);
 
-	if (pcpu_region_overlap(chunk_md->scan_hint_start,
+	if (chunk_md->scan_hint &&
+	    pcpu_region_overlap(chunk_md->scan_hint_start,
 				chunk_md->scan_hint_start +
 				chunk_md->scan_hint,
 				bit_off,
_

Patches currently in -mm which might be from joonwonkang@google.com are

a.patch
percpu-introduce-struct-pcpu_region.patch
percpu-fix-hint-invariant-breakage.patch

