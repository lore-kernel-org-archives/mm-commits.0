Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7A52C25B45
	for <mm-commits@archiver.kernel.org>; Mon, 23 Oct 2023 18:23:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjJWSXb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 23 Oct 2023 14:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjJWSXa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 23 Oct 2023 14:23:30 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 785DB8F;
        Mon, 23 Oct 2023 11:23:28 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12445C433C7;
        Mon, 23 Oct 2023 18:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698085408;
        bh=eXLFHZNewMlXoMAyULSmHBmujAuFbjNIQiDPe5fJi5Q=;
        h=Date:To:From:Subject:From;
        b=dPpIX/fpiHQ2QwAMtgkAH/YsTv7Mrdwmosv7xfjhHlCCW0P9sIOA36sEY8mk39kuN
         MGDWzUmoo0S4yTEeuoJpJ8Php9xZ8xWVOIXm7efN1rZ72ZkTuNJcgrlXT1W5M6Kp4s
         HieIyPMQtpsHMMWMfjf0/q/4INAffD+rW4wjW2y4=
Date:   Mon, 23 Oct 2023 11:23:27 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        brendanhiggins@google.com, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-remove-requested-targets-when-online-commit-inputs.patch added to mm-hotfixes-unstable branch
Message-Id: <20231023182328.12445C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs: remove requested targets when online-commit inputs
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-sysfs-remove-requested-targets-when-online-commit-inputs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-remove-requested-targets-when-online-commit-inputs.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

Link: https://lkml.kernel.org/r/20231022210735.46409-2-sj@kernel.org
Fixes: da87878010e5 ("mm/damon/sysfs: support online inputs update")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: <stable@vger.kernel.org>	[5.19.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   48 +++++++--------------------------------------
 1 file changed, 8 insertions(+), 40 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-remove-requested-targets-when-online-commit-inputs
+++ a/mm/damon/sysfs.c
@@ -1150,58 +1150,26 @@ destroy_targets_out:
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
-{
-	struct pid *pid;
-	struct damon_target *t;
-
-	if (!damon_target_has_pid(ctx)) {
-		/* Up to only one target for paddr could exist */
-		damon_for_each_target(t, ctx)
-			return t;
-		return NULL;
-	}
-
-	/* ops.id should be DAMON_OPS_VADDR or DAMON_OPS_FVADDR */
-	pid = find_get_pid(sys_target->pid);
-	if (!pid)
-		return ERR_PTR(-EINVAL);
-	damon_for_each_target(t, ctx) {
-		if (t->pid == pid) {
-			put_pid(pid);
-			return t;
-		}
-	}
-	put_pid(pid);
-	return NULL;
-}
-
 static int damon_sysfs_set_targets(struct damon_ctx *ctx,
 		struct damon_sysfs_targets *sysfs_targets)
 {
+	struct damon_target *t, *next;
 	int i, err;
 
 	/* Multiple physical address space monitoring targets makes no sense */
 	if (ctx->ops.id == DAMON_OPS_PADDR && sysfs_targets->nr > 1)
 		return -EINVAL;
 
+	damon_for_each_target_safe(t, next, ctx) {
+		if (damon_target_has_pid(ctx))
+			put_pid(t->pid);
+		damon_destroy_target(t);
+	}
+
 	for (i = 0; i < sysfs_targets->nr; i++) {
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

mm-damon-implement-a-function-for-max-nr_accesses-safe-calculation.patch
mm-damon-core-avoid-divide-by-zero-during-monitoring-results-update.patch
mm-damon-ops-common-avoid-divide-by-zero-during-region-hotness-calculation.patch
mm-damon-lru_sort-avoid-divide-by-zero-in-hot-threshold-calculation.patch
mm-damon-sysfs-remove-requested-targets-when-online-commit-inputs.patch
mm-damon-core-avoid-divide-by-zero-from-pseudo-moving-window-length-calculation.patch
mm-damon-sysfs-test-add-a-unit-test-for-damon_sysfs_set_targets.patch

