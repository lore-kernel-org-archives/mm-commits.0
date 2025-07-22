Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8CEA28C000
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 03:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753153912; cv=none; b=A6wDv96n+NBMGWxJ3ymqkw+F9SlVqf3W3LURSjpoqHmoYHYj3hKPlqpe5rS+jHHmEG2aQwbB0lHr3zHjzf1kkJjd50/7rmxo+JDuVP3BYAErBR0VKuq9xIB0yF+y5oKuCZN4zzcEXNAREDe3lgwMhh4s4RhLwiVabYSpXiW9ewA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753153912; c=relaxed/simple;
	bh=rztBg5JdUI/7wpw4Rgn+lriBg+0cjQSoJ63hzRIB09s=;
	h=Date:To:From:Subject:Message-Id; b=H5LkcJfXLmgk0igrbFLW6oRZcvAyNzOsePX7KDe6gawsX5d3gNLC3VTBiXirhxXwjUqhzjOnQCD32bAKrw9FCmJXI7U1Fj0oXbxfVjKvgB8SA6bvWlLhvx875AkxgT+Yh+k+SJKoGBNqiB2rzbN93tLfY2dbUG9/3/KiM/vi7/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LbabStkZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LbabStkZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DE8FC4CEED;
	Tue, 22 Jul 2025 03:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753153912;
	bh=rztBg5JdUI/7wpw4Rgn+lriBg+0cjQSoJ63hzRIB09s=;
	h=Date:To:From:Subject:From;
	b=LbabStkZ9BMUZs2StOb5RM/OZvoRq3ib3LkJ9RyPxD+48oOKhzIUPGELBcPNi59rf
	 sRrq6CWXJ46Aa0Pxvo/NsPnacVkTlMzloo2V2sEshBlgAw11P8T7qH9tn3DhQ0rD0Q
	 mt1Fl57cyu4r5k04LaAYznqzXncw9DWhEx3xLoWE=
Date: Mon, 21 Jul 2025 20:11:52 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-sysfspy-test-damos-filters-commitment.patch added to mm-new branch
Message-Id: <20250722031152.8DE8FC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/sysfs.py: test DAMOS filters commitment
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-sysfspy-test-damos-filters-commitment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-sysfspy-test-damos-filters-commitment.patch

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
Subject: selftests/damon/sysfs.py: test DAMOS filters commitment
Date: Sun, 20 Jul 2025 10:16:47 -0700

Current DAMOS scheme commitment assertion is not testing DAMOS filters. 
Add the test.

Link: https://lkml.kernel.org/r/20250720171652.92309-18-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.py |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/tools/testing/selftests/damon/sysfs.py~selftests-damon-sysfspy-test-damos-filters-commitment
+++ a/tools/testing/selftests/damon/sysfs.py
@@ -76,6 +76,21 @@ def assert_migrate_dests_committed(dests
         assert_true(dump['node_id_arr'][idx] == dest.id, 'node_id', dump)
         assert_true(dump['weight_arr'][idx] == dest.weight, 'weight', dump)
 
+def assert_filter_committed(filter_, dump):
+    assert_true(filter_.type_ == dump['type'], 'type', dump)
+    assert_true(filter_.matching == dump['matching'], 'matching', dump)
+    assert_true(filter_.allow == dump['allow'], 'allow', dump)
+    # TODO: check memcg_path and memcg_id if type is memcg
+    if filter_.type_ == 'addr':
+        assert_true([filter_.addr_start, filter_.addr_end] ==
+                    dump['addr_range'], 'addr_range', dump)
+    elif filter_.type_ == 'target':
+        assert_true(filter_.target_idx == dump['target_idx'], 'target_idx',
+                    dump)
+    elif filter_.type_ == 'hugepage_size':
+        assert_true([filter_.min_, filter_.max_] == dump['sz_range'],
+                    'sz_range', dump)
+
 def assert_access_pattern_committed(pattern, dump):
     assert_true(dump['min_sz_region'] == pattern.size[0], 'min_sz_region',
                 dump)
@@ -111,6 +126,11 @@ def assert_scheme_committed(scheme, dump
     assert_migrate_dests_committed(scheme.dests, dump['migrate_dests'])
     assert_quota_committed(scheme.quota, dump['quota'])
     assert_watermarks_committed(scheme.watermarks, dump['wmarks'])
+    # TODO: test filters directory
+    for idx, f in enumerate(scheme.core_filters.filters):
+        assert_filter_committed(f, dump['filters'][idx])
+    for idx, f in enumerate(scheme.ops_filters.filters):
+        assert_filter_committed(f, dump['ops_filters'][idx])
 
 def main():
     kdamonds = _damon_sysfs.Kdamonds(
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

