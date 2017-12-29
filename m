From: akpm@linux-foundation.org
Subject: +
 kasan-unify-code-between-kasan_slab_free-and-kasan_poison_kfree.patch added to -mm tree
Date: Thu, 28 Dec 2017 16:06:41 -0800
Message-ID: <5a458711.wx3K3yaF5NvUWKty%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43204 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751253AbdL2AGm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Dec 2017 19:06:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvyukov@google.com, aryabinin@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: unify code between kasan_slab_free() and kasan_poison_kfree()
has been added to the -mm tree.  Its filename is
     kasan-unify-code-between-kasan_slab_free-and-kasan_poison_kfree.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-unify-code-between-kasan_slab_free-and-kasan_poison_kfree.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-unify-code-between-kasan_slab_free-and-kasan_poison_kfree.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dmitry Vyukov <dvyukov@google.com>
Subject: kasan: unify code between kasan_slab_free() and kasan_poison_kfree()

Both of these functions deal with freeing of slab objects.
However, kasan_poison_kfree() mishandles SLAB_TYPESAFE_BY_RCU
(must also not poison such objects) and does not detect double-frees.

Unify code between these functions.
This solves both of the problems and allows to add more common code
(e.g. detection of invalid frees).

Link: http://lkml.kernel.org/r/385493d863acf60408be219a021c3c8e27daa96f.1514378558.git.dvyukov@google.com
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>a
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.c |   28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff -puN mm/kasan/kasan.c~kasan-unify-code-between-kasan_slab_free-and-kasan_poison_kfree mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~kasan-unify-code-between-kasan_slab_free-and-kasan_poison_kfree
+++ a/mm/kasan/kasan.c
@@ -489,21 +489,11 @@ void kasan_slab_alloc(struct kmem_cache
 	kasan_kmalloc(cache, object, cache->object_size, flags);
 }
 
-static void kasan_poison_slab_free(struct kmem_cache *cache, void *object)
-{
-	unsigned long size = cache->object_size;
-	unsigned long rounded_up_size = round_up(size, KASAN_SHADOW_SCALE_SIZE);
-
-	/* RCU slabs could be legally used after free within the RCU period */
-	if (unlikely(cache->flags & SLAB_TYPESAFE_BY_RCU))
-		return;
-
-	kasan_poison_shadow(object, rounded_up_size, KASAN_KMALLOC_FREE);
-}
-
-bool kasan_slab_free(struct kmem_cache *cache, void *object, unsigned long ip)
+static bool __kasan_slab_free(struct kmem_cache *cache, void *object,
+			      unsigned long ip, bool quarantine)
 {
 	s8 shadow_byte;
+	unsigned long rounded_up_size;
 
 	/* RCU slabs could be legally used after free within the RCU period */
 	if (unlikely(cache->flags & SLAB_TYPESAFE_BY_RCU))
@@ -515,9 +505,10 @@ bool kasan_slab_free(struct kmem_cache *
 		return true;
 	}
 
-	kasan_poison_slab_free(cache, object);
+	rounded_up_size = round_up(cache->object_size, KASAN_SHADOW_SCALE_SIZE);
+	kasan_poison_shadow(object, rounded_up_size, KASAN_KMALLOC_FREE);
 
-	if (unlikely(!(cache->flags & SLAB_KASAN)))
+	if (!quarantine || unlikely(!(cache->flags & SLAB_KASAN)))
 		return false;
 
 	set_track(&get_alloc_info(cache, object)->free_track, GFP_NOWAIT);
@@ -525,6 +516,11 @@ bool kasan_slab_free(struct kmem_cache *
 	return true;
 }
 
+bool kasan_slab_free(struct kmem_cache *cache, void *object, unsigned long ip)
+{
+	return __kasan_slab_free(cache, object, ip, true);
+}
+
 void kasan_kmalloc(struct kmem_cache *cache, const void *object, size_t size,
 		   gfp_t flags)
 {
@@ -602,7 +598,7 @@ void kasan_poison_kfree(void *ptr, unsig
 		kasan_poison_shadow(ptr, PAGE_SIZE << compound_order(page),
 				KASAN_FREE_PAGE);
 	} else {
-		kasan_poison_slab_free(page->slab_cache, ptr);
+		__kasan_slab_free(page->slab_cache, ptr, ip, false);
 	}
 }
 
_

Patches currently in -mm which might be from dvyukov@google.com are

kasan-detect-invalid-frees-for-large-objects.patch
kasan-dont-use-__builtin_return_address1.patch
kasan-detect-invalid-frees-for-large-mempool-objects.patch
kasan-unify-code-between-kasan_slab_free-and-kasan_poison_kfree.patch
kasan-detect-invalid-frees.patch

