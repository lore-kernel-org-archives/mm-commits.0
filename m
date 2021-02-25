Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2B20C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:17:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 684B764F33
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:17:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234492AbhBYTQ4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:16:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:57324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233848AbhBYTOy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:14:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA97164F31;
        Thu, 25 Feb 2021 19:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280299;
        bh=wM2sR7aCjJ/tYOHukMKR/J9+256ybVsDnRtBHERrpO4=;
        h=Date:From:To:Subject:From;
        b=JzNjEnl1eHD/Oln5J6wlUSRrugrr2xgY5+U3Jr0PTrAClmKqWhto70zKh4XnaajzF
         L8WDSzDxSmgdlyzHaIAuk18b9FTtlyodOI7FVunzGdkmv4EC1d2a7BxEdR85exCuiD
         gV0s0LbkFGVoTHh48UHNB6if1k2x74av1Fmm1CLs=
Date:   Thu, 25 Feb 2021 11:11:38 -0800
From:   akpm@linux-foundation.org
To:     abaci@linux.alibaba.com, gechangwei@live.cn, ghe@suse.com,
        jiapeng.chong@linux.alibaba.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com
Subject:  [merged]
 ocfs2-simplify-the-calculation-of-variables.patch removed from -mm tree
Message-ID: <20210225191138.xTixtPLJj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: simplify the calculation of variables
has been removed from the -mm tree.  Its filename was
     ocfs2-simplify-the-calculation-of-variables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: ocfs2: simplify the calculation of variables

Fix the following coccicheck warnings:

./fs/ocfs2/refcounttree.c:981:16-18: WARNING !A || A && B is equivalent
to !A || B.

Link: https://lkml.kernel.org/r/1612235424-80367-1-git-send-email-jiapeng.chong@linux.alibaba.com
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/refcounttree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/refcounttree.c~ocfs2-simplify-the-calculation-of-variables
+++ a/fs/ocfs2/refcounttree.c
@@ -978,7 +978,7 @@ static int ocfs2_get_refcount_cpos_end(s
 		return 0;
 	}
 
-	if (!eb || (eb && !eb->h_next_leaf_blk)) {
+	if (!eb || !eb->h_next_leaf_blk) {
 		/*
 		 * We are the last extent rec, so any high cpos should
 		 * be stored in this leaf refcount block.
_

Patches currently in -mm which might be from jiapeng.chong@linux.alibaba.com are


