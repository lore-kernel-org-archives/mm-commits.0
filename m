Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F41312FB2E;
	Thu, 31 Oct 2024 03:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730344511; cv=none; b=ux/GDh0Z0gHM9JBbSWAzkP1CvF58fUDrbKUbEu5Yms+JRI7TIyVsTjij5odZCa5VhNVg5BwfU2UHQehx6AgznGx+KGzGvTVFHdecKZv1FI8LUrwlhdkoJ9BlUh55yJwkridv0koxmk4DlUU5ZLrEYss3BmxJmfffbdUKg6cFiVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730344511; c=relaxed/simple;
	bh=BfPkTb1ggRhMbSlrpTWer+oT+5nEUoUOepo7xUMc+0M=;
	h=Date:To:From:Subject:Message-Id; b=VDxAt+IZ5FqyvoVz1HjQXSA/rr9GFJXiUCO4jTW43l+Kby7svfKEiIc4JjQFyXb96M3cWWl77FnsXmRH8OEKPZa+LPcg7yU4Va9IhYVH8qMrpQ27sCLSYmsQm3nLW8ECIb4pn6+rMqdjfOHWd94b1h6NypQm3SnDOK/ugAbiXuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r+9jUtny; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r+9jUtny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02166C4CECE;
	Thu, 31 Oct 2024 03:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730344511;
	bh=BfPkTb1ggRhMbSlrpTWer+oT+5nEUoUOepo7xUMc+0M=;
	h=Date:To:From:Subject:From;
	b=r+9jUtnyFklyBsqAa20aaWQkhaWilzxvf53Be7m71It9CB4CPNV3P+/cSGpI0j/cr
	 NpnN8QkNXCAhR9HIyoAOaDcRj0H5C1Ue/5Yw1HoVFsVNeOslxBtXlxzLUpIpe6zdgF
	 oozW47jq62lndlvJv5uLOIdJgtSySdvbgvw4sYGs=
Date: Wed, 30 Oct 2024 20:15:10 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,snovitoll@gmail.com,samuel.holland@sifive.com,ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kasan-remove-vmalloc_percpu-test.patch removed from -mm tree
Message-Id: <20241031031511.02166C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: remove vmalloc_percpu test
has been removed from the -mm tree.  Its filename was
     kasan-remove-vmalloc_percpu-test.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


