Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47B27C433EF
	for <mm-commits@archiver.kernel.org>; Tue,  7 Dec 2021 01:04:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347991AbhLGBH5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Dec 2021 20:07:57 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46526 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244276AbhLGBH4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Dec 2021 20:07:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B282B81611
        for <mm-commits@vger.kernel.org>; Tue,  7 Dec 2021 01:04:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F92C004DD;
        Tue,  7 Dec 2021 01:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638839065;
        bh=nx4RiH+ugBEJip2jIIvqL709MyosfacNHPr1zbcfbWs=;
        h=Date:From:To:Subject:From;
        b=PKssifeUz2KNdw6qJQUXK5GfK/4AW7521fBWYAs84D/Ty0jm1fF4eNJIP2wJCZZkM
         X2IbzDCBvmXXPDOZ4klwUOI2x2JX2uKgE+7vKbCOFaRh7QXtqAHMklPdpBqNDWrj6p
         Zwv4rGimwIviialwzApLubVwKziu7LhlhD/mN2+4=
Date:   Mon, 06 Dec 2021 17:04:24 -0800
From:   akpm@linux-foundation.org
To:     dan.carpenter@oracle.com, gechangwei@live.cn, ghe@suse.com,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org,
        piaojun@huawei.com
Subject:  +
 ocfs2-clearly-handle-ocfs2_grab_pages_for_write-return-value.patch added to
 -mm tree
Message-ID: <20211207010424.pnkMjDrDt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: clearly handle ocfs2_grab_pages_for_write() return value
has been added to the -mm tree.  Its filename is
     ocfs2-clearly-handle-ocfs2_grab_pages_for_write-return-value.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-clearly-handle-ocfs2_grab_pages_for_write-return-value.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-clearly-handle-ocfs2_grab_pages_for_write-return-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: clearly handle ocfs2_grab_pages_for_write() return value

ocfs2_grab_pages_for_write() may return -EAGAIN if write context type is
mmap and it could not lock the target page. In this case, we exit with
no error and no target page. And then trigger the caller page_mkwrite()
to retry.
Since there are other caller types, e.g. buffer and direct io, so make
the return value handling more clearly.

Link: https://lkml.kernel.org/r/20211206065051.103353-1-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/fs/ocfs2/aops.c~ocfs2-clearly-handle-ocfs2_grab_pages_for_write-return-value
+++ a/fs/ocfs2/aops.c
@@ -1799,20 +1799,20 @@ try_again:
 	 */
 	ret = ocfs2_grab_pages_for_write(mapping, wc, wc->w_cpos, pos, len,
 					 cluster_of_pages, mmap_page);
-	if (ret && ret != -EAGAIN) {
-		mlog_errno(ret);
-		goto out_quota;
-	}
+	if (ret) {
+		/*
+		 * ocfs2_grab_pages_for_write() returns -EAGAIN if it could not lock
+		 * the target page. In this case, we exit with no error and no target
+		 * page. This will trigger the caller, page_mkwrite(), to re-try
+		 * the operation.
+		 */
+		if (type == OCFS2_WRITE_MMAP && ret == -EAGAIN) {
+			BUG_ON(wc->w_target_page);
+			ret = 0;
+			goto out_quota;
+		}
 
-	/*
-	 * ocfs2_grab_pages_for_write() returns -EAGAIN if it could not lock
-	 * the target page. In this case, we exit with no error and no target
-	 * page. This will trigger the caller, page_mkwrite(), to re-try
-	 * the operation.
-	 */
-	if (ret == -EAGAIN) {
-		BUG_ON(wc->w_target_page);
-		ret = 0;
+		mlog_errno(ret);
 		goto out_quota;
 	}
 
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-clearly-handle-ocfs2_grab_pages_for_write-return-value.patch

