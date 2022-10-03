Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28C0AC433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:14:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiJCVOT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbiJCVLj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:11:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C90E1AD89
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:07:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19CDA611EC
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:07:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71736C433D6;
        Mon,  3 Oct 2022 21:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831258;
        bh=O+jPAu585h4RG2FcqtkImNYrL+1ZEqtzrGwvadEI1pA=;
        h=Date:To:From:Subject:From;
        b=wc7/hus20iz4L5ZdTFUSzYYySPQqaCyt05M/pST8MF/0/X0Vw5zpTodPeUiMyHwIh
         WvtCWR3Sw7XSUWRhhrEAteMp9co9gPmdqEFgtsqSDvWke7fOPnFqIr+8Wv9EWxRyou
         ApgSigkEnDqAQ5z7M3UwnQcSq0zgc1gqfN+tCj5w=
Date:   Mon, 03 Oct 2022 14:07:37 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, kaixuxia@tencent.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-simplify-the-variable-pid-assignment-operation.patch removed from -mm tree
Message-Id: <20221003210738.71736C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs: simplify the variable 'pid' assignment operation
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-simplify-the-variable-pid-assignment-operation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kaixu Xia <kaixuxia@tencent.com>
Subject: mm/damon/sysfs: simplify the variable 'pid' assignment operation
Date: Tue, 13 Sep 2022 17:11:25 +0800

We can initialize the variable 'pid' with '-1' in pid_show() to simplify
the variable assignment operation and make the code more readable.

Link: https://lkml.kernel.org/r/1663060287-30201-3-git-send-email-kaixuxia@tencent.com
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-simplify-the-variable-pid-assignment-operation
+++ a/mm/damon/sysfs.c
@@ -2592,19 +2592,16 @@ static ssize_t pid_show(struct kobject *
 	struct damon_sysfs_kdamond *kdamond = container_of(kobj,
 			struct damon_sysfs_kdamond, kobj);
 	struct damon_ctx *ctx;
-	int pid;
+	int pid = -1;
 
 	if (!mutex_trylock(&damon_sysfs_lock))
 		return -EBUSY;
 	ctx = kdamond->damon_ctx;
-	if (!ctx) {
-		pid = -1;
+	if (!ctx)
 		goto out;
-	}
+
 	mutex_lock(&ctx->kdamond_lock);
-	if (!ctx->kdamond)
-		pid = -1;
-	else
+	if (ctx->kdamond)
 		pid = ctx->kdamond->pid;
 	mutex_unlock(&ctx->kdamond_lock);
 out:
_

Patches currently in -mm which might be from kaixuxia@tencent.com are


