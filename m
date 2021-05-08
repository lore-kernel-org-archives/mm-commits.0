Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41274C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:39:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 230E061421
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:39:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbhEHWkh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:40:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:43764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229552AbhEHWkh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:40:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2C4061415;
        Sat,  8 May 2021 22:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513574;
        bh=3/5m665KVqeEnAe4Kh82PFyPqtRiuQ2u/D5MPibpIkc=;
        h=Date:From:To:Subject:From;
        b=FnlQS0pDdBWIyqj/aOw+UjcALGmF2PGGa4teFMFOe+jNryhjDjFDmcV+AhCI9BrDr
         30HvnAEM2j+sbJK/9ncaN9vvElAmqocUaIqoEBJg3fErgnNW/zmkZK9Optw6L7tVe3
         wHls3mDL9qRauu5iq/r5ghRInY+8CWEjraKNHd6s=
Date:   Sat, 08 May 2021 15:39:33 -0700
From:   akpm@linux-foundation.org
To:     abaci@linux.alibaba.com, gechangwei@live.cn, ghe@suse.com,
        jiapeng.chong@linux.alibaba.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com,
        wen.gang.wang@oracle.com
Subject:  [merged] ocfs2-dlm-remove-unused-function.patch removed
 from -mm tree
Message-ID: <20210508223933.G80WGuBKQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: remove unused function
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm-remove-unused-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from jiapeng.chong@linux.alibaba.com are


