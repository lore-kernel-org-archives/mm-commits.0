Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D0B3C463
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 03:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753153905; cv=none; b=DZc804Cg/q/d/Qgg79JDXzwTAVF06+Mxpeh8tDdFt6pNl4NlEaCIGCkztA4kVdkZFQu7/tI1PPlK4RrPlhpTdMQPrtlitkNiEAiIj+gcwkP7D0RLXkujAYtC3yKS+EPLfXDRWzXh+u59dh/hzu5O6Sy1w+pfKXORTjxBVIQvrn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753153905; c=relaxed/simple;
	bh=fhPtMZYyqI6TJk7QtQ7jtvStnQgxoA4fNFINIhiz6XI=;
	h=Date:To:From:Subject:Message-Id; b=Dj5Px9Oub1729TQ6TwahwaKC4jiagKK04A6424xF7J2GvaSexI6tSkzh8Vgiil3OcYxJaNzVr1LA5jGFGHcM24DfvPSZC+5T6Eb9SV0mfsEKOuXZCUFsCJGjSLx7OssyiNRRa9uEVxCPlP/bhzRRvSD408/qnLiEY77A8h/PkBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=snt/Iiqd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="snt/Iiqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 592CBC4CEED;
	Tue, 22 Jul 2025 03:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753153905;
	bh=fhPtMZYyqI6TJk7QtQ7jtvStnQgxoA4fNFINIhiz6XI=;
	h=Date:To:From:Subject:From;
	b=snt/IiqdgMr97JSPrMMQc6vqJXyR5AqFXLDsIt4ppd4XCckFzCc8ODUiKRfqzm8i8
	 aFc1ZsU691hOaaTCkytE3AIsugerdOx2cfusrwDvURE3hHlNzv7V3MLcZUoRPITAyC
	 gpCrr+npDNgKrAhG0qxyPdgCJM5VtnfF2U5r268A=
Date: Mon, 21 Jul 2025 20:11:44 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-sysfspy-generalize-damosquota-commit-assertion.patch added to mm-new branch
Message-Id: <20250722031145.592CBC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/sysfs.py: generalize DamosQuota commit assertion
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-sysfspy-generalize-damosquota-commit-assertion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-sysfspy-generalize-damosquota-commit-assertion.patch

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
Subject: selftests/damon/sysfs.py: generalize DamosQuota commit assertion
Date: Sun, 20 Jul 2025 10:16:43 -0700

DamosQuota commitment assertion is hard-coded for a specific test case. 
Split it out into a general version that can be reused for different test
cases.

Link: https://lkml.kernel.org/r/20250720171652.92309-14-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.py |   31 ++++++++++++++---------
 1 file changed, 20 insertions(+), 11 deletions(-)

--- a/tools/testing/selftests/damon/sysfs.py~selftests-damon-sysfspy-generalize-damosquota-commit-assertion
+++ a/tools/testing/selftests/damon/sysfs.py
@@ -41,6 +41,18 @@ def assert_watermarks_committed(watermar
     assert_true(dump['mid'] == watermarks.mid, 'mid', dump)
     assert_true(dump['low'] == watermarks.low, 'low', dump)
 
+def assert_quota_committed(quota, dump):
+    assert_true(dump['reset_interval'] == quota.reset_interval_ms,
+                'reset_interval', dump)
+    assert_true(dump['ms'] == quota.ms, 'ms', dump)
+    assert_true(dump['sz'] == quota.sz, 'sz', dump)
+    # TODO: assert goals are committed
+    assert_true(dump['weight_sz'] == quota.weight_sz_permil, 'weight_sz', dump)
+    assert_true(dump['weight_nr_accesses'] == quota.weight_nr_accesses_permil,
+                'weight_nr_accesses', dump)
+    assert_true(
+            dump['weight_age'] == quota.weight_age_permil, 'weight_age', dump)
+
 def main():
     kdamonds = _damon_sysfs.Kdamonds(
             [_damon_sysfs.Kdamond(
@@ -104,18 +116,15 @@ def main():
     if scheme['target_nid'] != -1:
         fail('damos target nid', status)
 
-    if scheme['quota'] != {
-            'reset_interval': 0,
-            'ms': 0,
-            'sz': 0,
-            'goals': [],
-            'esz': 0,
-            'weight_sz': 0,
-            'weight_nr_accesses': 0,
-            'weight_age': 0,
-            }:
-        fail('damos quota', status)
+    migrate_dests = scheme['migrate_dests']
+    if migrate_dests['nr_dests'] != 0:
+        fail('nr_dests', status)
+    if migrate_dests['node_id_arr'] != []:
+        fail('node_id_arr', status)
+    if migrate_dests['weight_arr'] != []:
+        fail('weight_arr', status)
 
+    assert_quota_committed(_damon_sysfs.DamosQuota(), scheme['quota'])
     assert_watermarks_committed(_damon_sysfs.DamosWatermarks(),
                                 scheme['wmarks'])
 
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

