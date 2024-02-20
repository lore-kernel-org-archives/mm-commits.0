Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72A2367
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 00:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708387701; cv=none; b=k9jppcjiCo8Uks5jE8cWmzyPTGu+WJhI0KFHLGWTB1Ue6IKRoJs8KtzBFbwB+RuTWM/LMig2FjkKKCvgpZPWxoPYFcVR8cNihbGhU2QlMpCiM6zrzPauasXRmN2u/gaKCHqiA3jefHLeoOqbvQjQd8DLL0SlmN3Nk3A18tbM1Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708387701; c=relaxed/simple;
	bh=STb8isbBMFVtNuXELaHKq370CVi8BLJ5ShXwC2bV35E=;
	h=Date:To:From:Subject:Message-Id; b=g/rAj20Iodcos31JM4S7k0UPNv19NImLY4uBPvLVhq6fDcMo++eydJBzYPp3jLpXDg85m/HhFWR34ZOqj3jTDLiIcw2091eV/g7yQHx9k3oeHBoKtTSeMcS1q2uq/OAkmZiCp55zDZh8r+7p2tk3Mi5VvIEvk8HuZi7y5M/aVic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JM+49w9P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JM+49w9P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A6BBC433F1;
	Tue, 20 Feb 2024 00:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708387700;
	bh=STb8isbBMFVtNuXELaHKq370CVi8BLJ5ShXwC2bV35E=;
	h=Date:To:From:Subject:From;
	b=JM+49w9PMfqskshJ2Q+zaG/YXZGeDLhyzz2/xKKehY7Ce+Fulp2yFInZGXNADz26w
	 qB1lwBy9Llp/PBzNENDvzN6owxc+kZMJI5fiOE1iGaWs9OlqQBL8ktd4lZlRMNDhX2
	 63VQQ5yQna6nwbWTKL5Skm12rj7OqI4H0w18ixZo=
Date: Mon, 19 Feb 2024 16:08:19 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-set-damos_quota-esz-as-public-field-and-document.patch added to mm-unstable branch
Message-Id: <20240220000820.6A6BBC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: set damos_quota->esz as public field and document
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-set-damos_quota-esz-as-public-field-and-document.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-set-damos_quota-esz-as-public-field-and-document.patch

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
Subject: mm/damon/core: set damos_quota->esz as public field and document
Date: Mon, 19 Feb 2024 11:44:12 -0800

Patch series "mm/damon: let DAMOS feeds and tame/auto-tune itself".

The Aim-oriented Feedback-driven DAMOS Aggressiveness Auto-tuning
patchset[1] which has merged since commit 9294a037c015 ("mm/damon/core:
implement goal-oriented feedback-driven quota auto-tuning") made the
mechanism and the policy separated.  That is, users can set a part of
DAMOS control policies without a deep understanding of the mechanism but
just their demands such as SLA.

However, users are still required to do some additional work of manually
collecting their target metric and feeding it to DAMOS.  In the case of
end-users who use DAMON sysfs interface, the context switches between
user-space and kernel-space could also make it inefficient.  The overhead
is supposed to be only trivial in common cases, though.  Meanwhile, in
simple use cases, the target metric could be common system metrics that
the kernel can efficiently self-retrieve, such as memory pressure stall
time (PSI).

Extend DAMOS quota auto-tuning to support multiple types of metrics
including the DAMOS self-retrievable ones, and add support for memory
pressure stall time metric.  Different types of metrics can be supported
in future.  The auto-tuning capability is currently supported for only
users of DAMOS kernel API and DAMON sysfs interface.  Extend the support
to DAMON_RECLAIM.

Patches Sequence
================

First five patches are for helping debugging and fine-tuning existing
quota control features.  The first one (patch 1) exposes the effective
quota that is made with given user inputs to DAMOS kernel API users and
kernel-doc documents.  Following four patches implement (patches 1, 2 and
3) and document (patches 4 and 5) a new DAMON sysfs file that exposes the
value.

Following six patches cleanup and simplify the existing DAMOS quota
auto-tuning code by improving layout of comments and data structures
(patches 6 and 7), supporting common use cases, namely multiple goals
(patches 8, 9 and 10), and simplifying the interface (patch 11).

Then six patches for the main purpose of this patchset follow.  The first
three changes extend the core logic for various target metrics (patch 12),
implement memory pressure stall time-based target metric support (patch
13), and update DAMON sysfs interface to support the new target metric
(patch 14).  Then, documentation updates for the features on design (patch
15), ABI (patch 16), and usage (patch 17) follow.

Last three patches add auto-tuning support on DAMON_RECLAIM.  The patches
implement DAMON_RECLAIM parameters for user-feedback driven quota
auto-tuning (patch 18), memory pressure stall time-driven quota
self-tuning (patch 19), and finally update the DAMON_RECLAIM usage
document for the new parameters (patch 20).

[1] https://lore.kernel.org/all/20231130023652.50284-1-sj@kernel.org/


This patch (of 20):

DAMOS allow users to specify the quota as they want in multiple ways
including time quota, size quota, and feedback-based auto-tuning.  DAMOS
makes one effective quota out of the inputs and use it at the end. 
Knowing the current effective quota helps understanding DAMOS' internal
mechanism and fine-tuning quotas.  DAMON kernel API users can get the
information from ->esz field of damos_quota struct, but the field is
marked as private purpose, and not kernel-doc documented.  Make it public
and document.

Link: https://lkml.kernel.org/r/20240219194431.159606-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20240219194431.159606-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    6 ++++--
 mm/damon/core.c       |    8 ++++----
 2 files changed, 8 insertions(+), 6 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-set-damos_quota-esz-as-public-field-and-document
+++ a/include/linux/damon.h
@@ -138,6 +138,7 @@ enum damos_action {
  *
  * @get_score:		Feedback function for self-tuning quota.
  * @get_score_arg:	Parameter for @get_score
+ * @esz:		Effective size quota in bytes.
  *
  * To avoid consuming too much CPU time or IO resources for applying the
  * &struct damos->action to large memory, DAMON allows users to set time and/or
@@ -167,6 +168,8 @@ enum damos_action {
  * tuning is getting the feedback screo value of 10,000.  If @ms and/or @sz are
  * set together, those work as a hard limit quota.  If neither @ms nor @sz are
  * set, the mechanism starts from the quota of one byte.
+ *
+ * The resulting effective size quota in bytes is set to @esz.
  */
 struct damos_quota {
 	unsigned long ms;
@@ -179,14 +182,13 @@ struct damos_quota {
 
 	unsigned long (*get_score)(void *arg);
 	void *get_score_arg;
+	unsigned long esz;
 
 /* private: */
 	/* For throughput estimation */
 	unsigned long total_charged_sz;
 	unsigned long total_charged_ns;
 
-	unsigned long esz;	/* Effective size quota in bytes */
-
 	/* For charging the quota */
 	unsigned long charged_sz;
 	unsigned long charged_from;
--- a/mm/damon/core.c~mm-damon-core-set-damos_quota-esz-as-public-field-and-document
+++ a/mm/damon/core.c
@@ -299,12 +299,12 @@ void damos_destroy_filter(struct damos_f
 	damos_free_filter(f);
 }
 
-/* initialize private fields of damos_quota and return the pointer */
-static struct damos_quota *damos_quota_init_priv(struct damos_quota *quota)
+/* initialize fields of @quota that normally API users wouldn't set */
+static struct damos_quota *damos_quota_init(struct damos_quota *quota)
 {
+	quota->esz = 0;
 	quota->total_charged_sz = 0;
 	quota->total_charged_ns = 0;
-	quota->esz = 0;
 	quota->charged_sz = 0;
 	quota->charged_from = 0;
 	quota->charge_target_from = NULL;
@@ -336,7 +336,7 @@ struct damos *damon_new_scheme(struct da
 	scheme->stat = (struct damos_stat){};
 	INIT_LIST_HEAD(&scheme->list);
 
-	scheme->quota = *(damos_quota_init_priv(quota));
+	scheme->quota = *(damos_quota_init(quota));
 
 	scheme->wmarks = *wmarks;
 	scheme->wmarks.activated = true;
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

