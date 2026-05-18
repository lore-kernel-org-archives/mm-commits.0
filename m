Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1AA351C22
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 18:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779127245; cv=none; b=mRZ33mf1UGSqeZ3FEzu8C65F6Gz0+4FD0NDhQyJuMoL43lR3a+QpvPgbvR0syYNM6BBtLtl+9GGaPhnw9cYXmNhghsX2hj85fG6ynOskhRh/owfSdLIzdnMrpds57rf1CqcngcRpg0+b73ewB4Rh1GChcPESArIkwNBbJWJetJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779127245; c=relaxed/simple;
	bh=nlfFUmf3s7guLObLhx4MKv5DP0BRfNaA4x8Fq/5XVPg=;
	h=Date:To:From:Subject:Message-Id; b=I6+XbuQOZMo9czBK9+TnBPrxcg82aHedW7wC+nrTRMlwa5o71H+t5kuVPk4k7W0616ry+HTNP8kfc+JOOOmCeGCeFAvvZ3iye247jNKXFvWJdyQ7wGX+YG89OgHSvBTvCNxeG3aBVS5QWGAUrYNTvJ5jEo/NX//5f/PlT9sGWAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MKdLu+nD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MKdLu+nD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B25C2BCB7;
	Mon, 18 May 2026 18:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779127244;
	bh=nlfFUmf3s7guLObLhx4MKv5DP0BRfNaA4x8Fq/5XVPg=;
	h=Date:To:From:Subject:From;
	b=MKdLu+nDbxMkRUmII674ml1+7nJ21rqYATwRtyK85AQdl0m2n75JGBY4PwS8P4qy1
	 ZtjAdVnP0+pEbeos/ZOI4nG+x9iC9YKRraZgDwkh/0BMFpIbsAwwBVdBN0TQhQNOWb
	 wWYt/rICxYcjYHpQkSe0V8vZU94xSSI4fz8R7IOM=
Date: Mon, 18 May 2026 11:00:44 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,dennis@kernel.org,joonwonkang@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + percpu-do-not-trust-hint-starts-when-they-are-not-set.patch added to mm-new branch
Message-Id: <20260518180044.C4B25C2BCB7@smtp.kernel.org>
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
Date: Wed, 13 May 2026 08:51:14 +0000

contig_hint_start can be trusted outside the hint update function since it
will be updated everytime contig_hint is broken.  On the other hand,
scan_hint_start might still be invalid anywhere in the code due to the
broken scan_hint not being updated promptly.  If those starts are trusted
when they are not set, it could lead to false invalidation or update of
the hints.

Link: https://lore.kernel.org/20260513085117.1024175-2-joonwonkang@google.com
Signed-off-by: Joonwon Kang <joonwonkang@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
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

percpu-fix-wrong-chunk-hints-update.patch
percpu-do-not-trust-hint-starts-when-they-are-not-set.patch
percpu-introduce-struct-pcpu_region.patch
percpu-fix-hint-invariant-breakage.patch

