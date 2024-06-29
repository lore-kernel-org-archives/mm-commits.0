Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F74915E81
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628312; cv=none; b=WlFrrSMMjqKHmz6pAdiDEb7kUjP8TBl9Qzx5w4ugbfGL6vr2yWWFbDcZLOKsy77lEcs+fxCRAX88d54emrIwjmKBBcOd05ObetQrUMpH1dllIEcmfOHAQ6pkXtdKtXgMgh30Q3rUfwpbM4Z4lXwbiIffPdU0/Rbcx6RJOVTMDPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628312; c=relaxed/simple;
	bh=CIonpsLg08GMkV5BYz24o2DbOkolK6BpfVpTggtwACs=;
	h=Date:To:From:Subject:Message-Id; b=PU6PDmo6Mft6bR+2o7xCBju90ilExDn5VEuv+VD5WV3Df6PeRu43u8cXGWa1DE2L9yoy/tX9Yp88elQrNkVc8wqGJ0so+Ad8akTRE5HbDzw4MR/TbJU+fjEVMjMEnE9zV20bjrSW0EQLS4nnSbVNYv8y6wScz5SRpYzO3MiKKPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2MGrqvGD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2MGrqvGD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EABA5C116B1;
	Sat, 29 Jun 2024 02:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628312;
	bh=CIonpsLg08GMkV5BYz24o2DbOkolK6BpfVpTggtwACs=;
	h=Date:To:From:Subject:From;
	b=2MGrqvGD28oSvnO05rlCGnSEzdsEZ8qOKl82H0UY+ms5u06LJP55ftUl8ysYf8kZr
	 VxpY596MfgK1mBrBCOyrIH+QNH0P9I7qeKN2BC7xLPFd0OkSrs4tAVON0eM7Q0wif5
	 B3I1CsnODHzpYMTVK3f1EDWBfWvcaAdW2a3p+rIA=
Date: Fri, 28 Jun 2024 19:31:51 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-damon_nr_regions-test-online-tuned-max_nr_regions.patch removed from -mm tree
Message-Id: <20240629023151.EABA5C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/damon_nr_regions: test online-tuned max_nr_regions
has been removed from the -mm tree.  Its filename was
     selftests-damon-damon_nr_regions-test-online-tuned-max_nr_regions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/damon_nr_regions: test online-tuned max_nr_regions
Date: Tue, 25 Jun 2024 11:05:38 -0700

User could update max_nr_regions parameter while DAMON is running to a
value that smaller than the current number of regions that DAMON is
seeing.  Such update could be done for reducing the monitoring overhead. 
In the case, DAMON should merge regions aggressively more than normal
situation to ensure the new limit is successfully applied.  Implement a
kselftest to ensure that.

Link: https://lkml.kernel.org/r/20240625180538.73134-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/damon_nr_regions.py |   60 ++++++++++++
 1 file changed, 60 insertions(+)

--- a/tools/testing/selftests/damon/damon_nr_regions.py~selftests-damon-damon_nr_regions-test-online-tuned-max_nr_regions
+++ a/tools/testing/selftests/damon/damon_nr_regions.py
@@ -81,5 +81,65 @@ def main():
     # test max_nr_regions smaller than real nr regions
     test_nr_regions(15, 3, 10)
 
+    # test online-tuned max_nr_regions that smaller than real nr regions
+    sz_region = 10 * 1024 * 1024
+    proc = subprocess.Popen(['./access_memory_even', '14', '%d' % sz_region])
+
+    # stat every monitored regions
+    kdamonds = _damon_sysfs.Kdamonds([_damon_sysfs.Kdamond(
+            contexts=[_damon_sysfs.DamonCtx(
+                monitoring_attrs=_damon_sysfs.DamonAttrs(
+                    min_nr_regions=10, max_nr_regions=1000),
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
+    # wait until the real regions are found
+    time.sleep(3)
+
+    attrs = kdamonds.kdamonds[0].contexts[0].monitoring_attrs
+    attrs.min_nr_regions = 3
+    attrs.max_nr_regions = 7
+    err = kdamonds.kdamonds[0].commit()
+    if err is not None:
+        proc.terminate()
+        print('commit failed: %s' % err)
+        exit(1)
+    # wait for next merge operation is executed
+    time.sleep(0.3)
+
+    err = kdamonds.kdamonds[0].update_schemes_tried_regions()
+    if err is not None:
+        proc.terminate()
+        print('tried regions update failed: %s' % err)
+        exit(1)
+
+    scheme = kdamonds.kdamonds[0].contexts[0].schemes[0]
+    if scheme.tried_regions is None:
+        proc.terminate()
+        print('tried regions is not collected')
+        exit(1)
+
+    nr_tried_regions = len(scheme.tried_regions)
+    if nr_tried_regions <= 0:
+        proc.terminate()
+        print('tried regions is not created')
+        exit(1)
+    proc.terminate()
+
+    if nr_tried_regions > 7:
+        print('fail online-tuned max_nr_regions: %d > 7' % nr_tried_regions)
+        exit(1)
+    print('pass online-tuned max_nr_regions')
+
 if __name__ == '__main__':
     main()
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet.patch
mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet-fix.patch
mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet-fix-2.patch

