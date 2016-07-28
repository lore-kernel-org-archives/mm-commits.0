From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub-fix.patch removed from -mm tree
Date: Thu, 28 Jul 2016 15:13:22 -0700
Message-ID: <579a8382.oLvLFJud9DkLzYUp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54870 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbcG1WNX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:13:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject:  mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub-fix
has been removed from the -mm tree.  Its filename was
     mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub-fix.patch

This patch was dropped because it was folded into mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub.patch

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject:  mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub-fix

- Remove CONFIG_SLAB ifdefs. The code works just fine with both allocators.
- Reset metada offsets if metadata doesn't fit. Otherwise kasan_metadata_size()
will give us the wrong results.

Link: http://lkml.kernel.org/r/1468601423-28676-1-git-send-email-aryabinin@virtuozzo.com
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Acked-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff -puN mm/kasan/kasan.c~mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub-fix mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub-fix
+++ a/mm/kasan/kasan.c
@@ -372,9 +372,7 @@ void kasan_cache_create(struct kmem_cach
 			unsigned long *flags)
 {
 	int redzone_adjust;
-#ifdef CONFIG_SLAB
 	int orig_size = *size;
-#endif
 
 	/* Add alloc meta. */
 	cache->kasan_info.alloc_meta_offset = *size;
@@ -392,25 +390,20 @@ void kasan_cache_create(struct kmem_cach
 	if (redzone_adjust > 0)
 		*size += redzone_adjust;
 
-#ifdef CONFIG_SLAB
-	*size = min(KMALLOC_MAX_SIZE,
-		    max(*size,
-			cache->object_size +
-			optimal_redzone(cache->object_size)));
+	*size = min(KMALLOC_MAX_SIZE, max(*size, cache->object_size +
+					optimal_redzone(cache->object_size)));
+
 	/*
 	 * If the metadata doesn't fit, don't enable KASAN at all.
 	 */
 	if (*size <= cache->kasan_info.alloc_meta_offset ||
 			*size <= cache->kasan_info.free_meta_offset) {
+		cache->kasan_info.alloc_meta_offset = 0;
+		cache->kasan_info.free_meta_offset = 0;
 		*size = orig_size;
 		return;
 	}
-#else
-	*size = max(*size,
-			cache->object_size +
-			optimal_redzone(cache->object_size));
 
-#endif
 	*flags |= SLAB_KASAN;
 }
 
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are

mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub.patch

