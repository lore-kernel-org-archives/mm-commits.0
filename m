Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B502E36FD
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 03:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753153891; cv=none; b=QSrfPw6MimPS3OEk6aTE/+4YstBu7R4KbxMhhClW6D59aJRKWxIDnH6cEIpRlplpHh+5JW71eiFzbIZ/ESPvqoms+12unqkt+YfGjaOOUOCWnd4sf9R2eddni6dcLuzKg3vygUfyeMDhgLYbzEF5Mg/Zrhs5RSWpl7OWUxqrOBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753153891; c=relaxed/simple;
	bh=p936CwdsF0Uz35of9Q+QWyg9Qwor4+0JgRb2RyqDqnA=;
	h=Date:To:From:Subject:Message-Id; b=WW3TUcSd6wuq4h8ZRqp+yjBfNCU8So4J5ak8/Mvw2jNyGMqTQ+6vLq2B31xJdOG4hW5GmjCieaeyzjrCkvCXUvyKABMywwiXnIEbNx+Poa5i/JbUSxRCX/6mfMlBC9B8Sa6lQzyL4p+yTIt8k4sO2H5xa2AC030xH57Q+wcvZkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NjNvLC5Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NjNvLC5Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9057C4CEED;
	Tue, 22 Jul 2025 03:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753153890;
	bh=p936CwdsF0Uz35of9Q+QWyg9Qwor4+0JgRb2RyqDqnA=;
	h=Date:To:From:Subject:From;
	b=NjNvLC5Q5wwmFa5aQVGhp8p26ayiDLh902gv6IzHdm9QGGCQxCTVuWVMILDUNZwfT
	 RQvRhR2kJ46wrOmPwXiZ0A2xl+pHHiL20VTTU5AKioNCEi+oiBGGuMLh3XqGHPK5gR
	 FgC4GKJGHKxCx57yVxaTToywiaiE3gwPXGFKovNM=
Date: Mon, 21 Jul 2025 20:11:30 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-_damon_sysfs-support-damos-quota-goal-nid-setup.patch added to mm-new branch
Message-Id: <20250722031130.D9057C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/_damon_sysfs: support DAMOS quota goal nid setup
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-_damon_sysfs-support-damos-quota-goal-nid-setup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-_damon_sysfs-support-damos-quota-goal-nid-setup.patch

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
Subject: selftests/damon/_damon_sysfs: support DAMOS quota goal nid setup
Date: Sun, 20 Jul 2025 10:16:35 -0700

_damon_sysfs.py contains code for test-purpose DAMON sysfs interface
control.  Add support of DAMOS quota goal nid setup for more tests.

Link: https://lkml.kernel.org/r/20250720171652.92309-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-_damon_sysfs-support-damos-quota-goal-nid-setup
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -93,14 +93,16 @@ class DamosQuotaGoal:
     metric = None
     target_value = None
     current_value = None
+    nid = None
     effective_bytes = None
     quota = None            # owner quota
     idx = None
 
-    def __init__(self, metric, target_value=10000, current_value=0):
+    def __init__(self, metric, target_value=10000, current_value=0, nid=0):
         self.metric = metric
         self.target_value = target_value
         self.current_value = current_value
+        self.nid = nid
 
     def sysfs_dir(self):
         return os.path.join(self.quota.sysfs_dir(), 'goals', '%d' % self.idx)
@@ -118,6 +120,10 @@ class DamosQuotaGoal:
                          self.current_value)
         if err is not None:
             return err
+        err = write_file(os.path.join(self.sysfs_dir(), 'nid'), self.nid)
+        if err is not None:
+            return err
+
         return None
 
 class DamosQuota:
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

