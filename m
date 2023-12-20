Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88EB5ECC
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 00:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qumNRYvf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 544E5C433C8;
	Wed, 20 Dec 2023 00:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703030765;
	bh=+hhZikrlcB3T63LMMa6k1WEL/XWyeD0V0XZCGywR8GA=;
	h=Date:To:From:Subject:From;
	b=qumNRYvfbjXw+LZyH4CHs+upxrtehUDr620WtHAII/FdQsZhVSKkiIYpnb8eo++Ya
	 kLEAcxBthNvknunFjPqFNokvzffvbd2KaGZkpgqCJ98zjFXmeYeK5IFYzsyKfWdlHA
	 Hpmwr2ij2b8PAs8GocV7nDXuElK7FBCrgULD9ryo=
Date: Tue, 19 Dec 2023 16:06:04 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,leitao@debian.org,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,alobakin@pm.me,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + io_uring-use-mempool-kasan-hook.patch added to mm-unstable branch
Message-Id: <20231220000605.544E5C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: io_uring: use mempool KASAN hook
has been added to the -mm mm-unstable branch.  Its filename is
     io_uring-use-mempool-kasan-hook.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/io_uring-use-mempool-kasan-hook.patch

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
Subject: io_uring: use mempool KASAN hook
Date: Tue, 19 Dec 2023 23:29:05 +0100

Use the proper kasan_mempool_unpoison_object hook for unpoisoning cached
objects.

A future change might also update io_uring to check the return value of
kasan_mempool_poison_object to prevent double-free and invalid-free bugs. 
This proves to be non-trivial with the current way io_uring caches
objects, so this is left out-of-scope of this series.

Link: https://lkml.kernel.org/r/eca18d6cbf676ed784f1a1f209c386808a8087c5.1703024586.git.andreyknvl@google.com
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

 io_uring/alloc_cache.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/alloc_cache.h~io_uring-use-mempool-kasan-hook
+++ a/io_uring/alloc_cache.h
@@ -33,7 +33,7 @@ static inline struct io_cache_entry *io_
 		struct io_cache_entry *entry;
 
 		entry = container_of(cache->list.next, struct io_cache_entry, node);
-		kasan_unpoison_range(entry, cache->elem_size);
+		kasan_mempool_unpoison_object(entry, cache->elem_size);
 		cache->list.next = cache->list.next->next;
 		cache->nr_cached--;
 		return entry;
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

