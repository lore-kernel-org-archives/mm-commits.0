Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F261DA10B
	for <mm-commits@vger.kernel.org>; Sat, 19 Jul 2025 23:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752966696; cv=none; b=rfT6x6uNeFMfuDfufnJ4QsuOp97/GeNgPXdoXQeKxLkmkaV9HLZ+N99R7FBy8Fh0u0vANuki6N6BKHOVUKxFUhVkWs8AmJaWNnGbPszeHAzM8FzqaeLxuey215O558vjXC+wFbvGD55m0RjZfpE0jdzKVk36uLTA5PYDePWMpj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752966696; c=relaxed/simple;
	bh=b4bvIMBJw2Y23Tv1cnm33nXGTs1sNjAb32nTyM6KzLI=;
	h=Date:To:From:Subject:Message-Id; b=Mnuzd3KR+tfBCrCPqyxOqUdLvPv4h+kof+jWBvCJzffaYwpxLaUGoSzJ84GGnNNbdwI8saziBkjsWvJ1ROw440BydZdqcewSMInRNrIpUBekSc0PrryFlUHqc2xDKcj/ZJhW5KV4rPgyWGi/8dyVarCfQnbrC0U6ccZ3g0YRZ5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OcCVZ02K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OcCVZ02K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31153C4CEE3;
	Sat, 19 Jul 2025 23:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752966696;
	bh=b4bvIMBJw2Y23Tv1cnm33nXGTs1sNjAb32nTyM6KzLI=;
	h=Date:To:From:Subject:From;
	b=OcCVZ02K3RCNu+wR+KffVSbwgeyRCqV6MiEh+CZ9x3iRUiweAlkPmGd510swBVl9U
	 vLv1pLbhQ/nYhVQmCca6/ksUPyhyIb6zLPoZwFky3nFmMV3r4ZnHyyP5WqPRu2LJtI
	 2fzq8wxpNBo3ea7RURVLBRf1ACecfwd7xqvY8cAQ=
Date: Sat, 19 Jul 2025 16:11:35 -0700
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-simplify-cma_debug_show_areas.patch added to mm-new branch
Message-Id: <20250719231136.31153C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: cma: simplify cma_debug_show_areas()
has been added to the -mm mm-new branch.  Its filename is
     mm-cma-simplify-cma_debug_show_areas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-simplify-cma_debug_show_areas.patch

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
From: Yury Norov (NVIDIA) <yury.norov@gmail.com>
Subject: mm: cma: simplify cma_debug_show_areas()
Date: Sat, 19 Jul 2025 16:53:59 -0400

The function opencodes for_each_clear_bitrange().  Fix that and drop most
of housekeeping code.

Link: https://lkml.kernel.org/r/20250719205401.399475-2-yury.norov@gmail.com
Signed-off-by: Yury Norov (NVIDIA) <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |   19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

--- a/mm/cma.c~mm-cma-simplify-cma_debug_show_areas
+++ a/mm/cma.c
@@ -751,8 +751,7 @@ int __init cma_declare_contiguous_nid(ph
 
 static void cma_debug_show_areas(struct cma *cma)
 {
-	unsigned long next_zero_bit, next_set_bit, nr_zero;
-	unsigned long start;
+	unsigned long start, end;
 	unsigned long nr_part;
 	unsigned long nbits;
 	int r;
@@ -763,22 +762,12 @@ static void cma_debug_show_areas(struct
 	for (r = 0; r < cma->nranges; r++) {
 		cmr = &cma->ranges[r];
 
-		start = 0;
 		nbits = cma_bitmap_maxno(cma, cmr);
 
 		pr_info("range %d: ", r);
-		for (;;) {
-			next_zero_bit = find_next_zero_bit(cmr->bitmap,
-							   nbits, start);
-			if (next_zero_bit >= nbits)
-				break;
-			next_set_bit = find_next_bit(cmr->bitmap, nbits,
-						     next_zero_bit);
-			nr_zero = next_set_bit - next_zero_bit;
-			nr_part = nr_zero << cma->order_per_bit;
-			pr_cont("%s%lu@%lu", start ? "+" : "", nr_part,
-				next_zero_bit);
-			start = next_zero_bit + nr_zero;
+		for_each_clear_bitrange(start, end, cmr->bitmap, nbits) {
+			nr_part = (end - start) << cma->order_per_bit;
+			pr_cont("%s%lu@%lu", start ? "+" : "", nr_part, start);
 		}
 		pr_info("\n");
 	}
_

Patches currently in -mm which might be from yury.norov@gmail.com are

mm-cma-simplify-cma_debug_show_areas.patch
mm-cma-simplify-cma_maxchunk_get.patch

