From: akpm@linux-foundation.org
Subject: + kasan-dont-use-__builtin_return_address1.patch added to -mm
 tree
Date: Thu, 28 Dec 2017 16:06:34 -0800
Message-ID: <5a45870a.YjGyMen0Vndhl4Ki%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43180 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751253AbdL2AGg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Dec 2017 19:06:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvyukov@google.com, aryabinin@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: don't use __builtin_return_address(1)
has been added to the -mm tree.  Its filename is
     kasan-dont-use-__builtin_return_address1.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-dont-use-__builtin_return_address1.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-dont-use-__builtin_return_address1.patch

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
Subject: kasan: don't use __builtin_return_address(1)

__builtin_return_address(1) is unreliable without frame pointers.
With defconfig on kmalloc_pagealloc_invalid_free test I am getting:

BUG: KASAN: double-free or invalid-free in           (null)

Pass caller PC from callers explicitly.

Link: http://lkml.kernel.org/r/9b01bc2d237a4df74ff8472a3bf6b7635908de01.1514378558.git.dvyukov@google.com
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>a
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |    9 +++++----
 mm/kasan/kasan.c      |    8 ++++----
 mm/kasan/kasan.h      |    2 +-
 mm/kasan/report.c     |    4 ++--
 mm/slab.c             |    6 +++---
 mm/slub.c             |    8 ++++----
 6 files changed, 19 insertions(+), 18 deletions(-)

diff -puN include/linux/kasan.h~kasan-dont-use-__builtin_return_address1 include/linux/kasan.h
--- a/include/linux/kasan.h~kasan-dont-use-__builtin_return_address1
+++ a/include/linux/kasan.h
@@ -56,14 +56,14 @@ void kasan_poison_object_data(struct kme
 void kasan_init_slab_obj(struct kmem_cache *cache, const void *object);
 
 void kasan_kmalloc_large(const void *ptr, size_t size, gfp_t flags);
-void kasan_kfree_large(void *ptr);
+void kasan_kfree_large(void *ptr, unsigned long ip);
 void kasan_poison_kfree(void *ptr);
 void kasan_kmalloc(struct kmem_cache *s, const void *object, size_t size,
 		  gfp_t flags);
 void kasan_krealloc(const void *object, size_t new_size, gfp_t flags);
 
 void kasan_slab_alloc(struct kmem_cache *s, void *object, gfp_t flags);
-bool kasan_slab_free(struct kmem_cache *s, void *object);
+bool kasan_slab_free(struct kmem_cache *s, void *object, unsigned long ip);
 
 struct kasan_cache {
 	int alloc_meta_offset;
@@ -108,7 +108,7 @@ static inline void kasan_init_slab_obj(s
 				const void *object) {}
 
 static inline void kasan_kmalloc_large(void *ptr, size_t size, gfp_t flags) {}
-static inline void kasan_kfree_large(void *ptr) {}
+static inline void kasan_kfree_large(void *ptr, unsigned long ip) {}
 static inline void kasan_poison_kfree(void *ptr) {}
 static inline void kasan_kmalloc(struct kmem_cache *s, const void *object,
 				size_t size, gfp_t flags) {}
@@ -117,7 +117,8 @@ static inline void kasan_krealloc(const
 
 static inline void kasan_slab_alloc(struct kmem_cache *s, void *object,
 				   gfp_t flags) {}
-static inline bool kasan_slab_free(struct kmem_cache *s, void *object)
+static inline bool kasan_slab_free(struct kmem_cache *s, void *object,
+				   unsigned long ip)
 {
 	return false;
 }
diff -puN mm/kasan/kasan.c~kasan-dont-use-__builtin_return_address1 mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~kasan-dont-use-__builtin_return_address1
+++ a/mm/kasan/kasan.c
@@ -501,7 +501,7 @@ static void kasan_poison_slab_free(struc
 	kasan_poison_shadow(object, rounded_up_size, KASAN_KMALLOC_FREE);
 }
 
-bool kasan_slab_free(struct kmem_cache *cache, void *object)
+bool kasan_slab_free(struct kmem_cache *cache, void *object, unsigned long ip)
 {
 	s8 shadow_byte;
 
@@ -511,7 +511,7 @@ bool kasan_slab_free(struct kmem_cache *
 
 	shadow_byte = READ_ONCE(*(s8 *)kasan_mem_to_shadow(object));
 	if (shadow_byte < 0 || shadow_byte >= KASAN_SHADOW_SCALE_SIZE) {
-		kasan_report_invalid_free(object, __builtin_return_address(1));
+		kasan_report_invalid_free(object, ip);
 		return true;
 	}
 
@@ -601,10 +601,10 @@ void kasan_poison_kfree(void *ptr)
 		kasan_poison_slab_free(page->slab_cache, ptr);
 }
 
-void kasan_kfree_large(void *ptr)
+void kasan_kfree_large(void *ptr, unsigned long ip)
 {
 	if (ptr != page_address(virt_to_head_page(ptr)))
-		kasan_report_invalid_free(ptr, __builtin_return_address(1));
+		kasan_report_invalid_free(ptr, ip);
 	/* The object will be poisoned by page_alloc. */
 }
 
diff -puN mm/kasan/kasan.h~kasan-dont-use-__builtin_return_address1 mm/kasan/kasan.h
--- a/mm/kasan/kasan.h~kasan-dont-use-__builtin_return_address1
+++ a/mm/kasan/kasan.h
@@ -107,7 +107,7 @@ static inline const void *kasan_shadow_t
 
 void kasan_report(unsigned long addr, size_t size,
 		bool is_write, unsigned long ip);
-void kasan_report_invalid_free(void *object, void *ip);
+void kasan_report_invalid_free(void *object, unsigned long ip);
 
 #if defined(CONFIG_SLAB) || defined(CONFIG_SLUB)
 void quarantine_put(struct kasan_free_meta *info, struct kmem_cache *cache);
diff -puN mm/kasan/report.c~kasan-dont-use-__builtin_return_address1 mm/kasan/report.c
--- a/mm/kasan/report.c~kasan-dont-use-__builtin_return_address1
+++ a/mm/kasan/report.c
@@ -326,12 +326,12 @@ static void print_shadow_for_address(con
 	}
 }
 
-void kasan_report_invalid_free(void *object, void *ip)
+void kasan_report_invalid_free(void *object, unsigned long ip)
 {
 	unsigned long flags;
 
 	kasan_start_report(&flags);
-	pr_err("BUG: KASAN: double-free or invalid-free in %pS\n", ip);
+	pr_err("BUG: KASAN: double-free or invalid-free in %pS\n", (void *)ip);
 	pr_err("\n");
 	print_address_description(object);
 	pr_err("\n");
diff -puN mm/slab.c~kasan-dont-use-__builtin_return_address1 mm/slab.c
--- a/mm/slab.c~kasan-dont-use-__builtin_return_address1
+++ a/mm/slab.c
@@ -3477,11 +3477,11 @@ free_done:
  * Release an obj back to its cache. If the obj has a constructed state, it must
  * be in this state _before_ it is released.  Called with disabled ints.
  */
-static inline void __cache_free(struct kmem_cache *cachep, void *objp,
-				unsigned long caller)
+static __always_inline void __cache_free(struct kmem_cache *cachep, void *objp,
+					 unsigned long caller)
 {
 	/* Put the object into the quarantine, don't touch it for now. */
-	if (kasan_slab_free(cachep, objp))
+	if (kasan_slab_free(cachep, objp, _RET_IP_))
 		return;
 
 	___cache_free(cachep, objp, caller);
diff -puN mm/slub.c~kasan-dont-use-__builtin_return_address1 mm/slub.c
--- a/mm/slub.c~kasan-dont-use-__builtin_return_address1
+++ a/mm/slub.c
@@ -1354,13 +1354,13 @@ static inline void kmalloc_large_node_ho
 	kasan_kmalloc_large(ptr, size, flags);
 }
 
-static inline void kfree_hook(void *x)
+static __always_inline void kfree_hook(void *x)
 {
 	kmemleak_free(x);
-	kasan_kfree_large(x);
+	kasan_kfree_large(x, _RET_IP_);
 }
 
-static inline void *slab_free_hook(struct kmem_cache *s, void *x)
+static __always_inline void *slab_free_hook(struct kmem_cache *s, void *x)
 {
 	void *freeptr;
 
@@ -1388,7 +1388,7 @@ static inline void *slab_free_hook(struc
 	 * kasan_slab_free() may put x into memory quarantine, delaying its
 	 * reuse. In this case the object's freelist pointer is changed.
 	 */
-	kasan_slab_free(s, x);
+	kasan_slab_free(s, x, _RET_IP_);
 	return freeptr;
 }
 
_

Patches currently in -mm which might be from dvyukov@google.com are

kasan-detect-invalid-frees-for-large-objects.patch
kasan-dont-use-__builtin_return_address1.patch
kasan-detect-invalid-frees-for-large-mempool-objects.patch
kasan-unify-code-between-kasan_slab_free-and-kasan_poison_kfree.patch
kasan-detect-invalid-frees.patch

