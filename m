Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C8355E59
	for <mm-commits@vger.kernel.org>; Thu, 21 Dec 2023 21:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yTiF7ZbF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E509FC433C9;
	Thu, 21 Dec 2023 21:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703195266;
	bh=783OI0IguIS5J83ssRWbmg7YuxxxPmNU24z9iul0X8s=;
	h=Date:To:From:Subject:From;
	b=yTiF7ZbFTXx8DE3BHkDTvYWtym75JzQJn/zKo0QueXyJutK/T92jBLtrk2n2oqX94
	 sYDputU5Hhn76+QmUAd3hSkSylO8/KGYTZLtqU1E0rgX6H8iaAChF/Vm5xv5Z9hZpb
	 A2/WLeb5UQga3mYaIvhdEY7nUOI2N79IDj6g49ZI=
Date: Thu, 21 Dec 2023 13:47:44 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,juntong.deng@outlook.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-reuse-kasan_track-in-kasan_stack_ring_entry.patch added to mm-unstable branch
Message-Id: <20231221214745.E509FC433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: reuse kasan_track in kasan_stack_ring_entry
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-reuse-kasan_track-in-kasan_stack_ring_entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-reuse-kasan_track-in-kasan_stack_ring_entry.patch

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
Subject: kasan: reuse kasan_track in kasan_stack_ring_entry
Date: Thu, 21 Dec 2023 19:35:38 +0100

Avoid duplicating fields of kasan_track in kasan_stack_ring_entry: reuse
the structure.

Link: https://lkml.kernel.org/r/20231221183540.168428-2-andrey.konovalov@linux.dev
Fixes: 5d4c6ac94694 ("kasan: record and report more information")
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Juntong Deng <juntong.deng@outlook.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h       |    7 +------
 mm/kasan/report_tags.c |   12 ++++++------
 mm/kasan/tags.c        |   12 ++++++------
 3 files changed, 13 insertions(+), 18 deletions(-)

--- a/mm/kasan/kasan.h~kasan-reuse-kasan_track-in-kasan_stack_ring_entry
+++ a/mm/kasan/kasan.h
@@ -293,13 +293,8 @@ struct kasan_free_meta {
 struct kasan_stack_ring_entry {
 	void *ptr;
 	size_t size;
-	u32 pid;
-	depot_stack_handle_t stack;
+	struct kasan_track track;
 	bool is_free;
-#ifdef CONFIG_KASAN_EXTRA_INFO
-	u64 cpu:20;
-	u64 timestamp:44;
-#endif /* CONFIG_KASAN_EXTRA_INFO */
 };
 
 struct kasan_stack_ring {
--- a/mm/kasan/report_tags.c~kasan-reuse-kasan_track-in-kasan_stack_ring_entry
+++ a/mm/kasan/report_tags.c
@@ -31,8 +31,8 @@ static const char *get_common_bug_type(s
 static void kasan_complete_extra_report_info(struct kasan_track *track,
 					 struct kasan_stack_ring_entry *entry)
 {
-	track->cpu = entry->cpu;
-	track->timestamp = entry->timestamp;
+	track->cpu = entry->track.cpu;
+	track->timestamp = entry->track.timestamp;
 }
 #endif /* CONFIG_KASAN_EXTRA_INFO */
 
@@ -80,8 +80,8 @@ void kasan_complete_mode_report_info(str
 			if (free_found)
 				break;
 
-			info->free_track.pid = entry->pid;
-			info->free_track.stack = entry->stack;
+			info->free_track.pid = entry->track.pid;
+			info->free_track.stack = entry->track.stack;
 #ifdef CONFIG_KASAN_EXTRA_INFO
 			kasan_complete_extra_report_info(&info->free_track, entry);
 #endif /* CONFIG_KASAN_EXTRA_INFO */
@@ -98,8 +98,8 @@ void kasan_complete_mode_report_info(str
 			if (alloc_found)
 				break;
 
-			info->alloc_track.pid = entry->pid;
-			info->alloc_track.stack = entry->stack;
+			info->alloc_track.pid = entry->track.pid;
+			info->alloc_track.stack = entry->track.stack;
 #ifdef CONFIG_KASAN_EXTRA_INFO
 			kasan_complete_extra_report_info(&info->alloc_track, entry);
 #endif /* CONFIG_KASAN_EXTRA_INFO */
--- a/mm/kasan/tags.c~kasan-reuse-kasan_track-in-kasan_stack_ring_entry
+++ a/mm/kasan/tags.c
@@ -100,8 +100,8 @@ static void save_extra_info(struct kasan
 	u32 cpu = raw_smp_processor_id();
 	u64 ts_nsec = local_clock();
 
-	entry->cpu = cpu;
-	entry->timestamp = ts_nsec >> 3;
+	entry->track.cpu = cpu;
+	entry->track.timestamp = ts_nsec >> 3;
 }
 #endif /* CONFIG_KASAN_EXTRA_INFO */
 
@@ -134,15 +134,15 @@ next:
 	if (!try_cmpxchg(&entry->ptr, &old_ptr, STACK_RING_BUSY_PTR))
 		goto next; /* Busy slot. */
 
-	old_stack = entry->stack;
+	old_stack = entry->track.stack;
 
 	entry->size = cache->object_size;
-	entry->pid = current->pid;
-	entry->stack = stack;
-	entry->is_free = is_free;
+	entry->track.pid = current->pid;
+	entry->track.stack = stack;
 #ifdef CONFIG_KASAN_EXTRA_INFO
 	save_extra_info(entry);
 #endif /* CONFIG_KASAN_EXTRA_INFO */
+	entry->is_free = is_free;
 
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

