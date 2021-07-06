Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05328C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:08:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDBD661C7A
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:08:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbhGFTLI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:11:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231718AbhGFTLI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:11:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A04D161C6C;
        Tue,  6 Jul 2021 19:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598508;
        bh=yLzBvEh61vdeyPBqfnK9/+O6YXdnHOTHHwZnbMVES+U=;
        h=Date:From:To:Subject:From;
        b=yr4mrmtDkrEsUNsS60bWIwOqP2Ojo0Heu99sUrNIQ9NXHPu9XSwfCba5cRbN0ht9D
         kG/PPIn6A15UoMoJ+a8hKW0lR9JaaHucsb9zgodVuxpTSnnQ31oQdShoPVdZ4v48Kp
         mLbOD5pkjdFDke3Anh+0+Po2cYIOS2JfiXZ7cnKo=
Date:   Tue, 06 Jul 2021 12:08:28 -0700
From:   akpm@linux-foundation.org
To:     dan.carpenter@oracle.com, gechangwei@live.cn, ghe@suse.com,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org,
        piaojun@huawei.com
Subject:  [merged] ocfs2-fix-snprintf-checking.patch removed from
 -mm tree
Message-ID: <20210706190828.V60gvVRP5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix snprintf() checking
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-snprintf-checking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: ocfs2: fix snprintf() checking

The snprintf() function returns the number of bytes which would have been
printed if the buffer was large enough.  In other words it can return ">=
remain" but this code assumes it returns "== remain".

The run time impact of this bug is not very severe.  The next iteration
through the loop would trigger a WARN() when we pass a negative limit to
snprintf().  We would then return success instead of -E2BIG.

The kernel implementation of snprintf() will never return negatives so
there is no need to check and I have deleted that dead code.

Link: https://lkml.kernel.org/r/20210511135350.GV1955@kadam
Fixes: a860f6eb4c6a ("ocfs2: sysfile interfaces for online file check")
Fixes: 74ae4e104dfc ("ocfs2: Create stack glue sysfs files.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/filecheck.c |    6 +-----
 fs/ocfs2/stackglue.c |    8 ++------
 2 files changed, 3 insertions(+), 11 deletions(-)

--- a/fs/ocfs2/filecheck.c~ocfs2-fix-snprintf-checking
+++ a/fs/ocfs2/filecheck.c
@@ -326,11 +326,7 @@ static ssize_t ocfs2_filecheck_attr_show
 		ret = snprintf(buf + total, remain, "%lu\t\t%u\t%s\n",
 			       p->fe_ino, p->fe_done,
 			       ocfs2_filecheck_error(p->fe_status));
-		if (ret < 0) {
-			total = ret;
-			break;
-		}
-		if (ret == remain) {
+		if (ret >= remain) {
 			/* snprintf() didn't fit */
 			total = -E2BIG;
 			break;
--- a/fs/ocfs2/stackglue.c~ocfs2-fix-snprintf-checking
+++ a/fs/ocfs2/stackglue.c
@@ -500,11 +500,7 @@ static ssize_t ocfs2_loaded_cluster_plug
 	list_for_each_entry(p, &ocfs2_stack_list, sp_list) {
 		ret = snprintf(buf, remain, "%s\n",
 			       p->sp_name);
-		if (ret < 0) {
-			total = ret;
-			break;
-		}
-		if (ret == remain) {
+		if (ret >= remain) {
 			/* snprintf() didn't fit */
 			total = -E2BIG;
 			break;
@@ -531,7 +527,7 @@ static ssize_t ocfs2_active_cluster_plug
 	if (active_stack) {
 		ret = snprintf(buf, PAGE_SIZE, "%s\n",
 			       active_stack->sp_name);
-		if (ret == PAGE_SIZE)
+		if (ret >= PAGE_SIZE)
 			ret = -E2BIG;
 	}
 	spin_unlock(&ocfs2_stack_lock);
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are


