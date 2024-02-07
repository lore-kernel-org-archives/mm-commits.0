Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05A01CF9C
	for <mm-commits@vger.kernel.org>; Wed,  7 Feb 2024 22:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707346514; cv=none; b=rB09YgUfPDNPiF7IoUOiaeKxEQyFiVOzDBlI+ymPtOpUe7sI9EfoiegE499ua+a1V9URoqSo4FmMHP5JVQTNFmis4nkMWqpcptz4U9Poowo2v7sNjrMg1nWTN/DlGBZxHMLJdXG2kO2+Zrn9qhIU6DKhJ80tlOWuR7CBimLcjkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707346514; c=relaxed/simple;
	bh=hMRnpsSu3dAo9XoqUz06lkhnCQvEA7cZS1OIXTJPJBo=;
	h=Date:To:From:Subject:Message-Id; b=q/QPuiXFFkET6LecuPmVvLrjyipIUBfsCwwf6VGVTQSStdPOblZdfHpgBYTUx7357WM1j0ETBc0zC+RB3UZnNgSFA+5ME4jAQB+bWuqdZheg2Q5+pH5eP98DFED6Zo4QFoPL2ffCKohzYV/fVfF7sIwy6+wwPtGo5L2dPRIpWuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HR5+aBQg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HR5+aBQg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6524FC433F1;
	Wed,  7 Feb 2024 22:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707346513;
	bh=hMRnpsSu3dAo9XoqUz06lkhnCQvEA7cZS1OIXTJPJBo=;
	h=Date:To:From:Subject:From;
	b=HR5+aBQg4fp7WifLX1h2b4XYiZ2mnuBF2LNYLhzrpZtAGxMCEFZtfI7LccqoTI1iC
	 UOL5RuegTJ+bz9Z3d3BkPlxKUuryCNmvg73sZr9nV9BCEDH4R+aTFtRcWE56gydA7p
	 DFKiK9aRIoCa2wP+piuZ/VcqBajXEBgXvTXtQalM=
Date: Wed, 07 Feb 2024 14:55:12 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-add-a-test-for-damos-apply-intervals.patch added to mm-unstable branch
Message-Id: <20240207225513.6524FC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon: add a test for DAMOS apply intervals
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-add-a-test-for-damos-apply-intervals.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-add-a-test-for-damos-apply-intervals.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon: add a test for DAMOS apply intervals
Date: Wed, 7 Feb 2024 12:31:31 -0800

Add a selftest for DAMOS apply intervals.  It runs two schemes having
different apply interval agains an artificial memory access workload, and
check if the scheme with smaller apply interval was applied more
frequently.

Link: https://lkml.kernel.org/r/20240207203134.69976-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/Makefile                |    2 
 tools/testing/selftests/damon/damos_apply_interval.py |   67 ++++++++++
 2 files changed, 68 insertions(+), 1 deletion(-)

--- /dev/null
+++ a/tools/testing/selftests/damon/damos_apply_interval.py
@@ -0,0 +1,67 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0
+
+import subprocess
+import time
+
+import _damon_sysfs
+
+def main():
+    # access two 10 MiB memory regions, 2 second per each
+    sz_region = 10 * 1024 * 1024
+    proc = subprocess.Popen(['./access_memory', '2', '%d' % sz_region, '2000'])
+
+    # Set quota up to 1 MiB per 100 ms
+    kdamonds = _damon_sysfs.Kdamonds([_damon_sysfs.Kdamond(
+            contexts=[_damon_sysfs.DamonCtx(
+                ops='vaddr',
+                targets=[_damon_sysfs.DamonTarget(pid=proc.pid)],
+                schemes=[
+                    _damon_sysfs.Damos(
+                        access_pattern=_damon_sysfs.DamosAccessPattern(
+                            # >= 25% access rate, >= 200ms age
+                            nr_accesses=[5, 20], age=[2, 2**64 - 1]),
+                        # aggregation interval (100 ms) is used
+                        apply_interval_us=0),
+                    # use 10ms apply interval
+                    _damon_sysfs.Damos(
+                        access_pattern=_damon_sysfs.DamosAccessPattern(
+                            # >= 25% access rate, >= 200ms age
+                            nr_accesses=[5, 20], age=[2, 2**64 - 1]),
+                        # explicitly set 10 ms apply interval
+                        apply_interval_us=10 * 1000)
+                    ] # schemes
+                )] # contexts
+            )]) # kdamonds
+
+    err = kdamonds.start()
+    if err != None:
+        print('kdamond start failed: %s' % err)
+        exit(1)
+
+    wss_collected = []
+    nr_quota_exceeds = 0
+    while proc.poll() == None:
+        time.sleep(0.1)
+        err = kdamonds.kdamonds[0].update_schemes_stats()
+        if err != None:
+            print('stats update failed: %s' % err)
+            exit(1)
+    schemes = kdamonds.kdamonds[0].contexts[0].schemes
+    nr_tried_stats = [s.stats.nr_tried for s in schemes]
+    if nr_tried_stats[0] == 0 or nr_tried_stats[1] == 0:
+        print('scheme(s) are not tried')
+        exit(1)
+
+    # Because the second scheme was having the apply interval that is ten times
+    # lower than that of the first scheme, the second scheme should be tried
+    # about ten times more frequently than the first scheme.  For possible
+    # timing errors, check if it was at least nine times more freuqnetly tried.
+    ratio = nr_tried_stats[1] / nr_tried_stats[0]
+    if ratio < 9:
+        print('%d / %d = %f (< 9)' %
+              (nr_tried_stats[1], nr_tried_stats[0], ratio))
+        exit(1)
+
+if __name__ == '__main__':
+    main()
--- a/tools/testing/selftests/damon/Makefile~selftests-damon-add-a-test-for-damos-apply-intervals
+++ a/tools/testing/selftests/damon/Makefile
@@ -12,7 +12,7 @@ TEST_PROGS += debugfs_rm_non_contexts.sh
 TEST_PROGS += sysfs.sh sysfs_update_removed_scheme_dir.sh
 TEST_PROGS += sysfs_update_schemes_tried_regions_hang.py
 TEST_PROGS += sysfs_update_schemes_tried_regions_wss_estimation.py
-TEST_PROGS += damos_quota.py
+TEST_PROGS += damos_quota.py damos_apply_interval.py
 TEST_PROGS += reclaim.sh lru_sort.sh
 
 include ../lib.mk
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-fix-wrong-damos-tried-regions-update-timeout-setup.patch
mm-damon-core-check-apply-interval-in-damon_do_apply_schemes.patch
docs-admin-guide-mm-damon-usage-use-sysfs-interface-for-tracepoints-example.patch
mm-damon-rename-config_damon_dbgfs-to-damon_dbgfs_deprecated.patch
mm-damon-dbgfs-implement-deprecation-notice-file.patch
mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro.patch
docs-admin-guide-mm-damon-usage-document-deprecated-file-of-damon-debugfs-interface.patch
selftets-damon-prepare-for-monitor_on-file-renaming.patch
mm-damon-dbgfs-rename-monitor_on-file-to-monitor_on_deprecated.patch
docs-admin-guide-mm-damon-usage-update-for-monitor_on-renaming.patch
docs-translations-damon-usage-update-for-monitor_on-renaming.patch
mm-damon-sysfs-handle-state-file-inputs-for-every-sampling-interval-if-possible.patch
selftests-damon-_damon_sysfs-support-damos-quota.patch
selftests-damon-_damon_sysfs-support-damos-stats.patch
selftests-damon-_damon_sysfs-support-damos-apply-interval.patch
selftests-damon-add-a-test-for-damos-quota.patch
selftests-damon-add-a-test-for-damos-apply-intervals.patch
selftests-damon-add-a-test-for-a-race-between-target_ids_read-and-dbgfs_before_terminate.patch
selftests-damon-add-a-test-for-the-pid-leak-of-dbgfs_target_ids_write.patch
selftests-damon-_chk_dependency-get-debugfs-mount-point-from-proc-mounts.patch

