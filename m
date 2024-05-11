Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAF020B04
	for <mm-commits@vger.kernel.org>; Sat, 11 May 2024 22:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715467331; cv=none; b=NTP5mrSHP0hZ0HoVMvOMVKhtXlwPqqe1ms3aF0d9Z+eZOx2kYHGeHaUBs6lG5R8e+pI2Vv+Oss6Y3MNZC+LEI4nQZJ8D8OCZInytsZocyVcYJqfjdDBIxK1KbQ+E2lHvQOe8M+WEaQCsDlxXljn3Feqsh8q+gPO8RNBr6CsDnU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715467331; c=relaxed/simple;
	bh=v/XIMTQt9OWP+ezvUY2oazUZX8DaEql0FM2Lk8uRBTo=;
	h=Date:To:From:Subject:Message-Id; b=F6JgyYg2N8cGfoFhmoQaEmSv+9EtOdMc8/DSh1VH2aUXqkUpTJXDDxFxCQIrrDypfS94/HEgP7iCzeDEpLK2SOpPgzOfvXptwa+oPXaWcgyceFNp4Ap/Hu7bI03hIstKF3GYEXapP0eu4fZ0+KdQ/XOi2WoRtqpmdXQzoyeCr0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VtS/d72k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VtS/d72k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F04C32781;
	Sat, 11 May 2024 22:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715467331;
	bh=v/XIMTQt9OWP+ezvUY2oazUZX8DaEql0FM2Lk8uRBTo=;
	h=Date:To:From:Subject:From;
	b=VtS/d72kI82X/ASRkUXAR1dL2rxKZ/Er7+M5+G/9fNxiRlDSnqvWJBRPTGolOrKG5
	 dIXaYQekWbtTWUWZdKIr5mepOGm3jAt2Y6iMgkyEXBaBP7XwA7QJwy5qHpZdWE9YHX
	 bbSStj1AtwoqblWyc9qMGX5hR3OcF+vmlGTpHB7o=
Date: Sat, 11 May 2024 15:42:10 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-classify-tests-for-functionalities-and-regressions.patch removed from -mm tree
Message-Id: <20240511224210.E6F04C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon: classify tests for functionalities and regressions
has been removed from the -mm tree.  Its filename was
     selftests-damon-classify-tests-for-functionalities-and-regressions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon: classify tests for functionalities and regressions
Date: Fri, 3 May 2024 11:03:13 -0700

DAMON selftests can be classified into two categories: functionalities and
regressions.  Functionality tests are for checking if the function is
working as specified, while the regression tests are basically reproducers
of previously reported and fixed bugs.  The tests of the categories are
mixed in the selftests Makefile.  Separate those for easier understanding
of the types of tests.

Link: https://lkml.kernel.org/r/20240503180318.72798-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/Makefile |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/damon/Makefile~selftests-damon-classify-tests-for-functionalities-and-regressions
+++ a/tools/testing/selftests/damon/Makefile
@@ -7,16 +7,21 @@ TEST_GEN_FILES += debugfs_target_ids_pid
 TEST_GEN_FILES += access_memory
 
 TEST_FILES = _chk_dependency.sh _debugfs_common.sh
+
+# functionality tests
 TEST_PROGS = debugfs_attrs.sh debugfs_schemes.sh debugfs_target_ids.sh
+TEST_PROGS += sysfs.sh
+TEST_PROGS += sysfs_update_schemes_tried_regions_wss_estimation.py
+TEST_PROGS += damos_quota.py damos_quota_goal.py damos_apply_interval.py
+TEST_PROGS += reclaim.sh lru_sort.sh
+
+# regression tests (reproducers of previously found bugs)
 TEST_PROGS += debugfs_empty_targets.sh debugfs_huge_count_read_write.sh
 TEST_PROGS += debugfs_duplicate_context_creation.sh
 TEST_PROGS += debugfs_rm_non_contexts.sh
 TEST_PROGS += debugfs_target_ids_read_before_terminate_race.sh
 TEST_PROGS += debugfs_target_ids_pid_leak.sh
-TEST_PROGS += sysfs.sh sysfs_update_removed_scheme_dir.sh
+TEST_PROGS += sysfs_update_removed_scheme_dir.sh
 TEST_PROGS += sysfs_update_schemes_tried_regions_hang.py
-TEST_PROGS += sysfs_update_schemes_tried_regions_wss_estimation.py
-TEST_PROGS += damos_quota.py damos_quota_goal.py damos_apply_interval.py
-TEST_PROGS += reclaim.sh lru_sort.sh
 
 include ../lib.mk
_

Patches currently in -mm which might be from sj@kernel.org are


