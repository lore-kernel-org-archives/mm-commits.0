Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CBE13AC2
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vpwQjYzS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ACE6C433C7;
	Fri, 29 Dec 2023 20:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880041;
	bh=2+4xM1njNvZkTc+dp1Oz9aZESnc30/W8dNbXLK5Dd2Q=;
	h=Date:To:From:Subject:From;
	b=vpwQjYzSy6NzLcE0woehqY6YxeIF50THVWUj3JP7rsWM4KLskyN3e+6KkholhBXRo
	 jVHCcs8P7AYJu5s3ENkmigHGfVlcsAegJcTrw4yNF2WhyOMC0p0GR6A9CDWCeFFi6c
	 SKMrWusYlkQyYrpbnVTMYTp0DTLxSIS7tZG7NJsw=
Date: Fri, 29 Dec 2023 12:00:40 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,leitao@debian.org,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,alobakin@pm.me,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-clean-up-__kasan_mempool_poison_object.patch removed from -mm tree
Message-Id: <20231229200041.4ACE6C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: clean up __kasan_mempool_poison_object
has been removed from the -mm tree.  Its filename was
     kasan-clean-up-__kasan_mempool_poison_object.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

kasan-stop-leaking-stack-trace-handles.patch

