Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B443C17A932
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 19:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719342492; cv=none; b=qvb1i/ymDORxoVpPu9TO6fdeY0owPjDAe0xi5+cxomgTl7dQiAy7s0cHmR0mjcK6kLM1ZyKS2oEupjiA8dbABT9zOAquOtI855ZeduhLy98EH/NcuumO/nf5IFDtVgdE45zvhtZXRSQES0rGh1fII64JAxU71e8sVAXBhuKUV4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719342492; c=relaxed/simple;
	bh=xGpCDuiZaze/SNMzldIy+QgzhCnTSHNqOPcMDiv0rYc=;
	h=Date:To:From:Subject:Message-Id; b=dJKGj6UVUDzczhFJGQ0PTPkqbMuOif9WTp6LsnREVjz69oef7UD9Ghq0mKPc+tqTaBADeTi75XiyLxEaTnRwO9p3tJL1+jkJD6d8YzZzwQfzpxtwY25Ghu51ByC2GSIHFkHWSPo4+zY77fmVdCoap6jCcwxsWFNCn90qf3vs08o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Lt/4+n4e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Lt/4+n4e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B361C32781;
	Tue, 25 Jun 2024 19:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719342492;
	bh=xGpCDuiZaze/SNMzldIy+QgzhCnTSHNqOPcMDiv0rYc=;
	h=Date:To:From:Subject:From;
	b=Lt/4+n4egLTCek49mirCi40Wp4wxypJZNot1+oK80o488cpZw2MSP/OG8Drt9TQnc
	 swHeqxuLY5XXzhpmQNoLQA9LzfvXVyAjlMRP1bLFHg8jdINaWJxhijl/WSM3qtpFE9
	 4LEywtbQCD1hBfIqhG7RxyEsauCPBEcFJ72hKZ68=
Date: Tue, 25 Jun 2024 12:08:11 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-implement-test-for-min-max_nr_regions.patch added to mm-unstable branch
Message-Id: <20240625190812.6B361C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon: implement test for min/max_nr_regions
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-implement-test-for-min-max_nr_regions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-implement-test-for-min-max_nr_regions.patch

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
Subject: selftests/damon: implement test for min/max_nr_regions
Date: Tue, 25 Jun 2024 11:05:36 -0700

Implement a kselftest for DAMON's {min,max}_nr_regions' parameters.  The
test ensures both the minimum and the maximum number of regions limit is
respected even if the workload's real number of regions is less than the
minimum or larger than the maximum limits.

Link: https://lkml.kernel.org/r/20240625180538.73134-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/Makefile            |    2 
 tools/testing/selftests/damon/damon_nr_regions.py |   85 ++++++++++++
 2 files changed, 86 insertions(+), 1 deletion(-)

--- /dev/null
+++ a/tools/testing/selftests/damon/damon_nr_regions.py
@@ -0,0 +1,85 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0
+
+import subprocess
+import time
+
+import _damon_sysfs
+
+def test_nr_regions(real_nr_regions, min_nr_regions, max_nr_regions):
+    '''
+    Create process of the given 'real_nr_regions' regions, monitor it using
+    DAMON with given '{min,max}_nr_regions' monitoring parameter.
+
+    Exit with non-zero return code if the given {min,max}_nr_regions is not
+    kept.
+    '''
+    sz_region = 10 * 1024 * 1024
+    proc = subprocess.Popen(['./access_memory_even', '%d' % real_nr_regions,
+                             '%d' % sz_region])
+
+    # stat every monitored regions
+    kdamonds = _damon_sysfs.Kdamonds([_damon_sysfs.Kdamond(
+            contexts=[_damon_sysfs.DamonCtx(
+                monitoring_attrs=_damon_sysfs.DamonAttrs(
+                    min_nr_regions=min_nr_regions,
+                    max_nr_regions=max_nr_regions),
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
+    kdamonds.stop()
+
+    test_name = 'nr_regions test with %d/%d/%d real/min/max nr_regions' % (
+            real_nr_regions, min_nr_regions, max_nr_regions)
+    if (collected_nr_regions[0] < min_nr_regions or
+        collected_nr_regions[-1] > max_nr_regions):
+        print('fail %s' % test_name)
+        print('number of regions that collected are:')
+        for nr in collected_nr_regions:
+            print(nr)
+        exit(1)
+    print('pass %s ' % test_name)
+
+def main():
+    # test min_nr_regions larger than real nr regions
+    test_nr_regions(10, 20, 100)
+
+    # test max_nr_regions smaller than real nr regions
+    test_nr_regions(15, 3, 10)
+
+if __name__ == '__main__':
+    main()
--- a/tools/testing/selftests/damon/Makefile~selftests-damon-implement-test-for-min-max_nr_regions
+++ a/tools/testing/selftests/damon/Makefile
@@ -13,7 +13,7 @@ TEST_PROGS = debugfs_attrs.sh debugfs_sc
 TEST_PROGS += sysfs.sh
 TEST_PROGS += sysfs_update_schemes_tried_regions_wss_estimation.py
 TEST_PROGS += damos_quota.py damos_quota_goal.py damos_apply_interval.py
-TEST_PROGS += damos_tried_regions.py
+TEST_PROGS += damos_tried_regions.py damon_nr_regions.py
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

