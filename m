Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3410115E81
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628308; cv=none; b=J5R0L2z6VrJi3/cEOXSemkxqxaMvGiQNPCLgKbBC3ToEWgeQrqpD4Iz2osxXx0WOiTJqkC4ZSfOvLTlm+ugpQeFMw+ikOZydExGZrUFlRBHBTnlPEjASD1hCSdUStDEuw7HU0A697OVN/dEJg69Af8Ucks6H2q817sMGWst/vew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628308; c=relaxed/simple;
	bh=8U9lz/iSlxBp10E0Sh1Pyc1RfuwvI79gbdHCgnGPiJU=;
	h=Date:To:From:Subject:Message-Id; b=lKeRQSE8T0OR6QZEWGlD32KLIYjsJ4sUeV8ovbi54Vz1Bg2GYWW4p/ZxXMd1JKoxXvz6sAGwddF+rKPxA7gz1Rjj4M3LQsPNYcaUIcrDg2gh6PsIdNNXUoWH3Fr8EtXdg0nBFDNpoJTETDfHjCz/TOKBBNQF7PDOTdxYx7sUyfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WnQbhE53; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WnQbhE53"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040F8C116B1;
	Sat, 29 Jun 2024 02:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628308;
	bh=8U9lz/iSlxBp10E0Sh1Pyc1RfuwvI79gbdHCgnGPiJU=;
	h=Date:To:From:Subject:From;
	b=WnQbhE53zQ1L5q+8d4Z5uEVPkCS+EcWVN1Wo/U1TzFIpSp804ajQ6YyblCeNU2kiF
	 cuZkMQr72NoQ1X6/PGxLOjVB9if8kUC4HUUWB9UCWu4hR4T0Hdelu/NwJDjnVeRCEo
	 ug1L20j7rR536tUfuRh+auoH8ULPJSD/Lx6CiSGU=
Date: Fri, 28 Jun 2024 19:31:47 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-implement-damos-tried-regions-test.patch removed from -mm tree
Message-Id: <20240629023148.040F8C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon: implement DAMOS tried regions test
has been removed from the -mm tree.  Its filename was
     selftests-damon-implement-damos-tried-regions-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon: implement DAMOS tried regions test
Date: Tue, 25 Jun 2024 11:05:34 -0700

Implement a test for DAMOS tried regions command of DAMON sysfs interface.
It ensures the expected number of monitoring regions are created using an
artificial memory access pattern generator program.

Link: https://lkml.kernel.org/r/20240625180538.73134-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/Makefile               |    1 
 tools/testing/selftests/damon/damos_tried_regions.py |   65 ++++++++++
 2 files changed, 66 insertions(+)

--- /dev/null
+++ a/tools/testing/selftests/damon/damos_tried_regions.py
@@ -0,0 +1,65 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0
+
+import subprocess
+import time
+
+import _damon_sysfs
+
+def main():
+    # repeatedly access even-numbered ones in 14 regions of 10 MiB size
+    sz_region = 10 * 1024 * 1024
+    proc = subprocess.Popen(['./access_memory_even', '14', '%d' % sz_region])
+
+    # stat every monitored regions
+    kdamonds = _damon_sysfs.Kdamonds([_damon_sysfs.Kdamond(
+            contexts=[_damon_sysfs.DamonCtx(
+                ops='vaddr',
+                targets=[_damon_sysfs.DamonTarget(pid=proc.pid)],
+                schemes=[_damon_sysfs.Damos(action='stat',
+                    )] # schemes
+                )] # contexts
+            )]) # kdamonds
+
+    err = kdamonds.start()
+    if err is not None:
+        proc.terminate()
+        print('kdamond start failed: %s' % err)
+        exit(1)
+
+    collected_nr_regions = []
+    while proc.poll() is None:
+        time.sleep(0.1)
+        err = kdamonds.kdamonds[0].update_schemes_tried_regions()
+        if err is not None:
+            proc.terminate()
+            print('tried regions update failed: %s' % err)
+            exit(1)
+
+        scheme = kdamonds.kdamonds[0].contexts[0].schemes[0]
+        if scheme.tried_regions is None:
+            proc.terminate()
+            print('tried regions is not collected')
+            exit(1)
+
+        nr_tried_regions = len(scheme.tried_regions)
+        if nr_tried_regions <= 0:
+            proc.terminate()
+            print('tried regions is not created')
+            exit(1)
+        collected_nr_regions.append(nr_tried_regions)
+        if len(collected_nr_regions) > 10:
+            break
+    proc.terminate()
+
+    collected_nr_regions.sort()
+    sample = collected_nr_regions[4]
+    print('50-th percentile nr_regions: %d' % sample)
+    print('expectation (>= 14) is %s' % 'met' if sample >= 14 else 'not met')
+    if collected_nr_regions[4] < 14:
+        print('full nr_regions:')
+        print('\n'.join(collected_nr_regions))
+        exit(1)
+
+if __name__ == '__main__':
+    main()
--- a/tools/testing/selftests/damon/Makefile~selftests-damon-implement-damos-tried-regions-test
+++ a/tools/testing/selftests/damon/Makefile
@@ -13,6 +13,7 @@ TEST_PROGS = debugfs_attrs.sh debugfs_sc
 TEST_PROGS += sysfs.sh
 TEST_PROGS += sysfs_update_schemes_tried_regions_wss_estimation.py
 TEST_PROGS += damos_quota.py damos_quota_goal.py damos_apply_interval.py
+TEST_PROGS += damos_tried_regions.py
 TEST_PROGS += reclaim.sh lru_sort.sh
 
 # regression tests (reproducers of previously found bugs)
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet.patch
mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet-fix.patch
mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet-fix-2.patch

