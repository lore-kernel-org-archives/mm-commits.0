Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80151210FB
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Qs69Q3f5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06596C433C8;
	Tue, 12 Dec 2023 18:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407200;
	bh=7R9Z8gUxKti9H5yGnUzL0xbjYPNv06rYqu3v7+L0ChA=;
	h=Date:To:From:Subject:From;
	b=Qs69Q3f5UzMoZjZcDqCqGwEJOXX5/f+xSX75U6I88Qgx/YwumEZ6eZHCr1BeGfEmJ
	 7R+oqnaCKRHt6MBK0tLsp/c9TesEnmC1YawL66KI6knB0TIGSslfABak1EHh8i/2yv
	 rgUna1yfVDRObI6jNP+N/2mvswnl683joEZiFHGM=
Date: Tue, 12 Dec 2023 10:53:19 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,corbet@lwn.net,brendanhiggins@google.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-damon-core-implement-goal-oriented-feedback-driven-quota-auto-tuning-fix.patch removed from -mm tree
Message-Id: <20231212185320.06596C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: document get_score_arg field of struct damos_quota
has been removed from the -mm tree.  Its filename was
     mm-damon-core-implement-goal-oriented-feedback-driven-quota-auto-tuning-fix.patch

This patch was dropped because it was folded into mm-damon-core-implement-goal-oriented-feedback-driven-quota-auto-tuning.patch

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: document get_score_arg field of struct damos_quota
Date: Mon, 4 Dec 2023 17:01:06 +0000

Commit 99b36eab9c05 ("mm/damon/core: implement goal-oriented
feedback-driven quota auto-tuning") on mm-unstable missed documenting
'get_score_arg' field of 'struct damos_quota' on the kernel-doc comment. 
Fix it.

Link: https://lkml.kernel.org/r/20231204170106.60992-1-sj@kernel.org
Fixes: 99b36eab9c05 ("mm/damon/core: implement goal-oriented feedback-driven quota auto-tuning") on mm-unstable
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Gow <davidgow@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-implement-goal-oriented-feedback-driven-quota-auto-tuning-fix
+++ a/include/linux/damon.h
@@ -137,6 +137,7 @@ enum damos_action {
  * @weight_age:		Weight of the region's age for prioritization.
  *
  * @get_score:		Feedback function for self-tuning quota.
+ * @get_score_arg:	Parameter for @get_score
  *
  * To avoid consuming too much CPU time or IO resources for applying the
  * &struct damos->action to large memory, DAMON allows users to set time and/or
@@ -156,10 +157,10 @@ enum damos_action {
  * &weight_nr_accesses, and &weight_age, because monitoring operations are
  * encouraged to respect those.
  *
- * If @get_score function pointer is set, DAMON calls it back and get the
- * return value of it for every @reset_interval.  Then, DAMON adjusts the
- * effective quota using the return value as a feedback score to the current
- * quota, using its internal feedback loop algorithm.
+ * If @get_score function pointer is set, DAMON calls it back with
+ * @get_score_arg and get the return value of it for every @reset_interval.
+ * Then, DAMON adjusts the effective quota using the return value as a feedback
+ * score to the current quota, using its internal feedback loop algorithm.
  *
  * The feedback loop algorithem assumes the quota input and the feedback score
  * output are in a positive proportional relationship, and the goal of the
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-make-damon_start-waits-until-kdamond_fn-starts.patch
mm-damon-core-implement-goal-oriented-feedback-driven-quota-auto-tuning.patch
mm-damon-sysfs-schemes-implement-files-for-scheme-quota-goals-setup.patch
mm-damon-sysfs-schemes-commit-damos-quota-goals-user-input-to-damos.patch
mm-damon-sysfs-schemes-implement-a-command-for-scheme-quota-goals-only-commit.patch
mm-damon-core-test-add-a-unit-test-for-the-feedback-loop-algorithm.patch
selftests-damon-test-quota-goals-directory.patch
docs-mm-damon-design-document-damos-quota-auto-tuning.patch
docs-abi-damon-document-damos-quota-goals.patch
docs-admin-guide-mm-damon-usage-document-for-quota-goals.patch

