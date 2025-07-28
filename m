Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAAB622539D
	for <mm-commits@vger.kernel.org>; Mon, 28 Jul 2025 21:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753736407; cv=none; b=HXbvnQiLSXCZe2914Dw4cuHKW9Aw1AVtS9Cgu/W92zL89Cmv26eSUiLCWYpveOiCT89pxHHhw3B/YkfRilspcvqRDB3oLdCyGefYb7DpYy11/82avdFJ+XoME/WYIoTbXv3wfzwL2qWMbtomRlgX1y0ESxl7rNFZgiZwhHBynG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753736407; c=relaxed/simple;
	bh=x5XZ8qObQfvuTda7xucQ4RJtaZsjJI1RAHl3Dw3yGQU=;
	h=Date:To:From:Subject:Message-Id; b=HHjq+6HK/rw3b6H8RrrdY0t9Ep0AD1iuqi/R/SC/h1SKWIUYIbppj3p11JwfoVxMEA69qqRmoBUsjrUtbanVlQ1ufv2lE4jK0L3f2O4w+pu8GGGnmlpB+HMDJ9bcm9ZbKoSoMxvymVIZd/QEIMYwHuIiVKQNT21cwDTLI8IcPJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BzHR4O46; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BzHR4O46"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CFE4C4CEE7;
	Mon, 28 Jul 2025 21:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753736406;
	bh=x5XZ8qObQfvuTda7xucQ4RJtaZsjJI1RAHl3Dw3yGQU=;
	h=Date:To:From:Subject:From;
	b=BzHR4O46k4uqcoy9UNDs1ZQYWni1v4GUzhgkeS5vfW1t+vc20mGznSKcirDR+IfTN
	 VQPP4lzSbYxF6ghnd1Mlz5oSBFNt/5feeC2RRKA3p4v99txeKm9ZaIm6uAQqaI4kbA
	 8GXpagTfofstOUv2Sja3hw7B9CbuG2UAdd+KLsnw=
Date: Mon, 28 Jul 2025 14:00:05 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,vbabka@suse.cz,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-add-test-for-slab_typesafe_by_rcu-quarantine-skipping.patch added to mm-new branch
Message-Id: <20250728210006.3CFE4C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: add test for SLAB_TYPESAFE_BY_RCU quarantine skipping
has been added to the -mm mm-new branch.  Its filename is
     kasan-add-test-for-slab_typesafe_by_rcu-quarantine-skipping.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-add-test-for-slab_typesafe_by_rcu-quarantine-skipping.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Jann Horn <jannh@google.com>
Subject: kasan: add test for SLAB_TYPESAFE_BY_RCU quarantine skipping
Date: Mon, 28 Jul 2025 17:25:07 +0200

Verify that KASAN does not quarantine objects in SLAB_TYPESAFE_BY_RCU
slabs if CONFIG_SLUB_RCU_DEBUG is off.

Link: https://lkml.kernel.org/r/20250728-kasan-tsbrcu-noquarantine-test-v1-1-fa24d9ab7f41@google.com
Signed-off-by: Jann Horn <jannh@google.com>
Suggested-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test_c.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

--- a/mm/kasan/kasan_test_c.c~kasan-add-test-for-slab_typesafe_by_rcu-quarantine-skipping
+++ a/mm/kasan/kasan_test_c.c
@@ -1073,6 +1073,41 @@ static void kmem_cache_rcu_uaf(struct ku
 	kmem_cache_destroy(cache);
 }
 
+/*
+ * Check that SLAB_TYPESAFE_BY_RCU objects are immediately reused when
+ * CONFIG_SLUB_RCU_DEBUG is off, and stay at the same address.
+ */
+static void kmem_cache_rcu_reuse(struct kunit *test)
+{
+	char *p, *p2;
+	struct kmem_cache *cache;
+
+	KASAN_TEST_NEEDS_CONFIG_OFF(test, CONFIG_SLUB_RCU_DEBUG);
+
+	cache = kmem_cache_create("test_cache", 16, 0, SLAB_TYPESAFE_BY_RCU,
+				  NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, cache);
+
+	p = kmem_cache_alloc(cache, GFP_KERNEL);
+	if (!p) {
+		kunit_err(test, "Allocation failed: %s\n", __func__);
+		kmem_cache_destroy(cache);
+		return;
+	}
+
+	kmem_cache_free(cache, p);
+	p2 = kmem_cache_alloc(cache, GFP_KERNEL);
+	if (!p2) {
+		kunit_err(test, "Allocation failed: %s\n", __func__);
+		kmem_cache_destroy(cache);
+		return;
+	}
+	KUNIT_ASSERT_PTR_EQ(test, p, p2);
+
+	kmem_cache_free(cache, p2);
+	kmem_cache_destroy(cache);
+}
+
 static void kmem_cache_double_destroy(struct kunit *test)
 {
 	struct kmem_cache *cache;
@@ -2104,6 +2139,7 @@ static struct kunit_case kasan_kunit_tes
 	KUNIT_CASE(kmem_cache_double_free),
 	KUNIT_CASE(kmem_cache_invalid_free),
 	KUNIT_CASE(kmem_cache_rcu_uaf),
+	KUNIT_CASE(kmem_cache_rcu_reuse),
 	KUNIT_CASE(kmem_cache_double_destroy),
 	KUNIT_CASE(kmem_cache_accounted),
 	KUNIT_CASE(kmem_cache_bulk),
_

Patches currently in -mm which might be from jannh@google.com are

kasan-test-fix-protection-against-compiler-elision.patch
kasan-skip-quarantine-if-object-is-still-accessible-under-rcu.patch
mm-rmap-add-anon_vma-lifetime-debug-check.patch
kasan-add-test-for-slab_typesafe_by_rcu-quarantine-skipping.patch

