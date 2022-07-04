Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D184EC433EF
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:09:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiGDBJh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbiGDBJd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:09:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C4646271
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:09:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1647B80CF1
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:09:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C02C341C6;
        Mon,  4 Jul 2022 01:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656896970;
        bh=PHY9RKF2uncgou4bvZRQc972k5wvGmsnaiC1RuzwD0w=;
        h=Date:To:From:Subject:From;
        b=AkGd6tR2D4JyfOgXj8NMc4ZbHbGWP3OlrMysDXxWb2rk43sXys1dNnoCPAlClB7Qw
         SCar+jVvs9Rt4gA96Vxr2JesANug8XpUFxYwz8elEaDuXZ30qOZUl41cPS+x3Sp7K/
         ZXoClpzDCM4dyEWvhOGFnUvjakESUXKNN2JWa5f8=
Date:   Sun, 03 Jul 2022 18:09:29 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-dbgfssysfs-move-target_has_pid-from-dbgfs-to-damonh.patch removed from -mm tree
Message-Id: <20220704010930.62C02C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/{dbgfs,sysfs}: move target_has_pid() from dbgfs to damon.h
has been removed from the -mm tree.  Its filename was
     mm-damon-dbgfssysfs-move-target_has_pid-from-dbgfs-to-damonh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/{dbgfs,sysfs}: move target_has_pid() from dbgfs to damon.h
Date: Mon, 6 Jun 2022 18:23:06 +0000

The function for knowing if given monitoring context's targets will have
pid or not is defined and used in dbgfs only.  However, the logic is also
needed for sysfs.  This commit moves the code to damon.h and makes both
dbgfs and sysfs to use it.

Link: https://lkml.kernel.org/r/20220606182310.48781-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    6 ++++++
 mm/damon/dbgfs.c      |   15 +++++----------
 mm/damon/sysfs.c      |    8 +++-----
 3 files changed, 14 insertions(+), 15 deletions(-)

--- a/include/linux/damon.h~mm-damon-dbgfssysfs-move-target_has_pid-from-dbgfs-to-damonh
+++ a/include/linux/damon.h
@@ -525,6 +525,12 @@ bool damon_is_registered_ops(enum damon_
 int damon_register_ops(struct damon_operations *ops);
 int damon_select_ops(struct damon_ctx *ctx, enum damon_ops_id id);
 
+static inline bool damon_target_has_pid(const struct damon_ctx *ctx)
+{
+	return ctx->ops.id == DAMON_OPS_VADDR || ctx->ops.id == DAMON_OPS_FVADDR;
+}
+
+
 int damon_start(struct damon_ctx **ctxs, int nr_ctxs, bool exclusive);
 int damon_stop(struct damon_ctx **ctxs, int nr_ctxs);
 
--- a/mm/damon/dbgfs.c~mm-damon-dbgfssysfs-move-target_has_pid-from-dbgfs-to-damonh
+++ a/mm/damon/dbgfs.c
@@ -275,11 +275,6 @@ out:
 	return ret;
 }
 
-static inline bool target_has_pid(const struct damon_ctx *ctx)
-{
-	return ctx->ops.id == DAMON_OPS_VADDR;
-}
-
 static ssize_t sprint_target_ids(struct damon_ctx *ctx, char *buf, ssize_t len)
 {
 	struct damon_target *t;
@@ -288,7 +283,7 @@ static ssize_t sprint_target_ids(struct
 	int rc;
 
 	damon_for_each_target(t, ctx) {
-		if (target_has_pid(ctx))
+		if (damon_target_has_pid(ctx))
 			/* Show pid numbers to debugfs users */
 			id = pid_vnr(t->pid);
 		else
@@ -415,7 +410,7 @@ static int dbgfs_set_targets(struct damo
 	struct damon_target *t, *next;
 
 	damon_for_each_target_safe(t, next, ctx) {
-		if (target_has_pid(ctx))
+		if (damon_target_has_pid(ctx))
 			put_pid(t->pid);
 		damon_destroy_target(t);
 	}
@@ -425,11 +420,11 @@ static int dbgfs_set_targets(struct damo
 		if (!t) {
 			damon_for_each_target_safe(t, next, ctx)
 				damon_destroy_target(t);
-			if (target_has_pid(ctx))
+			if (damon_target_has_pid(ctx))
 				dbgfs_put_pids(pids, nr_targets);
 			return -ENOMEM;
 		}
-		if (target_has_pid(ctx))
+		if (damon_target_has_pid(ctx))
 			t->pid = pids[i];
 		damon_add_target(ctx, t);
 	}
@@ -722,7 +717,7 @@ static void dbgfs_before_terminate(struc
 {
 	struct damon_target *t, *next;
 
-	if (!target_has_pid(ctx))
+	if (!damon_target_has_pid(ctx))
 		return;
 
 	mutex_lock(&ctx->kdamond_lock);
--- a/mm/damon/sysfs.c~mm-damon-dbgfssysfs-move-target_has_pid-from-dbgfs-to-damonh
+++ a/mm/damon/sysfs.c
@@ -2136,8 +2136,7 @@ static void damon_sysfs_destroy_targets(
 	struct damon_target *t, *next;
 
 	damon_for_each_target_safe(t, next, ctx) {
-		if (ctx->ops.id == DAMON_OPS_VADDR ||
-				ctx->ops.id == DAMON_OPS_FVADDR)
+		if (damon_target_has_pid(ctx))
 			put_pid(t->pid);
 		damon_destroy_target(t);
 	}
@@ -2181,8 +2180,7 @@ static int damon_sysfs_add_target(struct
 
 	if (!t)
 		return -ENOMEM;
-	if (ctx->ops.id == DAMON_OPS_VADDR ||
-			ctx->ops.id == DAMON_OPS_FVADDR) {
+	if (damon_target_has_pid(ctx)) {
 		t->pid = find_get_pid(sys_target->pid);
 		if (!t->pid)
 			goto destroy_targets_out;
@@ -2210,7 +2208,7 @@ static struct damon_target *damon_sysfs_
 	struct pid *pid;
 	struct damon_target *t;
 
-	if (ctx->ops.id == DAMON_OPS_PADDR) {
+	if (!damon_target_has_pid(ctx)) {
 		/* Up to only one target for paddr could exist */
 		damon_for_each_target(t, ctx)
 			return t;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-reclaim-deduplicate-commit_inputs-handling.patch
mm-damon-sysfs-deduplicate-inputs-applying.patch
mm-damon-reclaim-make-enabled-checking-timer-simpler.patch
mm-damon-reclaim-add-damon_reclaim_-prefix-to-enabled_store.patch
mm-damon-dbgfs-add-and-use-mappings-between-schemes-action-inputs-and-damos_action-values.patch
mm-damon-paddr-use-a-separate-function-for-damos_pageout-handling.patch
mm-damon-schemes-add-lru_prio-damos-action.patch
docs-admin-guide-damon-sysfs-document-lru_prio-scheme-action.patch
mm-damon-schemes-add-lru_deprio-action.patch
docs-admin-guide-damon-sysfs-document-lru_deprio-scheme-action.patch
mm-damon-introduce-damon-based-lru-lists-sorting.patch
docs-admin-guide-damon-add-a-document-for-damon_lru_sort.patch

