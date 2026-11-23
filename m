Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795454925;
	b=vL3O6Jcqxy6GhfqbpBubHfK2GUPP89wFGFm13hct6fKrD3OeURhgMegKdPE9IJH5ywqz
	 R5DytsYVC+BT6sTLm82vyK5d1NcaKElyhvtP3ZzuDGwRXLcLOXmLHmB/ZrfE242b61s+L
	 QK2XzmlZxlcVJ3bCPNVG994pzh7JTUqmOgVdwN6QtujuWTY4DFkk3wlZx7cA1YMYDOlQE
	 gO5ryyn9IuCJlqzKr7ghNROnJNZWtg1OZPW9gTQoNTSAOt8tcBgUkRAiO2p0Qt4jEqS9e
	 BPqo2byJT+XTDseNwuWmGN/iVIUNZFTdjgJxscfJw3UBUe4R8ccmMBcOhTy90jdqPXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795454925;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=bSg9HU106zbrPqoyjn1WJElcznsTHJVtKL2a1eXCryA=;
	b=PPBnmV97Egr8SC6rSRD3UkfJLpDnLbqQBJFFYzdpY4HjO1A185IDyI7w7mbWt/BDDxrD
	 gPDPH2B+JK4MlpK5PL6l2x+cJkGfmbziGfcldMWTLHUhnAIfW05PyAD6m/iIoB494Emgo
	 B2pthrS6mbRm7iux5EXrqtJkawO0lo01vN8MkjwGqlB5Rw4XBQ69X9NXOM5ta/TNDdJe4
	 4SN9CpBO2tYMDD/mL2jJch3ZYlMe1MnWEq7JpewcySzQZEktZYt7z1HZ4FWoTxV4cPwFs
	 6bAAfHzS25vlnyW1gCZjdv+wLnuYslJHvhOpO6f0gFkxWezlNY+02xmZayYs1911BHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=H6j7OPaA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9EF9606A31A
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 17:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=H6j7OPaA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAEE11F000C0;
	Mon, 23 Nov 2026 17:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795454925;
	bh=bSg9HU106zbrPqoyjn1WJElcznsTHJVtKL2a1eXCryA=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=H6j7OPaAQMmPnWhoScO2BM9I14tcmLYsqtzhvCC5f+4NNJ4Kct/UYrTRHNo8RVeNr
	 3G9P3JCInN19ZTWTOaSZURCJJCfW15ZS2n+XsuFdAIKFxS8LLw0dOmIqozZ/c48q9R
	 K+AB8l1gjkT6mqWTmpzVX2S6Jv54vpp1Fo6jbJUA=
Date: Mon, 23 Nov 2026 09:28:44 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,davidgow@davidgow.net,
	brendan.higgins@linux.dev,mattathias.pinchover@uber.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261123151309.82675-4-sj@kernel.org>
References: <20261123151309.82675-4-sj@kernel.org>
Subject: + mm-damon-tests-core-kunit-test-sz_ops_filter_passed_last.patch added to mm-new branch
Message-Id: <20261123172844.DAEE11F000C0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/tests/core-kunit: test sz_ops_filter_passed_last
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-tests-core-kunit-test-sz_ops_filter_passed_last.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-tests-core-kunit-test-sz_ops_filter_passed_last.patch

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
From: Mattathias Pinchover <mattathias.pinchover@uber.com>
Subject: mm/damon/tests/core-kunit: test sz_ops_filter_passed_last
Date: Mon, 23 Nov 2026 07:13:04 -0800

Add a kunit test for the sz_ops_filter_passed_last DAMOS
stat.  The test runs kdamond_apply_schemes() for multiple apply intervals
with a stub apply_scheme() operation that reports a given ops
filter-passed size, and checks that the stat is set to the value of the
last apply interval rather than the accumulated value, and that it is
kept unchanged until the next apply interval is completed.

Link: https://patch.msgid.link/20261123151309.82675-4-sj@kernel.org
Signed-off-by: Mattathias Pinchover <mattathias.pinchover@uber.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>

 mm/damon/tests/core-kunit.h |   93 ++++++++++++++++++++++++++++++++++
 1 file changed, 93 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-test-sz_ops_filter_passed_last
+++ a/mm/damon/tests/core-kunit.h
@@ -2632,6 +2632,98 @@ static void damon_test_last_region_quota
 	damon_destroy_ctx(ctx);
 }
 
+/* bytes that damos_test_apply_scheme_passed_stub() reports per region */
+static unsigned long damos_test_sz_passed;
+
+static unsigned long damos_test_apply_scheme_passed_stub(struct damon_ctx *c,
+		struct damon_target *t, struct damon_region *r,
+		struct damos *s, unsigned long *sz_filter_passed)
+{
+	*sz_filter_passed = damos_test_sz_passed;
+	return 0;
+}
+
+/* run one apply interval and return the last apply interval's passed bytes */
+static unsigned long damos_test_apply_interval(struct damon_ctx *c,
+		struct damos *s)
+{
+	c->passed_sample_intervals = s->next_apply_sis;
+	kdamond_apply_schemes(c);
+	return s->stat.sz_ops_filter_passed_last;
+}
+
+static void damos_test_sz_ops_filter_passed_last(struct kunit *test)
+{
+	struct damos_access_pattern pattern = {
+		.min_sz_region = 0,
+		.max_sz_region = ULONG_MAX,
+		.min_nr_accesses = 0,
+		.max_nr_accesses = UINT_MAX,
+		.min_age_region = 0,
+		.max_age_region = UINT_MAX,
+	};
+	struct damos_watermarks wmarks = {};
+	struct damos_quota quota = {};
+	struct damon_ctx *c;
+	struct damon_target *t;
+	struct damon_region *r;
+	struct damos *s;
+
+	c = damon_new_ctx();
+	if (!c)
+		kunit_skip(test, "ctx alloc fail");
+	c->ops.apply_scheme = damos_test_apply_scheme_passed_stub;
+
+	s = damon_new_scheme(&pattern, DAMOS_STAT, 0, &quota, &wmarks,
+			NUMA_NO_NODE);
+	if (!s) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "scheme alloc fail");
+	}
+	damos_set_filters_default_reject(s);
+	damon_add_scheme(c, s);
+
+	t = damon_new_target();
+	if (!t) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "target alloc fail");
+	}
+	damon_add_target(c, t);
+
+	r = damon_new_region(0, DAMON_MIN_REGION_SZ);
+	if (!r) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "region alloc fail");
+	}
+	damon_add_region(r, t);
+
+	KUNIT_EXPECT_EQ(test, s->stat.sz_ops_filter_passed_last, 0);
+
+	/* each value is for the last apply interval only, not cumulative */
+	damos_test_sz_passed = 1000;
+	KUNIT_EXPECT_EQ(test, damos_test_apply_interval(c, s), 1000);
+	KUNIT_EXPECT_EQ(test, damos_test_apply_interval(c, s), 1000);
+	KUNIT_EXPECT_EQ(test, s->stat.sz_ops_filter_passed, 2000);
+
+	damos_test_sz_passed = 300;
+	KUNIT_EXPECT_EQ(test, damos_test_apply_interval(c, s), 300);
+	KUNIT_EXPECT_EQ(test, s->stat.sz_ops_filter_passed, 2300);
+
+	damos_test_sz_passed = 0;
+	KUNIT_EXPECT_EQ(test, damos_test_apply_interval(c, s), 0);
+	KUNIT_EXPECT_EQ(test, s->stat.sz_ops_filter_passed, 2300);
+
+	/* not yet the time to apply, so the last value should be kept */
+	damos_test_sz_passed = 500;
+	damos_test_apply_interval(c, s);
+	c->passed_sample_intervals = s->next_apply_sis - 1;
+	kdamond_apply_schemes(c);
+	KUNIT_EXPECT_EQ(test, s->stat.sz_ops_filter_passed_last,
+			500);
+
+	damon_destroy_ctx(c);
+}
+
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_target),
 	KUNIT_CASE(damon_test_regions),
@@ -2678,6 +2770,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damon_test_rand),
 	KUNIT_CASE(damos_test_esz_goal_temporal),
 	KUNIT_CASE(damon_test_last_region_quota_reset),
+	KUNIT_CASE(damos_test_sz_ops_filter_passed_last),
 	{},
 };
 
_

Patches currently in -mm which might be from mattathias.pinchover@uber.com are

mm-damon-core-introduce-sz_ops_filter_passed_last-stat.patch
mm-damon-sysfs-schemes-add-sz_ops_filter_passed_last-file.patch
mm-damon-tests-core-kunit-test-sz_ops_filter_passed_last.patch
docs-mm-damon-design-update-for-sz_ops_filter_passed_last.patch
docs-admin-guide-mm-damon-usage-update-for-sz_ops_filter_passed_last.patch
docs-abi-damon-update-for-sz_ops_filter_passed_last.patch

