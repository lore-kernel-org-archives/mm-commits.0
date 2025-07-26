Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FCF522333B
	for <mm-commits@vger.kernel.org>; Sat, 26 Jul 2025 22:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753567819; cv=none; b=EgsihmZ1E+WcqzyHzXjipxJVfW439tpHwVtJY6oSB4pk8l51n/a0mox/MhNry4XyeM2TUzI0cMg7zXqY3qmGHvNcZkUr+cJG3nTOeXRCbOnD+NeY/YiPtWy5g9zE3XkH1WucsBHVM4A8W5VtThchZg6YGf9XB+UxbEgRKpyqMmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753567819; c=relaxed/simple;
	bh=+h0nnOi6rRQae6AY4wRm39heEK2uXE4bLyHkaReQv/8=;
	h=Date:To:From:Subject:Message-Id; b=HEZnnYpJCFofM+/pH2wT9d2SPVBjiYUkX9VPgVxFWhSc3ofQnVnlMEH8bdh8ltE33scF2MyOQzSQNkMVluEVnmDEqq4Dbq09E2JjGaEuxNtueOpCzmngHXt/ltihCxtWDmpfpTqnajJ/yP6fdBgR8pC6QNQMucVTwpAuBSMwBsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fdJ2eFt6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fdJ2eFt6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F3EC4CEED;
	Sat, 26 Jul 2025 22:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753567819;
	bh=+h0nnOi6rRQae6AY4wRm39heEK2uXE4bLyHkaReQv/8=;
	h=Date:To:From:Subject:From;
	b=fdJ2eFt65+wG333zjpJUZBkpNy85ABLgQgntM0wVU9T3h+ZSJM3lpc++H5XcZd5ay
	 FEU4xro/FRglrjvgd2IBtRGBWFsw290hovrZ4oZjIBWnicTSkYigbEvAphNEljIj+q
	 vw0sDkXn2ur6H97VxeuRGBqHW0d8cnF9h3AE4Qak=
Date: Sat, 26 Jul 2025 15:10:18 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-sysfspy-generalize-damos-watermarks-commit-assertion.patch removed from -mm tree
Message-Id: <20250726221018.E6F3EC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/sysfs.py: generalize DAMOS Watermarks commit assertion
has been removed from the -mm tree.  Its filename was
     selftests-damon-sysfspy-generalize-damos-watermarks-commit-assertion.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/sysfs.py: generalize DAMOS Watermarks commit assertion
Date: Sun, 20 Jul 2025 10:16:42 -0700

DamosWatermarks commitment assertion is hard-coded for a specific test
case.  Split it out into a general version that can be reused for
different test cases.

Link: https://lkml.kernel.org/r/20250720171652.92309-13-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.py |   26 +++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/damon/sysfs.py~selftests-damon-sysfspy-generalize-damos-watermarks-commit-assertion
+++ a/tools/testing/selftests/damon/sysfs.py
@@ -29,6 +29,22 @@ def fail(expectation, status):
     print(json.dumps(status, indent=4))
     exit(1)
 
+def assert_true(condition, expectation, status):
+    if condition is not True:
+        fail(expectation, status)
+
+def assert_watermarks_committed(watermarks, dump):
+    wmark_metric_val = {
+            'none': 0,
+            'free_mem_rate': 1,
+            }
+    assert_true(dump['metric'] == wmark_metric_val[watermarks.metric],
+                'metric', dump)
+    assert_true(dump['interval'] == watermarks.interval, 'interval', dump)
+    assert_true(dump['high'] == watermarks.high, 'high', dump)
+    assert_true(dump['mid'] == watermarks.mid, 'mid', dump)
+    assert_true(dump['low'] == watermarks.low, 'low', dump)
+
 def main():
     kdamonds = _damon_sysfs.Kdamonds(
             [_damon_sysfs.Kdamond(
@@ -105,14 +121,8 @@ def main():
             }:
         fail('damos quota', status)
 
-    if scheme['wmarks'] != {
-            'metric': 0,
-            'interval': 0,
-            'high': 0,
-            'mid': 0,
-            'low': 0,
-            }:
-        fail('damos wmarks', status)
+    assert_watermarks_committed(_damon_sysfs.DamosWatermarks(),
+                                scheme['wmarks'])
 
     kdamonds.stop()
 
_

Patches currently in -mm which might be from sj@kernel.org are


