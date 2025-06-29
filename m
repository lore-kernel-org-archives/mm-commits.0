Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C8B522A
	for <mm-commits@vger.kernel.org>; Sun, 29 Jun 2025 22:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751237284; cv=none; b=rpMWu60s9+/YyrPO3YJBnGlg83EyMcaWqLwcsFnYKfr5LLnS/GVXx5dEGfl99k8y3LSuTygO5YiyGJU14lE+BlRUX53bHvXCI8JA39yG5BJKYZJVv68YyeS+61RABjbzkZHWWULR6zcwM7A2EL+0dFuI0r2TcyMK+an+VenDTHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751237284; c=relaxed/simple;
	bh=/2A7apjt6FyWVVhHx6WxLSVObhJYNoAIBX53wpWHQUs=;
	h=Date:To:From:Subject:Message-Id; b=LEEXjSajs095lHqjRRy6F6S7mGwSICjkKFa0sYnJdL4oOkgjaPMG8l0uTbIZe5sPpQDTNSCbGlbtachTa+JSNfoitKsnNsOGEhqYpWk4iFBgPeo/lrMcwyRUmd4bcoF4D8/HzE+0A/5x87Y4oMgF45LpgQ1fjZp+TSe41VqqFTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qkajQQqa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qkajQQqa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C71C4CEEB;
	Sun, 29 Jun 2025 22:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751237284;
	bh=/2A7apjt6FyWVVhHx6WxLSVObhJYNoAIBX53wpWHQUs=;
	h=Date:To:From:Subject:From;
	b=qkajQQqaVn2GKK7U/Z7mNh9/ZRojngyGuNcRLSkmgvxt8bTVHU7NRvgnXosVSmIH1
	 jOqqZPsBwFIcVs3btntokl5NdUr2rZzSVUMDb+5KqiTqxyaFsVg9vfawoer/BYu/w6
	 pGt/osixrqV4KOlL28mY4e3bS4HqRdrLmEB5Q8lg=
Date: Sun, 29 Jun 2025 15:48:03 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-sysfspy-test-adaptive-targets-parameter.patch added to mm-new branch
Message-Id: <20250629224804.22C71C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/sysfs.py: test adaptive targets parameter
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-sysfspy-test-adaptive-targets-parameter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-sysfspy-test-adaptive-targets-parameter.patch

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
Subject: selftests/damon/sysfs.py: test adaptive targets parameter
Date: Sat, 28 Jun 2025 09:04:27 -0700

Add DAMON sysfs interface functionality tests for setup of basic adaptive
targets parameters.

Link: https://lkml.kernel.org/r/20250628160428.53115-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.py |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/damon/sysfs.py~selftests-damon-sysfspy-test-adaptive-targets-parameter
+++ a/tools/testing/selftests/damon/sysfs.py
@@ -27,7 +27,9 @@ def fail(expectation, status):
 
 def main():
     kdamonds = _damon_sysfs.Kdamonds(
-            [_damon_sysfs.Kdamond(contexts=[_damon_sysfs.DamonCtx()])])
+            [_damon_sysfs.Kdamond(
+                contexts=[_damon_sysfs.DamonCtx(
+                    targets=[_damon_sysfs.DamonTarget(pid=-1)])])])
     err = kdamonds.start()
     if err is not None:
         print('kdamond start failed: %s' % err)
@@ -60,8 +62,9 @@ def main():
     if attrs['max_nr_regions'] != 1000:
         fail('max_nr_regions')
 
-    if ctx['adaptive_targets'] != []:
-        fail('adaptive_targets')
+    if ctx['adaptive_targets'] != [
+            { 'pid': 0, 'nr_regions': 0, 'regions_list': []}]:
+        fail('adaptive targets', status)
 
     if ctx['schemes'] != []:
         fail('schemes')
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-handle-damon_call_control-as-normal-under-kdmond-deactivation.patch
mm-damon-introduce-damon_stat-module.patch
mm-damon-introduce-damon_stat-module-fix.patch
mm-damon-stat-calculate-and-expose-estimated-memory-bandwidth.patch
mm-damon-stat-calculate-and-expose-idle-time-percentiles.patch
docs-admin-guide-mm-damon-add-damon_stat-usage-document.patch
mm-damon-paddr-use-alloc_migartion_target-with-no-migration-fallback-nodemask.patch
revert-mm-rename-alloc_demote_folio-to-alloc_migrate_folio.patch
revert-mm-make-alloc_demote_folio-externally-invokable-for-migration.patch
selftets-damon-add-a-test-for-memcg_path-leak.patch
mm-damon-sysfs-schemes-decouple-from-damos_quota_goal_metric.patch
mm-damon-sysfs-schemes-decouple-from-damos_action.patch
mm-damon-sysfs-schemes-decouple-from-damos_wmark_metric.patch
mm-damon-sysfs-schemes-decouple-from-damos_filter_type.patch
mm-damon-sysfs-decouple-from-damon_ops_id.patch
selftests-damon-add-drgn-script-for-extracting-damon-status.patch
selftests-damon-_damon_sysfs-set-kdamondpid-in-start.patch
selftests-damon-add-python-and-drgn-based-damon-sysfs-test.patch
selftests-damon-sysfspy-test-monitoring-attribute-parameters.patch
selftests-damon-sysfspy-test-adaptive-targets-parameter.patch
selftests-damon-sysfspy-test-damos-schemes-parameters-setup.patch

