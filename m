Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 804F9C001B0
	for <mm-commits@archiver.kernel.org>; Wed,  1 Nov 2023 19:39:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345929AbjKATjT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Nov 2023 15:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345943AbjKATjP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Nov 2023 15:39:15 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1233DDA;
        Wed,  1 Nov 2023 12:39:09 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D151C433B6;
        Wed,  1 Nov 2023 19:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698867548;
        bh=e7TqJetW6MdvUug/vphD835ZYOzznqpdxCgTs2gSBHo=;
        h=Date:To:From:Subject:From;
        b=tp+iCL9gokxyzApSZKwdi8s1v8X/0FRDq533RjkzoEda/hJb1qntxl3KtsxiX+8I/
         mbw6kg/vg8yWEcjox6/90ti6BmRVX9lbHtLRF3yHf7baLU/qzxJ4a0xRJv/P0FFqTj
         hXowwTMJu8VOtkL7D/twVq/nrlmieM2xIvQLiOBw=
Date:   Wed, 01 Nov 2023 12:39:06 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        brendanhiggins@google.com, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-remove-requested-targets-when-online-commit-inputs.patch removed from -mm tree
Message-Id: <20231101193908.7D151C433B6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs: remove requested targets when online-commit inputs
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-remove-requested-targets-when-online-commit-inputs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: remove requested targets when online-commit inputs
Date: Sun, 22 Oct 2023 21:07:33 +0000

damon_sysfs_set_targets(), which updates the targets of the context for
online commitment, do not remove targets that removed from the
corresponding sysfs files.  As a result, more than intended targets of the
context can exist and hence consume memory and monitoring CPU resource
more than expected.

Fix it by removing all targets of the context and fill up again using the
user input.  This could cause unnecessary memory dealloc and realloc
operations, but this is not a hot code path.  Also, note that damon_target
is stateless, and hence no data is lost.

[sj@kernel.org: fix unnecessary monitoring results removal]
  Link: https://lkml.kernel.org/r/20231028213353.45397-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20231022210735.46409-2-sj@kernel.org
Fixes: da87878010e5 ("mm/damon/sysfs: support online inputs update")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: <stable@vger.kernel.org>	[5.19.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   68 +++++++++++++++++++++++----------------------
 1 file changed, 35 insertions(+), 33 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-remove-requested-targets-when-online-commit-inputs
+++ a/mm/damon/sysfs.c
@@ -1150,58 +1150,60 @@ destroy_targets_out:
 	return err;
 }
 
-/*
- * Search a target in a context that corresponds to the sysfs target input.
- *
- * Return: pointer to the target if found, NULL if not found, or negative
- * error code if the search failed.
- */
-static struct damon_target *damon_sysfs_existing_target(
-		struct damon_sysfs_target *sys_target, struct damon_ctx *ctx)
+static int damon_sysfs_update_target(struct damon_target *target,
+		struct damon_ctx *ctx,
+		struct damon_sysfs_target *sys_target)
 {
 	struct pid *pid;
-	struct damon_target *t;
+	struct damon_region *r, *next;
 
-	if (!damon_target_has_pid(ctx)) {
-		/* Up to only one target for paddr could exist */
-		damon_for_each_target(t, ctx)
-			return t;
-		return NULL;
-	}
+	if (!damon_target_has_pid(ctx))
+		return 0;
 
-	/* ops.id should be DAMON_OPS_VADDR or DAMON_OPS_FVADDR */
 	pid = find_get_pid(sys_target->pid);
 	if (!pid)
-		return ERR_PTR(-EINVAL);
-	damon_for_each_target(t, ctx) {
-		if (t->pid == pid) {
-			put_pid(pid);
-			return t;
-		}
+		return -EINVAL;
+
+	/* no change to the target */
+	if (pid == target->pid) {
+		put_pid(pid);
+		return 0;
 	}
-	put_pid(pid);
-	return NULL;
+
+	/* remove old monitoring results and update the target's pid */
+	damon_for_each_region_safe(r, next, target)
+		damon_destroy_region(r, target);
+	put_pid(target->pid);
+	target->pid = pid;
+	return 0;
 }
 
 static int damon_sysfs_set_targets(struct damon_ctx *ctx,
 		struct damon_sysfs_targets *sysfs_targets)
 {
-	int i, err;
+	struct damon_target *t, *next;
+	int i = 0, err;
 
 	/* Multiple physical address space monitoring targets makes no sense */
 	if (ctx->ops.id == DAMON_OPS_PADDR && sysfs_targets->nr > 1)
 		return -EINVAL;
 
-	for (i = 0; i < sysfs_targets->nr; i++) {
+	damon_for_each_target_safe(t, next, ctx) {
+		if (i < sysfs_targets->nr) {
+			damon_sysfs_update_target(t, ctx,
+					sysfs_targets->targets_arr[i]);
+		} else {
+			if (damon_target_has_pid(ctx))
+				put_pid(t->pid);
+			damon_destroy_target(t);
+		}
+		i++;
+	}
+
+	for (; i < sysfs_targets->nr; i++) {
 		struct damon_sysfs_target *st = sysfs_targets->targets_arr[i];
-		struct damon_target *t = damon_sysfs_existing_target(st, ctx);
 
-		if (IS_ERR(t))
-			return PTR_ERR(t);
-		if (!t)
-			err = damon_sysfs_add_target(st, ctx);
-		else
-			err = damon_sysfs_set_regions(t, st->regions);
+		err = damon_sysfs_add_target(st, ctx);
 		if (err)
 			return err;
 	}
_

Patches currently in -mm which might be from sj@kernel.org are


