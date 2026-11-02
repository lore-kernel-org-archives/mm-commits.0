Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793640167;
	b=tegBsUuxZy4c3LreO/cAMQbFSM/Lmkp/MeAHbZBSmyH4PLWsaw46LUMJWRF40Hg8zBsX
	 SwSRPM0ibptqyr45o4o9bhoLynYSgvU7+4FHA2E5bUQaPuLJKz2CI59bxu3mvWlskEx+9
	 qxW1o6/jZN43EaEDrbNGfdHu6VuoZumAjPUpHOARGXBV7RjAZr4CxaDIVK9fSG6OLgvyz
	 zv2ZT3BaUuyyRzDjiZ6A2B5oiCtXuHNg+x2Z3KahyY9rLNqlIYZVy/ujF3iSaV+zL+bbT
	 XD4bFATTj/z/uCvwNkKlch2Js5eGO437OMUB6ByOCAv+QfS/Ekqozk6batWHOaqaJLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793640167;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=TKQIMYRPR94Lc3tYNECCTwk1mbecqBhYu9VgRH3BIYI=;
	b=M2c/VHaNL0UBGbkFwYxEOOOdIC+ebIEnup0bIi9WZ9ZnzKxPofQLWwnVxZL0zR8NCJeB
	 ovAKEAsiAY2gX/Je6QxtpwMIVMeMF/C3cBuK6QaFTB7ySiZKI1x5mPexyfFEtJ+jw/Qe2
	 4opRwM1PXAyFWAvtcMVka5j2LAk/5VwDm+k+xksx34t6HDTYcuVM0tuqRbECYPEbU0RHb
	 /Q83U/UPXPW598NF6sgGBYI53YDj2QWmOQlbs+AUbYImNOvM2RHY87QdMNbSYWWZkwSFZ
	 r4vRlP6/ND0jurZQh7f2j/9Cb+YePhUz6iabq0TOYAKE9i+cyPrVsQxlL/d67hhty7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=HCVWKb8j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112CE606B0FE
	for <mm-commits@vger.kernel.org>; Mon,  2 Nov 2026 17:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=HCVWKb8j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D5C71F00A16;
	Mon,  2 Nov 2026 17:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793640166;
	bh=TKQIMYRPR94Lc3tYNECCTwk1mbecqBhYu9VgRH3BIYI=;
	h=Date:To:From:Subject;
	b=HCVWKb8j1+0bZaR9zQFUKqWHkce+Wj2tIKAkvSvmBcfOFpA9dnVGjhXS7aqReqOQX
	 rKD2ktdCBBkaAimDZ3e97LPI7aOcZ4xTznt6Yzu9q8RYz7PVjkfcnTlzzAoECqp8DF
	 AYtPxTohxsTLxAvHZZ8TacqG+YICvey10dEyudSc=
Date: Mon, 02 Nov 2026 09:22:36 -0800
To: mm-commits@vger.kernel.org,suhaas@s-joshi.in,sj@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-copy-only-installed-probe-in-damon_split_region_at.patch added to mm-new branch
Message-Id: <20261102172246.6D5C71F00A16@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/core: copy only installed probe in damon_split_region_at()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-copy-only-installed-probe-in-damon_split_region_at.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-copy-only-installed-probe-in-damon_split_region_at.patch

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
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: copy only installed probe in damon_split_region_at()
Date: Mon, 02 Nov 2026 07:37:52 -0800

In damon_split_region_at(), we copy the entire probe_hits[] and
last_probe_hits[] arrays of DAMON_MAX_PROBES size. However it is possible
that the number of probes installed is less than DAMON_MAX_PROBES, in which
case one or more iterations is/are redundant. To remedy this, iterate over
only as many times as the number of installed probes. To do so, accept a
struct damon_ctx pointer in damon_split_region_at(), and update all
invocations of the function to pass the new argument.

Also update damon_test_split_at() and damos_test_filter_out() in
core-kunit.h to supply a context to function paths that call
damon_split_region_at().

Link: https://lore.kernel.org/20261102153753.97769-3-sj@kernel.org
Signed-off-by: Suhaas Joshi <suhaas@s-joshi.in>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
---

 mm/damon/core.c             |   42 ++++++++++++----------
 mm/damon/tests/core-kunit.h |   64 ++++++++++++++++++++++++++++------
 2 files changed, 78 insertions(+), 28 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-copy-only-installed-probe-in-damon_split_region_at
+++ a/mm/damon/core.c
@@ -2051,8 +2051,8 @@ static unsigned long damon_region_sz_lim
 	return sz;
 }
 
-static int damon_split_region_at(struct damon_target *t,
-				  struct damon_region *r, unsigned long sz_r);
+static int damon_split_region_at(struct damon_ctx *ctx, struct damon_target *t,
+		struct damon_region *r, unsigned long sz_r);
 
 /*
  * damon_apply_min_nr_regions() - Make effect of min_nr_regions parameter.
@@ -2077,7 +2077,7 @@ static unsigned long damon_apply_min_nr_
 	damon_for_each_target(t, ctx) {
 		damon_for_each_region_safe(r, next, t) {
 			while (damon_sz_region(r) > max_region_sz) {
-				if (damon_split_region_at(t, r, max_region_sz))
+				if (damon_split_region_at(ctx, t, r, max_region_sz))
 					goto out;
 				r = damon_next_region(r);
 			}
@@ -2474,6 +2474,7 @@ static bool damos_valid_target(struct da
 /*
  * damos_skip_charged_region() - Check if the given region or starting part of
  * it is already charged for the DAMOS quota.
+ * @ctx: The pointer to the context.
  * @t:	The target of the region.
  * @rp:	The pointer to the region.
  * @s:	The scheme to be applied.
@@ -2496,8 +2497,8 @@ static bool damos_valid_target(struct da
  *
  * Return: true if the region should be skipped, false otherwise.
  */
-static bool damos_skip_charged_region(struct damon_target *t,
-		struct damon_region *r, struct damos *s,
+static bool damos_skip_charged_region(struct damon_ctx *ctx,
+		struct damon_target *t, struct damon_region *r, struct damos *s,
 		unsigned long min_region_sz)
 {
 	struct damos_quota *quota = &s->quota;
@@ -2525,7 +2526,7 @@ static bool damos_skip_charged_region(st
 				}
 				sz_to_skip = min_region_sz;
 			}
-			damon_split_region_at(t, r, sz_to_skip);
+			damon_split_region_at(ctx, t, r, sz_to_skip);
 			skip = true;
 		}
 	}
@@ -2584,13 +2585,13 @@ static bool damos_filter_match(struct da
 		}
 		/* start before the range and overlap */
 		if (r->ar.start < start) {
-			*err = damon_split_region_at(t, r,
+			*err = damon_split_region_at(ctx, t, r,
 					start - r->ar.start);
 			matched = false;
 			break;
 		}
 		/* start inside the range */
-		*err = damon_split_region_at(t, r, end - r->ar.start);
+		*err = damon_split_region_at(ctx, t, r, end - r->ar.start);
 		matched = true;
 		break;
 	case DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:
@@ -2789,7 +2790,7 @@ static void damos_apply_scheme(struct da
 					c->min_region_sz);
 			if (!sz)
 				goto update_stat;
-			if (damon_split_region_at(t, r, sz))
+			if (damon_split_region_at(c, t, r, sz))
 				goto update_stat;
 		}
 		if (damos_core_filter_out(c, t, r, s))
@@ -2836,7 +2837,7 @@ static void damon_do_apply_schemes(struc
 		if (damos_quota_is_full(quota, c->min_region_sz))
 			continue;
 
-		if (damos_skip_charged_region(t, r, s, c->min_region_sz))
+		if (damos_skip_charged_region(c, t, r, s, c->min_region_sz))
 			continue;
 
 		if (s->max_nr_snapshots &&
@@ -3695,15 +3696,18 @@ static void damon_verify_split_region_at
 /*
  * Split a region in two
  *
+ * ctx		pointer to the region's context
  * r		the region to be split
  * sz_r		size of the first sub-region that will be made
  *
  * Return: 0 on success, negative error code otherwise.
  */
-static int damon_split_region_at(struct damon_target *t,
-				  struct damon_region *r, unsigned long sz_r)
+static int damon_split_region_at(struct damon_ctx *ctx, struct damon_target *t,
+		struct damon_region *r, unsigned long sz_r)
 {
 	struct damon_region *new;
+	struct damon_probe *p;
+	int i;
 
 	damon_verify_split_region_at(r, sz_r);
 	new = damon_new_region(r->ar.start + sz_r, r->ar.end);
@@ -3715,11 +3719,13 @@ static int damon_split_region_at(struct
 	new->age = r->age;
 	new->last_nr_accesses = r->last_nr_accesses;
 	new->nr_accesses = r->nr_accesses;
-	/* todo: do this for only installed probes */
-	memcpy(new->probe_hits, r->probe_hits, sizeof(r->probe_hits));
-	memcpy(new->last_probe_hits, r->last_probe_hits,
-			sizeof(r->last_probe_hits));
 
+	i = 0;
+	damon_for_each_probe(p, ctx) {
+		new->probe_hits[i] = r->probe_hits[i];
+		new->last_probe_hits[i] = r->last_probe_hits[i];
+		++i;
+	}
 	damon_insert_region(new, r, damon_next_region(r), t);
 	return 0;
 }
@@ -3748,7 +3754,7 @@ static void damon_split_regions_of(struc
 			if (sz_sub == 0 || sz_sub >= sz_region)
 				continue;
 
-			damon_split_region_at(t, r, sz_sub);
+			damon_split_region_at(ctx, t, r, sz_sub);
 			sz_region = sz_sub;
 		}
 	}
@@ -3781,7 +3787,7 @@ static void damon_split_some_regions(str
 			if (sz_sub == 0 || sz_sub >= sz_region)
 				continue;
 
-			damon_split_region_at(t, r, sz_sub);
+			damon_split_region_at(ctx, t, r, sz_sub);
 		}
 	}
 }
--- a/mm/damon/tests/core-kunit.h~mm-damon-core-copy-only-installed-probe-in-damon_split_region_at
+++ a/mm/damon/tests/core-kunit.h
@@ -141,6 +141,8 @@ static void damon_test_split_at(struct k
 {
 	struct damon_target *t;
 	struct damon_region *r, *r_new;
+	struct damon_ctx *ctx;
+	struct damon_probe *p;
 
 	t = damon_new_target();
 	if (!t)
@@ -150,13 +152,29 @@ static void damon_test_split_at(struct k
 		damon_free_target(t);
 		kunit_skip(test, "region alloc fail");
 	}
+	p = damon_new_probe();
+	if (!p) {
+		damon_free_region(r);
+		damon_free_target(t);
+		kunit_skip(test, "probe alloc fail");
+	}
+	ctx = damon_new_ctx();
+	if (!ctx) {
+		damon_destroy_probe(p);
+		damon_free_region(r);
+		damon_free_target(t);
+		kunit_skip(test, "context alloc fail");
+	}
+	damon_add_probe(ctx, p);
+	damon_add_target(ctx, t);
+
 	r->nr_accesses = 42;
 	r->last_nr_accesses = 15;
 	r->probe_hits[0] = 7;
 	r->last_probe_hits[0] = 3;
 	r->age = 10;
 	damon_add_region(r, t);
-	damon_split_region_at(t, r, 25);
+	damon_split_region_at(ctx, t, r, 25);
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 2);
 	if (damon_nr_regions(t) != 2)
 		goto out;
@@ -175,7 +193,7 @@ static void damon_test_split_at(struct k
 	KUNIT_EXPECT_EQ(test, r->age, r_new->age);
 
 out:
-	damon_free_target(t);
+	damon_destroy_ctx(ctx);
 }
 
 static void damon_test_merge_two(struct kunit *test)
@@ -1799,6 +1817,8 @@ static void damos_test_filter_out(struct
 	struct damon_target *t;
 	struct damon_region *r, *r2;
 	struct damos_filter *f;
+	struct damon_ctx *ctx;
+	struct damon_probe *p;
 	int err;
 
 	f = damos_new_filter(DAMOS_FILTER_TYPE_ADDR, true, false);
@@ -1819,28 +1839,44 @@ static void damos_test_filter_out(struct
 	}
 	damon_add_region(r, t);
 
+	p = damon_new_probe();
+	if (!p) {
+		damon_free_target(t);
+		damos_destroy_filter(f);
+		kunit_skip(test, "probe alloc fail");
+	}
+	ctx = damon_new_ctx();
+	if (!ctx) {
+		damon_destroy_probe(p);
+		damon_free_target(t);
+		damos_destroy_filter(f);
+		kunit_skip(test, "context alloc fail");
+	}
+	damon_add_probe(ctx, p);
+	damon_add_target(ctx, t);
+
 	/* region in the range */
-	KUNIT_EXPECT_TRUE(test, damos_filter_match(NULL, t, r, f, 1, &err));
+	KUNIT_EXPECT_TRUE(test, damos_filter_match(ctx, t, r, f, 1, &err));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region before the range */
 	r->ar.start = 1;
 	r->ar.end = 2;
 	KUNIT_EXPECT_FALSE(test,
-			damos_filter_match(NULL, t, r, f, 1, &err));
+			damos_filter_match(ctx, t, r, f, 1, &err));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region after the range */
 	r->ar.start = 6;
 	r->ar.end = 8;
 	KUNIT_EXPECT_FALSE(test,
-			damos_filter_match(NULL, t, r, f, 1, &err));
+			damos_filter_match(ctx, t, r, f, 1, &err));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region started before the range */
 	r->ar.start = 1;
 	r->ar.end = 4;
-	KUNIT_EXPECT_FALSE(test, damos_filter_match(NULL, t, r, f, 1, &err));
+	KUNIT_EXPECT_FALSE(test, damos_filter_match(ctx, t, r, f, 1, &err));
 	/* filter should have split the region */
 	KUNIT_EXPECT_EQ(test, r->ar.start, 1);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 2);
@@ -1856,7 +1892,7 @@ static void damos_test_filter_out(struct
 	r->ar.start = 2;
 	r->ar.end = 8;
 	KUNIT_EXPECT_TRUE(test,
-			damos_filter_match(NULL, t, r, f, 1, &err));
+			damos_filter_match(ctx, t, r, f, 1, &err));
 	/* filter should have split the region */
 	KUNIT_EXPECT_EQ(test, r->ar.start, 2);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 6);
@@ -1869,7 +1905,7 @@ static void damos_test_filter_out(struct
 	damon_destroy_region(r2, t);
 
 out:
-	damon_free_target(t);
+	damon_destroy_ctx(ctx);
 	damos_free_filter(f);
 }
 
@@ -2459,6 +2495,7 @@ static void damos_test_esz_goal_temporal
 static void damon_test_last_region_quota_reset(struct kunit *test)
 {
 	struct damos s = {0};
+	struct damon_ctx *ctx;
 	struct damon_target *t;
 	struct damon_region *r1, *r2;
 	unsigned long min_region_sz = 1;
@@ -2485,7 +2522,14 @@ static void damon_test_last_region_quota
 	s.quota.charge_target_from = t;
 	s.quota.charge_addr_from = r1->ar.end;
 
-	skipped = damos_skip_charged_region(t, r2, &s, min_region_sz);
+	ctx = damon_new_ctx();
+	if (!ctx) {
+		damon_free_target(t);
+		kunit_skip(test, "ctx alloc failed");
+	}
+	damon_add_target(ctx, t);
+
+	skipped = damos_skip_charged_region(ctx, t, r2, &s, min_region_sz);
 
 	/* 'r2' is not processed, it should not skip */
 	KUNIT_EXPECT_EQ(test, skipped, false);
@@ -2494,7 +2538,7 @@ static void damon_test_last_region_quota
 	KUNIT_EXPECT_PTR_EQ(test, s.quota.charge_target_from, NULL);
 	KUNIT_EXPECT_EQ(test, s.quota.charge_addr_from, 0);
 
-	damon_free_target(t);
+	damon_destroy_ctx(ctx);
 }
 
 static struct kunit_case damon_test_cases[] = {
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-hold-damon_sysfs_lock-in-target_metric_store.patch
mm-damon-core-move-static-variable-last_nr_regions-to-damon_ctx.patch
mm-damon-core-move-static-variable-rotation-to-damon_ctx.patch
mm-damon-core-copy-only-installed-probe-in-damon_split_region_at.patch

