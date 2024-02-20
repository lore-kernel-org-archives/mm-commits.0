Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D8C7E5
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 00:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708387703; cv=none; b=sfMNl5Admg1/KSRcFRgjKg0c5kHFTrkTMnFroOIaPOXJtwm6rX66Ujy/Eib4anZFCe4ABx/tpEWtSFQKo07tZUzLE25t5b6c4Hmi4un4LQMGa7/lC0DYW+Cq51fQZ5Y/rcxAmxeL2UMkmzVPJCp3pj63zYL+x5rAhRHj1dNiJqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708387703; c=relaxed/simple;
	bh=iqVC/bA3uTefXa0DGtdtAGRUkrMERYrOoVCfWQSjUxE=;
	h=Date:To:From:Subject:Message-Id; b=rgJaIsVWObWvCkgLy+rNRJT4UP77XC9QTdyoS4S6EroNDaaTp7NnkIZv2jheE/UK2cespv2tMZA2BmWfY96Ymjel791Fvs1tbNaDGZORgGZobnoFeNFfGwfu2n5pCbgunszIL9GYQIKGl2i/eEwU1EY/tHJgaYBhD0ma3JuuvUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bEqCogwQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bEqCogwQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9248EC433C7;
	Tue, 20 Feb 2024 00:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708387702;
	bh=iqVC/bA3uTefXa0DGtdtAGRUkrMERYrOoVCfWQSjUxE=;
	h=Date:To:From:Subject:From;
	b=bEqCogwQpjITy9iNQBjMWxcucycPea3C8wgJyAxezTEQYFrNppm/OILAmgiwOmw3A
	 yGd5+cijJWg6Y1nnX+zpbxsqxzuc4QZkEIrs3keeovUB4C3vqUzNTGkiKfjiz92cGC
	 xJFOTZ9RYSxLC07lE7IGvSW2/EjKDEbvtr1aFQHE=
Date: Mon, 19 Feb 2024 16:08:22 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-implement-quota-effective_bytes-file.patch added to mm-unstable branch
Message-Id: <20240220000822.9248EC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs-schemes: implement quota effective_bytes file
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-schemes-implement-quota-effective_bytes-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-implement-quota-effective_bytes-file.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: mm/damon/sysfs-schemes: implement quota effective_bytes file
Date: Mon, 19 Feb 2024 11:44:13 -0800

DAMON sysfs interface allows users to set two types of quotas, namely time
quota and size quota.  DAMOS converts time quota to a size quota and use
smaller one among the resulting two size quotas.  The resulting effective
size quota can be helpful for debugging and analysis, but not exposed to
the user.  The recently added feedback-driven quota auto-tuning is making
it even more mysterious.

Implement a DAMON sysfs interface read-only empty file, namely
'effective_bytes', under the quota goal DAMON sysfs directory.  It will be
extended to expose the effective quota to the end user.

Link: https://lkml.kernel.org/r/20240219194431.159606-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-implement-quota-effective_bytes-file
+++ a/mm/damon/sysfs-schemes.c
@@ -1139,6 +1139,7 @@ struct damon_sysfs_quotas {
 	unsigned long ms;
 	unsigned long sz;
 	unsigned long reset_interval_ms;
+	unsigned long effective_sz;	/* Effective size quota in bytes */
 };
 
 static struct damon_sysfs_quotas *damon_sysfs_quotas_alloc(void)
@@ -1252,6 +1253,15 @@ static ssize_t reset_interval_ms_store(s
 	return count;
 }
 
+static ssize_t effective_bytes_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_quotas *quotas = container_of(kobj,
+			struct damon_sysfs_quotas, kobj);
+
+	return sysfs_emit(buf, "%lu\n", quotas->effective_sz);
+}
+
 static void damon_sysfs_quotas_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_quotas, kobj));
@@ -1266,10 +1276,14 @@ static struct kobj_attribute damon_sysfs
 static struct kobj_attribute damon_sysfs_quotas_reset_interval_ms_attr =
 		__ATTR_RW_MODE(reset_interval_ms, 0600);
 
+static struct kobj_attribute damon_sysfs_quotas_effective_bytes_attr =
+		__ATTR_RO_MODE(effective_bytes, 0400);
+
 static struct attribute *damon_sysfs_quotas_attrs[] = {
 	&damon_sysfs_quotas_ms_attr.attr,
 	&damon_sysfs_quotas_sz_attr.attr,
 	&damon_sysfs_quotas_reset_interval_ms_attr.attr,
+	&damon_sysfs_quotas_effective_bytes_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_quotas);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-check-apply-interval-in-damon_do_apply_schemes.patch
mm-damon-sysfs-schemes-handle-schemes-sysfs-dir-removal-before-commit_schemes_quota_goals.patch
mm-damon-reclaim-fix-quota-stauts-loss-due-to-online-tunings.patch
mm-damon-lru_sort-fix-quota-status-loss-due-to-online-tunings.patch
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

