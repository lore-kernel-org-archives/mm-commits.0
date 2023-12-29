Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E8DE13AEB
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TOB94d9X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67583C433C9;
	Fri, 29 Dec 2023 20:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880048;
	bh=54GLf5NhQIfEAnnE095yPGE1M/gtUvLqc8zbGOvbiL4=;
	h=Date:To:From:Subject:From;
	b=TOB94d9XvMS15ul7JOnxleqW0PRGaRKuTqHozEllAsOVguk4sjjsthDjenHDS+5yw
	 sBICYu+SeinQ5Ft5jumJPn1ykdgBOiqXPoYG5KzHl98l0YUK6KH+jquBehUYXCoN3A
	 I42NoYSHuukr2jDCMU+Jdhd1VOOairbEIDjQQcvo=
Date: Fri, 29 Dec 2023 12:00:47 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,leitao@debian.org,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,alobakin@pm.me,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mempool-use-new-mempool-kasan-hooks.patch removed from -mm tree
Message-Id: <20231229200048.67583C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mempool: use new mempool KASAN hooks
has been removed from the -mm tree.  Its filename was
     mempool-use-new-mempool-kasan-hooks.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: mempool: use new mempool KASAN hooks
Date: Tue, 19 Dec 2023 23:28:58 +0100

Update the mempool code to use the new mempool KASAN hooks.

Rely on the return value of kasan_mempool_poison_object and
kasan_mempool_poison_pages to prevent double-free and invalid-free bugs.

Link: https://lkml.kernel.org/r/d36fc4a6865bdbd297cadb46b67641d436849f4c.1703024586.git.andreyknvl@google.com
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

 mm/mempool.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/mm/mempool.c~mempool-use-new-mempool-kasan-hooks
+++ a/mm/mempool.c
@@ -112,32 +112,34 @@ static inline void poison_element(mempoo
 }
 #endif /* CONFIG_DEBUG_SLAB || CONFIG_SLUB_DEBUG_ON */
 
-static __always_inline void kasan_poison_element(mempool_t *pool, void *element)
+static __always_inline bool kasan_poison_element(mempool_t *pool, void *element)
 {
 	if (pool->alloc == mempool_alloc_slab || pool->alloc == mempool_kmalloc)
-		kasan_mempool_poison_object(element);
+		return kasan_mempool_poison_object(element);
 	else if (pool->alloc == mempool_alloc_pages)
-		kasan_poison_pages(element, (unsigned long)pool->pool_data,
-				   false);
+		return kasan_mempool_poison_pages(element,
+						(unsigned long)pool->pool_data);
+	return true;
 }
 
 static void kasan_unpoison_element(mempool_t *pool, void *element)
 {
 	if (pool->alloc == mempool_kmalloc)
-		kasan_unpoison_range(element, (size_t)pool->pool_data);
+		kasan_mempool_unpoison_object(element, (size_t)pool->pool_data);
 	else if (pool->alloc == mempool_alloc_slab)
-		kasan_unpoison_range(element, kmem_cache_size(pool->pool_data));
+		kasan_mempool_unpoison_object(element,
+					      kmem_cache_size(pool->pool_data));
 	else if (pool->alloc == mempool_alloc_pages)
-		kasan_unpoison_pages(element, (unsigned long)pool->pool_data,
-				     false);
+		kasan_mempool_unpoison_pages(element,
+					     (unsigned long)pool->pool_data);
 }
 
 static __always_inline void add_element(mempool_t *pool, void *element)
 {
 	BUG_ON(pool->curr_nr >= pool->min_nr);
 	poison_element(pool, element);
-	kasan_poison_element(pool, element);
-	pool->elements[pool->curr_nr++] = element;
+	if (kasan_poison_element(pool, element))
+		pool->elements[pool->curr_nr++] = element;
 }
 
 static void *remove_element(mempool_t *pool)
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-stop-leaking-stack-trace-handles.patch

