Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748D9629
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 00:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t6fF+ZS7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD49EC433C8;
	Wed, 20 Dec 2023 00:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703030740;
	bh=Clr62LSwA85RZculRYavv97nCowb8ufnz96ySHOS8N8=;
	h=Date:To:From:Subject:From;
	b=t6fF+ZS7mQWm91Y5Q0lC+pOsQp67QkEVwSwt8uC8bjOsAzNldOStgZVFtQJ2/W45T
	 c01FXWcu4K/tbRRH8wirKI1bVnOOXeZ3bIk4YLbdKZAy12vGlMLKxcm9idDaxQ25xQ
	 rjSpxYYMrFH1WlC+hj0I0tUXfszrsav2s0Hgd8Os=
Date: Tue, 19 Dec 2023 16:05:39 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,leitao@debian.org,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,alobakin@pm.me,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-clean-up-__kasan_mempool_poison_object.patch added to mm-unstable branch
Message-Id: <20231220000539.DD49EC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: clean up __kasan_mempool_poison_object
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-clean-up-__kasan_mempool_poison_object.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-clean-up-__kasan_mempool_poison_object.patch

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
Subject: kasan: clean up __kasan_mempool_poison_object
Date: Tue, 19 Dec 2023 23:28:52 +0100

Reorganize the code and reword the comment in
__kasan_mempool_poison_object to improve the code readability.

Link: https://lkml.kernel.org/r/4f6fc8840512286c1a96e16e86901082c671677d.1703024586.git.andreyknvl@google.com
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

 mm/kasan/common.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

--- a/mm/kasan/common.c~kasan-clean-up-__kasan_mempool_poison_object
+++ a/mm/kasan/common.c
@@ -457,27 +457,22 @@ void __kasan_mempool_unpoison_pages(stru
 
 bool __kasan_mempool_poison_object(void *ptr, unsigned long ip)
 {
-	struct folio *folio;
-
-	folio = virt_to_folio(ptr);
+	struct folio *folio = virt_to_folio(ptr);
+	struct slab *slab;
 
 	/*
-	 * Even though this function is only called for kmem_cache_alloc and
-	 * kmalloc backed mempool allocations, those allocations can still be
-	 * !PageSlab() when the size provided to kmalloc is larger than
-	 * KMALLOC_MAX_SIZE, and kmalloc falls back onto page_alloc.
+	 * This function can be called for large kmalloc allocation that get
+	 * their memory from page_alloc. Thus, the folio might not be a slab.
 	 */
 	if (unlikely(!folio_test_slab(folio))) {
 		if (check_page_allocation(ptr, ip))
 			return false;
 		kasan_poison(ptr, folio_size(folio), KASAN_PAGE_FREE, false);
 		return true;
-	} else {
-		struct slab *slab = folio_slab(folio);
-
-		return !____kasan_slab_free(slab->slab_cache, ptr, ip,
-						false, false);
 	}
+
+	slab = folio_slab(folio);
+	return !____kasan_slab_free(slab->slab_cache, ptr, ip, false, false);
 }
 
 void __kasan_mempool_unpoison_object(void *ptr, size_t size, unsigned long ip)
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

