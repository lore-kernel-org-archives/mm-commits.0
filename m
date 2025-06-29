Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C48D239591
	for <mm-commits@vger.kernel.org>; Sun, 29 Jun 2025 22:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751237280; cv=none; b=XksqlEJ+hnihHQkl30NZkDXR7VOhGvpXEvZvKddpUYX+ZniHRvi5S4q2tUePxmY4WBkh2T50aFpgrFIYpvq9+n7yPCcYIIVtj5DbOAHn2DtJ8hRhuHoNVdQeTYGavtnl39k/LZqW8A0oVcXiAeI0QIR074jlg4otHjVBKSPteEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751237280; c=relaxed/simple;
	bh=MbPAJKb7KUJq0Uk7+lKaC/itHCcWkz74jfib/Wp4OX8=;
	h=Date:To:From:Subject:Message-Id; b=fbZJcnOcBWbR+zob5VAxZbcYdgZX+QNVbH56F5Sp0NOB2U5htTS+p1ZPbpAihiczGmQvAwxe547b8mkX43L9aSJrfAGHaOkwJk2N3euJmOUvnK1MMZGg45w2Jc5ErCditcDrJ7Vz7PNVc6EBXYnLgJp3SqL5f5gJccJkXs5dzjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NWKm3T4H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NWKm3T4H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 924D6C4CEEB;
	Sun, 29 Jun 2025 22:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751237279;
	bh=MbPAJKb7KUJq0Uk7+lKaC/itHCcWkz74jfib/Wp4OX8=;
	h=Date:To:From:Subject:From;
	b=NWKm3T4H3NJ/5mQSqvSkcayMRMT240r5zq6jQqwVkc8C4pK15q4QODStiqjDkkyNH
	 Ht/lQSlGDsU4qmSSV49NNHDUbFdq77gXgAAKHArNXmg9UsW98dC1AcNYeljMiRJTKq
	 o3ClzMt+7ojLaDyRG4la5BRsZmzMSUxzq4TPVh9A=
Date: Sun, 29 Jun 2025 15:47:59 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-add-python-and-drgn-based-damon-sysfs-test.patch added to mm-new branch
Message-Id: <20250629224759.924D6C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon: add python and drgn-based DAMON sysfs test
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-add-python-and-drgn-based-damon-sysfs-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-add-python-and-drgn-based-damon-sysfs-test.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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

mm-damon-core-handle-damon_call_control-as-normal-under-kdmond-deactivation.patch
mm-damon-introduce-damon_stat-module.patch
mm-damon-introduce-damon_stat-module-fix.patch
mm-damon-stat-calculate-and-expose-estimated-memory-bandwidth.patch
mm-damon-stat-calculate-and-expose-idle-time-percentiles.patch
docs-admin-guide-mm-damon-add-damon_stat-usage-document.patch
mm-damon-paddr-use-alloc_migartion_target-with-no-migration-fallback-nodemask.patch
revert-mm-rename-alloc_demote_folio-to-alloc_migrate_folio.patch
revert-mm-make-alloc_demote_folio-externally-invokable-for-migration.patch
selftets-damon-add-a-test-for-memcg_path-leak.patch
mm-damon-sysfs-schemes-decouple-from-damos_quota_goal_metric.patch
mm-damon-sysfs-schemes-decouple-from-damos_action.patch
mm-damon-sysfs-schemes-decouple-from-damos_wmark_metric.patch
mm-damon-sysfs-schemes-decouple-from-damos_filter_type.patch
mm-damon-sysfs-decouple-from-damon_ops_id.patch
selftests-damon-add-drgn-script-for-extracting-damon-status.patch
selftests-damon-_damon_sysfs-set-kdamondpid-in-start.patch
selftests-damon-add-python-and-drgn-based-damon-sysfs-test.patch
selftests-damon-sysfspy-test-monitoring-attribute-parameters.patch
selftests-damon-sysfspy-test-adaptive-targets-parameter.patch
selftests-damon-sysfspy-test-damos-schemes-parameters-setup.patch

