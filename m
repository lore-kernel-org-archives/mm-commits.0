Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F524C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:02:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 126C364F1F
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:02:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235116AbhBXUCb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:02:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:55480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235126AbhBXUCJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:02:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8733764F13;
        Wed, 24 Feb 2021 20:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614196846;
        bh=bPZ87oWzslRoFI8kO/hepKZB4OjSgr0BiEmXwDLybUs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=eyYoNo8cVNdOYefNCQNJ64lgDM69Awt2l+J4a+j9gUvgdeaia32Xk4xprlNfiY94E
         FJQTM1Ndwyy0tHaSjou9gMYhLBxM6hwZ3Aac4rOUDOlTIRmFF5S0w0m69bWUUmI24M
         fRJ/4ZTtvJ9bhtqr0mVUtKZ3Ppic631zyTD3m9AY=
Date:   Wed, 24 Feb 2021 12:00:45 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     abaci@linux.alibaba.com, akpm@linux-foundation.org,
        gechangwei@live.cn, ghe@suse.com, jiapeng.chong@linux.alibaba.com,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, linux-mm@kvack.org, mark@fasheh.com,
        mm-commits@vger.kernel.org, piaojun@huawei.com,
        torvalds@linux-foundation.org
Subject:  [patch 011/173] ocfs2: simplify the calculation of
 variables
Message-ID: <20210224200045.tBGNb2xJQ%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
