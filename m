Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 940C1C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:19:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235833AbiEJEXE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236173AbiEJEUu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C4D393D0
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:15:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 608FB61766
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:15:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B630FC385A6;
        Tue, 10 May 2022 04:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156152;
        bh=2cC6dn6D8vzBmxSt3z1embi5n3oFiNr3mA5OGFH4sF8=;
        h=Date:To:From:Subject:From;
        b=MKfTZperZ5Uc0GdH17gbErHaMfFj41XP/9Fu9IPlCn5OjdHMhk9654GnM7VJlYfL5
         9KhXGVioQBk0PpNTHU63BmFb81gkFZXZPFAB9Ws2u/VfFK5OYQ/X3tVqWSyR4OOASs
         8Q6pfYOB5il6IJLxZlU1BuqPUXgkjsXnHV9dFcKE=
Date:   Mon, 09 May 2022 21:15:52 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-move-targets-setup-code-to-a-separated-function.patch removed from -mm tree
Message-Id: <20220510041552.B630FC385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs: move targets setup code to a separated function
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-move-targets-setup-code-to-a-separated-function.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: move targets setup code to a separated function

This commit separates DAMON sysfs interface's monitoring context targets
setup code to a new function for better readability.

Link: https://lkml.kernel.org/r/20220429160606.127307-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   49 +++++++++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 21 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-move-targets-setup-code-to-a-separated-function
+++ a/mm/damon/sysfs.c
@@ -2120,6 +2120,31 @@ static int damon_sysfs_set_regions(struc
 	return 0;
 }
 
+static int damon_sysfs_add_target(struct damon_sysfs_target *sys_target,
+		struct damon_ctx *ctx)
+{
+	struct damon_target *t = damon_new_target();
+	int err = -EINVAL;
+
+	if (!t)
+		return -ENOMEM;
+	if (ctx->ops.id == DAMON_OPS_VADDR ||
+			ctx->ops.id == DAMON_OPS_FVADDR) {
+		t->pid = find_get_pid(sys_target->pid);
+		if (!t->pid)
+			goto destroy_targets_out;
+	}
+	damon_add_target(ctx, t);
+	err = damon_sysfs_set_regions(t, sys_target->regions);
+	if (err)
+		goto destroy_targets_out;
+	return 0;
+
+destroy_targets_out:
+	damon_sysfs_destroy_targets(ctx);
+	return err;
+}
+
 static int damon_sysfs_set_targets(struct damon_ctx *ctx,
 		struct damon_sysfs_targets *sysfs_targets)
 {
@@ -2130,28 +2155,10 @@ static int damon_sysfs_set_targets(struc
 		return -EINVAL;
 
 	for (i = 0; i < sysfs_targets->nr; i++) {
-		struct damon_sysfs_target *sys_target =
-			sysfs_targets->targets_arr[i];
-		struct damon_target *t = damon_new_target();
-
-		if (!t) {
-			damon_sysfs_destroy_targets(ctx);
-			return -ENOMEM;
-		}
-		if (ctx->ops.id == DAMON_OPS_VADDR ||
-				ctx->ops.id == DAMON_OPS_FVADDR) {
-			t->pid = find_get_pid(sys_target->pid);
-			if (!t->pid) {
-				damon_sysfs_destroy_targets(ctx);
-				return -EINVAL;
-			}
-		}
-		damon_add_target(ctx, t);
-		err = damon_sysfs_set_regions(t, sys_target->regions);
-		if (err) {
-			damon_sysfs_destroy_targets(ctx);
+		err = damon_sysfs_add_target(
+				sysfs_targets->targets_arr[i], ctx);
+		if (err)
 			return err;
-		}
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from sj@kernel.org are


