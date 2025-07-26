Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFF1228CBC
	for <mm-commits@vger.kernel.org>; Sat, 26 Jul 2025 22:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753567806; cv=none; b=g/NVlILF7WLssDJX/XYfXiarTOON2DrNvPmqOI1kSW4EXaZisiSnb9yjcdN/C925FOSBpVPLwKG8hRsmuDhTfoivk5B22wXAOHhqMieW24Rg+ob7zoMQGHRpzPMs2sQPLNETQ/ud8J3pUa75kBdUqmP2iagxwlmBPNpuBiax+eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753567806; c=relaxed/simple;
	bh=0cD3GTcoKvcU+C8HsybsDaUCtLvjnaUSQjPu/YTmKZQ=;
	h=Date:To:From:Subject:Message-Id; b=UY9PeONngc+xrnwEHvrrTWcEgHZzaKsqjFl8v3Vbyzj1mIWnU/NFEB+wWa++/tzAlnSZ2Yx3tKGOczUuCncWGLYVy+PUOc36T/P+V/Drkr9vg8onf4/sORHzGoZyLDH22SxSqYkwqqpKUPB5yGBM3gIpMNfdyv/2HU9u27MvZfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EPmEwVoh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EPmEwVoh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F44C4CEF4;
	Sat, 26 Jul 2025 22:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753567806;
	bh=0cD3GTcoKvcU+C8HsybsDaUCtLvjnaUSQjPu/YTmKZQ=;
	h=Date:To:From:Subject:From;
	b=EPmEwVohEDsKt/AqFS8ExJTrjntB8VauAmm8xMmZMFuqo8MtrVaii9qSwdxBhEQiM
	 5HpYYPVp8V+PD58rwJzaHSPiuz4P8/2KlOj1l6sdAs9GRNK7hI4G0VCZqjEhm+jiJN
	 3GbaTYuMOdReqZUpkwSr+XenEe12HyoiaSEcWScA=
Date: Sat, 26 Jul 2025 15:10:05 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-_damon_sysfs-support-damos-watermarks-setup.patch removed from -mm tree
Message-Id: <20250726221006.46F44C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/_damon_sysfs: support DAMOS watermarks setup
has been removed from the -mm tree.  Its filename was
     selftests-damon-_damon_sysfs-support-damos-watermarks-setup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


