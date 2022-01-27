Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 262E9C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jan 2022 02:25:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233001AbiA0CZO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 26 Jan 2022 21:25:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46080 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiA0CZO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jan 2022 21:25:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10CB560C93
        for <mm-commits@vger.kernel.org>; Thu, 27 Jan 2022 02:25:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E0CC340E7;
        Thu, 27 Jan 2022 02:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643250313;
        bh=/KEwy62jwBe3KuUR9ntYEKpwL48PhXglDeM6jATX5Gs=;
        h=Date:From:To:Subject:From;
        b=lph9ATfh9aTN1VM9MjiU9PMZfW7MQ5/DCNRm65u3hFZb9yNAe2B399AtMx+XiIcd4
         aJF6BqcY6fMgE1nju1LROiI3o2mhpr+9fqsoANCOBFQ8XQT/MX+113NpoTQQ3QQxUB
         /gabp/wwv2OAY+HlnHo4tqf7C+XmgnrDEyIDAv6U=
Date:   Wed, 26 Jan 2022 18:25:12 -0800
From:   akpm@linux-foundation.org
To:     cgel.zte@gmail.com, chi.minghao@zte.com.cn, gechangwei@live.cn,
        ghe@suse.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org,
        piaojun@huawei.com, zealci@zte.com.cn
Subject:  + ocfs2-cleanup-some-return-variables.patch added to -mm
 tree
Message-ID: <20220127022512.LQrXQcMjZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: cleanup some return variables
has been added to the -mm tree.  Its filename is
     ocfs2-cleanup-some-return-variables.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-cleanup-some-return-variables.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-cleanup-some-return-variables.patch

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

jbd2-export-jbd2_journal__journal_head.patch
ocfs2-fix-a-deadlock-when-commit-trans.patch
ocfs2-cleanup-some-return-variables.patch

