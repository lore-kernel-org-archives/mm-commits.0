Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB101DE885
	for <mm-commits@vger.kernel.org>; Sat, 26 Jul 2025 22:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753567808; cv=none; b=LUiAlIvC0UYY562Oom5sdWaJynw7u/FC+PE+jmZGj/JzqCdmUKG31d28tiMzT29bjh8IOGhJvoOy3XWWSVGUXjCvDlyyGWfgaYfEE2UTc2Odmt5UzWsq5WbsdcGWviIZgVHaU8Dp+oGK3HDbgv2U7NHs9SEvoLT0Mt96l4iNFJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753567808; c=relaxed/simple;
	bh=ueMJj/OvgfdTT941ZDnuYv6XWllsql3RMrC9TQEVgmo=;
	h=Date:To:From:Subject:Message-Id; b=TaMGOpbsSxv2h+vnnMHZkYe2ZYMOcGehJtLpso+Tg/7uLk0Jj6WmjDn9YaNpu3rvBv+cYUFbwbYW2hZtjsvdQjYVyFQJ+T13DVmyMcjJVRyQIxExY/xyB7x5KITqlhGE8M211ObfwrWSvsBiNjBmR5BL/SEfc+v1qZ6hRZ11Tpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U7YkEEt4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U7YkEEt4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BE9DC4CEF4;
	Sat, 26 Jul 2025 22:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753567807;
	bh=ueMJj/OvgfdTT941ZDnuYv6XWllsql3RMrC9TQEVgmo=;
	h=Date:To:From:Subject:From;
	b=U7YkEEt4DPxMfYRWAPxI0xcGith55INhClLKGTCSbIdsOnYIubG+LDba/fawIpSOF
	 dB4GMw8fcKSMKWRtocHq85PoxmuBv87emNagVnXf45gQifR2+Lz0WNREcHLMArKAAA
	 MNbKXiJMfNlJPF3gg4glvCp51s41BT3G67ibAUuk=
Date: Sat, 26 Jul 2025 15:10:06 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-_damon_sysfs-support-damos-filters-setup.patch removed from -mm tree
Message-Id: <20250726221007.7BE9DC4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/_damon_sysfs: support DAMOS filters setup
has been removed from the -mm tree.  Its filename was
     selftests-damon-_damon_sysfs-support-damos-filters-setup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/_damon_sysfs: support DAMOS filters setup
Date: Sun, 20 Jul 2025 10:16:32 -0700

_damon_sysfs.py contains code for test-purpose DAMON sysfs interface
control.  Add support of DAMOS filters setup for more tests.

Link: https://lkml.kernel.org/r/20250720171652.92309-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |  115 +++++++++++++++-
 1 file changed, 111 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-_damon_sysfs-support-damos-filters-setup
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -201,6 +201,96 @@ class DamosWatermarks:
         if err is not None:
             return err
 
+class DamosFilter:
+    type_ = None
+    matching = None
+    allow = None
+    memcg_path = None
+    addr_start = None
+    addr_end = None
+    target_idx = None
+    min_ = None
+    max_ = None
+    idx = None
+    filters = None  # owner filters
+
+    def __init__(self, type_='anon', matching=False, allow=False,
+                 memcg_path='', addr_start=0, addr_end=0, target_idx=0, min_=0,
+                 max_=0):
+        self.type_ = type_
+        self.matching = matching
+        self.allow = allow
+        self.memcg_path = memcg_path,
+        self.addr_start = addr_start
+        self.addr_end = addr_end
+        self.target_idx = target_idx
+        self.min_ = min_
+        self.max_ = max_
+
+    def sysfs_dir(self):
+        return os.path.join(self.filters.sysfs_dir(), '%d' % self.idx)
+
+    def stage(self):
+        err = write_file(os.path.join(self.sysfs_dir(), 'type'), self.type_)
+        if err is not None:
+            return err
+        err = write_file(os.path.join(self.sysfs_dir(), 'matching'),
+                         self.matching)
+        if err is not None:
+            return err
+        err = write_file(os.path.join(self.sysfs_dir(), 'allow'), self.allow)
+        if err is not None:
+            return err
+        err = write_file(os.path.join(self.sysfs_dir(), 'memcg_path'),
+                         self.memcg_path)
+        if err is not None:
+            return err
+        err = write_file(os.path.join(self.sysfs_dir(), 'addr_start'),
+                         self.addr_start)
+        if err is not None:
+            return err
+        err = write_file(os.path.join(self.sysfs_dir(), 'addr_end'),
+                         self.addr_end)
+        if err is not None:
+            return err
+        err = write_file(os.path.join(self.sysfs_dir(), 'damon_target_idx'),
+                         self.target_idx)
+        if err is not None:
+            return err
+        err = write_file(os.path.join(self.sysfs_dir(), 'min'), self.min_)
+        if err is not None:
+            return err
+        err = write_file(os.path.join(self.sysfs_dir(), 'max'), self.max_)
+        if err is not None:
+            return err
+        return None
+
+class DamosFilters:
+    name = None
+    filters = None
+    scheme = None   # owner scheme
+
+    def __init__(self, name, filters=[]):
+        self.name = name
+        self.filters = filters
+        for idx, filter_ in enumerate(self.filters):
+            filter_.idx = idx
+            filter_.filters = self
+
+    def sysfs_dir(self):
+        return os.path.join(self.scheme.sysfs_dir(), self.name)
+
+    def stage(self):
+        err = write_file(os.path.join(self.sysfs_dir(), 'nr_filters'),
+                         len(self.filters))
+        if err is not None:
+            return err
+        for filter_ in self.filters:
+            err = filter_.stage()
+            if err is not None:
+                return err
+        return None
+
 class DamosStats:
     nr_tried = None
     sz_tried = None
@@ -227,8 +317,10 @@ class Damos:
     access_pattern = None
     quota = None
     watermarks = None
+    core_filters = None
+    ops_filters = None
+    filters = None
     apply_interval_us = None
-    # todo: Support watermarks, stats
     idx = None
     context = None
     tried_bytes = None
@@ -237,6 +329,7 @@ class Damos:
 
     def __init__(self, action='stat', access_pattern=DamosAccessPattern(),
                  quota=DamosQuota(), watermarks=DamosWatermarks(),
+                 core_filters=[], ops_filters=[], filters=[],
                  apply_interval_us=0):
         self.action = action
         self.access_pattern = access_pattern
@@ -245,6 +338,16 @@ class Damos:
         self.quota.scheme = self
         self.watermarks = watermarks
         self.watermarks.scheme = self
+
+        self.core_filters = DamosFilters(name='core_filters',
+                                         filters=core_filters)
+        self.core_filters.scheme = self
+        self.ops_filters = DamosFilters(name='ops_filters',
+                                         filters=ops_filters)
+        self.ops_filters.scheme = self
+        self.filters = DamosFilters(name='filters', filters=filters)
+        self.filters.scheme = self
+
         self.apply_interval_us = apply_interval_us
 
     def sysfs_dir(self):
@@ -271,9 +374,13 @@ class Damos:
         if err is not None:
             return err
 
-        # disable filters
-        err = write_file(
-                os.path.join(self.sysfs_dir(), 'filters', 'nr_filters'), '0')
+        err = self.core_filters.stage()
+        if err is not None:
+            return err
+        err = self.ops_filters.stage()
+        if err is not None:
+            return err
+        err = self.filters.stage()
         if err is not None:
             return err
 
_

Patches currently in -mm which might be from sj@kernel.org are


