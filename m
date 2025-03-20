Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16421E5B7E
	for <mm-commits@vger.kernel.org>; Thu, 20 Mar 2025 21:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742505145; cv=none; b=Y6O01AhJ2RsMc3C5snr07q8rIwdbPi/UvxgSsOjeGpkjSGfogXAKlnfcfFtyVgYzrHNrUuj+vtKSzxHTEj4PapOr/usk52z6yadjfv6kuugff47tiX5QyJv5rYpbicta+BmLNZPQGgo77sODv5X4WEY93dl26KzG0ZS7qBTRKjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742505145; c=relaxed/simple;
	bh=+zUSwHIleq3hOFRe9wrfvfBaKgCOObG+NScMgbQRSbo=;
	h=Date:To:From:Subject:Message-Id; b=sHGfqJpHavQNJyeleAGJHNq9Vg0FobGZg1nL3HWlTpCcRSFP+31Ulkj5OwvX5itOILgjqv2b/0RZUFuxnJRc4VUo+DEE22LndapFIfHTvaX4l5k6LrNcmBWMI1cjspH1uXic+JnSB6OPkvINg30zeBJwYq1bgViI79qGEjW2voo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ycb6pq6m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ycb6pq6m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A74BC4CEDD;
	Thu, 20 Mar 2025 21:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742505145;
	bh=+zUSwHIleq3hOFRe9wrfvfBaKgCOObG+NScMgbQRSbo=;
	h=Date:To:From:Subject:From;
	b=Ycb6pq6mIdATq3ux6trNaMgEv18frp1kPShyKbN0vEGdLYbcaL0n0W8R8rq8UBYoU
	 lyIQxV11BYLr+SZnCx3hjLt1mmf/6SqMd9ok0xIsDz8qGyGIsloKaOZ+gllXMu8rJr
	 LMSyUH8gEQmFYHYCHU+SvmqHJW8l3Q5TZhh9PFZc=
Date: Thu, 20 Mar 2025 14:12:24 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,harry.yoo@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kasan-use-slab_no_merge-flag-instead-of-an-empty-constructor.patch added to mm-unstable branch
Message-Id: <20250320211225.2A74BC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/kasan: use SLAB_NO_MERGE flag instead of an empty constructor
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kasan-use-slab_no_merge-flag-instead-of-an-empty-constructor.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kasan-use-slab_no_merge-flag-instead-of-an-empty-constructor.patch

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
From: Harry Yoo <harry.yoo@oracle.com>
Subject: mm/kasan: use SLAB_NO_MERGE flag instead of an empty constructor
Date: Tue, 18 Mar 2025 10:59:26 +0900

Use SLAB_NO_MERGE flag to prevent merging instead of providing an empty
constructor.  Using an empty constructor in this manner is an abuse of
slab interface.

The SLAB_NO_MERGE flag should be used with caution, but in this case, it
is acceptable as the cache is intended solely for debugging purposes.

No functional changes intended.

Link: https://lkml.kernel.org/r/20250318015926.1629748-1-harry.yoo@oracle.com
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Acked-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test_c.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/kasan/kasan_test_c.c~mm-kasan-use-slab_no_merge-flag-instead-of-an-empty-constructor
+++ a/mm/kasan/kasan_test_c.c
@@ -1073,14 +1073,11 @@ static void kmem_cache_rcu_uaf(struct ku
 	kmem_cache_destroy(cache);
 }
 
-static void empty_cache_ctor(void *object) { }
-
 static void kmem_cache_double_destroy(struct kunit *test)
 {
 	struct kmem_cache *cache;
 
-	/* Provide a constructor to prevent cache merging. */
-	cache = kmem_cache_create("test_cache", 200, 0, 0, empty_cache_ctor);
+	cache = kmem_cache_create("test_cache", 200, 0, SLAB_NO_MERGE, NULL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, cache);
 	kmem_cache_destroy(cache);
 	KUNIT_EXPECT_KASAN_FAIL(test, kmem_cache_destroy(cache));
_

Patches currently in -mm which might be from harry.yoo@oracle.com are

mm-kasan-use-slab_no_merge-flag-instead-of-an-empty-constructor.patch

