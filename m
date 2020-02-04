From: akpm@linux-foundation.org
Subject: [merged] mm-remove-__krealloc.patch removed from -mm tree
Date: Tue, 04 Feb 2020 10:40:49 -0800
Message-ID: <20200204184049.peB6rCIdD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727511AbgBDSku (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 Feb 2020 13:40:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, david@redhat.com, fw@strlen.de, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com


The patch titled
     Subject: mm: remove __krealloc
has been removed from the -mm tree.  Its filename was
     mm-remove-__krealloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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
-
-/**
  * krealloc - reallocate memory. The contents will remain unchanged.
  * @p: object to reallocate memory for.
  * @new_size: how many bytes of memory are required.
--- a/scripts/coccinelle/free/devm_free.cocci~mm-remove-__krealloc
+++ a/scripts/coccinelle/free/devm_free.cocci
@@ -91,8 +91,6 @@ position p;
 |
  kzfree@p(x)
 |
- __krealloc@p(x, ...)
-|
  krealloc@p(x, ...)
 |
  free_pages@p(x, ...)
@@ -116,8 +114,6 @@ position p != safe.p;
 |
 * kzfree@p(x)
 |
-* __krealloc@p(x, ...)
-|
 * krealloc@p(x, ...)
 |
 * free_pages@p(x, ...)
_

Patches currently in -mm which might be from fw@strlen.de are
