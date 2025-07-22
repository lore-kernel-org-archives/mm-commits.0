Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43653C463
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 03:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753153903; cv=none; b=ZQ3GzE4IupF+ELg/yP75EWdfYuUB3ZFWkTsM1k5/NYgmB7XHAZ0amDJHwRuxvKQeIgbDC4Ia6cufwVp3Q878aEj/R1PTyrKQHrQ/NJV4E0/bdb2Cms+VWkXyxVcwdxjg1kTDtkP5vTM2m/Oouxd3LGz8GTD9cHIOj6rbprpg6YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753153903; c=relaxed/simple;
	bh=mdQgfNaWtNZZ1hjTF2MptDD6lj7QIPD/wQFUWoeiFpE=;
	h=Date:To:From:Subject:Message-Id; b=hTW8P53dnoKxhwjN3PmIGtKyE+Dot+iOg6SFDFuctuGuejz5VC5bHa8wzRFPkSASanau2a8EiL6bPKFihipANG49mItEY/tBgvw1Zl70lAzIxcvDguT2gisT8HIoc59KdY4LsrHBbbWgomqsLfRDw50YlH6qGwuNP+stX9cddss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NsOvKFyG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NsOvKFyG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A20C4CEED;
	Tue, 22 Jul 2025 03:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753153903;
	bh=mdQgfNaWtNZZ1hjTF2MptDD6lj7QIPD/wQFUWoeiFpE=;
	h=Date:To:From:Subject:From;
	b=NsOvKFyGs6qpUsLYfuZMRIG5EhT7sPaLNjFA6svLL3qhfUCz1oySClcUNe4Pxk3PV
	 K4Huqjf12oRSikMOd9VFPSCa3eAjiWbYzBpa0Aey0pm1VKg6OmJEk/7Vt0dVMRJ80M
	 gb8iTRKZYT0W/jQGGiQXPHMQdxlHiT6080/lSHuM=
Date: Mon, 21 Jul 2025 20:11:43 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-sysfspy-generalize-damos-watermarks-commit-assertion.patch added to mm-new branch
Message-Id: <20250722031143.87A20C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/sysfs.py: generalize DAMOS Watermarks commit assertion
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-sysfspy-generalize-damos-watermarks-commit-assertion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-sysfspy-generalize-damos-watermarks-commit-assertion.patch

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
@@ -25,6 +25,22 @@ def fail(expectation, status):
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
@@ -100,14 +116,8 @@ def main():
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

mm-damon-core-commit-damos_quota_goal-nid.patch
mm-damon-sysfs-implement-refresh_ms-file-under-kdamond-directory.patch
mm-damon-sysfs-implement-refresh_ms-file-internal-work.patch
docs-admin-guide-mm-damon-usage-document-refresh_ms-file.patch
docs-abi-damon-update-for-refresh_ms.patch
mm-damon-ops-common-ignore-migration-request-to-invalid-nodes.patch
selftests-damon-_damon_sysfs-support-damos-watermarks-setup.patch
selftests-damon-_damon_sysfs-support-damos-filters-setup.patch
selftests-damon-_damon_sysfs-support-monitoring-intervals-goal-setup.patch
selftests-damon-_damon_sysfs-support-damos-quota-weights-setup.patch
selftests-damon-_damon_sysfs-support-damos-quota-goal-nid-setup.patch
selftests-damon-_damon_sysfs-support-damos-action-dests-setup.patch
selftests-damon-_damon_sysfs-support-damos-target_nid-setup.patch
selftests-damon-_damon_sysfs-use-232-1-as-max-nr_accesses-and-age.patch
selftests-damon-drgn_dump_damon_status-dump-damos-migrate_dests.patch
selftests-damon-drgn_dump_damon_status-dump-ctx-opsid.patch
selftests-damon-drgn_dump_damon_status-dump-damos-filters.patch
selftests-damon-sysfspy-generalize-damos-watermarks-commit-assertion.patch
selftests-damon-sysfspy-generalize-damosquota-commit-assertion.patch
selftests-damon-sysfspy-test-quota-goal-commitment.patch
selftests-damon-sysfspy-test-damos-destinations-commitment.patch
selftests-damon-sysfspy-generalize-damos-access-pattern-commit-assertion.patch
selftests-damon-sysfspy-test-damos-filters-commitment.patch
selftests-damon-sysfspy-generalize-damos-schemes-commit-assertion.patch
selftests-damon-sysfspy-generalize-monitoring-attributes-commit-assertion.patch
selftests-damon-sysfspy-generalize-damon-context-commit-assertion.patch
selftests-damon-sysfspy-test-non-default-parameters-runtime-commit.patch
selftests-damon-sysfspy-test-runtime-reduction-of-damon-parameters.patch

