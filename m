Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792458160;
	b=eIXK0ZGrgIjRV0lJ+WndAfwswgGiof89ZcOVOXmwZlaj0vLrG5TXlCE+z9eIrNH7+JHx
	 y4nEL9iEFCZ8I30mumxVeKbZPxfkwURPSS85I29aapwbhb3y0awrPbxeiVmKjWFcwdphk
	 X8TKZA/u8NiHAEy6hikn/W1S/Ke0SGNMoZEI3fM2XPoQo+8jx/lIR/NjScYKTcJ59EeXa
	 53p6IJzm3YwtUJkr97pNfDBEyaiDiMDiOnHjz4Pk2s5ClJw9g4s8aek3z8E9MrwhJx/TQ
	 9EsJNik+y2ra3G6V0cM1GQoz83u/TrwSfcOMJAzYEwW0cp59cAEf39VBRkRV/06G/+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792458160;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=vA9HrIlYy80oAx3dOJ8vBQKkZAANJTZdkbS+jz0zzy8=;
	b=EDwgk031yOZkrnhB3Ll9o/D0yr/+R1VkvniApikcosoAL9Q/NIyxjqeg5Z4aul4b2BGS
	 aH7UjiuWGAxWGfGh3To51coLtO7wjRaNUed05THVD7V7nImW8sHaCvw9WkL2SDcDa4W2G
	 DXasv1TdKnEvZ72AWKtgSqQXIeE6q+OGmU4j+m7bKTpWDSA2X8/koZG4fuS3h74KiW0Ga
	 +55gtnVK6USP/hDJW4uyORR9/7hbU2lrvnPNhyAe/Vky2lUKI845vGRhshPiPvRQrbT9O
	 hawC21KYg9NgOdrCWn71x+0SkT2WIQ5eXUHRiJ+LwcIg1SA7L5riFH+qj7WCC2Wa5qA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=0L61nKTj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F278606A319;
	Tue, 20 Oct 2026 01:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=0L61nKTj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD95F1F000C4;
	Tue, 20 Oct 2026 01:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792458160;
	bh=vA9HrIlYy80oAx3dOJ8vBQKkZAANJTZdkbS+jz0zzy8=;
	h=Date:To:From:Subject;
	b=0L61nKTjNSD51NYbC4ZAvFU59Bb0uvxTAy+ixT1vtInrXGNBtXpMhozmziHiOFaef
	 5eoFymapiMHm9kiExfuUyD9BFeVWb5RZSh0o05dmSduJe2YNdl52FYpH/dwylpPqRq
	 BoWVe6r3KOJ1GXAVNOphdl5qqyVMzPB0Aq3furWg=
Date: Mon, 19 Oct 2026 18:02:39 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-filter-out-damos-address-filter-split-failed-region.patch added to mm-unstable branch
Message-Id: <20261020010239.DD95F1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/core: filter out damos address filter-split failed region
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-filter-out-damos-address-filter-split-failed-region.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-filter-out-damos-address-filter-split-failed-region.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: mm/damon/core: filter out damos address filter-split failed region
Date: Mon, 19 Oct 2026 17:41:18 -0700

When an address type DAMOS filter is configured, DAMOS tries to split the
region for the filter range, and apply DAMOS action to the filter-in
region.  The split operation (damon_split_region_at()) could fail from
allocation failure under extreme memory pressure.  In the case, DAMOS
action could be applied more or less than expected, ignoring the address
filter.

The issue only rarely happens under extreme memory pressure.  No crash or
leak happens.  Occasionally not applying the action to a few regions
shouldn't be a real problem.  But applying the action to a region that the
user has excluded via address filter could be a surprise depending on the
use case.  It is only theoretical.  No such real case is found yet.

Filter out the entire region if the split is failed.  Update
damos_filter_match() signature to receive the error from split.  Also
update kunit tests for the updated signature.

The issue was discovered [1] by sashiko.

Link: https://lore.kernel.org/20261020004119.106690-1-sj@kernel.org
Link: https://lore.kernel.org/20260801203121.117449-1-sj@kernel.org [1]
Fixes: ab9bda001b68 ("mm/damon/core: introduce address range type damos filter")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@vger.kernel.org> # 6.6.x
---

 mm/damon/core.c             |   16 ++++++++++++----
 mm/damon/tests/core-kunit.h |   11 ++++++-----
 2 files changed, 18 insertions(+), 9 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-filter-out-damos-address-filter-split-failed-region
+++ a/mm/damon/core.c
@@ -2551,13 +2551,14 @@ static void damos_update_stat(struct dam
 
 static bool damos_filter_match(struct damon_ctx *ctx, struct damon_target *t,
 		struct damon_region *r, struct damos_filter *filter,
-		unsigned long min_region_sz)
+		unsigned long min_region_sz, int *err)
 {
 	bool matched = false;
 	struct damon_target *ti;
 	int target_idx = 0;
 	unsigned long start, end, wsum;
 
+	*err = 0;
 	switch (filter->type) {
 	case DAMOS_FILTER_TYPE_TARGET:
 		damon_for_each_target(ti, ctx) {
@@ -2583,12 +2584,13 @@ static bool damos_filter_match(struct da
 		}
 		/* start before the range and overlap */
 		if (r->ar.start < start) {
-			damon_split_region_at(t, r, start - r->ar.start);
+			*err = damon_split_region_at(t, r,
+					start - r->ar.start);
 			matched = false;
 			break;
 		}
 		/* start inside the range */
-		damon_split_region_at(t, r, end - r->ar.start);
+		*err = damon_split_region_at(t, r, end - r->ar.start);
 		matched = true;
 		break;
 	case DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:
@@ -2607,10 +2609,16 @@ static bool damos_core_filter_out(struct
 		struct damon_region *r, struct damos *s)
 {
 	struct damos_filter *filter;
+	bool matching;
+	int err;
 
 	s->core_filters_allowed = false;
 	damos_for_each_core_filter(filter, s) {
-		if (damos_filter_match(ctx, t, r, filter, ctx->min_region_sz)) {
+		matching = damos_filter_match(ctx, t, r, filter,
+				ctx->min_region_sz, &err);
+		if (err)
+			return true;
+		if (matching) {
 			if (filter->allow)
 				s->core_filters_allowed = true;
 			return !filter->allow;
--- a/mm/damon/tests/core-kunit.h~mm-damon-core-filter-out-damos-address-filter-split-failed-region
+++ a/mm/damon/tests/core-kunit.h
@@ -1783,6 +1783,7 @@ static void damos_test_filter_out(struct
 	struct damon_target *t;
 	struct damon_region *r, *r2;
 	struct damos_filter *f;
+	int err;
 
 	f = damos_new_filter(DAMOS_FILTER_TYPE_ADDR, true, false);
 	if (!f)
@@ -1803,27 +1804,27 @@ static void damos_test_filter_out(struct
 	damon_add_region(r, t);
 
 	/* region in the range */
-	KUNIT_EXPECT_TRUE(test, damos_filter_match(NULL, t, r, f, 1));
+	KUNIT_EXPECT_TRUE(test, damos_filter_match(NULL, t, r, f, 1, &err));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region before the range */
 	r->ar.start = 1;
 	r->ar.end = 2;
 	KUNIT_EXPECT_FALSE(test,
-			damos_filter_match(NULL, t, r, f, 1));
+			damos_filter_match(NULL, t, r, f, 1, &err));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region after the range */
 	r->ar.start = 6;
 	r->ar.end = 8;
 	KUNIT_EXPECT_FALSE(test,
-			damos_filter_match(NULL, t, r, f, 1));
+			damos_filter_match(NULL, t, r, f, 1, &err));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region started before the range */
 	r->ar.start = 1;
 	r->ar.end = 4;
-	KUNIT_EXPECT_FALSE(test, damos_filter_match(NULL, t, r, f, 1));
+	KUNIT_EXPECT_FALSE(test, damos_filter_match(NULL, t, r, f, 1, &err));
 	/* filter should have split the region */
 	KUNIT_EXPECT_EQ(test, r->ar.start, 1);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 2);
@@ -1839,7 +1840,7 @@ static void damos_test_filter_out(struct
 	r->ar.start = 2;
 	r->ar.end = 8;
 	KUNIT_EXPECT_TRUE(test,
-			damos_filter_match(NULL, t, r, f, 1));
+			damos_filter_match(NULL, t, r, f, 1, &err));
 	/* filter should have split the region */
 	KUNIT_EXPECT_EQ(test, r->ar.start, 2);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 6);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-damos_quota_goal-complement.patch
mm-damon-core-add-complement-argument-to-damos_new_quota_goal.patch
mm-damon-sysfs-schemes-support-quota-goal-complement-flag.patch
mm-damon-tests-core-kunit-test-quota_goal-complement-commit.patch
selftests-damon-sysfssh-test-quota-goal-complement-flag-file.patch
docs-mm-damon-design-document-damos-quota-goal-complement-flag.patch
docs-admin-guide-mm-damon-usage-update-for-quota-goal-complement-file.patch
docs-abi-damon-update-for-quota-goal-metric-complement-sysfs-file.patch
mm-damon-core-filter-out-damos-address-filter-split-failed-region.patch

