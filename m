Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23CA14373B
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291739; cv=none; b=K9v3v9hIjEmcWRrHcfpIHxfHgvbYgmbUUbYZmtg3Ce3O6DTGYJCL0ZR5JMinaes434lK/Zk/SMTP0oRVZhLPQirGtsChvNnoBhgfojZl/yY8svO0Bw4xebbI+T1vnf3daeTuvErVixpYkLM43zRA984zBu2tpYahkqctVchOmww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291739; c=relaxed/simple;
	bh=+DcmdsDOcrzjUDUItJT9z0vfoAQA+/ZXbRkmGfYQ/pQ=;
	h=Date:To:From:Subject:Message-Id; b=OlKVjbWwEbbat5gx+f95WrcLYi7J7l3WgkU1vZ1m5A5Yc11LFdsD6rgaI64C+ck7aBF7MCSURIsFRFYeCWs/qMKqoxo9vBZcvsvikxlUSc1zQIKRZXmU8Pe2Jk/KYA6rK4hOGs7OwyvBmyY4PxaIKU8spIm21DD0qxjbgdB/1ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OCxHx5IG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OCxHx5IG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7855CC32782;
	Tue, 25 Jun 2024 05:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291739;
	bh=+DcmdsDOcrzjUDUItJT9z0vfoAQA+/ZXbRkmGfYQ/pQ=;
	h=Date:To:From:Subject:From;
	b=OCxHx5IGLIF8zcWN0E78FgdRYtL1Xo0obRpKZF/euquYCxAA10ek9Lw8c0dt1C8wh
	 Lpwx8tZkLvb5NqHuR/zOxBcuY3o//Bva87O19GBJkpONQlh/Zly2DR9rXTzk6of/+e
	 qETqNj9vikuN0ya542Ue+H1RKsVmq1SW9xYUfyG8=
Date: Mon, 24 Jun 2024 22:02:18 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-rename-damon_sysfs_set_targets-to-add_targets.patch removed from -mm tree
Message-Id: <20240625050219.7855CC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: rename damon_sysfs_set_targets() to ...add_targets()
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-rename-damon_sysfs_set_targets-to-add_targets.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: rename damon_sysfs_set_targets() to ...add_targets()
Date: Tue, 18 Jun 2024 11:18:03 -0700

The function was for updating DAMON structs that may or may not be
partially populated.  Hence it was not for only adding items, but also
removing unnecessary items and updating items in-place.  A previous commit
has changed the function to assume the structs are not partially
populated, and do only adding items.  Make the function name better
explain the behavior.

Link: https://lkml.kernel.org/r/20240618181809.82078-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-test.h |    8 ++++----
 mm/damon/sysfs.c      |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-rename-damon_sysfs_set_targets-to-add_targets
+++ a/mm/damon/sysfs.c
@@ -1162,7 +1162,7 @@ destroy_targets_out:
 	return err;
 }
 
-static int damon_sysfs_set_targets(struct damon_ctx *ctx,
+static int damon_sysfs_add_targets(struct damon_ctx *ctx,
 		struct damon_sysfs_targets *sysfs_targets)
 {
 	int i, err;
@@ -1283,7 +1283,7 @@ static int damon_sysfs_apply_inputs(stru
 	err = damon_sysfs_set_attrs(ctx, sys_ctx->attrs);
 	if (err)
 		return err;
-	err = damon_sysfs_set_targets(ctx, sys_ctx->targets);
+	err = damon_sysfs_add_targets(ctx, sys_ctx->targets);
 	if (err)
 		return err;
 	return damon_sysfs_set_schemes(ctx, sys_ctx->schemes);
--- a/mm/damon/sysfs-test.h~mm-damon-sysfs-rename-damon_sysfs_set_targets-to-add_targets
+++ a/mm/damon/sysfs-test.h
@@ -38,7 +38,7 @@ static int __damon_sysfs_test_get_any_pi
 	return -1;
 }
 
-static void damon_sysfs_test_set_targets(struct kunit *test)
+static void damon_sysfs_test_add_targets(struct kunit *test)
 {
 	struct damon_sysfs_targets *sysfs_targets;
 	struct damon_sysfs_target *sysfs_target;
@@ -56,12 +56,12 @@ static void damon_sysfs_test_set_targets
 
 	ctx = damon_new_ctx();
 
-	damon_sysfs_set_targets(ctx, sysfs_targets);
+	damon_sysfs_add_targets(ctx, sysfs_targets);
 	KUNIT_EXPECT_EQ(test, 1u, nr_damon_targets(ctx));
 
 	sysfs_target->pid = __damon_sysfs_test_get_any_pid(
 			sysfs_target->pid + 1, 200);
-	damon_sysfs_set_targets(ctx, sysfs_targets);
+	damon_sysfs_add_targets(ctx, sysfs_targets);
 	KUNIT_EXPECT_EQ(test, 2u, nr_damon_targets(ctx));
 
 	damon_destroy_ctx(ctx);
@@ -71,7 +71,7 @@ static void damon_sysfs_test_set_targets
 }
 
 static struct kunit_case damon_sysfs_test_cases[] = {
-	KUNIT_CASE(damon_sysfs_test_set_targets),
+	KUNIT_CASE(damon_sysfs_test_add_targets),
 	{},
 };
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet.patch
docs-mm-damon-maintainer-profile-introduce-hackermail.patch
docs-mm-damon-maintainer-profile-document-damon-community-meetups.patch

