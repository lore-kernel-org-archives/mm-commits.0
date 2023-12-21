Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D647745DA
	for <mm-commits@vger.kernel.org>; Thu, 21 Dec 2023 21:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RfZ0fYYA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5788C433C9;
	Thu, 21 Dec 2023 21:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703194677;
	bh=p5DsyktNZpJOIiIN1fJJJNWrUvDgYsid5XjyDiOzgQs=;
	h=Date:To:From:Subject:From;
	b=RfZ0fYYAMK8/QuDEMgTSuDjF+b9a3n6gsBeWbjLCyVEX1k7gEAPintRfHt6keIGtO
	 S+7hUiBSIKs+6RV1MpYp7jtDh+YA/TzKgDN7W+lKOsfIl9zQXAFK/DHd/JJIzYxK9X
	 hb+XxGAzUWsK0DMpJcOjCcExEdhsZtpStraCvXg4=
Date: Thu, 21 Dec 2023 13:37:55 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-improve-kasan_non_canonical_hook.patch added to mm-unstable branch
Message-Id: <20231221213756.E5788C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: improve kasan_non_canonical_hook
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-improve-kasan_non_canonical_hook.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-improve-kasan_non_canonical_hook.patch

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
Subject: kasan: improve kasan_non_canonical_hook
Date: Thu, 21 Dec 2023 21:04:45 +0100

Make kasan_non_canonical_hook to be more sure in its report (i.e.  say
"probably" instead of "maybe") if the address belongs to the shadow memory
region for kernel addresses.

Also use the kasan_shadow_to_mem helper to calculate the original address.

Also improve the comments in kasan_non_canonical_hook.

Link: https://lkml.kernel.org/r/af94ef3cb26f8c065048b3158d9f20f6102bfaaa.1703188911.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h  |    6 ++++++
 mm/kasan/report.c |   34 ++++++++++++++++++++--------------
 2 files changed, 26 insertions(+), 14 deletions(-)

--- a/mm/kasan/kasan.h~kasan-improve-kasan_non_canonical_hook
+++ a/mm/kasan/kasan.h
@@ -307,6 +307,12 @@ struct kasan_stack_ring {
 
 #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
 
+static __always_inline bool addr_in_shadow(const void *addr)
+{
+	return addr >= (void *)KASAN_SHADOW_START &&
+		addr < (void *)KASAN_SHADOW_END;
+}
+
 #ifndef kasan_shadow_to_mem
 static inline const void *kasan_shadow_to_mem(const void *shadow_addr)
 {
--- a/mm/kasan/report.c~kasan-improve-kasan_non_canonical_hook
+++ a/mm/kasan/report.c
@@ -635,37 +635,43 @@ void kasan_report_async(void)
 
 #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
 /*
- * With CONFIG_KASAN_INLINE, accesses to bogus pointers (outside the high
- * canonical half of the address space) cause out-of-bounds shadow memory reads
- * before the actual access. For addresses in the low canonical half of the
- * address space, as well as most non-canonical addresses, that out-of-bounds
- * shadow memory access lands in the non-canonical part of the address space.
- * Help the user figure out what the original bogus pointer was.
+ * With compiler-based KASAN modes, accesses to bogus pointers (outside of the
+ * mapped kernel address space regions) cause faults when KASAN tries to check
+ * the shadow memory before the actual memory access. This results in cryptic
+ * GPF reports, which are hard for users to interpret. This hook helps users to
+ * figure out what the original bogus pointer was.
  */
 void kasan_non_canonical_hook(unsigned long addr)
 {
 	unsigned long orig_addr;
 	const char *bug_type;
 
+	/*
+	 * All addresses that came as a result of the memory-to-shadow mapping
+	 * (even for bogus pointers) must be >= KASAN_SHADOW_OFFSET.
+	 */
 	if (addr < KASAN_SHADOW_OFFSET)
 		return;
 
-	orig_addr = (addr - KASAN_SHADOW_OFFSET) << KASAN_SHADOW_SCALE_SHIFT;
+	orig_addr = (unsigned long)kasan_shadow_to_mem((void *)addr);
+
 	/*
 	 * For faults near the shadow address for NULL, we can be fairly certain
 	 * that this is a KASAN shadow memory access.
-	 * For faults that correspond to shadow for low canonical addresses, we
-	 * can still be pretty sure - that shadow region is a fairly narrow
-	 * chunk of the non-canonical address space.
-	 * But faults that look like shadow for non-canonical addresses are a
-	 * really large chunk of the address space. In that case, we still
-	 * print the decoded address, but make it clear that this is not
-	 * necessarily what's actually going on.
+	 * For faults that correspond to the shadow for low or high canonical
+	 * addresses, we can still be pretty sure: these shadow regions are a
+	 * fairly narrow chunk of the address space.
+	 * But the shadow for non-canonical addresses is a really large chunk
+	 * of the address space. For this case, we still print the decoded
+	 * address, but make it clear that this is not necessarily what's
+	 * actually going on.
 	 */
 	if (orig_addr < PAGE_SIZE)
 		bug_type = "null-ptr-deref";
 	else if (orig_addr < TASK_SIZE)
 		bug_type = "probably user-memory-access";
+	else if (addr_in_shadow((void *)addr))
+		bug_type = "probably wild-memory-access";
 	else
 		bug_type = "maybe wild-memory-access";
 	pr_alert("KASAN: %s in range [0x%016lx-0x%016lx]\n", bug_type,
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

