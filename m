Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415BB47A884
	for <mm-commits@vger.kernel.org>; Mon, 28 Sep 2026 22:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790633943; cv=none; b=LWxeLV5Pxalgm0bnN0nVL4RQ5E152JGeuo4I/V/OPVJbSa5eX7RVL1+gaAtEUIzspw4FVcv3AIyu+WVVJifMYww1yL+o7RyPXweBiLe4sj60QnsM8Zt+XR7FjS5cyH/D3Re77BFbY7GWuE/0kT3i9merE2MVsbPALJfUB/LD1Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790633943; c=relaxed/simple;
	bh=YETmDx8m+yiIIJ361PKxfsqI/L+mzNbDP8QyESfA5hc=;
	h=Date:To:From:Subject:Message-Id; b=MWacaROx5THt7BNbgNc4LdfEoHafhqoTbFoqQgti0E9eYl5PUOZ4XsdLqStpWo39HMEEtQXsJvSchWKf2Nn0B1YwULK8vmVfXAMmy/gx+kIjEDKt/K/AHjyfD+oLeb1xv0wkRHZI2DBUoSroIkHD/mfZi8qvxj+eB5+XLm4vMUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OqGqI0zt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OqGqI0zt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F2D01F00893;
	Mon, 28 Sep 2026 22:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790633941;
	bh=u6EvW5PKvl/0WGaHY0XBvB7Rt6CPJkKnkYQLG7U6krs=;
	h=Date:To:From:Subject;
	b=OqGqI0ztkdv8+kMos0NReqfgZClwKKQbVZ61Afws+xoCUMH3Gw8oPRhc0bXVi89c8
	 sr8wLU7PVpabjID9WQX9M8UoSnpNl1BhHmf+JCRsnkF3LTFoA06Zh3dp0CmqlXDp6X
	 FbKZPf9CIZ7J0W4/SFJ7jHo1wNdlO7TwDVeAca2I=
Date: Mon, 28 Sep 2026 15:19:00 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,davidgow@davidgow.net,brendan.higgins@linux.dev,bijan311@gmail.com,kmehltretter@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-tests-core-kunit-test-preservation-of-quota-state.patch added to mm-new branch
Message-Id: <20260928221901.5F2D01F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/tests/core-kunit: test preservation of quota state
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-tests-core-kunit-test-preservation-of-quota-state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-tests-core-kunit-test-preservation-of-quota-state.patch

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
From: Karl Mehltretter <kmehltretter@gmail.com>
Subject: mm/damon/tests/core-kunit: test preservation of quota state
Date: Mon, 28 Sep 2026 01:58:34 -0700

Check that damon_new_scheme() initializes the new scheme's quota without
changing the quota passed as a parameter.  Cover all eight fields
initialized by damos_quota_init().

Also check that damon_commit_ctx() preserves those fields in the
destination scheme for both accepted and rejected parameter updates.  Use
an invalid min_region_sz for the rejected update and confirm that
returning -EINVAL leaves the running quota state unchanged.

Without the preceding fix, all eight fields are cleared in the constructor
test and in both context update cases.

Link: https://lore.kernel.org/20260928085835.7675-3-sj@kernel.org
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Assisted-by: LLM
Cc: Bijan Tabatabai <bijan311@gmail.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
---

 mm/damon/tests/core-kunit.h |  107 ++++++++++++++++++++++++++++++++++
 1 file changed, 107 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-test-preservation-of-quota-state
+++ a/mm/damon/tests/core-kunit.h
@@ -812,6 +812,48 @@ static void damos_test_new_filter(struct
 	damos_destroy_filter(filter);
 }
 
+static void damos_test_new_scheme_keeps_src_quota(struct kunit *test)
+{
+	struct damos_access_pattern pattern = {};
+	struct damon_target target = {};
+	struct damos_quota quota = {
+		.sz = SZ_64K,
+		.esz = 123,
+		.esz_bp = 456,
+		.total_charged_sz = 789,
+		.total_charged_ns = 1011,
+		.charged_sz = 12,
+		.charged_from = 13,
+		.charge_target_from = &target,
+		.charge_addr_from = 14,
+	};
+	struct damos_watermarks wmarks = {};
+	struct damos *s;
+
+	s = damon_new_scheme(&pattern, DAMOS_STAT, 0, &quota, &wmarks,
+			NUMA_NO_NODE);
+	if (!s)
+		kunit_skip(test, "scheme alloc fail");
+	KUNIT_EXPECT_EQ(test, s->quota.sz, (unsigned long)SZ_64K);
+	KUNIT_EXPECT_EQ(test, s->quota.esz, 0ul);
+	KUNIT_EXPECT_EQ(test, s->quota.esz_bp, 0ul);
+	KUNIT_EXPECT_EQ(test, s->quota.total_charged_sz, 0ul);
+	KUNIT_EXPECT_EQ(test, s->quota.total_charged_ns, 0ul);
+	KUNIT_EXPECT_EQ(test, s->quota.charged_sz, 0ul);
+	KUNIT_EXPECT_EQ(test, s->quota.charged_from, 0ul);
+	KUNIT_EXPECT_PTR_EQ(test, s->quota.charge_target_from, NULL);
+	KUNIT_EXPECT_EQ(test, s->quota.charge_addr_from, 0ul);
+	KUNIT_EXPECT_EQ(test, quota.esz, 123ul);
+	KUNIT_EXPECT_EQ(test, quota.esz_bp, 456ul);
+	KUNIT_EXPECT_EQ(test, quota.total_charged_sz, 789ul);
+	KUNIT_EXPECT_EQ(test, quota.total_charged_ns, 1011ul);
+	KUNIT_EXPECT_EQ(test, quota.charged_sz, 12ul);
+	KUNIT_EXPECT_EQ(test, quota.charged_from, 13ul);
+	KUNIT_EXPECT_PTR_EQ(test, quota.charge_target_from, &target);
+	KUNIT_EXPECT_EQ(test, quota.charge_addr_from, 14ul);
+	damon_destroy_scheme(s);
+}
+
 static void damos_test_commit_quota_goal_for(struct kunit *test,
 		struct damos_quota_goal *dst,
 		struct damos_quota_goal *src)
@@ -1572,6 +1614,69 @@ static void damon_test_commit_ctx(struct
 	damon_destroy_ctx(dst);
 }
 
+static void damon_test_commit_ctx_keeps_quota_for(struct kunit *test,
+		unsigned long min_region_sz, int expected_err)
+{
+	struct damos_access_pattern pattern = {};
+	struct damos_quota quota = {.sz = SZ_64K};
+	struct damos_watermarks wmarks = {};
+	struct damon_ctx *src, *dst;
+	struct damon_target *target;
+	struct damos *s;
+
+	dst = damon_new_ctx();
+	if (!dst)
+		kunit_skip(test, "dst alloc fail");
+	target = damon_new_target();
+	if (!target) {
+		damon_destroy_ctx(dst);
+		kunit_skip(test, "target alloc fail");
+	}
+	damon_add_target(dst, target);
+	s = damon_new_scheme(&pattern, DAMOS_STAT, 0, &quota, &wmarks,
+			NUMA_NO_NODE);
+	if (!s) {
+		damon_destroy_ctx(dst);
+		kunit_skip(test, "scheme alloc fail");
+	}
+	damon_add_scheme(dst, s);
+
+	/* Copy the parameters before populating dst's runtime quota state. */
+	src = damon_new_test_ctx(dst);
+	if (!src) {
+		damon_destroy_ctx(dst);
+		kunit_skip(test, "src alloc fail");
+	}
+	src->min_region_sz = min_region_sz;
+	s->quota.esz = 123;
+	s->quota.esz_bp = 456;
+	s->quota.total_charged_sz = 789;
+	s->quota.total_charged_ns = 1011;
+	s->quota.charged_sz = 12;
+	s->quota.charged_from = 13;
+	s->quota.charge_target_from = target;
+	s->quota.charge_addr_from = 14;
+
+	KUNIT_EXPECT_EQ(test, damon_commit_ctx(dst, src), expected_err);
+	KUNIT_EXPECT_EQ(test, s->quota.esz, 123ul);
+	KUNIT_EXPECT_EQ(test, s->quota.esz_bp, 456ul);
+	KUNIT_EXPECT_EQ(test, s->quota.total_charged_sz, 789ul);
+	KUNIT_EXPECT_EQ(test, s->quota.total_charged_ns, 1011ul);
+	KUNIT_EXPECT_EQ(test, s->quota.charged_sz, 12ul);
+	KUNIT_EXPECT_EQ(test, s->quota.charged_from, 13ul);
+	KUNIT_EXPECT_PTR_EQ(test, s->quota.charge_target_from, target);
+	KUNIT_EXPECT_EQ(test, s->quota.charge_addr_from, 14ul);
+	damon_destroy_ctx(src);
+	damon_destroy_ctx(dst);
+}
+
+static void damon_test_commit_ctx_keeps_quota(struct kunit *test)
+{
+	/* Only power of two min_region_sz is allowed. */
+	damon_test_commit_ctx_keeps_quota_for(test, 4096, 0);
+	damon_test_commit_ctx_keeps_quota_for(test, 4095, -EINVAL);
+}
+
 static void damon_test_valid_probe_params(struct kunit *test)
 {
 	struct damon_ctx *ctx;
@@ -2259,6 +2364,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damon_test_mvsum),
 	KUNIT_CASE(damon_test_nr_accesses_mvsum),
 	KUNIT_CASE(damos_test_new_filter),
+	KUNIT_CASE(damos_test_new_scheme_keeps_src_quota),
 	KUNIT_CASE(damos_test_commit_quota_goal),
 	KUNIT_CASE(damos_test_commit_quota_goals),
 	KUNIT_CASE(damos_test_commit_quota),
@@ -2270,6 +2376,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damon_test_commit_filter),
 	KUNIT_CASE(damon_test_commit_probes),
 	KUNIT_CASE(damon_test_commit_ctx),
+	KUNIT_CASE(damon_test_commit_ctx_keeps_quota),
 	KUNIT_CASE(damon_test_valid_probe_params),
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damos_test_apply_scheme_filtered_sz),
_

Patches currently in -mm which might be from kmehltretter@gmail.com are

mm-damon-core-handle-uninitialized-damos_quota_goal-last_psi_total-fix.patch
docs-mm-ksm-use-the-renamed-ksm-structure-names.patch
mm-secretmem-fix-the-enable-parameter-description.patch
mm-damon-core-preserve-the-quota-passed-to-damon_new_scheme.patch
mm-damon-tests-core-kunit-test-preservation-of-quota-state.patch
klist-avoid-accesses-after-waking-klist_remove.patch
squashfs-fix-fragment-index-table-sizing-overflow-on-32-bit.patch
squashfs-make-the-fragment-index-table-bounds-check-overflow-safe.patch
fork-honor-task_structs-declared-alignment.patch
ocfs2-cluster-hold-a-reference-on-the-heartbeat-thread.patch
resource-kunit-stop-selecting-get_free_region.patch

