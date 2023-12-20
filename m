Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52286ECC
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 00:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l/90J7rF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6F7C433C7;
	Wed, 20 Dec 2023 00:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703030729;
	bh=T8p3HxTTFUQECwVw5ydPCQxG82JE8nTy9YerpKxb9ag=;
	h=Date:To:From:Subject:From;
	b=l/90J7rFdyI7UDX9cmVx8gx/6FrTZsaXHtVESoTWtca40IGBbpuCT8iVExkIwbFbJ
	 cUzT5Gq0lYmc5sTFSv2yXk2rABNE/iV1Klo2cs7/JzW8S85610U+wYLjwj8QGqQfbH
	 TfwcuI7qdReuv1JL/LEDnh3PI7nBlk5+XZNKVkMU=
Date: Tue, 19 Dec 2023 16:05:29 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,leitao@debian.org,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,alobakin@pm.me,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-document-kasan_mempool_poison_object.patch added to mm-unstable branch
Message-Id: <20231220000529.AC6F7C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: document kasan_mempool_poison_object
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-document-kasan_mempool_poison_object.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-document-kasan_mempool_poison_object.patch

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
Subject: kasan: document kasan_mempool_poison_object
Date: Tue, 19 Dec 2023 23:28:47 +0100

Add documentation comment for kasan_mempool_poison_object.

Link: https://lkml.kernel.org/r/af33ba8cabfa1ad731fe23a3f874bfc8d3b7fed4.1703024586.git.andreyknvl@google.com
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

 include/linux/kasan.h |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/include/linux/kasan.h~kasan-document-kasan_mempool_poison_object
+++ a/include/linux/kasan.h
@@ -213,6 +213,24 @@ static __always_inline void * __must_che
 }
 
 void __kasan_mempool_poison_object(void *ptr, unsigned long ip);
+/**
+ * kasan_mempool_poison_object - Check and poison a mempool slab allocation.
+ * @ptr: Pointer to the slab allocation.
+ *
+ * This function is intended for kernel subsystems that cache slab allocations
+ * to reuse them instead of freeing them back to the slab allocator (e.g.
+ * mempool).
+ *
+ * This function poisons a slab allocation without initializing its memory and
+ * without putting it into the quarantine (for the Generic mode).
+ *
+ * This function also performs checks to detect double-free and invalid-free
+ * bugs and reports them.
+ *
+ * This function operates on all slab allocations including large kmalloc
+ * allocations (the ones returned by kmalloc_large() or by kmalloc() with the
+ * size > KMALLOC_MAX_SIZE).
+ */
 static __always_inline void kasan_mempool_poison_object(void *ptr)
 {
 	if (kasan_enabled())
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

