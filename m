Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84CC815C158
	for <mm-commits@vger.kernel.org>; Thu, 12 Jun 2025 01:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749693447; cv=none; b=SVqy5zFQSDVZMTTmJZFMPItCVzW9gTsYx8RjPL7lbObpyCaLcWIbY1uwDtPhdRdOkT9xrxVrFLrA71Wg7hX9ZTK3FlqNvtMznvCWpfwddiP2PjvDqMgBhHYfHyvZtbnJ3td246/m1jU0SXkkftMgLeutXTjjLAznh4Eq7DA0EGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749693447; c=relaxed/simple;
	bh=Aqa9E3h8o4hCvCxf2OemK3Hm8YiXed+2hRUV8Mxxj/M=;
	h=Date:To:From:Subject:Message-Id; b=qRntEgYyY25kQ3u1696ZKErOCxohxS7qkS3kiWsoFN53aDcMXp7VGUJeyEOxyLj8/7D2L7NTs7maL5xLabzhziE+dZKl9B/Xue7lpIgTOIyyW0BDt13FTI0zpHEYpy62p4LoGFPbl/mpcYn7Xi4QIUGm+QNhYS0a0IzjTMkdhik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=atW05q2m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="atW05q2m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 198F2C4CEE3;
	Thu, 12 Jun 2025 01:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749693447;
	bh=Aqa9E3h8o4hCvCxf2OemK3Hm8YiXed+2hRUV8Mxxj/M=;
	h=Date:To:From:Subject:From;
	b=atW05q2mRy5gIsDhtNKDyThx69OUZepPasOzJmiMHIjWla+ok4dbtVStiRAXdEoez
	 5bWUAbiVwji2PKifLJJwvEpQdmB1zLFU4x2Ew70kJ6Ye4KCsuDJQAJCHMiqxrfqeu2
	 4+knueVBng+e12ZINXbY3aihYVulzZenBVB49Tzo=
Date: Wed, 11 Jun 2025 18:57:26 -0700
To: mm-commits@vger.kernel.org,robertpang@google.com,kent.overstreet@linux.dev,jserv@ccns.ncku.edu.tw,corbet@lwn.net,colyli@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-min_heap-add-eqaware-variant-of-min_heapify_all.patch added to mm-nonmm-unstable branch
Message-Id: <20250612015727.198F2C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib min_heap: add eqaware variant of min_heapify_all()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-min_heap-add-eqaware-variant-of-min_heapify_all.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-min_heap-add-eqaware-variant-of-min_heapify_all.patch

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
Subject: lib min_heap: add eqaware variant of min_heapify_all()
Date: Wed, 11 Jun 2025 05:55:11 +0800

Introduce min_heapify_all_eqaware() as a variant of min_heapify_all() that
uses the equality-aware version of sift_down, which is implemented in a
top-down manner.

This top-down sift_down reduces the number of comparisons from O(log2(n))
to O(1) in cases where many elements have equal priority.  It enables more
efficient heap construction when the heap contains a large number of equal
elements.

Link: https://lkml.kernel.org/r/20250610215516.1513296-4-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Coly Li <colyli@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Robert Pang <robertpang@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/min_heap.h |   19 ++++++++++++++-----
 lib/min_heap.c           |    4 ++--
 2 files changed, 16 insertions(+), 7 deletions(-)

--- a/include/linux/min_heap.h~lib-min_heap-add-eqaware-variant-of-min_heapify_all
+++ a/include/linux/min_heap.h
@@ -371,17 +371,23 @@ void __min_heap_sift_up_inline(min_heap_
 /* Floyd's approach to heapification that is O(nr). */
 static __always_inline
 void __min_heapify_all_inline(min_heap_char *heap, size_t elem_size,
-			      const struct min_heap_callbacks *func, void *args)
+			      const struct min_heap_callbacks *func, void *args, bool eqaware)
 {
 	ssize_t i;
+	siftdown_fn_t sift_down = eqaware ? __min_heap_sift_down_eqaware_inline :
+					    __min_heap_sift_down_inline;
 
 	for (i = heap->nr / 2 - 1; i >= 0; i--)
-		__min_heap_sift_down_inline(heap, i, elem_size, func, args);
+		sift_down(heap, i, elem_size, func, args);
 }
 
 #define min_heapify_all_inline(_heap, _func, _args)	\
 	__min_heapify_all_inline(container_of(&(_heap)->nr, min_heap_char, nr),	\
-				 __minheap_obj_size(_heap), _func, _args)
+				 __minheap_obj_size(_heap), _func, _args, false)
+
+#define min_heapify_all_eqaware_inline(_heap, _func, _args)	\
+	__min_heapify_all_inline(container_of(&(_heap)->nr, min_heap_char, nr),	\
+				 __minheap_obj_size(_heap), _func, _args, true)
 
 /* Remove minimum element from the heap, O(log2(nr)). */
 static __always_inline
@@ -487,7 +493,7 @@ void __min_heap_sift_down_eqaware(min_he
 void __min_heap_sift_up(min_heap_char *heap, size_t elem_size, size_t idx,
 			const struct min_heap_callbacks *func, void *args);
 void __min_heapify_all(min_heap_char *heap, size_t elem_size,
-		       const struct min_heap_callbacks *func, void *args);
+		       const struct min_heap_callbacks *func, void *args, bool eqaware);
 bool __min_heap_pop(min_heap_char *heap, size_t elem_size,
 		    const struct min_heap_callbacks *func, void *args);
 void __min_heap_pop_push(min_heap_char *heap, const void *element, size_t elem_size,
@@ -514,7 +520,10 @@ bool __min_heap_del(min_heap_char *heap,
 			   __minheap_obj_size(_heap), _idx, _func, _args)
 #define min_heapify_all(_heap, _func, _args)	\
 	__min_heapify_all(container_of(&(_heap)->nr, min_heap_char, nr),	\
-			  __minheap_obj_size(_heap), _func, _args)
+			  __minheap_obj_size(_heap), _func, _args, false)
+#define min_heapify_all_eqaware(_heap, _func, _args)	\
+	__min_heapify_all(container_of(&(_heap)->nr, min_heap_char, nr),	\
+			  __minheap_obj_size(_heap), _func, _args, true)
 #define min_heap_pop(_heap, _func, _args)	\
 	__min_heap_pop(container_of(&(_heap)->nr, min_heap_char, nr),	\
 		       __minheap_obj_size(_heap), _func, _args)
--- a/lib/min_heap.c~lib-min_heap-add-eqaware-variant-of-min_heapify_all
+++ a/lib/min_heap.c
@@ -42,9 +42,9 @@ void __min_heap_sift_up(min_heap_char *h
 EXPORT_SYMBOL(__min_heap_sift_up);
 
 void __min_heapify_all(min_heap_char *heap, size_t elem_size,
-		       const struct min_heap_callbacks *func, void *args)
+		       const struct min_heap_callbacks *func, void *args, bool eqaware)
 {
-	__min_heapify_all_inline(heap, elem_size, func, args);
+	__min_heapify_all_inline(heap, elem_size, func, args, eqaware);
 }
 EXPORT_SYMBOL(__min_heapify_all);
 
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

