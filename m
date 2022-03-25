Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6890CC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:29:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243739AbiCYBbU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357315AbiCYBbQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:31:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C122980A
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:29:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7448B82727
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:29:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F05C340EC;
        Fri, 25 Mar 2022 01:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171780;
        bh=sR1DdvPFPz+SjpXtvaMp/mTiIS6yAfdD4OnCiqA9H4U=;
        h=Date:To:From:Subject:From;
        b=YAN2E9slkaLkoQncCxIAFc0ZgE5Z9qfMUO8lyi0HjFYJjpbyIdCrkoTGFB0PUwMOj
         wXW+yxyonxnqArDxsaqVWH9WdFijIxh6Ydk+BTsmPNg+kpXNyrZJ7MFQAEGaBItqdv
         ZeGnK9Atur1PFQ0W5yi0/EZMBKy/WW+x5mE45if4=
Date:   Thu, 24 Mar 2022 18:29:39 -0700
To:     mm-commits@vger.kernel.org, zealci@zte.com.cn, piaojun@huawei.com,
        mark@fasheh.com, junxiao.bi@oracle.com, jlbec@evilplan.org,
        ghe@suse.com, gechangwei@live.cn, chi.minghao@zte.com.cn,
        cgel.zte@gmail.com, joseph.qi@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] ocfs2-cleanup-some-return-variables.patch removed from -mm tree
Message-Id: <20220325012940.54F05C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: cleanup some return variables
has been removed from the -mm tree.  Its filename was
     ocfs2-cleanup-some-return-variables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: cleanup some return variables

Simply return directly instead of assign the return value to another
variable.

Link: https://lkml.kernel.org/r/20220114021641.13927-1-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reported-by: Zeal Robot <zealci@zte.com.cn>
Cc: Minghao Chi <chi.minghao@zte.com.cn>
Cc: CGEL ZTE <cgel.zte@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c       |    9 +++------
 fs/ocfs2/stack_user.c |   18 ++++++------------
 2 files changed, 9 insertions(+), 18 deletions(-)

--- a/fs/ocfs2/file.c~ocfs2-cleanup-some-return-variables
+++ a/fs/ocfs2/file.c
@@ -540,15 +540,12 @@ int ocfs2_add_inode_data(struct ocfs2_su
 			 struct ocfs2_alloc_context *meta_ac,
 			 enum ocfs2_alloc_restarted *reason_ret)
 {
-	int ret;
 	struct ocfs2_extent_tree et;
 
 	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), fe_bh);
-	ret = ocfs2_add_clusters_in_btree(handle, &et, logical_offset,
-					  clusters_to_add, mark_unwritten,
-					  data_ac, meta_ac, reason_ret);
-
-	return ret;
+	return ocfs2_add_clusters_in_btree(handle, &et, logical_offset,
+					   clusters_to_add, mark_unwritten,
+					   data_ac, meta_ac, reason_ret);
 }
 
 static int ocfs2_extend_allocation(struct inode *inode, u32 logical_start,
--- a/fs/ocfs2/stack_user.c~ocfs2-cleanup-some-return-variables
+++ a/fs/ocfs2/stack_user.c
@@ -683,28 +683,22 @@ static int user_dlm_lock(struct ocfs2_cl
 			 void *name,
 			 unsigned int namelen)
 {
-	int ret;
-
 	if (!lksb->lksb_fsdlm.sb_lvbptr)
 		lksb->lksb_fsdlm.sb_lvbptr = (char *)lksb +
 					     sizeof(struct dlm_lksb);
 
-	ret = dlm_lock(conn->cc_lockspace, mode, &lksb->lksb_fsdlm,
-		       flags|DLM_LKF_NODLCKWT, name, namelen, 0,
-		       fsdlm_lock_ast_wrapper, lksb,
-		       fsdlm_blocking_ast_wrapper);
-	return ret;
+	return dlm_lock(conn->cc_lockspace, mode, &lksb->lksb_fsdlm,
+			flags|DLM_LKF_NODLCKWT, name, namelen, 0,
+			fsdlm_lock_ast_wrapper, lksb,
+			fsdlm_blocking_ast_wrapper);
 }
 
 static int user_dlm_unlock(struct ocfs2_cluster_connection *conn,
 			   struct ocfs2_dlm_lksb *lksb,
 			   u32 flags)
 {
-	int ret;
-
-	ret = dlm_unlock(conn->cc_lockspace, lksb->lksb_fsdlm.sb_lkid,
-			 flags, &lksb->lksb_fsdlm, lksb);
-	return ret;
+	return dlm_unlock(conn->cc_lockspace, lksb->lksb_fsdlm.sb_lkid,
+			  flags, &lksb->lksb_fsdlm, lksb);
 }
 
 static int user_dlm_lock_status(struct ocfs2_dlm_lksb *lksb)
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are


