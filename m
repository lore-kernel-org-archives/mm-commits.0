Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50AF32DCF74
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298541; cv=none; b=M4Hy1/0j9Wi1X9zmFNraycUUiBobOzfqZG1edMpS7KS6tK79z+hS2n9HEeHUHCUmwKYnbmyDoWgnKp1bSooX30+Hl1t4UTEn52hZhM7D/H/mXttgn/aP2NwE/H9YfGu+6jWC3EG9d2eFJa82bto0cbxpfbZ90ZJjYxMZF82X85A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298541; c=relaxed/simple;
	bh=eoUCzPdsp2I/b85q3i0GZ0wL8TdfbqzgwwHzyM+93Tw=;
	h=Date:To:From:Subject:Message-Id; b=agi86s4ZXb2o1MYHR04Silh4COhwSXSrKtiXhfmhSKiHVaDU4mu1U59Ok7UWo5xptgegWT4vJjhWDTUjBR5D9LIcmNWJHAGsuLr23+fhgKbNDpnyeDXE3MaEG0ycY2GvEOiGOCxoyZYqq+z14uDVcBg9zR+v9cuM+kDjhT16QDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dGVZbxtB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dGVZbxtB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C701F00A3A;
	Wed, 29 Jul 2026 04:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298539;
	bh=MYvGWRz5sotiHVz6HlI38D36ULVgoEJ5cnrtb/1EDFk=;
	h=Date:To:From:Subject;
	b=dGVZbxtBMpbQoGCltGKkQYl8qP/doatonTjgUDFZkEbAYHbV4yyS4/802OqAhWjh1
	 hCvxip+WCoJljezlm9IB4Nmx443SJafsvw7+Em6EeB7PouIm82emI5CeO+S+eSib81
	 KLQAZoFy2xjnEdS1MZ1HySsO/ys3sfu3lJqst1Sk=
Date: Tue, 28 Jul 2026 21:15:38 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,shuah@kernel.org,linuxoid@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-sysfs_refresh-test-kdamond-refresh_ms.patch removed from -mm tree
Message-Id: <20260729041539.27C701F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/sysfs_refresh: test kdamond refresh_ms
has been removed from the -mm tree.  Its filename was
     selftests-damon-sysfs_refresh-test-kdamond-refresh_ms.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ruslan Valiyev <linuxoid@gmail.com>
Subject: selftests/damon/sysfs_refresh: test kdamond refresh_ms
Date: Mon, 29 Jun 2026 07:49:26 -0700

Writing a non-zero value to a kdamond's 'refresh_ms' sysfs file should
make DAMON periodically update the read-only sysfs files on its own,
without the user writing update keywords such as 'update_schemes_stats' to
the 'state' file.  This behavior has no test coverage.

Add a test that starts a kdamond with refresh_ms set and a 'stat' scheme
whose default access pattern matches every monitored region, then polls
the scheme's 'nr_tried' stats file directly, without requesting an update.
The value can become non-zero only via the periodic refresh, so the test
confirms refresh_ms works; with refresh_ms disabled the stat stays zero
and the test fails.

Link: https://lore.kernel.org/20260602131217.2210912-3-linuxoid@gmail.com
Link: https://lore.kernel.org/20260629144927.134237-3-sj@kernel.org
Signed-off-by: Ruslan Valiyev <linuxoid@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/Makefile         |    1 
 tools/testing/selftests/damon/sysfs_refresh.py |   75 +++++++++++++++
 2 files changed, 76 insertions(+)

--- a/tools/testing/selftests/damon/Makefile~selftests-damon-sysfs_refresh-test-kdamond-refresh_ms
+++ a/tools/testing/selftests/damon/Makefile
@@ -13,6 +13,7 @@ TEST_PROGS += sysfs.py
 TEST_PROGS += sysfs_update_schemes_tried_regions_wss_estimation.py
 TEST_PROGS += damos_quota.py damos_quota_goal.py damos_apply_interval.py
 TEST_PROGS += damos_tried_regions.py damon_nr_regions.py
+TEST_PROGS += sysfs_refresh.py
 TEST_PROGS += reclaim.sh lru_sort.sh
 
 # regression tests (reproducers of previously found bugs)
diff --git a/tools/testing/selftests/damon/sysfs_refresh.py a/tools/testing/selftests/damon/sysfs_refresh.py
new file mode 100755
--- /dev/null
+++ a/tools/testing/selftests/damon/sysfs_refresh.py
@@ -0,0 +1,75 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0
+
+import os
+import subprocess
+import time
+
+import _damon_sysfs
+
+def main():
+    # Continuously access a memory region for far longer than the test needs,
+    # so the kdamond always has a live target to monitor while we poll.
+    sz_region = 10 * 1024 * 1024
+    proc = subprocess.Popen(
+            ['./access_memory', '1', '%d' % sz_region, '60000', 'repeat'])
+
+    # A 'stat' scheme with the default (maximally wide) access pattern matches
+    # every monitored region, so its 'nr_tried' stat increases as the kdamond
+    # runs.  refresh_ms should make DAMON update the schemes' stats files under
+    # sysfs on its own, without a manual 'update_schemes_stats' request.
+    kdamond = _damon_sysfs.Kdamond(
+            refresh_ms=100,
+            contexts=[_damon_sysfs.DamonCtx(
+                ops='vaddr',
+                targets=[_damon_sysfs.DamonTarget(pid=proc.pid)],
+                schemes=[_damon_sysfs.Damos(action='stat')],
+                )])
+    kdamonds = _damon_sysfs.Kdamonds([kdamond])
+
+    err = kdamonds.start()
+    if err is not None:
+        # Kernels older than the refresh_ms feature have no such file; treat
+        # that as unsupported rather than a failure.
+        if not os.path.exists(os.path.join(kdamond.sysfs_dir(), 'refresh_ms')):
+            proc.terminate()
+            proc.wait()
+            print('kdamond has no refresh_ms file; skipping')
+            exit(_damon_sysfs.ksft_skip)
+        proc.terminate()
+        proc.wait()
+        print('kdamond start failed: %s' % err)
+        exit(1)
+
+    scheme = kdamond.contexts[0].schemes[0]
+    nr_tried_path = os.path.join(scheme.sysfs_dir(), 'stats', 'nr_tried')
+
+    try:
+        # Poll the stat file directly.  We never request an update (e.g.
+        # 'update_schemes_stats'), so 'nr_tried' can become non-zero only
+        # through the periodic refresh that refresh_ms enables.
+        nr_tried = 0
+        deadline = time.monotonic() + 10
+        while time.monotonic() < deadline:
+            if proc.poll() is not None:
+                print('the access_memory target exited unexpectedly')
+                exit(1)
+            content, err = _damon_sysfs.read_file(nr_tried_path)
+            if err is not None:
+                print('reading %s failed: %s' % (nr_tried_path, err))
+                exit(1)
+            nr_tried = int(content)
+            if nr_tried > 0:
+                break
+            time.sleep(0.1)
+    finally:
+        kdamonds.stop()
+        proc.terminate()
+        proc.wait()
+
+    if nr_tried == 0:
+        print('refresh_ms did not auto-update the schemes stats')
+        exit(1)
+
+if __name__ == '__main__':
+    main()
_

Patches currently in -mm which might be from linuxoid@gmail.com are


