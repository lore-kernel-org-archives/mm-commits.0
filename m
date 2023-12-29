Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C11113AC9
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T9+Froiz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 813ABC433C7;
	Fri, 29 Dec 2023 20:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880049;
	bh=UTPerkopug8uyMIUwkTEQyJt9cuK+HDcZQWck5pbzTI=;
	h=Date:To:From:Subject:From;
	b=T9+Froiz7cNtSot6v49FxsvGNPbhhhIjsV8Rl0J6l9q4hQ5RyZsWBWXgPRCTSGH+/
	 6A8D9nkGlrUomVREhS0Y1eH0zjQk1vYGotvkHfYs+Z0sIb/ZqWenQCKXxENi2US/Cd
	 5iZVxgzg3oHS5bN+H3QUJE7k3xEbnpSPLEnz928E=
Date: Fri, 29 Dec 2023 12:00:48 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,leitao@debian.org,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,alobakin@pm.me,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mempool-introduce-mempool_use_prealloc_only.patch removed from -mm tree
Message-Id: <20231229200049.813ABC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mempool: introduce mempool_use_prealloc_only
has been removed from the -mm tree.  Its filename was
     mempool-introduce-mempool_use_prealloc_only.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: mempool: introduce mempool_use_prealloc_only
Date: Tue, 19 Dec 2023 23:28:59 +0100

Introduce a new mempool_alloc_preallocated API that asks the mempool to
only use the elements preallocated during the mempool's creation when
allocating and to not attempt allocating new ones from the underlying
allocator.

This API is required to test the KASAN poisoning/unpoisoning functionality
in KASAN tests, but it might be also useful on its own.

Link: https://lkml.kernel.org/r/a14d809dbdfd04cc33bcacc632fee2abd6b83c00.1703024586.git.andreyknvl@google.com
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

 include/linux/mempool.h |    1 +
 mm/mempool.c            |   37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

--- a/include/linux/mempool.h~mempool-introduce-mempool_use_prealloc_only
+++ a/include/linux/mempool.h
@@ -51,6 +51,7 @@ extern mempool_t *mempool_create_node(in
 extern int mempool_resize(mempool_t *pool, int new_min_nr);
 extern void mempool_destroy(mempool_t *pool);
 extern void *mempool_alloc(mempool_t *pool, gfp_t gfp_mask) __malloc;
+extern void *mempool_alloc_preallocated(mempool_t *pool) __malloc;
 extern void mempool_free(void *element, mempool_t *pool);
 
 /*
--- a/mm/mempool.c~mempool-introduce-mempool_use_prealloc_only
+++ a/mm/mempool.c
@@ -457,6 +457,43 @@ repeat_alloc:
 EXPORT_SYMBOL(mempool_alloc);
 
 /**
+ * mempool_alloc_preallocated - allocate an element from preallocated elements
+ *                              belonging to a specific memory pool
+ * @pool:      pointer to the memory pool which was allocated via
+ *             mempool_create().
+ *
+ * This function is similar to mempool_alloc, but it only attempts allocating
+ * an element from the preallocated elements. It does not sleep and immediately
+ * returns if no preallocated elements are available.
+ *
+ * Return: pointer to the allocated element or %NULL if no elements are
+ * available.
+ */
+void *mempool_alloc_preallocated(mempool_t *pool)
+{
+	void *element;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pool->lock, flags);
+	if (likely(pool->curr_nr)) {
+		element = remove_element(pool);
+		spin_unlock_irqrestore(&pool->lock, flags);
+		/* paired with rmb in mempool_free(), read comment there */
+		smp_wmb();
+		/*
+		 * Update the allocation stack trace as this is more useful
+		 * for debugging.
+		 */
+		kmemleak_update_trace(element);
+		return element;
+	}
+	spin_unlock_irqrestore(&pool->lock, flags);
+
+	return NULL;
+}
+EXPORT_SYMBOL(mempool_alloc_preallocated);
+
+/**
  * mempool_free - return an element to the pool.
  * @element:   pool element pointer.
  * @pool:      pointer to the memory pool which was allocated via
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-stop-leaking-stack-trace-handles.patch

