Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D42413AF1
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IrgzrEY8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B0B8C433C8;
	Fri, 29 Dec 2023 20:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880082;
	bh=A4gqb+mDiLruToUs254jStlBaK/f7LGBuXS2oWCM6ww=;
	h=Date:To:From:Subject:From;
	b=IrgzrEY8L1jWj5opTKgdjB/mxkZcdkKcLCXGYwQYONciK2y/rb3nDnvHpSyeX61cQ
	 ml6uR4BcgjoaFbYy3LJqzF5253rxZe53sCuogr2aOllveiwDScVZi0eGPBNZjXUu+v
	 AwHxEcIU32VHgipntAaN0R31+TIpsq9YmHUAZQAk=
Date: Fri, 29 Dec 2023 12:01:21 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,juntong.deng@outlook.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-simplify-saving-extra-info-into-tracks.patch removed from -mm tree
Message-Id: <20231229200122.1B0B8C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: simplify saving extra info into tracks
has been removed from the -mm tree.  Its filename was
     kasan-simplify-saving-extra-info-into-tracks.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

kasan-stop-leaking-stack-trace-handles.patch

