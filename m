Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251AA2C15A8
	for <mm-commits@vger.kernel.org>; Sun,  6 Jul 2025 20:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751832043; cv=none; b=KQu2k3NjofEQe5tbVTA1vAwqcYhqQCH6HYATzEbhoS6g+CzS2iq9N+NEeCEMv/qhsNGf7CwnoDKC2uuGqIFZWpetARVaMe2sLQbTE5FDjBMWGQcopSmRfSYvIHlFx8HVp3mS5J7lFZOtemUeBTX0hguGjJ3bkuvMU34gT7I+vQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751832043; c=relaxed/simple;
	bh=2JsSTZLLr5CHjTpBI8nxxrxlklRysz01RAONoWT7Caw=;
	h=Date:To:From:Subject:Message-Id; b=nPkrPSq6YgQnqmskMBt9MdUeDeOIBIPFZUXPKQU29U/z1JW3dEaejk3rx7UjfrqGIboMR3cRavlw08luw/n/X8ztFWJrCz7GOTIEQJjt+gCKIQtg/ckywu6ZxwwhbQclfApkLc7fw4zttg98onwa+tnXkovF62DGpFHBZWU05b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CO9oKI0a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CO9oKI0a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0207C4CEF1;
	Sun,  6 Jul 2025 20:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751832042;
	bh=2JsSTZLLr5CHjTpBI8nxxrxlklRysz01RAONoWT7Caw=;
	h=Date:To:From:Subject:From;
	b=CO9oKI0apoT+MYWKVnAKgM+N8JiMNn9Fw/LtEy2Ca5bSre4v+sxtCIm7PiYmyWpcY
	 8haQxZraHKrAaohAzE3J3wjHP7fIm1RXCgg3hL/lEi17tjV2PeC/mMXnmsDWWIT8Pr
	 5x8N38TiPivi6BmoGK5qe2HCfUJpHhBFirOE8dLw=
Date: Sun, 06 Jul 2025 13:00:42 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + samples-damon-prcl-fix-boot-time-enable-crash.patch added to mm-new branch
Message-Id: <20250706200042.D0207C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: samples/damon/prcl: fix boot time enable crash
has been added to the -mm mm-new branch.  Its filename is
     samples-damon-prcl-fix-boot-time-enable-crash.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/samples-damon-prcl-fix-boot-time-enable-crash.patch

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
Subject: samples/damon/prcl: fix boot time enable crash
Date: Sun, 6 Jul 2025 12:32:03 -0700

If 'enable' parameter of the 'prcl' DAMON sample module is set at boot
time via the kernel command line, memory allocation is tried before the
slab is initialized.  As a result kernel NULL pointer dereference BUG can
happen.  Fix it by checking the initialization status.

Link: https://lkml.kernel.org/r/20250706193207.39810-3-sj@kernel.org
Fixes: 2aca254620a8 ("samples/damon: introduce a skeleton of a smaple DAMON module for proactive reclamation")
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/prcl.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/samples/damon/prcl.c~samples-damon-prcl-fix-boot-time-enable-crash
+++ a/samples/damon/prcl.c
@@ -109,6 +109,8 @@ static void damon_sample_prcl_stop(void)
 		put_pid(target_pidp);
 }
 
+static bool init_called;
+
 static int damon_sample_prcl_enable_store(
 		const char *val, const struct kernel_param *kp)
 {
@@ -122,6 +124,9 @@ static int damon_sample_prcl_enable_stor
 	if (enable == enabled)
 		return 0;
 
+	if (!init_called)
+		return 0;
+
 	if (enable) {
 		err = damon_sample_prcl_start();
 		if (err)
@@ -134,6 +139,14 @@ static int damon_sample_prcl_enable_stor
 
 static int __init damon_sample_prcl_init(void)
 {
+	int err = 0;
+
+	init_called = true;
+	if (enable) {
+		err = damon_sample_prcl_start();
+		if (err)
+			enable = false;
+	}
 	return 0;
 }
 
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

