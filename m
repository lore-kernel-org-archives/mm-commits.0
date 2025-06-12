Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75894770FE
	for <mm-commits@vger.kernel.org>; Thu, 12 Jun 2025 01:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749693454; cv=none; b=fbTOpoSG6A+jxbb0TmX9A7FeD5SWg4VC3v7fsShEu2dCVX3OiRcxhFQeaY4L7rO2CDLmlSHtttgKoxWeMLRgiK3VGK39lZs/e3NqYa/3papuB/NzrjNc6EOMXjeKY9jFI+41bhAML3IVXi825uySwvfcI7WvwdUrKaU6t8xNWow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749693454; c=relaxed/simple;
	bh=k160iAwjE3cEo6r1IFwlUDOUQpMWCn8oOJRNUFUziYc=;
	h=Date:To:From:Subject:Message-Id; b=tsIOxVoH7kzy8B5GyFt4MMVMAjFwE4DlmryHQnDjp3PFX61u5nEYzPSn/MFTOFB2f3+phzURt7/XQuCnKWGV5p6hUJy7/+NhUFN1OfOHiqWl4PKKrOU6kle9MwO6pPTkLckOco22IXAh7OEAAnOgicGMTki1wRzu8bTYZEtX6iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TC8JTzak; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TC8JTzak"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0622C4CEE3;
	Thu, 12 Jun 2025 01:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749693454;
	bh=k160iAwjE3cEo6r1IFwlUDOUQpMWCn8oOJRNUFUziYc=;
	h=Date:To:From:Subject:From;
	b=TC8JTzakQYIvs2VKL+w5zR5IgSxIYHW3X5VTP3vY8jOApi6FR9XMATD0Ldw1PlORE
	 DkhTdnNl054VgZzX0Jn3L7mUA2IHzrYymh4lWCTANyDrrsjRnot58WZpuj5MW++5YV
	 j0onIErivy7GILQIapY6mbNf534Ggvqnw7gdB8MA=
Date: Wed, 11 Jun 2025 18:57:33 -0700
To: mm-commits@vger.kernel.org,robertpang@google.com,kent.overstreet@linux.dev,jserv@ccns.ncku.edu.tw,corbet@lwn.net,colyli@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + bcache-fix-the-tail-io-latency-regression-by-using-equality-aware-min-heap-api.patch added to mm-nonmm-unstable branch
Message-Id: <20250612015733.F0622C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: bcache: fix the tail IO latency regression by using equality-aware min heap API
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     bcache-fix-the-tail-io-latency-regression-by-using-equality-aware-min-heap-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/bcache-fix-the-tail-io-latency-regression-by-using-equality-aware-min-heap-api.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: bcache: fix the tail IO latency regression by using equality-aware min heap API
Date: Wed, 11 Jun 2025 05:55:16 +0800

Commit 866898efbb25 ("bcache: remove heap-related macros and switch to
generic min_heap") replaced the original top-down heap macros in bcache
with the generic min heap library, which uses a bottom-up heapify
strategy.  However, in scenarios like invalidate_buckets_lru() -
especially before the cache is fully populated - many buckets remain
unfilled.  This causes new_bucket_prio() to frequently return zero,
leading to a high rate of equal comparisons.

Bottom-up sift_down performs up to 2 * log2(n) comparisons in such cases,
resulting in a performance regression.

Switch to the _eqaware variants of the min heap API to restore the
original top-down sift_down behavior, which requires only O(1) comparisons
when many elements are equal.

Also use the inline versions of the heap functions to avoid performance
degradation introduced by commit 92a8b224b833 ("lib/min_heap: introduce
non-inline versions of min heap API functions"), as
invalidate_buckets_lru() is on a performance-critical hot path.

Link: https://lkml.kernel.org/r/20250610215516.1513296-9-visitorckw@gmail.com
Fixes: 866898efbb25 ("bcache: remove heap-related macros and switch to generic min_heap")
Fixes: 92a8b224b833 ("lib/min_heap: introduce non-inline versions of min heap API functions")
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reported-by: Robert Pang <robertpang@google.com>
Closes: https://lore.kernel.org/linux-bcache/CAJhEC06F_AtrPgw2-7CvCqZgeStgCtitbD-ryuPpXQA-JG5XXw@mail.gmail.com
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Coly Li <colyli@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/bcache/alloc.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/drivers/md/bcache/alloc.c~bcache-fix-the-tail-io-latency-regression-by-using-equality-aware-min-heap-api
+++ a/drivers/md/bcache/alloc.c
@@ -207,15 +207,16 @@ static void invalidate_buckets_lru(struc
 		if (!bch_can_invalidate_bucket(ca, b))
 			continue;
 
-		if (!min_heap_full(&ca->heap))
-			min_heap_push(&ca->heap, &b, &bucket_max_cmp_callback, ca);
-		else if (!new_bucket_max_cmp(&b, min_heap_peek(&ca->heap), ca)) {
+		if (!min_heap_full_inline(&ca->heap))
+			min_heap_push_inline(&ca->heap, &b, &bucket_max_cmp_callback, ca);
+		else if (!new_bucket_max_cmp(&b, min_heap_peek_inline(&ca->heap), ca)) {
 			ca->heap.data[0] = b;
-			min_heap_sift_down(&ca->heap, 0, &bucket_max_cmp_callback, ca);
+			min_heap_sift_down_eqaware_inline(&ca->heap, 0, &bucket_max_cmp_callback,
+							  ca);
 		}
 	}
 
-	min_heapify_all(&ca->heap, &bucket_min_cmp_callback, ca);
+	min_heapify_all_eqaware_inline(&ca->heap, &bucket_min_cmp_callback, ca);
 
 	while (!fifo_full(&ca->free_inc)) {
 		if (!ca->heap.nr) {
@@ -227,8 +228,8 @@ static void invalidate_buckets_lru(struc
 			wake_up_gc(ca->set);
 			return;
 		}
-		b = min_heap_peek(&ca->heap)[0];
-		min_heap_pop(&ca->heap, &bucket_min_cmp_callback, ca);
+		b = min_heap_peek_inline(&ca->heap)[0];
+		min_heap_pop_eqaware_inline(&ca->heap, &bucket_min_cmp_callback, ca);
 
 		bch_invalidate_one_bucket(ca, b);
 	}
_

Patches currently in -mm which might be from visitorckw@gmail.com are

lib-math-gcd-use-static-key-to-select-implementation-at-runtime.patch
riscv-optimize-gcd-code-size-when-config_riscv_isa_zbb-is-disabled.patch
riscv-optimize-gcd-performance-on-risc-v-without-zbb-extension.patch
lib-min_heap-add-equal-elements-aware-sift_down-variant.patch
lib-min_heap-add-typedef-for-sift_down-function-pointer.patch
lib-min_heap-add-eqaware-variant-of-min_heapify_all.patch
lib-min_heap-add-eqaware-variant-of-min_heap_pop.patch
lib-min_heap-add-eqaware-variant-of-min_heap_pop_push.patch
lib-min_heap-add-eqaware-variant-of-min_heap_del.patch
documentation-core-api-min_heap-document-_eqaware-variants-of-min-heap-apis.patch
bcache-fix-the-tail-io-latency-regression-by-using-equality-aware-min-heap-api.patch

