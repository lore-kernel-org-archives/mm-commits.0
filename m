Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A16638B127
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780030303; cv=none; b=K5rAFZwZKejT7JBrV0d3jxEGbqSTyKbS/ef6+1WDZgED1aUD0Qc78UAQLxAEq/gatxbaW4PIMgUtmKbSOb7nx4BXHhgilhDFWxuqb4FLkz06hM0Y7OyqxUYHZ1vxJSCD46qosx9tqfGZcpWniaNF51Yi0eNGrbJrU6N9wdvPopM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780030303; c=relaxed/simple;
	bh=gQKPxbFTZ1Zx6oCsqJgj+/X9tZYW5vDTQnE9Tc4VYUY=;
	h=Date:To:From:Subject:Message-Id; b=BNWeCRsa+aDlUGKXrmgHgd0nKXgd+Ao1xYm5mkVLLgveQHyyjBmqC52xyga0+UCjrNQlZzSHnNWF2kLDcDZWi79JmDLlSGvpy/Iw3Gqq6hRr5EV/JIhoA4ouJ/nVwHqMgL1e9gAQss3XinavOj0KkZOYcXI8lru1s6KF6OTX4tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ssyKER3H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ssyKER3H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 455191F00893;
	Fri, 29 May 2026 04:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780030302;
	bh=H1LghdE+JeGm+9Pdx7t0/yUOMK6cNhYrTjS2/thMUVI=;
	h=Date:To:From:Subject;
	b=ssyKER3HQymaIrwk1SvBd5hiK6vOHTR/QzSTYDSs/2vbZ/5rLsdMBJUM9CLQnaDye
	 Xk/b5E902OAuqWF3MMk/yWK+YQ9TSaMVrq+J/PZWf7nLPCn1jFmV9oOZfyMLpuPHnN
	 4tbqyZ4p7G0N1zfSL6Db+H/UzFxr+LvJA/2ARk54=
Date: Thu, 28 May 2026 21:51:41 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,dennis@kernel.org,joonwonkang@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] percpu-do-not-trust-hint-starts-when-they-are-not-set.patch removed from -mm tree
Message-Id: <20260529045142.455191F00893@smtp.kernel.org>
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
Date: Wed, 13 May 2026 08:51:14 +0000

contig_hint_start can be trusted outside the hint update function since it
will be updated everytime contig_hint is broken.  On the other hand,
scan_hint_start might still be invalid anywhere in the code due to the
broken scan_hint not being updated promptly.  If those starts are trusted
when they are not set, it could lead to false invalidation or update of
the hints.

Link: https://lore.kernel.org/20260513085117.1024175-2-joonwonkang@google.com
Signed-off-by: Joonwon Kang <joonwonkang@google.com>
Reviewed-by: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
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

percpu-introduce-struct-pcpu_region.patch
percpu-fix-hint-invariant-breakage.patch

