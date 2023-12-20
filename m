Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452EB4CB4B
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 22:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Tqgolv+t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E37C433CB;
	Wed, 20 Dec 2023 22:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703112560;
	bh=epHowD17s8hJ2l/AhVZHzcTurN3xIqKTljReolUt4eo=;
	h=Date:To:From:Subject:From;
	b=Tqgolv+t832mfgCQn1Gy89u0Eba9rbS4a3vYXGJIntoNHHTedQRAVjSl76QA3XMSt
	 bg3UqRvaytJYL8Prg0jdNixm5gy+B5U/LowRVDHPhNsW48eVhWptRZNzozihEgUUsb
	 iwOWYqwcRnaLFKFwTWejhVi5dGgHIynsYThvmges=
Date: Wed, 20 Dec 2023 14:49:20 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-_damon_sysfs-implement-kdamonds-start-function.patch removed from -mm tree
Message-Id: <20231220224920.B1E37C433CB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/_damon_sysfs: implement kdamonds start function
has been removed from the -mm tree.  Its filename was
     selftests-damon-_damon_sysfs-implement-kdamonds-start-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/_damon_sysfs: implement kdamonds start function
Date: Tue, 12 Dec 2023 19:48:07 +0000

Extend the tests-writing-purpose DAMON sysfs control module to support the
kdamonds start functionality.

Link: https://lkml.kernel.org/r/20231212194810.54457-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |  206 ++++++++++++++++
 1 file changed, 206 insertions(+)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-_damon_sysfs-implement-kdamonds-start-function
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -1,5 +1,28 @@
 # SPDX-License-Identifier: GPL-2.0
 
+import os
+
+sysfs_root = '/sys/kernel/mm/damon/admin'
+
+def write_file(path, string):
+    "Returns error string if failed, or None otherwise"
+    string = '%s' % string
+    try:
+        with open(path, 'w') as f:
+            f.write(string)
+    except Exception as e:
+        return '%s' % e
+    return None
+
+def read_file(path):
+    '''Returns the read content and error string.  The read content is None if
+    the reading failed'''
+    try:
+        with open(path, 'r') as f:
+            return f.read(), None
+    except Exception as e:
+        return None, '%s' % e
+
 class DamosAccessPattern:
     size = None
     nr_accesses = None
@@ -18,6 +41,35 @@ class DamosAccessPattern:
         if self.age == None:
             self.age = [0, 2**64 - 1]
 
+    def sysfs_dir(self):
+        return os.path.join(self.scheme.sysfs_dir(), 'access_pattern')
+
+    def stage(self):
+        err = write_file(
+                os.path.join(self.sysfs_dir(), 'sz', 'min'), self.size[0])
+        if err != None:
+            return err
+        err = write_file(
+                os.path.join(self.sysfs_dir(), 'sz', 'max'), self.size[1])
+        if err != None:
+            return err
+        err = write_file(os.path.join(self.sysfs_dir(), 'nr_accesses', 'min'),
+                self.nr_accesses[0])
+        if err != None:
+            return err
+        err = write_file(os.path.join(self.sysfs_dir(), 'nr_accesses', 'max'),
+                self.nr_accesses[1])
+        if err != None:
+            return err
+        err = write_file(
+                os.path.join(self.sysfs_dir(), 'age', 'min'), self.age[0])
+        if err != None:
+            return err
+        err = write_file(
+                os.path.join(self.sysfs_dir(), 'age', 'max'), self.age[1])
+        if err != None:
+            return err
+
 class Damos:
     action = None
     access_pattern = None
@@ -30,6 +82,39 @@ class Damos:
         self.access_pattern = access_pattern
         self.access_pattern.scheme = self
 
+    def sysfs_dir(self):
+        return os.path.join(
+                self.context.sysfs_dir(), 'schemes', '%d' % self.idx)
+
+    def stage(self):
+        err = write_file(os.path.join(self.sysfs_dir(), 'action'), self.action)
+        if err != None:
+            return err
+        err = self.access_pattern.stage()
+        if err != None:
+            return err
+
+        # disable quotas
+        err = write_file(os.path.join(self.sysfs_dir(), 'quotas', 'ms'), '0')
+        if err != None:
+            return err
+        err = write_file(
+                os.path.join(self.sysfs_dir(), 'quotas', 'bytes'), '0')
+        if err != None:
+            return err
+
+        # disable watermarks
+        err = write_file(
+                os.path.join(self.sysfs_dir(), 'watermarks', 'metric'), 'none')
+        if err != None:
+            return err
+
+        # disable filters
+        err = write_file(
+                os.path.join(self.sysfs_dir(), 'filters', 'nr_filters'), '0')
+        if err != None:
+            return err
+
 class DamonTarget:
     pid = None
     # todo: Support target regions if test is made
@@ -39,6 +124,18 @@ class DamonTarget:
     def __init__(self, pid):
         self.pid = pid
 
+    def sysfs_dir(self):
+        return os.path.join(
+                self.context.sysfs_dir(), 'targets', '%d' % self.idx)
+
+    def stage(self):
+        err = write_file(
+                os.path.join(self.sysfs_dir(), 'regions', 'nr_regions'), '0')
+        if err != None:
+            return err
+        return write_file(
+                os.path.join(self.sysfs_dir(), 'pid_target'), self.pid)
+
 class DamonAttrs:
     sample_us = None
     aggr_us = None
@@ -55,6 +152,40 @@ class DamonAttrs:
         self.min_nr_regions = min_nr_regions
         self.max_nr_regions = max_nr_regions
 
+    def interval_sysfs_dir(self):
+        return os.path.join(self.context.sysfs_dir(), 'monitoring_attrs',
+                'intervals')
+
+    def nr_regions_range_sysfs_dir(self):
+        return os.path.join(self.context.sysfs_dir(), 'monitoring_attrs',
+                'nr_regions')
+
+    def stage(self):
+        err = write_file(os.path.join(self.interval_sysfs_dir(), 'sample_us'),
+                self.sample_us)
+        if err != None:
+            return err
+        err = write_file(os.path.join(self.interval_sysfs_dir(), 'aggr_us'),
+                self.aggr_us)
+        if err != None:
+            return err
+        err = write_file(os.path.join(self.interval_sysfs_dir(), 'update_us'),
+                self.update_us)
+        if err != None:
+            return err
+
+        err = write_file(
+                os.path.join(self.nr_regions_range_sysfs_dir(), 'min'),
+                self.min_nr_regions)
+        if err != None:
+            return err
+
+        err = write_file(
+                os.path.join(self.nr_regions_range_sysfs_dir(), 'max'),
+                self.max_nr_regions)
+        if err != None:
+            return err
+
 class DamonCtx:
     ops = None
     monitoring_attrs = None
@@ -79,6 +210,46 @@ class DamonCtx:
             scheme.idx = idx
             scheme.context = self
 
+    def sysfs_dir(self):
+        return os.path.join(self.kdamond.sysfs_dir(), 'contexts',
+                '%d' % self.idx)
+
+    def stage(self):
+        err = write_file(
+                os.path.join(self.sysfs_dir(), 'operations'), self.ops)
+        if err != None:
+            return err
+        err = self.monitoring_attrs.stage()
+        if err != None:
+            return err
+
+        nr_targets_file = os.path.join(
+                self.sysfs_dir(), 'targets', 'nr_targets')
+        content, err = read_file(nr_targets_file)
+        if err != None:
+            return err
+        if int(content) != len(self.targets):
+            err = write_file(nr_targets_file, '%d' % len(self.targets))
+            if err != None:
+                return err
+        for target in self.targets:
+            err = target.stage()
+            if err != None:
+                return err
+
+        nr_schemes_file = os.path.join(
+                self.sysfs_dir(), 'schemes', 'nr_schemes')
+        content, err = read_file(nr_schemes_file)
+        if int(content) != len(self.schemes):
+            err = write_file(nr_schemes_file, '%d' % len(self.schemes))
+            if err != None:
+                return err
+        for scheme in self.schemes:
+            err = scheme.stage()
+            if err != None:
+                return err
+        return None
+
 class Kdamond:
     state = None
     pid = None
@@ -92,6 +263,27 @@ class Kdamond:
             context.idx = idx
             context.kdamond = self
 
+    def sysfs_dir(self):
+        return os.path.join(self.kdamonds.sysfs_dir(), '%d' % self.idx)
+
+    def start(self):
+        nr_contexts_file = os.path.join(self.sysfs_dir(),
+                'contexts', 'nr_contexts')
+        content, err = read_file(nr_contexts_file)
+        if err != None:
+            return err
+        if int(content) != len(self.contexts):
+            err = write_file(nr_contexts_file, '%d' % len(self.contexts))
+            if err != None:
+                return err
+
+        for context in self.contexts:
+            err = context.stage()
+            if err != None:
+                return err
+        err = write_file(os.path.join(self.sysfs_dir(), 'state'), 'on')
+        return err
+
 class Kdamonds:
     kdamonds = []
 
@@ -100,3 +292,17 @@ class Kdamonds:
         for idx, kdamond in enumerate(self.kdamonds):
             kdamond.idx = idx
             kdamond.kdamonds = self
+
+    def sysfs_dir(self):
+        return os.path.join(sysfs_root, 'kdamonds')
+
+    def start(self):
+        err = write_file(os.path.join(self.sysfs_dir(),  'nr_kdamonds'),
+                '%s' % len(self.kdamonds))
+        if err != None:
+            return err
+        for kdamond in self.kdamonds:
+            err = kdamond.start()
+            if err != None:
+                return err
+        return None
_

Patches currently in -mm which might be from sj@kernel.org are


