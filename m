Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D2E11CA0
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 01:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724807258; cv=none; b=pctU1RSnlRoiHuUCgez3oYiqPvANnulskMy4CL3UhHBUmZ8rk+SJgNNoey7RCixD8sEXivfI2vZOFHLisJTVgxaseI8FiTjdwY9CRUQzNDc8Mi0SJMGRKWIFNKSYU2f3bvP9SndJfSiEJMEZwj4MrpZMHXxnkzJfU6NsAaBxkNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724807258; c=relaxed/simple;
	bh=iMYmH5iqghnETlxC8GZfdrmEFX/9RCzXA8Qeu6jLb7A=;
	h=Date:To:From:Subject:Message-Id; b=Cp+yBzbr591kAYYt3QIMDITQh0VFK+5ajaxZE7D36Zm2ePcoOlru8HGdqSt2myjaMRNGZz92eXgVQkyLNkm71kU1/2UUiwDcxBNzKfXE1Mg7HQMCxp4rBuz0iCrEqkgaZaTQ8O/3HC/+pm9m8mmJ7+ugh5FAcWgDAzicGuWCJmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jHzIjKQE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jHzIjKQE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0A4CC4AF48;
	Wed, 28 Aug 2024 01:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724807257;
	bh=iMYmH5iqghnETlxC8GZfdrmEFX/9RCzXA8Qeu6jLb7A=;
	h=Date:To:From:Subject:From;
	b=jHzIjKQEnJHue9BNAyD5xqrZYMpYS+NR47OE5aKLtMxcp06XKNk0+e51h2QhJdfNa
	 QXyYKLQ3TkCB0Jegh/M9Vz1yNHgHsZyLL9oOV3gWFySJ4QakxXTNZ7qTwI67mkT4Ge
	 6NXjvj+nOMXd6htmqfeq1AHdDSgWn361mL1sOIcE=
Date: Tue, 27 Aug 2024 18:07:37 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-intorduce-per-context-region-priorities-histogram-buffer.patch added to mm-unstable branch
Message-Id: <20240828010737.B0A4CC4AF48@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: introduce per-context region priorities histogram buffer
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-intorduce-per-context-region-priorities-histogram-buffer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-intorduce-per-context-region-priorities-histogram-buffer.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: mm/damon/core: introduce per-context region priorities histogram buffer
Date: Sun, 25 Aug 2024 21:23:20 -0700

Patch series "replace per-quota region priorities histogram buffer with
per-context one".

Each DAMOS quota (struct damos_quota) maintains a histogram for total
regions size per its prioritization score.  DAMOS calcultes minimum
prioritization score of regions that are ok to apply the DAMOS action to
while respecting the quota.  The histogram is constructed only for the
calculation of the minimum score in damos_adjust_quota() for each quota
which called by kdamond_fn().

Hence, there is no real reason to have per-quota histogram.  Only
per-kdamond histogram is needed, since parallel kdamonds could have races
otherwise.  The current implementation is only wasting the memory, and can
easily cause unintended stack usage[1].

So, introducing a per-kdamond histogram and replacing the per-quota one
with it would be the right solution for the issue.  However, supporting
multiple DAMON contexts per kdamond is still an ongoing work[2] without a
clear estimated time of arrival.  Meanwhile, per-context histogram could
be an effective and straightforward solution having no blocker.  Let's fix
the problem first in the way.


This patch (of 4):

Introduce per-context buffer for region priority scores-total size
histogram.  Same to the per-quota one (->histogram of struct damos_quota),
the new buffer is hidden from DAMON API users by being defined as a
private field of DAMON context structure.  It is dynamically allocated and
de-allocated at the beginning and ending of the execution of the kdamond
by kdamond_fn() itself.

[1] commit 0742cadf5e4c ("mm/damon/lru_sort: adjust local variable to dynamic allocation")
[2] https://lore.kernel.org/20240531122320.909060-1-yorha.op@gmail.com

Link: https://lkml.kernel.org/r/20240826042323.87025-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20240826042323.87025-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    2 ++
 mm/damon/core.c       |    5 +++++
 2 files changed, 7 insertions(+)

--- a/include/linux/damon.h~mm-damon-core-intorduce-per-context-region-priorities-histogram-buffer
+++ a/include/linux/damon.h
@@ -630,6 +630,8 @@ struct damon_ctx {
 	unsigned long next_ops_update_sis;
 	/* for waiting until the execution of the kdamond_fn is started */
 	struct completion kdamond_started;
+	/* for scheme quotas prioritization */
+	unsigned long *regions_score_histogram;
 
 /* public: */
 	struct task_struct *kdamond;
--- a/mm/damon/core.c~mm-damon-core-intorduce-per-context-region-priorities-histogram-buffer
+++ a/mm/damon/core.c
@@ -1957,6 +1957,10 @@ static int kdamond_fn(void *data)
 		ctx->ops.init(ctx);
 	if (ctx->callback.before_start && ctx->callback.before_start(ctx))
 		goto done;
+	ctx->regions_score_histogram = kmalloc_array(DAMOS_MAX_SCORE + 1,
+			sizeof(*ctx->regions_score_histogram), GFP_KERNEL);
+	if (!ctx->regions_score_histogram)
+		goto done;
 
 	sz_limit = damon_region_sz_limit(ctx);
 
@@ -2034,6 +2038,7 @@ done:
 		ctx->callback.before_terminate(ctx);
 	if (ctx->ops.cleanup)
 		ctx->ops.cleanup(ctx);
+	kfree(ctx->regions_score_histogram);
 
 	pr_debug("kdamond (%d) finishes\n", current->pid);
 	mutex_lock(&ctx->kdamond_lock);
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-add-access_memory_even-to-gitignore.patch
selftests-damon-cleanup-__pycache__-with-make-clean.patch
selftests-damon-add-execute-permissions-to-test-scripts.patch
mm-damon-core-test-test-only-vaddr-case-on-ops-registration-test.patch
mm-damon-core-test-fix-damon_test_ops_registration-for-damon_vaddr-unset-case.patch
mm-damon-dbgfs-test-skip-dbgfs_set_targets-test-if-paddr-is-not-registered.patch
mm-damon-dbgfs-test-skip-dbgfs_set_init_regions-test-if-paddr-is-not-registered.patch
mm-damon-move-kunit-tests-to-tests-subdirectory-with-_kunit-suffix.patch
mm-damon-tests-add-kunitconfig-file-for-damon-kunit-tests.patch
mm-damon-core-intorduce-per-context-region-priorities-histogram-buffer.patch
mm-damon-core-replace-per-quota-regions-priority-histogram-buffer-usage-with-per-context-one.patch
mm-damon-core-remove-per-scheme-region-priority-histogram-buffer.patch
revert-mm-damon-lru_sort-adjust-local-variable-to-dynamic-allocation.patch

