Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7E3BC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:34:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353647AbiCYBgJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354709AbiCYBfb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3ABA17E15
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:33:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D283160909
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:33:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34487C340F1;
        Fri, 25 Mar 2022 01:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171990;
        bh=48FGZ/o00AzCKhj5ScR6nFyE5RvUwU8xvmKskUWVTeg=;
        h=Date:To:From:Subject:From;
        b=dIMNl7PGNQjWgJfNwvrWAiddOGF4god18Ru09/Yl08pBoKSL1tKsNvIojNwedGAzt
         PvfW+ZRdgRoSqul1HcJz7jyM6RTSz7zyFW0SMGUy+Tp7RxKPMMWLJXtSPlqbSasvTI
         2UpEngLgX92+KfMtLIvtncka6fVBWb4yL/M2EVxs=
Date:   Thu, 24 Mar 2022 18:33:09 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-damon-core-move-damon_set_targets-into-dbgfs.patch removed from -mm tree
Message-Id: <20220325013310.34487C340F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: move damon_set_targets() into dbgfs
has been removed from the -mm tree.  Its filename was
     mm-damon-core-move-damon_set_targets-into-dbgfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: move damon_set_targets() into dbgfs

damon_set_targets() function is defined in the core for general use cases,
but called from only dbgfs.  Also, because the function is for general use
cases, dbgfs does additional handling of pid type target id case.  To make
the situation simpler, this commit moves the function into dbgfs and makes
it to do the pid type case handling on its own.

Link: https://lkml.kernel.org/r/20211230100723.2238-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    2 -
 mm/damon/core-test.h  |    5 +++
 mm/damon/core.c       |   32 ------------------------
 mm/damon/dbgfs-test.h |   14 +++++-----
 mm/damon/dbgfs.c      |   53 ++++++++++++++++++++++++++++++----------
 5 files changed, 52 insertions(+), 54 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-move-damon_set_targets-into-dbgfs
+++ a/include/linux/damon.h
@@ -484,8 +484,6 @@ unsigned int damon_nr_regions(struct dam
 
 struct damon_ctx *damon_new_ctx(void);
 void damon_destroy_ctx(struct damon_ctx *ctx);
-int damon_set_targets(struct damon_ctx *ctx,
-		unsigned long *ids, ssize_t nr_ids);
 int damon_set_attrs(struct damon_ctx *ctx, unsigned long sample_int,
 		unsigned long aggr_int, unsigned long primitive_upd_int,
 		unsigned long min_nr_reg, unsigned long max_nr_reg);
--- a/mm/damon/core.c~mm-damon-core-move-damon_set_targets-into-dbgfs
+++ a/mm/damon/core.c
@@ -246,38 +246,6 @@ void damon_destroy_ctx(struct damon_ctx
 }
 
 /**
- * damon_set_targets() - Set monitoring targets.
- * @ctx:	monitoring context
- * @ids:	array of target ids
- * @nr_ids:	number of entries in @ids
- *
- * This function should not be called while the kdamond is running.
- *
- * Return: 0 on success, negative error code otherwise.
- */
-int damon_set_targets(struct damon_ctx *ctx,
-		      unsigned long *ids, ssize_t nr_ids)
-{
-	ssize_t i;
-	struct damon_target *t, *next;
-
-	damon_destroy_targets(ctx);
-
-	for (i = 0; i < nr_ids; i++) {
-		t = damon_new_target(ids[i]);
-		if (!t) {
-			/* The caller should do cleanup of the ids itself */
-			damon_for_each_target_safe(t, next, ctx)
-				damon_destroy_target(t);
-			return -ENOMEM;
-		}
-		damon_add_target(ctx, t);
-	}
-
-	return 0;
-}
-
-/**
  * damon_set_attrs() - Set attributes for the monitoring.
  * @ctx:		monitoring context
  * @sample_int:		time interval between samplings
--- a/mm/damon/core-test.h~mm-damon-core-move-damon_set_targets-into-dbgfs
+++ a/mm/damon/core-test.h
@@ -86,7 +86,10 @@ static void damon_test_aggregate(struct
 	struct damon_region *r;
 	int it, ir;
 
-	damon_set_targets(ctx, target_ids, 3);
+	for (it = 0; it < 3; it++) {
+		t = damon_new_target(target_ids[it]);
+		damon_add_target(ctx, t);
+	}
 
 	it = 0;
 	damon_for_each_target(t, ctx) {
--- a/mm/damon/dbgfs.c~mm-damon-core-move-damon_set_targets-into-dbgfs
+++ a/mm/damon/dbgfs.c
@@ -358,11 +358,48 @@ static void dbgfs_put_pids(unsigned long
 		put_pid((struct pid *)ids[i]);
 }
 
+/*
+ * dbgfs_set_targets() - Set monitoring targets.
+ * @ctx:	monitoring context
+ * @ids:	array of target ids
+ * @nr_ids:	number of entries in @ids
+ *
+ * This function should not be called while the kdamond is running.
+ *
+ * Return: 0 on success, negative error code otherwise.
+ */
+static int dbgfs_set_targets(struct damon_ctx *ctx,
+		      unsigned long *ids, ssize_t nr_ids)
+{
+	ssize_t i;
+	struct damon_target *t, *next;
+
+	damon_for_each_target_safe(t, next, ctx) {
+		if (targetid_is_pid(ctx))
+			put_pid((struct pid *)t->id);
+		damon_destroy_target(t);
+	}
+
+	for (i = 0; i < nr_ids; i++) {
+		t = damon_new_target(ids[i]);
+		if (!t) {
+			/* The caller should do cleanup of the ids itself */
+			damon_for_each_target_safe(t, next, ctx)
+				damon_destroy_target(t);
+			if (targetid_is_pid(ctx))
+				dbgfs_put_pids(ids, nr_ids);
+			return -ENOMEM;
+		}
+		damon_add_target(ctx, t);
+	}
+
+	return 0;
+}
+
 static ssize_t dbgfs_target_ids_write(struct file *file,
 		const char __user *buf, size_t count, loff_t *ppos)
 {
 	struct damon_ctx *ctx = file->private_data;
-	struct damon_target *t, *next_t;
 	bool id_is_pid = true;
 	char *kbuf;
 	unsigned long *targets;
@@ -407,11 +444,7 @@ static ssize_t dbgfs_target_ids_write(st
 	}
 
 	/* remove previously set targets */
-	damon_for_each_target_safe(t, next_t, ctx) {
-		if (targetid_is_pid(ctx))
-			put_pid((struct pid *)t->id);
-		damon_destroy_target(t);
-	}
+	dbgfs_set_targets(ctx, NULL, 0);
 
 	/* Configure the context for the address space type */
 	if (id_is_pid)
@@ -419,13 +452,9 @@ static ssize_t dbgfs_target_ids_write(st
 	else
 		damon_pa_set_primitives(ctx);
 
-	ret = damon_set_targets(ctx, targets, nr_targets);
-	if (ret) {
-		if (id_is_pid)
-			dbgfs_put_pids(targets, nr_targets);
-	} else {
+	ret = dbgfs_set_targets(ctx, targets, nr_targets);
+	if (!ret)
 		ret = count;
-	}
 
 unlock_out:
 	mutex_unlock(&ctx->kdamond_lock);
--- a/mm/damon/dbgfs-test.h~mm-damon-core-move-damon_set_targets-into-dbgfs
+++ a/mm/damon/dbgfs-test.h
@@ -86,23 +86,23 @@ static void damon_dbgfs_test_set_targets
 	ctx->primitive.target_valid = NULL;
 	ctx->primitive.cleanup = NULL;
 
-	damon_set_targets(ctx, ids, 3);
+	dbgfs_set_targets(ctx, ids, 3);
 	sprint_target_ids(ctx, buf, 64);
 	KUNIT_EXPECT_STREQ(test, (char *)buf, "1 2 3\n");
 
-	damon_set_targets(ctx, NULL, 0);
+	dbgfs_set_targets(ctx, NULL, 0);
 	sprint_target_ids(ctx, buf, 64);
 	KUNIT_EXPECT_STREQ(test, (char *)buf, "\n");
 
-	damon_set_targets(ctx, (unsigned long []){1, 2}, 2);
+	dbgfs_set_targets(ctx, (unsigned long []){1, 2}, 2);
 	sprint_target_ids(ctx, buf, 64);
 	KUNIT_EXPECT_STREQ(test, (char *)buf, "1 2\n");
 
-	damon_set_targets(ctx, (unsigned long []){2}, 1);
+	dbgfs_set_targets(ctx, (unsigned long []){2}, 1);
 	sprint_target_ids(ctx, buf, 64);
 	KUNIT_EXPECT_STREQ(test, (char *)buf, "2\n");
 
-	damon_set_targets(ctx, NULL, 0);
+	dbgfs_set_targets(ctx, NULL, 0);
 	sprint_target_ids(ctx, buf, 64);
 	KUNIT_EXPECT_STREQ(test, (char *)buf, "\n");
 
@@ -130,7 +130,7 @@ static void damon_dbgfs_test_set_init_re
 	int i, rc;
 	char buf[256];
 
-	damon_set_targets(ctx, ids, 3);
+	dbgfs_set_targets(ctx, ids, 3);
 
 	/* Put valid inputs and check the results */
 	for (i = 0; i < ARRAY_SIZE(valid_inputs); i++) {
@@ -158,7 +158,7 @@ static void damon_dbgfs_test_set_init_re
 		KUNIT_EXPECT_STREQ(test, (char *)buf, "");
 	}
 
-	damon_set_targets(ctx, NULL, 0);
+	dbgfs_set_targets(ctx, NULL, 0);
 	damon_destroy_ctx(ctx);
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are


