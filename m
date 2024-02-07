Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51BA1CFB2
	for <mm-commits@vger.kernel.org>; Wed,  7 Feb 2024 22:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707346508; cv=none; b=PuW7gaDMuMcQgMvS2PvvbMdWjSKRq4270vwnfmoPqnGsjBpvr10qjwPzyCyG/kByN371dME80hZt1NJw1y/ltQ00tKCI7pjwuk7m0aSXXAc5A/+MY64FeS22KlS7oq2V9K5K92d4eLvc/fc5DgCGu1g4xEQExx9T58WreWv1TV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707346508; c=relaxed/simple;
	bh=bOc9IJ6T0CBhRsps+lBZ1Kl8OqfByt7B3Mj2HV5bVFw=;
	h=Date:To:From:Subject:Message-Id; b=UIzgNo8yHvu1AuOP8EqpLYUy0d8sR1rXZD5Op00wqYNQe9r6kouX05iEp/Im19TlrT8eI3tJTSjnIboqFeDi4iHKB8yb6OdSkKbL6BGT69Ixau2yHVy4aiijEMlccIgIN5PTooIlKbbJiahpvrVqCmZDQsDlOh5gdQO7Ysp+rac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Sg6VVhB0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Sg6VVhB0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F9EC43390;
	Wed,  7 Feb 2024 22:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707346508;
	bh=bOc9IJ6T0CBhRsps+lBZ1Kl8OqfByt7B3Mj2HV5bVFw=;
	h=Date:To:From:Subject:From;
	b=Sg6VVhB0PiWXVq1ATkjjkwOExpnevsht+BpFEHyjzD3zRE55rbxrrv8Rg95F1W5GW
	 KAAR9m+Rm9s+LHvhOQ8SMgYF0fqFqteM29WyqVt/EG63nUt7Z4wMtGD36FUU7OEdDh
	 V1ONucbcr4XrXtUYAKjzmRoNN9TvP2UZZ3SNUzx4=
Date: Wed, 07 Feb 2024 14:55:07 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-_damon_sysfs-support-damos-quota.patch added to mm-unstable branch
Message-Id: <20240207225508.14F9EC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/_damon_sysfs: support DAMOS quota
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-_damon_sysfs-support-damos-quota.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-_damon_sysfs-support-damos-quota.patch

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
Subject: selftests/damon/_damon_sysfs: support DAMOS quota
Date: Wed, 7 Feb 2024 12:31:27 -0800

Patch series "selftests/damon: add more tests for core functionalities and
corner cases".

Continue DAMON selftests' test coverage improvement works with a trivial
improvement of the test code itself.  The sequence of the patches in
patchset is as follows.

The first five patches add two DAMON core functionalities tests.  Those
begins with three patches (patches 1-3) that update the test-purpose DAMON
sysfs interface wrapper to support DAMOS quota, stats, and apply interval
features, respectively.  The fourth patch implements and adds a selftest
for DAMOS quota feature, using the DAMON sysfs interface wrapper's newly
added support of the quota and the stats feature.  The fifth patch further
implements and adds a selftest for DAMOS apply interval using the DAMON
sysfs interface wrapper's newly added support of the apply interval and
the stats feature.

Two patches (patches 6 and 7) for implementing and adding two corner cases
handling selftests follow.  Those try to avoid two previously fixed bugs
from recurring.

Finally, a patch for making DAMON debugfs selftests dependency checker to
use /proc/mounts instead of the hard-coded mount point assumption follows.


This patch (of 8):

Update the test-purpose DAMON sysfs control Python module to support DAMOS
quota.

Link: https://lkml.kernel.org/r/20240207203134.69976-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20240207203134.69976-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |   42 ++++++++++++----
 1 file changed, 33 insertions(+), 9 deletions(-)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-_damon_sysfs-support-damos-quota
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -70,18 +70,48 @@ class DamosAccessPattern:
         if err != None:
             return err
 
+class DamosQuota:
+    sz = None                   # size quota, in bytes
+    ms = None                   # time quota
+    reset_interval_ms = None    # quota reset interval
+    scheme = None               # owner scheme
+
+    def __init__(self, sz=0, ms=0, reset_interval_ms=0):
+        self.sz = sz
+        self.ms = ms
+        self.reset_interval_ms = reset_interval_ms
+
+    def sysfs_dir(self):
+        return os.path.join(self.scheme.sysfs_dir(), 'quotas')
+
+    def stage(self):
+        err = write_file(os.path.join(self.sysfs_dir(), 'bytes'), self.sz)
+        if err != None:
+            return err
+        err = write_file(os.path.join(self.sysfs_dir(), 'ms'), self.ms)
+        if err != None:
+            return err
+        err = write_file(os.path.join(self.sysfs_dir(), 'reset_interval_ms'),
+                         self.reset_interval_ms)
+        if err != None:
+            return err
+
 class Damos:
     action = None
     access_pattern = None
-    # todo: Support quotas, watermarks, stats, tried_regions
+    quota = None
+    # todo: Support watermarks, stats, tried_regions
     idx = None
     context = None
     tried_bytes = None
 
-    def __init__(self, action='stat', access_pattern=DamosAccessPattern()):
+    def __init__(self, action='stat', access_pattern=DamosAccessPattern(),
+                 quota=DamosQuota()):
         self.action = action
         self.access_pattern = access_pattern
         self.access_pattern.scheme = self
+        self.quota = quota
+        self.quota.scheme = self
 
     def sysfs_dir(self):
         return os.path.join(
@@ -94,13 +124,7 @@ class Damos:
         err = self.access_pattern.stage()
         if err != None:
             return err
-
-        # disable quotas
-        err = write_file(os.path.join(self.sysfs_dir(), 'quotas', 'ms'), '0')
-        if err != None:
-            return err
-        err = write_file(
-                os.path.join(self.sysfs_dir(), 'quotas', 'bytes'), '0')
+        err = self.quota.stage()
         if err != None:
             return err
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-fix-wrong-damos-tried-regions-update-timeout-setup.patch
mm-damon-core-check-apply-interval-in-damon_do_apply_schemes.patch
docs-admin-guide-mm-damon-usage-use-sysfs-interface-for-tracepoints-example.patch
mm-damon-rename-config_damon_dbgfs-to-damon_dbgfs_deprecated.patch
mm-damon-dbgfs-implement-deprecation-notice-file.patch
mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro.patch
docs-admin-guide-mm-damon-usage-document-deprecated-file-of-damon-debugfs-interface.patch
selftets-damon-prepare-for-monitor_on-file-renaming.patch
mm-damon-dbgfs-rename-monitor_on-file-to-monitor_on_deprecated.patch
docs-admin-guide-mm-damon-usage-update-for-monitor_on-renaming.patch
docs-translations-damon-usage-update-for-monitor_on-renaming.patch
mm-damon-sysfs-handle-state-file-inputs-for-every-sampling-interval-if-possible.patch
selftests-damon-_damon_sysfs-support-damos-quota.patch
selftests-damon-_damon_sysfs-support-damos-stats.patch
selftests-damon-_damon_sysfs-support-damos-apply-interval.patch
selftests-damon-add-a-test-for-damos-quota.patch
selftests-damon-add-a-test-for-damos-apply-intervals.patch
selftests-damon-add-a-test-for-a-race-between-target_ids_read-and-dbgfs_before_terminate.patch
selftests-damon-add-a-test-for-the-pid-leak-of-dbgfs_target_ids_write.patch
selftests-damon-_chk_dependency-get-debugfs-mount-point-from-proc-mounts.patch

