Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F40152DF6;
	Tue, 20 Feb 2024 22:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708467756; cv=none; b=SJlYuLpFDCNaczDFnHjVUM3EZLATKi1CZyq/XhP2c8iqJnGNtAHuh6QHIAZzo9lidYLCqTbiCfPzn8vqgzmXweqsUgbn7r8avfYg0F2CdIF5/ZRCTExflE1OcY283fixPkBP29x6hgK+Xd3tWcl40xhwDaI13z3FIjscTVXzLfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708467756; c=relaxed/simple;
	bh=6Q7KKcZBlIEn96wL6vr9T5WboIpbAx5YV9LJ65Lkiaw=;
	h=Date:To:From:Subject:Message-Id; b=fUn8+l/vJNmmSwKnQEM3d3UXlbsQyDRXWIdDela6y7aLjvJtp9FnL9qXevt9PqQWRqdgnB75Qk/vSAJqh+8QkZiuwm2YCPosLVi7KaZhaZ8tmkTd01cP+Bmwceqy2SUpc8gL5o5F1DzMeiYHD8Iivo8+Q6sCTcDQzRRCgOMhDx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QcHGmJcs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QcHGmJcs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C02FAC43399;
	Tue, 20 Feb 2024 22:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708467755;
	bh=6Q7KKcZBlIEn96wL6vr9T5WboIpbAx5YV9LJ65Lkiaw=;
	h=Date:To:From:Subject:From;
	b=QcHGmJcsinY744kpNadgT1AgLQkoMT2VIsYASbANvDF9m9OCB6bKTSVMJ/pgzGHMr
	 icfpIvGLzeUuQl6hdDS0KNprhYRZSfC/BEJYLWrCejzXBj1l+Q64yYilFxDaQ0M+bR
	 WHBN+Uq8SaUSVkqPuW7xEQ4Z9GDDoZX/Hun3Skwo=
Date: Tue, 20 Feb 2024 14:22:35 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-reclaim-fix-quota-stauts-loss-due-to-online-tunings.patch removed from -mm tree
Message-Id: <20240220222235.C02FAC43399@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/reclaim: fix quota stauts loss due to online tunings
has been removed from the -mm tree.  Its filename was
     mm-damon-reclaim-fix-quota-stauts-loss-due-to-online-tunings.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/reclaim: fix quota stauts loss due to online tunings
Date: Fri, 16 Feb 2024 11:40:24 -0800

Patch series "mm/damon: fix quota status loss due to online tunings".

DAMON_RECLAIM and DAMON_LRU_SORT is not preserving internal quota status
when applying new user parameters, and hence could cause temporal quota
accuracy degradation.  Fix it by preserving the status.


This patch (of 2):

For online parameters change, DAMON_RECLAIM creates new scheme based on
latest values of the parameters and replaces the old scheme with the new
one.  When creating it, the internal status of the quota of the old
scheme is not preserved.  As a result, charging of the quota starts from
zero after the online tuning.  The data that collected to estimate the
throughput of the scheme's action is also reset, and therefore the
estimation should start from the scratch again.  Because the throughput
estimation is being used to convert the time quota to the effective size
quota, this could result in temporal time quota inaccuracy.  It would be
recovered over time, though.  In short, the quota accuracy could be
temporarily degraded after online parameters update.

Fix the problem by checking the case and copying the internal fields for
the status.

Link: https://lkml.kernel.org/r/20240216194025.9207-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20240216194025.9207-2-sj@kernel.org
Fixes: e035c280f6df ("mm/damon/reclaim: support online inputs update")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[5.19+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-fix-quota-stauts-loss-due-to-online-tunings
+++ a/mm/damon/reclaim.c
@@ -150,9 +150,20 @@ static struct damos *damon_reclaim_new_s
 			&damon_reclaim_wmarks);
 }
 
+static void damon_reclaim_copy_quota_status(struct damos_quota *dst,
+		struct damos_quota *src)
+{
+	dst->total_charged_sz = src->total_charged_sz;
+	dst->total_charged_ns = src->total_charged_ns;
+	dst->charged_sz = src->charged_sz;
+	dst->charged_from = src->charged_from;
+	dst->charge_target_from = src->charge_target_from;
+	dst->charge_addr_from = src->charge_addr_from;
+}
+
 static int damon_reclaim_apply_parameters(void)
 {
-	struct damos *scheme;
+	struct damos *scheme, *old_scheme;
 	struct damos_filter *filter;
 	int err = 0;
 
@@ -164,6 +175,11 @@ static int damon_reclaim_apply_parameter
 	scheme = damon_reclaim_new_scheme();
 	if (!scheme)
 		return -ENOMEM;
+	if (!list_empty(&ctx->schemes)) {
+		damon_for_each_scheme(old_scheme, ctx)
+			damon_reclaim_copy_quota_status(&scheme->quota,
+					&old_scheme->quota);
+	}
 	if (skip_anon) {
 		filter = damos_new_filter(DAMOS_FILTER_TYPE_ANON, true);
 		if (!filter) {
_

Patches currently in -mm which might be from sj@kernel.org are

docs-admin-guide-mm-damon-usage-use-sysfs-interface-for-tracepoints-example.patch
mm-damon-rename-config_damon_dbgfs-to-damon_dbgfs_deprecated.patch
mm-damon-dbgfs-implement-deprecation-notice-file.patch
mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro.patch
docs-admin-guide-mm-damon-usage-document-deprecated-file-of-damon-debugfs-interface.patch
selftets-damon-prepare-for-monitor_on-file-renaming.patch
mm-damon-dbgfs-rename-monitor_on-file-to-monitor_on_deprecated.patch
docs-admin-guide-mm-damon-usage-update-for-monitor_on-renaming.patch
docs-translations-damon-usage-update-for-monitor_on-renaming.patch
mm-damon-sysfs-handle-state-file-inputs-for-every-sampling-interval-if-possible.patch
selftests-damon-_damon_sysfs-support-damos-quota.patch
selftests-damon-_damon_sysfs-support-damos-stats.patch
selftests-damon-_damon_sysfs-support-damos-apply-interval.patch
selftests-damon-add-a-test-for-damos-quota.patch
selftests-damon-add-a-test-for-damos-apply-intervals.patch
selftests-damon-add-a-test-for-a-race-between-target_ids_read-and-dbgfs_before_terminate.patch
selftests-damon-add-a-test-for-the-pid-leak-of-dbgfs_target_ids_write.patch
selftests-damon-_chk_dependency-get-debugfs-mount-point-from-proc-mounts.patch
docs-mm-damon-maintainer-profile-fix-reference-links-for-mm-stable-tree.patch
docs-mm-damon-move-the-list-of-damos-actions-to-design-doc.patch
docs-mm-damon-move-damon-operation-sets-list-from-the-usage-to-the-design-document.patch
docs-mm-damon-move-monitoring-target-regions-setup-detail-from-the-usage-to-the-design-document.patch
docs-admin-guide-mm-damon-usage-fix-wrong-quotas-diabling-condition.patch
mm-damon-core-set-damos_quota-esz-as-public-field-and-document.patch
mm-damon-sysfs-schemes-implement-quota-effective_bytes-file.patch
mm-damon-sysfs-implement-a-kdamond-command-for-updating-schemes-effective-quotas.patch
docs-abi-damon-document-effective_bytes-sysfs-file.patch
docs-admin-guide-mm-damon-usage-document-effective_bytes-file.patch
mm-damon-move-comments-and-fields-for-damos-quota-prioritization-to-the-end.patch
mm-damon-core-split-out-quota-goal-related-fields-to-a-struct.patch
mm-damon-core-add-multiple-goals-per-damos_quota-and-helpers-for-those.patch
mm-damon-sysfs-use-only-quota-goals.patch
mm-damon-core-remove-goal-field-of-damos_quota.patch
mm-damon-core-let-goal-specified-with-only-target-and-current-values.patch
mm-damon-core-support-multiple-metrics-for-quota-goal.patch
mm-damon-core-implement-psi-metric-damos-quota-goal.patch
mm-damon-sysfs-schemes-support-psi-based-quota-auto-tune.patch
docs-mm-damon-design-document-quota-goal-self-tuning.patch
docs-abi-damon-document-quota-goal-metric-file.patch
docs-admin-guide-mm-damon-usage-document-quota-goal-metric-file.patch
mm-damon-reclaim-implement-user-feedback-driven-quota-auto-tuning.patch
mm-damon-reclaim-implement-memory-psi-driven-quota-self-tuning.patch
docs-admin-guide-mm-damon-reclaim-document-auto-tuning-parameters.patch

