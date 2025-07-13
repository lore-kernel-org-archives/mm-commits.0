Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E880C1EF38E
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752450031; cv=none; b=LlMojHms6qEdMlzotQ8KdDWFUCezZH+vzS3BCF+qtkXs8wVgWvdt4giiRM4utS+fiTBdvxsfWv3qX6BH3V081d4zxrqeSvZuvoaA3WbhPFLTdj6KzFWZt+PQU5ooBcqfyfFEjzxqXqwwLLTLs+1F5fn3bzdDfsxyl0Gd10N5810=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752450031; c=relaxed/simple;
	bh=ymu8YJG+8fITih7IfX9XkU8KRaHPWGL/dq+TxlTqqwc=;
	h=Date:To:From:Subject:Message-Id; b=IAC6NaYJBQ+PJbZSwId8ldeQ4NihuTOhOC+Z/W9rphLzyzH33R4SiFvYMvbTZn2TH5HasKz9DoU30r0O3DxQKLgrWV2GxuHKme304r3Rf7fQA7hNqqoj+LB0sLkxYmMajZrS3TFDzI7UBLloXRQIIF9U35rXxl2wcNYEboTbZf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pHiJoAsK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pHiJoAsK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE7CEC4CEF5;
	Sun, 13 Jul 2025 23:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752450030;
	bh=ymu8YJG+8fITih7IfX9XkU8KRaHPWGL/dq+TxlTqqwc=;
	h=Date:To:From:Subject:From;
	b=pHiJoAsKHv8K2V+V03L2NmW86Ssq0za500kW4zbNvhZFCLN2LaHc8ycQy+BZr1yH2
	 vd6ny/QGFSTXPuDVWSbFFnWwxtT7hvkRRD5ho8cElpHr/WfWxcZUU6EmQywM2+96sJ
	 2qHIjW9d2QZFmLaIXalBjzO8xmi/beT2sRG8N2OA=
Date: Sun, 13 Jul 2025 16:40:30 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-sysfspy-test-damos-schemes-parameters-setup.patch removed from -mm tree
Message-Id: <20250713234030.BE7CEC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/sysfs.py: test DAMOS schemes parameters setup
has been removed from the -mm tree.  Its filename was
     selftests-damon-sysfspy-test-damos-schemes-parameters-setup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

samples-damon-wsse-rename-to-have-damon_sample_-prefix.patch
samples-damon-prcl-rename-to-have-damon_sample_-prefix.patch
samples-damon-mtier-rename-to-have-damon_sample_-prefix.patch
mm-damon-sysfs-use-damon-core-api-damon_is_running.patch
mm-damon-sysfs-dont-hold-kdamond_lock-in-before_terminate.patch
docs-mm-damon-maintainer-profile-update-for-mm-new-tree.patch
mm-damon-add-struct-damos_migrate_dests.patch
mm-damon-core-add-damos-migrate_dests-field.patch
mm-damon-sysfs-schemes-implement-damos-action-destinations-directory.patch
mm-damon-sysfs-schemes-set-damos-migrate_dests.patch
docs-abi-damon-document-schemes-dests-directory.patch
docs-admin-guide-mm-damon-usage-document-dests-directory.patch
mm-damon-accept-parallel-damon_call-requests.patch
mm-damon-core-introduce-repeat-mode-damon_call.patch
mm-damon-stat-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-reclaim-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-lru_sort-use-damon_call-repeat-mode-instead-of-damon_callback.patch
samples-damon-prcl-use-damon_call-repeat-mode-instead-of-damon_callback.patch
samples-damon-wsse-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-core-do-not-call-opscleanup-when-destroying-targets.patch
mm-damon-core-add-cleanup_target-ops-callback.patch
mm-damon-vaddr-put-pid-in-cleanup_target.patch
mm-damon-sysfs-remove-damon_sysfs_destroy_targets.patch
mm-damon-core-destroy-targets-when-kdamond_fn-finish.patch
mm-damon-sysfs-remove-damon_sysfs_before_terminate.patch
mm-damon-core-remove-damon_callback.patch

