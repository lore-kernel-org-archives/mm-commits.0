Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5C93F8EA2
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525370; cv=none; b=CpMsEwzt0kdFvl2crTh5K7p7Uk8p17PpsxzsXZZi9hKqCHzSzf/STJM++Fbb6El8TxzM14IwwIJXZQdDjqp6q7x3c/ltkmuYg76TlnUAWJ6ec2mUD/7xYh6aiynCOiaUBdoGQAeTcnF3KzO83G/ZghlBYU1RWCI45S532mnluLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525370; c=relaxed/simple;
	bh=2CiA3KKyB4Bj/8LOiPGbpBSiejqirf5KNvcp+ZedX1o=;
	h=Date:To:From:Subject:Message-Id; b=i0hia2DTC/j6AmU4xeZ1QXMW5SXeRciq2UMrgNJkLeWqq3M9ezgk/dnnnvfA6/AUaIM/jEwADpNISdgqGiSz8EJBp9JYjxmRmAv+JlbZYkNzIuW1/ZUHA9Wl0WbB6D04dpF2HFUgN7BnjGYiDZixysSiypo6ZHKBrv+v/tOF+OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a8FrH1+g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a8FrH1+g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B07C01F00893;
	Fri,  9 Oct 2026 05:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525368;
	bh=YVuRQR65A/TOJPQUd0HNs30IlMg//lS5nmygjf03UIk=;
	h=Date:To:From:Subject;
	b=a8FrH1+gTOgcKY+y0ZGraKuMqNaYCSkL+Z9rKSOHbNr6519/s17uL51lbAHOzck6k
	 S0yST3vrJlE4bg5PVtMWrzrUJq7o36sqJrII916ONKJTEHxl52kD/ifFwPVTpOBOPM
	 beeJr4Q5QXcg/eYAqKdLuvwloJFMiGul9kwvjRJM=
Date: Thu, 08 Oct 2026 22:56:08 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kunwu.chan@gmail.com,david@kernel.org,davidgow@davidgow.net,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-validate-number-of-probes-in-valid_probe_params.patch removed from -mm tree
Message-Id: <20261009055608.B07C01F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: validate number of probes in valid_probe_params()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-validate-number-of-probes-in-valid_probe_params.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: validate number of probes in valid_probe_params()
Date: Tue, 1 Sep 2026 22:47:37 -0700

Each DAMON context is allowed to have only up to DAMON_MAX_PROBES probes. 
The central place for validating DAMON probe parameters,
damon_valid_probe_params(), is not validating the upper limit, though.  Do
the validation.

Link: https://lore.kernel.org/20260902054747.99370-5-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 mm/damon/core.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-validate-number-of-probes-in-valid_probe_params
+++ a/mm/damon/core.c
@@ -1419,6 +1419,13 @@ static bool damon_valid_probe_params(str
 	unsigned char max_probe_hits;
 	struct damon_probe *probe;
 	unsigned int wsum, wsum_to_add;
+	int nr_probes;
+
+	nr_probes = 0;
+	damon_for_each_probe(probe, ctx)
+		nr_probes++;
+	if (nr_probes > DAMON_MAX_PROBES)
+		return false;
 
 	if (!damon_has_probe_weights(ctx))
 		return true;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-read-sysfs_filter-addr_range-only-once.patch
mm-damon-sysfs-schemes-read-sysfs_filter-sz_range-only-once.patch
mm-damon-core-return-an-error-from-damos_commit_filter_arg.patch
mm-damon-core-disallow-max-min-damos-filter-range-arguments-commit.patch
mm-damon-sysfs-schemes-drop-centralized-filter-range-arg-validations.patch
mm-damon-sysfs-schemes-use-switch-case-in-add_scheme_filters.patch
mm-damon-core-kunit-extend-damos_commit_filter_for-for-wrong-input.patch
mm-damon-core-kunit-test-invalid-damos-filter-commits.patch
mm-damon-api-introduce-damon_filter_type_hugepage_size.patch
mm-damon-core-commit-hugepage_size-type-damon-filter.patch
mm-damon-ops-common-support-hugepage_size-damon-filter-matching.patch
mm-damon-sysfs-add-minmax-files-under-probe-filter-directory.patch
mm-damon-sysfs-support-hugepage_size-probe-filter.patch
docs-mm-damon-design-update-for-hugepage_size-probe-filter.patch
docs-admin-guide-mm-damon-usage-update-for-hugepage_size.patch
docs-abi-damon-update-for-hugepage_size-probe-filter.patch
mm-damon-api-remove-nr_damos_filter_types.patch
mm-damon-core-use-abs_diff-in-damon_feed_loop_next_input.patch
mm-damon-core-use-mult_frac-in-damon_feed_loop_next_input.patch
mm-damon-core-set-damon_ctx-walk_control_obsolete-in-damon_new_ctx.patch
mm-damon-core-document-damon_call-damon_start-race-hang-issue.patch
mm-damon-paddr-remove-pa-parameter-from-damon_pa_filter_pass.patch
mm-damon-tests-core-kunit-test-eligible_mem_bp-commitment.patch
mm-damon-tests-core-kunit-add-probe_hits_wsum-damos-filter-commit-test.patch
selftests-damon-sysfs_memcg_path_leak-fail-only-for-real-damon-leak.patch
docs-mm-damon-design-clarify-bp-is-basis-point.patch
mm-damon-core-introduce-damos_quota_goal-complement.patch
mm-damon-core-add-complement-argument-to-damos_new_quota_goal.patch
mm-damon-sysfs-schemes-support-quota-goal-complement-flag.patch
mm-damon-tests-core-kunit-test-quota_goal-complement-commit.patch
selftests-damon-sysfssh-test-quota-goal-complement-flag-file.patch
docs-mm-damon-design-document-damos-quota-goal-complement-flag.patch
docs-admin-guide-mm-damon-usage-update-for-quota-goal-complement-file.patch
docs-abi-damon-update-for-quota-goal-metric-complement-sysfs-file.patch

