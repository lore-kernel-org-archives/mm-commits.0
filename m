Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2519C2C08DF;
	Sun,  6 Jul 2025 20:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751832041; cv=none; b=Ah9vCKVmqbB9U1T93GpnEVH2WFNzTy6ZB6asXQ5nkYXupS33AfykU0Ts0l57zycvM5HhXWQIutNLcv/dFaIfQj8aXFVFNfI8Dl9WJ5BKOQiJ0n5xuQxmjrPJ4BC+CdPesppv9iqf01l3Ch5awnrncHXQEQN8km/Oa0bzjtD4XeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751832041; c=relaxed/simple;
	bh=quY6iFtjPlFs/piKsrcVjoR2RznJ9rLCDVIZs0ujkrc=;
	h=Date:To:From:Subject:Message-Id; b=hjPmHSMPPUo46U9Tdp1Tybs7RkGrORBzzJnRD150NvlQptYNgaGgsJocAeVjwPsUuRKuqk344u1B9G5fSZpDNCBz8nu3t0skeg24IfzU5tQ4Shb1CNcThfqzOgqdJu6HM0yb7t/Kj3kLC2rKQmRtQKyHaPlBjvxNFTqOeAQ1Bek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=udg1Hdbv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="udg1Hdbv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2612C4CEED;
	Sun,  6 Jul 2025 20:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751832040;
	bh=quY6iFtjPlFs/piKsrcVjoR2RznJ9rLCDVIZs0ujkrc=;
	h=Date:To:From:Subject:From;
	b=udg1Hdbvro+mOgcyETugbMnsv5khHGRM08Sq5n8U3fqKg0Svq8pO35C3WGAYlZhh2
	 NZRHlWzkJVWi2BSrdAELf87FJFQDGa2CUhzo5qUvr9nT0LUzj0xDY9RFMJdlTBCBjn
	 GLchlnCSeC0AHeuLrj53JjMaXgjC8Lbzq6cwk41I=
Date: Sun, 06 Jul 2025 13:00:40 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + samples-damon-wsse-fix-boot-time-enable-handling.patch added to mm-new branch
Message-Id: <20250706200040.C2612C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: samples/damon/wsse: fix boot time enable handling
has been added to the -mm mm-new branch.  Its filename is
     samples-damon-wsse-fix-boot-time-enable-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/samples-damon-wsse-fix-boot-time-enable-handling.patch

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
Subject: samples/damon/wsse: fix boot time enable handling
Date: Sun, 6 Jul 2025 12:32:02 -0700

Patch series "mm/damon: fix misc bugs in DAMON modules".

From manual code review, I found below bugs in DAMON modules.

DAMON sample modules crash if those are enabled at boot time, via kernel
command line.  A similar issue was found and fixed on DAMON non-sample
modules in the past, but we didn't check that for sample modules.

DAMON non-sample modules are not setting 'enabled' parameters accordingly
when real enabling is failed.  Honggyu found and fixed[1] this type of
bugs in DAMON sample modules, and my inspection was motivated by the great
work.  Kudos to Honggyu.

Finally, DAMON_RECLIAM is mistakenly losing scheme internal status due to
misuse of damon_commit_ctx().  DAMON_LRU_SORT has a similar misuse, but
fortunately it is not causing real status loss.

Fix the bugs.  Since these are similar patterns of bugs that were found in
the past, it would be better to add tests or refactor the code, in future.


This patch (of 6):

If 'enable' parameter of the 'wsse' DAMON sample module is set at boot
time via the kernel command line, memory allocation is tried before the
slab is initialized.  As a result kernel NULL pointer dereference BUG can
happen.  Fix it by checking the initialization status.

Link: https://lkml.kernel.org/r/20250706193207.39810-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250706193207.39810-2-sj@kernel.org
Link: https://lore.kernel.org/20250702000205.1921-1-honggyu.kim@sk.com [1]
Fixes: b757c6cfc696 ("samples/damon/wsse: start and stop DAMON as the user requests")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/wsse.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/samples/damon/wsse.c~samples-damon-wsse-fix-boot-time-enable-handling
+++ a/samples/damon/wsse.c
@@ -89,6 +89,8 @@ static void damon_sample_wsse_stop(void)
 		put_pid(target_pidp);
 }
 
+static bool init_called;
+
 static int damon_sample_wsse_enable_store(
 		const char *val, const struct kernel_param *kp)
 {
@@ -103,6 +105,9 @@ static int damon_sample_wsse_enable_stor
 		return 0;
 
 	if (enable) {
+		if (!init_called)
+			return 0;
+
 		err = damon_sample_wsse_start();
 		if (err)
 			enable = false;
@@ -114,7 +119,15 @@ static int damon_sample_wsse_enable_stor
 
 static int __init damon_sample_wsse_init(void)
 {
-	return 0;
+	int err = 0;
+
+	init_called = true;
+	if (enable) {
+		err = damon_sample_wsse_start();
+		if (err)
+			enable = false;
+	}
+	return err;
 }
 
 module_init(damon_sample_wsse_init);
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
mm-damon-add-trace-event-for-auto-tuned-monitoring-intervals.patch
mm-damon-add-trace-event-for-effective-size-quota.patch
samples-damon-wsse-fix-boot-time-enable-handling.patch
samples-damon-prcl-fix-boot-time-enable-crash.patch
samples-damon-mtier-support-boot-time-enable-setup.patch
mm-damon-reclaim-reset-enabled-when-damon-start-failed.patch
mm-damon-lru_sort-reset-enabled-when-damon-start-failed.patch
mm-damon-reclaim-use-parameter-context-correctly.patch

