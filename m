Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67DB8ECAAA1
	for <mm-commits@archiver.kernel.org>; Mon,  5 Sep 2022 22:15:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbiIEWPY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Sep 2022 18:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiIEWPX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Sep 2022 18:15:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 770D53DBE4
        for <mm-commits@vger.kernel.org>; Mon,  5 Sep 2022 15:15:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12A9A60CD4
        for <mm-commits@vger.kernel.org>; Mon,  5 Sep 2022 22:15:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56B4EC433C1;
        Mon,  5 Sep 2022 22:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662416121;
        bh=tvDmoqB2ExWFFX309PaZdcu+/IWramMVdmHkkT/8RbU=;
        h=Date:To:From:Subject:From;
        b=W4+VVWD27jG3MfGAYzp4+kxE+pXa+Pnw6tARfdMuZ8A77Lnl7q06LEOgEdqL9s1Je
         j1nxyYK1vFwJ7bk1PXVwfzqioQLcelOsoLYq/1vwu51melf5z1vI14Gd4JZJL3pc6V
         iHnVoFyQt3iruj5Px06lXHOcTevz09VFJPTkbmy8=
Date:   Mon, 05 Sep 2022 15:15:20 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, kaixuxia@tencent.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-simplify-the-judgement-whether-kdamonds-are-busy.patch added to mm-unstable branch
Message-Id: <20220905221521.56B4EC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs: simplify the judgement whether kdamonds are busy
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-simplify-the-judgement-whether-kdamonds-are-busy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-simplify-the-judgement-whether-kdamonds-are-busy.patch

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
Subject: mm/damon/sysfs: simplify the judgement whether kdamonds are busy
Date: Sun, 4 Sep 2022 22:36:06 +0800

It is unnecessary to get the number of the running kdamond to judge
whether kdamonds are busy.  Here we can use the
damon_sysfs_kdamond_running() helper and return -EBUSY directly when
finding a running kdamond.  Meanwhile, merging with the judgement that a
kdamond has current sysfs command callback request to make the code more
clear.

Link: https://lkml.kernel.org/r/1662302166-13216-1-git-send-email-kaixuxia@tencent.com
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-simplify-the-judgement-whether-kdamonds-are-busy
+++ a/mm/damon/sysfs.c
@@ -2657,23 +2657,18 @@ static void damon_sysfs_kdamonds_rm_dirs
 	kdamonds->kdamonds_arr = NULL;
 }
 
-static int damon_sysfs_nr_running_ctxs(struct damon_sysfs_kdamond **kdamonds,
+static bool damon_sysfs_kdamonds_busy(struct damon_sysfs_kdamond **kdamonds,
 		int nr_kdamonds)
 {
-	int nr_running_ctxs = 0;
 	int i;
 
 	for (i = 0; i < nr_kdamonds; i++) {
-		struct damon_ctx *ctx = kdamonds[i]->damon_ctx;
-
-		if (!ctx)
-			continue;
-		mutex_lock(&ctx->kdamond_lock);
-		if (ctx->kdamond)
-			nr_running_ctxs++;
-		mutex_unlock(&ctx->kdamond_lock);
+		if (damon_sysfs_kdamond_running(kdamonds[i]) ||
+		    damon_sysfs_cmd_request.kdamond == kdamonds[i])
+			return true;
 	}
-	return nr_running_ctxs;
+
+	return false;
 }
 
 static int damon_sysfs_kdamonds_add_dirs(struct damon_sysfs_kdamonds *kdamonds,
@@ -2682,15 +2677,9 @@ static int damon_sysfs_kdamonds_add_dirs
 	struct damon_sysfs_kdamond **kdamonds_arr, *kdamond;
 	int err, i;
 
-	if (damon_sysfs_nr_running_ctxs(kdamonds->kdamonds_arr, kdamonds->nr))
+	if (damon_sysfs_kdamonds_busy(kdamonds->kdamonds_arr, kdamonds->nr))
 		return -EBUSY;
 
-	for (i = 0; i < kdamonds->nr; i++) {
-		if (damon_sysfs_cmd_request.kdamond ==
-				kdamonds->kdamonds_arr[i])
-			return -EBUSY;
-	}
-
 	damon_sysfs_kdamonds_rm_dirs(kdamonds);
 	if (!nr_kdamonds)
 		return 0;
_

Patches currently in -mm which might be from kaixuxia@tencent.com are

mm-damon-core-simplify-the-parameter-passing-for-region-split-operation.patch
mm-damon-simplify-the-parameter-passing-for-check_accesses.patch
mm-damon-vaddr-remove-comparison-between-mm-and-last_mm-when-checking-region-accesses.patch
mm-damon-get-the-hotness-from-damon_hot_score-in-damon_pageout_score.patch
mm-damon-sysfs-simplify-the-judgement-whether-kdamonds-are-busy.patch

