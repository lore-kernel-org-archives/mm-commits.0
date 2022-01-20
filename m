Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 435DBC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:23:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377808AbiATVXU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:23:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237238AbiATVXU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:23:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0ECC061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:23:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1D7B61890
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:23:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B946DC340E0;
        Thu, 20 Jan 2022 21:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713799;
        bh=Qf5rbh772Rc0MfZTPSEbTPr6Zkta5I9AoxjV6Y057zg=;
        h=Date:From:To:Subject:From;
        b=sl/7/1dC4CLxCyK+zF0OHipDTFejf+hcHMi/34P9GxLpY6cTiuV7n7KoqbkVvYgAP
         GWD2cyxedXYd3jAzsbdOeKKEnNeSxzjwy1/PEsB2FDf0NSN8zuYheBMo5eg80fVrHD
         h+qqUfo652V4Th19MU48tplC0oKbqz81V3zbi8yI=
Date:   Thu, 20 Jan 2022 13:23:18 -0800
From:   akpm@linux-foundation.org
To:     dan.carpenter@oracle.com, gechangwei@live.cn, ghe@suse.com,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org,
        piaojun@huawei.com
Subject:  [merged]
 ocfs2-clearly-handle-ocfs2_grab_pages_for_write-return-value.patch removed
 from -mm tree
Message-ID: <20220120212318.nXJuPzaRb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: clearly handle ocfs2_grab_pages_for_write() return value
has been removed from the -mm tree.  Its filename was
     ocfs2-clearly-handle-ocfs2_grab_pages_for_write-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are


