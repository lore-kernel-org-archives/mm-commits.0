Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F4A77620
	for <mm-commits@vger.kernel.org>; Thu, 21 Dec 2023 21:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EU1OGlSO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D19C433C8;
	Thu, 21 Dec 2023 21:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703194679;
	bh=/95Fy3sMWCw82jzLpDoWjZ8medYPYI8pTxJhlqybWa4=;
	h=Date:To:From:Subject:From;
	b=EU1OGlSOedtm0aWLuMOiOQLBxjqQmeG5rpDBqns6yZNf0De/+yuG+KkMfR3Bf3JHJ
	 X+FmuMyXwvtAEB105G5rBoR3MH5QVGLK4p6m8+3daX/zVkOOLXMQmTgTL5L4Nbv5UA
	 VClodB31yDN+aQ8fE/o97gh9Sp3LuvEMTnijBh3Q=
Date: Thu, 21 Dec 2023 13:37:58 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-update-kasan_poison-documentation-comment.patch added to mm-unstable branch
Message-Id: <20231221213759.67D19C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: update kasan_poison documentation comment
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-update-kasan_poison-documentation-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-update-kasan_poison-documentation-comment.patch

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
Subject: kasan: update kasan_poison documentation comment
Date: Thu, 21 Dec 2023 21:04:47 +0100

The comment for kasan_poison says that the size argument gets aligned by
the function to KASAN_GRANULE_SIZE, which is wrong: the argument must be
already aligned when it is passed to the function.

Remove the invalid part of the comment.

Link: https://lkml.kernel.org/r/992a302542059fc40d86ea560eac413ecb31b6a1.1703188911.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/kasan/kasan.h~kasan-update-kasan_poison-documentation-comment
+++ a/mm/kasan/kasan.h
@@ -513,8 +513,6 @@ static inline bool kasan_byte_accessible
  * @size - range size, must be aligned to KASAN_GRANULE_SIZE
  * @value - value that's written to metadata for the range
  * @init - whether to initialize the memory range (only for hardware tag-based)
- *
- * The size gets aligned to KASAN_GRANULE_SIZE before marking the range.
  */
 void kasan_poison(const void *addr, size_t size, u8 value, bool init);
 
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

