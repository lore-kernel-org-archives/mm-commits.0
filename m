Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2411DE885
	for <mm-commits@vger.kernel.org>; Sat, 26 Jul 2025 22:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753567808; cv=none; b=UPA7kDRk0AYFXqU/FvP0l0XpWATbSJXd+D2z5evFPVdJ5eAEsqM0ZlR3poYiJH1QWuI24/A1q38OSHF//AY/PJEYtpZJYGxBEDVqaIusfoFeIf9PJatj8W7Yj+gKpShFfjCzSbADPA8JysX5BG2jOQaP7yHHbWXR9tX61uYBz54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753567808; c=relaxed/simple;
	bh=MvarXsE/eD4jNvbW7DIpIK4ar2g0Jmt9U3vDTGWWuAk=;
	h=Date:To:From:Subject:Message-Id; b=Ulpws6fJsmSEoktVrWedbOuFtYYZhKJ9qYz1Xjltky1sB17SWJYLvSPhQq+IOosoObKPcZIWjVuKxtDr+diuShrP9FtcnbHgVv9QSHt4HNqfrKlcAz6Cs3dVrOcNDDSPjIDTp6hzJVRr6/D9l1Cm9I82MTUGm+kD3n82a5fGrlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xTPKR5KJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xTPKR5KJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A30B3C4CEED;
	Sat, 26 Jul 2025 22:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753567808;
	bh=MvarXsE/eD4jNvbW7DIpIK4ar2g0Jmt9U3vDTGWWuAk=;
	h=Date:To:From:Subject:From;
	b=xTPKR5KJwmG47juuXdony4iBZdwPHjtFGbX6wcPR2uka2yaZdo9hXDkdOlpn2uviU
	 PXDx1CobMmOH30LPA/adjZw8cNkEHZ4bY5SSXY4FTa2JKAhae4+Dtfdet4bT5FeCsw
	 oyVtBgV2mykspNs+pcyyuwvSm70scnK8p7pzHyYc=
Date: Sat, 26 Jul 2025 15:10:08 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-_damon_sysfs-support-monitoring-intervals-goal-setup.patch removed from -mm tree
Message-Id: <20250726221008.A30B3C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/_damon_sysfs: support monitoring intervals goal setup
has been removed from the -mm tree.  Its filename was
     selftests-damon-_damon_sysfs-support-monitoring-intervals-goal-setup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/_damon_sysfs: support monitoring intervals goal setup
Date: Sun, 20 Jul 2025 10:16:33 -0700

_damon_sysfs.py contains code for test-purpose DAMON sysfs interface
control.  Add support of the monitoring intervals auto-tune goal setup for
more tests.

Link: https://lkml.kernel.org/r/20250720171652.92309-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |   43 +++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-_damon_sysfs-support-monitoring-intervals-goal-setup
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -405,18 +405,56 @@ class DamonTarget:
         return write_file(
                 os.path.join(self.sysfs_dir(), 'pid_target'), self.pid)
 
+class IntervalsGoal:
+    access_bp = None
+    aggrs = None
+    min_sample_us = None
+    max_sample_us = None
+    attrs = None    # owner DamonAttrs
+
+    def __init__(self, access_bp=0, aggrs=0, min_sample_us=0, max_sample_us=0):
+        self.access_bp = access_bp
+        self.aggrs = aggrs
+        self.min_sample_us = min_sample_us
+        self.max_sample_us = max_sample_us
+
+    def sysfs_dir(self):
+        return os.path.join(self.attrs.interval_sysfs_dir(), 'intervals_goal')
+
+    def stage(self):
+        err = write_file(
+                os.path.join(self.sysfs_dir(), 'access_bp'), self.access_bp)
+        if err is not None:
+            return err
+        err = write_file(os.path.join(self.sysfs_dir(), 'aggrs'), self.aggrs)
+        if err is not None:
+            return err
+        err = write_file(os.path.join(self.sysfs_dir(), 'min_sample_us'),
+                         self.min_sample_us)
+        if err is not None:
+            return err
+        err = write_file(os.path.join(self.sysfs_dir(), 'max_sample_us'),
+                         self.max_sample_us)
+        if err is not None:
+            return err
+        return None
+
 class DamonAttrs:
     sample_us = None
     aggr_us = None
+    intervals_goal = None
     update_us = None
     min_nr_regions = None
     max_nr_regions = None
     context = None
 
-    def __init__(self, sample_us=5000, aggr_us=100000, update_us=1000000,
+    def __init__(self, sample_us=5000, aggr_us=100000,
+                 intervals_goal=IntervalsGoal(), update_us=1000000,
             min_nr_regions=10, max_nr_regions=1000):
         self.sample_us = sample_us
         self.aggr_us = aggr_us
+        self.intervals_goal = intervals_goal
+        self.intervals_goal.attrs = self
         self.update_us = update_us
         self.min_nr_regions = min_nr_regions
         self.max_nr_regions = max_nr_regions
@@ -438,6 +476,9 @@ class DamonAttrs:
                 self.aggr_us)
         if err is not None:
             return err
+        err = self.intervals_goal.stage()
+        if err is not None:
+            return err
         err = write_file(os.path.join(self.interval_sysfs_dir(), 'update_us'),
                 self.update_us)
         if err is not None:
_

Patches currently in -mm which might be from sj@kernel.org are


