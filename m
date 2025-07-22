Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB4F2E36FD
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 03:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753153893; cv=none; b=VsEAF93O+IeaiKA485m10F3luESUd9KsR3x53d7wgbqxPKa2qKrxjbU9TY9zgZuEFE4tlWcP7zqYmqRIuE4ini5ECSZRjrFl8W30TgV9tPpgRoPat4GIH3zHd4uYAI5ACjvjnjtreeUdtZnXIrELh38Jdwuox9rUYpDyY09bYk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753153893; c=relaxed/simple;
	bh=kthYgPVgN7nqHLrOserNb8liWl+JBs8iUGloaH4++VA=;
	h=Date:To:From:Subject:Message-Id; b=dhAaj43bBmHTOfzCSDP1/SXPG7HAqi6q/bBvZS0SSauoFubqEH9ETqUKp/FKQ7I+waBurxxujQ9sCq+tnsTXpZdIhSI4Txmti1Nl7FN64lZ6kkWYv63DM3emngAR5fZchud62EsD7pXqWhlIsXYfatJTqxdIYqrLmbxVVlmrBJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZdZn/TML; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZdZn/TML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75EDC4CEED;
	Tue, 22 Jul 2025 03:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753153892;
	bh=kthYgPVgN7nqHLrOserNb8liWl+JBs8iUGloaH4++VA=;
	h=Date:To:From:Subject:From;
	b=ZdZn/TMLGqTcn5O8P054mACwwfACRPa0LNMmeW3CCc1yIoxI4btCpPRKsBegzJDSi
	 73fqPW+XnRyvGWJpCJFN8vbYr7dBN8hRAzkd6IP0C/hR24MQfm2hR0lk6CRhqQgb2a
	 00+B8NLymSYhigza0RJt54zgAEcCmxu06Qxb4r1w=
Date: Mon, 21 Jul 2025 20:11:32 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-_damon_sysfs-support-damos-action-dests-setup.patch added to mm-new branch
Message-Id: <20250722031132.A75EDC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/_damon_sysfs: support DAMOS action dests setup
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-_damon_sysfs-support-damos-action-dests-setup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-_damon_sysfs-support-damos-action-dests-setup.patch

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

