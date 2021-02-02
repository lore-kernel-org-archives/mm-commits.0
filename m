Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 699C6C433E6
	for <mm-commits@archiver.kernel.org>; Tue,  2 Feb 2021 19:54:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1852564DC4
	for <mm-commits@archiver.kernel.org>; Tue,  2 Feb 2021 19:54:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238470AbhBBTy1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 Feb 2021 14:54:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:56804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240054AbhBBTxb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Feb 2021 14:53:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8C3464DC4;
        Tue,  2 Feb 2021 19:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612295570;
        bh=pMF+XcixKIuJHTamPxZ5WfvxkyNvk0xDZCXmQIwJdjQ=;
        h=Date:From:To:Subject:From;
        b=W8AWxh6Y1KMrzHWGDoD8yl3SIfYHE3BIKq8QPzgoJLI1euL89dFwSVOen0VLkzQ7/
         bAqSfFKAyhKQq8RFCSO7QFQ8wsyTJR8FK4RxAo7q55lDMEjH831t820UZV5QBYGVds
         9P5BTMc/453WJFFMXVgzVCHArM2ayewYwuY92lVA=
Date:   Tue, 02 Feb 2021 11:52:49 -0800
From:   akpm@linux-foundation.org
To:     abaci@linux.alibaba.com, gechangwei@live.cn, ghe@suse.com,
        jiapeng.chong@linux.alibaba.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com
Subject:  + ocfs2-simplify-the-calculation-of-variables.patch added
 to -mm tree
Message-ID: <20210202195249.tHy4s0YP0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: Simplify the calculation of variables
has been added to the -mm tree.  Its filename is
     ocfs2-simplify-the-calculation-of-variables.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-simplify-the-calculation-of-variables.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-simplify-the-calculation-of-variables.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: ocfs2: Simplify the calculation of variables

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

ocfs2-simplify-the-calculation-of-variables.patch

