Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8338485516
	for <mm-commits@vger.kernel.org>; Wed,  2 Sep 2026 20:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788381039; cv=none; b=jC7xqpyWhbvuk5F9bICJX6pJSj/eYdSqSuePUjcdIjSLO+o5yk+6yHAUgzA3oz2m0ss4fU0z9X586vU/JfNtXr4m7OgT10zjJ6qnPmHCUdUj9D+RQls70lKnJiZmcxkhzLh/e48TujkYtvyMR1le4zW+iG5owCHqDCAm2X4dOvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788381039; c=relaxed/simple;
	bh=KSrGfZiu5SwpfCIRbfjvQbDhQhK8ZFS2/8DFwetcA9w=;
	h=Date:To:From:Subject:Message-Id; b=GEmfQBtXQ9qVojSLs7yjVKwkShf+EcXIzdTfwbWQEhLYVIq1lxGtxQPtrhTMkU5xxGwhIx0mr7SL3kGxkEkD07WtaitzfU9M4M7Vq+9nXbN1TrSIpGl7iYZwXgaq4Igoly5af/VJgA2/qMNdbKbbYulefQQrHrVQIeRf7RfWfBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e1IQzfyp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e1IQzfyp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7331F000E9;
	Wed,  2 Sep 2026 20:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788381037;
	bh=yvHv5jtg4nvxeKNQ64bw2XKj3n1gu/yRJ5lBlAdv4Ws=;
	h=Date:To:From:Subject;
	b=e1IQzfypwoq4OYdjxJhaCKJiZ9Lj8ca0sa3IZuWu/eF9uIHaouOTHy0Lqq7+SOG5c
	 PQhEf2y4iq2yttmDVJS8N7Vc0e2JUTNguxrcbSHTvMuvpzVFn97+fslSNfykZ7UviU
	 4l1q/AxCtl1RCq6xJrOGlG90DlsuT2CBSrK5Ikm4=
Date: Wed, 02 Sep 2026 13:30:36 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@davidgow.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-sysfspy-extend-commit-assertion-function-for-probes.patch added to mm-new branch
Message-Id: <20260902203037.3E7331F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/sysfs.py: extend commit assertion function for probes
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-sysfspy-extend-commit-assertion-function-for-probes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-sysfspy-extend-commit-assertion-function-for-probes.patch

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
mm-damon-tests-core-kunit-test-damon_commit_filter.patch
mm-damon-tests-core-kunit-add-damon_commit_probes-test.patch
selftests-damon-_damon_sysfs-implement-damonprobes.patch
selftests-damon-drgn_dump_damon_status-dump-probes.patch
selftests-damon-sysfspy-extend-commit-assertion-function-for-probes.patch
selftests-damon-sysfspy-test-damon-probes.patch

