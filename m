Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9BA2E36FD
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 03:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753153883; cv=none; b=ej7WEww6CwTgRwkKoibtNjHi3T2zxLRcv3kIXn8kXKh8V/Vdhm8mxL1ezMKgQZVfSS7zQUmy4QOhSG8fNMAn6OPLX75ReVGzn89TrZARSDe2WcqDYn02JsW2f+am1odTguFxNKqRq5S7NnrzVuKcyA+utzsLLo7+7w5ZY8deqic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753153883; c=relaxed/simple;
	bh=GynPvDjSAaNj5J3pi1DAL8NkwLmBgIdMy+FX7HZLorY=;
	h=Date:To:From:Subject:Message-Id; b=jzoirWsscswiCExFA/ZW7/C/SNi9D87njbOAjGmfSJApzn3eC9njof+nMwqrSyrHa8znvdtJWlHPxn8jt75yOe5VpsXaGiPlODizW+d5CUfDkw/EjC/xQTlDM7X0AJVMjZUrYKQUZdAtZCBsroZ1CcTpP31+GOoI/gR0OfQsUAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N7nGmXIT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N7nGmXIT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D32CC4CEED;
	Tue, 22 Jul 2025 03:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753153883;
	bh=GynPvDjSAaNj5J3pi1DAL8NkwLmBgIdMy+FX7HZLorY=;
	h=Date:To:From:Subject:From;
	b=N7nGmXITSgocSw3Hr1X9pIxnOaYVBSow2hK+lai+aTPXh/WI0BT9+Vs8Tl5BynYZP
	 /d+cR+uaaqOCXKNQJ37bD5IMBrCN1dJfoGcTfSXKWXJ8j6TY9s46b/90/89RjfokGX
	 jI4qnL2mMjvAucxR0mUudeBQ7Nh7hQXkN/f+Ao5k=
Date: Mon, 21 Jul 2025 20:11:22 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-_damon_sysfs-support-damos-watermarks-setup.patch added to mm-new branch
Message-Id: <20250722031123.5D32CC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/_damon_sysfs: support DAMOS watermarks setup
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-_damon_sysfs-support-damos-watermarks-setup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-_damon_sysfs-support-damos-watermarks-setup.patch

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
Subject: selftests/damon/_damon_sysfs: support DAMOS watermarks setup
Date: Sun, 20 Jul 2025 10:16:31 -0700

Patch series "selftests/damon/sysfs.py: test all parameters".

sysfs.py tests if DAMON sysfs interface is passing the user-requested
parameters to DAMON as expected.  But only the default (minimum)
parameters are being tested.  This is partially because _damon_sysfs.py,
which is the library for making the parameter requests, is not supporting
the entire parameters.  The internal DAMON status dump script
(drgn_dump_damon_status.py) is also not dumping entire parameters.  Extend
the test coverage by updating parameters input and status dumping scripts
to support all parameters, and writing additional tests using those.

This increased test coverage actually found one real bug
(https://lore.kernel.org/20250719181932.72944-1-sj@kernel.org).

First seven patches (1-7) extend _damon_sysfs.py for all parameters setup.
The eight patch (8) fixes _damon_sysfs.py to use correct max nr_acceses
and age values for their type.  Following three patches (9-11) extend
drgn_dump_damon_status.py to dump full DAMON parameters.  Following nine
patches (12-20) refactor sysfs.py for general testing code reuse, and
extend it for full parameters check.  Finally, two patches (21 and 22) add
test cases in sysfs.py for full parameters testing.


This patch (of 22):

_damon_sysfs.py contains code for test-purpose DAMON sysfs interface
control.  Add support of DAMOS watermarks setup for more tests.

Link: https://lkml.kernel.org/r/20250720171652.92309-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250720171652.92309-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |   46 ++++++++++++++--
 1 file changed, 42 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-_damon_sysfs-support-damos-watermarks-setup
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -165,6 +165,42 @@ class DamosQuota:
                 return err
         return None
 
+class DamosWatermarks:
+    metric = None
+    interval = None
+    high = None
+    mid = None
+    low = None
+    scheme = None   # owner scheme
+
+    def __init__(self, metric='none', interval=0, high=0, mid=0, low=0):
+        self.metric = metric
+        self.interval = interval
+        self.high = high
+        self.mid = mid
+        self.low = low
+
+    def sysfs_dir(self):
+        return os.path.join(self.scheme.sysfs_dir(), 'watermarks')
+
+    def stage(self):
+        err = write_file(os.path.join(self.sysfs_dir(), 'metric'), self.metric)
+        if err is not None:
+            return err
+        err = write_file(os.path.join(self.sysfs_dir(), 'interval_us'),
+                         self.interval)
+        if err is not None:
+            return err
+        err = write_file(os.path.join(self.sysfs_dir(), 'high'), self.high)
+        if err is not None:
+            return err
+        err = write_file(os.path.join(self.sysfs_dir(), 'mid'), self.mid)
+        if err is not None:
+            return err
+        err = write_file(os.path.join(self.sysfs_dir(), 'low'), self.low)
+        if err is not None:
+            return err
+
 class DamosStats:
     nr_tried = None
     sz_tried = None
@@ -190,6 +226,7 @@ class Damos:
     action = None
     access_pattern = None
     quota = None
+    watermarks = None
     apply_interval_us = None
     # todo: Support watermarks, stats
     idx = None
@@ -199,12 +236,15 @@ class Damos:
     tried_regions = None
 
     def __init__(self, action='stat', access_pattern=DamosAccessPattern(),
-                 quota=DamosQuota(), apply_interval_us=0):
+                 quota=DamosQuota(), watermarks=DamosWatermarks(),
+                 apply_interval_us=0):
         self.action = action
         self.access_pattern = access_pattern
         self.access_pattern.scheme = self
         self.quota = quota
         self.quota.scheme = self
+        self.watermarks = watermarks
+        self.watermarks.scheme = self
         self.apply_interval_us = apply_interval_us
 
     def sysfs_dir(self):
@@ -227,9 +267,7 @@ class Damos:
         if err is not None:
             return err
 
-        # disable watermarks
-        err = write_file(
-                os.path.join(self.sysfs_dir(), 'watermarks', 'metric'), 'none')
+        err = self.watermarks.stage()
         if err is not None:
             return err
 
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

