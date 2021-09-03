Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BCB5C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:55:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3983610E9
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:55:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236039AbhICU4Y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:56:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:55510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235957AbhICU4Y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:56:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95A73610E6;
        Fri,  3 Sep 2021 20:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702523;
        bh=7KRFt6kotE1L6Juvr4DwDmvrZL+eAtVqO90UaA5/Hgc=;
        h=Date:From:To:Subject:From;
        b=RwcoRiQb0MsWCpg6rRCkOZ5vTpPCOl2f0/5qBFaxIkXprA/Cqb0jZg+FP1Q33YjLl
         GuZfSX3eUAidmDpEhACExXVdjcrlFcieH4hXrKZxHyAl1I0ze4anTMazOA1SBxuVxo
         DdsyXFuGNxHku9ZMzQiCV8EiV2hoLOY0MHOtv4/Q=
Date:   Fri, 03 Sep 2021 13:55:23 -0700
From:   akpm@linux-foundation.org
To:     gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com
Subject:  [merged]
 ocfs2-ocfs2_downconvert_lock-failure-results-in-deadlock.patch removed from
 -mm tree
Message-ID: <20210903205523.HKnek9D0g%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: ocfs2_downconvert_lock failure results in deadlock
has been removed from the -mm tree.  Its filename was
     ocfs2-ocfs2_downconvert_lock-failure-results-in-deadlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gang He <ghe@suse.com>
Subject: ocfs2: ocfs2_downconvert_lock failure results in deadlock

Usually, ocfs2_downconvert_lock() function always downconverts dlm lock to
the expected level for satisfy dlm bast requests from the other nodes.

But there is a rare situation.  When dlm lock conversion is being
canceled, ocfs2_downconvert_lock() function will return -EBUSY.  You need
to be aware that ocfs2_cancel_convert() function is asynchronous in fsdlm
implementation.

If we does not requeue this lockres entry, ocfs2 downconvert thread no
longer handles this dlm lock bast request.  Then, the other nodes will not
get the dlm lock again, the current node's process will be blocked when
acquire this dlm lock again.

Link: https://lkml.kernel.org/r/20210830044621.12544-1-ghe@suse.com
Signed-off-by: Gang He <ghe@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/fs/ocfs2/dlmglue.c~ocfs2-ocfs2_downconvert_lock-failure-results-in-deadlock
+++ a/fs/ocfs2/dlmglue.c
@@ -16,6 +16,7 @@
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 #include <linux/time.h>
+#include <linux/delay.h>
 #include <linux/quotaops.h>
 #include <linux/sched/signal.h>
 
@@ -3912,6 +3913,17 @@ downconvert:
 	spin_unlock_irqrestore(&lockres->l_lock, flags);
 	ret = ocfs2_downconvert_lock(osb, lockres, new_level, set_lvb,
 				     gen);
+	/* The dlm lock convert is being cancelled in background,
+	 * ocfs2_cancel_convert() is asynchronous in fs/dlm,
+	 * requeue it, try again later.
+	 */
+	if (ret == -EBUSY) {
+		ctl->requeue = 1;
+		mlog(ML_BASTS, "lockres %s, ReQ: Downconvert busy\n",
+		     lockres->l_name);
+		ret = 0;
+		msleep(20);
+	}
 
 leave:
 	if (ret)
_

Patches currently in -mm which might be from ghe@suse.com are

ocfs2-reflink-deadlock-when-clone-file-to-the-same-directory-simultaneously.patch

