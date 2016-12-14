From: akpm@linux-foundation.org
Subject: [merged] mm-check-kmem_create_cache-flags-are-commons.patch
 removed from -mm tree
Date: Wed, 14 Dec 2016 11:23:34 -0800
Message-ID: <58519c36.uXbjcBqZzK9c/45S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43998 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754107AbcLNTXf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:23:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thgarnie@google.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab_common.c: check kmem_create_cache flags are common
has been removed from the -mm tree.  Its filename was
     mm-check-kmem_create_cache-flags-are-commons.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Thomas Garnier <thgarnie@google.com>
Subject: mm/slab_common.c: check kmem_create_cache flags are common

Verify that kmem_create_cache flags are not allocator specific.  It is
done before removing flags that are not available with the current
configuration.

The current kmem_cache_create removes incorrect flags but do not
validate the callers are using them right.  This change will ensure
that callers are not trying to create caches with flags that won't be
used because allocator specific.

Link: http://lkml.kernel.org/r/1478553075-120242-2-git-send-email-thgarnie@google.com
Signed-off-by: Thomas Garnier <thgarnie@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.h        |   15 +++++++++++++++
 mm/slab_common.c |    6 ++++++
 2 files changed, 21 insertions(+)

diff -puN mm/slab.h~mm-check-kmem_create_cache-flags-are-commons mm/slab.h
--- a/mm/slab.h~mm-check-kmem_create_cache-flags-are-commons
+++ a/mm/slab.h
@@ -142,8 +142,23 @@ static inline unsigned long kmem_cache_f
 #define SLAB_CACHE_FLAGS (0)
 #endif
 
+/* Common flags available with current configuration */
 #define CACHE_CREATE_MASK (SLAB_CORE_FLAGS | SLAB_DEBUG_FLAGS | SLAB_CACHE_FLAGS)
 
+/* Common flags permitted for kmem_cache_create */
+#define SLAB_FLAGS_PERMITTED (SLAB_CORE_FLAGS | \
+			      SLAB_RED_ZONE | \
+			      SLAB_POISON | \
+			      SLAB_STORE_USER | \
+			      SLAB_TRACE | \
+			      SLAB_CONSISTENCY_CHECKS | \
+			      SLAB_MEM_SPREAD | \
+			      SLAB_NOLEAKTRACE | \
+			      SLAB_RECLAIM_ACCOUNT | \
+			      SLAB_TEMPORARY | \
+			      SLAB_NOTRACK | \
+			      SLAB_ACCOUNT)
+
 int __kmem_cache_shutdown(struct kmem_cache *);
 void __kmem_cache_release(struct kmem_cache *);
 int __kmem_cache_shrink(struct kmem_cache *);
diff -puN mm/slab_common.c~mm-check-kmem_create_cache-flags-are-commons mm/slab_common.c
--- a/mm/slab_common.c~mm-check-kmem_create_cache-flags-are-commons
+++ a/mm/slab_common.c
@@ -404,6 +404,12 @@ kmem_cache_create(const char *name, size
 		goto out_unlock;
 	}
 
+	/* Refuse requests with allocator specific flags */
+	if (flags & ~SLAB_FLAGS_PERMITTED) {
+		err = -EINVAL;
+		goto out_unlock;
+	}
+
 	/*
 	 * Some allocators will constraint the set of valid flags to a subset
 	 * of all flags. We expect them to define CACHE_CREATE_MASK in this
_

Patches currently in -mm which might be from thgarnie@google.com are


