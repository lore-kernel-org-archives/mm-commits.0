Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8ED523D3E9
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837204; cv=none; b=REyH05loRTFXQ2VUKQPFDI8sM/PPQzchUxc3wWkmSfwcTxfbonesCMcTmcF9ycG2E823zRSFFp9cE3t5xO4maYOvPNgitjMiKCL8Tl1b+jnBIAvoqdGeSU0BSTv4dSIBdH53HNtK42s7AIFWVPauke1kBXAV9DqBX3kLP4VInp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837204; c=relaxed/simple;
	bh=x8bU1GSV/EHPjMu/7YuWLczOnyVr2RI6uixBbHRRt88=;
	h=Date:To:From:Subject:Message-Id; b=H7lsR6aKiKX5HSgmOlgE76UI8mBtm6OYoDwGc73ja4M0prBSlqkD/qgwNDjQKkTQyttCQi/Ni7ch7B/Fqua2eE87ud1jpmivQxGIdRgFOtZDXPA5A4ADFiPD9aeytssTpBXC5qXSM8sq90T5dsX+3PGCz1CFN8CYQI7/0MKAWcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F7RQyqnp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F7RQyqnp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEDABC4CEDD;
	Tue, 14 Jan 2025 06:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837204;
	bh=x8bU1GSV/EHPjMu/7YuWLczOnyVr2RI6uixBbHRRt88=;
	h=Date:To:From:Subject:From;
	b=F7RQyqnp3KyGX1HjYHCoHEd+pPmcv/FfsMCT0wjz1xRaGF33K94VY6HmU0DN0xTAQ
	 vT0Wk+UgzsshNmA6mpyDZnMLTxo4S473Z7yfEoYYbH/D5y4SSUC6DtzZHc4AvoFHnn
	 Fz+vXUN1cqmtPMd1C7om+6aX0ZVvttIh5m26iSPk=
Date: Mon, 13 Jan 2025 22:46:44 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-support-damos_filter-allow.patch removed from -mm tree
Message-Id: <20250114064644.AEDABC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: support damos_filter->allow
has been removed from the -mm tree.  Its filename was
     mm-damon-core-support-damos_filter-allow.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: support damos_filter->allow
Date: Thu, 9 Jan 2025 09:51:19 -0800

DAMOS filters supports allowing behavior, but the core layer's DAMOS
filters handling logic still assumes only rejecting (filtering-out)
behavior.  Update the logic to aware of and respect the behavioral
decision by reading damos_filter->allow when making the decision to
exclude a region or not.

Link: https://lkml.kernel.org/r/20250109175126.57878-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c             |    6 +++---
 mm/damon/tests/core-kunit.h |   10 +++++-----
 2 files changed, 8 insertions(+), 8 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-support-damos_filter-allow
+++ a/mm/damon/core.c
@@ -1374,7 +1374,7 @@ static void damos_update_stat(struct dam
 	s->stat.sz_ops_filter_passed += sz_ops_filter_passed;
 }
 
-static bool __damos_filter_out(struct damon_ctx *ctx, struct damon_target *t,
+static bool damos_filter_match(struct damon_ctx *ctx, struct damon_target *t,
 		struct damon_region *r, struct damos_filter *filter)
 {
 	bool matched = false;
@@ -1428,8 +1428,8 @@ static bool damos_filter_out(struct damo
 	struct damos_filter *filter;
 
 	damos_for_each_filter(filter, s) {
-		if (__damos_filter_out(ctx, t, r, filter))
-			return true;
+		if (damos_filter_match(ctx, t, r, filter))
+			return !filter->allow;
 	}
 	return false;
 }
--- a/mm/damon/tests/core-kunit.h~mm-damon-core-support-damos_filter-allow
+++ a/mm/damon/tests/core-kunit.h
@@ -434,25 +434,25 @@ static void damos_test_filter_out(struct
 	damon_add_region(r, t);
 
 	/* region in the range */
-	KUNIT_EXPECT_TRUE(test, __damos_filter_out(NULL, t, r, f));
+	KUNIT_EXPECT_TRUE(test, damos_filter_match(NULL, t, r, f));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region before the range */
 	r->ar.start = DAMON_MIN_REGION * 1;
 	r->ar.end = DAMON_MIN_REGION * 2;
-	KUNIT_EXPECT_FALSE(test, __damos_filter_out(NULL, t, r, f));
+	KUNIT_EXPECT_FALSE(test, damos_filter_match(NULL, t, r, f));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region after the range */
 	r->ar.start = DAMON_MIN_REGION * 6;
 	r->ar.end = DAMON_MIN_REGION * 8;
-	KUNIT_EXPECT_FALSE(test, __damos_filter_out(NULL, t, r, f));
+	KUNIT_EXPECT_FALSE(test, damos_filter_match(NULL, t, r, f));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region started before the range */
 	r->ar.start = DAMON_MIN_REGION * 1;
 	r->ar.end = DAMON_MIN_REGION * 4;
-	KUNIT_EXPECT_FALSE(test, __damos_filter_out(NULL, t, r, f));
+	KUNIT_EXPECT_FALSE(test, damos_filter_match(NULL, t, r, f));
 	/* filter should have split the region */
 	KUNIT_EXPECT_EQ(test, r->ar.start, DAMON_MIN_REGION * 1);
 	KUNIT_EXPECT_EQ(test, r->ar.end, DAMON_MIN_REGION * 2);
@@ -465,7 +465,7 @@ static void damos_test_filter_out(struct
 	/* region started in the range */
 	r->ar.start = DAMON_MIN_REGION * 2;
 	r->ar.end = DAMON_MIN_REGION * 8;
-	KUNIT_EXPECT_TRUE(test, __damos_filter_out(NULL, t, r, f));
+	KUNIT_EXPECT_TRUE(test, damos_filter_match(NULL, t, r, f));
 	/* filter should have split the region */
 	KUNIT_EXPECT_EQ(test, r->ar.start, DAMON_MIN_REGION * 2);
 	KUNIT_EXPECT_EQ(test, r->ar.end, DAMON_MIN_REGION * 6);
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch

