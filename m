Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00703988F8
	for <mm-commits@vger.kernel.org>; Tue, 12 May 2026 22:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778626188; cv=none; b=qxzrif8vEwbYIA7u0Pfz1WZ2rgGySC4zYq4KZ/87+I4DAmSlj+W9C+CtOXttvDVAS7OKSA+C8QrlLoPmCeSzG+ISTnJK3K3bDWuuxYO52VAYpGiDc9oHTBRwCp7Y5YB4ab3R/q8SsV7i7h+q4+JvQnmUsC+fpJ6wYOdiS/IX5Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778626188; c=relaxed/simple;
	bh=KmDMWKWkt0P4wRz0g6z2kn2iHIdqjiVa0Y9dzQO+RKw=;
	h=Date:To:From:Subject:Message-Id; b=Vkf8II/59sypV3w0wIZLnKCxPbj4P/9mF2fmNKCE71i4Ie2VWK+EtPwi1qdPETvSmiq+QgAwNZMBPj/JV4B1uTvEolW0ObOt4bxFzAl/TDsTY41lfVKfTUMoUcdyxl1jrYFf586lVTZ3/x20l3LwpMlEZpJ5PMTvE9xh4R4ld3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RghrYIbF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RghrYIbF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE967C2BCB8;
	Tue, 12 May 2026 22:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778626188;
	bh=KmDMWKWkt0P4wRz0g6z2kn2iHIdqjiVa0Y9dzQO+RKw=;
	h=Date:To:From:Subject:From;
	b=RghrYIbFTPCZT3PEBbjjbZPfMjv9HZOw3Vxkc+Jnqw3b7NDHjmmjceLFnZ+06kAT9
	 rsF+S8LWl4Z2zwQKlOtQ/o7iDr/20B4O0X5ESGMeRvP2KuyWKw/6vukhh34AwUgaQ6
	 NVPZykyy/rSd49EQvPKk8Cg/EzegJkrtkIP7LyrE=
Date: Tue, 12 May 2026 15:49:36 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,dodam@google.com,dennis@kernel.org,cl@linux.com,joonwonkang@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + percpu-do-not-trust-hint-starts-when-they-are-not-set.patch added to mm-new branch
Message-Id: <20260512224947.EE967C2BCB8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: percpu: do not trust hint starts when they are not set
has been added to the -mm mm-new branch.  Its filename is
     percpu-do-not-trust-hint-starts-when-they-are-not-set.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/percpu-do-not-trust-hint-starts-when-they-are-not-set.patch

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

percpu-fix-wrong-chunk-hints-update.patch
percpu-do-not-trust-hint-starts-when-they-are-not-set.patch
percpu-introduce-struct-pcpu_region.patch
percpu-fix-hint-invariant-breakage.patch

