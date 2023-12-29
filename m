Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E968812E72
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 19:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wa+zaDc9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74680C433C7;
	Fri, 29 Dec 2023 19:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703879433;
	bh=9ZshGMPpCAsA9VaduZlyWVMpaDOKguwkQ3JQJvP7v0E=;
	h=Date:To:From:Subject:From;
	b=wa+zaDc9aNyQteT7H6A5R3SbPI4FzmhnQM9NZuGqwpoCMOwVNv+bOgGRgCp2dCb1y
	 U0QbWbZxy5ZMwWhYhWJ7oimZZeuJebjocGlaRJTSckgl6/9PAM2IbdiQtiQy+QJRfj
	 KE5+YCJTYTRwYAROM+PET3c6xm4YLZQGRTK10e1A=
Date: Fri, 29 Dec 2023 11:50:32 -0800
To: mm-commits@vger.kernel.org,elver@google.com,andreyknvl@google.com,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kasan-save-alloc-stack-traces-for-mempool-fix.patch removed from -mm tree
Message-Id: <20231229195033.74680C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: Mark unpoison_slab_object() as static
has been removed from the -mm tree.  Its filename was
     kasan-save-alloc-stack-traces-for-mempool-fix.patch

This patch was dropped because it was folded into kasan-save-alloc-stack-traces-for-mempool.patch

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: kasan: Mark unpoison_slab_object() as static
Date: Thu, 21 Dec 2023 19:00:42 +0100

With -Wmissing-prototypes enabled, there is a warning that
unpoison_slab_object() has no prototype, breaking the build with
CONFIG_WERROR=y:

  mm/kasan/common.c:271:6: error: no previous prototype for 'unpoison_slab_object' [-Werror=missing-prototypes]
    271 | void unpoison_slab_object(struct kmem_cache *cache, void *object, gfp_t flags,
        |      ^~~~~~~~~~~~~~~~~~~~
  cc1: all warnings being treated as errors

Mark the function as static, as it is not used outside of this
translation unit, clearing up the warning.

Link: https://lkml.kernel.org/r/20231221180042.104694-1-andrey.konovalov@linux.dev
Fixes: 3f38c3c5bc40 ("kasan: save alloc stack traces for mempool")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/kasan/common.c~kasan-save-alloc-stack-traces-for-mempool-fix
+++ a/mm/kasan/common.c
@@ -277,8 +277,8 @@ void __kasan_kfree_large(void *ptr, unsi
 	/* The object will be poisoned by kasan_poison_pages(). */
 }
 
-void unpoison_slab_object(struct kmem_cache *cache, void *object, gfp_t flags,
-			  bool init)
+static inline void unpoison_slab_object(struct kmem_cache *cache, void *object,
+					gfp_t flags, bool init)
 {
 	/*
 	 * Unpoison the whole object. For kmalloc() allocations,
_

Patches currently in -mm which might be from nathan@kernel.org are

kasan-save-alloc-stack-traces-for-mempool.patch

