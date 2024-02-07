Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEFDC1D557
	for <mm-commits@vger.kernel.org>; Wed,  7 Feb 2024 22:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707346510; cv=none; b=sba9X+Vvi7ZCPVw4O0AZjMSxvT4rq8U8X50vYWZcZyuHzJX21cWzCQjaFVaKIcQtEuG9yKUwrnhJOxqg/2uxfOzgn5JDJWjrcXRmIzezQqJpDGRnVA2cA5MbZdipdhO6xW1ntvflQDY5efb79m8vPY0Q/5i0+60M3VpYBiU5kPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707346510; c=relaxed/simple;
	bh=7Lp1yu279IAG4t+9w5VsJ+PnGmgrru/KC62oLAGh2JM=;
	h=Date:To:From:Subject:Message-Id; b=Vewb8R4j39Xz+LeFFsHV7S2v1gVqVUWAeDruf3H/7h4yaV2YvZ81YfkBDG5y7nieDYm0WBG85uDuKB/KCV9n06qQ07blEx/IBQ8jv/Lw4Gv3yEbYdJ1ExmLpA44H5afDNVlARrZFbWgbnqToAhIoxxfvDN8Tb0ggRMMMMTJYJBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gdhlOwV6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gdhlOwV6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D92C433F1;
	Wed,  7 Feb 2024 22:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707346509;
	bh=7Lp1yu279IAG4t+9w5VsJ+PnGmgrru/KC62oLAGh2JM=;
	h=Date:To:From:Subject:From;
	b=gdhlOwV6lik7Ljpnb/Qoxr/EStMnRwiwOJ0OUAb21n+bVZz6DY1Srf2WY4IVoYvTc
	 riH9nwov2x0nmy591GIj7AatavPRbJcTP2ZmD/GdsIjSqmhTNYyGBNUMXaclRbiQJl
	 lN+iQ8cFDAztndlakT6fMe9LkPaAqvNpPEkGcDVs=
Date: Wed, 07 Feb 2024 14:55:08 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-_damon_sysfs-support-damos-stats.patch added to mm-unstable branch
Message-Id: <20240207225509.32D92C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/_damon_sysfs: support DAMOS stats
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-_damon_sysfs-support-damos-stats.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-_damon_sysfs-support-damos-stats.patch

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
Subject: selftests/damon/_damon_sysfs: support DAMOS stats
Date: Wed, 7 Feb 2024 12:31:28 -0800

Update the test-purpose DAMON sysfs control Python module to support DAMOS
stats.

Link: https://lkml.kernel.org/r/20240207203134.69976-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |   32 ++++++++++++++++
 1 file changed, 32 insertions(+)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-_damon_sysfs-support-damos-stats
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -96,6 +96,20 @@ class DamosQuota:
         if err != None:
             return err
 
+class DamosStats:
+    nr_tried = None
+    sz_tried = None
+    nr_applied = None
+    sz_applied = None
+    qt_exceeds = None
+
+    def __init__(self, nr_tried, sz_tried, nr_applied, sz_applied, qt_exceeds):
+        self.nr_tried = nr_tried
+        self.sz_tried = sz_tried
+        self.nr_applied = nr_applied
+        self.sz_applied = sz_applied
+        self.qt_exceeds = qt_exceeds
+
 class Damos:
     action = None
     access_pattern = None
@@ -104,6 +118,7 @@ class Damos:
     idx = None
     context = None
     tried_bytes = None
+    stats = None
 
     def __init__(self, action='stat', access_pattern=DamosAccessPattern(),
                  quota=DamosQuota()):
@@ -322,6 +337,23 @@ class Kdamond:
                     return err
                 scheme.tried_bytes = int(content)
 
+    def update_schemes_stats(self):
+        err = write_file(os.path.join(self.sysfs_dir(), 'state'),
+                'update_schemes_stats')
+        if err != None:
+            return err
+        for context in self.contexts:
+            for scheme in context.schemes:
+                stat_values = []
+                for stat in ['nr_tried', 'sz_tried', 'nr_applied',
+                             'sz_applied', 'qt_exceeds']:
+                    content, err = read_file(
+                            os.path.join(scheme.sysfs_dir(), 'stats', stat))
+                    if err != None:
+                        return err
+                    stat_values.append(int(content))
+                scheme.stats = DamosStats(*stat_values)
+
 class Kdamonds:
     kdamonds = []
 
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

