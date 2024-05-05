Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9F97580E
	for <mm-commits@vger.kernel.org>; Sun,  5 May 2024 21:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714942877; cv=none; b=WrONLk66nhRYYkTX0c6/Ac0g9uDUYtHD5W0O0KbEmdn0xPq6kWEBThKTcZWPjwqc5c37fVM4ZmpETIkzQV4WhWIsR3mnpTefv6IOEf7ZtbNqwVU1TlOPN0G9T21wU/o24AVBSGrniDz80vL7OetMrKM2LfsndnBTkzD1rI5Cdf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714942877; c=relaxed/simple;
	bh=P6ex3S5ASAkk69rPr8/ZonVVxi1xwd6xaSMIqTFHg+0=;
	h=Date:To:From:Subject:Message-Id; b=trqgPBpNjGFVYMocXIFScrQ65pfHQzmoIIZdRrI+2kxE4xjxUemPNovsZx581NxhpIW+M/i0//ZpScowsOYkQrCSoxyc8MbtHMksfkNttK/1cydNKcu97fYdZ87PEbfz6k5B7pBu0AASZ9KTE+pJot/Xj4ik3lie2nVo/R07zP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AYk1SJP7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AYk1SJP7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57852C113CC;
	Sun,  5 May 2024 21:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714942877;
	bh=P6ex3S5ASAkk69rPr8/ZonVVxi1xwd6xaSMIqTFHg+0=;
	h=Date:To:From:Subject:From;
	b=AYk1SJP7upiUbZ741Q+a6sWzxvPZxcs8Lvj2kU4/vpxDPbi3ui/YvZE58E/kb57+u
	 nXAIyNjjqwsZrSyeErmJ/A9Ot7fV8pKkb5FKE6n58Wqzh/jh7KMN3/MZRkMPyv29Hl
	 JLvLb7N/vPneC9I6WHcf21rOglZ6fIlNRjxBl/ok=
Date: Sun, 05 May 2024 14:01:16 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-_damon_sysfs-support-quota-goals.patch added to mm-unstable branch
Message-Id: <20240505210117.57852C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/_damon_sysfs: support quota goals
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-_damon_sysfs-support-quota-goals.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-_damon_sysfs-support-quota-goals.patch

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

