Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58FA7763A
	for <mm-commits@vger.kernel.org>; Thu, 21 Dec 2023 21:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="egmowBYp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67669C433C8;
	Thu, 21 Dec 2023 21:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703195267;
	bh=fQIAlLLJQ7gmi0XV/7f2f3CjIvg6FlpHhoaSY4lbt+4=;
	h=Date:To:From:Subject:From;
	b=egmowBYpHICqTs3yNnbUdZRK8cBbsYMgBm2lg4nP8vMmnnepZwaeOT6tldMcViK3h
	 vhwAGuMItO+VLM16kpqMhh/X5pz7GVw3or08p/eCYf5UKQ0pmre5H3aju/HTIRcp8R
	 uvY+gxEhAPoPi/QLoS5fV6JWsfabkh6RSkjjyyJ4=
Date: Thu, 21 Dec 2023 13:47:45 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,juntong.deng@outlook.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-simplify-saving-extra-info-into-tracks.patch added to mm-unstable branch
Message-Id: <20231221214747.67669C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: simplify saving extra info into tracks
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-simplify-saving-extra-info-into-tracks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-simplify-saving-extra-info-into-tracks.patch

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
Subject: kasan: simplify saving extra info into tracks
Date: Thu, 21 Dec 2023 19:35:39 +0100

Avoid duplicating code for saving extra info into tracks: reuse the common
function for this.

Link: https://lkml.kernel.org/r/20231221183540.168428-3-andrey.konovalov@linux.dev
Fixes: 5d4c6ac94694 ("kasan: record and report more information")
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Juntong Deng <juntong.deng@outlook.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c  |   12 ++++++++++--
 mm/kasan/generic.c |    4 ++--
 mm/kasan/kasan.h   |    3 ++-
 mm/kasan/tags.c    |   17 +----------------
 4 files changed, 15 insertions(+), 21 deletions(-)

--- a/mm/kasan/common.c~kasan-simplify-saving-extra-info-into-tracks
+++ a/mm/kasan/common.c
@@ -48,7 +48,7 @@ depot_stack_handle_t kasan_save_stack(gf
 	return stack_depot_save_flags(entries, nr_entries, flags, depot_flags);
 }
 
-void kasan_set_track(struct kasan_track *track, gfp_t flags)
+void kasan_set_track(struct kasan_track *track, depot_stack_handle_t stack)
 {
 #ifdef CONFIG_KASAN_EXTRA_INFO
 	u32 cpu = raw_smp_processor_id();
@@ -58,8 +58,16 @@ void kasan_set_track(struct kasan_track
 	track->timestamp = ts_nsec >> 3;
 #endif /* CONFIG_KASAN_EXTRA_INFO */
 	track->pid = current->pid;
-	track->stack = kasan_save_stack(flags,
+	track->stack = stack;
+}
+
+void kasan_save_track(struct kasan_track *track, gfp_t flags)
+{
+	depot_stack_handle_t stack;
+
+	stack = kasan_save_stack(flags,
 			STACK_DEPOT_FLAG_CAN_ALLOC | STACK_DEPOT_FLAG_GET);
+	kasan_set_track(track, stack);
 }
 
 #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
--- a/mm/kasan/generic.c~kasan-simplify-saving-extra-info-into-tracks
+++ a/mm/kasan/generic.c
@@ -579,7 +579,7 @@ void kasan_save_alloc_info(struct kmem_c
 	stack_depot_put(alloc_meta->aux_stack[1]);
 	__memset(alloc_meta, 0, sizeof(*alloc_meta));
 
-	kasan_set_track(&alloc_meta->alloc_track, flags);
+	kasan_save_track(&alloc_meta->alloc_track, flags);
 }
 
 void kasan_save_free_info(struct kmem_cache *cache, void *object)
@@ -590,7 +590,7 @@ void kasan_save_free_info(struct kmem_ca
 	if (!free_meta)
 		return;
 
-	kasan_set_track(&free_meta->free_track, 0);
+	kasan_save_track(&free_meta->free_track, 0);
 	/* The object was freed and has free track set. */
 	*(u8 *)kasan_mem_to_shadow(object) = KASAN_SLAB_FREETRACK;
 }
--- a/mm/kasan/kasan.h~kasan-simplify-saving-extra-info-into-tracks
+++ a/mm/kasan/kasan.h
@@ -392,7 +392,8 @@ static inline void kasan_init_object_met
 #endif
 
 depot_stack_handle_t kasan_save_stack(gfp_t flags, depot_flags_t depot_flags);
-void kasan_set_track(struct kasan_track *track, gfp_t flags);
+void kasan_set_track(struct kasan_track *track, depot_stack_handle_t stack);
+void kasan_save_track(struct kasan_track *track, gfp_t flags);
 void kasan_save_alloc_info(struct kmem_cache *cache, void *object, gfp_t flags);
 void kasan_save_free_info(struct kmem_cache *cache, void *object);
 
--- a/mm/kasan/tags.c~kasan-simplify-saving-extra-info-into-tracks
+++ a/mm/kasan/tags.c
@@ -94,17 +94,6 @@ void __init kasan_init_tags(void)
 	}
 }
 
-#ifdef CONFIG_KASAN_EXTRA_INFO
-static void save_extra_info(struct kasan_stack_ring_entry *entry)
-{
-	u32 cpu = raw_smp_processor_id();
-	u64 ts_nsec = local_clock();
-
-	entry->track.cpu = cpu;
-	entry->track.timestamp = ts_nsec >> 3;
-}
-#endif /* CONFIG_KASAN_EXTRA_INFO */
-
 static void save_stack_info(struct kmem_cache *cache, void *object,
 			gfp_t gfp_flags, bool is_free)
 {
@@ -137,11 +126,7 @@ next:
 	old_stack = entry->track.stack;
 
 	entry->size = cache->object_size;
-	entry->track.pid = current->pid;
-	entry->track.stack = stack;
-#ifdef CONFIG_KASAN_EXTRA_INFO
-	save_extra_info(entry);
-#endif /* CONFIG_KASAN_EXTRA_INFO */
+	kasan_set_track(&entry->track, stack);
 	entry->is_free = is_free;
 
 	entry->ptr = object;
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

