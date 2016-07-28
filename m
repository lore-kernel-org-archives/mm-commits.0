From: akpm@linux-foundation.org
Subject: [patch 092/101] mm, kasan: account for object redzone in SLUB's
 nearest_obj()
Date: Thu, 28 Jul 2016 15:49:04 -0700
Message-ID: <579a8be0.WAOCq+rA8qYuTODl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57284 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbcG1WtG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:49:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, glider@google.com, adech.fo@gmail.com, aryabinin@virtuozzo.com, cl@linux.com, dvyukov@google.com, iamjoonsoo.kim@lge.com, kcc@google.com, kuthonuzo.luruo@hpe.com, rostedt@goodmis.org

From: Alexander Potapenko <glider@google.com>
Subject: mm, kasan: account for object redzone in SLUB's nearest_obj()

When looking up the nearest SLUB object for a given address, correctly
calculate its offset if SLAB_RED_ZONE is enabled for that cache.

Previously, when KASAN had detected an error on an object from a cache
with SLAB_RED_ZONE set, the actual start address of the object was
miscalculated, which led to random stacks having been reported.

When looking up the nearest SLUB object for a given address, correctly
calculate its offset if SLAB_RED_ZONE is enabled for that cache.

Fixes: 7ed2f9e663854db ("mm, kasan: SLAB support")
Link: http://lkml.kernel.org/r/1468347165-41906-2-git-send-email-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <adech.fo@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Steven Rostedt (Red Hat) <rostedt@goodmis.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kostya Serebryany <kcc@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Kuthonuzo Luruo <kuthonuzo.luruo@hpe.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slub_def.h |   10 ++++++----
 mm/slub.c                |    2 +-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff -puN include/linux/slub_def.h~mm-kasan-account-for-object-redzone-in-slubs-nearest_obj include/linux/slub_def.h
--- a/include/linux/slub_def.h~mm-kasan-account-for-object-redzone-in-slubs-nearest_obj
+++ a/include/linux/slub_def.h
@@ -119,15 +119,17 @@ static inline void sysfs_slab_remove(str
 void object_err(struct kmem_cache *s, struct page *page,
 		u8 *object, char *reason);
 
+void *fixup_red_left(struct kmem_cache *s, void *p);
+
 static inline void *nearest_obj(struct kmem_cache *cache, struct page *page,
 				void *x) {
 	void *object = x - (x - page_address(page)) % cache->size;
 	void *last_object = page_address(page) +
 		(page->objects - 1) * cache->size;
-	if (unlikely(object > last_object))
-		return last_object;
-	else
-		return object;
+	void *result = (unlikely(object > last_object)) ? last_object : object;
+
+	result = fixup_red_left(cache, result);
+	return result;
 }
 
 #endif /* _LINUX_SLUB_DEF_H */
diff -puN mm/slub.c~mm-kasan-account-for-object-redzone-in-slubs-nearest_obj mm/slub.c
--- a/mm/slub.c~mm-kasan-account-for-object-redzone-in-slubs-nearest_obj
+++ a/mm/slub.c
@@ -124,7 +124,7 @@ static inline int kmem_cache_debug(struc
 #endif
 }
 
-static inline void *fixup_red_left(struct kmem_cache *s, void *p)
+inline void *fixup_red_left(struct kmem_cache *s, void *p)
 {
 	if (kmem_cache_debug(s) && s->flags & SLAB_RED_ZONE)
 		p += s->red_left_pad;
_
