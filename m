Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EC6BC4332F
	for <mm-commits@archiver.kernel.org>; Wed,  1 Nov 2023 19:35:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347111AbjKATfq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Nov 2023 15:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345600AbjKATfp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Nov 2023 15:35:45 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E961E12D
        for <mm-commits@vger.kernel.org>; Wed,  1 Nov 2023 12:35:36 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B46BAC116B7;
        Wed,  1 Nov 2023 19:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698867336;
        bh=H00ze1sQcRFOwOu4C7GYCQR+ABr4pK0MPLhkahkU0UQ=;
        h=Date:To:From:Subject:From;
        b=tlVPTdzZ4raKYFG9LbFYeCOqO61iGylN1aZcOhGIQtPxXvJxnbA2X0CK0l5tjHKE/
         cJMQQ7zne2H0UGBWecm1/JglZPzXJ/JTz3SNjMFblUmntt9qT4Lia5vyj0tq4UMdXs
         cXCFHgMsOtc+D5fJJQybg7J8Bctk+botGgGIoAnI=
Date:   Wed, 01 Nov 2023 12:35:34 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-damon-sysfs-remove-requested-targets-when-online-commit-inputs-fix.patch removed from -mm tree
Message-Id: <20231101193536.B46BAC116B7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs: fix unnecessary monitoring results removal when online-commit inputs
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-remove-requested-targets-when-online-commit-inputs-fix.patch

This patch was dropped because it was folded into mm-damon-sysfs-remove-requested-targets-when-online-commit-inputs.patch

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: fix unnecessary monitoring results removal when online-commit inputs
Date: Sat, 28 Oct 2023 21:33:53 +0000

Commit db27869df6ed ("mm/damon/sysfs: remove requested targets when
online-commit inputs") of mm-hotfixes-unstable tree[1] makes all targets
to removed and then added again based on the user input, for online-commit
inputs.  The commit says it is inefficient but ok as below:

    This could cause unnecessary memory dealloc and realloc operations,
    but this is not a hot code path.  Also, note that damon_target is
    stateless, and hence no data is lost

But that's not true.  'struct target' is containing the monitoring results
('->regions_list').  As a result, the patch makes all previous monitoring
results to be removed for every online-commit inputs.  Fix it by removing
targets only when really changed or removal is requested.

[1] https://lore.kernel.org/damon/20231022210735.46409-2-sj@kernel.org/

Link: https://lkml.kernel.org/r/20231028213353.45397-1-sj@kernel.org
Fixes: db27869df6ed ("mm/damon/sysfs: remove requested targets when online-commit inputs") # mm-hotfixes-unstable
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   44 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 39 insertions(+), 5 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-remove-requested-targets-when-online-commit-inputs-fix
+++ a/mm/damon/sysfs.c
@@ -1150,23 +1150,57 @@ destroy_targets_out:
 	return err;
 }
 
+static int damon_sysfs_update_target(struct damon_target *target,
+		struct damon_ctx *ctx,
+		struct damon_sysfs_target *sys_target)
+{
+	struct pid *pid;
+	struct damon_region *r, *next;
+
+	if (!damon_target_has_pid(ctx))
+		return 0;
+
+	pid = find_get_pid(sys_target->pid);
+	if (!pid)
+		return -EINVAL;
+
+	/* no change to the target */
+	if (pid == target->pid) {
+		put_pid(pid);
+		return 0;
+	}
+
+	/* remove old monitoring results and update the target's pid */
+	damon_for_each_region_safe(r, next, target)
+		damon_destroy_region(r, target);
+	put_pid(target->pid);
+	target->pid = pid;
+	return 0;
+}
+
 static int damon_sysfs_set_targets(struct damon_ctx *ctx,
 		struct damon_sysfs_targets *sysfs_targets)
 {
 	struct damon_target *t, *next;
-	int i, err;
+	int i = 0, err;
 
 	/* Multiple physical address space monitoring targets makes no sense */
 	if (ctx->ops.id == DAMON_OPS_PADDR && sysfs_targets->nr > 1)
 		return -EINVAL;
 
 	damon_for_each_target_safe(t, next, ctx) {
-		if (damon_target_has_pid(ctx))
-			put_pid(t->pid);
-		damon_destroy_target(t);
+		if (i < sysfs_targets->nr) {
+			damon_sysfs_update_target(t, ctx,
+					sysfs_targets->targets_arr[i]);
+		} else {
+			if (damon_target_has_pid(ctx))
+				put_pid(t->pid);
+			damon_destroy_target(t);
+		}
+		i++;
 	}
 
-	for (i = 0; i < sysfs_targets->nr; i++) {
+	for (; i < sysfs_targets->nr; i++) {
 		struct damon_sysfs_target *st = sysfs_targets->targets_arr[i];
 
 		err = damon_sysfs_add_target(st, ctx);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-remove-requested-targets-when-online-commit-inputs.patch
mm-damon-sysfs-update-monitoring-target-regions-for-online-input-commit.patch

