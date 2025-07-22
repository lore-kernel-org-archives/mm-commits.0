Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3BC12E36FD
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 03:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753153907; cv=none; b=TDvvgrGcCZCqf2IAHhQ/AFoLw/5nQF5HS1kg5G2tR0SZkiRRVtp32l6QbvNZT2iA506YIpZmZrWxWTRKK2vEf+ighmQiUrnGbLIQ1VhElCufVLZTACdNqE8qbUudKfW6ICGs80GQNtM5WDFZt7ZHMHoIyzAxnDbwgx1mDrArtz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753153907; c=relaxed/simple;
	bh=yaBaMNVlvSXHG2y3W3bwmjw11tI7tL15PWVZFYBN+o0=;
	h=Date:To:From:Subject:Message-Id; b=fOMysN4Cx7YxCLlXR4kQSLVs7UhnP3OdHGQ7A9OEw/JeOSGSr/TcFAaHtfyyZlRMsTpVbYjV64Oyge0EV0LCmIUwsu+6/jRuXb6UeLtS9JrNbVQOWoVfQDSNfgIt5ask7mjSUPE8Ej6Y2bFBvMiMjKoVQ66vFmxtW/S7lB21Tig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JnTN3bZ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JnTN3bZ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D31DC4CEED;
	Tue, 22 Jul 2025 03:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753153907;
	bh=yaBaMNVlvSXHG2y3W3bwmjw11tI7tL15PWVZFYBN+o0=;
	h=Date:To:From:Subject:From;
	b=JnTN3bZ6QguRNl/HZl+dzPN3kobp0H8vpXusfWw1LHBcQs5abId9PQe08YIQp+yYb
	 Vqe3duT8fgMeqofcoSweY84D6HeNf0MJpCCDICs86PUGbtyKfPmgicOgWHjwVBwQYu
	 SzN31B5mwmbZ8MzYDSQ010zbNUVTyWNapFRFS2AQ=
Date: Mon, 21 Jul 2025 20:11:46 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-sysfspy-test-quota-goal-commitment.patch added to mm-new branch
Message-Id: <20250722031147.2D31DC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/sysfs.py: test quota goal commitment
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-sysfspy-test-quota-goal-commitment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-sysfspy-test-quota-goal-commitment.patch

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
Subject: selftests/damon/sysfs.py: test quota goal commitment
Date: Sun, 20 Jul 2025 10:16:44 -0700

Current DAMOS quota commitment assertion is not testing quota goal
commitment.  Add the test.

Link: https://lkml.kernel.org/r/20250720171652.92309-15-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.py |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/damon/sysfs.py~selftests-damon-sysfspy-test-quota-goal-commitment
+++ a/tools/testing/selftests/damon/sysfs.py
@@ -41,12 +41,28 @@ def assert_watermarks_committed(watermar
     assert_true(dump['mid'] == watermarks.mid, 'mid', dump)
     assert_true(dump['low'] == watermarks.low, 'low', dump)
 
+def assert_quota_goal_committed(qgoal, dump):
+    metric_val = {
+            'user_input': 0,
+            'some_mem_psi_us': 1,
+            'node_mem_used_bp': 2,
+            'node_mem_free_bp': 3,
+            }
+    assert_true(dump['metric'] == metric_val[qgoal.metric], 'metric', dump)
+    assert_true(dump['target_value'] == qgoal.target_value, 'target_value',
+                dump)
+    if qgoal.metric == 'user_input':
+        assert_true(dump['current_value'] == qgoal.current_value,
+                    'current_value', dump)
+    assert_true(dump['nid'] == qgoal.nid, 'nid', dump)
+
 def assert_quota_committed(quota, dump):
     assert_true(dump['reset_interval'] == quota.reset_interval_ms,
                 'reset_interval', dump)
     assert_true(dump['ms'] == quota.ms, 'ms', dump)
     assert_true(dump['sz'] == quota.sz, 'sz', dump)
-    # TODO: assert goals are committed
+    for idx, qgoal in enumerate(quota.goals):
+        assert_quota_goal_committed(qgoal, dump['goals'][idx])
     assert_true(dump['weight_sz'] == quota.weight_sz_permil, 'weight_sz', dump)
     assert_true(dump['weight_nr_accesses'] == quota.weight_nr_accesses_permil,
                 'weight_nr_accesses', dump)
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

