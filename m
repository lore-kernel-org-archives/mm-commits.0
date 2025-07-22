Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564642E36FD
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 03:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753153887; cv=none; b=TuRAA5iBkgcnyKN+wZA9+fSo9QkeY9BDNF/SzKLio86b7hKuy1JsZhxlgCaPMk8pvq9UeqQxWz7CBedSg/xjJQyKpYbgqw6KRg35GjU0b+rpmRdudvn7wYmC5cm1nadY8gIgS0Kp36+T12DhZHIS06d97l+qNs0QQn/pwdD6XDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753153887; c=relaxed/simple;
	bh=MCNivxIRM1z39HTzx3sc49gQTsFgnwDtoY0yIZsE/Ow=;
	h=Date:To:From:Subject:Message-Id; b=n29N3GJCp09MFFKWMZmlFlCoitHUI7aC1N7MOaPyEhYqaAMhABTcf/pMC8WGMIiU7aEIu31uNpao2Fqp5MEMwWM+n7dVqUxXkd7FroDXRtcIM0R0vcnF2zFcpspfaYGS9XZ8yt8IPy2jzW+/Kf53zKLC7tiUjU1SNNpg1e1eies=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t60BJFE7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t60BJFE7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21C13C4CEED;
	Tue, 22 Jul 2025 03:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753153887;
	bh=MCNivxIRM1z39HTzx3sc49gQTsFgnwDtoY0yIZsE/Ow=;
	h=Date:To:From:Subject:From;
	b=t60BJFE7a4P+Cn0p9qs1HRuusrNINFejXJkcn8ES3i2UwGUIWGBS3wIjnxUPM76hG
	 bYcFuPozqF+9A9pqWrjIe5qNv35YCS/IemcLF7j4x6mVOiXnLVOjwtPXvzg38yiyg7
	 Td+uqF3SQ85EQL5WyJ6t6s2QWC1SWjU93VyhA+fM=
Date: Mon, 21 Jul 2025 20:11:26 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-_damon_sysfs-support-monitoring-intervals-goal-setup.patch added to mm-new branch
Message-Id: <20250722031127.21C13C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/_damon_sysfs: support monitoring intervals goal setup
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-_damon_sysfs-support-monitoring-intervals-goal-setup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-_damon_sysfs-support-monitoring-intervals-goal-setup.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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

mm-damon-core-commit-damos_quota_goal-nid.patch
mm-damon-sysfs-implement-refresh_ms-file-under-kdamond-directory.patch
mm-damon-sysfs-implement-refresh_ms-file-internal-work.patch
docs-admin-guide-mm-damon-usage-document-refresh_ms-file.patch
docs-abi-damon-update-for-refresh_ms.patch
mm-damon-ops-common-ignore-migration-request-to-invalid-nodes.patch
selftests-damon-_damon_sysfs-support-damos-watermarks-setup.patch
selftests-damon-_damon_sysfs-support-damos-filters-setup.patch
selftests-damon-_damon_sysfs-support-monitoring-intervals-goal-setup.patch
selftests-damon-_damon_sysfs-support-damos-quota-weights-setup.patch
selftests-damon-_damon_sysfs-support-damos-quota-goal-nid-setup.patch
selftests-damon-_damon_sysfs-support-damos-action-dests-setup.patch
selftests-damon-_damon_sysfs-support-damos-target_nid-setup.patch
selftests-damon-_damon_sysfs-use-232-1-as-max-nr_accesses-and-age.patch
selftests-damon-drgn_dump_damon_status-dump-damos-migrate_dests.patch
selftests-damon-drgn_dump_damon_status-dump-ctx-opsid.patch
selftests-damon-drgn_dump_damon_status-dump-damos-filters.patch
selftests-damon-sysfspy-generalize-damos-watermarks-commit-assertion.patch
selftests-damon-sysfspy-generalize-damosquota-commit-assertion.patch
selftests-damon-sysfspy-test-quota-goal-commitment.patch
selftests-damon-sysfspy-test-damos-destinations-commitment.patch
selftests-damon-sysfspy-generalize-damos-access-pattern-commit-assertion.patch
selftests-damon-sysfspy-test-damos-filters-commitment.patch
selftests-damon-sysfspy-generalize-damos-schemes-commit-assertion.patch
selftests-damon-sysfspy-generalize-monitoring-attributes-commit-assertion.patch
selftests-damon-sysfspy-generalize-damon-context-commit-assertion.patch
selftests-damon-sysfspy-test-non-default-parameters-runtime-commit.patch
selftests-damon-sysfspy-test-runtime-reduction-of-damon-parameters.patch

