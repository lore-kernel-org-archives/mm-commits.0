Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0CF2F7F14
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298536; cv=none; b=h812mlasK7roudACaIMTLEGe1lrrLtVR5xaWGM//49BD+sGhXqIpJ74lGAB4MC/t75e8dfgH25bJg83fnO4VXO4nCwrIaUhB0Jt0VtdCjLQHGuytFHQWz5hSQNGPFKDxp3JM02oeNa2y1uZG2U4T8KBtdDKOpO/eXZwEmp1LDQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298536; c=relaxed/simple;
	bh=jEFwGK7r05ohUSuDNmAugPVvc1VhI61HHfgQMV8tuKE=;
	h=Date:To:From:Subject:Message-Id; b=jvEhFyK2xeJws4Tce2x4a4z68z29J55x4/qiOQxso3UhvJam6GWQKBGsrZ2VmVmmOOatFugR13cVSwEmI27rxP1R65+QE8PQoVfH2CBnBpdIO6/aA/6OM/+5uu/3S7USXL61IbZppQDP9aTP7jTxiD7ZMKtPH9jAHgY2U2gViig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LExU0kZ3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LExU0kZ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C201F000E9;
	Wed, 29 Jul 2026 04:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298534;
	bh=JC9eF1ZEVlseBpj/dIR8vCVWaA/g6tQptEBmtqJHV+0=;
	h=Date:To:From:Subject;
	b=LExU0kZ3mLZdOSENG96jkwlLg3IkOR0NHSmHC8tbTKY2SGkJvHrYhQ5d0+H1/iPNo
	 n8bvuDp/1AwP2S4AF2gE2vxcAzTO444Al0GvJps+rpt9xeEU+1Os6qLHTF5GsvWsa+
	 WU05buj3lolRyjrNNJ/3lZthaHpvP0xGI8gixr8c=
Date: Tue, 28 Jul 2026 21:15:34 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,lianux.mm@gmail.com,chentao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-fix-dead-code-skipped-checks-and-broken-lookups.patch removed from -mm tree
Message-Id: <20260729041534.A4C201F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon: fix dead code, skipped checks, and broken lookups
has been removed from the -mm tree.  Its filename was
     selftests-damon-fix-dead-code-skipped-checks-and-broken-lookups.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kunwu Chan <chentao@kylinos.cn>
Subject: selftests/damon: fix dead code, skipped checks, and broken lookups
Date: Mon, 29 Jun 2026 07:46:46 -0700

'hugeapge_size' in drgn_dump_damon_status.py was a dead elif branch. 
$fail_reason in sysfs.sh was undefined, silently emptying the error
message.  'exit' instead of 'exist' in sysfs.sh skipped a file existence
check.  'nohugeapge' in sysfs.py broke an action dict lookup.

Fix other wrong strings in the same files.

Link: https://lore.kernel.org/20260601032314.424013-4-kunwu.chan@linux.dev
Link: https://lore.kernel.org/20260629144648.134092-4-sj@kernel.org
Co-developed-by: Wang Lian <lianux.mm@gmail.com>
Signed-off-by: Wang Lian <lianux.mm@gmail.com>
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Signed-off-by: SJ Park <sj@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Kunwu Chan <chentao@kylinos.cn>
Cc: Wang Lian <lianux.mm@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py                                      |    2 +-
 tools/testing/selftests/damon/damos_apply_interval.py                              |    2 +-
 tools/testing/selftests/damon/damos_quota_goal.py                                  |    2 +-
 tools/testing/selftests/damon/drgn_dump_damon_status.py                            |    2 +-
 tools/testing/selftests/damon/sysfs.py                                             |    4 ++--
 tools/testing/selftests/damon/sysfs.sh                                             |    6 +++---
 tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py |    2 +-
 7 files changed, 10 insertions(+), 10 deletions(-)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-fix-dead-code-skipped-checks-and-broken-lookups
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -837,7 +837,7 @@ class Kdamond:
                 for goal in scheme.quota.goals:
                     err = goal.stage()
                     if err is not None:
-                        print('commit_schemes_quota_goals failed stagign: %s'%
+                        print('commit_schemes_quota_goals failed staging: %s'%
                               err)
                         exit(1)
         return write_file(os.path.join(self.sysfs_dir(), 'state'),
--- a/tools/testing/selftests/damon/damos_apply_interval.py~selftests-damon-fix-dead-code-skipped-checks-and-broken-lookups
+++ a/tools/testing/selftests/damon/damos_apply_interval.py
@@ -56,7 +56,7 @@ def main():
     # Because the second scheme was having the apply interval that is ten times
     # lower than that of the first scheme, the second scheme should be tried
     # about ten times more frequently than the first scheme.  For possible
-    # timing errors, check if it was at least nine times more freuqnetly tried.
+    # timing errors, check if it was at least nine times more frequently tried.
     ratio = nr_tried_stats[1] / nr_tried_stats[0]
     if ratio < 9:
         print('%d / %d = %f (< 9)' %
--- a/tools/testing/selftests/damon/damos_quota_goal.py~selftests-damon-fix-dead-code-skipped-checks-and-broken-lookups
+++ a/tools/testing/selftests/damon/damos_quota_goal.py
@@ -66,7 +66,7 @@ def main():
             # effective quota was already minimum that cannot be more reduced
             if expect_increase is False and last_effective_bytes == 1:
                 continue
-            print('efective bytes not changed: %d' % goal.effective_bytes)
+            print('effective bytes not changed: %d' % goal.effective_bytes)
             exit(1)
 
         increased = last_effective_bytes < goal.effective_bytes
--- a/tools/testing/selftests/damon/drgn_dump_damon_status.py~selftests-damon-fix-dead-code-skipped-checks-and-broken-lookups
+++ a/tools/testing/selftests/damon/drgn_dump_damon_status.py
@@ -163,7 +163,7 @@ def damos_filter_to_dict(damos_filter):
                                int(damos_filter.addr_range.end)]
     elif type_ == 'target':
         dict_['target_idx'] = int(damos_filter.target_idx)
-    elif type_ == 'hugeapge_size':
+    elif type_ == 'hugepage_size':
         dict_['sz_range'] = [int(damos_filter.sz_range.min),
                              int(damos_filter.sz_range.max)]
     return dict_
--- a/tools/testing/selftests/damon/sysfs.py~selftests-damon-fix-dead-code-skipped-checks-and-broken-lookups
+++ a/tools/testing/selftests/damon/sysfs.py
@@ -119,7 +119,7 @@ def assert_access_pattern_committed(patt
                 'max_nr_accesses', dump)
     assert_true(dump['min_age_region'] == pattern.age[0], 'min_age_region',
                 dump)
-    assert_true(dump['max_age_region'] == pattern.age[1], 'miaxage_region',
+    assert_true(dump['max_age_region'] == pattern.age[1], 'max_age_region',
                 dump)
 
 def assert_scheme_committed(scheme, dump):
@@ -129,7 +129,7 @@ def assert_scheme_committed(scheme, dump
             'cold': 1,
             'pageout': 2,
             'hugepage': 3,
-            'nohugeapge': 4,
+            'nohugepage': 4,
             'collapse': 5,
             'lru_prio': 6,
             'lru_deprio': 7,
--- a/tools/testing/selftests/damon/sysfs.sh~selftests-damon-fix-dead-code-skipped-checks-and-broken-lookups
+++ a/tools/testing/selftests/damon/sysfs.sh
@@ -3,7 +3,7 @@
 
 source _common.sh
 
-# Kselftest frmework requirement - SKIP code is 4.
+# Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
 
 ensure_write_succ()
@@ -28,7 +28,7 @@ ensure_write_fail()
 
 	if (echo "$content" > "$file") 2> /dev/null
 	then
-		echo "writing $content to $file succeed ($fail_reason)"
+		echo "writing $content to $file succeeded ($reason)"
 		echo "expected failure because $reason"
 		exit 1
 	fi
@@ -363,7 +363,7 @@ test_context()
 {
 	context_dir=$1
 	ensure_dir "$context_dir" "exist"
-	ensure_file "$context_dir/avail_operations" "exit" 400
+	ensure_file "$context_dir/avail_operations" "exist" 400
 	ensure_file "$context_dir/operations" "exist" 600
 	ensure_file "$context_dir/addr_unit" "exist" 600
 	ensure_file "$context_dir/pause" "exist" 600
--- a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py~selftests-damon-fix-dead-code-skipped-checks-and-broken-lookups
+++ a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py
@@ -7,7 +7,7 @@ import time
 import _damon_sysfs
 
 def pass_wss_estimation(sz_region):
-    # access two regions of given size, 2 seocnds per each region
+    # access two regions of given size, 2 seconds per each region
     proc = subprocess.Popen(
             ['./access_memory', '2', '%d' % sz_region, '2000', 'repeat'])
     kdamonds = _damon_sysfs.Kdamonds([_damon_sysfs.Kdamond(
_

Patches currently in -mm which might be from chentao@kylinos.cn are


