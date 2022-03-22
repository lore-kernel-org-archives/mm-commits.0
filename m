Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1378C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:49:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236754AbiCVVu1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236898AbiCVVuT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:50:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B082CC8E
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:48:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39D52B81DAB
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:48:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC583C340EC;
        Tue, 22 Mar 2022 21:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985718;
        bh=jw/fBqUkG5Pq/0ljg8vcqTguNFMMKBtQvzYQTgtUBSA=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=h6DMSV/mPmk2lHVVYcGrkABLh3N5iNrbJIspXKMjuNipGmYNfHA++GT+Jdc/NQnyg
         m3Fzc6vQ6qZastql3JniDJOx2/q2ix1Mzv4OMWiQGx22QmYT1RoO+MV9N6fwTYLlxV
         P5eF8yiX3SvqKe1YyML+jorxrLwpIrNnd7jDrwgA=
Date:   Tue, 22 Mar 2022 14:48:37 -0700
To:     sj@kernel.org, akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 199/227] mm/damon/core: move damon_set_targets() into dbgfs
Message-Id: <20220322214837.EC583C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
