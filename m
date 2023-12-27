Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F65D45945
	for <mm-commits@vger.kernel.org>; Wed, 27 Dec 2023 21:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EoJsrScA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06184C433C7;
	Wed, 27 Dec 2023 21:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703712060;
	bh=BP5Ce/wWr9q27kT4aO5+Gj1zMorOYMwBlg5L4yt6AOg=;
	h=Date:To:From:Subject:From;
	b=EoJsrScAcMPP7i2ih7ty2jh+vYRcbIhaXMh06GuSySSbzNdxgq72gXWkcN6yJZGHN
	 G/0pRDKn+pK2lHHoESK6ZP+kvKMD1+omOOQ2wFzZ1lKEf+9KOoTPuz2niZzFtuqNJG
	 QSx+ZQOXdvkhe6p7BsHeyE8ZR500+RVCvkNy25mo=
Date: Wed, 27 Dec 2023 13:20:59 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-stop-leaking-stack-trace-handles.patch added to mm-unstable branch
Message-Id: <20231227212100.06184C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: stop leaking stack trace handles
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-stop-leaking-stack-trace-handles.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-stop-leaking-stack-trace-handles.patch

This patch will later appear in the mm-unstable branch at
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
Subject: kasan: stop leaking stack trace handles
Date: Tue, 26 Dec 2023 23:51:21 +0100

Commit 773688a6cb24 ("kasan: use stack_depot_put for Generic mode") added
support for stack trace eviction for Generic KASAN.

However, that commit didn't evict stack traces when the object is not put
into quarantine.  As a result, some stack traces are never evicted from
the stack depot.

In addition, with the "kasan: save mempool stack traces" series, the free
stack traces for mempool objects are also not properly evicted from the
stack depot.

Fix both issues by:

1. Evicting all stack traces when an object if freed if it was not put
   into quarantine;

2. Always evicting an existing free stack trace when a new one is saved.

Also do a few related clean-ups:

- Do not zero out free track when initializing/invalidating free meta:
  set a value in shadow memory instead;

- Rename KASAN_SLAB_FREETRACK to KASAN_SLAB_FREE_META;

- Drop the kasan_init_cache_meta function as it's not used by KASAN;

- Add comments for the kasan_alloc_meta and kasan_free_meta structs.

Link: https://lkml.kernel.org/r/20231226225121.235865-1-andrey.konovalov@linux.dev
Fixes: 773688a6cb24 ("kasan: use stack_depot_put for Generic mode")
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c         |   27 +++++++++++++---
 mm/kasan/generic.c        |   60 ++++++++++++++++++++++++++++++------
 mm/kasan/kasan.h          |   25 +++++++++++----
 mm/kasan/quarantine.c     |   20 ------------
 mm/kasan/report_generic.c |    6 +--
 5 files changed, 97 insertions(+), 41 deletions(-)

--- a/mm/kasan/common.c~kasan-stop-leaking-stack-trace-handles
+++ a/mm/kasan/common.c
@@ -255,14 +255,33 @@ static inline bool poison_slab_object(st
 bool __kasan_slab_free(struct kmem_cache *cache, void *object,
 				unsigned long ip, bool init)
 {
-	bool buggy_object;
-
 	if (is_kfence_address(object))
 		return false;
 
-	buggy_object = poison_slab_object(cache, object, ip, init);
+	/*
+	 * If the object is buggy, do not let slab put the object onto the
+	 * freelist. The object will thus never be allocated again and its
+	 * metadata will never get released.
+	 */
+	if (poison_slab_object(cache, object, ip, init))
+		return true;
+
+	/*
+	 * If the object is put into quarantine, do not let slab put the object
+	 * onto the freelist for now. The object's metadata is kept until the
+	 * object gets evicted from quarantine.
+	 */
+	if (kasan_quarantine_put(cache, object))
+		return true;
+
+	/*
+	 * If the object is not put into quarantine, it will likely be quickly
+	 * reallocated. Thus, release its metadata now.
+	 */
+	kasan_release_object_meta(cache, object);
 
-	return buggy_object ? true : kasan_quarantine_put(cache, object);
+	/* Let slab put the object onto the freelist. */
+	return false;
 }
 
 static inline bool check_page_allocation(void *ptr, unsigned long ip)
--- a/mm/kasan/generic.c~kasan-stop-leaking-stack-trace-handles
+++ a/mm/kasan/generic.c
@@ -480,10 +480,10 @@ struct kasan_free_meta *kasan_get_free_m
 void kasan_init_object_meta(struct kmem_cache *cache, const void *object)
 {
 	struct kasan_alloc_meta *alloc_meta;
-	struct kasan_free_meta *free_meta;
 
 	alloc_meta = kasan_get_alloc_meta(cache, object);
 	if (alloc_meta) {
+		/* Zero out alloc meta to mark it as invalid. */
 		__memset(alloc_meta, 0, sizeof(*alloc_meta));
 
 		/*
@@ -495,9 +495,50 @@ void kasan_init_object_meta(struct kmem_
 		raw_spin_lock_init(&alloc_meta->aux_lock);
 		kasan_enable_current();
 	}
+
+	/*
+	 * Explicitly marking free meta as invalid is not required: the shadow
+	 * value for the first 8 bytes of a newly allocated object is not
+	 * KASAN_SLAB_FREE_META.
+	 */
+}
+
+void release_alloc_meta(struct kasan_alloc_meta *meta)
+{
+	/* Evict the stack traces from stack depot. */
+	stack_depot_put(meta->alloc_track.stack);
+	stack_depot_put(meta->aux_stack[0]);
+	stack_depot_put(meta->aux_stack[1]);
+
+	/* Zero out alloc meta to mark it as invalid. */
+	__memset(meta, 0, sizeof(*meta));
+}
+
+void release_free_meta(const void *object, struct kasan_free_meta *meta)
+{
+	/* Check if free meta is valid. */
+	if (*(u8 *)kasan_mem_to_shadow(object) != KASAN_SLAB_FREE_META)
+		return;
+
+	/* Evict the stack trace from the stack depot. */
+	stack_depot_put(meta->free_track.stack);
+
+	/* Mark free meta as invalid. */
+	*(u8 *)kasan_mem_to_shadow(object) = KASAN_SLAB_FREE;
+}
+
+void kasan_release_object_meta(struct kmem_cache *cache, const void *object)
+{
+	struct kasan_alloc_meta *alloc_meta;
+	struct kasan_free_meta *free_meta;
+
+	alloc_meta = kasan_get_alloc_meta(cache, object);
+	if (alloc_meta)
+		release_alloc_meta(alloc_meta);
+
 	free_meta = kasan_get_free_meta(cache, object);
 	if (free_meta)
-		__memset(free_meta, 0, sizeof(*free_meta));
+		release_free_meta(object, free_meta);
 }
 
 size_t kasan_metadata_size(struct kmem_cache *cache, bool in_object)
@@ -573,11 +614,8 @@ void kasan_save_alloc_info(struct kmem_c
 	if (!alloc_meta)
 		return;
 
-	/* Evict previous stack traces (might exist for krealloc). */
-	stack_depot_put(alloc_meta->alloc_track.stack);
-	stack_depot_put(alloc_meta->aux_stack[0]);
-	stack_depot_put(alloc_meta->aux_stack[1]);
-	__memset(alloc_meta, 0, sizeof(*alloc_meta));
+	/* Evict previous stack traces (might exist for krealloc or mempool). */
+	release_alloc_meta(alloc_meta);
 
 	kasan_save_track(&alloc_meta->alloc_track, flags);
 }
@@ -590,7 +628,11 @@ void kasan_save_free_info(struct kmem_ca
 	if (!free_meta)
 		return;
 
+	/* Evict previous stack trace (might exist for mempool). */
+	release_free_meta(object, free_meta);
+
 	kasan_save_track(&free_meta->free_track, 0);
-	/* The object was freed and has free track set. */
-	*(u8 *)kasan_mem_to_shadow(object) = KASAN_SLAB_FREETRACK;
+
+	/* Mark free meta as valid. */
+	*(u8 *)kasan_mem_to_shadow(object) = KASAN_SLAB_FREE_META;
 }
--- a/mm/kasan/kasan.h~kasan-stop-leaking-stack-trace-handles
+++ a/mm/kasan/kasan.h
@@ -156,7 +156,7 @@ static inline bool kasan_requires_meta(v
 
 #ifdef CONFIG_KASAN_GENERIC
 
-#define KASAN_SLAB_FREETRACK	0xFA  /* freed slab object with free track */
+#define KASAN_SLAB_FREE_META	0xFA  /* freed slab object with free meta */
 #define KASAN_GLOBAL_REDZONE	0xF9  /* redzone for global variable */
 
 /* Stack redzone shadow values. Compiler ABI, do not change. */
@@ -253,6 +253,15 @@ struct kasan_global {
 
 #ifdef CONFIG_KASAN_GENERIC
 
+/*
+ * Alloc meta contains the allocation-related information about a slab object.
+ * Alloc meta is saved when an object is allocated and is kept until either the
+ * object returns to the slab freelist (leaves quarantine for quarantined
+ * objects or gets freed for the non-quarantined ones) or reallocated via
+ * krealloc or through a mempool.
+ * Alloc meta is stored inside of the object's redzone.
+ * Alloc meta is considered valid whenever it contains non-zero data.
+ */
 struct kasan_alloc_meta {
 	struct kasan_track alloc_track;
 	/* Free track is stored in kasan_free_meta. */
@@ -278,8 +287,12 @@ struct qlist_node {
 #define KASAN_NO_FREE_META INT_MAX
 
 /*
- * Free meta is only used by Generic mode while the object is in quarantine.
- * After that, slab allocator stores the freelist pointer in the object.
+ * Free meta contains the freeing-related information about a slab object.
+ * Free meta is only kept for quarantined objects and for mempool objects until
+ * the object gets allocated again.
+ * Free meta is stored within the object's memory.
+ * Free meta is considered valid whenever the value of the shadow byte that
+ * corresponds to the first 8 bytes of the object is KASAN_SLAB_FREE_META.
  */
 struct kasan_free_meta {
 	struct qlist_node quarantine_link;
@@ -380,15 +393,15 @@ void kasan_report_invalid_free(void *obj
 struct slab *kasan_addr_to_slab(const void *addr);
 
 #ifdef CONFIG_KASAN_GENERIC
-void kasan_init_cache_meta(struct kmem_cache *cache, unsigned int *size);
-void kasan_init_object_meta(struct kmem_cache *cache, const void *object);
 struct kasan_alloc_meta *kasan_get_alloc_meta(struct kmem_cache *cache,
 						const void *object);
 struct kasan_free_meta *kasan_get_free_meta(struct kmem_cache *cache,
 						const void *object);
+void kasan_init_object_meta(struct kmem_cache *cache, const void *object);
+void kasan_release_object_meta(struct kmem_cache *cache, const void *object);
 #else
-static inline void kasan_init_cache_meta(struct kmem_cache *cache, unsigned int *size) { }
 static inline void kasan_init_object_meta(struct kmem_cache *cache, const void *object) { }
+static inline void kasan_release_object_meta(struct kmem_cache *cache, const void *object) { }
 #endif
 
 depot_stack_handle_t kasan_save_stack(gfp_t flags, depot_flags_t depot_flags);
--- a/mm/kasan/quarantine.c~kasan-stop-leaking-stack-trace-handles
+++ a/mm/kasan/quarantine.c
@@ -143,22 +143,10 @@ static void *qlink_to_object(struct qlis
 static void qlink_free(struct qlist_node *qlink, struct kmem_cache *cache)
 {
 	void *object = qlink_to_object(qlink, cache);
-	struct kasan_alloc_meta *alloc_meta = kasan_get_alloc_meta(cache, object);
 	struct kasan_free_meta *free_meta = kasan_get_free_meta(cache, object);
 	unsigned long flags;
 
-	if (alloc_meta) {
-		stack_depot_put(alloc_meta->alloc_track.stack);
-		stack_depot_put(alloc_meta->aux_stack[0]);
-		stack_depot_put(alloc_meta->aux_stack[1]);
-		__memset(alloc_meta, 0, sizeof(*alloc_meta));
-	}
-
-	if (free_meta &&
-	    *(u8 *)kasan_mem_to_shadow(object) == KASAN_SLAB_FREETRACK) {
-		stack_depot_put(free_meta->free_track.stack);
-		__memset(&free_meta->free_track, 0, sizeof(free_meta->free_track));
-	}
+	kasan_release_object_meta(cache, object);
 
 	/*
 	 * If init_on_free is enabled and KASAN's free metadata is stored in
@@ -170,12 +158,6 @@ static void qlink_free(struct qlist_node
 	    cache->kasan_info.free_meta_offset == 0)
 		memzero_explicit(free_meta, sizeof(*free_meta));
 
-	/*
-	 * As the object now gets freed from the quarantine,
-	 * take note that its free track is no longer exists.
-	 */
-	*(u8 *)kasan_mem_to_shadow(object) = KASAN_SLAB_FREE;
-
 	if (IS_ENABLED(CONFIG_SLAB))
 		local_irq_save(flags);
 
--- a/mm/kasan/report_generic.c~kasan-stop-leaking-stack-trace-handles
+++ a/mm/kasan/report_generic.c
@@ -110,7 +110,7 @@ static const char *get_shadow_bug_type(s
 		bug_type = "use-after-free";
 		break;
 	case KASAN_SLAB_FREE:
-	case KASAN_SLAB_FREETRACK:
+	case KASAN_SLAB_FREE_META:
 		bug_type = "slab-use-after-free";
 		break;
 	case KASAN_ALLOCA_LEFT:
@@ -173,8 +173,8 @@ void kasan_complete_mode_report_info(str
 		memcpy(&info->alloc_track, &alloc_meta->alloc_track,
 		       sizeof(info->alloc_track));
 
-	if (*(u8 *)kasan_mem_to_shadow(info->object) == KASAN_SLAB_FREETRACK) {
-		/* Free meta must be present with KASAN_SLAB_FREETRACK. */
+	if (*(u8 *)kasan_mem_to_shadow(info->object) == KASAN_SLAB_FREE_META) {
+		/* Free meta must be present with KASAN_SLAB_FREE_META. */
 		free_meta = kasan_get_free_meta(info->cache, info->object);
 		memcpy(&info->free_track, &free_meta->free_track,
 		       sizeof(info->free_track));
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
kasan-rename-and-document-kasan_unpoison_object_data-fix.patch
skbuff-use-mempool-kasan-hooks.patch
io_uring-use-mempool-kasan-hook.patch
lib-stackdepot-add-printk_deferred_enter-exit-guards.patch
kasan-handle-concurrent-kasan_record_aux_stack-calls.patch
kasan-memset-free-track-in-qlink_free.patch
lib-stackdepot-fix-comment-in-include-linux-stackdepoth.patch
xtensa-kasan-define-kasan_shadow_end.patch
kasan-arm64-improve-comments-for-kasan_shadow_start-end.patch
mm-kasan-use-kasan_tag_kernel-instead-of-0xff.patch
kasan-improve-kasan_non_canonical_hook.patch
kasan-clean-up-kasan_requires_meta.patch
kasan-update-kasan_poison-documentation-comment.patch
kasan-clean-up-is_kfence_address-checks.patch
kasan-respect-config_kasan_vmalloc-for-kasan_flag_vmalloc.patch
kasan-check-kasan_vmalloc_enabled-in-vmalloc-tests.patch
kasan-export-kasan_poison-as-gpl.patch
kasan-remove-slub-checks-for-page_alloc-fallbacks-in-tests.patch
kasan-speed-up-match_all_mem_tag-test-for-sw_tags.patch
kasan-clean-up-kasan_cache_create.patch
kasan-reuse-kasan_track-in-kasan_stack_ring_entry.patch
kasan-simplify-saving-extra-info-into-tracks.patch
kasan-simplify-kasan_complete_mode_report_info-for-tag-based-modes.patch
kasan-stop-leaking-stack-trace-handles.patch

