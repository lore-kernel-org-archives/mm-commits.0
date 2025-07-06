Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3A5846F
	for <mm-commits@vger.kernel.org>; Sun,  6 Jul 2025 21:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751838639; cv=none; b=Ll6frgMH3FwliydUGM+J6vOj1fdzLHwvLK/wtjM/xGAmab0btDsNmZFKiMi9+l94zIJeyHDKktNt8e3fp4Uol/fxoAoXZespkz5Di+nzi5ZS3JURRpBZnNq2FKaCHIqw2v6JjZxwhR94QaQ20zivQjzB05mIXV9ZZZ0UMTkc4I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751838639; c=relaxed/simple;
	bh=JzMk5BqpRxqBvAY169n3imPqLMbIVCtXa+4MXb8ydsc=;
	h=Date:To:From:Subject:Message-Id; b=Cwtcfbu8ZqjdefM93J6E/96wmaEpEMafXoD6PMkKyPKSqppthRsjw1VbJeeorzt5HFl6zvFfngyE2DBA8GSNNG50cHoqIHpBlDdQ00XriPyYxhV/7Y89VmWU5zt9H5u1my8QJXIFYNXiewpMIC1njfQmkvqQZe1BRtEhBONrzCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kSKPPg3f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kSKPPg3f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D30B2C4CEED;
	Sun,  6 Jul 2025 21:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751838636;
	bh=JzMk5BqpRxqBvAY169n3imPqLMbIVCtXa+4MXb8ydsc=;
	h=Date:To:From:Subject:From;
	b=kSKPPg3f5MIDsK/v5crZkAd+UmLfKFU7Zn3Q8EZ1RAfbGI591NAzfcaCAjGHzUM2w
	 WGPfWiMPdllAGwlUAeyxlrU/TcArfTAibHZUC8Zw3+AGcDrPCGgATxVGtnuqcvNjsi
	 NLOjpIXkrxv+Dk2+m9Kp6wL6cetum0qzTC9H0hBA=
Date: Sun, 06 Jul 2025 14:50:36 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-add-trace-event-for-effective-size-quota-fix.patch added to mm-new branch
Message-Id: <20250706215036.D30B2C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: initialize sidx in damos_trace_esz()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-add-trace-event-for-effective-size-quota-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-add-trace-event-for-effective-size-quota-fix.patch

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
Subject: mm/damon/core: initialize sidx in damos_trace_esz()
Date: Sat, 5 Jul 2025 10:20:03 -0700

Commit ae4dc5a31d0f ("mm/damon: add trace event for effective size
quota") introduced damos_trac_esz(), which uses sidx variable without
initialization.  Initialize before using it.

Link: https://lkml.kernel.org/r/20250705172003.52324-1-sj@kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202507051517.bs3jd8RW-lkp@intel.com/
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-add-trace-event-for-effective-size-quota-fix
+++ a/mm/damon/core.c
@@ -2014,7 +2014,7 @@ static void damos_set_effective_quota(st
 static void damos_trace_esz(struct damon_ctx *c, struct damos *s,
 		struct damos_quota *quota)
 {
-	unsigned int cidx = 0, sidx;
+	unsigned int cidx = 0, sidx = 0;
 	struct damos *siter;
 
 	damon_for_each_scheme(siter, c) {
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
mm-damon-add-trace-event-for-effective-size-quota-fix.patch
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

