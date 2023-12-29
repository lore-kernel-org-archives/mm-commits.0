Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB3513AC4
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ntr/67wT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 149A0C433C8;
	Fri, 29 Dec 2023 20:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880058;
	bh=UuOuPt3x7Rsy4jm+z+IOPUPgfUSvVsOEIwHISfe3a9Q=;
	h=Date:To:From:Subject:From;
	b=ntr/67wTXYeHsfolgaaLP0BNXHqLbicMVuKIRT7f81LgJ7D/tnyNoHzKEwzZAvL1g
	 cnjA79XmG+P+W8ZMPhJZMy5lyXHtJJi7QIwBe6TBeh2dpiXXyh+nTNWp8iekgBUdPb
	 UyUjaCzYy8rRuwZBspNIkAuwnKob5cwbM23rpyUE=
Date: Fri, 29 Dec 2023 12:00:57 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,penguin-kernel@i-love.sakura.ne.jp,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-stackdepot-add-printk_deferred_enter-exit-guards.patch removed from -mm tree
Message-Id: <20231229200058.149A0C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/stackdepot: add printk_deferred_enter/exit guards
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-add-printk_deferred_enter-exit-guards.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: lib/stackdepot: add printk_deferred_enter/exit guards
Date: Tue, 19 Dec 2023 22:19:50 +0100

Patch series "lib/stackdepot, kasan: fixes for stack eviction series", v3.

A few fixes for the stack depot eviction series ("stackdepot: allow
evicting stack traces").

This patch (of 5):

Stack depot functions can be called from various contexts that do
allocations, including with console locks taken.  At the same time, stack
depot functions might print WARNING's or refcount-related failures.

This can cause a deadlock on console locks.

Add printk_deferred_enter/exit guards to stack depot to avoid this.

Link: https://lkml.kernel.org/r/cover.1703020707.git.andreyknvl@google.com
Link: https://lkml.kernel.org/r/82092f9040d075a161d1264377d51e0bac847e8a.1703020707.git.andreyknvl@google.com
Fixes: 108be8def46e ("lib/stackdepot: allow users to evict stack traces")
Fixes: cd11016e5f52 ("mm, kasan: stackdepot implementation. Enable stackdepot for SLAB")
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Closes: https://lore.kernel.org/all/000000000000f56750060b9ad216@google.com/
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/lib/stackdepot.c~lib-stackdepot-add-printk_deferred_enter-exit-guards
+++ a/lib/stackdepot.c
@@ -506,12 +506,14 @@ depot_stack_handle_t stack_depot_save_fl
 	bucket = &stack_table[hash & stack_hash_mask];
 
 	read_lock_irqsave(&pool_rwlock, flags);
+	printk_deferred_enter();
 
 	/* Fast path: look the stack trace up without full locking. */
 	found = find_stack(bucket, entries, nr_entries, hash);
 	if (found) {
 		if (depot_flags & STACK_DEPOT_FLAG_GET)
 			refcount_inc(&found->count);
+		printk_deferred_exit();
 		read_unlock_irqrestore(&pool_rwlock, flags);
 		goto exit;
 	}
@@ -520,6 +522,7 @@ depot_stack_handle_t stack_depot_save_fl
 	if (new_pool_required)
 		need_alloc = true;
 
+	printk_deferred_exit();
 	read_unlock_irqrestore(&pool_rwlock, flags);
 
 	/*
@@ -541,6 +544,7 @@ depot_stack_handle_t stack_depot_save_fl
 	}
 
 	write_lock_irqsave(&pool_rwlock, flags);
+	printk_deferred_enter();
 
 	found = find_stack(bucket, entries, nr_entries, hash);
 	if (!found) {
@@ -562,6 +566,7 @@ depot_stack_handle_t stack_depot_save_fl
 			depot_keep_new_pool(&prealloc);
 	}
 
+	printk_deferred_exit();
 	write_unlock_irqrestore(&pool_rwlock, flags);
 exit:
 	if (prealloc) {
@@ -600,9 +605,11 @@ unsigned int stack_depot_fetch(depot_sta
 		return 0;
 
 	read_lock_irqsave(&pool_rwlock, flags);
+	printk_deferred_enter();
 
 	stack = depot_fetch_stack(handle);
 
+	printk_deferred_exit();
 	read_unlock_irqrestore(&pool_rwlock, flags);
 
 	*entries = stack->entries;
@@ -619,6 +626,7 @@ void stack_depot_put(depot_stack_handle_
 		return;
 
 	write_lock_irqsave(&pool_rwlock, flags);
+	printk_deferred_enter();
 
 	stack = depot_fetch_stack(handle);
 	if (WARN_ON(!stack))
@@ -633,6 +641,7 @@ void stack_depot_put(depot_stack_handle_
 	}
 
 out:
+	printk_deferred_exit();
 	write_unlock_irqrestore(&pool_rwlock, flags);
 }
 EXPORT_SYMBOL_GPL(stack_depot_put);
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-stop-leaking-stack-trace-handles.patch

