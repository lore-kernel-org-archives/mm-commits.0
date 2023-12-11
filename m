Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF12146BE
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="18tc1+Fg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96135C433C7;
	Mon, 11 Dec 2023 00:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256104;
	bh=IUjz29JzqmjjvErnwtOnI60k5NcHwb0HSIKpOJuusmc=;
	h=Date:To:From:Subject:From;
	b=18tc1+Fg+PDi5QDdi/TwX+qrJq3sY5TXnLwMLmW0v3jgDPV7DJ9HeRsMVNb6aIntA
	 teOVfkag44Xff6sGPWp5d++/FPTfbwDsEDq347/2GuirSfgow9DIfmRFJgBtRroE+J
	 PWDj+CWvXs0I1d4dJjbwUemAFoCugrKQCoKd7vI4=
Date: Sun, 10 Dec 2023 16:55:04 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-use-stack_depot_put-for-tag-based-modes.patch removed from -mm tree
Message-Id: <20231211005504.96135C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: use stack_depot_put for tag-based modes
has been removed from the -mm tree.  Its filename was
     kasan-use-stack_depot_put-for-tag-based-modes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: use stack_depot_put for tag-based modes
Date: Mon, 20 Nov 2023 18:47:18 +0100

Make tag-based KASAN modes evict stack traces from the stack depot once
they are evicted from the stack ring.

Internally, pass STACK_DEPOT_FLAG_GET to stack_depot_save_flags (via
kasan_save_stack) to increment the refcount when saving a new entry to
stack ring and call stack_depot_put when removing an entry from stack
ring.

Link: https://lkml.kernel.org/r/b4773e5c1b0b9df6826ec0b65c1923feadfa78e5.1700502145.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/tags.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/kasan/tags.c~kasan-use-stack_depot_put-for-tag-based-modes
+++ a/mm/kasan/tags.c
@@ -97,12 +97,13 @@ static void save_stack_info(struct kmem_
 			gfp_t gfp_flags, bool is_free)
 {
 	unsigned long flags;
-	depot_stack_handle_t stack;
+	depot_stack_handle_t stack, old_stack;
 	u64 pos;
 	struct kasan_stack_ring_entry *entry;
 	void *old_ptr;
 
-	stack = kasan_save_stack(gfp_flags, STACK_DEPOT_FLAG_CAN_ALLOC);
+	stack = kasan_save_stack(gfp_flags,
+			STACK_DEPOT_FLAG_CAN_ALLOC | STACK_DEPOT_FLAG_GET);
 
 	/*
 	 * Prevent save_stack_info() from modifying stack ring
@@ -121,6 +122,8 @@ next:
 	if (!try_cmpxchg(&entry->ptr, &old_ptr, STACK_RING_BUSY_PTR))
 		goto next; /* Busy slot. */
 
+	old_stack = entry->stack;
+
 	entry->size = cache->object_size;
 	entry->pid = current->pid;
 	entry->stack = stack;
@@ -129,6 +132,9 @@ next:
 	entry->ptr = object;
 
 	read_unlock_irqrestore(&stack_ring.lock, flags);
+
+	if (old_stack)
+		stack_depot_put(old_stack);
 }
 
 void kasan_save_alloc_info(struct kmem_cache *cache, void *object, gfp_t flags)
_

Patches currently in -mm which might be from andreyknvl@google.com are


