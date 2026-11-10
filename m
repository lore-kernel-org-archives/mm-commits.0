Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794293104;
	b=PyuVYNJH994HPERTRgePbSmUWGxuVfQ6DGQOw9v+XZ+ah190ylqc4YaMIQjPT2TRY4w8
	 cTOhU5xStbVnvR0pRFWIq0cbyBEmqZT242xnUiAZFJeYQg02sUCVqtQsxjkg2Zrk4ypnF
	 YQTmt7pJVHsVAKEWKUKzyfD45PmWbn9B6qUXV4z1HEEVS2d5eUrpko+2dE4zQ41NEbhyE
	 kAcXgUJtiIAGR7PkQKokOubBIBFjB3zmWekbQXDjadzz/7skgkoI7MijfgO6cP5K/5tKp
	 0AazuGsQUvCdcclY/FWA3TN9AgrXePWeRqondYd3gl9/TSWRJk7Q69mdczOs2wsd80w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794293104;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=403xIM+g6Pawp0jRTik3Wfra3U/e5ShvSLB3nL09Cqc=;
	b=108OYiH9ZpehnCHnXFE6+klHPmgo1YE+fV7diSR61K3iTd+XDpcXzjCqZ31mp57ZDBDh
	 G/iOLbRvioa3ncUFiXvCBEd+8sTLiSSk8KcrzjHi+3ps+TW17fOeudCWRC+cQSDMF+Nm3
	 NJL/MP/dLa8uE710XrT0fqfaKF0iI/mnVVZBDuZ0IOB0hn4TD7PoaChSxgQWONt0dCnZ+
	 FsDgJEmKz9sv91pKW4jWlptlDIryQJhqdG0401c3wxkhE7dB+UQQNNOqDk2lktchxjJ/J
	 5c6DXTv6zJ2VVZ9xnE7aw1MBgcrOKlzCMiNyyJ7BB5SfryvnvRN+2k4oVrjlN2RZqLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=uxEUC+Xj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C24606BD69;
	Tue, 10 Nov 2026 06:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=uxEUC+Xj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F7981F0089F;
	Tue, 10 Nov 2026 06:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794293104;
	bh=403xIM+g6Pawp0jRTik3Wfra3U/e5ShvSLB3nL09Cqc=;
	h=Date:To:From:Subject;
	b=uxEUC+XjkXHEV6/dUEz/+e57BKYFLNsb0iLOwkS68UTeIhHbjwYPhYhwOO+wX9HK9
	 BF0IkxIiNShA3RlQtn4Bf+E+mYMs+cHxTxi7AJ5zdjo0L4FG8hutR///XX2OZXn8qS
	 Rbah1i0CcNfhtqBFYL0QQ2mzz9Zh2OGkbARsxpkY=
Date: Mon, 09 Nov 2026 22:45:03 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,vbabka@kernel.org,
	stable@vger.kernel.org,ryabinin.a.a@gmail.com,roman.gushchin@linux.dev,
	rientjes@google.com,harry@kernel.org,hao.li@linux.dev,glider@google.com,
	dvyukov@google.com,cl@gentwo.org,andreyknvl@gmail.com,kuniyu@google.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-kasan-kunit-add-double-free-tests-involving-kfree_rcu_sheaf.patch removed from -mm tree
Message-Id: <20261110064504.1F7981F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/kasan/kunit: add double-free tests involving kfree_rcu_sheaf()
has been removed from the -mm tree.  Its filename was
     mm-kasan-kunit-add-double-free-tests-involving-kfree_rcu_sheaf.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuniyuki Iwashima <kuniyu@google.com>
Subject: mm/kasan/kunit: add double-free tests involving kfree_rcu_sheaf()
Date: Wed, 28 Oct 2026 19:39:20 +0000

The new test cases verify that KASAN immediately detects all
three combinations of double-free involving kfree_rcu_sheaf():

  1. kmem_cache_free() -> kfree_rcu()
  2. kfree_rcu()       -> kmem_cache_free()
  3. kfree_rcu()       -> kfree_rcu()

Each test also evicts the object from the KASAN quarantine and
reallocates it as a victim object before flushing the RCU sheaf
to ensure the live victim object is not poisoned by the rejected
double-free.

Without the patch, all tests fail to detect the 2nd free, and
the victim is poisoned:

  # kmem_cache_double_free_rcu_1: EXPECTATION FAILED at mm/kasan/kasan_test_c.c:1096
  KASAN failure expected in "kfree_rcu(p, rcu)", but none occurred
  ... <splat below is logged here>
  # kmem_cache_double_free_rcu_1: EXPECTATION FAILED at mm/kasan/kasan_test_c.c:1156
  Expected (<...snipped READ_ONCE()...>&(victim->i)); }) == 42, but
      <...snipped READ_ONCE()...>victim->i == 117729280 (0x7046800)

  # kasan: pass:0 fail:3 skip:0 total:3
  # Totals: pass:0 fail:3 skip:0 total:3
  not ok 1 kasan

In all cases, KASAN logs a false-positive use-after-free splat at
READ_ONCE(victim->i), and it has no information about the suspect;
the two stack traces ("Call Trace:" and "Allocated by") are of the
live victim, and "Freed by" is of the RCU task.

  BUG: KASAN: slab-use-after-free in __kmem_cache_double_free_rcu+0x9ee/0xaf0
  Read of size 4 at addr ffff8881076c2938 by task kunit_try_catch/513
  ...
  Freed by task 0:
   ...
   __rcu_free_sheaf_prepare+0xf6/0x240
   rcu_free_sheaf_nobarn+0x31/0xe0
   rcu_core+0x75e/0x16b0

With the patch, all tests can detect the 2nd free immediately and
prevent the victim from being poisoned:

  # kasan: pass:3 fail:0 skip:0 total:3
  # Totals: pass:3 fail:0 skip:0 total:3
  ok 1 kasan

All the stack traces point to the same object for double-free,
and the two free traces are shown in "Call Trace:" and "Freed by"
(or "Last potentially related work creation:" in the 2nd/3rd test
cases).

  BUG: KASAN: double-free in kvfree_call_rcu+0xb6/0x3c0
  Free of addr ffff888108495938 by task kunit_try_catch/511
  ...
  Call Trace:
   <TASK>
   ...
   check_slab_allocation+0x10d/0x120
   __kfree_rcu_sheaf+0x1c/0x2d0
   kvfree_call_rcu+0xb6/0x3c0
   __kmem_cache_double_free_rcu+0x310/0xaf0

  Allocated by task 511:
   ...
   kmem_cache_alloc_noprof+0x14f/0x3c0
   __kmem_cache_double_free_rcu+0x152/0xaf0

  Freed by task 511:
   ...
   kmem_cache_free+0x14f/0x3c0
   __kmem_cache_double_free_rcu+0x2c6/0xaf0

Notably, in the 2nd/3rd test cases, we can detect the 2nd free
before the object is poisoned:

  Memory state around the buggy address:
   ffff888106dc7800: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
   ffff888106dc7880: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  >ffff888106dc7900: fc fc fc fc fc fc fc 00 00 00 fc fc fc fc fc fc
                                          ^
  ...
      ok 2 kmem_cache_double_free_rcu_2

Link: https://lore.kernel.org/20261028194014.3671161-3-kuniyu@google.com
Fixes: ec66e0d59952 ("slab: add sheaf support for batching kfree_rcu() operations")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Hao Li <hao.li@linux.dev>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
---

 mm/kasan/kasan_test_c.c |  139 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 139 insertions(+)

--- a/mm/kasan/kasan_test_c.c~mm-kasan-kunit-add-double-free-tests-involving-kfree_rcu_sheaf
+++ a/mm/kasan/kasan_test_c.c
@@ -30,6 +30,7 @@
 #include <asm/page.h>
 
 #include "kasan.h"
+#include "../slab.h"
 
 #define OOB_TAG_OFF (IS_ENABLED(CONFIG_KASAN_GENERIC) ? 0 : KASAN_GRANULE_SIZE)
 
@@ -1070,6 +1071,139 @@ static void kmem_cache_double_free(struc
 	kmem_cache_destroy(cache);
 }
 
+#ifndef MODULE
+static void __kmem_cache_double_free_rcu(struct kunit *test, int mode)
+{
+	struct kasan_rcu_info *p, *victim = NULL, **objs;
+	struct kmem_cache *cache;
+	int i, n = 0;
+
+	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_GENERIC);
+	KASAN_TEST_NEEDS_CONFIG_OFF(test, CONFIG_PREEMPT_RT);
+
+	cache = kmem_cache_create("test_cache", sizeof(*p), 0, SLAB_NO_MERGE,
+				  NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, cache);
+
+	if (!cache->sheaf_capacity) {
+		kmem_cache_destroy(cache);
+		kunit_skip(test, "Test requires sheaves");
+	}
+
+	objs = kunit_kcalloc(test, cache->sheaf_capacity * 2, sizeof(*objs),
+			     GFP_KERNEL);
+	if (!objs) {
+		kunit_err(test, "Allocation failed: %s\n", __func__);
+		goto out;
+	}
+
+	migrate_disable();
+
+	p = kmem_cache_alloc(cache, GFP_KERNEL);
+	if (!p) {
+		migrate_enable();
+		kunit_err(test, "Allocation failed: %s\n", __func__);
+		goto out;
+	}
+
+	switch (mode) {
+	case 1:
+		kmem_cache_free(cache, p);
+		/* p is already in quarantine. */
+		KUNIT_EXPECT_KASAN_FAIL(test, kfree_rcu(p, rcu));
+		migrate_enable();
+		break;
+	case 2:
+		/* The actual free order is inverse. */
+		kfree_rcu(p, rcu);
+		KUNIT_EXPECT_KASAN_FAIL(test, kmem_cache_free(cache, p));
+		migrate_enable();
+		break;
+	case 3:
+		kfree_rcu(p, rcu);
+
+		for (i = 0; i < cache->sheaf_capacity - 1; i++) {
+			objs[i] = kmem_cache_alloc(cache, GFP_KERNEL);
+			kfree_rcu(objs[i], rcu);
+		}
+
+		KUNIT_EXPECT_KASAN_FAIL(test, kfree_rcu(p, rcu));
+		migrate_enable();
+
+		/*
+		 * Move the 1st full sheaf to quarantine, keeping the
+		 * 2nd in pcs->rcu_free.
+		 */
+		rcu_barrier();
+		break;
+	}
+
+	/*
+	 * Move p to quarantine if not poisoned yet (case 2,
+	 * or fallback in case 3).
+	 */
+	if (kasan_byte_accessible(p))
+		kvfree_rcu_barrier_on_cache(cache);
+
+	/*
+	 * Evict p from quarantine and reallocate it as a live victim object
+	 * before the RCU sheaf is flushed.
+	 */
+	kasan_quarantine_remove_cache(cache);
+
+	for (i = 0; i < cache->sheaf_capacity * 2; i++) {
+		objs[n] = kmem_cache_alloc(cache, GFP_KERNEL);
+		if (!objs[n])
+			break;
+		if (objs[n] == p) {
+			victim = objs[n];
+			break;
+		}
+		n++;
+	}
+
+	for (i = 0; i < n; i++)
+		kmem_cache_free(cache, objs[i]);
+
+	KUNIT_EXPECT_PTR_EQ(test, victim, p);
+	if (victim != p)
+		goto out;
+
+	WRITE_ONCE(victim->i, 42);
+
+	/*
+	 * If kfree_rcu() failed to reject the double-free above,
+	 * flushing the RCU sheaf will silently poison the live
+	 * victim and cause a false-positive UAF on victim->i.
+	 */
+	kvfree_rcu_barrier_on_cache(cache);
+	KUNIT_EXPECT_EQ(test, READ_ONCE(victim->i), 42);
+
+	if (!READ_ONCE(test_status.report_found))
+		kmem_cache_free(cache, victim);
+out:
+	kmem_cache_destroy(cache);
+}
+
+static void kmem_cache_double_free_rcu_1(struct kunit *test)
+{
+	/* kmem_cache_free() -> kfree_rcu() */
+	__kmem_cache_double_free_rcu(test, 1);
+}
+
+static void kmem_cache_double_free_rcu_2(struct kunit *test)
+{
+	/* kfree_rcu() -> kmem_cache_free() */
+	__kmem_cache_double_free_rcu(test, 2);
+}
+
+static void kmem_cache_double_free_rcu_3(struct kunit *test)
+{
+	/* kfree_rcu() -> kfree_rcu() */
+	__kmem_cache_double_free_rcu(test, 3);
+}
+#endif
+
 static void kmem_cache_invalid_free(struct kunit *test)
 {
 	char *p;
@@ -2239,6 +2373,11 @@ static struct kunit_case kasan_kunit_tes
 	KUNIT_CASE(kfree_via_phys),
 	KUNIT_CASE(kmem_cache_oob),
 	KUNIT_CASE(kmem_cache_double_free),
+#ifndef MODULE
+	KUNIT_CASE(kmem_cache_double_free_rcu_1),
+	KUNIT_CASE(kmem_cache_double_free_rcu_2),
+	KUNIT_CASE(kmem_cache_double_free_rcu_3),
+#endif
 	KUNIT_CASE(kmem_cache_invalid_free),
 	KUNIT_CASE(kmem_cache_rcu_uaf),
 	KUNIT_CASE(kmem_cache_rcu_reuse),
_

Patches currently in -mm which might be from kuniyu@google.com are

memcg-remove-unnecessary-read_once-under-memcg_stocklock.patch
memcg-reduce-nesting-in-consume_stock-and-refill_stock.patch
memcg-annotate-slow-paths-in-consume_stock-and-refill_stock.patch
memcg-uncharge-pages-outside-memcg_stocklock-in-refill_stock.patch

