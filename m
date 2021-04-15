Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40327C433ED
	for <mm-commits@archiver.kernel.org>; Thu, 15 Apr 2021 20:39:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1631761139
	for <mm-commits@archiver.kernel.org>; Thu, 15 Apr 2021 20:39:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234869AbhDOUjb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Apr 2021 16:39:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234536AbhDOUjb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Apr 2021 16:39:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E377160E0C;
        Thu, 15 Apr 2021 20:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618519148;
        bh=OcnAthBCqksyYYbZFqWrvhGcPyt+3swz+yx+esX1bmE=;
        h=Date:From:To:Subject:From;
        b=MDnsfU8ljxaeO9SfBQRSYVDIINwgjiHeBdIO9RgDsakOgfy4pVLruFvBZsfAHA/wv
         XUvUmuLzrTAXpwF3+mZba8pcABRrVrPInOwCa2x9gk++EGB+DY9+9TTTJCV6TQyUQV
         2exxjqW+5BYxv/GRQVAw6z2BhrH/cfaecRMxIwsA=
Date:   Thu, 15 Apr 2021 13:39:07 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, wen.gang.wang@oracle.com,
        piaojun@huawei.com, mark@fasheh.com, junxiao.bi@oracle.com,
        joseph.qi@linux.alibaba.com, jlbec@evilplan.org, ghe@suse.com,
        gechangwei@live.cn, abaci@linux.alibaba.com,
        jiapeng.chong@linux.alibaba.com
Subject:  + ocfs2-dlm-remove-unused-function.patch added to -mm tree
Message-ID: <20210415203907.aOaqX%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: remove unused function
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-remove-unused-function.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dlm-remove-unused-function.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dlm-remove-unused-function.patch

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

ocfs2-dlm-remove-unused-function.patch

