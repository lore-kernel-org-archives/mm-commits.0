Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D1522333B
	for <mm-commits@vger.kernel.org>; Sat, 26 Jul 2025 22:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753567820; cv=none; b=G6ZkjpGEIjZ6jMoSmLjTv8pXV3J+e50w3LnuDFxwrRsCD8d+dHZnWO/eoLrRS8VOUf6tBBcR++EKG5UW14fK48g3AhvsoB4Ko25OxgQtATO1X32xBxrw4joq8zEIJJT2yPADMxm3fF7BnT+xEvtOujRsEzdOxHX65yHu7f5/2yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753567820; c=relaxed/simple;
	bh=15sDvP+SuiH5vz/DK7pz8/s0ZBcpeuGIcCKA33RY1RI=;
	h=Date:To:From:Subject:Message-Id; b=DNCF9f7ZGWKhMUBSXgu3MRCrfb1+kXMs/boqZaOEu6xkrfP2zyZqwMoC1HzJh+k/mVSiwSssuXNeWboTAafbXADoy4TtEOBDFAFVlk0o94ytN/UnolVccYSwKKKQEuExMyQMkZEuB4Qy2YA5bfIGOG5dchR3lLdCSFLe+LpumPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h1LiIwgo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h1LiIwgo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 160DBC4CEED;
	Sat, 26 Jul 2025 22:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753567820;
	bh=15sDvP+SuiH5vz/DK7pz8/s0ZBcpeuGIcCKA33RY1RI=;
	h=Date:To:From:Subject:From;
	b=h1LiIwgoMi/m+NNNFWIkaGJBFMp7eSyM/AxMjQzOAIkMdByZQkRjkcsXcOIYJFXpG
	 MmlCAzNdZjil2kOOsc3TcMGGKJtFyBO91ZxKle4yAHZENvl/JboL9DjAOnGujUBvIK
	 07lzEn4Y3nnJSYoAr9hsLKZPleYc43GFf3nKA7i4=
Date: Sat, 26 Jul 2025 15:10:19 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-sysfspy-generalize-damosquota-commit-assertion.patch removed from -mm tree
Message-Id: <20250726221020.160DBC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/sysfs.py: generalize DamosQuota commit assertion
has been removed from the -mm tree.  Its filename was
     selftests-damon-sysfspy-generalize-damosquota-commit-assertion.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/sysfs.py: generalize DamosQuota commit assertion
Date: Sun, 20 Jul 2025 10:16:43 -0700

DamosQuota commitment assertion is hard-coded for a specific test case. 
Split it out into a general version that can be reused for different test
cases.

Link: https://lkml.kernel.org/r/20250720171652.92309-14-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.py |   31 ++++++++++++++---------
 1 file changed, 20 insertions(+), 11 deletions(-)

--- a/tools/testing/selftests/damon/sysfs.py~selftests-damon-sysfspy-generalize-damosquota-commit-assertion
+++ a/tools/testing/selftests/damon/sysfs.py
@@ -45,6 +45,18 @@ def assert_watermarks_committed(watermar
     assert_true(dump['mid'] == watermarks.mid, 'mid', dump)
     assert_true(dump['low'] == watermarks.low, 'low', dump)
 
+def assert_quota_committed(quota, dump):
+    assert_true(dump['reset_interval'] == quota.reset_interval_ms,
+                'reset_interval', dump)
+    assert_true(dump['ms'] == quota.ms, 'ms', dump)
+    assert_true(dump['sz'] == quota.sz, 'sz', dump)
+    # TODO: assert goals are committed
+    assert_true(dump['weight_sz'] == quota.weight_sz_permil, 'weight_sz', dump)
+    assert_true(dump['weight_nr_accesses'] == quota.weight_nr_accesses_permil,
+                'weight_nr_accesses', dump)
+    assert_true(
+            dump['weight_age'] == quota.weight_age_permil, 'weight_age', dump)
+
 def main():
     kdamonds = _damon_sysfs.Kdamonds(
             [_damon_sysfs.Kdamond(
@@ -109,18 +121,15 @@ def main():
     if scheme['target_nid'] != -1:
         fail('damos target nid', status)
 
-    if scheme['quota'] != {
-            'reset_interval': 0,
-            'ms': 0,
-            'sz': 0,
-            'goals': [],
-            'esz': 0,
-            'weight_sz': 0,
-            'weight_nr_accesses': 0,
-            'weight_age': 0,
-            }:
-        fail('damos quota', status)
+    migrate_dests = scheme['migrate_dests']
+    if migrate_dests['nr_dests'] != 0:
+        fail('nr_dests', status)
+    if migrate_dests['node_id_arr'] != []:
+        fail('node_id_arr', status)
+    if migrate_dests['weight_arr'] != []:
+        fail('weight_arr', status)
 
+    assert_quota_committed(_damon_sysfs.DamosQuota(), scheme['quota'])
     assert_watermarks_committed(_damon_sysfs.DamosWatermarks(),
                                 scheme['wmarks'])
 
_

Patches currently in -mm which might be from sj@kernel.org are


