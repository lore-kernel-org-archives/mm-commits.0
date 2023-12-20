Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DBC210FA
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 00:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dfzEUTp0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95356C433C7;
	Wed, 20 Dec 2023 00:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703030763;
	bh=DpupAflekHij5sy9SrqUOL0J7845nO+9tQ018XFYkuQ=;
	h=Date:To:From:Subject:From;
	b=dfzEUTp0myo1YVTr2LzNlFZ6+CpFvhAnj+TUopj5SfPHU267BKFAl4B7ehGKDnhQP
	 jVfcOLeFnNmkYQ1ZfnlfUeyUuyz3a3d14CHVjCRPJIGdpLwrLqNczkNsv95TkSHU92
	 v2l2bY1j0VzidqbW0rpQ8Pnp/xgeSclbnQ5oyNho=
Date: Tue, 19 Dec 2023 16:06:03 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,leitao@debian.org,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,alobakin@pm.me,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + skbuff-use-mempool-kasan-hooks.patch added to mm-unstable branch
Message-Id: <20231220000603.95356C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: skbuff: use mempool KASAN hooks
has been added to the -mm mm-unstable branch.  Its filename is
     skbuff-use-mempool-kasan-hooks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/skbuff-use-mempool-kasan-hooks.patch

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
Subject: skbuff: use mempool KASAN hooks
Date: Tue, 19 Dec 2023 23:29:04 +0100

Instead of using slab-internal KASAN hooks for poisoning and unpoisoning
cached objects, use the proper mempool KASAN hooks.

Also check the return value of kasan_mempool_poison_object to prevent
double-free and invali-free bugs.

Link: https://lkml.kernel.org/r/a3482c41395c69baa80eb59dbb06beef213d2a14.1703024586.git.andreyknvl@google.com
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

 net/core/skbuff.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/net/core/skbuff.c~skbuff-use-mempool-kasan-hooks
+++ a/net/core/skbuff.c
@@ -337,7 +337,7 @@ static struct sk_buff *napi_skb_cache_ge
 	}
 
 	skb = nc->skb_cache[--nc->skb_count];
-	kasan_unpoison_new_object(skbuff_cache, skb);
+	kasan_mempool_unpoison_object(skb, kmem_cache_size(skbuff_cache));
 
 	return skb;
 }
@@ -1309,13 +1309,15 @@ static void napi_skb_cache_put(struct sk
 	struct napi_alloc_cache *nc = this_cpu_ptr(&napi_alloc_cache);
 	u32 i;
 
-	kasan_poison_new_object(skbuff_cache, skb);
+	if (!kasan_mempool_poison_object(skb))
+		return;
+
 	nc->skb_cache[nc->skb_count++] = skb;
 
 	if (unlikely(nc->skb_count == NAPI_SKB_CACHE_SIZE)) {
 		for (i = NAPI_SKB_CACHE_HALF; i < NAPI_SKB_CACHE_SIZE; i++)
-			kasan_unpoison_new_object(skbuff_cache,
-						  nc->skb_cache[i]);
+			kasan_mempool_unpoison_object(nc->skb_cache[i],
+						kmem_cache_size(skbuff_cache));
 
 		kmem_cache_free_bulk(skbuff_cache, NAPI_SKB_CACHE_HALF,
 				     nc->skb_cache + NAPI_SKB_CACHE_HALF);
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

