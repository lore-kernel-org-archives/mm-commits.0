Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608651DF991
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 04:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753158558; cv=none; b=sdopIn/ILpdrEjcE+4nxUPQI4kCDcy/iZrZOwyHjnaYwgAiqmJDvnbrZgaxNI1ErT/uhs3i9pgEPwPv2rFAXJ4ejzMD/txLMOzn+f9O0/4l4hSgjXA/pRrldbzZOe0oafgU/Q42tCC+NGq72lx44KgK1j5aNA0sAXcoSCyxRLbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753158558; c=relaxed/simple;
	bh=Uhy7kxi4WgK5TF6m+JZHvY2CYYhklcVjoB0D9OpN9qY=;
	h=Date:To:From:Subject:Message-Id; b=hMFZZDIEBy8O60tZe2LMMEqnTFaL+SkNrJHRhjiE7oO0d78e81PGB4D02m3F51TMUObP4CBxkFF57JGnV/sq9wOoPvLW2Og/1SzJ38wCtqXekyXzVSLK6FK8O0OyseE9MJKctufZd/jM70KOgdcFdJuTdcMo94bOX30SIag7Z4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FQRmSgP7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FQRmSgP7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2DCBC4CEEB;
	Tue, 22 Jul 2025 04:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753158556;
	bh=Uhy7kxi4WgK5TF6m+JZHvY2CYYhklcVjoB0D9OpN9qY=;
	h=Date:To:From:Subject:From;
	b=FQRmSgP7Q2uiE9V7UsLDIctvzCMQenVtkcFdHH1tizIP06JjKzyCuwCbWGQbBubs6
	 JmuqQ89CPyAq93GUpa5n4eari01PU5BGOQsCL2Du1Mnun5fMxc44CPUawbhdu4LwM3
	 DSmMjeARlYgVRnJVPD1zxlc7Tkq2YrN4SFMYWat0=
Date: Mon, 21 Jul 2025 21:29:16 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-sysfspy-generalize-damos-scheme-commit-assertion.patch added to mm-unstable branch
Message-Id: <20250722042916.D2DCBC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/sysfs.py: generalize DAMOS scheme commit assertion
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-sysfspy-generalize-damos-scheme-commit-assertion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-sysfspy-generalize-damos-scheme-commit-assertion.patch

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
Subject: selftests/damon/sysfs.py: generalize DAMOS scheme commit assertion
Date: Sun, 20 Jul 2025 10:16:46 -0700

DAMOS scheme commitment assertion is hard-coded for a specific test case. 
Split it out into a general version that can be reused for different test
cases.

Link: https://lkml.kernel.org/r/20250720171652.92309-17-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.py |   59 ++++++++++++++---------
 1 file changed, 37 insertions(+), 22 deletions(-)

--- a/tools/testing/selftests/damon/sysfs.py~selftests-damon-sysfspy-generalize-damos-scheme-commit-assertion
+++ a/tools/testing/selftests/damon/sysfs.py
@@ -76,6 +76,42 @@ def assert_migrate_dests_committed(dests
         assert_true(dump['node_id_arr'][idx] == dest.id, 'node_id', dump)
         assert_true(dump['weight_arr'][idx] == dest.weight, 'weight', dump)
 
+def assert_access_pattern_committed(pattern, dump):
+    assert_true(dump['min_sz_region'] == pattern.size[0], 'min_sz_region',
+                dump)
+    assert_true(dump['max_sz_region'] == pattern.size[1], 'max_sz_region',
+                dump)
+    assert_true(dump['min_nr_accesses'] == pattern.nr_accesses[0],
+                'min_nr_accesses', dump)
+    assert_true(dump['max_nr_accesses'] == pattern.nr_accesses[1],
+                'max_nr_accesses', dump)
+    assert_true(dump['min_age_region'] == pattern.age[0], 'min_age_region',
+                dump)
+    assert_true(dump['max_age_region'] == pattern.age[1], 'miaxage_region',
+                dump)
+
+def assert_scheme_committed(scheme, dump):
+    assert_access_pattern_committed(scheme.access_pattern, dump['pattern'])
+    action_val = {
+            'willneed': 0,
+            'cold': 1,
+            'pageout': 2,
+            'hugepage': 3,
+            'nohugeapge': 4,
+            'lru_prio': 5,
+            'lru_deprio': 6,
+            'migrate_hot': 7,
+            'migrate_cold': 8,
+            'stat': 9,
+            }
+    assert_true(dump['action'] == action_val[scheme.action], 'action', dump)
+    assert_true(dump['apply_interval_us'] == scheme. apply_interval_us,
+                'apply_interval_us', dump)
+    assert_true(dump['target_nid'] == scheme.target_nid, 'target_nid', dump)
+    assert_migrate_dests_committed(scheme.dests, dump['migrate_dests'])
+    assert_quota_committed(scheme.quota, dump['quota'])
+    assert_watermarks_committed(scheme.watermarks, dump['wmarks'])
+
 def main():
     kdamonds = _damon_sysfs.Kdamonds(
             [_damon_sysfs.Kdamond(
@@ -122,28 +158,7 @@ def main():
     if len(ctx['schemes']) != 1:
         fail('number of schemes', status)
 
-    scheme = ctx['schemes'][0]
-    if scheme['pattern'] != {
-            'min_sz_region': 0,
-            'max_sz_region': 2**64 - 1,
-            'min_nr_accesses': 0,
-            'max_nr_accesses': 2**32 - 1,
-            'min_age_region': 0,
-            'max_age_region': 2**32 - 1,
-            }:
-        fail('damos pattern', status)
-    if scheme['action'] != 9:   # stat
-        fail('damos action', status)
-    if scheme['apply_interval_us'] != 0:
-        fail('damos apply interval', status)
-    if scheme['target_nid'] != -1:
-        fail('damos target nid', status)
-
-    assert_migrate_dests_committed(_damon_sysfs.DamosDests(),
-                                   scheme['migrate_dests'])
-    assert_quota_committed(_damon_sysfs.DamosQuota(), scheme['quota'])
-    assert_watermarks_committed(_damon_sysfs.DamosWatermarks(),
-                                scheme['wmarks'])
+    assert_scheme_committed(_damon_sysfs.Damos(), ctx['schemes'][0])
 
     kdamonds.stop()
 
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
selftests-damon-sysfspy-generalize-damos-scheme-commit-assertion.patch
selftests-damon-sysfspy-test-damos-filters-commitment.patch
selftests-damon-sysfspy-generalize-damos-schemes-commit-assertion.patch
selftests-damon-sysfspy-generalize-monitoring-attributes-commit-assertion.patch
selftests-damon-sysfspy-generalize-damon-context-commit-assertion.patch
selftests-damon-sysfspy-test-non-default-parameters-runtime-commit.patch
selftests-damon-sysfspy-test-runtime-reduction-of-damon-parameters.patch

