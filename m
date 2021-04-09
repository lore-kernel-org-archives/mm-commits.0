Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C279C433ED
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 20:08:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A6E461074
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 20:08:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233824AbhDIUIh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Apr 2021 16:08:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:42306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232796AbhDIUIh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Apr 2021 16:08:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3A306105A;
        Fri,  9 Apr 2021 20:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617998904;
        bh=o2WyZ6I8rzwkjW83M9jt/YKVxfKlBbkr5N379Yhi+Yk=;
        h=Date:From:To:Subject:From;
        b=LKy7NWlP1BbIFODmfMsF/zOmHCWXJtiwUa5a7yTrmesL0aPYWO+1xqRcO/+Fp0BpI
         lG81IXnQc9T1GR+92VK2ej1CG6Waje/5yy9myhUyZmCcj/gjxvc3pRe8UD1e4d302C
         avbX3ku7IOXzyr/l3EZnTWEJJswsvWlkp6zvME18=
Date:   Fri, 09 Apr 2021 13:08:23 -0700
From:   akpm@linux-foundation.org
To:     gechangwei@live.cn, ghe@suse.com, jiangqi903@gmail.com,
        jlbec@evilplan.org, junxiao.bi@oracle.com, mark@fasheh.com,
        mm-commits@vger.kernel.org, piaojun@huawei.com,
        wen.gang.wang@oracle.com
Subject:  [folded-merged]
 ocfs2-fix-deadlock-between-setattr-and-dio_end_io_write-v2.patch removed
 from -mm tree
Message-ID: <20210409200823.GP_FHyj7l%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-fix-deadlock-between-setattr-and-dio_end_io_write-v2
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-deadlock-between-setattr-and-dio_end_io_write-v2.patch

This patch was dropped because it was folded into ocfs2-fix-deadlock-between-setattr-and-dio_end_io_write.patch

------------------------------------------------------
From: Wengang Wang <wen.gang.wang@oracle.com>
Subject: ocfs2-fix-deadlock-between-setattr-and-dio_end_io_write-v2

remove the "had_alloc_lock" as suggested

Link: https://lkml.kernel.org/r/20210402171344.1605-1-wen.gang.wang@oracle.com
Cc: stable@vger.kernel.org
Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- a/fs/ocfs2/file.c~ocfs2-fix-deadlock-between-setattr-and-dio_end_io_write-v2
+++ a/fs/ocfs2/file.c
@@ -1124,7 +1124,7 @@ int ocfs2_setattr(struct user_namespace
 	handle_t *handle = NULL;
 	struct dquot *transfer_to[MAXQUOTAS] = { };
 	int qtype;
-	int had_lock, had_alloc_lock = 0;
+	int had_lock;
 	struct ocfs2_lock_holder oh;
 
 	trace_ocfs2_setattr(inode, dentry,
@@ -1246,27 +1246,23 @@ int ocfs2_setattr(struct user_namespace
 			}
 		}
 		down_write(&OCFS2_I(inode)->ip_alloc_sem);
-		had_alloc_lock = 1;
-
 		handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS +
 					   2 * ocfs2_quota_trans_credits(sb));
 		if (IS_ERR(handle)) {
 			status = PTR_ERR(handle);
 			mlog_errno(status);
-			goto bail_unlock;
+			goto bail_unlock_alloc;
 		}
 		status = __dquot_transfer(inode, transfer_to);
 		if (status < 0)
 			goto bail_commit;
 	} else {
 		down_write(&OCFS2_I(inode)->ip_alloc_sem);
-		had_alloc_lock = 1;
-
 		handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
 		if (IS_ERR(handle)) {
 			status = PTR_ERR(handle);
 			mlog_errno(status);
-			goto bail_unlock;
+			goto bail_unlock_alloc;
 		}
 	}
 
@@ -1279,10 +1275,9 @@ int ocfs2_setattr(struct user_namespace
 
 bail_commit:
 	ocfs2_commit_trans(osb, handle);
+bail_unlock_alloc:
+	up_write(&OCFS2_I(inode)->ip_alloc_sem);
 bail_unlock:
-	if (had_alloc_lock)
-		up_write(&OCFS2_I(inode)->ip_alloc_sem);
-
 	if (status && inode_locked) {
 		ocfs2_inode_unlock_tracker(inode, 1, &oh, had_lock);
 		inode_locked = 0;
_

Patches currently in -mm which might be from wen.gang.wang@oracle.com are

ocfs2-fix-deadlock-between-setattr-and-dio_end_io_write.patch

