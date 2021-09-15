Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB4F0C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 03:29:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87F3361214
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 03:29:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbhIODbL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Sep 2021 23:31:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236181AbhIODbK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Sep 2021 23:31:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD14A61211;
        Wed, 15 Sep 2021 03:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631676592;
        bh=ZJc3eK4NRSNphsBsnm+ieU06LYEZdWb3dZvR/VV6bUs=;
        h=Date:From:To:Subject:From;
        b=vjFRxTDVyKHMXt9D9Hu0HUHv/F6tqv7JpQGbB1ytBSpFPVd55lF7W9IbdrYUI+5Q6
         TBqNwb4E4dh90VUKzSxwvxMhI8xX6F+AW9CZgGYzY4QiYte6KPl6qjxtiLwyX7d28/
         K7gGI11of3RA/gDN2vyhcC9l2NFTdK96smxxAnPI=
Date:   Tue, 14 Sep 2021 20:29:51 -0700
From:   akpm@linux-foundation.org
To:     cymi20@fudan.edu.cn, gechangwei@live.cn, ghe@suse.com,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org,
        piaojun@huawei.com, tanxin.ctf@gmail.com, wen.gang.wang@oracle.com,
        xiyuyang19@fudan.edu.cn
Subject:  +
 ocfs2-fix-handle-refcount-leak-in-two-exception-handling-paths.patch added
 to -mm tree
Message-ID: <20210915032951.oY4s7C-k3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: Fix handle refcount leak in two exception handling paths
has been added to the -mm tree.  Its filename is
     ocfs2-fix-handle-refcount-leak-in-two-exception-handling-paths.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-handle-refcount-leak-in-two-exception-handling-paths.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-handle-refcount-leak-in-two-exception-handling-paths.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chenyuan Mi <cymi20@fudan.edu.cn>
Subject: ocfs2: Fix handle refcount leak in two exception handling paths

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

ocfs2-fix-handle-refcount-leak-in-two-exception-handling-paths.patch

