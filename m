Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E50286420
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126359; cv=none; b=uDbvHgAgI6QQi7rP1abNHUUm3RlWKBUx+6c/R8jLbdINDc9l0j7spEujuPHTRxT/Y7XPLH08CXXYKInVuyzbb/J2sxvngs5qJHojfkvrDJV8/uuOC9lyIGSTM6Fyrqv5xGtUy2Y5a3dzDSC5XuzxYqaMF6uPc+DL/V6P9uG8JoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126359; c=relaxed/simple;
	bh=fD21bAy1RVqUIBGd67oNeB10vivc5pGAb4Cj0a18Tk4=;
	h=Date:To:From:Subject:Message-Id; b=cbvfwXd5j8ppAhq7VIyJDGdixsG2xGg1eTbrbhDzM5MBxQfsq7SGPKftiRI2cYe/TKk1FdINrdwOrIfvoUiQKEz2JErFVVfFF0z97LZTK26qXy0zwcHO+oAFQP1qX8GDiEAsgS6VlOGrGABZyCHGkaYc/FwVtCuiseJS7wL4e9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qmgSv1bf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qmgSv1bf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEBF4C4CEE3;
	Thu, 10 Jul 2025 05:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126358;
	bh=fD21bAy1RVqUIBGd67oNeB10vivc5pGAb4Cj0a18Tk4=;
	h=Date:To:From:Subject:From;
	b=qmgSv1bfurPAKGcW2+go7ZtX3BcVQb4+0m7cauwts11cKSFFy2xa6658uOLxBmVR3
	 93SovKNB46sgNwsc0z1LwEWBc/mjjtES2+mR3yx/PXTnjD6aLfsstFCFYjDlf//olA
	 dcgRE9G4HghpO5hdAyM0gmrdotrABoSYArmnFvD0=
Date: Wed, 09 Jul 2025 22:45:58 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftets-damon-add-a-test-for-memcg_path-leak.patch removed from -mm tree
Message-Id: <20250710054558.BEBF4C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftets/damon: add a test for memcg_path leak
has been removed from the -mm tree.  Its filename was
     selftets-damon-add-a-test-for-memcg_path-leak.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftets/damon: add a test for memcg_path leak
Date: Thu, 19 Jun 2025 11:36:08 -0700

There was a memory leak bug in DAMOS sysfs memcg_path file.  Add a
selftest to ensure the bug never comes back.

Link: https://lkml.kernel.org/r/20250619183608.6647-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/Makefile                 |    1 
 tools/testing/selftests/damon/sysfs_memcg_path_leak.sh |   43 ++++++++++
 2 files changed, 44 insertions(+)

--- a/tools/testing/selftests/damon/Makefile~selftets-damon-add-a-test-for-memcg_path-leak
+++ a/tools/testing/selftests/damon/Makefile
@@ -15,6 +15,7 @@ TEST_PROGS += reclaim.sh lru_sort.sh
 # regression tests (reproducers of previously found bugs)
 TEST_PROGS += sysfs_update_removed_scheme_dir.sh
 TEST_PROGS += sysfs_update_schemes_tried_regions_hang.py
+TEST_PROGS += sysfs_memcg_path_leak.sh
 
 EXTRA_CLEAN = __pycache__
 
diff --git a/tools/testing/selftests/damon/sysfs_memcg_path_leak.sh a/tools/testing/selftests/damon/sysfs_memcg_path_leak.sh
new file mode 100755
--- /dev/null
+++ a/tools/testing/selftests/damon/sysfs_memcg_path_leak.sh
@@ -0,0 +1,43 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+if [ $EUID -ne 0 ]
+then
+	echo "Run as root"
+	exit $ksft_skip
+fi
+
+damon_sysfs="/sys/kernel/mm/damon/admin"
+if [ ! -d "$damon_sysfs" ]
+then
+	echo "damon sysfs not found"
+	exit $ksft_skip
+fi
+
+# ensure filter directory
+echo 1 > "$damon_sysfs/kdamonds/nr_kdamonds"
+echo 1 > "$damon_sysfs/kdamonds/0/contexts/nr_contexts"
+echo 1 > "$damon_sysfs/kdamonds/0/contexts/0/schemes/nr_schemes"
+echo 1 > "$damon_sysfs/kdamonds/0/contexts/0/schemes/0/filters/nr_filters"
+
+filter_dir="$damon_sysfs/kdamonds/0/contexts/0/schemes/0/filters/0"
+
+before_kb=$(grep Slab /proc/meminfo | awk '{print $2}')
+
+# try to leak 3000 KiB
+for i in {1..102400};
+do
+	echo "012345678901234567890123456789" > "$filter_dir/memcg_path"
+done
+
+after_kb=$(grep Slab /proc/meminfo | awk '{print $2}')
+# expect up to 1500 KiB free from other tasks memory
+expected_after_kb_max=$((before_kb + 1500))
+
+if [ "$after_kb" -gt "$expected_after_kb_max" ]
+then
+	echo "maybe memcg_path are leaking: $before_kb -> $after_kb"
+	exit 1
+else
+	exit 0
+fi
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-add-drgn-script-for-extracting-damon-status.patch
selftests-damon-_damon_sysfs-set-kdamondpid-in-start.patch
selftests-damon-add-python-and-drgn-based-damon-sysfs-test.patch
selftests-damon-sysfspy-test-monitoring-attribute-parameters.patch
selftests-damon-sysfspy-test-adaptive-targets-parameter.patch
selftests-damon-sysfspy-test-damos-schemes-parameters-setup.patch
mm-damon-add-trace-event-for-auto-tuned-monitoring-intervals.patch
mm-damon-add-trace-event-for-effective-size-quota.patch
mm-damon-add-trace-event-for-effective-size-quota-fix.patch
mm-damon-add-trace-event-for-effective-size-quota-fix-2.patch
samples-damon-wsse-fix-boot-time-enable-handling.patch
samples-damon-prcl-fix-boot-time-enable-crash.patch
samples-damon-mtier-support-boot-time-enable-setup.patch
mm-damon-reclaim-reset-enabled-when-damon-start-failed.patch
mm-damon-lru_sort-reset-enabled-when-damon-start-failed.patch
mm-damon-reclaim-use-parameter-context-correctly.patch
samples-damon-wsse-rename-to-have-damon_sample_-prefix.patch
samples-damon-prcl-rename-to-have-damon_sample_-prefix.patch
samples-damon-mtier-rename-to-have-damon_sample_-prefix.patch
mm-damon-sysfs-use-damon-core-api-damon_is_running.patch
mm-damon-sysfs-dont-hold-kdamond_lock-in-before_terminate.patch
docs-mm-damon-maintainer-profile-update-for-mm-new-tree.patch
mm-damon-add-struct-damos_migrate_dests.patch
mm-damon-core-add-damos-migrate_dests-field.patch
mm-damon-sysfs-schemes-implement-damos-action-destinations-directory.patch
mm-damon-sysfs-schemes-set-damos-migrate_dests.patch
docs-abi-damon-document-schemes-dests-directory.patch
docs-admin-guide-mm-damon-usage-document-dests-directory.patch

