Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4206F23C4
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 00:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j0PGWjmn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA559C433C8;
	Wed, 20 Dec 2023 00:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703033903;
	bh=8SFMo9A3kukwNjdXwev4K6qS85OYyQK7CAAm3oRuNRQ=;
	h=Date:To:From:Subject:From;
	b=j0PGWjmnAg6JicIcikD5aE75aId4MKMG/pKHMLlGFHU/kqVCm2IvRXPBEl8TowrTh
	 LLOX+tJKRU5/y4sploEZ7GQR7A1bJC04esWSvemJ4idzkLhXBG39XSbYRNMTMVvrrk
	 3JT9gDfwgZHD37NmH7DUyWqUqOU3Bc/DOfMB8+QI=
Date: Tue, 19 Dec 2023 16:58:23 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,penguin-kernel@i-love.sakura.ne.jp,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-handle-concurrent-kasan_record_aux_stack-calls.patch added to mm-nonmm-unstable branch
Message-Id: <20231220005823.BA559C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: handle concurrent kasan_record_aux_stack calls
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kasan-handle-concurrent-kasan_record_aux_stack-calls.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-handle-concurrent-kasan_record_aux_stack-calls.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: handle concurrent kasan_record_aux_stack calls
Date: Tue, 19 Dec 2023 22:19:51 +0100

kasan_record_aux_stack can be called concurrently on the same object. 
This might lead to a race condition when rotating the saved aux stack
trace handles, which in turns leads to incorrect accounting of stack depot
handles and refcount underflows in the stack depot code.

Fix by introducing a raw spinlock to protect the aux stack trace handles
in kasan_record_aux_stack.

Link: https://lkml.kernel.org/r/1606b960e2f746862d1f459515972f9695bf448a.1703020707.git.andreyknvl@google.com
Fixes: 773688a6cb24 ("kasan: use stack_depot_put for Generic mode")
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Reported-by: syzbot+186b55175d8360728234@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/000000000000784b1c060b0074a2@google.com/
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/generic.c |   32 +++++++++++++++++++++++++++++---
 mm/kasan/kasan.h   |    8 ++++++++
 2 files changed, 37 insertions(+), 3 deletions(-)

--- a/mm/kasan/generic.c~kasan-handle-concurrent-kasan_record_aux_stack-calls
+++ a/mm/kasan/generic.c
@@ -25,6 +25,7 @@
 #include <linux/sched.h>
 #include <linux/sched/task_stack.h>
 #include <linux/slab.h>
+#include <linux/spinlock.h>
 #include <linux/stackdepot.h>
 #include <linux/stacktrace.h>
 #include <linux/string.h>
@@ -471,8 +472,18 @@ void kasan_init_object_meta(struct kmem_
 	struct kasan_free_meta *free_meta;
 
 	alloc_meta = kasan_get_alloc_meta(cache, object);
-	if (alloc_meta)
+	if (alloc_meta) {
 		__memset(alloc_meta, 0, sizeof(*alloc_meta));
+
+		/*
+		 * Temporarily disable KASAN bug reporting to allow instrumented
+		 * raw_spin_lock_init to access aux_lock, which resides inside
+		 * of a redzone.
+		 */
+		kasan_disable_current();
+		raw_spin_lock_init(&alloc_meta->aux_lock);
+		kasan_enable_current();
+	}
 	free_meta = kasan_get_free_meta(cache, object);
 	if (free_meta)
 		__memset(free_meta, 0, sizeof(*free_meta));
@@ -502,6 +513,8 @@ static void __kasan_record_aux_stack(voi
 	struct kmem_cache *cache;
 	struct kasan_alloc_meta *alloc_meta;
 	void *object;
+	depot_stack_handle_t new_handle, old_handle;
+	unsigned long flags;
 
 	if (is_kfence_address(addr) || !slab)
 		return;
@@ -512,9 +525,22 @@ static void __kasan_record_aux_stack(voi
 	if (!alloc_meta)
 		return;
 
-	stack_depot_put(alloc_meta->aux_stack[1]);
+	new_handle = kasan_save_stack(0, depot_flags);
+
+	/*
+	 * Temporarily disable KASAN bug reporting to allow instrumented
+	 * spinlock functions to access aux_lock, which resides inside of a
+	 * redzone.
+	 */
+	kasan_disable_current();
+	raw_spin_lock_irqsave(&alloc_meta->aux_lock, flags);
+	old_handle = alloc_meta->aux_stack[1];
 	alloc_meta->aux_stack[1] = alloc_meta->aux_stack[0];
-	alloc_meta->aux_stack[0] = kasan_save_stack(0, depot_flags);
+	alloc_meta->aux_stack[0] = new_handle;
+	raw_spin_unlock_irqrestore(&alloc_meta->aux_lock, flags);
+	kasan_enable_current();
+
+	stack_depot_put(old_handle);
 }
 
 void kasan_record_aux_stack(void *addr)
--- a/mm/kasan/kasan.h~kasan-handle-concurrent-kasan_record_aux_stack-calls
+++ a/mm/kasan/kasan.h
@@ -6,6 +6,7 @@
 #include <linux/kasan.h>
 #include <linux/kasan-tags.h>
 #include <linux/kfence.h>
+#include <linux/spinlock.h>
 #include <linux/stackdepot.h>
 
 #if defined(CONFIG_KASAN_SW_TAGS) || defined(CONFIG_KASAN_HW_TAGS)
@@ -249,6 +250,13 @@ struct kasan_global {
 struct kasan_alloc_meta {
 	struct kasan_track alloc_track;
 	/* Free track is stored in kasan_free_meta. */
+	/*
+	 * aux_lock protects aux_stack from accesses from concurrent
+	 * kasan_record_aux_stack calls. It is a raw spinlock to avoid sleeping
+	 * on RT kernels, as kasan_record_aux_stack_noalloc can be called from
+	 * non-sleepable contexts.
+	 */
+	raw_spinlock_t aux_lock;
 	depot_stack_handle_t aux_stack[2];
 };
 
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-rename-kasan_slab_free_mempool-to-kasan_mempool_poison_object.patch
kasan-move-kasan_mempool_poison_object.patch
kasan-document-kasan_mempool_poison_object.patch
kasan-add-return-value-for-kasan_mempool_poison_object.patch
kasan-introduce-kasan_mempool_unpoison_object.patch
kasan-introduce-kasan_mempool_poison_pages.patch
kasan-introduce-kasan_mempool_unpoison_pages.patch
kasan-clean-up-__kasan_mempool_poison_object.patch
kasan-save-free-stack-traces-for-slab-mempools.patch
kasan-clean-up-and-rename-____kasan_kmalloc.patch
kasan-introduce-poison_kmalloc_large_redzone.patch
kasan-save-alloc-stack-traces-for-mempool.patch
mempool-skip-slub_debug-poisoning-when-kasan-is-enabled.patch
mempool-use-new-mempool-kasan-hooks.patch
mempool-introduce-mempool_use_prealloc_only.patch
kasan-add-mempool-tests.patch
kasan-rename-pagealloc-tests.patch
kasan-reorder-tests.patch
kasan-rename-and-document-kasan_unpoison_object_data.patch
skbuff-use-mempool-kasan-hooks.patch
io_uring-use-mempool-kasan-hook.patch
lib-stackdepot-add-printk_deferred_enter-exit-guards.patch
kasan-handle-concurrent-kasan_record_aux_stack-calls.patch
kasan-memset-free-track-in-qlink_free.patch
lib-stackdepot-fix-comment-in-include-linux-stackdepoth.patch

