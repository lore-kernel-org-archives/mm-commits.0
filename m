From: akpm@linux-foundation.org
Subject: [patch 04/10] mm: slub: remove unused virt_to_obj()
Date: Thu, 26 May 2016 15:16:14 -0700
Message-ID: <574775ae.z1E8a4+v6Y8KFKw+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49384 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187AbcEZWQP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 May 2016 18:16:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, aryabinin@virtuozzo.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com

From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: mm: slub: remove unused virt_to_obj()

It's unused since commit 7ed2f9e66385 ("mm, kasan: SLAB support")

Link: http://lkml.kernel.org/r/1464020961-2242-1-git-send-email-aryabinin@virtuozzo.com
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slub_def.h |   16 ----------------
 1 file changed, 16 deletions(-)

diff -puN include/linux/slub_def.h~mm-slub-remove-unused-virt_to_obj include/linux/slub_def.h
--- a/include/linux/slub_def.h~mm-slub-remove-unused-virt_to_obj
+++ a/include/linux/slub_def.h
@@ -111,22 +111,6 @@ static inline void sysfs_slab_remove(str
 }
 #endif
 
-
-/**
- * virt_to_obj - returns address of the beginning of object.
- * @s: object's kmem_cache
- * @slab_page: address of slab page
- * @x: address within object memory range
- *
- * Returns address of the beginning of object
- */
-static inline void *virt_to_obj(struct kmem_cache *s,
-				const void *slab_page,
-				const void *x)
-{
-	return (void *)x - ((x - slab_page) % s->size);
-}
