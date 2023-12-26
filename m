Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B0123A8
	for <mm-commits@vger.kernel.org>; Tue, 26 Dec 2023 20:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sXfnNheI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E218C433C8;
	Tue, 26 Dec 2023 20:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703621328;
	bh=D9Mv+66uPd8brEVKppoHE1CXSpycmUUykGK/D2S9VSo=;
	h=Date:To:From:Subject:From;
	b=sXfnNheIrMBzGbQs7p3w9HWc3A1lpLLd6RQYIY6IW2aOdepOS7+CywxuMcLAJ7npt
	 sv6KxlfJRTjQRbX8ZSxgMCOargUrExZZeDx9vl4b3c52Cw4HBoGrWOQy+tPcRgAH9e
	 J6v2PCh8HAsQREKDBhh05R4u6AxX0HhK841yUdfY=
Date: Tue, 26 Dec 2023 12:08:47 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,lkp@intel.com,jcmvbkbc@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,chris@zankel.net,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xtensa-kasan-define-kasan_shadow_end.patch added to mm-unstable branch
Message-Id: <20231226200848.3E218C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xtensa, kasan: define KASAN_SHADOW_END
has been added to the -mm mm-unstable branch.  Its filename is
     xtensa-kasan-define-kasan_shadow_end.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xtensa-kasan-define-kasan_shadow_end.patch

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
Date: Mon, 25 Dec 2023 16:19:24 +0100
Subject: xtensa, kasan: define KASAN_SHADOW_END

Common KASAN code might rely on the definitions of the shadow mapping
start, end, and size.  Define KASAN_SHADOW_END in addition to
KASAN_SHADOW_START and KASAN_SHADOW_SIZE.

Link: https://lkml.kernel.org/r/20231225151924.5422-1-andrey.konovalov@linux.dev
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202312240755.MqsWuTno-lkp@intel.com/
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/include/asm/kasan.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/xtensa/include/asm/kasan.h~xtensa-kasan-define-kasan_shadow_end
+++ a/arch/xtensa/include/asm/kasan.h
@@ -18,6 +18,8 @@
 #define KASAN_SHADOW_START (XCHAL_PAGE_TABLE_VADDR + XCHAL_PAGE_TABLE_SIZE)
 /* Size of the shadow map */
 #define KASAN_SHADOW_SIZE (-KASAN_START_VADDR >> KASAN_SHADOW_SCALE_SHIFT)
+/* End of the shadow map */
+#define KASAN_SHADOW_END (KASAN_SHADOW_START + KASAN_SHADOW_SIZE)
 /* Offset for mem to shadow address transformation */
 #define KASAN_SHADOW_OFFSET __XTENSA_UL_CONST(CONFIG_KASAN_SHADOW_OFFSET)
 
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

