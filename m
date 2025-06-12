Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825DA15C158
	for <mm-commits@vger.kernel.org>; Thu, 12 Jun 2025 01:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749693450; cv=none; b=LOr02AzysgwyvC9yXQxY+moGsB1aRPXIIvFF0p8onB8Ton4WJztzVwA3HxgxI59DL9R7ei/3w4zifol+LQSn+aUmlkFg3yW2N3afhfrzIePiGy+rrqjTEsKNNPGs+3R6Qzukjp2AOYbmKpQl8LHUpbe2yI+KIv+D8tEp2f9RB5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749693450; c=relaxed/simple;
	bh=sC3GUqhoG/irkG5HTti9ax7y9v+dcHyM/jbOdYjV1HY=;
	h=Date:To:From:Subject:Message-Id; b=fV/mBfFpdreN0g6pENiimYYU63fp0BqY4UR85MvET5ONI94vD6D90XC31eaCYYprrsfYSaBsxwuVzxKmKtzb5cirQY7fEfXTO+ugln3N3EwKk1KqfROMOdBsKk/QLT5tj5wkaKfBlAil0XGXKERP7rKWQOxDXRGVJiZWbMdCep8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vyswddUy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vyswddUy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00142C4CEE3;
	Thu, 12 Jun 2025 01:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749693450;
	bh=sC3GUqhoG/irkG5HTti9ax7y9v+dcHyM/jbOdYjV1HY=;
	h=Date:To:From:Subject:From;
	b=vyswddUyfHKNDSMo8D1e2+TWO0w97n1WIV6X79AJpDa9+SYejhdtCuMF9qzW1emba
	 bysFw4tRT28bYibUJMKLHBmrrs65ZIJEenIefV9shkdw3Rtyj4cT8bomNXlvSyfNaK
	 x8s+pJD1/dsuY3DGm6ADuICUdTdo29OK0tN4QqlY=
Date: Wed, 11 Jun 2025 18:57:29 -0700
To: mm-commits@vger.kernel.org,robertpang@google.com,kent.overstreet@linux.dev,jserv@ccns.ncku.edu.tw,corbet@lwn.net,colyli@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-min_heap-add-eqaware-variant-of-min_heap_pop_push.patch added to mm-nonmm-unstable branch
Message-Id: <20250612015730.00142C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib min_heap: add eqaware variant of min_heap_pop_push()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-min_heap-add-eqaware-variant-of-min_heap_pop_push.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-min_heap-add-eqaware-variant-of-min_heap_pop_push.patch

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
Subject: lib min_heap: add eqaware variant of min_heap_pop_push()
Date: Wed, 11 Jun 2025 05:55:13 +0800

Introduce min_heap_pop_push_eqaware() as a variant of min_heap_pop_push()
that uses the equality-aware version of sift_down, which is implemented in
a top-down manner.

This top-down sift_down reduces the number of comparisons from O(log2(n))
to O(1) in cases where many elements have equal priority.  It enables more
efficient heap construction when the heap contains a large number of equal
elements.

Link: https://lkml.kernel.org/r/20250610215516.1513296-6-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Coly Li <colyli@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Robert Pang <robertpang@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/min_heap.h |   20 +++++++++++++++-----
 lib/min_heap.c           |    4 ++--
 2 files changed, 17 insertions(+), 7 deletions(-)

--- a/include/linux/min_heap.h~lib-min_heap-add-eqaware-variant-of-min_heap_pop_push
+++ a/include/linux/min_heap.h
@@ -424,15 +424,22 @@ bool __min_heap_pop_inline(min_heap_char
  */
 static __always_inline
 void __min_heap_pop_push_inline(min_heap_char *heap, const void *element, size_t elem_size,
-				const struct min_heap_callbacks *func, void *args)
+				const struct min_heap_callbacks *func, void *args, bool eqaware)
 {
+	siftdown_fn_t sift_down = eqaware ? __min_heap_sift_down_eqaware_inline :
+					    __min_heap_sift_down_inline;
+
 	memcpy(heap->data, element, elem_size);
-	__min_heap_sift_down_inline(heap, 0, elem_size, func, args);
+	sift_down(heap, 0, elem_size, func, args);
 }
 
 #define min_heap_pop_push_inline(_heap, _element, _func, _args)	\
 	__min_heap_pop_push_inline(container_of(&(_heap)->nr, min_heap_char, nr), _element,	\
-				   __minheap_obj_size(_heap), _func, _args)
+				   __minheap_obj_size(_heap), _func, _args, false)
+
+#define min_heap_pop_push_eqaware_inline(_heap, _element, _func, _args)	\
+	__min_heap_pop_push_inline(container_of(&(_heap)->nr, min_heap_char, nr), _element,	\
+				   __minheap_obj_size(_heap), _func, _args, true)
 
 /* Push an element on to the heap, O(log2(nr)). */
 static __always_inline
@@ -503,7 +510,7 @@ void __min_heapify_all(min_heap_char *he
 bool __min_heap_pop(min_heap_char *heap, size_t elem_size,
 		    const struct min_heap_callbacks *func, void *args, bool eqaware);
 void __min_heap_pop_push(min_heap_char *heap, const void *element, size_t elem_size,
-			 const struct min_heap_callbacks *func, void *args);
+			 const struct min_heap_callbacks *func, void *args, bool eqaware);
 bool __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
 		     const struct min_heap_callbacks *func, void *args);
 bool __min_heap_del(min_heap_char *heap, size_t elem_size, size_t idx,
@@ -538,7 +545,10 @@ bool __min_heap_del(min_heap_char *heap,
 		       __minheap_obj_size(_heap), _func, _args, true)
 #define min_heap_pop_push(_heap, _element, _func, _args)	\
 	__min_heap_pop_push(container_of(&(_heap)->nr, min_heap_char, nr), _element,	\
-			    __minheap_obj_size(_heap), _func, _args)
+			    __minheap_obj_size(_heap), _func, _args, false)
+#define min_heap_pop_push_eqaware(_heap, _element, _func, _args)	\
+	__min_heap_pop_push(container_of(&(_heap)->nr, min_heap_char, nr), _element,	\
+			    __minheap_obj_size(_heap), _func, _args, true)
 #define min_heap_push(_heap, _element, _func, _args)	\
 	__min_heap_push(container_of(&(_heap)->nr, min_heap_char, nr), _element,	\
 			__minheap_obj_size(_heap), _func, _args)
--- a/lib/min_heap.c~lib-min_heap-add-eqaware-variant-of-min_heap_pop_push
+++ a/lib/min_heap.c
@@ -56,9 +56,9 @@ bool __min_heap_pop(min_heap_char *heap,
 EXPORT_SYMBOL(__min_heap_pop);
 
 void __min_heap_pop_push(min_heap_char *heap, const void *element, size_t elem_size,
-			 const struct min_heap_callbacks *func, void *args)
+			 const struct min_heap_callbacks *func, void *args, bool eqaware)
 {
-	__min_heap_pop_push_inline(heap, element, elem_size, func, args);
+	__min_heap_pop_push_inline(heap, element, elem_size, func, args, eqaware);
 }
 EXPORT_SYMBOL(__min_heap_pop_push);
 
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

