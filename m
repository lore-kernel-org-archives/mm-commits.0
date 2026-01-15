Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261EC3BB9FE
	for <mm-commits@vger.kernel.org>; Thu, 15 Jan 2026 16:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768495222; cv=none; b=kIkc3ahC7X8+K5BwRy0WuBZXSc/HvjKPIlngsy9TtXFSFcRwarz6Clzr5mjyTR0MBSl2mJrG87HJSlJ8wPRZpu3HB79eH7+sMpQ6q4MpRp3NkpOcGOEs0FSFY43ehvtMwEjIb75LjHSnKucK6MG/zPc0/0DTQ7jTLYYYsDbnXZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768495222; c=relaxed/simple;
	bh=UDNYHw9im0KKc+GA1yzZ3TRc5nZbbHWpXpXC4x9PvQg=;
	h=Date:To:From:Subject:Message-Id; b=Xria2BOz6UvvLvhJ3ci4PF0/5BDOxCBUSFsDRRlgBZV1SskQddSE5kewR5Zi97ancCgXDhuJKNus3ToTzSJ88DBhf55A7K8bNsPGmIoEvUg9MjLDjaBzQwGbXsBjClK4mfaGIjLZq79RK87OStlxWIsD9G+Pgqpls2yXF10WOPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oTMY11Xm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oTMY11Xm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E269AC116D0;
	Thu, 15 Jan 2026 16:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768495222;
	bh=UDNYHw9im0KKc+GA1yzZ3TRc5nZbbHWpXpXC4x9PvQg=;
	h=Date:To:From:Subject:From;
	b=oTMY11XmhK3f11DguooBIwAKEC0U8zgCB8qxo71b3oAkujecmo6IvPrS1FYjOU9U0
	 IOsBcTzqOIHd36my5OGjogABCG7dN0AtfJGsa4JnU1xQL9D+jwmzrCeW5xq/KjF76R
	 bLxxW/v8GE7HHkhSgPzCml0K/dMYhrjlUIyFop+k=
Date: Thu, 15 Jan 2026 08:40:21 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-hide-kdamond-and-kdamond_lock-of-damon_ctx.patch added to mm-new branch
Message-Id: <20260115164021.E269AC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: hide kdamond and kdamond_lock of damon_ctx
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-hide-kdamond-and-kdamond_lock-of-damon_ctx.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-hide-kdamond-and-kdamond_lock-of-damon_ctx.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
Subject: mm/damon: hide kdamond and kdamond_lock of damon_ctx
Date: Thu, 15 Jan 2026 07:20:45 -0800

There is no DAMON API caller that directly access 'kdamond' and
'kdamond_lock' fields of 'struct damon_ctx'.  Keeping those exposed could
only encourage creative but error-prone usages.  Hide them from DAMON API
callers by marking those as private fields.

Link: https://lkml.kernel.org/r/20260115152047.68415-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

--- a/include/linux/damon.h~mm-damon-hide-kdamond-and-kdamond_lock-of-damon_ctx
+++ a/include/linux/damon.h
@@ -759,23 +759,20 @@ struct damon_attrs {
  * of the monitoring.
  *
  * @attrs:		Monitoring attributes for accuracy/overhead control.
- * @kdamond:		Kernel thread who does the monitoring.
- * @kdamond_lock:	Mutex for the synchronizations with @kdamond.
  *
- * For each monitoring context, one kernel thread for the monitoring is
- * created.  The pointer to the thread is stored in @kdamond.
+ * For each monitoring context, one kernel thread for the monitoring, namely
+ * kdamond, is created.  The pid of kdamond can be retrieved using
+ * damon_kdamond_pid().
  *
- * Once started, the monitoring thread runs until explicitly required to be
- * terminated or every monitoring target is invalid.  The validity of the
- * targets is checked via the &damon_operations.target_valid of @ops.  The
- * termination can also be explicitly requested by calling damon_stop().
- * The thread sets @kdamond to NULL when it terminates. Therefore, users can
- * know whether the monitoring is ongoing or terminated by reading @kdamond.
- * Reads and writes to @kdamond from outside of the monitoring thread must
- * be protected by @kdamond_lock.
+ * Once started, kdamond runs until explicitly required to be terminated or
+ * every monitoring target is invalid.  The validity of the targets is checked
+ * via the &damon_operations.target_valid of @ops.  The termination can also be
+ * explicitly requested by calling damon_stop().  To know if a kdamond is
+ * running, damon_is_running() can be used.
  *
- * Note that the monitoring thread protects only @kdamond via @kdamond_lock.
- * Accesses to other fields must be protected by themselves.
+ * While the kdamond is running, all accesses to &struct damon_ctx from a
+ * thread other than the kdamond should be made using safe DAMON APIs,
+ * including damon_call() and damos_walk().
  *
  * @ops:	Set of monitoring operations for given use cases.
  * @addr_unit:	Scale factor for core to ops address conversion.
@@ -816,10 +813,12 @@ struct damon_ctx {
 	struct damos_walk_control *walk_control;
 	struct mutex walk_control_lock;
 
-/* public: */
+	/* Working thread of the given DAMON context */
 	struct task_struct *kdamond;
+	/* Protects @kdamond field access */
 	struct mutex kdamond_lock;
 
+/* public: */
 	struct damon_operations ops;
 	unsigned long addr_unit;
 	unsigned long min_sz_region;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-nr_snapshots-damos-stat.patch
mm-damon-sysfs-schemes-introduce-nr_snapshots-damos-stat-file.patch
docs-mm-damon-design-update-for-nr_snapshots-damos-stat.patch
docs-admin-guide-mm-damon-usage-update-for-nr_snapshots-damos-stat.patch
docs-abi-damon-update-for-nr_snapshots-damos-stat.patch
mm-damon-update-damos-kerneldoc-for-stat-field.patch
mm-damon-core-implement-max_nr_snapshots.patch
mm-damon-sysfs-schemes-implement-max_nr_snapshots-file.patch
docs-mm-damon-design-update-for-max_nr_snapshots.patch
docs-admin-guide-mm-damon-usage-update-for-max_nr_snapshots.patch
docs-abi-damon-update-for-max_nr_snapshots.patch
mm-damon-core-add-trace-point-for-damos-stat-per-apply-interval.patch
mm-damon-tests-core-kunit-add-test-cases-for-multiple-regions-in-damon_test_split_regions_of-fix.patch
mm-damon-core-introduce-active-memory-ratio-damos-quota-goal-metric.patch
mm-damon-sysfs-schemes-support-damos_quota_active_mem_bp.patch
docs-mm-damon-design-document-damos_quota_active_mem_bp.patch
mm-damon-paddr-activate-damos_lru_prio-targets-instead-of-marking-accessed.patch
mm-damon-lru_sort-consider-age-for-quota-prioritization.patch
mm-damon-lru_sort-support-young-page-filters.patch
docs-admin-guide-mm-damon-lru_sort-document-filter_young_pages.patch
mm-damon-lru_sort-support-active-inactive-memory-ratio-based-auto-tuning.patch
docs-admin-guide-mm-damon-lru_sort-document-active_mem_bp-parameter.patch
mm-damon-lru_sort-add-monitoring-intervals-auto-tuning-parameter.patch
docs-admin-guide-mm-damon-lru_sort-document-intervals-autotuning.patch
mm-damon-core-implement-damon_kdamond_pid.patch
mm-damon-sysfs-use-damon_kdamond_pid.patch
mm-damon-lru_sort-use-damon_kdamond_pid.patch
mm-damon-reclaim-use-damon_kdamond_pid.patch
mm-damon-hide-kdamond-and-kdamond_lock-of-damon_ctx.patch

