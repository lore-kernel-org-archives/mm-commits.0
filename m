Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786E7225771
	for <mm-commits@vger.kernel.org>; Sat, 12 Jul 2025 22:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752357997; cv=none; b=JRntEt2DD2XmAiI6No5U8XChBP4sMU1aM5OslFeZiQkeCSpOzbFq5Jdt2JXYtt2IMT5elcUf5lTpZ4QH088D2bGEjpi55gt5dvFfLeJ6S+JDVmMbycaE8+KmuzPHNMnd6zaXk7e87KrL2EQrTcgYj2hn3gZGaHk6zSMyaUH/yGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752357997; c=relaxed/simple;
	bh=3pIGfLUcl8TpY0snGkYg+SAgbTyah4RKcG5g7OS/BqM=;
	h=Date:To:From:Subject:Message-Id; b=VWVnifNRuvGgh34TgMRcakNyDKsC3QIjz2asVMuN/vgaXu8Atpro7jrMJgRfoAkmt/4sHyUUtp3fi6G2f7ZogAos+iGmmrMCQ6vjMIFXV9/WlX47mkCBzE8H/UTgFoXJRAZNbP21rejrkLzEN9G4QTEbRI9DklNy6ad1S6P4HS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IAEirjOe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IAEirjOe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B23AC4CEEF;
	Sat, 12 Jul 2025 22:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752357997;
	bh=3pIGfLUcl8TpY0snGkYg+SAgbTyah4RKcG5g7OS/BqM=;
	h=Date:To:From:Subject:From;
	b=IAEirjOem2R3bWvLAxRfFo2WQLIde7zLXpP4QmNaXPwH4QAhjnVcspZ+FgWzAL96/
	 c1Fytf2JMYM+W+hnpr5M1ORI6yc6FHpzVzkwIDWVqOnrGqaNY59tA0bEmTUWsFAhlG
	 WP1+62UlQ6Kug+Buq2UX+lhQOWJxUraX2WnUqu7A=
Date: Sat, 12 Jul 2025 15:06:36 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-vaddr-put-pid-in-cleanup_target.patch added to mm-new branch
Message-Id: <20250712220637.4B23AC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/vaddr: put pid in cleanup_target()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-vaddr-put-pid-in-cleanup_target.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-vaddr-put-pid-in-cleanup_target.patch

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
Subject: mm/damon/vaddr: put pid in cleanup_target()
Date: Sat, 12 Jul 2025 12:50:12 -0700

Implement cleanup_target() callback for [f]vaddr, which calls put_pid()
for each target that will be destroyed.  Also remove redundant put_pid()
calls in core, sysfs and sample modules, which were required to be done
redundantly due to the lack of such self cleanup in vaddr.

Link: https://lkml.kernel.org/r/20250712195016.151108-11-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c      |    2 --
 mm/damon/sysfs.c     |   10 ++--------
 mm/damon/vaddr.c     |    6 ++++++
 samples/damon/prcl.c |    2 --
 samples/damon/wsse.c |    2 --
 5 files changed, 8 insertions(+), 14 deletions(-)

--- a/mm/damon/core.c~mm-damon-vaddr-put-pid-in-cleanup_target
+++ a/mm/damon/core.c
@@ -1139,8 +1139,6 @@ static int damon_commit_targets(
 		} else {
 			struct damos *s;
 
-			if (damon_target_has_pid(dst))
-				put_pid(dst_target->pid);
 			damon_destroy_target(dst_target, dst);
 			damon_for_each_scheme(s, dst) {
 				if (s->quota.charge_target_from == dst_target) {
--- a/mm/damon/sysfs.c~mm-damon-vaddr-put-pid-in-cleanup_target
+++ a/mm/damon/sysfs.c
@@ -1298,13 +1298,9 @@ static int damon_sysfs_set_attrs(struct
 static void damon_sysfs_destroy_targets(struct damon_ctx *ctx)
 {
 	struct damon_target *t, *next;
-	bool has_pid = damon_target_has_pid(ctx);
 
-	damon_for_each_target_safe(t, next, ctx) {
-		if (has_pid)
-			put_pid(t->pid);
+	damon_for_each_target_safe(t, next, ctx)
 		damon_destroy_target(t, ctx);
-	}
 }
 
 static int damon_sysfs_set_regions(struct damon_target *t,
@@ -1387,10 +1383,8 @@ static void damon_sysfs_before_terminate
 	if (!damon_target_has_pid(ctx))
 		return;
 
-	damon_for_each_target_safe(t, next, ctx) {
-		put_pid(t->pid);
+	damon_for_each_target_safe(t, next, ctx)
 		damon_destroy_target(t, ctx);
-	}
 }
 
 /*
--- a/mm/damon/vaddr.c~mm-damon-vaddr-put-pid-in-cleanup_target
+++ a/mm/damon/vaddr.c
@@ -805,6 +805,11 @@ static bool damon_va_target_valid(struct
 	return false;
 }
 
+static void damon_va_cleanup_target(struct damon_target *t)
+{
+	put_pid(t->pid);
+}
+
 #ifndef CONFIG_ADVISE_SYSCALLS
 static unsigned long damos_madvise(struct damon_target *target,
 		struct damon_region *r, int behavior)
@@ -946,6 +951,7 @@ static int __init damon_va_initcall(void
 		.prepare_access_checks = damon_va_prepare_access_checks,
 		.check_accesses = damon_va_check_accesses,
 		.target_valid = damon_va_target_valid,
+		.cleanup_target = damon_va_cleanup_target,
 		.cleanup = NULL,
 		.apply_scheme = damon_va_apply_scheme,
 		.get_scheme_score = damon_va_scheme_score,
--- a/samples/damon/prcl.c~mm-damon-vaddr-put-pid-in-cleanup_target
+++ a/samples/damon/prcl.c
@@ -120,8 +120,6 @@ static void damon_sample_prcl_stop(void)
 		damon_stop(&ctx, 1);
 		damon_destroy_ctx(ctx);
 	}
-	if (target_pidp)
-		put_pid(target_pidp);
 }
 
 static bool init_called;
--- a/samples/damon/wsse.c~mm-damon-vaddr-put-pid-in-cleanup_target
+++ a/samples/damon/wsse.c
@@ -100,8 +100,6 @@ static void damon_sample_wsse_stop(void)
 		damon_stop(&ctx, 1);
 		damon_destroy_ctx(ctx);
 	}
-	if (target_pidp)
-		put_pid(target_pidp);
 }
 
 static bool init_called;
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-add-drgn-script-for-extracting-damon-status.patch
selftests-damon-_damon_sysfs-set-kdamondpid-in-start.patch
selftests-damon-add-python-and-drgn-based-damon-sysfs-test.patch
selftests-damon-sysfspy-test-monitoring-attribute-parameters.patch
selftests-damon-sysfspy-test-adaptive-targets-parameter.patch
selftests-damon-sysfspy-test-damos-schemes-parameters-setup.patch
mm-damon-add-trace-event-for-auto-tuned-monitoring-intervals.patch
mm-damon-add-trace-event-for-effective-size-quota.patch
mm-damon-add-trace-event-for-effective-size-quota-fix.patch
mm-damon-add-trace-event-for-effective-size-quota-fix-2.patch
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
mm-damon-add-struct-damos_migrate_dests.patch
mm-damon-core-add-damos-migrate_dests-field.patch
mm-damon-sysfs-schemes-implement-damos-action-destinations-directory.patch
mm-damon-sysfs-schemes-set-damos-migrate_dests.patch
docs-abi-damon-document-schemes-dests-directory.patch
docs-admin-guide-mm-damon-usage-document-dests-directory.patch
mm-damon-accept-parallel-damon_call-requests.patch
mm-damon-core-introduce-repeat-mode-damon_call.patch
mm-damon-stat-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-reclaim-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-lru_sort-use-damon_call-repeat-mode-instead-of-damon_callback.patch
samples-damon-prcl-use-damon_call-repeat-mode-instead-of-damon_callback.patch
samples-damon-wsse-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-core-do-not-call-opscleanup-when-destroying-targets.patch
mm-damon-core-add-cleanup_target-ops-callback.patch
mm-damon-vaddr-put-pid-in-cleanup_target.patch
mm-damon-sysfs-remove-damon_sysfs_destroy_targets.patch
mm-damon-core-destroy-targets-when-kdamond_fn-finish.patch
mm-damon-sysfs-remove-damon_sysfs_before_terminate.patch
mm-damon-core-remove-damon_callback.patch

