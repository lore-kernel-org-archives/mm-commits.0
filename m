Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5879B22333B
	for <mm-commits@vger.kernel.org>; Sat, 26 Jul 2025 22:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753567812; cv=none; b=aYvJpB0ul1TignzejETsl+fGJzUlANp7UGxncATsSTXSc0TiqbAaLoMWJjm55tbz6d8PagwJuO9Msr9Zf1+rx1C9pmtBonLnaTlq7wmHoY4En2/U8o2x2SUCla9HTgCtu80B2qdFVIaBKoVa84LHoVbArtBqE+P290MIshzd+FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753567812; c=relaxed/simple;
	bh=H9tmncpMMg7Fw7pEZ9juvTlXFKKtAToQz3k4qU+8dwI=;
	h=Date:To:From:Subject:Message-Id; b=Bb8EYf7lgMUdwHDsAprRcgnX+0w7exAtH4q/ZOLTBgbyZhd6XMAW1k6yTQmWYDN13as8cAhl+Pc5bTRmILv9xOccDCCbuxk4p2GzecR4WbJJo/bxQ28BmI3VNpTjngRzDLjATN6DBkVwJsrXm3ZiaNAQWynsEO7X4XI9P/fhLRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O+eFjvCN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O+eFjvCN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CEDDC4CEED;
	Sat, 26 Jul 2025 22:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753567812;
	bh=H9tmncpMMg7Fw7pEZ9juvTlXFKKtAToQz3k4qU+8dwI=;
	h=Date:To:From:Subject:From;
	b=O+eFjvCN9jMomr2n/lQZL/iZnht2RgSc+whT0AeCKwlQiPQi3w4X2hPDXk8xUihsa
	 2YYKqGhMpdnfaeqf5+TRa+95c/a896yHMff+2LuhClIcOqhcA6r817A2Eks8ORPBmW
	 GATsXnky/GQk+5Q1yigx5EqhuncP1AnqdQiM4CgQ=
Date: Sat, 26 Jul 2025 15:10:11 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-_damon_sysfs-support-damos-action-dests-setup.patch removed from -mm tree
Message-Id: <20250726221012.2CEDDC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/_damon_sysfs: support DAMOS action dests setup
has been removed from the -mm tree.  Its filename was
     selftests-damon-_damon_sysfs-support-damos-action-dests-setup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/_damon_sysfs: support DAMOS action dests setup
Date: Sun, 20 Jul 2025 10:16:36 -0700

_damon_sysfs.py contains code for test-purpose DAMON sysfs interface
control.  Add support of DAMOS action destinations setup for more tests.

Link: https://lkml.kernel.org/r/20250720171652.92309-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |   56 +++++++++++++++-
 1 file changed, 55 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-_damon_sysfs-support-damos-action-dests-setup
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -319,6 +319,52 @@ class DamosFilters:
                 return err
         return None
 
+class DamosDest:
+    id = None
+    weight = None
+    idx = None
+    dests = None    # owner dests
+
+    def __init__(self, id=0, weight=0):
+        self.id = id
+        self.weight = weight
+
+    def sysfs_dir(self):
+        return os.path.join(self.dests.sysfs_dir(), '%d' % self.idx)
+
+    def stage(self):
+        err = write_file(os.path.join(self.sysfs_dir(), 'id'), self.id)
+        if err is not None:
+            return err
+        err = write_file(os.path.join(self.sysfs_dir(), 'weight'), self.weight)
+        if err is not None:
+            return err
+        return None
+
+class DamosDests:
+    dests = None
+    scheme = None   # owner scheme
+
+    def __init__(self, dests=[]):
+        self.dests = dests
+        for idx, dest in enumerate(self.dests):
+            dest.idx = idx
+            dest.dests = self
+
+    def sysfs_dir(self):
+        return os.path.join(self.scheme.sysfs_dir(), 'dests')
+
+    def stage(self):
+        err = write_file(os.path.join(self.sysfs_dir(), 'nr_dests'),
+                         len(self.dests))
+        if err is not None:
+            return err
+        for dest in self.dests:
+            err = dest.stage()
+            if err is not None:
+                return err
+        return None
+
 class DamosStats:
     nr_tried = None
     sz_tried = None
@@ -349,6 +395,7 @@ class Damos:
     ops_filters = None
     filters = None
     apply_interval_us = None
+    dests = None
     idx = None
     context = None
     tried_bytes = None
@@ -358,7 +405,7 @@ class Damos:
     def __init__(self, action='stat', access_pattern=DamosAccessPattern(),
                  quota=DamosQuota(), watermarks=DamosWatermarks(),
                  core_filters=[], ops_filters=[], filters=[],
-                 apply_interval_us=0):
+                 dests=DamosDests(), apply_interval_us=0):
         self.action = action
         self.access_pattern = access_pattern
         self.access_pattern.scheme = self
@@ -376,6 +423,9 @@ class Damos:
         self.filters = DamosFilters(name='filters', filters=filters)
         self.filters.scheme = self
 
+        self.dests = dests
+        self.dests.scheme = self
+
         self.apply_interval_us = apply_interval_us
 
     def sysfs_dir(self):
@@ -412,6 +462,10 @@ class Damos:
         if err is not None:
             return err
 
+        err = self.dests.stage()
+        if err is not None:
+            return err
+
 class DamonTarget:
     pid = None
     # todo: Support target regions if test is made
_

Patches currently in -mm which might be from sj@kernel.org are


