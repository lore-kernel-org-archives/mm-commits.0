Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2EE225771
	for <mm-commits@vger.kernel.org>; Sat, 12 Jul 2025 22:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752358005; cv=none; b=HR/9X7Ohp0aKw9BFYP58d+0eY//0wG5p0KHOXKS25/Y6w3KjmmavwbcuZPBd6kWq5ZJQcDoQSTSNS17irAJ8EHrVQrgfCuvcpP4GuUeRhkW0uQR0o194YW9dxZmPynZIfyoDTTl8uOrVa5b5wGputw0R+kDzP37uRtCD6S+9ntU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752358005; c=relaxed/simple;
	bh=vSQ5XfHlelDEZLOi5mw3U4V2/+8Ry/6+naePOQ1iByA=;
	h=Date:To:From:Subject:Message-Id; b=ff7ZClTu2GGJi1WRKTs5DdsNgYfALzU2BU93OmmZ8mJRGotQ2Rxy1vVBW430ox2e/W9X77hH1Bzwe81pVAfo1qGGozO7+MERD4BGTjrL93beO7luYCtcr+U9dzabwkiRB8H0wRPiB1ZyoRkiC+ynDBu8Dy8P+Jv2UZbd7r4zuD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JO3s6nbz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JO3s6nbz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E27EC4CEEF;
	Sat, 12 Jul 2025 22:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752358005;
	bh=vSQ5XfHlelDEZLOi5mw3U4V2/+8Ry/6+naePOQ1iByA=;
	h=Date:To:From:Subject:From;
	b=JO3s6nbzEOUsGwmzIH0qo/bljjqLFnnehhXXZGlLJWG6s1ZL+FGyuGe8K0zXkA0/O
	 vKxzxjAfU+yLgVPBavT+gcRKq86+Ir6GmL/5TBYV0b94KPrzyce2934Nvvjc9MDXm4
	 rSizBYfhBdrkPNeMEx/49/xW5XJrurB7sa5eEXSs=
Date: Sat, 12 Jul 2025 15:06:44 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-remove-damon_sysfs_before_terminate.patch added to mm-new branch
Message-Id: <20250712220645.4E27EC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: remove damon_sysfs_before_terminate()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-remove-damon_sysfs_before_terminate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-remove-damon_sysfs_before_terminate.patch

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
Subject: mm/damon/sysfs: remove damon_sysfs_before_terminate()
Date: Sat, 12 Jul 2025 12:50:15 -0700

DAMON core layer does target cleanup on its own.  Remove duplicated and
unnecessarily selective cleanup attempts in DAMON sysfs interface.

Link: https://lkml.kernel.org/r/20250712195016.151108-14-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   12 ------------
 1 file changed, 12 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-remove-damon_sysfs_before_terminate
+++ a/mm/damon/sysfs.c
@@ -1361,17 +1361,6 @@ static int damon_sysfs_add_targets(struc
 	return 0;
 }
 
-static void damon_sysfs_before_terminate(struct damon_ctx *ctx)
-{
-	struct damon_target *t, *next;
-
-	if (!damon_target_has_pid(ctx))
-		return;
-
-	damon_for_each_target_safe(t, next, ctx)
-		damon_destroy_target(t, ctx);
-}
-
 /*
  * damon_sysfs_upd_schemes_stats() - Update schemes stats sysfs files.
  * @data:	The kobject wrapper that associated to the kdamond thread.
@@ -1516,7 +1505,6 @@ static struct damon_ctx *damon_sysfs_bui
 		return ERR_PTR(err);
 	}
 
-	ctx->callback.before_terminate = damon_sysfs_before_terminate;
 	return ctx;
 }
 
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

