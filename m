From: akpm@linux-foundation.org
Subject: [merged] mm-slabh-wrap-the-whole-file-with-guarding-macro.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:02:57 -0700
Message-ID: <53e3db71.YFYWa09IWLX9swWv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:50141 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191AbaHGUC6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:02:58 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so1172741pab.4
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:02:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.ryabinin@samsung.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: slab.h: wrap the whole file with guarding macro
has been removed from the -mm tree.  Its filename was
     mm-slabh-wrap-the-whole-file-with-guarding-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: mm: slab.h: wrap the whole file with guarding macro

Guarding section:
	#ifndef MM_SLAB_H
	#define MM_SLAB_H
	...
	#endif
currently doesn't cover the whole mm/slab.h. It seems like it was
done unintentionally.

Wrap the whole file by moving closing #endif to the end of it.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/slab.h~mm-slabh-wrap-the-whole-file-with-guarding-macro mm/slab.h
--- a/mm/slab.h~mm-slabh-wrap-the-whole-file-with-guarding-macro
+++ a/mm/slab.h
@@ -260,7 +260,6 @@ static inline struct kmem_cache *cache_f
 	WARN_ON_ONCE(1);
 	return s;
 }
-#endif
 
 #ifndef CONFIG_SLOB
 /*
@@ -311,3 +310,5 @@ static inline struct kmem_cache_node *ge
 
 void *slab_next(struct seq_file *m, void *p, loff_t *pos);
 void slab_stop(struct seq_file *m, void *p);
+
+#endif /* MM_SLAB_H */
_

Patches currently in -mm which might be from a.ryabinin@samsung.com are

origin.patch
lib-idr-fix-out-of-bounds-pointer-dereference.patch

