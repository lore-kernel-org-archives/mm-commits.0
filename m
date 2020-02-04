From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 23/67] mm: remove __krealloc
Date: Mon, 03 Feb 2020 17:34:58 -0800
Message-ID: <20200204013458.4VHrt9Zmi%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726369AbgBDBe7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Feb 2020 20:34:59 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, david@redhat.com, fw@strlen.de, iamjoonsoo.kim@lge.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com, torvalds@linux-foundation.org

From: Florian Westphal <fw@strlen.de>
Subject: mm: remove __krealloc

Since 5.5-rc1 the last user of this function is gone, so remove the
functionality.

See commit
2ad9d7747c10 ("netfilter: conntrack: free extension area immediately")
for details.

Link: http://lkml.kernel.org/r/20191212223442.22141-1-fw@strlen.de
Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h                    |    1 -
 mm/slab_common.c                        |   22 ----------------------
 scripts/coccinelle/free/devm_free.cocci |    4 ----
 3 files changed, 27 deletions(-)

--- a/include/linux/slab.h~mm-remove-__krealloc
+++ a/include/linux/slab.h
@@ -184,7 +184,6 @@ void memcg_deactivate_kmem_caches(struct
 /*
  * Common kmalloc functions provided by all allocators
  */
-void * __must_check __krealloc(const void *, size_t, gfp_t);
 void * __must_check krealloc(const void *, size_t, gfp_t);
 void kfree(const void *);
 void kzfree(const void *);
--- a/mm/slab_common.c~mm-remove-__krealloc
+++ a/mm/slab_common.c
@@ -1677,28 +1677,6 @@ static __always_inline void *__do_kreall
 }
 
 /**
- * __krealloc - like krealloc() but don't free @p.
- * @p: object to reallocate memory for.
- * @new_size: how many bytes of memory are required.
- * @flags: the type of memory to allocate.
- *
- * This function is like krealloc() except it never frees the originally
- * allocated buffer. Use this if you don't want to free the buffer immediately
- * like, for example, with RCU.
- *
- * Return: pointer to the allocated memory or %NULL in case of error
- */
-void *__krealloc(const void *p, size_t new_size, gfp_t flags)
-{
-	if (unlikely(!new_size))
-		return ZERO_SIZE_PTR;
-
-	return __do_krealloc(p, new_size, flags);
-
-}
-EXPORT_SYMBOL(__krealloc);
