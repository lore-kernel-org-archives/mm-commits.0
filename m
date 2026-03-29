Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E52E325B2FA
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744874; cv=none; b=chRK19OCYW75P2pX7pRl6KBFxfcG6f34i5o7WMFGXl7CVLpMsOZJ0vwVJyRrxM38LJb5kMNUbmtmug57WKVr446KyaKTj3XVE4qkycapGmM28CbayJiTKCmkSkoSG0545Ud7J7+/DwDJoug6B66bXbgE46eNlOZjK1nnjoHNv+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744874; c=relaxed/simple;
	bh=WirapZcaySc0YGzPd5OnUDKRlAGxSvpidXrTgEhb3os=;
	h=Date:To:From:Subject:Message-Id; b=bmWd5oaDPBmd6BIGrRq/7HuEw5QgVb5kNfftX3h8oCsZx88wa+5aRZzZgaZ67lyFdfVSXXByMoe4ej9doNlbTsvWtoGHiMvzd0QpWou5/Nt5YDXxbF7/Gvwox+Fqp3ZPKeLtPnHwT+myXrVLJwJHSJ9XDjnVCDtLGmluZAFZt8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YhT0uwKH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YhT0uwKH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC39C4CEF7;
	Sun, 29 Mar 2026 00:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744873;
	bh=WirapZcaySc0YGzPd5OnUDKRlAGxSvpidXrTgEhb3os=;
	h=Date:To:From:Subject:From;
	b=YhT0uwKHPNUlpWgfpc2P49jCsQeVQwy+5OJnxLUmFMA8Gu7/ZZvWADr9MVZUDhLWE
	 4ptGTWhgbiogakBpFX+aMee/sksSOFQC+P2llwvweIKBAfI3Ue1zV4/ZRubeQruLgH
	 htW5fxQDR7E9gGxIzI/QzKLPXnA/5a2kO30lqXgU=
Date: Sat, 28 Mar 2026 17:41:13 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-core-kunit-test-goal_tuner-commit.patch removed from -mm tree
Message-Id: <20260329004113.BEC39C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/core-kunit: test goal_tuner commit
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-core-kunit-test-goal_tuner-commit.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/tests/core-kunit: test goal_tuner commit
Date: Mon, 9 Mar 2026 18:05:24 -0700

Extend damos_commit_quota() kunit test for the newly added goal_tuner
parameter.

Link: https://lkml.kernel.org/r/20260310010529.91162-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-test-goal_tuner-commit
+++ a/mm/damon/tests/core-kunit.h
@@ -693,6 +693,7 @@ static void damos_test_commit_quota(stru
 		.reset_interval = 1,
 		.ms = 2,
 		.sz = 3,
+		.goal_tuner = DAMOS_QUOTA_GOAL_TUNER_CONSIST,
 		.weight_sz = 4,
 		.weight_nr_accesses = 5,
 		.weight_age = 6,
@@ -701,6 +702,7 @@ static void damos_test_commit_quota(stru
 		.reset_interval = 7,
 		.ms = 8,
 		.sz = 9,
+		.goal_tuner = DAMOS_QUOTA_GOAL_TUNER_TEMPORAL,
 		.weight_sz = 10,
 		.weight_nr_accesses = 11,
 		.weight_age = 12,
@@ -714,6 +716,7 @@ static void damos_test_commit_quota(stru
 	KUNIT_EXPECT_EQ(test, dst.reset_interval, src.reset_interval);
 	KUNIT_EXPECT_EQ(test, dst.ms, src.ms);
 	KUNIT_EXPECT_EQ(test, dst.sz, src.sz);
+	KUNIT_EXPECT_EQ(test, dst.goal_tuner, src.goal_tuner);
 	KUNIT_EXPECT_EQ(test, dst.weight_sz, src.weight_sz);
 	KUNIT_EXPECT_EQ(test, dst.weight_nr_accesses, src.weight_nr_accesses);
 	KUNIT_EXPECT_EQ(test, dst.weight_age, src.weight_age);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch

