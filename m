Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A9278E68
	for <mm-commits@vger.kernel.org>; Thu, 21 Dec 2023 21:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="crhRdoS/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45174C433C8;
	Thu, 21 Dec 2023 21:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703195524;
	bh=iSddT4mFkuMiZX12oxvVwuCGv188dsFS7Kw7xE9LVIQ=;
	h=Date:To:From:Subject:From;
	b=crhRdoS/HlOvU2IF6ooZcd/D7ArJi9O9M+dFBe5tCs5LJVzjqCP5m0SHaaaIJhY8J
	 pnJadHRoVs3kAv/H0LrpfSCWjU4lxQmjOWZ0SjV0lCd9QSLoagKG1c2egVVu8pHoaI
	 Lb9YWOlYVejaJJfX1Eq+1yzTTNdiFbU7feUYK7vI=
Date: Thu, 21 Dec 2023 13:52:02 -0800
To: mm-commits@vger.kernel.org,elver@google.com,andreyknvl@google.com,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-save-alloc-stack-traces-for-mempool-fix.patch added to mm-unstable branch
Message-Id: <20231221215204.45174C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: Mark unpoison_slab_object() as static
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-save-alloc-stack-traces-for-mempool-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-save-alloc-stack-traces-for-mempool-fix.patch

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

buffer-fix-grow_buffers-for-block-size-page_size-fix.patch
kasan-save-alloc-stack-traces-for-mempool-fix.patch

