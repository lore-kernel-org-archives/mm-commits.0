Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF0D29B8EF
	for <mm-commits@vger.kernel.org>; Sun, 28 Dec 2025 23:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766962923; cv=none; b=nNrLX4QIHVOeBBTR3Vhkt3BE+OGliP1S+x2U5vszsxshQv3QGSmCl7KngBU5628/+NTCTVmWX5F2AzLI1QqNPHRPWPQBQpi+AZcfjviRH6rv5JkbostemzNgoo41SWpK9XAWj4DeVHd/Tx2Comi0Foao/e87yFHS6tunLVLvcqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766962923; c=relaxed/simple;
	bh=KyyWJl6H/Z/UrkNCjC5Qy6slWvOqQX54M+6HqvTk/sg=;
	h=Date:To:From:Subject:Message-Id; b=Ae6ENixNE0evvOioqRiF4e1ZtY/MJDjJ7gIuz842uMf5I7kkMDawZYfGoyKzLQtThhC7V1jEP1DhGnJmp8mj4EZaPnF6+NM4zyE7mBNMI08WKj3p88MXRw67SRRKvuDMKS/JsPCFtpSC41CBdeaHbFH9bUafaw+JHSCeWbgp1UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a2JuTaHD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a2JuTaHD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36BD4C4CEFB;
	Sun, 28 Dec 2025 23:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766962923;
	bh=KyyWJl6H/Z/UrkNCjC5Qy6slWvOqQX54M+6HqvTk/sg=;
	h=Date:To:From:Subject:From;
	b=a2JuTaHDpqG8TBsPgWWYZGJmh6cGx26hp35uyGk6azBFgWz+S2tMvJ9NhGei1K93m
	 hsJbaqXRdqit9TIe0JIFCCfHFAbkygwGVktuYakfxy2sKOwgIhlUQKuS7ge6ebsoFK
	 HOXBDnx4K2srBUedmObR6k6mYM2LC09T1AWjDAR0=
Date: Sun, 28 Dec 2025 15:02:02 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,shu17az@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-tests-core-kunit-remove-a-redundant-test-case-and-add-a-new-test-case-in-damos_test_commit_quota_goal.patch added to mm-new branch
Message-Id: <20251228230203.36BD4C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/tests/core-kunit: remove a redundant test case and add a new test case in damos_test_commit_quota_goal()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-tests-core-kunit-remove-a-redundant-test-case-and-add-a-new-test-case-in-damos_test_commit_quota_goal.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-tests-core-kunit-remove-a-redundant-test-case-and-add-a-new-test-case-in-damos_test_commit_quota_goal.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Shu Anzai <shu17az@gmail.com>
Subject: mm/damon/tests/core-kunit: remove a redundant test case and add a new test case in damos_test_commit_quota_goal()
Date: Wed, 24 Dec 2025 04:22:00 +0000

Remove a redundant test case from damos_test_commit_quota_goal() as it is
already covered.  Instead, add a new test for DAMOS_QUOTA_SOME_MEM_PSI_US,
which was previously not tested.

Link: https://lkml.kernel.org/r/20251224042200.2061847-6-shu17az@gmail.com
Signed-off-by: Shu Anzai <shu17az@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-remove-a-redundant-test-case-and-add-a-new-test-case-in-damos_test_commit_quota_goal
+++ a/mm/damon/tests/core-kunit.h
@@ -600,9 +600,10 @@ static void damos_test_commit_quota_goal
 			});
 	damos_test_commit_quota_goal_for(test, &dst,
 			&(struct damos_quota_goal) {
-			.metric = DAMOS_QUOTA_USER_INPUT,
-			.target_value = 789,
-			.current_value = 12,
+			.metric = DAMOS_QUOTA_SOME_MEM_PSI_US,
+			.target_value = 234,
+			.current_value = 345,
+			.last_psi_total = 567,
 			});
 }
 
_

Patches currently in -mm which might be from shu17az@gmail.com are

mm-damon-tests-core-kunit-verify-the-age-field-in-damon_test_split_at.patch
mm-damon-tests-core-kunit-verify-the-age-and-nr_accesses_bp-fields-in-damon_test_merge_two.patch
mm-damon-tests-core-kunit-add-a-test-case-for-region-merge-size-limit-in-damon_test_merge_regions_of.patch
mm-damon-tests-core-kunit-add-test-cases-for-multiple-regions-in-damon_test_split_regions_of.patch
mm-damon-tests-core-kunit-remove-a-redundant-test-case-and-add-a-new-test-case-in-damos_test_commit_quota_goal.patch

