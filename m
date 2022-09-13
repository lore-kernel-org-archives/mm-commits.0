Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB876ECAAD8
	for <mm-commits@archiver.kernel.org>; Tue, 13 Sep 2022 22:15:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbiIMWPA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Sep 2022 18:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiIMWO5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Sep 2022 18:14:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F8636370
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 15:14:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D8FDB810DD
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 22:14:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE746C433C1;
        Tue, 13 Sep 2022 22:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663107291;
        bh=2BcPHjkWiMmOYPGe2Pez7a/fX8kz5I3ETSdDkbhgryM=;
        h=Date:To:From:Subject:From;
        b=QuWNRfCxitgAwYrxd82PLlbiVynDPrfeIixe/wjt/sMBKErRBbo8xrCSlBo7BjUO1
         XCmPwli/lljWRXQIj3ybQSVmc6eYVdumnvhRTwrbHuEL+rnwTk4BVtL0sG3zNiZdBP
         Yr/u51G/TmDYJsKIHVINDifXXKfU3XFlU1bkaxWs=
Date:   Tue, 13 Sep 2022 15:14:50 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, kaixuxia@tencent.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-simplify-the-variable-pid-assignment-operation.patch added to mm-unstable branch
Message-Id: <20220913221450.EE746C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs: simplify the variable 'pid' assignment operation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-simplify-the-variable-pid-assignment-operation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-simplify-the-variable-pid-assignment-operation.patch

This patch will later appear in the mm-unstable branch at
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

mm-damon-sysfs-simplify-the-judgement-whether-kdamonds-are-busy.patch
mm-damon-core-iterate-the-regions-list-from-current-point-in-damon_set_regions.patch
mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme.patch
mm-damon-sysfs-use-the-wrapper-directly-to-check-if-the-kdamond-is-running.patch
mm-damon-simplify-the-parameter-passing-for-prepare_access_checks.patch
mm-damon-sysfs-simplify-the-variable-pid-assignment-operation.patch
mm-damon-core-simplify-the-kdamond-stop-mechanism-by-removing-done.patch
mm-damon-vaddr-indicate-the-target-is-invalid-when-nr_regions-is-zero.patch

