Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E081C6A3
	for <mm-commits@vger.kernel.org>; Sat, 30 Nov 2024 02:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732935408; cv=none; b=nyp0Lry6zriBdK4jjoBQHvkx2zgbSZMb8CK8bqB0c1wtBeISQcUySmqEOm3vmJ+HA28iYGWsB9nXY8b2KfGl55N/riT/xrmMIjK/HN7RG21PdcOjvF4baRq2ap1TF6iVp6Kc5ee8yXnV4BGdseVowtWaprYl9O4W28O35XGbLVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732935408; c=relaxed/simple;
	bh=sLxyNtWhY/tPaq+hQYc74deXRfTCiJp1wGq/fQkKN+Y=;
	h=Date:To:From:Subject:Message-Id; b=E7tl/FxnHIF/FlkimBh6/jNOgSXQAX7LDsm9AfhBto34/1VdEvoxI+W8vf3tW9t9MSdmq/4aiuo5liFetBnO3Ininpzgrw3NFRX93lW2N2xAAjBPxEeOEPw0hvpuqNU1/LMPBNnlUYoc14gGT6hmmwGt5+jeDFHTZD3a+meLGPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R+rfMV3h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R+rfMV3h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C724C4CECF;
	Sat, 30 Nov 2024 02:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732935408;
	bh=sLxyNtWhY/tPaq+hQYc74deXRfTCiJp1wGq/fQkKN+Y=;
	h=Date:To:From:Subject:From;
	b=R+rfMV3h7SQqemSO70wWD+Uh2PqAlpNNaft9mVAdiVdET2qcFESSkWKmMbDShw9HL
	 8DG6fiHzRFJwm2WbBrbyr6zprRY83IigpZXpX3PBSqtH7OhHNgtKN6uqX4LayAIxnO
	 3DZ5k5WnmH2ruh5WeC4ch9PnV7MKobRanoMxSwlc=
Date: Fri, 29 Nov 2024 18:56:47 -0800
To: mm-commits@vger.kernel.org,jserv@ccns.ncku.edu.tw,geert@linux-m68k.org,corbet@lwn.net,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_min_heap-use-inline-min-heap-variants-to-reduce-attack-vector.patch added to mm-nonmm-unstable branch
Message-Id: <20241130025648.0C724C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/test_min_heap: use inline min heap variants to reduce attack vector
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-test_min_heap-use-inline-min-heap-variants-to-reduce-attack-vector.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_min_heap-use-inline-min-heap-variants-to-reduce-attack-vector.patch

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
Subject: lib/test_min_heap: use inline min heap variants to reduce attack vector
Date: Sat, 30 Nov 2024 02:12:20 +0800

To address concerns about increasing the attack vector, remove the select
MIN_HEAP dependency from TEST_MIN_HEAP in Kconfig.debug.

Additionally, all min heap test function calls in lib/test_min_heap.c are
replaced with their inline variants.  By exclusively using inline
variants, we eliminate the need to enable CONFIG_MIN_HEAP for testing
purposes.

Link: https://lore.kernel.org/lkml/CAMuHMdVO5DPuD9HYWBFqKDHphx7+0BEhreUxtVC40A=8p6VAhQ@mail.gmail.com
Link: https://lkml.kernel.org/r/20241129181222.646855-3-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug   |    1 -
 lib/test_min_heap.c |   30 +++++++++++++++---------------
 2 files changed, 15 insertions(+), 16 deletions(-)

--- a/lib/Kconfig.debug~lib-test_min_heap-use-inline-min-heap-variants-to-reduce-attack-vector
+++ a/lib/Kconfig.debug
@@ -2269,7 +2269,6 @@ config TEST_LIST_SORT
 config TEST_MIN_HEAP
 	tristate "Min heap test"
 	depends on DEBUG_KERNEL || m
-	select MIN_HEAP
 	help
 	  Enable this to turn on min heap function tests. This test is
 	  executed only once during system boot (so affects only boot time),
--- a/lib/test_min_heap.c~lib-test_min_heap-use-inline-min-heap-variants-to-reduce-attack-vector
+++ a/lib/test_min_heap.c
@@ -32,7 +32,7 @@ static __init int pop_verify_heap(bool m
 	int last;
 
 	last = values[0];
-	min_heap_pop(heap, funcs, NULL);
+	min_heap_pop_inline(heap, funcs, NULL);
 	while (heap->nr > 0) {
 		if (min_heap) {
 			if (last > values[0]) {
@@ -48,7 +48,7 @@ static __init int pop_verify_heap(bool m
 			}
 		}
 		last = values[0];
-		min_heap_pop(heap, funcs, NULL);
+		min_heap_pop_inline(heap, funcs, NULL);
 	}
 	return err;
 }
@@ -69,7 +69,7 @@ static __init int test_heapify_all(bool
 	int i, err;
 
 	/* Test with known set of values. */
-	min_heapify_all(&heap, &funcs, NULL);
+	min_heapify_all_inline(&heap, &funcs, NULL);
 	err = pop_verify_heap(min_heap, &heap, &funcs);
 
 
@@ -78,7 +78,7 @@ static __init int test_heapify_all(bool
 	for (i = 0; i < heap.nr; i++)
 		values[i] = get_random_u32();
 
-	min_heapify_all(&heap, &funcs, NULL);
+	min_heapify_all_inline(&heap, &funcs, NULL);
 	err += pop_verify_heap(min_heap, &heap, &funcs);
 
 	return err;
@@ -102,14 +102,14 @@ static __init int test_heap_push(bool mi
 
 	/* Test with known set of values copied from data. */
 	for (i = 0; i < ARRAY_SIZE(data); i++)
-		min_heap_push(&heap, &data[i], &funcs, NULL);
+		min_heap_push_inline(&heap, &data[i], &funcs, NULL);
 
 	err = pop_verify_heap(min_heap, &heap, &funcs);
 
 	/* Test with randomly generated values. */
 	while (heap.nr < heap.size) {
 		temp = get_random_u32();
-		min_heap_push(&heap, &temp, &funcs, NULL);
+		min_heap_push_inline(&heap, &temp, &funcs, NULL);
 	}
 	err += pop_verify_heap(min_heap, &heap, &funcs);
 
@@ -135,22 +135,22 @@ static __init int test_heap_pop_push(boo
 	/* Fill values with data to pop and replace. */
 	temp = min_heap ? 0x80000000 : 0x7FFFFFFF;
 	for (i = 0; i < ARRAY_SIZE(data); i++)
-		min_heap_push(&heap, &temp, &funcs, NULL);
+		min_heap_push_inline(&heap, &temp, &funcs, NULL);
 
 	/* Test with known set of values copied from data. */
 	for (i = 0; i < ARRAY_SIZE(data); i++)
-		min_heap_pop_push(&heap, &data[i], &funcs, NULL);
+		min_heap_pop_push_inline(&heap, &data[i], &funcs, NULL);
 
 	err = pop_verify_heap(min_heap, &heap, &funcs);
 
 	heap.nr = 0;
 	for (i = 0; i < ARRAY_SIZE(data); i++)
-		min_heap_push(&heap, &temp, &funcs, NULL);
+		min_heap_push_inline(&heap, &temp, &funcs, NULL);
 
 	/* Test with randomly generated values. */
 	for (i = 0; i < ARRAY_SIZE(data); i++) {
 		temp = get_random_u32();
-		min_heap_pop_push(&heap, &temp, &funcs, NULL);
+		min_heap_pop_push_inline(&heap, &temp, &funcs, NULL);
 	}
 	err += pop_verify_heap(min_heap, &heap, &funcs);
 
@@ -163,7 +163,7 @@ static __init int test_heap_del(bool min
 			 -3, -1, -2, -4, 0x8000000, 0x7FFFFFF };
 	struct min_heap_test heap;
 
-	min_heap_init(&heap, values, ARRAY_SIZE(values));
+	min_heap_init_inline(&heap, values, ARRAY_SIZE(values));
 	heap.nr = ARRAY_SIZE(values);
 	struct min_heap_callbacks funcs = {
 		.less = min_heap ? less_than : greater_than,
@@ -172,9 +172,9 @@ static __init int test_heap_del(bool min
 	int i, err;
 
 	/* Test with known set of values. */
-	min_heapify_all(&heap, &funcs, NULL);
+	min_heapify_all_inline(&heap, &funcs, NULL);
 	for (i = 0; i < ARRAY_SIZE(values) / 2; i++)
-		min_heap_del(&heap, get_random_u32() % heap.nr, &funcs, NULL);
+		min_heap_del_inline(&heap, get_random_u32() % heap.nr, &funcs, NULL);
 	err = pop_verify_heap(min_heap, &heap, &funcs);
 
 
@@ -182,10 +182,10 @@ static __init int test_heap_del(bool min
 	heap.nr = ARRAY_SIZE(values);
 	for (i = 0; i < heap.nr; i++)
 		values[i] = get_random_u32();
-	min_heapify_all(&heap, &funcs, NULL);
+	min_heapify_all_inline(&heap, &funcs, NULL);
 
 	for (i = 0; i < ARRAY_SIZE(values) / 2; i++)
-		min_heap_del(&heap, get_random_u32() % heap.nr, &funcs, NULL);
+		min_heap_del_inline(&heap, get_random_u32() % heap.nr, &funcs, NULL);
 	err += pop_verify_heap(min_heap, &heap, &funcs);
 
 	return err;
_

Patches currently in -mm which might be from visitorckw@gmail.com are

lib-min_heap-improve-type-safety-in-min_heap-macros-by-using-container_of.patch
lib-test_min_heap-use-inline-min-heap-variants-to-reduce-attack-vector.patch
lib-min_heap-add-brief-introduction-to-min-heap-api.patch
documentation-core-api-min_heap-add-author-information.patch

