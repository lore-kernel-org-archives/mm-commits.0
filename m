Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0192749CF
	for <mm-commits@vger.kernel.org>; Sat,  9 May 2026 02:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778294219; cv=none; b=JLBuhEIRerCWUVS/eExxt9nTwhwZawG7UXqQldk02pMikrS7MKuIw31JM3vlZf/bcwruKXhXqslkFbPruNSzkPqu/Z4hvk+sbQqoD2SHcek97M8QsiLxFJuXClssHCQvOBWoutumU3G1UP5cziv50wy2+iYbTBa1an0F/sv46UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778294219; c=relaxed/simple;
	bh=LK7BWWSj/Kzpzcol0PexwLyWwnUK6Czww91HDbN2IzI=;
	h=Date:To:From:Subject:Message-Id; b=TzwYmDJEKtTVrPsVmhsdvInMG18a52D3YZolMp3A0URFMGbonppCVng2EaUMq5pPvPj/94Flr8c4zv3CxuvyZtCbffZzvHzTNKJaHa90nJv+0oOSzJxvH342JbjvwETGYFqhOxwyMAvzIqWgYJ+YO+CG1u0ojyeZ7ghqO1JZEx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D+nezRYn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D+nezRYn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43AC3C2BCB0;
	Sat,  9 May 2026 02:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778294219;
	bh=LK7BWWSj/Kzpzcol0PexwLyWwnUK6Czww91HDbN2IzI=;
	h=Date:To:From:Subject:From;
	b=D+nezRYnJ4F8Y0ObTt6YlEh2jFhvP8j1+utg+JY0bCM4+2mXowTgNuzMGo/5tWIAn
	 JTAFemmg/Ph4kaJjyFhWwllpbgjWzoDiLhxa9LSpKjRWeBO+QrPM+cgKE37H29U+9n
	 V3dEJFp2sDP4+eVtnVvG7IwYNMfe3uqw5yF+Oo3A=
Date: Fri, 08 May 2026 19:36:58 -0700
To: mm-commits@vger.kernel.org,yanquanmin1@huawei.com,sj@kernel.org,shu17az@gmail.com,jiayuan.chen@shopee.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-replace-damon_rand-with-a-per-ctx-lockless-prng.patch added to mm-new branch
Message-Id: <20260509023659.43AC3C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: replace damon_rand() with a per-ctx lockless PRNG
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-replace-damon_rand-with-a-per-ctx-lockless-prng.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-replace-damon_rand-with-a-per-ctx-lockless-prng.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Jiayuan Chen <jiayuan.chen@shopee.com>
Subject: mm/damon: replace damon_rand() with a per-ctx lockless PRNG
Date: Fri, 8 May 2026 18:18:15 -0700

damon_rand() on the sampling_addr hot path called get_random_u32_below(),
which takes a local_lock_irqsave() around a per-CPU batched entropy pool
and periodically refills it with ChaCha20.  At elevated nr_regions counts
(20k+), the lock_acquire / local_lock pair plus __get_random_u32_below()
dominate kdamond perf profiles.

Replace the helper with a lockless lfsr113 generator (struct rnd_state)
held per damon_ctx and seeded from get_random_u64() in damon_new_ctx(). 
kdamond is the single consumer of a given ctx, so no synchronization is
required.  Range mapping uses traditional reciprocal multiplication,
similar as get_random_u32_below(); for spans larger than U32_MAX (only
reachable on 64-bit) the slow path combines two u32 outputs and uses
mul_u64_u64_shr() at 64-bit width.  On 32-bit the slow path is dead code
and gets eliminated by the compiler.

The new helper takes a ctx parameter; damon_split_regions_of() and the
kunit tests that call it directly are updated accordingly.

lfsr113 is a linear PRNG and MUST NOT be used for anything
security-sensitive.  DAMON's sampling_addr is not exposed to userspace and
is only consumed as a probe point for PTE accessed-bit sampling, so a
non-cryptographic PRNG is appropriate here.

Tested with paddr monitoring and max_nr_regions=20000: kdamond CPU usage
reduced from ~72% to ~50% of one core.

Link: https://lore.kernel.org/20260505145212.108644-1-jiayuan.chen@linux.dev
Link: https://lore.kernel.org/damon/20260426173346.86238-1-sj@kernel.org/T/#m4f1fd74112728f83a41511e394e8c3fef703039c
Link: https://lore.kernel.org/20260509011816.85145-1-sj@kernel.org
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Shu Anzai <shu17az@gmail.com>
Cc: Quanmin Yan <yanquanmin1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h       |   28 +++++++++++++++++++++-------
 mm/damon/core.c             |   12 ++++++++----
 mm/damon/paddr.c            |    8 ++++----
 mm/damon/tests/core-kunit.h |   28 ++++++++++++++++++++++------
 mm/damon/vaddr.c            |    7 ++++---
 5 files changed, 59 insertions(+), 24 deletions(-)

--- a/include/linux/damon.h~mm-damon-replace-damon_rand-with-a-per-ctx-lockless-prng
+++ a/include/linux/damon.h
@@ -8,23 +8,18 @@
 #ifndef _DAMON_H_
 #define _DAMON_H_
 
+#include <linux/math64.h>
 #include <linux/memcontrol.h>
 #include <linux/mutex.h>
+#include <linux/prandom.h>
 #include <linux/time64.h>
 #include <linux/types.h>
-#include <linux/random.h>
 
 /* Minimal region size.  Every damon_region is aligned by this. */
 #define DAMON_MIN_REGION_SZ	PAGE_SIZE
 /* Max priority score for DAMON-based operation schemes */
 #define DAMOS_MAX_SCORE		(99)
 
-/* Get a random number in [l, r) */
-static inline unsigned long damon_rand(unsigned long l, unsigned long r)
-{
-	return l + get_random_u32_below(r - l);
-}
-
 /**
  * struct damon_addr_range - Represents an address region of [@start, @end).
  * @start:	Start address of the region (inclusive).
@@ -859,8 +854,27 @@ struct damon_ctx {
 
 	struct list_head adaptive_targets;
 	struct list_head schemes;
+
+	/* Per-ctx PRNG state for damon_rand(); kdamond is the sole consumer. */
+	struct rnd_state rnd_state;
 };
 
+/* Get a random number in [@l, @r) using @ctx's lockless PRNG. */
+static inline unsigned long damon_rand(struct damon_ctx *ctx,
+				       unsigned long l, unsigned long r)
+{
+	unsigned long span = r - l;
+	u64 rnd;
+
+	if (span <= U32_MAX) {
+		rnd = prandom_u32_state(&ctx->rnd_state);
+		return l + (unsigned long)((rnd * span) >> 32);
+	}
+	rnd = ((u64)prandom_u32_state(&ctx->rnd_state) << 32) |
+	      prandom_u32_state(&ctx->rnd_state);
+	return l + mul_u64_u64_shr(rnd, span, 64);
+}
+
 static inline struct damon_region *damon_next_region(struct damon_region *r)
 {
 	return container_of(r->list.next, struct damon_region, list);
--- a/mm/damon/core.c~mm-damon-replace-damon_rand-with-a-per-ctx-lockless-prng
+++ a/mm/damon/core.c
@@ -611,6 +611,8 @@ struct damon_ctx *damon_new_ctx(void)
 	INIT_LIST_HEAD(&ctx->adaptive_targets);
 	INIT_LIST_HEAD(&ctx->schemes);
 
+	prandom_seed_state(&ctx->rnd_state, get_random_u64());
+
 	return ctx;
 }
 
@@ -2939,8 +2941,9 @@ static void damon_split_region_at(struct
 }
 
 /* Split every region in the given target into 'nr_subs' regions */
-static void damon_split_regions_of(struct damon_target *t, int nr_subs,
-				  unsigned long min_region_sz)
+static void damon_split_regions_of(struct damon_ctx *ctx,
+				   struct damon_target *t, int nr_subs,
+				   unsigned long min_region_sz)
 {
 	struct damon_region *r, *next;
 	unsigned long sz_region, sz_sub = 0;
@@ -2955,7 +2958,7 @@ static void damon_split_regions_of(struc
 			 * Randomly select size of left sub-region to be at
 			 * least 10 percent and at most 90% of original region
 			 */
-			sz_sub = ALIGN_DOWN(damon_rand(1, 10) *
+			sz_sub = ALIGN_DOWN(damon_rand(ctx, 1, 10) *
 					sz_region / 10, min_region_sz);
 			/* Do not allow blank region */
 			if (sz_sub == 0 || sz_sub >= sz_region)
@@ -2996,7 +2999,8 @@ static void kdamond_split_regions(struct
 		nr_subregions = 3;
 
 	damon_for_each_target(t, ctx)
-		damon_split_regions_of(t, nr_subregions, ctx->min_region_sz);
+		damon_split_regions_of(ctx, t, nr_subregions,
+				       ctx->min_region_sz);
 
 	last_nr_regions = nr_regions;
 }
--- a/mm/damon/paddr.c~mm-damon-replace-damon_rand-with-a-per-ctx-lockless-prng
+++ a/mm/damon/paddr.c
@@ -49,11 +49,11 @@ static void damon_pa_mkold(phys_addr_t p
 }
 
 static void __damon_pa_prepare_access_check(struct damon_region *r,
-		unsigned long addr_unit)
+		struct damon_ctx *ctx)
 {
-	r->sampling_addr = damon_rand(r->ar.start, r->ar.end);
+	r->sampling_addr = damon_rand(ctx, r->ar.start, r->ar.end);
 
-	damon_pa_mkold(damon_pa_phys_addr(r->sampling_addr, addr_unit));
+	damon_pa_mkold(damon_pa_phys_addr(r->sampling_addr, ctx->addr_unit));
 }
 
 static void damon_pa_prepare_access_checks(struct damon_ctx *ctx)
@@ -63,7 +63,7 @@ static void damon_pa_prepare_access_chec
 
 	damon_for_each_target(t, ctx) {
 		damon_for_each_region(r, t)
-			__damon_pa_prepare_access_check(r, ctx->addr_unit);
+			__damon_pa_prepare_access_check(r, ctx);
 	}
 }
 
--- a/mm/damon/tests/core-kunit.h~mm-damon-replace-damon_rand-with-a-per-ctx-lockless-prng
+++ a/mm/damon/tests/core-kunit.h
@@ -273,54 +273,70 @@ static void damon_test_merge_regions_of(
 
 static void damon_test_split_regions_of(struct kunit *test)
 {
+	struct damon_ctx *c;
 	struct damon_target *t;
 	struct damon_region *r;
 	unsigned long sa[] = {0, 300, 500};
 	unsigned long ea[] = {220, 400, 700};
 	int i;
 
+	c = damon_new_ctx();
+	if (!c)
+		kunit_skip(test, "ctx alloc fail");
+
 	t = damon_new_target();
-	if (!t)
+	if (!t) {
+		damon_destroy_ctx(c);
 		kunit_skip(test, "target alloc fail");
+	}
 	r = damon_new_region(0, 22);
 	if (!r) {
 		damon_free_target(t);
+		damon_destroy_ctx(c);
 		kunit_skip(test, "region alloc fail");
 	}
 	damon_add_region(r, t);
-	damon_split_regions_of(t, 2, 1);
+	damon_split_regions_of(c, t, 2, 1);
 	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 2u);
 	damon_free_target(t);
 
 	t = damon_new_target();
-	if (!t)
+	if (!t) {
+		damon_destroy_ctx(c);
 		kunit_skip(test, "second target alloc fail");
+	}
 	r = damon_new_region(0, 220);
 	if (!r) {
 		damon_free_target(t);
+		damon_destroy_ctx(c);
 		kunit_skip(test, "second region alloc fail");
 	}
 	damon_add_region(r, t);
-	damon_split_regions_of(t, 4, 1);
+	damon_split_regions_of(c, t, 4, 1);
 	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 4u);
 	damon_free_target(t);
 
 	t = damon_new_target();
-	if (!t)
+	if (!t) {
+		damon_destroy_ctx(c);
 		kunit_skip(test, "third target alloc fail");
+	}
 	for (i = 0; i < ARRAY_SIZE(sa); i++) {
 		r = damon_new_region(sa[i], ea[i]);
 		if (!r) {
 			damon_free_target(t);
+			damon_destroy_ctx(c);
 			kunit_skip(test, "region alloc fail");
 		}
 		damon_add_region(r, t);
 	}
-	damon_split_regions_of(t, 4, 5);
+	damon_split_regions_of(c, t, 4, 5);
 	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 12u);
 	damon_for_each_region(r, t)
 		KUNIT_EXPECT_GE(test, damon_sz_region(r) % 5ul, 0ul);
 	damon_free_target(t);
+
+	damon_destroy_ctx(c);
 }
 
 static void damon_test_ops_registration(struct kunit *test)
--- a/mm/damon/vaddr.c~mm-damon-replace-damon_rand-with-a-per-ctx-lockless-prng
+++ a/mm/damon/vaddr.c
@@ -333,9 +333,10 @@ static void damon_va_mkold(struct mm_str
  */
 
 static void __damon_va_prepare_access_check(struct mm_struct *mm,
-					struct damon_region *r)
+					struct damon_region *r,
+					struct damon_ctx *ctx)
 {
-	r->sampling_addr = damon_rand(r->ar.start, r->ar.end);
+	r->sampling_addr = damon_rand(ctx, r->ar.start, r->ar.end);
 
 	damon_va_mkold(mm, r->sampling_addr);
 }
@@ -351,7 +352,7 @@ static void damon_va_prepare_access_chec
 		if (!mm)
 			continue;
 		damon_for_each_region(r, t)
-			__damon_va_prepare_access_check(mm, r);
+			__damon_va_prepare_access_check(mm, r, ctx);
 		mmput(mm);
 	}
 }
_

Patches currently in -mm which might be from jiayuan.chen@shopee.com are

mm-damon-replace-damon_rand-with-a-per-ctx-lockless-prng.patch

