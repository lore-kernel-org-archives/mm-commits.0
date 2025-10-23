Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F30B72629
	for <mm-commits@vger.kernel.org>; Thu, 23 Oct 2025 23:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761261594; cv=none; b=UmMLow/0ZqMZLs5IYJrxa1bzGNWw0m0K17PXk/rmCVXUQbPThW1NyvZs/39TB/uZnYO0EC6VRFls7qvxXEaWc41xgKUSOLNTAdGTiLeqd78LeDJsHjGmmCvfCq1SOWlrF5KN8wZOYq5F0LfcC4YQ6vxtJjGt1wIzoplNu4c7w+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761261594; c=relaxed/simple;
	bh=NCwQQ9XwE79oWrtkeKvzREETA+qIKy/PhwTkY93kf9Q=;
	h=Date:To:From:Subject:Message-Id; b=pG3DUgX2bqgh2FhAeItt8MlAb+R/3TrYD6xa8WVvmxRrzq0ilYqnx0wOq1XHGoWsEyfWiGvr1V+PkqRl/kcNDgziRM6qcWhQ1LlxJL92ARnflQ7apf5YHIxjha+o9F5+0kmj3a50cEz025b6+E4Uj87j0yxL5XfsG4Sm9uFxtZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LlsE7khZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LlsE7khZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94A1DC4CEE7;
	Thu, 23 Oct 2025 23:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761261592;
	bh=NCwQQ9XwE79oWrtkeKvzREETA+qIKy/PhwTkY93kf9Q=;
	h=Date:To:From:Subject:From;
	b=LlsE7khZFzPwnAs+TFXcmmNU0DR890Z2pvVzd75Ashb3cbkHTl/qmwQ2uJheeV9xY
	 eobBGPBBb6go/kWuvUiIY6gJh7x5S85ib54qz6AAY+wdHVyd/3lSFhh/OsNcAdJl5c
	 w93aS8WQGSqzpTObbR9MjmZrFo5X9J8EduyDSegI=
Date: Thu, 23 Oct 2025 16:19:52 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,corbet@lwn.net,bijan311@gmail.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sysfspy-extend-assert_ctx_committed-for-monitoring-targets.patch added to mm-new branch
Message-Id: <20251023231952.94A1DC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sysfs.py: extend assert_ctx_committed() for monitoring targets
has been added to the -mm mm-new branch.  Its filename is
     sysfspy-extend-assert_ctx_committed-for-monitoring-targets.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sysfspy-extend-assert_ctx_committed-for-monitoring-targets.patch

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
Subject: sysfs.py: extend assert_ctx_committed() for monitoring targets
Date: Wed, 22 Oct 2025 18:25:32 -0700

assert_ctx_committed() is not asserting monitoring targets commitment,
since all existing callers of the function assume no target changes. 
Extend it for future usage.

Link: https://lkml.kernel.org/r/20251023012535.69625-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Bijan Tabatabai <bijan311@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.py |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/tools/testing/selftests/damon/sysfs.py~sysfspy-extend-assert_ctx_committed-for-monitoring-targets
+++ a/tools/testing/selftests/damon/sysfs.py
@@ -164,6 +164,16 @@ def assert_monitoring_attrs_committed(at
     assert_true(dump['max_nr_regions'] == attrs.max_nr_regions,
                 'max_nr_regions', dump)
 
+def assert_monitoring_target_committed(target, dump):
+    # target.pid is the pid "number", while dump['pid'] is 'struct pid'
+    # pointer, and hence cannot be compared.
+    assert_true(dump['obsolete'] == target.obsolete, 'target obsolete', dump)
+
+def assert_monitoring_targets_committed(targets, dump):
+    assert_true(len(targets) == len(dump), 'len_targets', dump)
+    for idx, target in enumerate(targets):
+        assert_monitoring_target_committed(target, dump[idx])
+
 def assert_ctx_committed(ctx, dump):
     ops_val = {
             'vaddr': 0,
@@ -172,6 +182,7 @@ def assert_ctx_committed(ctx, dump):
             }
     assert_true(dump['ops']['id'] == ops_val[ctx.ops], 'ops_id', dump)
     assert_monitoring_attrs_committed(ctx.monitoring_attrs, dump['attrs'])
+    assert_monitoring_targets_committed(ctx.targets, dump['adaptive_targets'])
     assert_schemes_committed(ctx.schemes, dump['schemes'])
 
 def assert_ctxs_committed(ctxs, dump):
_

Patches currently in -mm which might be from sj@kernel.org are

mm-zswap-remove-unnecessary-dlen-writes-for-incompressible-pages.patch
mm-zswap-fix-typos-s-zwap-zswap.patch
mm-zswap-s-red-black-tree-xarray.patch
docs-admin-guide-mm-zswap-s-red-black-tree-xarray.patch
mm-damon-document-damos_quota_goal-nid-use-case.patch
mm-damon-add-damos-quota-goal-type-for-per-memcg-per-node-memory-usage.patch
mm-damon-core-implement-damos_quota_node_memcg_used_bp.patch
mm-damon-sysfs-schemes-implement-path-file-under-quota-goal-directory.patch
mm-damon-sysfs-schemes-support-damos_quota_node_memcg_used_bp.patch
mm-damon-core-add-damos-quota-gaol-metric-for-per-memcg-per-numa-free-memory.patch
mm-damon-sysfs-schemes-support-damos_quota_node_memcg_free_bp.patch
docs-mm-damon-design-document-damos_quota_node_memcg_usedfree_bp.patch
docs-admin-guide-mm-damon-usage-document-damos-quota-goal-path-file.patch
docs-abi-damon-document-damos-quota-goal-path-file.patch
mm-damon-core-add-damon_target-obsolete-for-pin-point-removal.patch
mm-damon-sysfs-test-commit-input-against-realistic-destination.patch
mm-damon-sysfs-implement-obsolete_target-file.patch
docs-admin-guide-mm-damon-usage-document-obsolete_target-file.patch
docs-abi-damon-document-obsolete_target-sysfs-file.patch
selftests-damon-_damon_sysfs-support-obsolete_target-file.patch
drgn_dump_damon_status-dump-damon_target-obsolete.patch
sysfspy-extend-assert_ctx_committed-for-monitoring-targets.patch
selftests-damon-sysfs-add-obsolete_target-test.patch

