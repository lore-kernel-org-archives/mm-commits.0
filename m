Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2051B75818
	for <mm-commits@vger.kernel.org>; Sun,  5 May 2024 21:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714942882; cv=none; b=lKfqMqZyCKH6AfxtSgT5lqJoAg+L+2qLFioc6acV+zr+DBsdSFs3CFFD+YO+ogeZW31rXZAv5XuB1mQmSvMJLj9MfwuRmF9XnsJk1mybV3QyahGW1MpL6tJMekJ9KgwisZArXQdaGvicXvhNjCsuVKNCCrHKxkEY7u3W8Hmn9Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714942882; c=relaxed/simple;
	bh=7tOUiTUge7xQFzgZAvC8cKebn82niXNoO30gisliFpo=;
	h=Date:To:From:Subject:Message-Id; b=IVwXlLKsIz/LB3ek8+2GFu4oFjIjvabnx35UatGtEkPOMRXH5gGsbYddFMHzbN0QqfJWwxLWRssTONta1EetzlSIGMi2eLIbpocVk708fGk8bSfTn8nxDsyPPYmJWwBmgdl56o/iFaZcpSS8CqBThIpJyCtGLRukbWTovYNQ7CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SKYxW72b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SKYxW72b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8FCFC113CC;
	Sun,  5 May 2024 21:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714942881;
	bh=7tOUiTUge7xQFzgZAvC8cKebn82niXNoO30gisliFpo=;
	h=Date:To:From:Subject:From;
	b=SKYxW72bAQLiHWMYvRIjuUovl62jw/etc7bkzOftB1xYnKE5v6POJ5jCcWFDTZWo9
	 bk8v8VvqBL+tTTtfB2Ktp/AZ+AwkTjSUPOSaKfdZxlkApqiwkE2OA8FzIwffCdvSo9
	 vWUGkXTlbGxWIdSLpJSxWydCmKWEARQwcCpKwmTo=
Date: Sun, 05 May 2024 14:01:21 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-_damon_sysfs-use-is-instead-of-==-for-none.patch added to mm-unstable branch
Message-Id: <20240505210121.D8FCFC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/_damon_sysfs: use 'is' instead of '==' for 'None'
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-_damon_sysfs-use-is-instead-of-==-for-none.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-_damon_sysfs-use-is-instead-of-==-for-none.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: selftests/damon/_damon_sysfs: use 'is' instead of '==' for 'None'
Date: Fri, 3 May 2024 11:03:12 -0700

_damon_sysfs.py is using '==' or '!=' for 'None'.  Since 'None' is a
singleton, using 'is' or 'is not' is more efficient.  Use the more
efficient one.

Link: https://lkml.kernel.org/r/20240503180318.72798-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |   80 ++++++++--------
 1 file changed, 40 insertions(+), 40 deletions(-)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-_damon_sysfs-use-is-instead-of-==-for-none
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -45,11 +45,11 @@ class DamosAccessPattern:
         self.nr_accesses = nr_accesses
         self.age = age
 
-        if self.size == None:
+        if self.size is None:
             self.size = [0, 2**64 - 1]
-        if self.nr_accesses == None:
+        if self.nr_accesses is None:
             self.nr_accesses = [0, 2**64 - 1]
-        if self.age == None:
+        if self.age is None:
             self.age = [0, 2**64 - 1]
 
     def sysfs_dir(self):
@@ -58,27 +58,27 @@ class DamosAccessPattern:
     def stage(self):
         err = write_file(
                 os.path.join(self.sysfs_dir(), 'sz', 'min'), self.size[0])
-        if err != None:
+        if err is not None:
             return err
         err = write_file(
                 os.path.join(self.sysfs_dir(), 'sz', 'max'), self.size[1])
-        if err != None:
+        if err is not None:
             return err
         err = write_file(os.path.join(self.sysfs_dir(), 'nr_accesses', 'min'),
                 self.nr_accesses[0])
-        if err != None:
+        if err is not None:
             return err
         err = write_file(os.path.join(self.sysfs_dir(), 'nr_accesses', 'max'),
                 self.nr_accesses[1])
-        if err != None:
+        if err is not None:
             return err
         err = write_file(
                 os.path.join(self.sysfs_dir(), 'age', 'min'), self.age[0])
-        if err != None:
+        if err is not None:
             return err
         err = write_file(
                 os.path.join(self.sysfs_dir(), 'age', 'max'), self.age[1])
-        if err != None:
+        if err is not None:
             return err
 
 qgoal_metric_user_input = 'user_input'
@@ -137,14 +137,14 @@ class DamosQuota:
 
     def stage(self):
         err = write_file(os.path.join(self.sysfs_dir(), 'bytes'), self.sz)
-        if err != None:
+        if err is not None:
             return err
         err = write_file(os.path.join(self.sysfs_dir(), 'ms'), self.ms)
-        if err != None:
+        if err is not None:
             return err
         err = write_file(os.path.join(self.sysfs_dir(), 'reset_interval_ms'),
                          self.reset_interval_ms)
-        if err != None:
+        if err is not None:
             return err
 
         nr_goals_file = os.path.join(self.sysfs_dir(), 'goals', 'nr_goals')
@@ -201,30 +201,30 @@ class Damos:
 
     def stage(self):
         err = write_file(os.path.join(self.sysfs_dir(), 'action'), self.action)
-        if err != None:
+        if err is not None:
             return err
         err = self.access_pattern.stage()
-        if err != None:
+        if err is not None:
             return err
         err = write_file(os.path.join(self.sysfs_dir(), 'apply_interval_us'),
                          '%d' % self.apply_interval_us)
-        if err != None:
+        if err is not None:
             return err
 
         err = self.quota.stage()
-        if err != None:
+        if err is not None:
             return err
 
         # disable watermarks
         err = write_file(
                 os.path.join(self.sysfs_dir(), 'watermarks', 'metric'), 'none')
-        if err != None:
+        if err is not None:
             return err
 
         # disable filters
         err = write_file(
                 os.path.join(self.sysfs_dir(), 'filters', 'nr_filters'), '0')
-        if err != None:
+        if err is not None:
             return err
 
 class DamonTarget:
@@ -243,7 +243,7 @@ class DamonTarget:
     def stage(self):
         err = write_file(
                 os.path.join(self.sysfs_dir(), 'regions', 'nr_regions'), '0')
-        if err != None:
+        if err is not None:
             return err
         return write_file(
                 os.path.join(self.sysfs_dir(), 'pid_target'), self.pid)
@@ -275,27 +275,27 @@ class DamonAttrs:
     def stage(self):
         err = write_file(os.path.join(self.interval_sysfs_dir(), 'sample_us'),
                 self.sample_us)
-        if err != None:
+        if err is not None:
             return err
         err = write_file(os.path.join(self.interval_sysfs_dir(), 'aggr_us'),
                 self.aggr_us)
-        if err != None:
+        if err is not None:
             return err
         err = write_file(os.path.join(self.interval_sysfs_dir(), 'update_us'),
                 self.update_us)
-        if err != None:
+        if err is not None:
             return err
 
         err = write_file(
                 os.path.join(self.nr_regions_range_sysfs_dir(), 'min'),
                 self.min_nr_regions)
-        if err != None:
+        if err is not None:
             return err
 
         err = write_file(
                 os.path.join(self.nr_regions_range_sysfs_dir(), 'max'),
                 self.max_nr_regions)
-        if err != None:
+        if err is not None:
             return err
 
 class DamonCtx:
@@ -329,24 +329,24 @@ class DamonCtx:
     def stage(self):
         err = write_file(
                 os.path.join(self.sysfs_dir(), 'operations'), self.ops)
-        if err != None:
+        if err is not None:
             return err
         err = self.monitoring_attrs.stage()
-        if err != None:
+        if err is not None:
             return err
 
         nr_targets_file = os.path.join(
                 self.sysfs_dir(), 'targets', 'nr_targets')
         content, err = read_file(nr_targets_file)
-        if err != None:
+        if err is not None:
             return err
         if int(content) != len(self.targets):
             err = write_file(nr_targets_file, '%d' % len(self.targets))
-            if err != None:
+            if err is not None:
                 return err
         for target in self.targets:
             err = target.stage()
-            if err != None:
+            if err is not None:
                 return err
 
         nr_schemes_file = os.path.join(
@@ -356,11 +356,11 @@ class DamonCtx:
             return err
         if int(content) != len(self.schemes):
             err = write_file(nr_schemes_file, '%d' % len(self.schemes))
-            if err != None:
+            if err is not None:
                 return err
         for scheme in self.schemes:
             err = scheme.stage()
-            if err != None:
+            if err is not None:
                 return err
         return None
 
@@ -384,16 +384,16 @@ class Kdamond:
         nr_contexts_file = os.path.join(self.sysfs_dir(),
                 'contexts', 'nr_contexts')
         content, err = read_file(nr_contexts_file)
-        if err != None:
+        if err is not None:
             return err
         if int(content) != len(self.contexts):
             err = write_file(nr_contexts_file, '%d' % len(self.contexts))
-            if err != None:
+            if err is not None:
                 return err
 
         for context in self.contexts:
             err = context.stage()
-            if err != None:
+            if err is not None:
                 return err
         err = write_file(os.path.join(self.sysfs_dir(), 'state'), 'on')
         return err
@@ -401,20 +401,20 @@ class Kdamond:
     def update_schemes_tried_bytes(self):
         err = write_file(os.path.join(self.sysfs_dir(), 'state'),
                 'update_schemes_tried_bytes')
-        if err != None:
+        if err is not None:
             return err
         for context in self.contexts:
             for scheme in context.schemes:
                 content, err = read_file(os.path.join(scheme.sysfs_dir(),
                     'tried_regions', 'total_bytes'))
-                if err != None:
+                if err is not None:
                     return err
                 scheme.tried_bytes = int(content)
 
     def update_schemes_stats(self):
         err = write_file(os.path.join(self.sysfs_dir(), 'state'),
                 'update_schemes_stats')
-        if err != None:
+        if err is not None:
             return err
         for context in self.contexts:
             for scheme in context.schemes:
@@ -423,7 +423,7 @@ class Kdamond:
                              'sz_applied', 'qt_exceeds']:
                     content, err = read_file(
                             os.path.join(scheme.sysfs_dir(), 'stats', stat))
-                    if err != None:
+                    if err is not None:
                         return err
                     stat_values.append(int(content))
                 scheme.stats = DamosStats(*stat_values)
@@ -471,10 +471,10 @@ class Kdamonds:
     def start(self):
         err = write_file(os.path.join(self.sysfs_dir(),  'nr_kdamonds'),
                 '%s' % len(self.kdamonds))
-        if err != None:
+        if err is not None:
             return err
         for kdamond in self.kdamonds:
             err = kdamond.start()
-            if err != None:
+            if err is not None:
                 return err
         return None
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-paddr-implement-damon_folio_young.patch
mm-damon-paddr-implement-damon_folio_mkold.patch
mm-damon-add-damos-filter-type-young.patch
mm-damon-paddr-implement-damos-filter-type-young.patch
docs-mm-damon-design-document-young-page-type-damos-filter.patch
docs-admin-guide-mm-damon-usage-update-for-young-page-type-damos-filter.patch
docs-abi-damon-update-for-youg-page-type-damos-filter.patch
mm-damon-paddr-avoid-unnecessary-page-level-access-check-for-pageout-damos-action.patch
mm-damon-paddr-do-page-level-access-check-for-pageout-damos-action-on-its-own.patch
mm-vmscan-remove-ignore_references-argument-of-reclaim_pages.patch
mm-vmscan-remove-ignore_references-argument-of-reclaim_folio_list.patch
selftests-damon-_damon_sysfs-support-quota-goals.patch
selftests-damon-add-a-test-for-damos-quota-goal.patch
mm-damon-core-initialize-esz_bp-from-damos_quota_init_priv.patch
selftests-damon-_damon_sysfs-check-errors-from-nr_schemes-file-reads.patch
selftests-damon-_damon_sysfs-find-sysfs-mount-point-from-proc-mounts.patch
selftests-damon-_damon_sysfs-use-is-instead-of-==-for-none.patch
selftests-damon-classify-tests-for-functionalities-and-regressions.patch
docs-admin-guide-mm-damon-usage-fix-wrong-example-of-damos-filter-matching-sysfs-file.patch
docs-admin-guide-mm-damon-usage-fix-wrong-schemes-effective-quota-update-command.patch
docs-mm-damon-design-use-a-list-for-supported-filters.patch
docs-mm-damon-maintainer-profile-change-the-maintainers-timezone-from-pst-to-pt.patch
docs-mm-damon-maintainer-profile-allow-posting-patches-based-on-damon-next-tree.patch

