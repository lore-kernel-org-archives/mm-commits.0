Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1C81106
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 00:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708387712; cv=none; b=ii5cA3nAmDcxz5OV0VH4639nDMvNxVF2j33PVU1Gu3yVZ1MxzVDAXBK38ZPbE6WBVehbYq+EUrRUkEkioQk3uszks1uTOEpptvH/L8GXbQAAehk05sa5AqQ65COM3No8nZeULhaYZ/W6H9qtJ51jrhOGNRdmrqqsuru3RqNLVWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708387712; c=relaxed/simple;
	bh=bAnROl7+c1uKJiyPMBpm9SP9cJqva6MuTDwrzHoVB1k=;
	h=Date:To:From:Subject:Message-Id; b=VBHqtNaUjHlqJpxSCj+IEARuLly56w8hun94PyRpUEKg0zmQ5C+QAu9yw2cwRTT7+yQua18CMx3aJrQe/VxP6xayeYc3SXBZ+yfbnQz7CW2zOy+NybQVhPRdwmZ7b4hgiE0KSHnOwftvBOYRUIqPMe3x1dzTPjT0JIKI49CmwEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sZsSaI8w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sZsSaI8w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5CCC43390;
	Tue, 20 Feb 2024 00:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708387710;
	bh=bAnROl7+c1uKJiyPMBpm9SP9cJqva6MuTDwrzHoVB1k=;
	h=Date:To:From:Subject:From;
	b=sZsSaI8wff92AjS8HEz3eweqzwVesqUY+IAyQkQbUt9jynePEIuETtvEoJgg6ralN
	 yayT4iLmvLysZ3lLrcAINEYY+S6k9/CGrAoxBZ1v3hyq8gXhgnzUDH8eZ4GZMmlI5f
	 8yspYHCGDJFKISNGWkszWlECeTm4ZXl5taX3HriY=
Date: Mon, 19 Feb 2024 16:08:29 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-move-comments-and-fields-for-damos-quota-prioritization-to-the-end.patch added to mm-unstable branch
Message-Id: <20240220000830.7D5CCC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: move comments and fields for damos-quota-prioritization to the end
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-move-comments-and-fields-for-damos-quota-prioritization-to-the-end.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-move-comments-and-fields-for-damos-quota-prioritization-to-the-end.patch

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
Subject: mm/damon: move comments and fields for damos-quota-prioritization to the end
Date: Mon, 19 Feb 2024 11:44:17 -0800

The comments and definition of 'struct damos_quota' lists a few fields for
effective quota generation first, fields for regions prioritization under
the quota, and then remaining fields for effective quota generation. 
Readers' should unnecesssarily switch their context in the middle.  List
all the fields for the effective quota first, and then fields for the
prioritization for making it easier to read.

Link: https://lkml.kernel.org/r/20240219194431.159606-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

--- a/include/linux/damon.h~mm-damon-move-comments-and-fields-for-damos-quota-prioritization-to-the-end
+++ a/include/linux/damon.h
@@ -128,18 +128,17 @@ enum damos_action {
 
 /**
  * struct damos_quota - Controls the aggressiveness of the given scheme.
+ * @reset_interval:	Charge reset interval in milliseconds.
  * @ms:			Maximum milliseconds that the scheme can use.
  * @sz:			Maximum bytes of memory that the action can be applied.
- * @reset_interval:	Charge reset interval in milliseconds.
+ * @get_score:		Feedback function for self-tuning quota.
+ * @get_score_arg:	Parameter for @get_score
+ * @esz:		Effective size quota in bytes.
  *
  * @weight_sz:		Weight of the region's size for prioritization.
  * @weight_nr_accesses:	Weight of the region's nr_accesses for prioritization.
  * @weight_age:		Weight of the region's age for prioritization.
  *
- * @get_score:		Feedback function for self-tuning quota.
- * @get_score_arg:	Parameter for @get_score
- * @esz:		Effective size quota in bytes.
- *
  * To avoid consuming too much CPU time or IO resources for applying the
  * &struct damos->action to large memory, DAMON allows users to set time and/or
  * size quotas.  The quotas can be set by writing non-zero values to &ms and
@@ -152,12 +151,6 @@ enum damos_action {
  * throughput of the scheme's action.  DAMON then compares it against &sz and
  * uses smaller one as the effective quota.
  *
- * For selecting regions within the quota, DAMON prioritizes current scheme's
- * target memory regions using the &struct damon_operations->get_scheme_score.
- * You could customize the prioritization logic by setting &weight_sz,
- * &weight_nr_accesses, and &weight_age, because monitoring operations are
- * encouraged to respect those.
- *
  * If @get_score function pointer is set, DAMON calls it back with
  * @get_score_arg and get the return value of it for every @reset_interval.
  * Then, DAMON adjusts the effective quota using the return value as a feedback
@@ -170,20 +163,25 @@ enum damos_action {
  * set, the mechanism starts from the quota of one byte.
  *
  * The resulting effective size quota in bytes is set to @esz.
+ *
+ * For selecting regions within the quota, DAMON prioritizes current scheme's
+ * target memory regions using the &struct damon_operations->get_scheme_score.
+ * You could customize the prioritization logic by setting &weight_sz,
+ * &weight_nr_accesses, and &weight_age, because monitoring operations are
+ * encouraged to respect those.
  */
 struct damos_quota {
+	unsigned long reset_interval;
 	unsigned long ms;
 	unsigned long sz;
-	unsigned long reset_interval;
+	unsigned long (*get_score)(void *arg);
+	void *get_score_arg;
+	unsigned long esz;
 
 	unsigned int weight_sz;
 	unsigned int weight_nr_accesses;
 	unsigned int weight_age;
 
-	unsigned long (*get_score)(void *arg);
-	void *get_score_arg;
-	unsigned long esz;
-
 /* private: */
 	/* For throughput estimation */
 	unsigned long total_charged_sz;
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

