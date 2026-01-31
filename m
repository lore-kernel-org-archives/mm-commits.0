Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF5938A9B5
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898328; cv=none; b=u8w39AmFsrlmdhrFiWI4sW7C4WLdaFL1h5OAPPI3e3/j/XV3L0/pqNf6UGNW7CfZIjlUNlBJ7DFvbqtGoD9sQdN27hOTixiAQyxZK65l7N3ieJhlpK5Qm9rtcRs/sISGBKmv9spixb1/6mXcv05KdrumP8uQ4qba7J1KW7WXrqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898328; c=relaxed/simple;
	bh=m2hRkfhtqJqjcmrAtbcVfk0LoU3IA1FLsprNfyU0hfI=;
	h=Date:To:From:Subject:Message-Id; b=puoZGDvvIOcer/r1avVADsYXyZ7Ne9U/RcgkHtkI8RbWCMWPWQ26bBVO3oGo/+f8B486G9RCDVsbx6q3licKUOmFksWFCT9OY5ile1VS+Btwx7N8Nc24SukSv2w4Dn+MBNxw2rcNTFpxfqYU5T3n8q7Q6HGE3gkc+GvTJ4qjVC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r8juQdtn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r8juQdtn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A47A7C4CEF1;
	Sat, 31 Jan 2026 22:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898328;
	bh=m2hRkfhtqJqjcmrAtbcVfk0LoU3IA1FLsprNfyU0hfI=;
	h=Date:To:From:Subject:From;
	b=r8juQdtn5sAubk6kxnIPSdlXCKasglvAsr6jiOs+AI6vHGuJhX78TlQ+I9nSo/0PF
	 SIUCzuraZPbbTK9tJfxPjgkriuZNY988ptaE4h5ND3tRmghKPj9oshHZOgM+KwJkn9
	 HFfL2hOAlT+qDy0CLaMPXgaBtuHHovKr0egZge3g=
Date: Sat, 31 Jan 2026 14:25:28 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-wss_estimation-test-for-up-to-160-mib-working-set-size.patch removed from -mm tree
Message-Id: <20260131222528.A47A7C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/wss_estimation: test for up to 160 MiB working set size
has been removed from the -mm tree.  Its filename was
     selftests-damon-wss_estimation-test-for-up-to-160-mib-working-set-size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/wss_estimation: test for up to 160 MiB working set size
Date: Fri, 16 Jan 2026 18:07:25 -0800

DAMON reads and writes Accessed bits of page tables without manual TLB
flush for two reasons.  First, it minimizes the overhead.  Second, real
systems that need DAMON are expected to be memory intensive enough to
cause periodic TLB flushes.  For test setups that use small test
workloads, however, the system's TLB could be big enough to cover whole or
most accesses of the test workload.  In this case, no page table walk
happens and DAMON cannot show any access from the test workload.

The test workload for DAMON's working set size estimation selftest is such
a case.  It accesses only 10 MiB working set, and it turned out there are
test setups that have TLBs large enough to cover the 10 MiB data accesses.
As a result, the test fails depending on the test machine.

Make it more reliable by trying larger working sets up to 160 MiB when it
fails.

Link: https://lkml.kernel.org/r/20260117020731.226785-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py |   29 +++++++---
 1 file changed, 23 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py~selftests-damon-wss_estimation-test-for-up-to-160-mib-working-set-size
+++ a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py
@@ -6,9 +6,8 @@ import time
 
 import _damon_sysfs
 
-def main():
-    # access two 10 MiB memory regions, 2 second per each
-    sz_region = 10 * 1024 * 1024
+def pass_wss_estimation(sz_region):
+    # access two regions of given size, 2 seocnds per each region
     proc = subprocess.Popen(['./access_memory', '2', '%d' % sz_region, '2000'])
     kdamonds = _damon_sysfs.Kdamonds([_damon_sysfs.Kdamond(
             contexts=[_damon_sysfs.DamonCtx(
@@ -36,20 +35,38 @@ def main():
 
         wss_collected.append(
                 kdamonds.kdamonds[0].contexts[0].schemes[0].tried_bytes)
+    err = kdamonds.stop()
+    if err is not None:
+        print('kdamond stop failed: %s' % err)
+        exit(1)
 
     wss_collected.sort()
     acceptable_error_rate = 0.2
     for percentile in [50, 75]:
         sample = wss_collected[int(len(wss_collected) * percentile / 100)]
         error_rate = abs(sample - sz_region) / sz_region
-        print('%d-th percentile (%d) error %f' %
-                (percentile, sample, error_rate))
+        print('%d-th percentile error %f (expect %d, result %d)' %
+                (percentile, error_rate, sz_region, sample))
         if error_rate > acceptable_error_rate:
             print('the error rate is not acceptable (> %f)' %
                     acceptable_error_rate)
             print('samples are as below')
             print('\n'.join(['%d' % wss for wss in wss_collected]))
-            exit(1)
+            return False
+    return True
+
+def main():
+    # DAMON doesn't flush TLB.  If the system has large TLB that can cover
+    # whole test working set, DAMON cannot see the access.  Test up to 160 MiB
+    # test working set.
+    sz_region_mb = 10
+    max_sz_region_mb = 160
+    while sz_region_mb <= max_sz_region_mb:
+        test_pass = pass_wss_estimation(sz_region_mb * 1024 * 1024)
+        if test_pass is True:
+            exit(0)
+        sz_region_mb *= 2
+    exit(1)
 
 if __name__ == '__main__':
     main()
_

Patches currently in -mm which might be from sj@kernel.org are


