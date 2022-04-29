Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45746C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 16:26:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379085AbiD2Q3i (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 12:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379094AbiD2Q3f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 12:29:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5742CD8933
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 09:26:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E800E62315
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 16:26:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480E4C385A4;
        Fri, 29 Apr 2022 16:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651249569;
        bh=JbTuY58YGclPgZD2MOeaXLe5q3r4+7aygzIByjhsDlU=;
        h=Date:To:From:Subject:From;
        b=DbLCFufkK3NosB840vLZW27mIpdKChEP4tScUgompSFtt8gTCNYbsIQ2ZDlz/pCvX
         pnJmhSodEQBEjlFFDOOkS81XyK7CDVN3ZyJZ4Hwh+g+KRtBnNGN2faZj/CQQBc+sOw
         a5jP7obXd2ViKc3ooWtTDVaii68OYSyz6TT9vzV4=
Date:   Fri, 29 Apr 2022 09:26:08 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-update-schemes-stat-in-the-kdamond-context.patch added to mm-unstable branch
Message-Id: <20220429162609.480E4C385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs: update schemes stat in the kdamond context
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-update-schemes-stat-in-the-kdamond-context.patch

This patch should soon appear in the mm-unstable branch at
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
Subject: mm/damon/sysfs: update schemes stat in the kdamond context

Only '->kdamond' and '->kdamond_stop' are protected by 'kdamond_lock' of
'struct damon_ctx'.  All other DAMON context internal data items are
recommended to be accessed in DAMON callbacks, or under some additional
synchronizations.  But, DAMON sysfs is accessing the schemes stat under
'kdamond_lock'.

It makes no big issue as the read values are not used anywhere inside
kernel, but would better to be fixed.  This commit moves the reads to
DAMON callback context, as supposed to be used for the purpose.

Link: https://lkml.kernel.org/r/20220429160606.127307-11-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |  161 +++++++++++++++++++++++++++++++++++++--------
 1 file changed, 135 insertions(+), 26 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-update-schemes-stat-in-the-kdamond-context
+++ a/mm/damon/sysfs.c
@@ -2079,6 +2079,25 @@ static const char * const damon_sysfs_cm
 	"update_schemes_stats",
 };
 
+/*
+ * struct damon_sysfs_cmd_request - A request to the DAMON callback.
+ * @cmd:	The command that needs to be handled by the callback.
+ * @kdamond:	The kobject wrapper that associated to the kdamond thread.
+ *
+ * This structure represents a sysfs command request that need to access some
+ * DAMON context-internal data.  Because DAMON context-internal data can be
+ * safely accessed from DAMON callbacks without additional synchronization, the
+ * request will be handled by the DAMON callback.  None-``NULL`` @kdamond means
+ * the request is valid.
+ */
+struct damon_sysfs_cmd_request {
+	enum damon_sysfs_cmd cmd;
+	struct damon_sysfs_kdamond *kdamond;
+};
+
+/* Current DAMON callback request.  Protected by damon_sysfs_lock. */
+static struct damon_sysfs_cmd_request damon_sysfs_cmd_request;
+
 static ssize_t state_show(struct kobject *kobj, struct kobj_attribute *attr,
 		char *buf)
 {
@@ -2257,6 +2276,70 @@ static void damon_sysfs_before_terminate
 	mutex_unlock(&ctx->kdamond_lock);
 }
 
+/*
+ * damon_sysfs_upd_schemes_stats() - Update schemes stats sysfs files.
+ * @kdamond:	The kobject wrapper that associated to the kdamond thread.
+ *
+ * This function reads the schemes stats of specific kdamond and update the
+ * related values for sysfs files.  This function should be called from DAMON
+ * callbacks while holding ``damon_syfs_lock``, to safely access the DAMON
+ * contexts-internal data and DAMON sysfs variables.
+ */
+static int damon_sysfs_upd_schemes_stats(struct damon_sysfs_kdamond *kdamond)
+{
+	struct damon_ctx *ctx = kdamond->damon_ctx;
+	struct damon_sysfs_schemes *sysfs_schemes;
+	struct damos *scheme;
+	int schemes_idx = 0;
+
+	if (!ctx)
+		return -EINVAL;
+	sysfs_schemes = kdamond->contexts->contexts_arr[0]->schemes;
+	damon_for_each_scheme(scheme, ctx) {
+		struct damon_sysfs_stats *sysfs_stats;
+
+		sysfs_stats = sysfs_schemes->schemes_arr[schemes_idx++]->stats;
+		sysfs_stats->nr_tried = scheme->stat.nr_tried;
+		sysfs_stats->sz_tried = scheme->stat.sz_tried;
+		sysfs_stats->nr_applied = scheme->stat.nr_applied;
+		sysfs_stats->sz_applied = scheme->stat.sz_applied;
+		sysfs_stats->qt_exceeds = scheme->stat.qt_exceeds;
+	}
+	return 0;
+}
+
+/*
+ * damon_sysfs_cmd_request_callback() - DAMON callback for handling requests.
+ * @c:	The DAMON context of the callback.
+ *
+ * This function is periodically called back from the kdamond thread for @c.
+ * Then, it checks if there is a waiting DAMON sysfs request and handles it.
+ */
+static int damon_sysfs_cmd_request_callback(struct damon_ctx *c)
+{
+	struct damon_sysfs_kdamond *kdamond;
+	int err = 0;
+
+	/* avoid deadlock due to concurrent state_store('off') */
+	if (!mutex_trylock(&damon_sysfs_lock))
+		return 0;
+	kdamond = damon_sysfs_cmd_request.kdamond;
+	if (!kdamond || kdamond->damon_ctx != c)
+		goto out;
+	switch (damon_sysfs_cmd_request.cmd) {
+	case DAMON_SYSFS_CMD_UPDATE_SCHEMES_STATS:
+		err = damon_sysfs_upd_schemes_stats(kdamond);
+		break;
+	default:
+		break;
+	}
+	/* Mark the request as invalid now. */
+	damon_sysfs_cmd_request.kdamond = NULL;
+out:
+	mutex_unlock(&damon_sysfs_lock);
+	return err;
+}
+
 static struct damon_ctx *damon_sysfs_build_ctx(
 		struct damon_sysfs_context *sys_ctx)
 {
@@ -2279,6 +2362,8 @@ static struct damon_ctx *damon_sysfs_bui
 	if (err)
 		goto out;
 
+	ctx->callback.after_wmarks_check = damon_sysfs_cmd_request_callback;
+	ctx->callback.after_aggregation = damon_sysfs_cmd_request_callback;
 	ctx->callback.before_terminate = damon_sysfs_before_terminate;
 	return ctx;
 
@@ -2295,6 +2380,8 @@ static int damon_sysfs_turn_damon_on(str
 	if (kdamond->damon_ctx &&
 			damon_sysfs_ctx_running(kdamond->damon_ctx))
 		return -EBUSY;
+	if (damon_sysfs_cmd_request.kdamond == kdamond)
+		return -EBUSY;
 	/* TODO: support multiple contexts per kdamond */
 	if (kdamond->contexts->nr != 1)
 		return -EINVAL;
@@ -2327,29 +2414,11 @@ static int damon_sysfs_turn_damon_off(st
 	 */
 }
 
-static int damon_sysfs_update_schemes_stats(struct damon_sysfs_kdamond *kdamond)
+static inline bool damon_sysfs_kdamond_running(
+		struct damon_sysfs_kdamond *kdamond)
 {
-	struct damon_ctx *ctx = kdamond->damon_ctx;
-	struct damos *scheme;
-	int schemes_idx = 0;
-
-	if (!ctx)
-		return -EINVAL;
-	mutex_lock(&ctx->kdamond_lock);
-	damon_for_each_scheme(scheme, ctx) {
-		struct damon_sysfs_schemes *sysfs_schemes;
-		struct damon_sysfs_stats *sysfs_stats;
-
-		sysfs_schemes = kdamond->contexts->contexts_arr[0]->schemes;
-		sysfs_stats = sysfs_schemes->schemes_arr[schemes_idx++]->stats;
-		sysfs_stats->nr_tried = scheme->stat.nr_tried;
-		sysfs_stats->sz_tried = scheme->stat.sz_tried;
-		sysfs_stats->nr_applied = scheme->stat.nr_applied;
-		sysfs_stats->sz_applied = scheme->stat.sz_applied;
-		sysfs_stats->qt_exceeds = scheme->stat.qt_exceeds;
-	}
-	mutex_unlock(&ctx->kdamond_lock);
-	return 0;
+	return kdamond->damon_ctx &&
+		damon_sysfs_ctx_running(kdamond->damon_ctx);
 }
 
 /*
@@ -2357,24 +2426,58 @@ static int damon_sysfs_update_schemes_st
  * @cmd:	The command to handle.
  * @kdamond:	The kobject wrapper for the associated kdamond.
  *
- * This function handles a DAMON sysfs command for a kdamond.
+ * This function handles a DAMON sysfs command for a kdamond.  For commands
+ * that need to access running DAMON context-internal data, it requests
+ * handling of the command to the DAMON callback
+ * (@damon_sysfs_cmd_request_callback()) and wait until it is properly handled,
+ * or the context is completed.
  *
  * Return: 0 on success, negative error code otherwise.
  */
 static int damon_sysfs_handle_cmd(enum damon_sysfs_cmd cmd,
 		struct damon_sysfs_kdamond *kdamond)
 {
+	bool need_wait = true;
+
+	/* Handle commands that doesn't access DAMON context-internal data */
 	switch (cmd) {
 	case DAMON_SYSFS_CMD_ON:
 		return damon_sysfs_turn_damon_on(kdamond);
 	case DAMON_SYSFS_CMD_OFF:
 		return damon_sysfs_turn_damon_off(kdamond);
-	case DAMON_SYSFS_CMD_UPDATE_SCHEMES_STATS:
-		return damon_sysfs_update_schemes_stats(kdamond);
 	default:
 		break;
 	}
-	return -EINVAL;
+
+	/* Pass the command to DAMON callback for safe DAMON context access */
+	if (damon_sysfs_cmd_request.kdamond)
+		return -EBUSY;
+	if (!damon_sysfs_kdamond_running(kdamond))
+		return -EINVAL;
+	damon_sysfs_cmd_request.cmd = cmd;
+	damon_sysfs_cmd_request.kdamond = kdamond;
+
+	/*
+	 * wait until damon_sysfs_cmd_request_callback() handles the request
+	 * from kdamond context
+	 */
+	mutex_unlock(&damon_sysfs_lock);
+	while (need_wait) {
+		schedule_timeout_idle(msecs_to_jiffies(100));
+		if (!mutex_trylock(&damon_sysfs_lock))
+			continue;
+		if (!damon_sysfs_cmd_request.kdamond) {
+			/* damon_sysfs_cmd_request_callback() handled */
+			need_wait = false;
+		} else if (!damon_sysfs_kdamond_running(kdamond)) {
+			/* kdamond has already finished */
+			need_wait = false;
+			damon_sysfs_cmd_request.kdamond = NULL;
+		}
+		mutex_unlock(&damon_sysfs_lock);
+	}
+	mutex_lock(&damon_sysfs_lock);
+	return 0;
 }
 
 static ssize_t state_store(struct kobject *kobj, struct kobj_attribute *attr,
@@ -2511,6 +2614,12 @@ static int damon_sysfs_kdamonds_add_dirs
 	if (damon_sysfs_nr_running_ctxs(kdamonds->kdamonds_arr, kdamonds->nr))
 		return -EBUSY;
 
+	for (i = 0; i < kdamonds->nr; i++) {
+		if (damon_sysfs_cmd_request.kdamond ==
+				kdamonds->kdamonds_arr[i])
+			return -EBUSY;
+	}
+
 	damon_sysfs_kdamonds_rm_dirs(kdamonds);
 	if (!nr_kdamonds)
 		return 0;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-test-add-a-kunit-test-case-for-ops-registration.patch
mm-damon-core-add-a-function-for-damon_operations-registration-checks.patch
mm-damon-sysfs-add-a-file-for-listing-available-monitoring-ops.patch
selftets-damon-sysfs-test-existence-and-permission-of-avail_operations.patch
docs-abiadmin-guide-damon-document-avail_operations-sysfs-file.patch
mm-damon-vaddr-register-a-damon_operations-for-fixed-virtual-address-ranges-monitoring.patch
mm-damon-sysfs-support-fixed-virtual-address-ranges-monitoring.patch
docs-abiadmin-guide-damon-update-for-fixed-virtual-address-ranges-monitoring.patch
mm-damon-core-add-a-new-callback-for-watermarks-checks.patch
mm-damon-core-finish-kdamond-as-soon-as-any-callback-returns-an-error.patch
mm-damon-vaddr-generalize-damon_va_apply_three_regions.patch
mm-damon-vaddr-move-damon_set_regions-to-core.patch
mm-damon-vaddr-remove-damon_va_apply_three_regions.patch
mm-damon-sysfs-prohibit-multiple-physical-address-space-monitoring-targets.patch
mm-damon-sysfs-move-targets-setup-code-to-a-separated-function.patch
mm-damon-sysfs-reuse-damon_set_regions-for-regions-setting.patch
mm-damon-sysfs-use-enum-for-state-input-handling.patch
mm-damon-sysfs-update-schemes-stat-in-the-kdamond-context.patch
mm-damon-sysfs-support-online-inputs-update.patch
docs-abiadmin-guide-damon-update-for-state-sysfs-file-input-keyword-commit.patch
mm-damon-reclaim-support-online-inputs-update.patch
docs-admin-guide-mm-damon-reclaim-document-commit_inputs-parameter.patch

