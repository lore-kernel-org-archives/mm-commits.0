Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B06F482C3
	for <mm-commits@vger.kernel.org>; Wed, 27 Dec 2023 21:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tbA/VgSm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95180C433C7;
	Wed, 27 Dec 2023 21:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703712203;
	bh=tOb8IStrOR87f4i/LI9tcQs3jU88YCcgVXK3oahCTVI=;
	h=Date:To:From:Subject:From;
	b=tbA/VgSm5aqxDabdTggp7tnG83/bQgCeQvnexsCUS4XNEK2Lf6GcfZoBc3pRNwo3s
	 jWoxdD5qRFeTaWnzoaoX4raGXr7becDDbtiGi/5Tpvasc0cOA5EzAjFKJmnIdt3qKF
	 p5FqKr0c6DIgHHEPFzVsaRi4eT2JaEEbEAeXxhBQ=
Date: Wed, 27 Dec 2023 13:23:22 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,lkp@intel.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-stop-leaking-stack-trace-handles-fix.patch added to mm-unstable branch
Message-Id: <20231227212323.95180C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan-stop-leaking-stack-trace-handles-fix
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-stop-leaking-stack-trace-handles-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-stop-leaking-stack-trace-handles-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kasan-stop-leaking-stack-trace-handles-fix
Date: Wed Dec 27 01:21:02 PM PST 2023

make release_free_meta() and release_alloc_meta)( static

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202312280213.6j147JJb-lkp@intel.Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/generic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/kasan/generic.c~kasan-stop-leaking-stack-trace-handles-fix
+++ a/mm/kasan/generic.c
@@ -503,7 +503,7 @@ void kasan_init_object_meta(struct kmem_
 	 */
 }
 
-void release_alloc_meta(struct kasan_alloc_meta *meta)
+static void release_alloc_meta(struct kasan_alloc_meta *meta)
 {
 	/* Evict the stack traces from stack depot. */
 	stack_depot_put(meta->alloc_track.stack);
@@ -514,7 +514,7 @@ void release_alloc_meta(struct kasan_all
 	__memset(meta, 0, sizeof(*meta));
 }
 
-void release_free_meta(const void *object, struct kasan_free_meta *meta)
+static void release_free_meta(const void *object, struct kasan_free_meta *meta)
 {
 	/* Check if free meta is valid. */
 	if (*(u8 *)kasan_mem_to_shadow(object) != KASAN_SLAB_FREE_META)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maintainers-remove-hugetlb-maintainer-mike-kravetz-fix.patch
kasan-stop-leaking-stack-trace-handles-fix.patch

