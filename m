Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E727E24A0D
	for <mm-commits@vger.kernel.org>; Sat, 11 May 2024 22:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715467325; cv=none; b=Rlvq6lLzZyU25D3XZQseSR5lPDcgZPAhsDAan1VTwz5lyAasb74SuBhvVgW6cAdVS104h0IFPPPtDZmRe3jsVyORtzLHoJgaCwFLrsGTKLNl2ZzjSu2+a3nzKHIxjN3eyERu6wzWZDayhn3SkYTCuYZjfmpeu2WJatIasgXjC00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715467325; c=relaxed/simple;
	bh=sdTvayAbpkMTWHPwyoCrXMkSGYS2LgzjHJ9XFx2SO+o=;
	h=Date:To:From:Subject:Message-Id; b=QtWoGYJ6Rjak3nnOK/YcuqKnXzaj305TaNwU7/dMYvtzO3ws7IWA3Geb7aUa/Ck8f70/vvIVpmy9pjdUeNS4NHotsNEwUEbJiY3TGvbthuaHEZXobAGng8TeO0s6oE7kVq3XGTiIEj5js2FuksW9RADG2lvhfdiy5WXDOVaQwR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O1cpxze1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O1cpxze1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C72CC32781;
	Sat, 11 May 2024 22:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715467324;
	bh=sdTvayAbpkMTWHPwyoCrXMkSGYS2LgzjHJ9XFx2SO+o=;
	h=Date:To:From:Subject:From;
	b=O1cpxze1VC+lAsPL9sytXXteYF8Xl+II47EyxbZ2jInxUZl0FiJnpiXsJwy2frfxg
	 /MQs3dP5jZpkxL7nLudBquL6fsPJ9PoDCWM7dtr/AOdQ+pAR2tSrtdeUSjPdLdhuyA
	 gGlhpHnxRC6ZDg8h4w/8JB/EdxtxRqG+nc6ptEpk=
Date: Sat, 11 May 2024 15:42:03 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-_damon_sysfs-support-quota-goals.patch removed from -mm tree
Message-Id: <20240511224204.6C72CC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/_damon_sysfs: support quota goals
has been removed from the -mm tree.  Its filename was
     selftests-damon-_damon_sysfs-support-quota-goals.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/_damon_sysfs: support quota goals
Date: Thu, 2 May 2024 10:27:17 -0700

Patch series "selftests/damon: add DAMOS quota goal test".

Extend DAMON selftest-purpose sysfs wrapper to support DAMOS quota goal,
and implement a simple selftest for the feature using it.


This patch (of 2):

The DAMON sysfs test purpose wrapper, _damon_sysfs.py, is not supporting
quota goals.  Implement the support for testing the feature.  The test
will be implemented and added by the following commit.

Link: https://lkml.kernel.org/r/20240502172718.74166-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20240502172718.74166-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |   84 +++++++++++++++-
 1 file changed, 83 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-_damon_sysfs-support-quota-goals
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -70,16 +70,56 @@ class DamosAccessPattern:
         if err != None:
             return err
 
+qgoal_metric_user_input = 'user_input'
+qgoal_metric_some_mem_psi_us = 'some_mem_psi_us'
+qgoal_metrics = [qgoal_metric_user_input, qgoal_metric_some_mem_psi_us]
+
+class DamosQuotaGoal:
+    metric = None
+    target_value = None
+    current_value = None
+    effective_bytes = None
+    quota = None            # owner quota
+    idx = None
+
+    def __init__(self, metric, target_value=10000, current_value=0):
+        self.metric = metric
+        self.target_value = target_value
+        self.current_value = current_value
+
+    def sysfs_dir(self):
+        return os.path.join(self.quota.sysfs_dir(), 'goals', '%d' % self.idx)
+
+    def stage(self):
+        err = write_file(os.path.join(self.sysfs_dir(), 'target_metric'),
+                         self.metric)
+        if err is not None:
+            return err
+        err = write_file(os.path.join(self.sysfs_dir(), 'target_value'),
+                         self.target_value)
+        if err is not None:
+            return err
+        err = write_file(os.path.join(self.sysfs_dir(), 'current_value'),
+                         self.current_value)
+        if err is not None:
+            return err
+        return None
+
 class DamosQuota:
     sz = None                   # size quota, in bytes
     ms = None                   # time quota
+    goals = None                # quota goals
     reset_interval_ms = None    # quota reset interval
     scheme = None               # owner scheme
 
-    def __init__(self, sz=0, ms=0, reset_interval_ms=0):
+    def __init__(self, sz=0, ms=0, goals=None, reset_interval_ms=0):
         self.sz = sz
         self.ms = ms
         self.reset_interval_ms = reset_interval_ms
+        self.goals = goals if goals is not None else []
+        for idx, goal in enumerate(self.goals):
+            goal.idx = idx
+            goal.quota = self
 
     def sysfs_dir(self):
         return os.path.join(self.scheme.sysfs_dir(), 'quotas')
@@ -96,6 +136,20 @@ class DamosQuota:
         if err != None:
             return err
 
+        nr_goals_file = os.path.join(self.sysfs_dir(), 'goals', 'nr_goals')
+        content, err = read_file(nr_goals_file)
+        if err is not None:
+            return err
+        if int(content) != len(self.goals):
+            err = write_file(nr_goals_file, len(self.goals))
+            if err is not None:
+                return err
+        for goal in self.goals:
+            err = goal.stage()
+            if err is not None:
+                return err
+        return None
+
 class DamosStats:
     nr_tried = None
     sz_tried = None
@@ -361,6 +415,34 @@ class Kdamond:
                     stat_values.append(int(content))
                 scheme.stats = DamosStats(*stat_values)
 
+    def update_schemes_effective_quotas(self):
+        err = write_file(os.path.join(self.sysfs_dir(), 'state'),
+                         'update_schemes_effective_quotas')
+        if err is not None:
+            return err
+        for context in self.contexts:
+            for scheme in context.schemes:
+                for goal in scheme.quota.goals:
+                    content, err = read_file(
+                            os.path.join(scheme.quota.sysfs_dir(),
+                                         'effective_bytes'))
+                    if err is not None:
+                        return err
+                    goal.effective_bytes = int(content)
+        return None
+
+    def commit_schemes_quota_goals(self):
+        for context in self.contexts:
+            for scheme in context.schemes:
+                for goal in scheme.quota.goals:
+                    err = goal.stage()
+                    if err is not None:
+                        print('commit_schemes_quota_goals failed stagign: %s'%
+                              err)
+                        exit(1)
+        return write_file(os.path.join(self.sysfs_dir(), 'state'),
+                         'commit_schemes_quota_goals')
+
 class Kdamonds:
     kdamonds = []
 
_

Patches currently in -mm which might be from sj@kernel.org are


