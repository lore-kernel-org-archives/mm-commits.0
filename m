Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABD71BDDF;
	Thu, 24 Oct 2024 01:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729734611; cv=none; b=LIm9LBP+oK0P+yrnD6ZORBDiZFnIE4HPRWE6VV/y9JhzmgLKQX7gMqptDXcStCUzc6WZebJm/hN0FBijvh3h3nDNUlk7Q9SmiVx3BfWbHLDGi37lJhWtDfj2o/VVJ+GydtGxmt2VvR7beblGSLIhAJQy4Ux31CtdYsved+7VMj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729734611; c=relaxed/simple;
	bh=GWvQUdL+/PBw7dy05YLwa5cd5EhnJ0ucWLj2CT4WFUM=;
	h=Date:To:From:Subject:Message-Id; b=awe8ClGPIgMLWesqfcPhLMx6hoB5IOaljvzurlH+xfwW+ByXFaHkI4C4KMf/8udiRHpaupsAPU/wQQ0inBvJnrLjGOcquPTR4SkKAJszRjdwD8/WWkxPxB9+8J8AYaBQ7j1KYvEFpNmCqd0Cjccj8l8M3gynuTbc8CWEueKkoZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sz+1BwoO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sz+1BwoO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB0AC4CEC6;
	Thu, 24 Oct 2024 01:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729734610;
	bh=GWvQUdL+/PBw7dy05YLwa5cd5EhnJ0ucWLj2CT4WFUM=;
	h=Date:To:From:Subject:From;
	b=sz+1BwoOtaZKEqmTXofx6ezowoQFWrXZiSk7+YW3ei5ViudXdYNTvZ2S5fVvvO0ub
	 6Vo6LMTN2/vJ1i+Xgbr0vYgMuPUXnCpezDZA3s1YYq+wnS8mLPhsooKBenDvRGuE/h
	 vFQbdxXgEZnFA7FRCsxt5L0kLmFyg2DjVUx8+UJI=
Date: Wed, 23 Oct 2024 18:50:10 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,snovitoll@gmail.com,samuel.holland@sifive.com,ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-remove-vmalloc_percpu-test.patch added to mm-hotfixes-unstable branch
Message-Id: <20241024015010.BAB0AC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: remove vmalloc_percpu test
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kasan-remove-vmalloc_percpu-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-remove-vmalloc_percpu-test.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Andrey Konovalov <andreyknvl@gmail.com>
Subject: kasan: remove vmalloc_percpu test
Date: Tue, 22 Oct 2024 18:07:06 +0200

Commit 1a2473f0cbc0 ("kasan: improve vmalloc tests") added the
vmalloc_percpu KASAN test with the assumption that __alloc_percpu always
uses vmalloc internally, which is tagged by KASAN.

However, __alloc_percpu might allocate memory from the first per-CPU
chunk, which is not allocated via vmalloc().  As a result, the test might
fail.

Remove the test until proper KASAN annotation for the per-CPU allocated
are added; tracked in https://bugzilla.kernel.org/show_bug.cgi?id=215019.

Link: https://lkml.kernel.org/r/20241022160706.38943-1-andrey.konovalov@linux.dev
Fixes: 1a2473f0cbc0 ("kasan: improve vmalloc tests")
Signed-off-by: Andrey Konovalov <andreyknvl@gmail.com>
Reported-by: Samuel Holland <samuel.holland@sifive.com>
Link: https://lore.kernel.org/all/4a245fff-cc46-44d1-a5f9-fd2f1c3764ae@sifive.com/
Reported-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Link: https://lore.kernel.org/all/CACzwLxiWzNqPBp4C1VkaXZ2wDwvY3yZeetCi1TLGFipKW77drA@mail.gmail.com/
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test_c.c |   27 ---------------------------
 1 file changed, 27 deletions(-)

--- a/mm/kasan/kasan_test_c.c~kasan-remove-vmalloc_percpu-test
+++ a/mm/kasan/kasan_test_c.c
@@ -1810,32 +1810,6 @@ static void vm_map_ram_tags(struct kunit
 	free_pages((unsigned long)p_ptr, 1);
 }
 
-static void vmalloc_percpu(struct kunit *test)
-{
-	char __percpu *ptr;
-	int cpu;
-
-	/*
-	 * This test is specifically crafted for the software tag-based mode,
-	 * the only tag-based mode that poisons percpu mappings.
-	 */
-	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_SW_TAGS);
-
-	ptr = __alloc_percpu(PAGE_SIZE, PAGE_SIZE);
-
-	for_each_possible_cpu(cpu) {
-		char *c_ptr = per_cpu_ptr(ptr, cpu);
-
-		KUNIT_EXPECT_GE(test, (u8)get_tag(c_ptr), (u8)KASAN_TAG_MIN);
-		KUNIT_EXPECT_LT(test, (u8)get_tag(c_ptr), (u8)KASAN_TAG_KERNEL);
-
-		/* Make sure that in-bounds accesses don't crash the kernel. */
-		*c_ptr = 0;
-	}
-
-	free_percpu(ptr);
-}
-
 /*
  * Check that the assigned pointer tag falls within the [KASAN_TAG_MIN,
  * KASAN_TAG_KERNEL) range (note: excluding the match-all tag) for tag-based
@@ -2023,7 +1997,6 @@ static struct kunit_case kasan_kunit_tes
 	KUNIT_CASE(vmalloc_oob),
 	KUNIT_CASE(vmap_tags),
 	KUNIT_CASE(vm_map_ram_tags),
-	KUNIT_CASE(vmalloc_percpu),
 	KUNIT_CASE(match_all_not_assigned),
 	KUNIT_CASE(match_all_ptr_tag),
 	KUNIT_CASE(match_all_mem_tag),
_

Patches currently in -mm which might be from andreyknvl@gmail.com are

kasan-remove-vmalloc_percpu-test.patch

