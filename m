Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FCD61C6A3
	for <mm-commits@vger.kernel.org>; Sat, 30 Nov 2024 02:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732935407; cv=none; b=pKiRnV5PHoTU8n4mFlY98Z4N8Mq9sIU99L7nSoRFsAEvDAGZTWCd8EXWz+KnzY2ip4UmXLPzeTrqIXDEkS5QhYRB5taVGrsRLmtiY/M7dGieXIWWR/ViaezgWKQMx9Li8I/LNJnyBThEQfmyeV8WSwOtCAmJWmZdtObDcaeDEzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732935407; c=relaxed/simple;
	bh=1DBTuR3/7rWFyYj3TUDsFmheOUuzKbPuOBm76tKu84M=;
	h=Date:To:From:Subject:Message-Id; b=YFoFNFw9UzwpBQPqo8Rk0vkp15pjWdDf+nwu5Qewc5r5Pn2XHOhbDMQmf5qrwcbdpmGlL+yh6qmpt28UFNX8w3KcLjGZDH+tJU60rhoRQ+XCP1i5UW6/h/k6xhNc4/e+B4YYk7D1LODylzVuphTvzgSJYL/jVh0mM5HrdCtER0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JnZHUYNV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JnZHUYNV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAB39C4CECF;
	Sat, 30 Nov 2024 02:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732935405;
	bh=1DBTuR3/7rWFyYj3TUDsFmheOUuzKbPuOBm76tKu84M=;
	h=Date:To:From:Subject:From;
	b=JnZHUYNVjreRJ4y01n6MO8s8KvB0UU7Nx1EWMtQXQ4t6GTxqmnJIfod+TGlMBh5bR
	 6hyiutFAFWC11xaIzTmew25ulwPrSusHtx1fS6npB3obQ/HnuXZt0rEk/zhRqJcRlU
	 x09DaxFNPDZ/QdTfmnyLvBryI1kohKKnaixnZ6hM=
Date: Fri, 29 Nov 2024 18:56:45 -0800
To: mm-commits@vger.kernel.org,jserv@ccns.ncku.edu.tw,geert@linux-m68k.org,corbet@lwn.net,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-min_heap-improve-type-safety-in-min_heap-macros-by-using-container_of.patch added to mm-nonmm-unstable branch
Message-Id: <20241130025645.DAB39C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib min_heap: improve type safety in min_heap macros by using container_of
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-min_heap-improve-type-safety-in-min_heap-macros-by-using-container_of.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-min_heap-improve-type-safety-in-min_heap-macros-by-using-container_of.patch

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
Subject: lib min_heap: improve type safety in min_heap macros by using container_of
Date: Sat, 30 Nov 2024 02:12:19 +0800

Patch series "lib min_heap: Improve min_heap safety, testing, and
documentation".

Improve the min heap implementation by enhancing type safety with
container_of, reducing the attack vector by replacing test function calls
with inline variants, and adding a brief API introduction in min_heap.h. 
It also includes author information in
Documentation/core-api/min_heap.rst.


This patch (of 4):

The current implementation of min_heap macros uses explicit casting to
min_heap_char *, which prevents the compiler from detecting incorrect
pointer types.  This can lead to errors if non-min_heap pointers are
passed inadvertently.

To enhance safety, replace all explicit casts to min_heap_char * with the
use of container_of(&(_heap)->nr, min_heap_char, nr).  This approach
ensures that the _heap parameter is indeed a min_heap_char-compatible
structure, allowing the compiler to catch improper usages.

Link: https://lkml.kernel.org/r/20241129181222.646855-1-visitorckw@gmail.com
Link: https://lore.kernel.org/lkml/CAMuHMdVO5DPuD9HYWBFqKDHphx7+0BEhreUxtVC40A=8p6VAhQ@mail.gmail.com
Link: https://lkml.kernel.org/r/20241129181222.646855-2-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/min_heap.h |   61 +++++++++++++++++++++----------------
 1 file changed, 35 insertions(+), 26 deletions(-)

--- a/include/linux/min_heap.h~lib-min_heap-improve-type-safety-in-min_heap-macros-by-using-container_of
+++ a/include/linux/min_heap.h
@@ -218,7 +218,7 @@ void __min_heap_init_inline(min_heap_cha
 }
 
 #define min_heap_init_inline(_heap, _data, _size)	\
-	__min_heap_init_inline((min_heap_char *)_heap, _data, _size)
+	__min_heap_init_inline(container_of(&(_heap)->nr, min_heap_char, nr), _data, _size)
 
 /* Get the minimum element from the heap. */
 static __always_inline
@@ -228,7 +228,8 @@ void *__min_heap_peek_inline(struct min_
 }
 
 #define min_heap_peek_inline(_heap)	\
-	(__minheap_cast(_heap) __min_heap_peek_inline((min_heap_char *)_heap))
+	(__minheap_cast(_heap)	\
+	 __min_heap_peek_inline(container_of(&(_heap)->nr, min_heap_char, nr)))
 
 /* Check if the heap is full. */
 static __always_inline
@@ -238,7 +239,7 @@ bool __min_heap_full_inline(min_heap_cha
 }
 
 #define min_heap_full_inline(_heap)	\
-	__min_heap_full_inline((min_heap_char *)_heap)
+	__min_heap_full_inline(container_of(&(_heap)->nr, min_heap_char, nr))
 
 /* Sift the element at pos down the heap. */
 static __always_inline
@@ -277,8 +278,8 @@ void __min_heap_sift_down_inline(min_hea
 }
 
 #define min_heap_sift_down_inline(_heap, _pos, _func, _args)	\
-	__min_heap_sift_down_inline((min_heap_char *)_heap, _pos, __minheap_obj_size(_heap),	\
-				    _func, _args)
+	__min_heap_sift_down_inline(container_of(&(_heap)->nr, min_heap_char, nr), _pos,	\
+				    __minheap_obj_size(_heap), _func, _args)
 
 /* Sift up ith element from the heap, O(log2(nr)). */
 static __always_inline
@@ -304,8 +305,8 @@ void __min_heap_sift_up_inline(min_heap_
 }
 
 #define min_heap_sift_up_inline(_heap, _idx, _func, _args)	\
-	__min_heap_sift_up_inline((min_heap_char *)_heap, __minheap_obj_size(_heap), _idx,	\
-				  _func, _args)
+	__min_heap_sift_up_inline(container_of(&(_heap)->nr, min_heap_char, nr),	\
+				  __minheap_obj_size(_heap), _idx, _func, _args)
 
 /* Floyd's approach to heapification that is O(nr). */
 static __always_inline
@@ -319,7 +320,8 @@ void __min_heapify_all_inline(min_heap_c
 }
 
 #define min_heapify_all_inline(_heap, _func, _args)	\
-	__min_heapify_all_inline((min_heap_char *)_heap, __minheap_obj_size(_heap), _func, _args)
+	__min_heapify_all_inline(container_of(&(_heap)->nr, min_heap_char, nr),	\
+				 __minheap_obj_size(_heap), _func, _args)
 
 /* Remove minimum element from the heap, O(log2(nr)). */
 static __always_inline
@@ -340,7 +342,8 @@ bool __min_heap_pop_inline(min_heap_char
 }
 
 #define min_heap_pop_inline(_heap, _func, _args)	\
-	__min_heap_pop_inline((min_heap_char *)_heap, __minheap_obj_size(_heap), _func, _args)
+	__min_heap_pop_inline(container_of(&(_heap)->nr, min_heap_char, nr),	\
+			      __minheap_obj_size(_heap), _func, _args)
 
 /*
  * Remove the minimum element and then push the given element. The
@@ -356,8 +359,8 @@ void __min_heap_pop_push_inline(min_heap
 }
 
 #define min_heap_pop_push_inline(_heap, _element, _func, _args)	\
-	__min_heap_pop_push_inline((min_heap_char *)_heap, _element, __minheap_obj_size(_heap),	\
-				   _func, _args)
+	__min_heap_pop_push_inline(container_of(&(_heap)->nr, min_heap_char, nr), _element,	\
+				   __minheap_obj_size(_heap), _func, _args)
 
 /* Push an element on to the heap, O(log2(nr)). */
 static __always_inline
@@ -382,8 +385,8 @@ bool __min_heap_push_inline(min_heap_cha
 }
 
 #define min_heap_push_inline(_heap, _element, _func, _args)	\
-	__min_heap_push_inline((min_heap_char *)_heap, _element, __minheap_obj_size(_heap),	\
-			       _func, _args)
+	__min_heap_push_inline(container_of(&(_heap)->nr, min_heap_char, nr), _element,	\
+					    __minheap_obj_size(_heap), _func, _args)
 
 /* Remove ith element from the heap, O(log2(nr)). */
 static __always_inline
@@ -411,8 +414,8 @@ bool __min_heap_del_inline(min_heap_char
 }
 
 #define min_heap_del_inline(_heap, _idx, _func, _args)	\
-	__min_heap_del_inline((min_heap_char *)_heap, __minheap_obj_size(_heap), _idx,	\
-			      _func, _args)
+	__min_heap_del_inline(container_of(&(_heap)->nr, min_heap_char, nr),	\
+			      __minheap_obj_size(_heap), _idx, _func, _args)
 
 void __min_heap_init(min_heap_char *heap, void *data, int size);
 void *__min_heap_peek(struct min_heap_char *heap);
@@ -433,25 +436,31 @@ bool __min_heap_del(min_heap_char *heap,
 		    const struct min_heap_callbacks *func, void *args);
 
 #define min_heap_init(_heap, _data, _size)	\
-	__min_heap_init((min_heap_char *)_heap, _data, _size)
+	__min_heap_init(container_of(&(_heap)->nr, min_heap_char, nr), _data, _size)
 #define min_heap_peek(_heap)	\
-	(__minheap_cast(_heap) __min_heap_peek((min_heap_char *)_heap))
+	(__minheap_cast(_heap) __min_heap_peek(container_of(&(_heap)->nr, min_heap_char, nr)))
 #define min_heap_full(_heap)	\
-	__min_heap_full((min_heap_char *)_heap)
+	__min_heap_full(container_of(&(_heap)->nr, min_heap_char, nr))
 #define min_heap_sift_down(_heap, _pos, _func, _args)	\
-	__min_heap_sift_down((min_heap_char *)_heap, _pos, __minheap_obj_size(_heap), _func, _args)
+	__min_heap_sift_down(container_of(&(_heap)->nr, min_heap_char, nr), _pos,	\
+			     __minheap_obj_size(_heap), _func, _args)
 #define min_heap_sift_up(_heap, _idx, _func, _args)	\
-	__min_heap_sift_up((min_heap_char *)_heap, __minheap_obj_size(_heap), _idx, _func, _args)
+	__min_heap_sift_up(container_of(&(_heap)->nr, min_heap_char, nr),	\
+			   __minheap_obj_size(_heap), _idx, _func, _args)
 #define min_heapify_all(_heap, _func, _args)	\
-	__min_heapify_all((min_heap_char *)_heap, __minheap_obj_size(_heap), _func, _args)
+	__min_heapify_all(container_of(&(_heap)->nr, min_heap_char, nr),	\
+			  __minheap_obj_size(_heap), _func, _args)
 #define min_heap_pop(_heap, _func, _args)	\
-	__min_heap_pop((min_heap_char *)_heap, __minheap_obj_size(_heap), _func, _args)
+	__min_heap_pop(container_of(&(_heap)->nr, min_heap_char, nr),	\
+		       __minheap_obj_size(_heap), _func, _args)
 #define min_heap_pop_push(_heap, _element, _func, _args)	\
-	__min_heap_pop_push((min_heap_char *)_heap, _element, __minheap_obj_size(_heap),	\
-			    _func, _args)
+	__min_heap_pop_push(container_of(&(_heap)->nr, min_heap_char, nr), _element,	\
+			    __minheap_obj_size(_heap), _func, _args)
 #define min_heap_push(_heap, _element, _func, _args)	\
-	__min_heap_push((min_heap_char *)_heap, _element, __minheap_obj_size(_heap), _func, _args)
+	__min_heap_push(container_of(&(_heap)->nr, min_heap_char, nr), _element,	\
+			__minheap_obj_size(_heap), _func, _args)
 #define min_heap_del(_heap, _idx, _func, _args)	\
-	__min_heap_del((min_heap_char *)_heap, __minheap_obj_size(_heap), _idx, _func, _args)
+	__min_heap_del(container_of(&(_heap)->nr, min_heap_char, nr),	\
+		       __minheap_obj_size(_heap), _idx, _func, _args)
 
 #endif /* _LINUX_MIN_HEAP_H */
_

Patches currently in -mm which might be from visitorckw@gmail.com are

lib-min_heap-improve-type-safety-in-min_heap-macros-by-using-container_of.patch
lib-test_min_heap-use-inline-min-heap-variants-to-reduce-attack-vector.patch
lib-min_heap-add-brief-introduction-to-min-heap-api.patch
documentation-core-api-min_heap-add-author-information.patch

