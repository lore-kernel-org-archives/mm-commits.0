Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DBC4745DA
	for <mm-commits@vger.kernel.org>; Thu, 21 Dec 2023 21:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HO0w6dpg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A13D3C433C7;
	Thu, 21 Dec 2023 21:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703194675;
	bh=0FL4woiSu2dNHvpD3fpxdinzSHF+751dVHKdnm2CmwM=;
	h=Date:To:From:Subject:From;
	b=HO0w6dpgGgK786MmJqXbpFdDoYoZEFzxlzhOa44UlJlwHWGx9hzryOl0xvqoNJcH6
	 oxEMRrZWQFkZWVJ0eTJlK7xTxFBj9R/ekvO7MPTB5EH0T71VjdNc9OS7VcKU9l3lre
	 bRFUkOFfs+AvoH9EnrbezgEfEw98RMvi8Erjdoj0=
Date: Thu, 21 Dec 2023 13:37:54 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kasan-use-kasan_tag_kernel-instead-of-0xff.patch added to mm-unstable branch
Message-Id: <20231221213755.A13D3C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, kasan: use KASAN_TAG_KERNEL instead of 0xff
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kasan-use-kasan_tag_kernel-instead-of-0xff.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kasan-use-kasan_tag_kernel-instead-of-0xff.patch

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
Subject: mm, kasan: use KASAN_TAG_KERNEL instead of 0xff
Date: Thu, 21 Dec 2023 21:04:44 +0100

Use the KASAN_TAG_KERNEL marco instead of open-coding 0xff in the mm code.
This macro is provided by include/linux/kasan-tags.h, which does not
include any other headers, so it's safe to include it into mm.h without
causing circular include dependencies.

Link: https://lkml.kernel.org/r/71db9087b0aebb6c4dccbc609cc0cd50621533c7.1703188911.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |    1 +
 include/linux/mm.h    |    4 ++--
 mm/page_alloc.c       |    2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

--- a/include/linux/kasan.h~mm-kasan-use-kasan_tag_kernel-instead-of-0xff
+++ a/include/linux/kasan.h
@@ -4,6 +4,7 @@
 
 #include <linux/bug.h>
 #include <linux/kasan-enabled.h>
+#include <linux/kasan-tags.h>
 #include <linux/kernel.h>
 #include <linux/static_key.h>
 #include <linux/types.h>
--- a/include/linux/mm.h~mm-kasan-use-kasan_tag_kernel-instead-of-0xff
+++ a/include/linux/mm.h
@@ -1815,7 +1815,7 @@ static inline void vma_set_access_pid_bi
 
 static inline u8 page_kasan_tag(const struct page *page)
 {
-	u8 tag = 0xff;
+	u8 tag = KASAN_TAG_KERNEL;
 
 	if (kasan_enabled()) {
 		tag = (page->flags >> KASAN_TAG_PGSHIFT) & KASAN_TAG_MASK;
@@ -1844,7 +1844,7 @@ static inline void page_kasan_tag_set(st
 static inline void page_kasan_tag_reset(struct page *page)
 {
 	if (kasan_enabled())
-		page_kasan_tag_set(page, 0xff);
+		page_kasan_tag_set(page, KASAN_TAG_KERNEL);
 }
 
 #else /* CONFIG_KASAN_SW_TAGS || CONFIG_KASAN_HW_TAGS */
--- a/mm/page_alloc.c~mm-kasan-use-kasan_tag_kernel-instead-of-0xff
+++ a/mm/page_alloc.c
@@ -1059,7 +1059,7 @@ static inline bool should_skip_kasan_poi
 	if (IS_ENABLED(CONFIG_KASAN_GENERIC))
 		return deferred_pages_enabled();
 
-	return page_kasan_tag(page) == 0xff;
+	return page_kasan_tag(page) == KASAN_TAG_KERNEL;
 }
 
 static void kernel_init_pages(struct page *page, int numpages)
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

