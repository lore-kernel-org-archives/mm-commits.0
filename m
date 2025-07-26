Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65FBA21CA1D
	for <mm-commits@vger.kernel.org>; Sat, 26 Jul 2025 22:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753567828; cv=none; b=WjIbkzlOzPJelkr/RSz49il3GpO6vcfgjrtu0p7o0HJhdncmN4vadfaK/ABXEyJUPZkjUt/jqMtaxKPJw86bUJQymIozze92V/u4aBKNOQR8qE8Go40p2/2wyRQEVeBhz9IAeRrwC9S6GsM2eJOrzxcZI5ZCRr8J2AxWCEy5OTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753567828; c=relaxed/simple;
	bh=c5WECyPoSHEPrgqN5G+1WlK2fINVkDpilkTKBeNQOY4=;
	h=Date:To:From:Subject:Message-Id; b=cAcY9J1qs8CYeuZ2RRH1jKwv67rDklyjZHSG+bGyj5jClPsrMUVh3T8JHVykeLxbeQInd+Qz4HzcKXsn9oU3TgHs5GMIz3cLzhOaXMNTinoN5/v1RQRyjT/ZcYMTWmmduDt9FXZDeSjD6BEq84QjtX7D1PI1LkmYCW1kcFTngAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TRHkvIIR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TRHkvIIR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3920AC4CEF4;
	Sat, 26 Jul 2025 22:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753567828;
	bh=c5WECyPoSHEPrgqN5G+1WlK2fINVkDpilkTKBeNQOY4=;
	h=Date:To:From:Subject:From;
	b=TRHkvIIR636UH00uC6VoHBkHoaRXg5SH14rk0jfXK1OySeWaCkC135G4axAbI5OfZ
	 g/nCe2eMhb2AAJlFVwkMjqa/NombpPhes3CFC934jpCe4TsruF8h8X2GRhDCD0LL1M
	 wyCgA0K0VxAQm/Y8g/LVfVaujrPn5JGf5rVRNby0=
Date: Sat, 26 Jul 2025 15:10:27 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-sysfspy-generalize-damon-context-commit-assertion.patch removed from -mm tree
Message-Id: <20250726221028.3920AC4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/sysfs.py: generalize DAMON context commit assertion
has been removed from the -mm tree.  Its filename was
     selftests-damon-sysfspy-generalize-damon-context-commit-assertion.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/sysfs.py: generalize DAMON context commit assertion
Date: Sun, 20 Jul 2025 10:16:50 -0700

DAMON context commitment assertion is hard-coded for a specific test case.
Split it out into a general version that can be reused for different test
cases.

Link: https://lkml.kernel.org/r/20250720171652.92309-21-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.py |   28 +++++++++++++----------
 1 file changed, 16 insertions(+), 12 deletions(-)

--- a/tools/testing/selftests/damon/sysfs.py~selftests-damon-sysfspy-generalize-damon-context-commit-assertion
+++ a/tools/testing/selftests/damon/sysfs.py
@@ -164,6 +164,21 @@ def assert_monitoring_attrs_committed(at
     assert_true(dump['max_nr_regions'] == attrs.max_nr_regions,
                 'max_nr_regions', dump)
 
+def assert_ctx_committed(ctx, dump):
+    ops_val = {
+            'vaddr': 0,
+            'fvaddr': 1,
+            'paddr': 2,
+            }
+    assert_true(dump['ops']['id'] == ops_val[ctx.ops], 'ops_id', dump)
+    assert_monitoring_attrs_committed(ctx.monitoring_attrs, dump['attrs'])
+    assert_schemes_committed(ctx.schemes, dump['schemes'])
+
+def assert_ctxs_committed(ctxs, dump):
+    assert_true(len(ctxs) == len(dump), 'ctxs length', dump)
+    for idx, ctx in enumerate(ctxs):
+        assert_ctx_committed(ctx, dump[idx])
+
 def main():
     kdamonds = _damon_sysfs.Kdamonds(
             [_damon_sysfs.Kdamond(
@@ -182,18 +197,7 @@ def main():
         kdamonds.stop()
         exit(1)
 
-    if len(status['contexts']) != 1:
-        fail('number of contexts', status)
-
-    ctx = status['contexts'][0]
-
-    assert_monitoring_attrs_committed(_damon_sysfs.DamonAttrs(), ctx['attrs'])
-
-    if ctx['adaptive_targets'] != [
-            { 'pid': 0, 'nr_regions': 0, 'regions_list': []}]:
-        fail('adaptive targets', status)
-
-    assert_schemes_committed([_damon_sysfs.Damos()], ctx['schemes'])
+    assert_ctxs_committed(kdamonds.kdamonds[0].contexts, status['contexts'])
 
     kdamonds.stop()
 
_

Patches currently in -mm which might be from sj@kernel.org are


