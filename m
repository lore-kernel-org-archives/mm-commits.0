Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368705111B9
	for <mm-commits@vger.kernel.org>; Tue,  8 Sep 2026 23:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788908888; cv=none; b=ZiZS8Yz+y5BUABKlWDIZR7CbeY23nwmFWSCuVnBwlemoYsbAO1+OD8LZVepbzGt4ABYre5hSReAJ9cc/LXTEtg8hWo0ZMQTdF26cWt1FSsz0hfxfMHFs+mYHT2SiI+hBG6swfoazU5u9D06KE7KJk8BQl/ysovk/UABzOsGoW+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788908888; c=relaxed/simple;
	bh=gHz1lt/wpbw96Fddy/W4BJcNfzRTeWnNt972L4AUUAY=;
	h=Date:To:From:Subject:Message-Id; b=HVQDjNhHI2TBps9HGMmwm9/TvC2Dcngl7ssGbJ9QrBqpk6SCp9Bs5F0MOlGUQDg1zRnjvbDSzcsvg/TVp1LvTtqUdut0u8frnintQzkAP4ERf+e8OZ0Ix1MqZMBxUsXSwGiVURei141c+17ywHtOH0w/oh7MHWIZsZ19YvHVswg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BVi0IeTY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BVi0IeTY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B511F00A3A;
	Tue,  8 Sep 2026 23:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788908881;
	bh=xyUQkOeIsr1BoH/EttMwYQXkFWb+ZnIaXtkuUCpYFnM=;
	h=Date:To:From:Subject;
	b=BVi0IeTYAaApxoNVTl3PDLbQZvXGyMXP39mmnnYjSU0YDSPS7hQIUg1TvFZOJZtsv
	 w5o47/8FkGbWuJ5kdNgYod6BSk/crMXpLgBPrY57jyWqtYyRR1Is51ak//GzvWmD2+
	 kRchrbiuHHwKGgaNeDBq/8Uh5ytEGNIumPbEheUg=
Date: Tue, 08 Sep 2026 16:08:00 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-damon-sysfspy-extend-commit-assertion-function-for-probes.patch removed from -mm tree
Message-Id: <20260908230801.14B511F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/sysfs.py: extend commit assertion function for probes
has been removed from the -mm tree.  Its filename was
     selftests-damon-sysfspy-extend-commit-assertion-function-for-probes.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: selftests/damon/sysfs.py: extend commit assertion function for probes
Date: Wed, 2 Sep 2026 07:03:11 -0700

Extend DAMON sysfs testing commit assertion helper function to check
probes too.

Link: https://lore.kernel.org/20260902140313.85983-6-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.py |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/tools/testing/selftests/damon/sysfs.py~selftests-damon-sysfspy-extend-commit-assertion-function-for-probes
+++ a/tools/testing/selftests/damon/sysfs.py
@@ -178,6 +178,24 @@ def assert_monitoring_attrs_committed(at
     assert_true(dump['max_nr_regions'] == attrs.max_nr_regions,
                 'max_nr_regions', dump)
 
+def assert_damon_filters_committed(filters, dump):
+    assert_true(len(dump) == len(filters.filters), 'probe filters', dump)
+    for idx, damon_filter in enumerate(filters.filters):
+        filter_dump = dump[idx]
+        assert_true(filter_dump['type'] == damon_filter.type_, 'type',
+                    filter_dump)
+        assert_true(filter_dump['matching'] == damon_filter.matching,
+                    'matching', filter_dump)
+        assert_true(filter_dump['allow'] == damon_filter.allow, 'allow',
+                    filter_dump)
+
+def assert_probes_committed(probes, dump):
+    assert_true(len(dump) == len(probes.probes), 'probes length', dump)
+    for idx, probe in enumerate(probes.probes):
+        probe_dump = dump[idx]
+        assert_true(probe.weight == probe_dump['weight'], 'weight', probe_dump)
+        assert_damon_filters_committed(probe.filters, probe_dump['filters'])
+
 def assert_monitoring_target_committed(target, dump):
     # target.pid is the pid "number", while dump['pid'] is 'struct pid'
     # pointer, and hence cannot be compared.
@@ -196,6 +214,7 @@ def assert_ctx_committed(ctx, dump):
             }
     assert_true(dump['ops']['id'] == ops_val[ctx.ops], 'ops_id', dump)
     assert_monitoring_attrs_committed(ctx.monitoring_attrs, dump['attrs'])
+    assert_probes_committed(ctx.monitoring_attrs.probes, dump['probes'])
     assert_monitoring_targets_committed(ctx.targets, dump['adaptive_targets'])
     assert_schemes_committed(ctx.schemes, dump['schemes'])
     assert_true(dump['pause'] == ctx.pause, 'pause', dump)
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-vaddr-avoid-hw-driven-pte-updates-during-damon_hugetlb_mkold.patch
mm-damon-core-skip-applying-scheme-if-region-split-for-quota-fails.patch
mm-damon-paddr-respect-folio-end-for-damos_stat.patch
mm-damon-paddr-respect-folio-end-for-damos-actions-except-stat.patch
mm-damon-vaddr-respect-folio-end-for-damos_stat.patch
mm-damon-vaddr-respect-folio-end-for-damos_migrate_hotcold.patch
mm-damon-core-handle-extreme-memory-state-in-damon_get_node_mem_bp.patch
mm-damon-core-handle-extreme-memory-state-in-get_node_memcg_used_bp.patch
mm-damon-core-handle-extreme-memory-state-in-get_in_active_mem_bp.patch
mm-damon-core-introduce-damon_filter_type_pgidle_unset.patch
mm-damon-paddr-support-pgidle_unset-probe-filter-type.patch
mm-damon-sysfs-support-pgidle_unset-probe-filter-type.patch
docs-mm-damon-design-document-pgidle_unset-probe-filter-type.patch
mm-damon-core-introduce-damon_prep-struct.patch
mm-damon-core-commit-preps.patch
mm-damon-core-introduce-damon_operations-prep_probes.patch
mm-damon-paddr-support-damon_prep.patch
mm-damon-sysfs-implement-preps-directory.patch
mm-damon-sysfs-implement-preps-nr_preps-file.patch
mm-damon-sysfs-create-directories-for-nr_preps-writes.patch
mm-damon-sysfs-implement-prep_action-file.patch
mm-damon-sysfs-pass-preps-to-damon-core.patch
selftests-damon-sysfssh-test-probe-prep-sysfs-files.patch
docs-mm-damon-design-document-probe-preps.patch
docs-admin-guide-mm-damon-usage-document-probe-preps-sysfs-files.patch
docs-abi-damon-document-probe-prep-sysfs-files.patch
mm-damon-tests-core-kunit-test-committing-psi-goal-to-psi-goal.patch
mm-damon-core-handle-uninitialized-damos_quota_goal-last_psi_total.patch
mm-damon-core-copy-nid-for-eligible_mem_bp-damos-quota-goal-commit.patch
mm-damon-sysfs-set-next-refresh-jiffies-per-sysfs-context.patch
selftests-damon-sysfspy-test-damon-probes.patch
mm-damon-core-use-damon_nr_samples_per_aggr-for-max-merge-threshold.patch
mm-damon-core-remove-debug-messages.patch
mm-damon-core-remove-debug-messages-fix.patch
mm-damon-vaddr-remove-a-debug-message.patch
mm-damon-core-validate-number-of-probes-in-valid_probe_params.patch
mm-damon-sysfs-remove-probes-number-validation.patch
mm-damon-tests-core-kunit-extend-set_regions-test-for-error-case.patch
mm-damon-tests-core-kunit-test-=0-size-damon_set_regions-inputs.patch
mm-damon-tests-core-kunit-test-overlapping-ranges-for-set_regions.patch
mm-damon-tests-core-kunit-test-damon_nr_samples_per_aggr.patch
selftests-damon-sysfssh-test-hugepage_mem_bp-quota-goal.patch
docs-mm-damon-maintainer-profile-update-ai-review-for-sashiko-replies.patch
docs-abi-damon-recommend-subsystem-doc-instead-of-admin-guide.patch
mm-damon-core-error-damos_commit_quota_goal-for-zero-target_value.patch
revert-mm-damon-lru_sort-error-out-for-10000-active_mem_bp.patch
revert-samples-damon-mtier-error-out-for-zero-quota-goal-target-values.patch
mm-damon-core-handle-null-ctx-parameter-in-damon_call.patch
mm-damon-core-set-ctx-call_controls_obsolete-in-damon_new_ctx.patch
mm-damon-reclaim-remove-unnecessary-damon_call-param-validation.patch
mm-damon-lru_sort-remove-unnecessary-damon_call-param-validation.patch

