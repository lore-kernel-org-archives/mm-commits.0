Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E824AC433FE
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:34:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE2B0611EE
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:34:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbhKEUh2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:37:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:60446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230461AbhKEUh1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:37:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 457FA61216;
        Fri,  5 Nov 2021 20:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144486;
        bh=OJn0JxWHNIGTV3bVVu6WatIl/Ul4OL6osGpyinM+A8U=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Hz+9DuYxzzONEBqyqV+r6mBOt9B2RmLMSvcVD1+Za+rYbNe7QY6kEzoLDEA4QbjNQ
         aOf42tnYSULFlShAIUBx1K26m8+jkZFB8HMG4gY93Y8ZMp0Vm32mzuT/YKcoe7ZujA
         NI369sokqMh2lpGEIcDHSQGH9smqfhiC2QItrSi0=
Date:   Fri, 05 Nov 2021 13:34:45 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cymi20@fudan.edu.cn, gechangwei@live.cn,
        ghe@suse.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, linux-mm@kvack.org, mark@fasheh.com,
        mm-commits@vger.kernel.org, piaojun@huawei.com,
        tanxin.ctf@gmail.com, torvalds@linux-foundation.org,
        wen.gang.wang@oracle.com, xiyuyang19@fudan.edu.cn
Subject:  [patch 004/262] ocfs2: fix handle refcount leak in two
 exception handling paths
Message-ID: <20211105203445.DaSjbdbf2%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
