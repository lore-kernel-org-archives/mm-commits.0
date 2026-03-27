Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677E27261C;
	Fri, 27 Mar 2026 00:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774573171; cv=none; b=sXWcvBXH87HFC0N1FTcG8mxLVaXwlDeZLbbFZLLlEIz6hn0vqdAMb5GxLxSyAJCke4uOhzLQTu2AN4mRg5GheS7qRXmbbL/VOF8mnVlhgGSTujUmABU2HPUCuWNSZoBN0OCg4rus5E5G5t+5cZnu54Jmgz4/8ZYLmXD/WgeZEbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774573171; c=relaxed/simple;
	bh=7AQVPZU1kUZly34CyGmu2dCnKE901wXCVHYnWIGmgeU=;
	h=Date:To:From:Subject:Message-Id; b=lth7NZhbzckKVv95rJk+QkhZIgS13o+f9SVk8ixaZzXd+JTlj72CtNJtCmZ56NqLmg50861w/nLyCj6SqAng0NSa47MOTDx1AOssiZ/9hTKXPV8LH98nuBWpJeoaBO1aMG6H2rGiAXTcqk3WhDqPWaIqbkghCs/u8PBAA7695Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gM/P2V+L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gM/P2V+L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB256C116C6;
	Fri, 27 Mar 2026 00:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774573171;
	bh=7AQVPZU1kUZly34CyGmu2dCnKE901wXCVHYnWIGmgeU=;
	h=Date:To:From:Subject:From;
	b=gM/P2V+LJBUI9+wTQvNUGNfn/yIqyW0RpVu8oESP1TF9d1ctFmATpcqu040xw3+Ig
	 o/OCSpdwD8ii944ec4qsNeZTqcAs732VYuRveIe1stLwXBwsswPjVINJk6x5G8EFvD
	 dBpQZ2Xp+jgGgZxXlELpIF62B2ZxxhLvTW1NB2dE=
Date: Thu, 26 Mar 2026 17:59:29 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch added to mm-hotfixes-unstable branch
Message-Id: <20260327005930.EB256C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: dealloc repeat_call_control if damon_call() fails
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: dealloc repeat_call_control if damon_call() fails
Date: Thu, 26 Mar 2026 17:32:22 -0700

damon_call() for repeat_call_control of DAMON_SYSFS could fail if somehow
the kdamond is stopped before the damon_call().  It could happen, for
example, when te damon context was made for monitroing of a virtual
address processes, and the process is terminated immediately, before the
damon_call() invocation.  In the case, the dyanmically allocated
repeat_call_control is not deallocated and leaked.

Fix the leak by deallocating the repeat_call_control under the
damon_call() failure.

This issue is discovered by sashiko [1].

Link: https://lkml.kernel.org/r/20260327003224.55752-1-sj@kernel.org
Link: https://lore.kernel.org/20260320020630.962-1-sj@kernel.org [1]
Fixes: 04a06b139ec0 ("mm/damon/sysfs: use dynamically allocated repeat mode damon_call_control")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.17+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails
+++ a/mm/damon/sysfs.c
@@ -1670,7 +1670,8 @@ static int damon_sysfs_turn_damon_on(str
 	repeat_call_control->data = kdamond;
 	repeat_call_control->repeat = true;
 	repeat_call_control->dealloc_on_cancel = true;
-	damon_call(ctx, repeat_call_control);
+	if (damon_call(ctx, repeat_call_control))
+		kfree(repeat_call_control);
 	return err;
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch
mm-damon-add-config_damon_debug_sanity.patch
mm-damon-core-add-damon_new_region-debug_sanity-check.patch
mm-damon-core-add-damon_del_region-debug_sanity-check.patch
mm-damon-core-add-damon_nr_regions-debug_sanity-check.patch
mm-damon-core-add-damon_merge_two_regions-debug_sanity-check.patch
mm-damon-core-add-damon_merge_regions_of-debug_sanity-check.patch
mm-damon-core-add-damon_split_region_at-debug_sanity-check.patch
mm-damon-core-add-damon_reset_aggregated-debug_sanity-check.patch
mm-damon-tests-kunitconifg-enable-damon_debug_sanity.patch
selftests-damon-config-enable-damon_debug_sanity.patch
mm-damon-tests-core-kunit-add-a-test-for-damon_commit_ctx.patch
docs-mm-damon-design-document-the-power-of-two-limitation-for-addr_unit.patch
mm-damon-core-remove-damos_set_next_apply_sis-duplicates.patch
mm-damon-core-use-time_before-for-next_apply_sis.patch
mm-damon-core-use-time_after_eq-in-kdamond_fn.patch
mm-damon-core-use-mult_frac.patch
mm-damon-tests-core-kunit-add-a-test-for-damon_is_last_region.patch
mm-damon-core-clarify-damon_set_attrs-usages.patch
mm-damon-document-non-zero-length-damon_region-assumption.patch
docs-admin-guide-mm-damn-lru_sort-fix-intervals-autotune-parameter-name.patch
docs-mm-damon-maintainer-profile-use-flexible-review-cadence.patch
docs-mm-damon-index-fix-typo-autoamted-automated.patch
mm-damon-core-introduce-damos_quota_goal_tuner.patch
mm-damon-core-allow-quota-goals-set-zero-effective-size-quota.patch
mm-damon-core-introduce-damos_quota_goal_tuner_temporal.patch
mm-damon-sysfs-schemes-implement-quotas-goal_tuner-file.patch
docs-mm-damon-design-document-the-goal-based-quota-tuner-selections.patch
docs-admin-guide-mm-damon-usage-document-goal_tuner-sysfs-file.patch
docs-abi-damon-update-for-goal_tuner.patch
mm-damon-tests-core-kunit-test-goal_tuner-commit.patch
selftests-damon-_damon_sysfs-support-goal_tuner-setup.patch
selftests-damon-drgn_dump_damon_status-support-quota-goal_tuner-dumping.patch
selftests-damon-sysfspy-test-goal_tuner-commit.patch
mm-damon-core-fix-wrong-end-address-assignment-on-walk_system_ram.patch
mm-damon-core-support-addr_unit-on-damon_find_biggest_system_ram.patch
mm-damon-core-receive-addr_unit-on-damon_set_region_biggest_system_ram_default.patch
mm-damon-core-receive-addr_unit-on-damon_set_region_biggest_system_ram_default-fix.patch
mm-damon-reclaim-respect-addr_unit-on-default-monitoring-region-setup.patch
mm-damon-lru_sort-respect-addr_unit-on-default-monitoring-region-setup.patch

