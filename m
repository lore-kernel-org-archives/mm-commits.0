Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3398A17A932
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 19:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719342497; cv=none; b=c43kEh4IY0DzUiD0H7LBY89yYuWH37Fp/t0wRxMane2z1iwRlGRNNg6x1L/sM7t9ky5aA63/LbJq+2ouY/8xZPSzrFAIDjlNJqIzDbl58OV2AkGLW44oFqDJVmNoaA6H4HR64U4ee9DHO4B+S1jiLafM6YWBj5K/MKk+t4SN4yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719342497; c=relaxed/simple;
	bh=hM3BKMqJ7L93lmQ7ENEQZKcZ7SvdxXE30pF4EVek/aY=;
	h=Date:To:From:Subject:Message-Id; b=qfgE0dIj+P4a6M7kNaZfIVdJgSkip4qa0S0QswG5LsOiPtWUgmIc3hgzeqwrRnX/0k411QW1fL9io6XGMTxeaJMkN6LClEZKNUJ6Wm/E+MQdKfNG98FZ1/qnL3iDFxng8gBOtbN4hx5xyOfsr78n/xwGYSkHef84bLnP54JlZ5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zC0ziB7x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zC0ziB7x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11A9C32781;
	Tue, 25 Jun 2024 19:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719342496;
	bh=hM3BKMqJ7L93lmQ7ENEQZKcZ7SvdxXE30pF4EVek/aY=;
	h=Date:To:From:Subject:From;
	b=zC0ziB7xadRgJiJuTsU/zRbi1b7s6N5iRWctMqOK+sHjkHnPiw8vwFfYHNLSBGoOC
	 K8QSUa75JANIbUQMqkUJQOSJAFJqgCKgD0EwU6UeoP4nfGEmxTnaf1iBa3i7qcyXFL
	 BQMCrPFsWliIlpndesWh1FjKKKzvKBROgVA1xIEs=
Date: Tue, 25 Jun 2024 12:08:16 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-damon_nr_regions-test-online-tuned-max_nr_regions.patch added to mm-unstable branch
Message-Id: <20240625190816.B11A9C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/damon_nr_regions: test online-tuned max_nr_regions
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-damon_nr_regions-test-online-tuned-max_nr_regions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-damon_nr_regions-test-online-tuned-max_nr_regions.patch

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

