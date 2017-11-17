From: akpm@linux-foundation.org
Subject: [patch 35/94] lib/genalloc.c: make the avail variable an
 atomic_long_t
Date: Fri, 17 Nov 2017 15:28:16 -0800
Message-ID: <20171117232816.AcLZLdk-A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55558 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965622AbdKQX2S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:28:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, corbet@lwn.net, danielmentz@google.com, logang@deltatee.com, mathieu.desnoyers@efficios.com, mm-commits@vger.kernel.org, sbates@raithlin.com, torvalds@linux-foundation.org, will.deacon@arm.com

From: Stephen Bates <sbates@raithlin.com>
Subject: lib/genalloc.c: make the avail variable an atomic_long_t

If the amount of resources allocated to a gen_pool exceeds 2^32 then the
avail atomic overflows and this causes problems when clients try and
borrow resources from the pool.  This is only expected to be an issue on
64 bit systems.

Add the <linux/atomic.h> header to pull in atomic_long* operations.  So
that 32 bit systems continue to use atomic32_t but 64 bit systems can use
atomic64_t.

Link: http://lkml.kernel.org/r/1509033843-25667-1-git-send-email-sbates@raithlin.com
Signed-off-by: Stephen Bates <sbates@raithlin.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Daniel Mentz <danielmentz@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/genalloc.h |    3 ++-
 lib/genalloc.c           |   10 +++++-----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff -puN include/linux/genalloc.h~genalloc-make-the-avail-variable-an-atomic_long_t include/linux/genalloc.h
--- a/include/linux/genalloc.h~genalloc-make-the-avail-variable-an-atomic_long_t
+++ a/include/linux/genalloc.h
@@ -32,6 +32,7 @@
 
 #include <linux/types.h>
 #include <linux/spinlock_types.h>
+#include <linux/atomic.h>
 
 struct device;
 struct device_node;
@@ -71,7 +72,7 @@ struct gen_pool {
  */
 struct gen_pool_chunk {
 	struct list_head next_chunk;	/* next chunk in pool */
-	atomic_t avail;
+	atomic_long_t avail;
 	phys_addr_t phys_addr;		/* physical starting address of memory chunk */
 	unsigned long start_addr;	/* start address of memory chunk */
 	unsigned long end_addr;		/* end address of memory chunk (inclusive) */
diff -puN lib/genalloc.c~genalloc-make-the-avail-variable-an-atomic_long_t lib/genalloc.c
--- a/lib/genalloc.c~genalloc-make-the-avail-variable-an-atomic_long_t
+++ a/lib/genalloc.c
@@ -194,7 +194,7 @@ int gen_pool_add_virt(struct gen_pool *p
 	chunk->phys_addr = phys;
 	chunk->start_addr = virt;
 	chunk->end_addr = virt + size - 1;
-	atomic_set(&chunk->avail, size);
+	atomic_long_set(&chunk->avail, size);
 
 	spin_lock(&pool->lock);
 	list_add_rcu(&chunk->next_chunk, &pool->chunks);
@@ -304,7 +304,7 @@ unsigned long gen_pool_alloc_algo(struct
 	nbits = (size + (1UL << order) - 1) >> order;
 	rcu_read_lock();
 	list_for_each_entry_rcu(chunk, &pool->chunks, next_chunk) {
-		if (size > atomic_read(&chunk->avail))
+		if (size > atomic_long_read(&chunk->avail))
 			continue;
 
 		start_bit = 0;
@@ -324,7 +324,7 @@ retry:
 
 		addr = chunk->start_addr + ((unsigned long)start_bit << order);
 		size = nbits << order;
-		atomic_sub(size, &chunk->avail);
+		atomic_long_sub(size, &chunk->avail);
 		break;
 	}
 	rcu_read_unlock();
@@ -390,7 +390,7 @@ void gen_pool_free(struct gen_pool *pool
 			remain = bitmap_clear_ll(chunk->bits, start_bit, nbits);
 			BUG_ON(remain);
 			size = nbits << order;
-			atomic_add(size, &chunk->avail);
+			atomic_long_add(size, &chunk->avail);
 			rcu_read_unlock();
 			return;
 		}
@@ -464,7 +464,7 @@ size_t gen_pool_avail(struct gen_pool *p
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(chunk, &pool->chunks, next_chunk)
-		avail += atomic_read(&chunk->avail);
+		avail += atomic_long_read(&chunk->avail);
 	rcu_read_unlock();
 	return avail;
 }
_
