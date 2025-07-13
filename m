Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E6C20F070
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752450028; cv=none; b=Jz+qPv2ChcV/awWuuigjssVlL1qK0KfIghPbn8To4FvgmB9zQIhjm7RNTYVfxp8gQbLDhIeODlFVSs/OGsuUUnJ1KEOR/U5b/8vpOrXOHWyXE7ft+nZmryoaCZUus3RupRU9MgQw9dXjyrMvc5Dq9v2nJnB0Cqw329ldGzcFTYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752450028; c=relaxed/simple;
	bh=dTtMjwe/8rrBairE5d2HJPCpPfLLe3neFeD2kJmK1O4=;
	h=Date:To:From:Subject:Message-Id; b=Nr29GygI/U2+yHmqsma6HHYBK6rEmDOKQALkQtuMhasvfznWfJGj9RzylyjmgzAaquSakAIULodkwMPkbcljvoi+1C0H0PoXPFvWSYlrEDsOGjTGsUMdbfCn5K4wo0IUiu7J1pOu0Oz9sBAllonnHssu8Y9PT6rd/a9P8V6cikY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J8DnyBcn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J8DnyBcn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B578C4CEE3;
	Sun, 13 Jul 2025 23:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752450028;
	bh=dTtMjwe/8rrBairE5d2HJPCpPfLLe3neFeD2kJmK1O4=;
	h=Date:To:From:Subject:From;
	b=J8DnyBcnqDayQ7rE4Umzk1Gw0Pi/Gfw89oUopr5z3z8KQSyfHJMOJDlYqFRSzZWuY
	 wkRdkpvcj9MYG+zBQWGncf6jNFlnBOU51O/riiQ7Dp7GhmeqklPZBCZNbwhO45t5yV
	 VKxwr5jR+aBHDo6yOjD3+vsUCakjnxIbvwwbXXLY=
Date: Sun, 13 Jul 2025 16:40:28 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-sysfspy-test-monitoring-attribute-parameters.patch removed from -mm tree
Message-Id: <20250713234028.9B578C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/sysfs.py: test monitoring attribute parameters
has been removed from the -mm tree.  Its filename was
     selftests-damon-sysfspy-test-monitoring-attribute-parameters.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/sysfs.py: test monitoring attribute parameters
Date: Sat, 28 Jun 2025 09:04:26 -0700

Add DAMON sysfs interface functionality tests for DAMON monitoring
attribute parameters, including intervals, intervals tuning goals, and
min/max number of regions.

Link: https://lkml.kernel.org/r/20250628160428.53115-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.py |   34 +++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/damon/sysfs.py~selftests-damon-sysfspy-test-monitoring-attribute-parameters
+++ a/tools/testing/selftests/damon/sysfs.py
@@ -20,6 +20,11 @@ def dump_damon_status_dict(pid):
     except Exception as e:
         return None, 'json.load fail (%s)' % e
 
+def fail(expectation, status):
+    print('unexpected %s' % expectation)
+    print(json.dumps(status, indent=4))
+    exit(1)
+
 def main():
     kdamonds = _damon_sysfs.Kdamonds(
             [_damon_sysfs.Kdamond(contexts=[_damon_sysfs.DamonCtx()])])
@@ -34,8 +39,33 @@ def main():
         exit(1)
 
     if len(status['contexts']) != 1:
-        print('number of contexts: %d' % len(status['contexts']))
-        exit(1)
+        fail('number of contexts', status)
+
+    ctx = status['contexts'][0]
+    attrs = ctx['attrs']
+    if attrs['sample_interval'] != 5000:
+        fail('sample interval', status)
+    if attrs['aggr_interval'] != 100000:
+        fail('aggr interval', status)
+    if attrs['ops_update_interval'] != 1000000:
+        fail('ops updte interval', status)
+
+    if attrs['intervals_goal'] != {
+            'access_bp': 0, 'aggrs': 0,
+            'min_sample_us': 0, 'max_sample_us': 0}:
+        fail('intervals goal')
+
+    if attrs['min_nr_regions'] != 10:
+        fail('min_nr_regions')
+    if attrs['max_nr_regions'] != 1000:
+        fail('max_nr_regions')
+
+    if ctx['adaptive_targets'] != []:
+        fail('adaptive_targets')
+
+    if ctx['schemes'] != []:
+        fail('schemes')
+
     kdamonds.stop()
 
 if __name__ == '__main__':
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

