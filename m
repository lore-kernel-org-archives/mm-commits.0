Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62394522A
	for <mm-commits@vger.kernel.org>; Sun, 29 Jun 2025 22:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751237286; cv=none; b=QET6/pgI1YapY1oDknBtIKK1YPg1gG9/XjGWHZ2QNqhqdVTqWvL3QyEwARu6OTpegB7OOvHI+vePs02he6KOYPuoRxIN/1Q2Sb+aygn3XF3TBQS4li1rNAtjOsB8q6QWH3qH4XvLls15ZAI8hpnkGaEYtdKWSi7v2af9UKYGsEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751237286; c=relaxed/simple;
	bh=7dWhqlAbVBCGiBIhZDxtGTxOCQAXA3cs7ATmaBfxnU0=;
	h=Date:To:From:Subject:Message-Id; b=FY6Fo2AMz5q8iYjfGb0HRSelqS8coNIuIXwFSr0b8RZ09WUYszBfaQYSF9jp5fLHQ2T3xdwrxgs7D6t5TGPQSHEhYRxqSusv0TJhoR9GZGnEeZ47pM+t322bWGLRnJh3HvqNA0fcvHTG2IxJfgQsfS0++ICne8RfcE7LGC3VVhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PkRNfFV8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PkRNfFV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD6DC4CEEB;
	Sun, 29 Jun 2025 22:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751237285;
	bh=7dWhqlAbVBCGiBIhZDxtGTxOCQAXA3cs7ATmaBfxnU0=;
	h=Date:To:From:Subject:From;
	b=PkRNfFV8Ftteh9C7+ydkOPILvGYXF+KmoXUivfmPWx1PYcqTaidZrxhpT/fGDKU+1
	 P5wfgyiu3c16YScVcGml8lsXqwlj/hEq8FfdwvfSUZi9V1YuAQeyJ7erhrNJ0cmDoB
	 aAGfJL07jnT2ia+iRA3iIV2RbMnZekXEnXJsXK88=
Date: Sun, 29 Jun 2025 15:48:05 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-sysfspy-test-damos-schemes-parameters-setup.patch added to mm-new branch
Message-Id: <20250629224805.DBD6DC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/sysfs.py: test DAMOS schemes parameters setup
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-sysfspy-test-damos-schemes-parameters-setup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-sysfspy-test-damos-schemes-parameters-setup.patch

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
Subject: selftests/damon/sysfs.py: test DAMOS schemes parameters setup
Date: Sat, 28 Jun 2025 09:04:28 -0700

Add DAMON sysfs interface functionality tests for basic DAMOS schemes
parameters setup.

Link: https://lkml.kernel.org/r/20250628160428.53115-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.py |   46 +++++++++++++++++++++--
 1 file changed, 43 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/damon/sysfs.py~selftests-damon-sysfspy-test-damos-schemes-parameters-setup
+++ a/tools/testing/selftests/damon/sysfs.py
@@ -29,7 +29,9 @@ def main():
     kdamonds = _damon_sysfs.Kdamonds(
             [_damon_sysfs.Kdamond(
                 contexts=[_damon_sysfs.DamonCtx(
-                    targets=[_damon_sysfs.DamonTarget(pid=-1)])])])
+                    targets=[_damon_sysfs.DamonTarget(pid=-1)],
+                    schemes=[_damon_sysfs.Damos()],
+                    )])])
     err = kdamonds.start()
     if err is not None:
         print('kdamond start failed: %s' % err)
@@ -66,8 +68,46 @@ def main():
             { 'pid': 0, 'nr_regions': 0, 'regions_list': []}]:
         fail('adaptive targets', status)
 
-    if ctx['schemes'] != []:
-        fail('schemes')
+    if len(ctx['schemes']) != 1:
+        fail('number of schemes', status)
+
+    scheme = ctx['schemes'][0]
+    if scheme['pattern'] != {
+            'min_sz_region': 0,
+            'max_sz_region': 2**64 - 1,
+            'min_nr_accesses': 0,
+            'max_nr_accesses': 2**32 - 1,
+            'min_age_region': 0,
+            'max_age_region': 2**32 - 1,
+            }:
+        fail('damos pattern', status)
+    if scheme['action'] != 9:   # stat
+        fail('damos action', status)
+    if scheme['apply_interval_us'] != 0:
+        fail('damos apply interval', status)
+    if scheme['target_nid'] != -1:
+        fail('damos target nid', status)
+
+    if scheme['quota'] != {
+            'reset_interval': 0,
+            'ms': 0,
+            'sz': 0,
+            'goals': [],
+            'esz': 0,
+            'weight_sz': 0,
+            'weight_nr_accesses': 0,
+            'weight_age': 0,
+            }:
+        fail('damos quota', status)
+
+    if scheme['wmarks'] != {
+            'metric': 0,
+            'interval': 0,
+            'high': 0,
+            'mid': 0,
+            'low': 0,
+            }:
+        fail('damos wmarks', status)
 
     kdamonds.stop()
 
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

