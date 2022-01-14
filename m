Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 185E1C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:03:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbiANWDk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:03:40 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45422 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiANWDk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:03:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F10D861FEE
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:03:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5DCC36AE5;
        Fri, 14 Jan 2022 22:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197819;
        bh=Jpr0gDxBG2c1I+rPzuOJa8KfT9w3itjw0aD0P63usnE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=rg8J1UL42cIdvG/e5nqyq9dSFPxwhQdHtC+c4Z7zscdXvqYeFHOza/k4ZPcFVGIWI
         hpX7BQTGp4NgRTqMnVzKPEFHYvk86gZGlYMix7IvV4Kt61Bc4Zn1aoRj/zXhCgToIY
         LLAmJFi4rjN0ULfEGh+jMffDq9CVOHO9MiJ3m274=
Date:   Fri, 14 Jan 2022 14:03:38 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.carpenter@oracle.com,
        gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        linux-mm@kvack.org, mark@fasheh.com, mm-commits@vger.kernel.org,
        piaojun@huawei.com, torvalds@linux-foundation.org
Subject:  [patch 015/146] ocfs2: clearly handle
 ocfs2_grab_pages_for_write() return value
Message-ID: <20220114220338.3M11cdFzD%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: clearly handle ocfs2_grab_pages_for_write() return value

ocfs2_grab_pages_for_write() may return -EAGAIN if write context type is
mmap and it could not lock the target page.  In this case, we exit with no
error and no target page.  And then trigger the caller page_mkwrite() to
retry.

Since there are other caller types, e.g.  buffer and direct io, make the
return value handling more clear.

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
