Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832539;
	b=2MNIxwBT0Stjsp7+GfEy93eCU21WzmUa9yCToFk5O6TPrXgKfhVo/zLHAMvtQLBjyLja
	 P+N7V+0sX54EbXI64KwncDQREkCBedCxq4bhSpgYZ1z85JsOkCv2EszVKFRUB32hHfa0V
	 YdReLFq8591tfXujMdY39iAWC5OTgRWGtFbBxPRFdSLexja6Uzf7RBg16YQl0oZCvQ0iK
	 ynmH/rhHlMidOsBlF5Bdpuaj0tS0rNGQERbfYXhiO/tlVORT5CeqAwpWTyntk6fhD3AnN
	 tF49XIF4wm4H+7QTJcZMI66QyzsZOLTla2J39BOUqFg2WFLpqAp5+JmixaD9X24KHiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832539;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=68M4FMENKnpLDuXzMIWRSsZ5vWP+TYWCgvIOLu60dtk=;
	b=3zvmzNjRI5H4W26GdnY8TEHULu5rUXGzfnMfFs0GnBem7gNYrr6SFDELOVwON9tKFjw2
	 Spd7oPAKn+ehiGFFTis/EnMTFMC8npaWbKZ3///Lj2xFoDZ3ZypzA9PMdW2z7r2dSGRJq
	 U0r8xDmN3aD1CbjwDEiAQuwM2zAdN8/76o1ZWvf4cabfmfm122B0x7rTq/QXk28CNncs6
	 F92n5IgNka/fGK9yOLAkNrG1o3sOW1O2w4AhXdtf2DAPQOpwNGLWUBINbRYUDQcWXLYXX
	 UTPYM5s+pTygYvwKR0lV6BnrF4UI7bJOrmT8KV02aFroISrTipLqBDZjqutRNg0DzQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=pXksDHxz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA4C606A323;
	Sat, 24 Oct 2026 09:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=pXksDHxz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC9B51F031E2;
	Sat, 24 Oct 2026 09:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832538;
	bh=68M4FMENKnpLDuXzMIWRSsZ5vWP+TYWCgvIOLu60dtk=;
	h=Date:To:From:Subject;
	b=pXksDHxzvPQoImDkHg0ShqONsAepCPz2VAjsTPYrqMh8nc+ViYkTXUL5Wg+XME6sT
	 jowUny+6yqwDVFj3C53zizP9xCLw3OD36zc4PmQJOBJN9QxIm2ekkvLKhqxkUS85Xs
	 hsEk6bZDRRTmTy8a/ed7u4JA7Yum7xIeQuRXrFpU=
Date: Sat, 24 Oct 2026 02:02:18 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-filter-out-damos-address-filter-split-failed-region.patch removed from -mm tree
Message-Id: <20261024090218.CC9B51F031E2@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/damon/core: filter out damos address filter-split failed region
has been removed from the -mm tree.  Its filename was
     mm-damon-core-filter-out-damos-address-filter-split-failed-region.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


