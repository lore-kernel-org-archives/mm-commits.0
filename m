Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0233BC433ED
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:54:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D71FF61459
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:54:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbhD3FzA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:55:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:46356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230313AbhD3FzA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:55:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E0166144F;
        Fri, 30 Apr 2021 05:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762052;
        bh=JLVHghcJHdlLR7U9K34T1OvMNYr4CJt68N2X1aHrmo4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=wyrwWe0iQok7eQJarUtKQcAX6CZP+7ZuSGlssvDNOKsZw937P3Gex8KL8eAz+d3UJ
         V8D0qL4Ej5acdI01ohnOAsacmWPwZjl5OeimKCntHxCw/cbS5aI2RbzcM+vwT03bM7
         EWad+lp7EO/sklfqL6E8bxpwSqW9BD64d6sPU6Nc=
Date:   Thu, 29 Apr 2021 22:54:11 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     abaci@linux.alibaba.com, akpm@linux-foundation.org,
        gechangwei@live.cn, ghe@suse.com, jiapeng.chong@linux.alibaba.com,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, linux-mm@kvack.org, mark@fasheh.com,
        mm-commits@vger.kernel.org, piaojun@huawei.com,
        torvalds@linux-foundation.org, wen.gang.wang@oracle.com
Subject:  [patch 019/178] ocfs2/dlm: remove unused function
Message-ID: <20210430055411.C4STz2ow0%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: ocfs2/dlm: remove unused function

Fix the following clang warning:

fs/ocfs2/dlm/dlmrecovery.c:129:20: warning: unused function
'dlm_reset_recovery' [-Wunused-function].

Link: https://lkml.kernel.org/r/1618382761-5784-1-git-send-email-jiapeng.chong@linux.alibaba.com
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Reviewed-by: Wengang Wang <wen.gang.wang@oracle.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmrecovery.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-remove-unused-function
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -126,13 +126,6 @@ static inline void __dlm_reset_recovery(
 	dlm_set_reco_master(dlm, O2NM_INVALID_NODE_NUM);
 }
 
-static inline void dlm_reset_recovery(struct dlm_ctxt *dlm)
-{
-	spin_lock(&dlm->spinlock);
-	__dlm_reset_recovery(dlm);
-	spin_unlock(&dlm->spinlock);
-}
-
 /* Worker function used during recovery. */
 void dlm_dispatch_work(struct work_struct *work)
 {
_
