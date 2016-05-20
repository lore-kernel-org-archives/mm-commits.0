From: akpm@linux-foundation.org
Subject: [patch 058/162] mm, kasan: don't call kasan_krealloc() from
 ksize().
Date: Fri, 20 May 2016 16:59:14 -0700
Message-ID: <573fa4d2.S2BOMh0uwlAsrW//%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52427 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbcETX7P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:59:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, glider@google.com, adech.fo@gmail.com, aryabinin@virtuozzo.com, cl@linux.com, dvyukov@google.com, kcc@google.com

From: Alexander Potapenko <glider@google.com>
Subject: mm, kasan: don't call kasan_krealloc() from ksize().

Instead of calling kasan_krealloc(), which replaces the memory allocation
stack ID (if stack depot is used), just unpoison the whole memory chunk.

Signed-off-by: Alexander Potapenko <glider@google.com>
Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Andrey Konovalov <adech.fo@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Konstantin Serebryany <kcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    2 +-
 mm/slub.c |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/slab.c~mm-kasan-dont-call-kasan_krealloc-from-ksize mm/slab.c
--- a/mm/slab.c~mm-kasan-dont-call-kasan_krealloc-from-ksize
+++ a/mm/slab.c
@@ -4501,7 +4501,7 @@ size_t ksize(const void *objp)
 	/* We assume that ksize callers could use the whole allocated area,
 	 * so we need to unpoison this area.
 	 */
-	kasan_krealloc(objp, size, GFP_NOWAIT);
+	kasan_unpoison_shadow(objp, size);
 
 	return size;
 }
diff -puN mm/slub.c~mm-kasan-dont-call-kasan_krealloc-from-ksize mm/slub.c
--- a/mm/slub.c~mm-kasan-dont-call-kasan_krealloc-from-ksize
+++ a/mm/slub.c
@@ -3635,8 +3635,9 @@ size_t ksize(const void *object)
 {
 	size_t size = __ksize(object);
 	/* We assume that ksize callers could use whole allocated area,
-	   so we need unpoison this area. */
-	kasan_krealloc(object, size, GFP_NOWAIT);
+	 * so we need to unpoison this area.
+	 */
+	kasan_unpoison_shadow(object, size);
 	return size;
 }
 EXPORT_SYMBOL(ksize);
_
