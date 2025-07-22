Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3996B2E36FD
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 03:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753153889; cv=none; b=efK4Fu4jUwNdIAoW3N+bHuyHgeW/du1+zMO5WwvYtvZu85SMz2kQzSqHzQeuVdjuIfgOsjjcnkhM2wTf43M+a36JupDU63X6HtwbqGaa497htqJHY6hNQfODMIgw5tEbk5ZkBeDr5hh3SQWycI3/IstpDus/gylBVt+MiYjJSGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753153889; c=relaxed/simple;
	bh=wLZQBElbBICBDtV93/2TqfRov6CYg+ha7z1/5AIteuc=;
	h=Date:To:From:Subject:Message-Id; b=mXxXTHFVrpWap5mCKYov9mvIHzNzZHQYG9emuVtrduKqxQFVipMsNHnYrdWCYncQ/zlY7Oz0cRnc2b4aA2JusXhRnMr9y2ZVL5iBgXwlRK69UkDB5ehnH+UFrov2Fi3whUIRMigYfric4YGwpWzLIpIzu0vrHJhjasWvu56Jp0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NnZ/G4cf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NnZ/G4cf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6DEFC4CEED;
	Tue, 22 Jul 2025 03:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753153889;
	bh=wLZQBElbBICBDtV93/2TqfRov6CYg+ha7z1/5AIteuc=;
	h=Date:To:From:Subject:From;
	b=NnZ/G4cfk1TsGpqoJ+8y+XcAbCQ+6m9lIWAwVjhi/7sBDsL4jGnjGwGb5JR4BMGzt
	 8Blppja6cpEJ/t3KKbi6XMy6/T/sH/fw9zM1yZt6zAxkAZA6CqkBkgSsIn0QEHgxcL
	 t8Uu37RseeaU0oCNaST+XsuihVkRWTv/oh5KvUeg=
Date: Mon, 21 Jul 2025 20:11:28 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-_damon_sysfs-support-damos-quota-weights-setup.patch added to mm-new branch
Message-Id: <20250722031128.E6DEFC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/_damon_sysfs: support DAMOS quota weights setup
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-_damon_sysfs-support-damos-quota-weights-setup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-_damon_sysfs-support-damos-quota-weights-setup.patch

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
Subject: selftests/damon/_damon_sysfs: support DAMOS quota weights setup
Date: Sun, 20 Jul 2025 10:16:34 -0700

_damon_sysfs.py contains code for test-purpose DAMON sysfs interface
control.  Add support of DAMOS quotas prioritization weights setup for
more tests.

Link: https://lkml.kernel.org/r/20250720171652.92309-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |   24 +++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-_damon_sysfs-support-damos-quota-weights-setup
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -125,12 +125,20 @@ class DamosQuota:
     ms = None                   # time quota
     goals = None                # quota goals
     reset_interval_ms = None    # quota reset interval
+    weight_sz_permil = None
+    weight_nr_accesses_permil = None
+    weight_age_permil = None
     scheme = None               # owner scheme
 
-    def __init__(self, sz=0, ms=0, goals=None, reset_interval_ms=0):
+    def __init__(self, sz=0, ms=0, goals=None, reset_interval_ms=0,
+                 weight_sz_permil=0, weight_nr_accesses_permil=0,
+                 weight_age_permil=0):
         self.sz = sz
         self.ms = ms
         self.reset_interval_ms = reset_interval_ms
+        self.weight_sz_permil = weight_sz_permil
+        self.weight_nr_accesses_permil = weight_nr_accesses_permil
+        self.weight_age_permil = weight_age_permil
         self.goals = goals if goals is not None else []
         for idx, goal in enumerate(self.goals):
             goal.idx = idx
@@ -151,6 +159,20 @@ class DamosQuota:
         if err is not None:
             return err
 
+        err = write_file(os.path.join(
+            self.sysfs_dir(), 'weights', 'sz_permil'), self.weight_sz_permil)
+        if err is not None:
+            return err
+        err = write_file(os.path.join(
+            self.sysfs_dir(), 'weights', 'nr_accesses_permil'),
+                         self.weight_nr_accesses_permil)
+        if err is not None:
+            return err
+        err = write_file(os.path.join(
+            self.sysfs_dir(), 'weights', 'age_permil'), self.weight_age_permil)
+        if err is not None:
+            return err
+
         nr_goals_file = os.path.join(self.sysfs_dir(), 'goals', 'nr_goals')
         content, err = read_file(nr_goals_file)
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

