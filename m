Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFF91C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:18:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236120AbiEJEWs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236185AbiEJEUu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC523CFD6
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:15:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0CC3AB81B07
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:15:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0840C385C2;
        Tue, 10 May 2022 04:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156155;
        bh=/lfSKFL8xQ9+k1DOy10X13G2YY/tvwuplBeAC4iuwjQ=;
        h=Date:To:From:Subject:From;
        b=vcTH+/IfRYuOnSnAB7Ze0mkPO3xhKfAN2VlK50PZrMXQY3D0rOQTh23loSuyiErBF
         Fxk0X+RNI1dFSxEfqo2Toitdy18EWBur85mCzb0Hp2Zu6JZbdsn61TM9h9Y7GOBIl2
         rMojNgIZLh7LBDgs8mXmbriANYS5d9olwe4KUPQA=
Date:   Mon, 09 May 2022 21:15:55 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-update-schemes-stat-in-the-kdamond-context.patch removed from -mm tree
Message-Id: <20220510041555.A0840C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs: update schemes stat in the kdamond context
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-update-schemes-stat-in-the-kdamond-context.patch

This patch was dropped because it was merged into mm-stable

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
@@ -2258,6 +2277,70 @@ static void damon_sysfs_before_terminate
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
@@ -2280,6 +2363,8 @@ static struct damon_ctx *damon_sysfs_bui
 	if (err)
 		goto out;
 
+	ctx->callback.after_wmarks_check = damon_sysfs_cmd_request_callback;
+	ctx->callback.after_aggregation = damon_sysfs_cmd_request_callback;
 	ctx->callback.before_terminate = damon_sysfs_before_terminate;
 	return ctx;
 
@@ -2296,6 +2381,8 @@ static int damon_sysfs_turn_damon_on(str
 	if (kdamond->damon_ctx &&
 			damon_sysfs_ctx_running(kdamond->damon_ctx))
 		return -EBUSY;
+	if (damon_sysfs_cmd_request.kdamond == kdamond)
+		return -EBUSY;
 	/* TODO: support multiple contexts per kdamond */
 	if (kdamond->contexts->nr != 1)
 		return -EINVAL;
@@ -2328,29 +2415,11 @@ static int damon_sysfs_turn_damon_off(st
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
@@ -2358,24 +2427,58 @@ static int damon_sysfs_update_schemes_st
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
@@ -2512,6 +2615,12 @@ static int damon_sysfs_kdamonds_add_dirs
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


