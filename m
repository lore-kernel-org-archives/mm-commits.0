Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69BD4C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:19:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236150AbiEJEXB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236193AbiEJEUu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D153A3CFC8
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:15:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C9756176A
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:15:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 964ABC385C7;
        Tue, 10 May 2022 04:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156156;
        bh=bRfHg3H1v/9Y4hMCgTTrn0x0OgolN1rtm6kChz9nZfQ=;
        h=Date:To:From:Subject:From;
        b=JW1u8kJj2aRuOfY3fABXj/eF9KLQtBKo8ChA9YeKZ4cqHROx3NJhAkSr3bSWMuwtz
         S92r2Ay6o1mVyRONcruLzW+YT5GOawL0fIDMZWKsv7xMlqP28HYAtZy5MmOZu53qjs
         YwRgNliwygu8rIR9/LM/pBTaONiWHfJG/BTMMAm8=
Date:   Mon, 09 May 2022 21:15:56 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-support-online-inputs-update.patch removed from -mm tree
Message-Id: <20220510041556.964ABC385C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs: support online inputs update
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-support-online-inputs-update.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: support online inputs update

Currently, DAMON sysfs interface doesn't provide a way for adjusting DAMON
input parameters while it is turned on.  Therefore, users who want to
reconfigure DAMON need to stop DAMON and restart.  This means all the
monitoring results that accumulated so far, which could be useful, should
be flushed.  This would be inefficient for many cases.

For an example, let's suppose a sysadmin was running a DAMON-based
Operation Scheme to find memory regions not accessed for more than 5 mins
and page out the regions.  If it turns out the 5 mins threshold was too
long and therefore the sysadmin wants to reduce it to 4 mins, the sysadmin
should turn off DAMON, restart it, and wait for at least 4 more minutes so
that DAMON can find the cold memory regions, even though DAMON was knowing
there are regions that not accessed for 4 mins at the time of shutdown.

This commit makes DAMON sysfs interface to support online DAMON input
parameters updates by adding a new input keyword for the 'state' DAMON
sysfs file, 'commit'.  Writing the keyword to the 'state' file while the
corresponding kdamond is running makes the kdamond to read the sysfs file
values again and update the DAMON context.

Link: https://lkml.kernel.org/r/20220429160606.127307-12-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   99 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 90 insertions(+), 9 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-support-online-inputs-update
+++ a/mm/damon/sysfs.c
@@ -2061,6 +2061,8 @@ enum damon_sysfs_cmd {
 	DAMON_SYSFS_CMD_ON,
 	/* @DAMON_SYSFS_CMD_OFF: Turn the kdamond off. */
 	DAMON_SYSFS_CMD_OFF,
+	/* @DAMON_SYSFS_CMD_COMMIT: Update kdamond inputs. */
+	DAMON_SYSFS_CMD_COMMIT,
 	/*
 	 * @DAMON_SYSFS_CMD_UPDATE_SCHEMES_STATS: Update scheme stats sysfs
 	 * files.
@@ -2076,6 +2078,7 @@ enum damon_sysfs_cmd {
 static const char * const damon_sysfs_cmd_strs[] = {
 	"on",
 	"off",
+	"commit",
 	"update_schemes_stats",
 };
 
@@ -2195,6 +2198,39 @@ destroy_targets_out:
 	return err;
 }
 
+/*
+ * Search a target in a context that corresponds to the sysfs target input.
+ *
+ * Return: pointer to the target if found, NULL if not found, or negative
+ * error code if the search failed.
+ */
+static struct damon_target *damon_sysfs_existing_target(
+		struct damon_sysfs_target *sys_target, struct damon_ctx *ctx)
+{
+	struct pid *pid;
+	struct damon_target *t;
+
+	if (ctx->ops.id == DAMON_OPS_PADDR) {
+		/* Up to only one target for paddr could exist */
+		damon_for_each_target(t, ctx)
+			return t;
+		return NULL;
+	}
+
+	/* ops.id should be DAMON_OPS_VADDR or DAMON_OPS_FVADDR */
+	pid = find_get_pid(sys_target->pid);
+	if (!pid)
+		return ERR_PTR(-EINVAL);
+	damon_for_each_target(t, ctx) {
+		if (t->pid == pid) {
+			put_pid(pid);
+			return t;
+		}
+	}
+	put_pid(pid);
+	return NULL;
+}
+
 static int damon_sysfs_set_targets(struct damon_ctx *ctx,
 		struct damon_sysfs_targets *sysfs_targets)
 {
@@ -2205,8 +2241,15 @@ static int damon_sysfs_set_targets(struc
 		return -EINVAL;
 
 	for (i = 0; i < sysfs_targets->nr; i++) {
-		err = damon_sysfs_add_target(
-				sysfs_targets->targets_arr[i], ctx);
+		struct damon_sysfs_target *st = sysfs_targets->targets_arr[i];
+		struct damon_target *t = damon_sysfs_existing_target(st, ctx);
+
+		if (IS_ERR(t))
+			return PTR_ERR(t);
+		if (!t)
+			err = damon_sysfs_add_target(st, ctx);
+		else
+			err = damon_sysfs_set_regions(t, st->regions);
 		if (err)
 			return err;
 	}
@@ -2309,6 +2352,48 @@ static int damon_sysfs_upd_schemes_stats
 	return 0;
 }
 
+static inline bool damon_sysfs_kdamond_running(
+		struct damon_sysfs_kdamond *kdamond)
+{
+	return kdamond->damon_ctx &&
+		damon_sysfs_ctx_running(kdamond->damon_ctx);
+}
+
+/*
+ * damon_sysfs_commit_input() - Commit user inputs to a running kdamond.
+ * @kdamond:	The kobject wrapper for the associated kdamond.
+ *
+ * If the sysfs input is wrong, the kdamond will be terminated.
+ */
+static int damon_sysfs_commit_input(struct damon_sysfs_kdamond *kdamond)
+{
+	struct damon_ctx *ctx = kdamond->damon_ctx;
+	struct damon_sysfs_context *sys_ctx;
+	int err = 0;
+
+	if (!damon_sysfs_kdamond_running(kdamond))
+		return -EINVAL;
+	/* TODO: Support multiple contexts per kdamond */
+	if (kdamond->contexts->nr != 1)
+		return -EINVAL;
+
+	sys_ctx = kdamond->contexts->contexts_arr[0];
+
+	err = damon_select_ops(ctx, sys_ctx->ops_id);
+	if (err)
+		return err;
+	err = damon_sysfs_set_attrs(ctx, sys_ctx->attrs);
+	if (err)
+		return err;
+	err = damon_sysfs_set_targets(ctx, sys_ctx->targets);
+	if (err)
+		return err;
+	err = damon_sysfs_set_schemes(ctx, sys_ctx->schemes);
+	if (err)
+		return err;
+	return err;
+}
+
 /*
  * damon_sysfs_cmd_request_callback() - DAMON callback for handling requests.
  * @c:	The DAMON context of the callback.
@@ -2331,6 +2416,9 @@ static int damon_sysfs_cmd_request_callb
 	case DAMON_SYSFS_CMD_UPDATE_SCHEMES_STATS:
 		err = damon_sysfs_upd_schemes_stats(kdamond);
 		break;
+	case DAMON_SYSFS_CMD_COMMIT:
+		err = damon_sysfs_commit_input(kdamond);
+		break;
 	default:
 		break;
 	}
@@ -2415,13 +2503,6 @@ static int damon_sysfs_turn_damon_off(st
 	 */
 }
 
-static inline bool damon_sysfs_kdamond_running(
-		struct damon_sysfs_kdamond *kdamond)
-{
-	return kdamond->damon_ctx &&
-		damon_sysfs_ctx_running(kdamond->damon_ctx);
-}
-
 /*
  * damon_sysfs_handle_cmd() - Handle a command for a specific kdamond.
  * @cmd:	The command to handle.
_

Patches currently in -mm which might be from sj@kernel.org are


