Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5E377620
	for <mm-commits@vger.kernel.org>; Thu, 21 Dec 2023 21:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fx0bTpOi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 271DEC433C7;
	Thu, 21 Dec 2023 21:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703194678;
	bh=g24Rd6GK6wkIRIXBuItTK0nCh7a6P+Wcc0XJXQxeDLw=;
	h=Date:To:From:Subject:From;
	b=Fx0bTpOiAt+MPlfNUCD3E97qpieFucxxV6QV3QFaxLiHOGjjf6rBMTE4u4o/OeLFP
	 ByRO5w+JaJthSz75q9p3zy0Il9J72ye2/A1ZNxQHO7sSgNlxtSBw7GxhMycXmdJM9q
	 7+HLqXXIS0mK5DkjO/vLO2RirKqwvtT+fkr6Un70=
Date: Thu, 21 Dec 2023 13:37:56 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-clean-up-kasan_requires_meta.patch added to mm-unstable branch
Message-Id: <20231221213758.271DEC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: clean up kasan_requires_meta
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-clean-up-kasan_requires_meta.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-clean-up-kasan_requires_meta.patch

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
Subject: kasan: clean up kasan_requires_meta
Date: Thu, 21 Dec 2023 21:04:46 +0100

Currently, for Generic KASAN mode, kasan_requires_meta is defined to
return kasan_stack_collection_enabled.

Even though the Generic mode does not support disabling stack trace
collection, kasan_requires_meta was implemented in this way to make it
easier to implement the disabling for the Generic mode in the future.

However, for the Generic mode, the per-object metadata also stores the
quarantine link.  So even if disabling stack collection is implemented,
the per-object metadata will still be required.

Fix kasan_requires_meta to return true for the Generic mode and update the
related comments.

This change does not fix any observable bugs but rather just brings the
code to a cleaner state.

Link: https://lkml.kernel.org/r/8086623407095ac1c82377a2107dcc5845f99cfa.1703188911.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/mm/kasan/kasan.h~kasan-clean-up-kasan_requires_meta
+++ a/mm/kasan/kasan.h
@@ -101,21 +101,21 @@ static inline bool kasan_sample_page_all
 
 #ifdef CONFIG_KASAN_GENERIC
 
-/* Generic KASAN uses per-object metadata to store stack traces. */
+/*
+ * Generic KASAN uses per-object metadata to store alloc and free stack traces
+ * and the quarantine link.
+ */
 static inline bool kasan_requires_meta(void)
 {
-	/*
-	 * Technically, Generic KASAN always collects stack traces right now.
-	 * However, let's use kasan_stack_collection_enabled() in case the
-	 * kasan.stacktrace command-line argument is changed to affect
-	 * Generic KASAN.
-	 */
-	return kasan_stack_collection_enabled();
+	return true;
 }
 
 #else /* CONFIG_KASAN_GENERIC */
 
-/* Tag-based KASAN modes do not use per-object metadata. */
+/*
+ * Tag-based KASAN modes do not use per-object metadata: they use the stack
+ * ring to store alloc and free stack traces and do not use qurantine.
+ */
 static inline bool kasan_requires_meta(void)
 {
 	return false;
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

