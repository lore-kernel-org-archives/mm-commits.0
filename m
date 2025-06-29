Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD69522A
	for <mm-commits@vger.kernel.org>; Sun, 29 Jun 2025 22:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751237282; cv=none; b=TAK2z6MadnGkurSq05yXlgzvgsDy9LxY0pzslF9oLLJkUjsw4Rn+RLkMYxKVx1ArTXdyrK/UH5VISm2T8F/fL1JN+//msYDVWR5yNs4wAxF6qdWnBAffbgDxS4mvyu1gBgekeyusuaRlixjf1g40dGaNjydEZWQaymWuYzjwCVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751237282; c=relaxed/simple;
	bh=rhg12gBuybCgRfwy3J7nJYbZzSdUxK8AfWZmDvtL27g=;
	h=Date:To:From:Subject:Message-Id; b=m/qbDtdrjGXNgLQJGY6g95wlJzuln7gLNbYkzrkz7enuxjuuuCXj1YU7226hSWrbjcJtlNdpmRc7Ki14GCllzpgE+INji8d+Q3AIiGl18JhjxasfdipH0382Aw810KAF/P2kwLk2MMGQ5fq1rB7RM3OBEHQ8JnWGK1NkKry1rr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AUezD0VR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AUezD0VR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB71C4CEEB;
	Sun, 29 Jun 2025 22:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751237282;
	bh=rhg12gBuybCgRfwy3J7nJYbZzSdUxK8AfWZmDvtL27g=;
	h=Date:To:From:Subject:From;
	b=AUezD0VRGnIQJ4Ce0SPgdUlxARXueWQlgTBwv25DG16+Y4QNkjOWYsHGplshBtNfb
	 xWKDGxx722DyZfTA1m1u9xt86ZhOE8J1+Oba1AmVcPaePN6M3Xu3AcQ4/RmgCXgWtW
	 NxRQAzMbXZEz/olKbcHOXjpwDtY+qMR/r2PSRzXA=
Date: Sun, 29 Jun 2025 15:48:01 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-sysfspy-test-monitoring-attribute-parameters.patch added to mm-new branch
Message-Id: <20250629224802.4EB71C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/sysfs.py: test monitoring attribute parameters
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-sysfspy-test-monitoring-attribute-parameters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-sysfspy-test-monitoring-attribute-parameters.patch

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

