Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED12234971
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837207; cv=none; b=gHoFWkgrw26fQNPw/9iIPEWzzP8Kqsje+ejx1eUKdr86Q9i92hlvxdUXoXbB8BrynAaJwqYK3pwz8jbcT1VIq2xaQm0yFXApxbB/rO8QHOxkz7wJ8w/ntGhYzCjh3HSaQp5UzASvYURPT4+3Dy3I983R5JzwxWhW3K+LJSYkHYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837207; c=relaxed/simple;
	bh=zRudwJTGR2GARigOBoCghjeCGrffFp/tojoLRvrbeZ0=;
	h=Date:To:From:Subject:Message-Id; b=QQ8xqpsaehQvXrctblESPorPsYZyI88Bc87TuO4Elw6uaTUWmayQ6cuquCxWB3V7q0ytVjjHyQiTAElzrhi9mGis1H2ZKH+VwU20q3We7e9eicwGeg6DVdc+rkXu4KbB5kWurkVX1nlEUSqrvES3zyCDe5dzTo+z15boNe4qlEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WTgimq9h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WTgimq9h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C498DC4CEDD;
	Tue, 14 Jan 2025 06:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837206;
	bh=zRudwJTGR2GARigOBoCghjeCGrffFp/tojoLRvrbeZ0=;
	h=Date:To:From:Subject:From;
	b=WTgimq9hyvQ0AkuRG2p38TdYJAs16cttrMhleFhu2ZVdyRffOL5n9H3iSutSIIney
	 rYLW0YW3yoXoevQ/SgAaYwGkc8ZR2pMLMpHIK88rg1domW+TMbSlB0uq7WXW7o4EpN
	 siwQV30Hftuw+Z34Wkq8iYIJ4YtaxnXKJUQEP79o=
Date: Mon, 13 Jan 2025 22:46:46 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-add-allow-argument-to-damos_new_filter.patch removed from -mm tree
Message-Id: <20250114064646.C498DC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: add 'allow' argument to damos_new_filter()
has been removed from the -mm tree.  Its filename was
     mm-damon-add-allow-argument-to-damos_new_filter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: add 'allow' argument to damos_new_filter()
Date: Thu, 9 Jan 2025 09:51:21 -0800

DAMON API users should set damos_filter->allow manually to use a DAMOS
allow-filter, since damos_new_filter() unsets the field always.  It is
cumbersome and easy to mistake.  Add an arugment for setting the field to
damos_new_filter().

Link: https://lkml.kernel.org/r/20250109175126.57878-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h       |    2 +-
 mm/damon/core.c             |    7 ++++---
 mm/damon/paddr.c            |    3 ++-
 mm/damon/reclaim.c          |    2 +-
 mm/damon/sysfs-schemes.c    |    2 +-
 mm/damon/tests/core-kunit.h |    4 ++--
 6 files changed, 11 insertions(+), 9 deletions(-)

--- a/include/linux/damon.h~mm-damon-add-allow-argument-to-damos_new_filter
+++ a/include/linux/damon.h
@@ -801,7 +801,7 @@ void damon_update_region_access_rate(str
 		struct damon_attrs *attrs);
 
 struct damos_filter *damos_new_filter(enum damos_filter_type type,
-		bool matching);
+		bool matching, bool allow);
 void damos_add_filter(struct damos *s, struct damos_filter *f);
 void damos_destroy_filter(struct damos_filter *f);
 
--- a/mm/damon/core.c~mm-damon-add-allow-argument-to-damos_new_filter
+++ a/mm/damon/core.c
@@ -266,7 +266,7 @@ int damon_set_regions(struct damon_targe
 }
 
 struct damos_filter *damos_new_filter(enum damos_filter_type type,
-		bool matching)
+		bool matching, bool allow)
 {
 	struct damos_filter *filter;
 
@@ -275,7 +275,7 @@ struct damos_filter *damos_new_filter(en
 		return NULL;
 	filter->type = type;
 	filter->matching = matching;
-	filter->allow = false;
+	filter->allow = allow;
 	INIT_LIST_HEAD(&filter->list);
 	return filter;
 }
@@ -806,7 +806,8 @@ static int damos_commit_filters(struct d
 			continue;
 
 		new_filter = damos_new_filter(
-				src_filter->type, src_filter->matching);
+				src_filter->type, src_filter->matching,
+				src_filter->allow);
 		if (!new_filter)
 			return -ENOMEM;
 		damos_commit_filter_arg(new_filter, src_filter);
--- a/mm/damon/paddr.c~mm-damon-add-allow-argument-to-damos_new_filter
+++ a/mm/damon/paddr.c
@@ -259,7 +259,8 @@ static unsigned long damon_pa_pageout(st
 		}
 	}
 	if (install_young_filter) {
-		filter = damos_new_filter(DAMOS_FILTER_TYPE_YOUNG, true);
+		filter = damos_new_filter(
+				DAMOS_FILTER_TYPE_YOUNG, true, false);
 		if (!filter)
 			return 0;
 		damos_add_filter(s, filter);
--- a/mm/damon/reclaim.c~mm-damon-add-allow-argument-to-damos_new_filter
+++ a/mm/damon/reclaim.c
@@ -221,7 +221,7 @@ static int damon_reclaim_apply_parameter
 	}
 
 	if (skip_anon) {
-		filter = damos_new_filter(DAMOS_FILTER_TYPE_ANON, true);
+		filter = damos_new_filter(DAMOS_FILTER_TYPE_ANON, true, false);
 		if (!filter)
 			goto out;
 		damos_add_filter(scheme, filter);
--- a/mm/damon/sysfs-schemes.c~mm-damon-add-allow-argument-to-damos_new_filter
+++ a/mm/damon/sysfs-schemes.c
@@ -1901,7 +1901,7 @@ static int damon_sysfs_add_scheme_filter
 			sysfs_filters->filters_arr[i];
 		struct damos_filter *filter =
 			damos_new_filter(sysfs_filter->type,
-					sysfs_filter->matching);
+					sysfs_filter->matching, false);
 		int err;
 
 		if (!filter)
--- a/mm/damon/tests/core-kunit.h~mm-damon-add-allow-argument-to-damos_new_filter
+++ a/mm/damon/tests/core-kunit.h
@@ -411,7 +411,7 @@ static void damos_test_new_filter(struct
 {
 	struct damos_filter *filter;
 
-	filter = damos_new_filter(DAMOS_FILTER_TYPE_ANON, true);
+	filter = damos_new_filter(DAMOS_FILTER_TYPE_ANON, true, false);
 	KUNIT_EXPECT_EQ(test, filter->type, DAMOS_FILTER_TYPE_ANON);
 	KUNIT_EXPECT_EQ(test, filter->matching, true);
 	KUNIT_EXPECT_PTR_EQ(test, filter->list.prev, &filter->list);
@@ -425,7 +425,7 @@ static void damos_test_filter_out(struct
 	struct damon_region *r, *r2;
 	struct damos_filter *f;
 
-	f = damos_new_filter(DAMOS_FILTER_TYPE_ADDR, true);
+	f = damos_new_filter(DAMOS_FILTER_TYPE_ADDR, true, false);
 	f->addr_range = (struct damon_addr_range){
 		.start = DAMON_MIN_REGION * 2, .end = DAMON_MIN_REGION * 6};
 
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch

