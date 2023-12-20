Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1327F10FA
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 00:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vTd8j5xx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AC56C433C8;
	Wed, 20 Dec 2023 00:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703030733;
	bh=ZIN/7c+HVHlNiyzlF0eWaSIYrq6G9nGJpk44V+t/zHY=;
	h=Date:To:From:Subject:From;
	b=vTd8j5xxcWwR7uMVuGCbv2YOdK6f7y79wrMh/qVUymxSEUmNHO9++RO1v3f0ErPmO
	 de8NE5hMENyr1fjzcI496mU35Lc5KT5ckG4G31XYUz5Bvjdg4yAWCz/UuiTBfXuNf7
	 RvARFqvY1NAvpW/A5HPIURDSC8rG3p7GqKnlmL3U=
Date: Tue, 19 Dec 2023 16:05:32 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,leitao@debian.org,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,alobakin@pm.me,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-introduce-kasan_mempool_unpoison_object.patch added to mm-unstable branch
Message-Id: <20231220000533.7AC56C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: introduce kasan_mempool_unpoison_object
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-introduce-kasan_mempool_unpoison_object.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-introduce-kasan_mempool_unpoison_object.patch

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
Subject: kasan: introduce kasan_mempool_unpoison_object
Date: Tue, 19 Dec 2023 23:28:49 +0100

Introduce and document a kasan_mempool_unpoison_object hook.

This hook serves as a replacement for the generic kasan_unpoison_range
that the mempool code relies on right now.  mempool will be updated to use
the new hook in one of the following patches.

For now, define the new hook to be identical to kasan_unpoison_range.  One
of the following patches will update it to add stack trace collection.

Link: https://lkml.kernel.org/r/dae25f0e18ed8fd50efe509c5b71a0592de5c18d.1703024586.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Lobakin <alobakin@pm.me>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |   31 +++++++++++++++++++++++++++++++
 mm/kasan/common.c     |    5 +++++
 2 files changed, 36 insertions(+)

--- a/include/linux/kasan.h~kasan-introduce-kasan_mempool_unpoison_object
+++ a/include/linux/kasan.h
@@ -228,6 +228,9 @@ bool __kasan_mempool_poison_object(void
  * bugs and reports them. The caller can use the return value of this function
  * to find out if the allocation is buggy.
  *
+ * Before the poisoned allocation can be reused, it must be unpoisoned via
+ * kasan_mempool_unpoison_object().
+ *
  * This function operates on all slab allocations including large kmalloc
  * allocations (the ones returned by kmalloc_large() or by kmalloc() with the
  * size > KMALLOC_MAX_SIZE).
@@ -241,6 +244,32 @@ static __always_inline bool kasan_mempoo
 	return true;
 }
 
+void __kasan_mempool_unpoison_object(void *ptr, size_t size, unsigned long ip);
+/**
+ * kasan_mempool_unpoison_object - Unpoison a mempool slab allocation.
+ * @ptr: Pointer to the slab allocation.
+ * @size: Size to be unpoisoned.
+ *
+ * This function is intended for kernel subsystems that cache slab allocations
+ * to reuse them instead of freeing them back to the slab allocator (e.g.
+ * mempool).
+ *
+ * This function unpoisons a slab allocation that was previously poisoned via
+ * kasan_mempool_poison_object() without initializing its memory. For the
+ * tag-based modes, this function does not assign a new tag to the allocation
+ * and instead restores the original tags based on the pointer value.
+ *
+ * This function operates on all slab allocations including large kmalloc
+ * allocations (the ones returned by kmalloc_large() or by kmalloc() with the
+ * size > KMALLOC_MAX_SIZE).
+ */
+static __always_inline void kasan_mempool_unpoison_object(void *ptr,
+							  size_t size)
+{
+	if (kasan_enabled())
+		__kasan_mempool_unpoison_object(ptr, size, _RET_IP_);
+}
+
 /*
  * Unlike kasan_check_read/write(), kasan_check_byte() is performed even for
  * the hardware tag-based mode that doesn't rely on compiler instrumentation.
@@ -301,6 +330,8 @@ static inline bool kasan_mempool_poison_
 {
 	return true;
 }
+static inline void kasan_mempool_unpoison_object(void *ptr, size_t size) {}
+
 static inline bool kasan_check_byte(const void *address)
 {
 	return true;
--- a/mm/kasan/common.c~kasan-introduce-kasan_mempool_unpoison_object
+++ a/mm/kasan/common.c
@@ -451,6 +451,11 @@ bool __kasan_mempool_poison_object(void
 	}
 }
 
+void __kasan_mempool_unpoison_object(void *ptr, size_t size, unsigned long ip)
+{
+	kasan_unpoison(ptr, size, false);
+}
+
 bool __kasan_check_byte(const void *address, unsigned long ip)
 {
 	if (!kasan_byte_accessible(address)) {
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

