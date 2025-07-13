Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440A31EF38E
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752450030; cv=none; b=B5e6Eh3oaME2d94Dn0ENpTUpKdK2ueOq+O2Hpk5NGtHZRo9ZMOgCIadWL7bhUrnrjS/8+yOyEd/5t0dOUKcrmahJe44WQFiC+kz6KaNabLcdev3eWDCt3qaPiLZzVaHt45bZ/jot0fyj2f924noW2TSbF2jXpHsj8hySOpJzR3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752450030; c=relaxed/simple;
	bh=0AztD+3cqDSg7/VAyxyfjP49Gsh1UQ2J9sHw+L13KPQ=;
	h=Date:To:From:Subject:Message-Id; b=majSKQtGHI/79r/OSMVAaIhQZROWlTOqyplV2k1Pkjn2T8ntUxprSuBgr1xu6dh3KpjhRCnKi/8ZNzse/tm6mzKPBUZbYdXFnv8U70p0bGSTe2AsxkcKENmeycRAku4yZ1fIAi/s9cUKO4/lM4QAWBbFmkN1bLztF56bD4kL3Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LOVOUVoZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LOVOUVoZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0A1BC4CEE3;
	Sun, 13 Jul 2025 23:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752450029;
	bh=0AztD+3cqDSg7/VAyxyfjP49Gsh1UQ2J9sHw+L13KPQ=;
	h=Date:To:From:Subject:From;
	b=LOVOUVoZJSY/aswe1vrEo0P8rUTBJj7Hr4i33Z2DBEbKsnfwlbdZbWx6/gTOkkSNr
	 do6bJQhT7/EQ8gFDKrrLbntz33AYQQUcLQhSvQlXMvb6d9A7WzM0h2+H4sQlvuhmba
	 f3zfoHReEmAaVQV/KSxlNd58ON7/c/e2IvJZYifE=
Date: Sun, 13 Jul 2025 16:40:29 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-sysfspy-test-adaptive-targets-parameter.patch removed from -mm tree
Message-Id: <20250713234029.B0A1BC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/sysfs.py: test adaptive targets parameter
has been removed from the -mm tree.  Its filename was
     selftests-damon-sysfspy-test-adaptive-targets-parameter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

