Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6E94C433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:08:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiJCVI0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiJCVGY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:06:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8D4F4D4E1
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B55B611F1
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E15C433C1;
        Mon,  3 Oct 2022 21:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831143;
        bh=M0q2zRP6r+Q6EMJ4xJEf3mxTAcFhwvqkIjoVaycXlh4=;
        h=Date:To:From:Subject:From;
        b=Mn1gUyT088Ttjcwlv0o5hiJ5fL8SiSGUuqt+O+VK6nKGlbTvCX2VwqjhHmJTMImTc
         dte0qJ0DWGsKdQwkfquLjZzVCSfBhUTI4Si50Gjm7aOiT/zI0c8oU8TKDKmQ185Pol
         ger5ySJ+WfK0cbJhOuKNU5ww/GJrYv/Ain7fzt4E=
Date:   Mon, 03 Oct 2022 14:05:43 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, kaixuxia@tencent.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-simplify-the-judgement-whether-kdamonds-are-busy.patch removed from -mm tree
Message-Id: <20221003210543.B5E15C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs: simplify the judgement whether kdamonds are busy
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-simplify-the-judgement-whether-kdamonds-are-busy.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


