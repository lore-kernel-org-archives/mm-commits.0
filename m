Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA30D395ACD
	for <mm-commits@vger.kernel.org>; Tue, 12 May 2026 22:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778626210; cv=none; b=OyZ2zLM1wiVJxBESI6n69AMgd20OsVosL13Qqedx3+//NNqD6KLDnbBIYKh8t6akdGAg38AVqRs36b3+TFG5T8tcmN1mr+pyY1g175vPWwuSVT08s2ZL+NcqvwGtRGMsMorDK0l6qr6aUk3HdRKkvFpG4e8XUyqmpsa1AkoY8S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778626210; c=relaxed/simple;
	bh=emM6ZA6a8dMDyWmutVMi3Ui4tW0phRvu1IPVi6TKLo4=;
	h=Date:To:From:Subject:Message-Id; b=tHQtgA+qSStPmhWV8YUEeaBRWXCwtXz9ZLpEcHP7+pZ70IJF2WcMwdal3/aTvPiW7T0BgwCw9xfxUSTdgXEn9U3Yvvz73KbtqJ15M6bRk/7q8JsJNzrM0fPHfKJnld75e+Hp/xxnLL404adAjKbqT7g+3zI0C8ycLp99ubFRf3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lcDO173E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lcDO173E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4733FC2BCB0;
	Tue, 12 May 2026 22:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778626210;
	bh=emM6ZA6a8dMDyWmutVMi3Ui4tW0phRvu1IPVi6TKLo4=;
	h=Date:To:From:Subject:From;
	b=lcDO173EAxq1SlhuEIoL22MXO3Tm2jZmIc+uhJCJEv/p4LsA1PJ04jwyrv4fYdEx6
	 IN3nEjWEk+bxp53yGhoFNJuNdtzqycdEHJRYav/AhmLGpQCodS4FW1ZxJJ4CPflKO6
	 pQiJXzQK/6q+AQtmNesfX/ut/HKnHTTE5ElQzCcU=
Date: Tue, 12 May 2026 15:50:01 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,dodam@google.com,dennis@kernel.org,cl@linux.com,joonwonkang@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + percpu-fix-hint-invariant-breakage.patch added to mm-new branch
Message-Id: <20260512225007.4733FC2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: percpu: fix hint invariant breakage
has been added to the -mm mm-new branch.  Its filename is
     percpu-fix-hint-invariant-breakage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/percpu-fix-hint-invariant-breakage.patch

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
Subject: percpu: fix hint invariant breakage
Date: Sun, 10 May 2026 07:21:49 +0000

The invariant "scan_hint_start > contig_hint_start if and only if
scan_hint == contig_hint" should be kept for hint management.  However, it
could be broken in some cases:

  - if (new contig == contig_hint == scan_hint) && (contig_hint_start <
    scan_hint_start < new contig start) && the new contig is to become a
    new contig_hint due to its better alignment, then scan_hint should
    be invalidated instead of keeping the old value.

  - if (new contig == contig_hint > scan_hint) && (new contig start <
    contig_hint_start) && the new contig is not to become a new
    contig_hint, then scan_hint should be not updated to the new contig.

This commit mainly fixes this invariant breakage and includes more:

  - Handle the cases where the new contig overlaps with the contig_hint
    or with scan_hint.

  - Merge the new contig with other hints when it overlaps with them and
    treat it as a whole free region instead of a separate small region.

  - Fix the invariant breakage and also optimizes scan_hint further.
    Some of the optimization cases when no overlap occurs are:

    - if (new contig > contig_hint > scan_hint) && (scan_hint_start < new
      contig start < contig_hint_start), then keep scan_hint instead of
      invalidating it.

    - if (new contig > contig_hint == scan_hint) && (contig_hint_start <
      new contig start < scan_hint_start), then update scan_hint to the
      old contig_hint instead of invalidating it.

    - if (new contig == contig_hint > scan_hint) && (new contig start <
      contig_hint_start) && the new contig is to become a new contig_hint
      due to its better alignment, then update scan_hint to the old
      contig_hint instead of invalidating or keeping it.

Link: https://lore.kernel.org/20260510072149.1279887-4-joonwonkang@google.com
Signed-off-by: Joonwon Kang <joonwonkang@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: <dodam@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |  119 +++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 94 insertions(+), 25 deletions(-)

--- a/mm/percpu.c~percpu-fix-hint-invariant-breakage
+++ a/mm/percpu.c
@@ -616,6 +616,20 @@ static inline bool pcpu_region_overlap(s
 	return (a.start < b.start + b.size) && (b.start < a.start + a.size);
 }
 
+/*
+ * pcpu_region_concat - determines if two regions meet on the border
+ * @a: first region
+ * @b: second region
+ *
+ * This is used to determine if the hint region [a.start, a.start + a.size)
+ * meets with the allocated region [b.start, b.start + b.size) on the border.
+ */
+static inline bool pcpu_region_concat(struct pcpu_region a,
+				      struct pcpu_region b)
+{
+	return (a.start == b.start + b.size) || (b.start == a.start + a.size);
+}
+
 /**
  * pcpu_block_update - updates a block given a free area
  * @block: block of interest
@@ -629,6 +643,40 @@ static inline bool pcpu_region_overlap(s
 static void pcpu_block_update(struct pcpu_block_md *block, int start, int end)
 {
 	struct pcpu_region free = { .start = start, .size = end - start };
+	bool overlap_with_contig_hint =
+		block->contig_hint.size &&
+		(pcpu_region_overlap(block->contig_hint, free) ||
+		 pcpu_region_concat(block->contig_hint, free));
+
+	if (block->scan_hint.size &&
+	    (pcpu_region_overlap(block->scan_hint, free) ||
+	     pcpu_region_concat(block->scan_hint, free))) {
+		start = min(start, block->scan_hint.start);
+		end = max(end, block->scan_hint.start + block->scan_hint.size);
+		free = (struct pcpu_region){
+			.start = start,
+			.size = end - start,
+		};
+
+		block->scan_hint.size = 0;
+	}
+
+	if (overlap_with_contig_hint) {
+		start = min(start, block->contig_hint.start);
+		end = max(end,
+			  block->contig_hint.start + block->contig_hint.size);
+		free = (struct pcpu_region){
+			.start = start,
+			.size = end - start,
+		};
+
+		if (block->scan_hint.size &&
+		    free.size > block->scan_hint.size &&
+		    block->scan_hint.start > free.start)
+			block->scan_hint.size = 0;
+
+		block->contig_hint = free;
+	}
 
 	block->first_free = min(block->first_free, free.start);
 	if (free.start == 0)
@@ -637,23 +685,24 @@ static void pcpu_block_update(struct pcp
 	if (free.start + free.size == block->nr_bits)
 		block->right_free = free.size;
 
+	if (overlap_with_contig_hint)
+		return;
+
+	/*
+	 * At this point, it is guaranteed that the new contig does neither
+	 * overlap with contig_hint nor with scan_hint.
+	 */
+
 	if (free.size > block->contig_hint.size) {
 		/* promote the old contig_hint to be the new scan_hint */
 		if (block->contig_hint.size &&
 		    free.start > block->contig_hint.start) {
-			if (block->contig_hint.size > block->scan_hint.size) {
+			if (block->contig_hint.size > block->scan_hint.size ||
+			    free.start < block->scan_hint.start)
 				block->scan_hint = block->contig_hint;
-			} else if (block->scan_hint.size &&
-				   free.start < block->scan_hint.start) {
-				/*
-				 * The old contig_hint.size == scan_hint.size.
-				 * But, the new contig is larger so hold the
-				 * invariant scan_hint.start <
-				 * contig_hint.start.
-				 */
-				block->scan_hint.size = 0;
-			}
-		} else {
+		} else if (!block->contig_hint.size ||
+			   (block->scan_hint.size &&
+			    free.start < block->scan_hint.start)) {
 			block->scan_hint.size = 0;
 		}
 		block->contig_hint = free;
@@ -661,21 +710,41 @@ static void pcpu_block_update(struct pcp
 		if (block->contig_hint.start &&
 		    (!free.start ||
 		     __ffs(free.start) > __ffs(block->contig_hint.start))) {
+			if (block->contig_hint.size > block->scan_hint.size) {
+				if (free.start < block->contig_hint.start)
+					block->scan_hint = block->contig_hint;
+			} else if (free.start > block->scan_hint.start) {
+				/*
+				 * old contig_hint.size == old scan_hint.size
+				 * == new contig size. But, the new contig is
+				 * farther than the old scan_hint so hold the
+				 * invariant scan_hint.start > contig_hint.start
+				 * iff scan_hint.size == contig_hint.size.
+				 */
+				block->scan_hint.size = 0;
+			}
+
 			/* new start has a better alignment so use it */
 			block->contig_hint.start = free.start;
-			if (block->scan_hint.size &&
-			    free.start < block->scan_hint.start &&
-			    block->contig_hint.size > block->scan_hint.size)
-				block->scan_hint.size = 0;
-		} else if ((block->scan_hint.size &&
-			    free.start > block->scan_hint.start) ||
-			   block->contig_hint.size > block->scan_hint.size) {
-			/*
-			 * Knowing new contig size == contig_hint.size, update
-			 * the scan_hint if it is farther than or larger than
-			 * the current scan_hint.
-			 */
-			block->scan_hint = free;
+		} else {
+			if (block->contig_hint.size > block->scan_hint.size) {
+				if (free.start < block->contig_hint.start) {
+					/*
+					 * old scan_hint.size < new contig size
+					 * == old contig_hint.size. But, the new
+					 * contig is before the old contig_hint
+					 * so hold the invariant
+					 * scan_hint.start > contig_hint.start
+					 * iff scan_hint.size ==
+					 * contig_hint.size.
+					 */
+					block->scan_hint.size = 0;
+				} else {
+					block->scan_hint = free;
+				}
+			} else if (free.start > block->scan_hint.start) {
+				block->scan_hint = free;
+			}
 		}
 	} else {
 		/*
_

Patches currently in -mm which might be from joonwonkang@google.com are

percpu-fix-wrong-chunk-hints-update.patch
percpu-do-not-trust-hint-starts-when-they-are-not-set.patch
percpu-introduce-struct-pcpu_region.patch
percpu-fix-hint-invariant-breakage.patch

