Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84616EBE
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 00:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KpIajgw5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9BC6C433C7;
	Wed, 20 Dec 2023 00:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703030737;
	bh=LlrQImRW5eC+4XXebccQ0bTqXxfHN/Jf6WWZnjdmn8U=;
	h=Date:To:From:Subject:From;
	b=KpIajgw59tffkksklVXsZEeG59s+uAW2T6p7pRL6WFQ/nuumkFrkkS8Lo59xuR47u
	 RdhZSrqO0M8sYp5G4p2mQlT6gpc8vOJ5/w82KIN1x12vJGLvNrnCD4UrB8tqscL5YI
	 oUHf682y402D9xMhF2awvSoqew0mvYuKUYF7P0+4=
Date: Tue, 19 Dec 2023 16:05:37 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,leitao@debian.org,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,alobakin@pm.me,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-introduce-kasan_mempool_unpoison_pages.patch added to mm-unstable branch
Message-Id: <20231220000537.C9BC6C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: introduce kasan_mempool_unpoison_pages
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-introduce-kasan_mempool_unpoison_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-introduce-kasan_mempool_unpoison_pages.patch

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
Subject: kasan: introduce kasan_mempool_unpoison_pages
Date: Tue, 19 Dec 2023 23:28:51 +0100

Introduce and document a new kasan_mempool_unpoison_pages hook to be used
by the mempool code instead of kasan_unpoison_pages.

This hook is not functionally different from kasan_unpoison_pages, but
using it improves the mempool code readability.

Link: https://lkml.kernel.org/r/239bd9af6176f2cc59f5c25893eb36143184daff.1703024586.git.andreyknvl@google.com
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

 include/linux/kasan.h |   25 +++++++++++++++++++++++++
 mm/kasan/common.c     |    6 ++++++
 2 files changed, 31 insertions(+)

--- a/include/linux/kasan.h~kasan-introduce-kasan_mempool_unpoison_pages
+++ a/include/linux/kasan.h
@@ -225,6 +225,9 @@ bool __kasan_mempool_poison_pages(struct
  * This function is similar to kasan_mempool_poison_object() but operates on
  * page allocations.
  *
+ * Before the poisoned allocation can be reused, it must be unpoisoned via
+ * kasan_mempool_unpoison_pages().
+ *
  * Return: true if the allocation can be safely reused; false otherwise.
  */
 static __always_inline bool kasan_mempool_poison_pages(struct page *page,
@@ -235,6 +238,27 @@ static __always_inline bool kasan_mempoo
 	return true;
 }
 
+void __kasan_mempool_unpoison_pages(struct page *page, unsigned int order,
+				    unsigned long ip);
+/**
+ * kasan_mempool_unpoison_pages - Unpoison a mempool page allocation.
+ * @page: Pointer to the page allocation.
+ * @order: Order of the allocation.
+ *
+ * This function is intended for kernel subsystems that cache page allocations
+ * to reuse them instead of freeing them back to page_alloc (e.g. mempool).
+ *
+ * This function unpoisons a page allocation that was previously poisoned by
+ * kasan_mempool_poison_pages() without zeroing the allocation's memory. For
+ * the tag-based modes, this function assigns a new tag to the allocation.
+ */
+static __always_inline void kasan_mempool_unpoison_pages(struct page *page,
+							 unsigned int order)
+{
+	if (kasan_enabled())
+		__kasan_mempool_unpoison_pages(page, order, _RET_IP_);
+}
+
 bool __kasan_mempool_poison_object(void *ptr, unsigned long ip);
 /**
  * kasan_mempool_poison_object - Check and poison a mempool slab allocation.
@@ -353,6 +377,7 @@ static inline bool kasan_mempool_poison_
 {
 	return true;
 }
+static inline void kasan_mempool_unpoison_pages(struct page *page, unsigned int order) {}
 static inline bool kasan_mempool_poison_object(void *ptr)
 {
 	return true;
--- a/mm/kasan/common.c~kasan-introduce-kasan_mempool_unpoison_pages
+++ a/mm/kasan/common.c
@@ -449,6 +449,12 @@ bool __kasan_mempool_poison_pages(struct
 	return true;
 }
 
+void __kasan_mempool_unpoison_pages(struct page *page, unsigned int order,
+				    unsigned long ip)
+{
+	__kasan_unpoison_pages(page, order, false);
+}
+
 bool __kasan_mempool_poison_object(void *ptr, unsigned long ip)
 {
 	struct folio *folio;
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

