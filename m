Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8173213AF0
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HbAFlGgL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D619C433C7;
	Fri, 29 Dec 2023 20:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880042;
	bh=D6t2ApB52H8jYWsS8ml2cg+wryeqyRqp3jyZbjNmKQ0=;
	h=Date:To:From:Subject:From;
	b=HbAFlGgL3s57+9oH4YStlO7nAdEmkzGOWXSXyi3pXdzAGHsT3GgyZvVH4n0hBc7fS
	 G5jtB5MIDCf+irz43hDXAFUg/NcKXSwgcYX9smjF2sabSU/eLZWe8veqRqjQAPyEad
	 bMQtEjrXv0ltjAqAmpxm3FriEzOwbwHSuQeKZIig=
Date: Fri, 29 Dec 2023 12:00:41 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,leitao@debian.org,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,alobakin@pm.me,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-save-free-stack-traces-for-slab-mempools.patch removed from -mm tree
Message-Id: <20231229200042.4D619C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: save free stack traces for slab mempools
has been removed from the -mm tree.  Its filename was
     kasan-save-free-stack-traces-for-slab-mempools.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: save free stack traces for slab mempools
Date: Tue, 19 Dec 2023 23:28:53 +0100

Make kasan_mempool_poison_object save free stack traces for slab and
kmalloc mempools when the object is freed into the mempool.

Also simplify and rename ____kasan_slab_free to poison_slab_object and do
a few other reability changes.

Link: https://lkml.kernel.org/r/413a7c7c3344fb56809853339ffaabc9e4905e94.1703024586.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Lobakin <alobakin@pm.me>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |    5 +++--
 mm/kasan/common.c     |   20 +++++++++-----------
 2 files changed, 12 insertions(+), 13 deletions(-)

--- a/include/linux/kasan.h~kasan-save-free-stack-traces-for-slab-mempools
+++ a/include/linux/kasan.h
@@ -268,8 +268,9 @@ bool __kasan_mempool_poison_object(void
  * to reuse them instead of freeing them back to the slab allocator (e.g.
  * mempool).
  *
- * This function poisons a slab allocation without initializing its memory and
- * without putting it into the quarantine (for the Generic mode).
+ * This function poisons a slab allocation and saves a free stack trace for it
+ * without initializing the allocation's memory and without putting it into the
+ * quarantine (for the Generic mode).
  *
  * This function also performs checks to detect double-free and invalid-free
  * bugs and reports them. The caller can use the return value of this function
--- a/mm/kasan/common.c~kasan-save-free-stack-traces-for-slab-mempools
+++ a/mm/kasan/common.c
@@ -207,8 +207,8 @@ void * __must_check __kasan_init_slab_ob
 	return (void *)object;
 }
 
-static inline bool ____kasan_slab_free(struct kmem_cache *cache, void *object,
-				unsigned long ip, bool quarantine, bool init)
+static inline bool poison_slab_object(struct kmem_cache *cache, void *object,
+				      unsigned long ip, bool init)
 {
 	void *tagged_object;
 
@@ -221,13 +221,12 @@ static inline bool ____kasan_slab_free(s
 	if (is_kfence_address(object))
 		return false;
 
-	if (unlikely(nearest_obj(cache, virt_to_slab(object), object) !=
-	    object)) {
+	if (unlikely(nearest_obj(cache, virt_to_slab(object), object) != object)) {
 		kasan_report_invalid_free(tagged_object, ip, KASAN_REPORT_INVALID_FREE);
 		return true;
 	}
 
-	/* RCU slabs could be legally used after free within the RCU period */
+	/* RCU slabs could be legally used after free within the RCU period. */
 	if (unlikely(cache->flags & SLAB_TYPESAFE_BY_RCU))
 		return false;
 
@@ -239,19 +238,18 @@ static inline bool ____kasan_slab_free(s
 	kasan_poison(object, round_up(cache->object_size, KASAN_GRANULE_SIZE),
 			KASAN_SLAB_FREE, init);
 
-	if ((IS_ENABLED(CONFIG_KASAN_GENERIC) && !quarantine))
-		return false;
-
 	if (kasan_stack_collection_enabled())
 		kasan_save_free_info(cache, tagged_object);
 
-	return kasan_quarantine_put(cache, object);
+	return false;
 }
 
 bool __kasan_slab_free(struct kmem_cache *cache, void *object,
 				unsigned long ip, bool init)
 {
-	return ____kasan_slab_free(cache, object, ip, true, init);
+	bool buggy_object = poison_slab_object(cache, object, ip, init);
+
+	return buggy_object ? true : kasan_quarantine_put(cache, object);
 }
 
 static inline bool check_page_allocation(void *ptr, unsigned long ip)
@@ -472,7 +470,7 @@ bool __kasan_mempool_poison_object(void
 	}
 
 	slab = folio_slab(folio);
-	return !____kasan_slab_free(slab->slab_cache, ptr, ip, false, false);
+	return !poison_slab_object(slab->slab_cache, ptr, ip, false);
 }
 
 void __kasan_mempool_unpoison_object(void *ptr, size_t size, unsigned long ip)
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-stop-leaking-stack-trace-handles.patch

