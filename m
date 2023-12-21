Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5DF76DC0
	for <mm-commits@vger.kernel.org>; Thu, 21 Dec 2023 21:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nkPVFQql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F073C433C8;
	Thu, 21 Dec 2023 21:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703194680;
	bh=52Vn9AUVbkFICqPgqoK9sMkib+JA6IS0jQ1JHyojr6o=;
	h=Date:To:From:Subject:From;
	b=nkPVFQqlliGfBLLJaT0UenE8HPrZP34Zwrq7yHLIVRXdfXbaBTrj11yFQ4nMOmaV8
	 T4pR18+Wn9hWqN6JCBnwwF+jbHnAs21PnMr5+9U16sg+pGpwq5GXeOJKnX+PsLa3YH
	 n0HLkrpIgCQpXHO2EyXdij+5xfpTz70XcbImr7Lk=
Date: Thu, 21 Dec 2023 13:37:59 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-clean-up-is_kfence_address-checks.patch added to mm-unstable branch
Message-Id: <20231221213800.7F073C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: clean up is_kfence_address checks
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-clean-up-is_kfence_address-checks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-clean-up-is_kfence_address-checks.patch

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
Subject: kasan: clean up is_kfence_address checks
Date: Thu, 21 Dec 2023 21:04:48 +0100

1. Do not untag addresses that are passed to is_kfence_address: it
   tolerates tagged addresses.

2. Move is_kfence_address checks from internal KASAN functions
   (kasan_poison/unpoison, etc.) to external-facing ones.

   Note that kasan_poison/unpoison are never called outside of KASAN/slab
   code anymore; the comment is wrong, so drop it.

3. Simplify/reorganize the code around the updated checks.

Link: https://lkml.kernel.org/r/1065732315ef4e141b6177d8f612232d4d5bc0ab.1703188911.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c |   26 +++++++++++++++++---------
 mm/kasan/kasan.h  |   16 ++--------------
 mm/kasan/shadow.c |   12 ------------
 3 files changed, 19 insertions(+), 35 deletions(-)

--- a/mm/kasan/common.c~kasan-clean-up-is_kfence_address-checks
+++ a/mm/kasan/common.c
@@ -79,6 +79,9 @@ EXPORT_SYMBOL(kasan_disable_current);
 
 void __kasan_unpoison_range(const void *address, size_t size)
 {
+	if (is_kfence_address(address))
+		return;
+
 	kasan_unpoison(address, size, false);
 }
 
@@ -218,9 +221,6 @@ static inline bool poison_slab_object(st
 	tagged_object = object;
 	object = kasan_reset_tag(object);
 
-	if (is_kfence_address(object))
-		return false;
-
 	if (unlikely(nearest_obj(cache, virt_to_slab(object), object) != object)) {
 		kasan_report_invalid_free(tagged_object, ip, KASAN_REPORT_INVALID_FREE);
 		return true;
@@ -247,7 +247,12 @@ static inline bool poison_slab_object(st
 bool __kasan_slab_free(struct kmem_cache *cache, void *object,
 				unsigned long ip, bool init)
 {
-	bool buggy_object = poison_slab_object(cache, object, ip, init);
+	bool buggy_object;
+
+	if (is_kfence_address(object))
+		return false;
+
+	buggy_object = poison_slab_object(cache, object, ip, init);
 
 	return buggy_object ? true : kasan_quarantine_put(cache, object);
 }
@@ -359,7 +364,7 @@ void * __must_check __kasan_kmalloc(stru
 	if (unlikely(object == NULL))
 		return NULL;
 
-	if (is_kfence_address(kasan_reset_tag(object)))
+	if (is_kfence_address(object))
 		return (void *)object;
 
 	/* The object has already been unpoisoned by kasan_slab_alloc(). */
@@ -417,7 +422,7 @@ void * __must_check __kasan_krealloc(con
 	if (unlikely(object == ZERO_SIZE_PTR))
 		return (void *)object;
 
-	if (is_kfence_address(kasan_reset_tag(object)))
+	if (is_kfence_address(object))
 		return (void *)object;
 
 	/*
@@ -483,6 +488,9 @@ bool __kasan_mempool_poison_object(void
 		return true;
 	}
 
+	if (is_kfence_address(ptr))
+		return false;
+
 	slab = folio_slab(folio);
 	return !poison_slab_object(slab->slab_cache, ptr, ip, false);
 }
@@ -492,9 +500,6 @@ void __kasan_mempool_unpoison_object(voi
 	struct slab *slab;
 	gfp_t flags = 0; /* Might be executing under a lock. */
 
-	if (is_kfence_address(kasan_reset_tag(ptr)))
-		return;
-
 	slab = virt_to_slab(ptr);
 
 	/*
@@ -507,6 +512,9 @@ void __kasan_mempool_unpoison_object(voi
 		return;
 	}
 
+	if (is_kfence_address(ptr))
+		return;
+
 	/* Unpoison the object and save alloc info for non-kmalloc() allocations. */
 	unpoison_slab_object(slab->slab_cache, ptr, size, flags);
 
--- a/mm/kasan/kasan.h~kasan-clean-up-is_kfence_address-checks
+++ a/mm/kasan/kasan.h
@@ -466,35 +466,23 @@ static inline u8 kasan_random_tag(void)
 
 static inline void kasan_poison(const void *addr, size_t size, u8 value, bool init)
 {
-	addr = kasan_reset_tag(addr);
-
-	/* Skip KFENCE memory if called explicitly outside of sl*b. */
-	if (is_kfence_address(addr))
-		return;
-
 	if (WARN_ON((unsigned long)addr & KASAN_GRANULE_MASK))
 		return;
 	if (WARN_ON(size & KASAN_GRANULE_MASK))
 		return;
 
-	hw_set_mem_tag_range((void *)addr, size, value, init);
+	hw_set_mem_tag_range(kasan_reset_tag(addr), size, value, init);
 }
 
 static inline void kasan_unpoison(const void *addr, size_t size, bool init)
 {
 	u8 tag = get_tag(addr);
 
-	addr = kasan_reset_tag(addr);
-
-	/* Skip KFENCE memory if called explicitly outside of sl*b. */
-	if (is_kfence_address(addr))
-		return;
-
 	if (WARN_ON((unsigned long)addr & KASAN_GRANULE_MASK))
 		return;
 	size = round_up(size, KASAN_GRANULE_SIZE);
 
-	hw_set_mem_tag_range((void *)addr, size, tag, init);
+	hw_set_mem_tag_range(kasan_reset_tag(addr), size, tag, init);
 }
 
 static inline bool kasan_byte_accessible(const void *addr)
--- a/mm/kasan/shadow.c~kasan-clean-up-is_kfence_address-checks
+++ a/mm/kasan/shadow.c
@@ -135,10 +135,6 @@ void kasan_poison(const void *addr, size
 	 */
 	addr = kasan_reset_tag(addr);
 
-	/* Skip KFENCE memory if called explicitly outside of sl*b. */
-	if (is_kfence_address(addr))
-		return;
-
 	if (WARN_ON((unsigned long)addr & KASAN_GRANULE_MASK))
 		return;
 	if (WARN_ON(size & KASAN_GRANULE_MASK))
@@ -175,14 +171,6 @@ void kasan_unpoison(const void *addr, si
 	 */
 	addr = kasan_reset_tag(addr);
 
-	/*
-	 * Skip KFENCE memory if called explicitly outside of sl*b. Also note
-	 * that calls to ksize(), where size is not a multiple of machine-word
-	 * size, would otherwise poison the invalid portion of the word.
-	 */
-	if (is_kfence_address(addr))
-		return;
-
 	if (WARN_ON((unsigned long)addr & KASAN_GRANULE_MASK))
 		return;
 
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

