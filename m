Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E2A1D557
	for <mm-commits@vger.kernel.org>; Wed,  7 Feb 2024 22:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707346511; cv=none; b=dDHnVMCLP9ZnKolsz4j/ELi6vJ5hQibVrOclF2ADtCTvSDpq2GyBeu8f/nFV0nS2ihk2Os1hi5tsa9Q1v9hVeJ597GOUEi/IOIcBt9j86MLAwmeqG77QDzFRYXOzfwUHVvr91TYDjS1iOLnLTSTOveXBPBAz8sucFeLWltIHn6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707346511; c=relaxed/simple;
	bh=WsT5txRlejTDgAOM2xskuAJhr+BiRolq0OM4ROk5fZA=;
	h=Date:To:From:Subject:Message-Id; b=nwnYUzFaanp7pcsbxHVfG1BF5LP4o8pXUjF7gXgF+WvFGi+Y1NKuZeYM79bd9VGCFnM07TIzVWgJ3HXe8cuOd0NaPEEWIIv3Lw9nE2ntRaj9CrLl+yyVdOAr53i6c673UsI8PJ5l2uiQauO82FHuFfQArYl3SnFiPDVnjHL8FqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YOLoaOxP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YOLoaOxP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 688DEC433C7;
	Wed,  7 Feb 2024 22:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707346510;
	bh=WsT5txRlejTDgAOM2xskuAJhr+BiRolq0OM4ROk5fZA=;
	h=Date:To:From:Subject:From;
	b=YOLoaOxPKmtIpSJWcTEYRtOXQ9Nef4yRZtwpYot8ODFD9z7FVCoeeDiebBclnpC1J
	 LTY6vki3u4NHI8GcFYN2s0sJdbzJ1xikYm2ZxsiIyMRq4gWsqO7desFB9/XWp/rUq5
	 qxK4TtRPCON9nfeZlXcSbIXD/pC/RfI00prfDwPA=
Date: Wed, 07 Feb 2024 14:55:09 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-_damon_sysfs-support-damos-apply-interval.patch added to mm-unstable branch
Message-Id: <20240207225510.688DEC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/_damon_sysfs: support DAMOS apply interval
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-_damon_sysfs-support-damos-apply-interval.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-_damon_sysfs-support-damos-apply-interval.patch

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
Subject: selftests/damon/_damon_sysfs: support DAMOS apply interval
Date: Wed, 7 Feb 2024 12:31:29 -0800

Update the test-purpose DAMON sysfs control Python module to support DAMOS
apply interval.

Link: https://lkml.kernel.org/r/20240207203134.69976-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-_damon_sysfs-support-damos-apply-interval
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -114,6 +114,7 @@ class Damos:
     action = None
     access_pattern = None
     quota = None
+    apply_interval_us = None
     # todo: Support watermarks, stats, tried_regions
     idx = None
     context = None
@@ -121,12 +122,13 @@ class Damos:
     stats = None
 
     def __init__(self, action='stat', access_pattern=DamosAccessPattern(),
-                 quota=DamosQuota()):
+                 quota=DamosQuota(), apply_interval_us=0):
         self.action = action
         self.access_pattern = access_pattern
         self.access_pattern.scheme = self
         self.quota = quota
         self.quota.scheme = self
+        self.apply_interval_us = apply_interval_us
 
     def sysfs_dir(self):
         return os.path.join(
@@ -139,6 +141,11 @@ class Damos:
         err = self.access_pattern.stage()
         if err != None:
             return err
+        err = write_file(os.path.join(self.sysfs_dir(), 'apply_interval_us'),
+                         '%d' % self.apply_interval_us)
+        if err != None:
+            return err
+
         err = self.quota.stage()
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

