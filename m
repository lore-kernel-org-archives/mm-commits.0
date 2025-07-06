Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A841846F
	for <mm-commits@vger.kernel.org>; Sun,  6 Jul 2025 21:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751838590; cv=none; b=LGa5iYgzxJcOVtS+Gi1BlobNtl499bb/bomLePZ2oxmpcPhAsWF51Pk6+VMTeuLPGXbj/4I8cu9Z+FBfc1Qlu2WCStWHjOw4U2YiWmo7x5olhp/QYtStitU0NY7ckM1xX3itkfix0M6Vvet+OeB27oUXp7ff7OcLeV6M5E3FkDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751838590; c=relaxed/simple;
	bh=Yx4mgiEfSU/LaE7CDAlNCKJFiXXK6BiaOxPxhGlhQUs=;
	h=Date:To:From:Subject:Message-Id; b=pj4UmsOh/sOeaEMl2NGAyIkj5tRf5XwNdR3T/IPQpT5xK3BG3VRFXbYnI/IX5YFqqLj3OLChXaGTugnzNBQZ4sbYHuhinPHDmp8ZeFidCMUMb+fDO1DiIbvJBRzZD5uurqOfdoOZVgb3OZQd8icSV37eTXdXDnjoaqO2Mk8Hkj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l7M20JsL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l7M20JsL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 969D7C4CEED;
	Sun,  6 Jul 2025 21:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751838589;
	bh=Yx4mgiEfSU/LaE7CDAlNCKJFiXXK6BiaOxPxhGlhQUs=;
	h=Date:To:From:Subject:From;
	b=l7M20JsLS+ERrhZoyoq52ZfB3pmYlCkLbw9F7uj7BzYh3ZUuFN2clcwMehf0IHqGv
	 I0jpFDO6KamDxVSzfTHPJ6ntL7t9QGvb33JdBIhgFUIusWSJFmsxs1rkTFV6b6nuZ5
	 DKnUmt2C9ggb7qAfsam6GTIqPtxasllc9Z1jPoZQ=
Date: Sun, 06 Jul 2025 14:49:49 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + samples-damon-wsse-rename-to-have-damon_sample_-prefix.patch added to mm-new branch
Message-Id: <20250706214949.969D7C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: samples/damon/wsse: rename to have damon_sample_ prefix
has been added to the -mm mm-new branch.  Its filename is
     samples-damon-wsse-rename-to-have-damon_sample_-prefix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/samples-damon-wsse-rename-to-have-damon_sample_-prefix.patch

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
Subject: samples/damon/wsse: rename to have damon_sample_ prefix
Date: Sat, 5 Jul 2025 10:49:55 -0700

Patch series "mm/damon: misc cleanups".

Yet another round of miscellaneous DAMON cleanups.


This patch (of 6):

DAMON sample module, wsse has its name 'wsse'.  It could conflict with
future modules, and not very easy to identify it by name.  Use a prefix,
"damon_sample_" for the name.

Note that this could break users if they depend on the old name.  But it
is just a sample, so no such usage is expected, or known.  Even if such
usage exists, updating it for the new name should be straightforward.

Link: https://lkml.kernel.org/r/20250705175000.56259-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250705175000.56259-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/wsse.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/samples/damon/wsse.c~samples-damon-wsse-rename-to-have-damon_sample_-prefix
+++ a/samples/damon/wsse.c
@@ -12,6 +12,11 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 
+#ifdef MODULE_PARAM_PREFIX
+#undef MODULE_PARAM_PREFIX
+#endif
+#define MODULE_PARAM_PREFIX "damon_sample_wsse."
+
 static int target_pid __read_mostly;
 module_param(target_pid, int, 0600);
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-handle-damon_call_control-as-normal-under-kdmond-deactivation.patch
mm-damon-introduce-damon_stat-module.patch
mm-damon-introduce-damon_stat-module-fix.patch
mm-damon-introduce-damon_stat-module-fix-2.patch
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
samples-damon-wsse-rename-to-have-damon_sample_-prefix.patch
samples-damon-prcl-rename-to-have-damon_sample_-prefix.patch
samples-damon-mtier-rename-to-have-damon_sample_-prefix.patch
mm-damon-sysfs-use-damon-core-api-damon_is_running.patch
mm-damon-sysfs-dont-hold-kdamond_lock-in-before_terminate.patch
docs-mm-damon-maintainer-profile-update-for-mm-new-tree.patch

