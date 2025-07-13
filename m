Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B391EF38E
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752450027; cv=none; b=XEjaCjL88ad68hq75wbed96JAiIgdH6UIoSaXR0XtdOwsYgSlJZYuVqic2cCTgrS+8OHYbaS7VJ98oTjmdREfJK+ZJSCqYJ1kDP+pGw6HEOmEwS5vahGhs9tywk0tfujzSZlkrvlK8Z/QhUpKORzOzmbPsnFBAygcf19+/qwXsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752450027; c=relaxed/simple;
	bh=qiWlcbMpu/VI+yG4aoq3jmirEbpAW078AkTrH+xeB9c=;
	h=Date:To:From:Subject:Message-Id; b=QvibZnPwPYy05Ze8MrVo+n3gjGjMErb+fgA5XP3bljFeedQ1T6jl7912brDXRh9E78RVrIELRP2y9kGPB4xvSR0rK1bwRrR0hY/GVzZCiGAYsmGse/R/dHcTDl+utgcQ3PkKMhIX8QTf9+NYzHObQz2bkvov+5E4ZhT4geiL+wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a8jZYz48; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a8jZYz48"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC0BC4CEE3;
	Sun, 13 Jul 2025 23:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752450027;
	bh=qiWlcbMpu/VI+yG4aoq3jmirEbpAW078AkTrH+xeB9c=;
	h=Date:To:From:Subject:From;
	b=a8jZYz48AE1inAMSRV1fLkPIHa9cp9BQPWtiBtzjQCQlnmuOsWMbdzZp4N/+b8iGU
	 I54i9OMaZ0NOV2OqRhqc9WckAYbhU3UjI6Zm1x+ubDH0j13yuzjw0z3DHC8qK5sG5J
	 SESDrmdF8iJ15ePM10jZpVNAcU0Kmy8vvkkrjGBY=
Date: Sun, 13 Jul 2025 16:40:27 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-add-python-and-drgn-based-damon-sysfs-test.patch removed from -mm tree
Message-Id: <20250713234027.7EC0BC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon: add python and drgn-based DAMON sysfs test
has been removed from the -mm tree.  Its filename was
     selftests-damon-add-python-and-drgn-based-damon-sysfs-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon: add python and drgn-based DAMON sysfs test
Date: Sat, 28 Jun 2025 09:04:25 -0700

Add a python-written DAMON sysfs functionality selftest.  It sets DAMON
parameters using Python module _damon_sysfs, reads updated kernel internal
DAMON status and parameters using a 'drgn' script, namely
drgn_dump_damon_status.py, and compare if the resulted DAMON internal
status is as expected.  The test is very minimum at the moment.

Link: https://lkml.kernel.org/r/20250628160428.53115-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/Makefile |    1 
 tools/testing/selftests/damon/sysfs.py |   42 +++++++++++++++++++++++
 2 files changed, 43 insertions(+)

--- a/tools/testing/selftests/damon/Makefile~selftests-damon-add-python-and-drgn-based-damon-sysfs-test
+++ a/tools/testing/selftests/damon/Makefile
@@ -7,6 +7,7 @@ TEST_FILES = _damon_sysfs.py
 
 # functionality tests
 TEST_PROGS += sysfs.sh
+TEST_PROGS += sysfs.py
 TEST_PROGS += sysfs_update_schemes_tried_regions_wss_estimation.py
 TEST_PROGS += damos_quota.py damos_quota_goal.py damos_apply_interval.py
 TEST_PROGS += damos_tried_regions.py damon_nr_regions.py
diff --git a/tools/testing/selftests/damon/sysfs.py a/tools/testing/selftests/damon/sysfs.py
new file mode 100755
--- /dev/null
+++ a/tools/testing/selftests/damon/sysfs.py
@@ -0,0 +1,42 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0
+
+import json
+import os
+import subprocess
+
+import _damon_sysfs
+
+def dump_damon_status_dict(pid):
+    file_dir = os.path.dirname(os.path.abspath(__file__))
+    dump_script = os.path.join(file_dir, 'drgn_dump_damon_status.py')
+    rc = subprocess.call(['drgn', dump_script, pid, 'damon_dump_output'],
+                         stderr=subprocess.DEVNULL)
+    if rc != 0:
+        return None, 'drgn fail'
+    try:
+        with open('damon_dump_output', 'r') as f:
+            return json.load(f), None
+    except Exception as e:
+        return None, 'json.load fail (%s)' % e
+
+def main():
+    kdamonds = _damon_sysfs.Kdamonds(
+            [_damon_sysfs.Kdamond(contexts=[_damon_sysfs.DamonCtx()])])
+    err = kdamonds.start()
+    if err is not None:
+        print('kdamond start failed: %s' % err)
+        exit(1)
+
+    status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
+    if err is not None:
+        print(err)
+        exit(1)
+
+    if len(status['contexts']) != 1:
+        print('number of contexts: %d' % len(status['contexts']))
+        exit(1)
+    kdamonds.stop()
+
+if __name__ == '__main__':
+    main()
_

Patches currently in -mm which might be from sj@kernel.org are

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
mm-damon-accept-parallel-damon_call-requests.patch
mm-damon-core-introduce-repeat-mode-damon_call.patch
mm-damon-stat-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-reclaim-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-lru_sort-use-damon_call-repeat-mode-instead-of-damon_callback.patch
samples-damon-prcl-use-damon_call-repeat-mode-instead-of-damon_callback.patch
samples-damon-wsse-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-core-do-not-call-opscleanup-when-destroying-targets.patch
mm-damon-core-add-cleanup_target-ops-callback.patch
mm-damon-vaddr-put-pid-in-cleanup_target.patch
mm-damon-sysfs-remove-damon_sysfs_destroy_targets.patch
mm-damon-core-destroy-targets-when-kdamond_fn-finish.patch
mm-damon-sysfs-remove-damon_sysfs_before_terminate.patch
mm-damon-core-remove-damon_callback.patch

