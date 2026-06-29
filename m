Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E631837F8B1
	for <mm-commits@vger.kernel.org>; Mon, 29 Jun 2026 17:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782755048; cv=none; b=WVKqRyOZ6NnbGJREjppv3/zv1/GUFbyZwOwnZ/BIk1iEJXoNh6nMhbxAOWvnkrUvMFl4mJqFLKkfHxnI7cM/m1KsDt7mgPojmDt01VHopgxizvNB9Q46ob4aw+okLK4oYFIqXBaQxEQjsyiBKqY3uw2okmA7NUt8pheyKzy7c8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782755048; c=relaxed/simple;
	bh=0V1dMY4K4MP9tEp7ZrvSVDNRhoqUFi48uVDmt0N67go=;
	h=Date:To:From:Subject:Message-Id; b=f+4ZfAxcVQyesQXUr3WdBNDAsVB8xdLrweXu3Ir4GEYLZEwwRhNPjl93DUG6fom7HuoNIEN1QYPU6pUn8HeNBVrGcn/setwotxuQwsDgeM7xS7XGaZTXT6+1ZRl+cSIH78llsi/+PJFNehEVa6RBWuyR8TOsJyIi80stnGhRnGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=msmf2BhV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="msmf2BhV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6769B1F000E9;
	Mon, 29 Jun 2026 17:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782755046;
	bh=MydwZXqJQ0ZN1zPnMsatZyU1/2womDRZdlLO2xXjoRc=;
	h=Date:To:From:Subject;
	b=msmf2BhVaI8AAXKEopVusVd5EKTOMLY0yo5zNI2IGSWpdnDOfK5Kz90FMaCQTwjsr
	 dJ32UxQrxOGH8Wwsf8cIXjEWNcN89feFU0C9W/k/fwJCNmu/Fii0U/Gy+pQlRIEsWk
	 0yHPpSRqWT2k8/wsB/YJCfQ3rZEzg3Kgs+k4GlM0=
Date: Mon, 29 Jun 2026 10:44:06 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,lianux.mm@gmail.com,chentao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-fix-dead-code-skipped-checks-and-broken-lookups.patch added to mm-new branch
Message-Id: <20260629174406.6769B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon: fix dead code, skipped checks, and broken lookups
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-fix-dead-code-skipped-checks-and-broken-lookups.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-fix-dead-code-skipped-checks-and-broken-lookups.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

selftests-damon-prevent-cross-context-state-pollution-in-damonctx.patch
selftests-damon-damos_tried_regions-fix-expectation-output-and-join-typeerror.patch
selftests-damon-fix-dead-code-skipped-checks-and-broken-lookups.patch

