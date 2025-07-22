Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE20028BA9D
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 03:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753153946; cv=none; b=sBfXouA+v6mqs8IYbuOKWzk2I1BDqcRN7xceS8Zd/U4EqYWXoaWH30NI3aSB8Z+qfj70xSItdgmEX9QMvB2TxJ6U1gSC3fcibQiYtarAXCDVdQIhu04HTjDCFm0bl/5/VCZqx/lQsY2vIhJGHe3Kt3eHyQAXDpICl5CpFjIoBT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753153946; c=relaxed/simple;
	bh=NSx0C07A5dFOp6tLbmiqqil5DTXyTS+cNpsepj5p3us=;
	h=Date:To:From:Subject:Message-Id; b=FyRs0601XkffDlBCqypSowI6WX9RT1KISzQsDmV8fNvZeWQ1ABHH/mjGJI1TDYZX/rcVuPAg1/Ljoc5XMR3F3U8R31q84t6BpjvbvtpSZ3hZ3hubTCnsQq5wjMJkOkEuhsbLjJUhfPvcap2O/3h73IOVfYpbJy0K9060zFhj4cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wubQv4/p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wubQv4/p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82659C4CEED;
	Tue, 22 Jul 2025 03:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753153946;
	bh=NSx0C07A5dFOp6tLbmiqqil5DTXyTS+cNpsepj5p3us=;
	h=Date:To:From:Subject:From;
	b=wubQv4/p/C7Q4Hu9h42R7c02LIpqUAwh6eDMqEQlEHTw1O+Bpo3HKV+W5UsPgRVOK
	 8Gc+Cs5PH1J7vTlDEJTdSieOoomPEO/nxanTRkz7agUyPoTXc/b2jFbsxjdqmQ2H3V
	 lS4xF8r9j4e2oJra9BefgGPMQFxCLnhHWtdwSYFo=
Date: Mon, 21 Jul 2025 20:12:25 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-sysfspy-test-non-default-parameters-runtime-commit.patch added to mm-new branch
Message-Id: <20250722031226.82659C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/sysfs.py: test non-default parameters runtime commit
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-sysfspy-test-non-default-parameters-runtime-commit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-sysfspy-test-non-default-parameters-runtime-commit.patch

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
Subject: selftests/damon/sysfs.py: test non-default parameters runtime commit
Date: Sun, 20 Jul 2025 10:16:51 -0700

sysfs.py is testing only the default and minimum DAMON parameters.  Add
another test case for more non-default additional DAMON parameters
commitment on runtime.

Link: https://lkml.kernel.org/r/20250720171652.92309-22-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.py |   53 +++++++++++++++++++++++
 1 file changed, 53 insertions(+)

--- a/tools/testing/selftests/damon/sysfs.py~selftests-damon-sysfspy-test-non-default-parameters-runtime-commit
+++ a/tools/testing/selftests/damon/sysfs.py
@@ -194,6 +194,59 @@ def main():
 
     assert_ctxs_committed(kdamonds.kdamonds[0].contexts, status['contexts'])
 
+    context = _damon_sysfs.DamonCtx(
+            monitoring_attrs=_damon_sysfs.DamonAttrs(
+                sample_us=100000, aggr_us=2000000,
+                intervals_goal=_damon_sysfs.IntervalsGoal(
+                    access_bp=400, aggrs=3, min_sample_us=5000,
+                    max_sample_us=10000000),
+                update_us=2000000),
+            schemes=[_damon_sysfs.Damos(
+                action='pageout',
+                access_pattern=_damon_sysfs.DamosAccessPattern(
+                    size=[4096, 2**10],
+                    nr_accesses=[3, 317],
+                    age=[5,71]),
+                quota=_damon_sysfs.DamosQuota(
+                    sz=100*1024*1024, ms=100,
+                    goals=[_damon_sysfs.DamosQuotaGoal(
+                        metric='node_mem_used_bp',
+                        target_value=9950,
+                        nid=1)],
+                    reset_interval_ms=1500,
+                    weight_sz_permil=20,
+                    weight_nr_accesses_permil=200,
+                    weight_age_permil=1000),
+                watermarks=_damon_sysfs.DamosWatermarks(
+                    metric = 'free_mem_rate', interval = 500000, # 500 ms
+                    high = 500, mid = 400, low = 50),
+                target_nid=1,
+                apply_interval_us=1000000,
+                dests=_damon_sysfs.DamosDests(
+                    dests=[_damon_sysfs.DamosDest(id=1, weight=30),
+                           _damon_sysfs.DamosDest(id=0, weight=70)]),
+                core_filters=[
+                    _damon_sysfs.DamosFilter(type_='addr', matching=True,
+                                             allow=False, addr_start=42,
+                                             addr_end=4242),
+                    ],
+                ops_filters=[
+                    _damon_sysfs.DamosFilter(type_='anon', matching=True,
+                                             allow=True),
+                    ],
+                )])
+    context.idx = 0
+    context.kdamond = kdamonds.kdamonds[0]
+    kdamonds.kdamonds[0].contexts = [context]
+    kdamonds.kdamonds[0].commit()
+
+    status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
+    if err is not None:
+        print(err)
+        exit(1)
+
+    assert_ctxs_committed(kdamonds.kdamonds[0].contexts, status['contexts'])
+
     kdamonds.stop()
 
 if __name__ == '__main__':
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

