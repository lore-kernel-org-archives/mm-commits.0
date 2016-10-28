From: akpm@linux-foundation.org
Subject: [patch 15/20] lib/genalloc.c: start search from start of chunk
Date: Thu, 27 Oct 2016 17:46:59 -0700
Message-ID: <5812a003.8z3GSFerTw5x9J4g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57954 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S943135AbcJ1ArA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2016 20:47:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, danielmentz@google.com, mathieu.desnoyers@efficios.com, will.deacon@arm.com

From: Daniel Mentz <danielmentz@google.com>
Subject: lib/genalloc.c: start search from start of chunk

gen_pool_alloc_algo() iterates over the chunks of a pool trying to find a
contiguous block of memory that satisfies the allocation request.

The shortcut

	if (size > atomic_read(&chunk->avail))
		continue;

makes the loop skip over chunks that do not have enough bytes left to
fulfill the request.  There are two situations, though, where an
allocation might still fail:

(1) The available memory is not contiguous, i.e.  the request cannot
    be fulfilled due to external fragmentation.

(2) A race condition.  Another thread runs the same code concurrently
    and is quicker to grab the available memory.

In those situations, the loop calls pool->algo() to search the entire
chunk, and pool->algo() returns some value that is >= end_bit to indicate
that the search failed.  This return value is then assigned to start_bit. 
The variables start_bit and end_bit describe the range that should be
searched, and this range should be reset for every chunk that is searched.
Today, the code fails to reset start_bit to 0.  As a result, prefixes of
subsequent chunks are ignored.  Memory allocations might fail even though
there is plenty of room left in these prefixes of those other chunks.

Fixes: 7f184275aa30 ("lib, Make gen_pool memory allocator lockless")
Link: http://lkml.kernel.org/r/1477420604-28918-1-git-send-email-danielmentz@google.com
Signed-off-by: Daniel Mentz <danielmentz@google.com>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/genalloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN lib/genalloc.c~lib-genallocc-start-search-from-start-of-chunk lib/genalloc.c
--- a/lib/genalloc.c~lib-genallocc-start-search-from-start-of-chunk
+++ a/lib/genalloc.c
@@ -292,7 +292,7 @@ unsigned long gen_pool_alloc_algo(struct
 	struct gen_pool_chunk *chunk;
 	unsigned long addr = 0;
 	int order = pool->min_alloc_order;
-	int nbits, start_bit = 0, end_bit, remain;
+	int nbits, start_bit, end_bit, remain;
 
 #ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
 	BUG_ON(in_nmi());
@@ -307,6 +307,7 @@ unsigned long gen_pool_alloc_algo(struct
 		if (size > atomic_read(&chunk->avail))
 			continue;
 
+		start_bit = 0;
 		end_bit = chunk_size(chunk) >> order;
 retry:
 		start_bit = algo(chunk->bits, end_bit, start_bit,
_
