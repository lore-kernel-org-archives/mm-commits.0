Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F26134A1
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 19:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BHH3VCv4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27394C433C8;
	Fri, 29 Dec 2023 19:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703879482;
	bh=FMQ5fD6jCq9RMgKiaqXWionedZzEeTXg7vW3NcL7jgk=;
	h=Date:To:From:Subject:From;
	b=BHH3VCv4MI9kTiQb3MOLqOkLrffcLL3y6X8I7eCjG/dKQQiB/CJqmdCNUu8Xoh2Co
	 RpIm/3ziIv2QNzOELvmu7I8SEGwVsc6IEIFgJDfQrzHDSpO/WgqfJH5RmOGebLK2UQ
	 ADYblNmxjj9GuT/dXtEiRMlF04I+zRLfgUw/7H7I=
Date: Fri, 29 Dec 2023 11:51:21 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kasan-rename-and-document-kasan_unpoison_object_data-fix.patch removed from -mm tree
Message-Id: <20231229195122.27394C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: fix for "kasan: rename and document kasan_(un)poison_object_data"
has been removed from the -mm tree.  Its filename was
     kasan-rename-and-document-kasan_unpoison_object_data-fix.patch

This patch was dropped because it was folded into kasan-rename-and-document-kasan_unpoison_object_data.patch

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: fix for "kasan: rename and document kasan_(un)poison_object_data"
Date: Thu, 21 Dec 2023 19:06:37 +0100

Update references to renamed functions in comments.

Link: https://lkml.kernel.org/r/20231221180637.105098-1-andrey.konovalov@linux.dev
Fixes: ac6b240e1ede ("kasan: rename and document kasan_(un)poison_object_data")
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/shadow.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/kasan/shadow.c~kasan-rename-and-document-kasan_unpoison_object_data-fix
+++ a/mm/kasan/shadow.c
@@ -130,7 +130,7 @@ void kasan_poison(const void *addr, size
 
 	/*
 	 * Perform shadow offset calculation based on untagged address, as
-	 * some of the callers (e.g. kasan_poison_object_data) pass tagged
+	 * some of the callers (e.g. kasan_poison_new_object) pass tagged
 	 * addresses to this function.
 	 */
 	addr = kasan_reset_tag(addr);
@@ -170,7 +170,7 @@ void kasan_unpoison(const void *addr, si
 
 	/*
 	 * Perform shadow offset calculation based on untagged address, as
-	 * some of the callers (e.g. kasan_unpoison_object_data) pass tagged
+	 * some of the callers (e.g. kasan_unpoison_new_object) pass tagged
 	 * addresses to this function.
 	 */
 	addr = kasan_reset_tag(addr);
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

