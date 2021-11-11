Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D9C2C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:39:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32F5961872
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:39:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233758AbhKKCmM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:42:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:47854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233120AbhKKCmM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:42:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA259610F7;
        Thu, 11 Nov 2021 02:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598364;
        bh=DVt0/+fuXRgbs2zDnW9INVI1Ri+UMVPP2/Lso5av60Y=;
        h=Date:From:To:Subject:From;
        b=Dcxwl6bkGODl4bzbJQxynXDLA2iotC/qHPceJ3Xb1/CZ6crEHler2M7iRefiaF9eA
         vcjwEbei9s64a87ifvxdbxz+CHwd2EVbMVOT7OKqAtNRHKU9b6BUkIbadG8rlIxzst
         Q/TJDMuuhPoyfDTdRIKj7sNNRJUlCtIPj4y8DkBw=
Date:   Wed, 10 Nov 2021 18:39:23 -0800
From:   akpm@linux-foundation.org
To:     cymi20@fudan.edu.cn, gechangwei@live.cn, ghe@suse.com,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org,
        piaojun@huawei.com, tanxin.ctf@gmail.com, wen.gang.wang@oracle.com,
        xiyuyang19@fudan.edu.cn
Subject:  [merged]
 ocfs2-fix-handle-refcount-leak-in-two-exception-handling-paths.patch
 removed from -mm tree
Message-ID: <20211111023923.Qiw-aUvjM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix handle refcount leak in two exception handling paths
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-handle-refcount-leak-in-two-exception-handling-paths.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chenyuan Mi <cymi20@fudan.edu.cn>
Subject: ocfs2: fix handle refcount leak in two exception handling paths

The reference counting issue happens in two exception handling paths
of ocfs2_replay_truncate_records(). When executing these two exception
handling paths, the function forgets to decrease the refcount of handle
increased by ocfs2_start_trans(), causing a refcount leak.

Fix this issue by using ocfs2_commit_trans() to decrease the refcount
of handle in two handling paths.

Link: https://lkml.kernel.org/r/20210908102055.10168-1-cymi20@fudan.edu.cn
Signed-off-by: Chenyuan Mi <cymi20@fudan.edu.cn>
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Wengang Wang <wen.gang.wang@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ocfs2/alloc.c~ocfs2-fix-handle-refcount-leak-in-two-exception-handling-paths
+++ a/fs/ocfs2/alloc.c
@@ -5940,6 +5940,7 @@ static int ocfs2_replay_truncate_records
 		status = ocfs2_journal_access_di(handle, INODE_CACHE(tl_inode), tl_bh,
 						 OCFS2_JOURNAL_ACCESS_WRITE);
 		if (status < 0) {
+			ocfs2_commit_trans(osb, handle);
 			mlog_errno(status);
 			goto bail;
 		}
@@ -5964,6 +5965,7 @@ static int ocfs2_replay_truncate_records
 						     data_alloc_bh, start_blk,
 						     num_clusters);
 			if (status < 0) {
+				ocfs2_commit_trans(osb, handle);
 				mlog_errno(status);
 				goto bail;
 			}
_

Patches currently in -mm which might be from cymi20@fudan.edu.cn are


