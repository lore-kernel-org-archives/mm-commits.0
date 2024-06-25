Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989CA17A932
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 19:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719342488; cv=none; b=BfA4gcRo+RfcNZVmBDLoKTRo/WOomDubT8AbJv0hKgYwiPLhW04efuCKD7saNbPXPH/wmoI7yUgZep4gqKEVIakLTEkrLOYrC1jba9vgrasDs9ccmzA1wo8o4f2cYUbC94Zib/YjHlBHA+X4zHJqjDQJbf1dlVCd5WwnfTXWLQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719342488; c=relaxed/simple;
	bh=+RCsmtaRX30nadO6UIaOQCN10a5NKg8iANi60c6HM4Y=;
	h=Date:To:From:Subject:Message-Id; b=ruP+PHubsxxBtQJeWKaRvAvCxml79C/HlpvC2zGfP6vVUrO2Ez91KE9Wp4QOOisuVZ6VoWa/rOwpVN+DmdtAWT6Sz2i2BXw1zp8V+EFFeB1fcAy2hv2vlEbC8Xw/Rt6rwSnQcSHlDrR38Ql0TSzUN2rF1Dj0iyTu3nS+jznM+1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pbcRLYZN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pbcRLYZN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D2C4C32781;
	Tue, 25 Jun 2024 19:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719342488;
	bh=+RCsmtaRX30nadO6UIaOQCN10a5NKg8iANi60c6HM4Y=;
	h=Date:To:From:Subject:From;
	b=pbcRLYZNKeAuR/pqiywt8MD3CuJcPwkH7wM7DzvLqu8HEFEw/7HCfd00t66XZhNto
	 sjJGx8wX5E14/0fuWFQVghrJc7afjC5DBvAL+wYlFiPrzdJV96GcD3mNWANOb19Thc
	 3PfzNeD88ARKRr+gKtRBTQ/LRjO+E0hZVkzGJm+Y=
Date: Tue, 25 Jun 2024 12:08:07 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-implement-damos-tried-regions-test.patch added to mm-unstable branch
Message-Id: <20240625190808.1D2C4C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon: implement DAMOS tried regions test
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-implement-damos-tried-regions-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-implement-damos-tried-regions-test.patch

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
docs-mm-damon-maintainer-profile-introduce-hackermail.patch
docs-mm-damon-maintainer-profile-document-damon-community-meetups.patch
selftests-damon-access_memory-use-user-defined-region-size.patch
selftests-damon-_damon_sysfs-support-schemes_update_tried_regions.patch
selftests-damon-implement-a-program-for-even-numbered-memory-regions-access.patch
selftests-damon-implement-damos-tried-regions-test.patch
selftests-damon-_damon_sysfs-implement-kdamonds-stop-function.patch
selftests-damon-implement-test-for-min-max_nr_regions.patch
_damon_sysfs-implement-commit-for-online-parameters-update.patch
selftests-damon-damon_nr_regions-test-online-tuned-max_nr_regions.patch

