Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD5D31A81F
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486763; cv=none; b=dBCVWP+Iworq+RAIJKS3usP22/fnWGEQv9rq3VDvebGON2bl9cTk4Bgm5rG635UK9na173Mdz6nNnMhKfiEotO85Ywc+YgBSjqO/JdABj3GOAjaCnyKYIl8sDt69a8kxLjBhbtu5Ob7KPuJUEN3sxmY3FKjf5pNuu/jcsrzcnBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486763; c=relaxed/simple;
	bh=RK3Y8JulGYMgto61bj3R2TQoLTqzsyZ0tGZD4C3UmX8=;
	h=Date:To:From:Subject:Message-Id; b=DDJwr0e0pNo365S53b5sJ6lr2D8lM7yLe33ky+G5azOCKVRl8Ge6SWXKwbBxKbHegpnyXUVDRJoLO2MeUmUsECMu02TM1+JZDIn+vYKvUOcNpyLSopsx4n4zK9jWKDn8ZZJPE6lyaRYmcVRprAKu3c+gbCL9nAMxtWE/Ua730X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PrpFuo3u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PrpFuo3u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C573EC116C6;
	Tue, 27 Jan 2026 04:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486762;
	bh=RK3Y8JulGYMgto61bj3R2TQoLTqzsyZ0tGZD4C3UmX8=;
	h=Date:To:From:Subject:From;
	b=PrpFuo3uCYvLG7CTiCNQwQGRtDvLLhVX2Fx05szpIP9ZAM0zWuEjQLjINh4FtqIPA
	 Bp4IXGSeWoUXdquHhaCUzgOqGoP8csx8XV6d8/XToZDuD0gj5HUeTu1Q0BjGELEXYY
	 kxU6qFfiCNquvVMfui2U+AwaEpq/XfEohCoVvhys=
Date: Mon, 26 Jan 2026 20:06:02 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-hide-kdamond-and-kdamond_lock-of-damon_ctx.patch removed from -mm tree
Message-Id: <20260127040602.C573EC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: hide kdamond and kdamond_lock of damon_ctx
has been removed from the -mm tree.  Its filename was
     mm-damon-hide-kdamond-and-kdamond_lock-of-damon_ctx.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

selftests-damon-sysfs_memcg_path_leaksh-use-kmemleak.patch
selftests-damon-wss_estimation-test-for-up-to-160-mib-working-set-size.patch
selftests-damon-access_memory-add-repeat-mode.patch
selftests-damon-wss_estimation-ensure-number-of-collected-wss.patch
selftests-damon-wss_estimation-deduplicate-failed-samples-output.patch
mm-damon-remove-damon_operations-cleanup.patch
mm-damon-core-cleanup-targets-and-regions-at-once-on-kdamond-termination.patch
mm-damon-core-cancel-damos_walk-before-damon_ctx-kdamond-reset.patch
mm-damon-core-process-damon_call_control-requests-on-a-local-list.patch
mm-damon-document-damon_call_control-dealloc_on_cancel-repeat-behavior.patch
mm-damon-core-rename-damos_filter_out-to-damos_core_filter_out.patch
mm-damon-rename-damon_min_region-to-damon_min_region_sz.patch
mm-damon-rename-min_sz_region-of-damon_ctx-to-min_region_sz.patch
docs-mm-damon-index-simplify-the-intro.patch
docs-mm-damon-design-link-repology-instead-of-fedora-package.patch
docs-mm-damon-design-document-damon-sample-modules.patch
docs-mm-damon-design-add-reference-to-damon_stat-usage.patch
docs-admin-guide-mm-damon-usage-introduce-damon-modules-at-the-beginning.patch
docs-admin-guide-mm-damon-usage-update-stats-update-process-for-refresh_ms.patch
docs-mm-damon-maintainer-profile-fix-wrong-maitnainers-section-name.patch
docs-mm-damon-maintainer-profile-remove-damon-tests-perf-suggestion.patch
maple_tree-start-using-maple-copy-node-for-destination-fix.patch

