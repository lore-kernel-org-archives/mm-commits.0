Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A4B1DDD5
	for <mm-commits@vger.kernel.org>; Wed,  7 Feb 2024 22:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707346512; cv=none; b=QFMa+7KfMeLDZNFO5SiqLcpjg8T6Y1gEADx8j/Jit65+J3a7d4tyBq3tQvqkt7Bes7Bd7dhdF59QWasISwqUap+qCv/gof+sYLd8PGtS+CHTDCDP2aQV//p4KM/x9SrnW/xFkO3f9LcYXZu9AICaWndVxhqWKaaFOLnRbYDw/vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707346512; c=relaxed/simple;
	bh=B0eY9UVwaS8sNIh00YfrDbOflTwOTfZI91JRGkqVpWA=;
	h=Date:To:From:Subject:Message-Id; b=BIF6fFmF0ddseUV9RHPILPi4MJVjyHZcbMtnu9AuFv1aqWlD7rhkfY7a72aLW+rhb0emkoP+6hWsx/dtj7tWLqMKEKjqGlyRcN3EYO0rOO4PkDY9NqGsPRf3iKgmQ2pAnPoYEdgbAjj6r6wZ+C1O06LYdMg6F0q0zHWppHuoxZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W1XkvTZi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W1XkvTZi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 847DDC43390;
	Wed,  7 Feb 2024 22:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707346511;
	bh=B0eY9UVwaS8sNIh00YfrDbOflTwOTfZI91JRGkqVpWA=;
	h=Date:To:From:Subject:From;
	b=W1XkvTZiWwnzIXZbWRciiqrUpFhFrJMDvqC8kLUL78Wy8gvOSKeHZAs8aruEKexyr
	 nJ2djH6x6Xq0zbCNefiP3K83IPHA+IjiRojmJV+Ojk3dw6Yo2Fa23ukr7T4vzDN0Jn
	 kktdS/yJruT3Gy/fSCCbpV0fCWLx3ajbjtbLvrso=
Date: Wed, 07 Feb 2024 14:55:11 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-add-a-test-for-damos-quota.patch added to mm-unstable branch
Message-Id: <20240207225511.847DDC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon: add a test for DAMOS quota
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-add-a-test-for-damos-quota.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-add-a-test-for-damos-quota.patch

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
Subject: selftests/damon: add a test for DAMOS quota
Date: Wed, 7 Feb 2024 12:31:30 -0800

Add a selftest for verifying the DAMOS quota feature.  The test is very
similar to sysfs_update_schemes_tried_regions_wss_estimation.py.  It
starts an artificial workload of 20 MiB working set, run DAMON to find the
working set size, but with 1 MiB/100 ms size quota.  Then, it collect the
DAMON-found working set size every 100 ms and check if the quota was
always applied as expected.  For the confirmation, the tests shows the
stat-applied region size and the qt_exceeds stat.

Link: https://lkml.kernel.org/r/20240207203134.69976-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/Makefile       |    1 
 tools/testing/selftests/damon/damos_quota.py |   67 +++++++++++++++++
 2 files changed, 68 insertions(+)

--- /dev/null
+++ a/tools/testing/selftests/damon/damos_quota.py
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
+    sz_quota = 1024 * 1024 # 1 MiB
+    quota_reset_interval = 100 # 100 ms
+    kdamonds = _damon_sysfs.Kdamonds([_damon_sysfs.Kdamond(
+            contexts=[_damon_sysfs.DamonCtx(
+                ops='vaddr',
+                targets=[_damon_sysfs.DamonTarget(pid=proc.pid)],
+                schemes=[_damon_sysfs.Damos(
+                    access_pattern=_damon_sysfs.DamosAccessPattern(
+                        # >= 25% access rate, >= 200ms age
+                        nr_accesses=[5, 20], age=[2, 2**64 - 1]),
+                    quota=_damon_sysfs.DamosQuota(
+                        sz=sz_quota, reset_interval_ms=quota_reset_interval)
+                    )] # schemes
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
+        err = kdamonds.kdamonds[0].update_schemes_tried_bytes()
+        if err != None:
+            print('tried bytes update failed: %s' % err)
+            exit(1)
+        err = kdamonds.kdamonds[0].update_schemes_stats()
+        if err != None:
+            print('stats update failed: %s' % err)
+            exit(1)
+
+        scheme = kdamonds.kdamonds[0].contexts[0].schemes[0]
+        wss_collected.append(scheme.tried_bytes)
+        nr_quota_exceeds = scheme.stats.qt_exceeds
+
+    wss_collected.sort()
+    for wss in wss_collected:
+        if wss > sz_quota:
+            print('quota is not kept: %s > %s' % (wss, sz_quota))
+            print('collected samples are as below')
+            print('\n'.join(['%d' % wss for wss in wss_collected]))
+            exit(1)
+
+    if nr_quota_exceeds < len(wss_collected):
+        print('quota is not always exceeded: %d > %d' %
+              (len(wss_collected), nr_quota_exceeds))
+        exit(1)
+
+if __name__ == '__main__':
+    main()
--- a/tools/testing/selftests/damon/Makefile~selftests-damon-add-a-test-for-damos-quota
+++ a/tools/testing/selftests/damon/Makefile
@@ -12,6 +12,7 @@ TEST_PROGS += debugfs_rm_non_contexts.sh
 TEST_PROGS += sysfs.sh sysfs_update_removed_scheme_dir.sh
 TEST_PROGS += sysfs_update_schemes_tried_regions_hang.py
 TEST_PROGS += sysfs_update_schemes_tried_regions_wss_estimation.py
+TEST_PROGS += damos_quota.py
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

