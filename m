Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18ED42E36FD
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 03:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753153895; cv=none; b=aKeX+/GWrDhBbzGrPpuThAh/KISHkceZrfhF3/suIEm5VHZULy+ooOrLwGlh4ghCPLTzi4SQXvaebLFDRvbW8dffhW/oWLd8Uu8VuKZU9oeEZIYfc/gqlkk9FICdv/9cZWINkAHAfm5wUzOre7mT6rdmeR0AFySFNTSWsy67swk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753153895; c=relaxed/simple;
	bh=jxx/WxMIZMSH62NOHliIN0+H3L/S3kzzTKmEi5FIn5E=;
	h=Date:To:From:Subject:Message-Id; b=SJbqLeWx8EkAy6ioI5dW5p367erIfiZwpEzMU8k9crTixULBdHhDWCIXzPWxtvuK635mpVU+N2k+ZFdLABLvjtFqwa1YRQRvNpQKkFGXWjhAYUQTRNv7Fgh657R04AGnTXhyORP8jgeCHSoHS4cTPr6nZnh46dxE6AGkCuLuXmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fgDjdcOm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fgDjdcOm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA58C4CEED;
	Tue, 22 Jul 2025 03:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753153894;
	bh=jxx/WxMIZMSH62NOHliIN0+H3L/S3kzzTKmEi5FIn5E=;
	h=Date:To:From:Subject:From;
	b=fgDjdcOm/SphoEnWT8lzY+F11JZBw3F5SZX3+W+uUZfjRbFrMFiezLtxXgYhwsRzB
	 NjD4o8GEdtd+LhVjYGIrrZjqcTodFBsfIKc3oYfLoMi31ny/H5qo5HGwywydpZ8Ihf
	 SqfhCRYeP2rUZwb0aoAQGAFtFy9SaxDTYGthgB2A=
Date: Mon, 21 Jul 2025 20:11:33 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-_damon_sysfs-support-damos-target_nid-setup.patch added to mm-new branch
Message-Id: <20250722031134.6FA58C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/_damon_sysfs: support DAMOS target_nid setup
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-_damon_sysfs-support-damos-target_nid-setup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-_damon_sysfs-support-damos-target_nid-setup.patch

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
Subject: selftests/damon/_damon_sysfs: support DAMOS target_nid setup
Date: Sun, 20 Jul 2025 10:16:37 -0700

_damon_sysfs.py contains code for test-purpose DAMON sysfs interface
control.  Add support of DAMOS action destination target_nid setup for
more tests.

Link: https://lkml.kernel.org/r/20250720171652.92309-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-_damon_sysfs-support-damos-target_nid-setup
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -395,6 +395,7 @@ class Damos:
     ops_filters = None
     filters = None
     apply_interval_us = None
+    target_nid = None
     dests = None
     idx = None
     context = None
@@ -404,7 +405,7 @@ class Damos:
 
     def __init__(self, action='stat', access_pattern=DamosAccessPattern(),
                  quota=DamosQuota(), watermarks=DamosWatermarks(),
-                 core_filters=[], ops_filters=[], filters=[],
+                 core_filters=[], ops_filters=[], filters=[], target_nid=0,
                  dests=DamosDests(), apply_interval_us=0):
         self.action = action
         self.access_pattern = access_pattern
@@ -423,6 +424,7 @@ class Damos:
         self.filters = DamosFilters(name='filters', filters=filters)
         self.filters.scheme = self
 
+        self.target_nid = target_nid
         self.dests = dests
         self.dests.scheme = self
 
@@ -462,6 +464,11 @@ class Damos:
         if err is not None:
             return err
 
+        err = write_file(os.path.join(self.sysfs_dir(), 'target_nid'), '%d' %
+                         self.target_nid)
+        if err is not None:
+            return err
+
         err = self.dests.stage()
         if err is not None:
             return err
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

