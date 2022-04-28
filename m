Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B69A4C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 28 Apr 2022 22:00:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352726AbiD1WDe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Apr 2022 18:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352713AbiD1WD1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Apr 2022 18:03:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640DFDC4
        for <mm-commits@vger.kernel.org>; Thu, 28 Apr 2022 15:00:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3B1561D9A
        for <mm-commits@vger.kernel.org>; Thu, 28 Apr 2022 22:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56645C385A9;
        Thu, 28 Apr 2022 22:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651183210;
        bh=Ln9KjwUV8Rfqyjb8oZIh2Mdltn2aWlIUwxsAu7tWB8o=;
        h=Date:To:From:Subject:From;
        b=kpV1xq3A/qNbj5iC34LmFRFNEqA5BahgESdIYfvsVFCnTSx/YUbKgYSRxPRdzWIPn
         +Fwc8qCJGmvHuZg6athRgccr7NVG3h8UBJo9+xPTQGPufnApm8iT1788HTGTdLWXB+
         zxxnSVWeG3cmWqmtymSKIG3q0Rn6HLBhDIUidYzo=
Date:   Thu, 28 Apr 2022 15:00:09 -0700
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
        jlbec@evilplan.org, heming.zhao@suse.com, ghe@suse.com,
        gechangwei@live.cn, ocfs2-devel@oss.oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-ocfs2_mount_volume-does-cleanup-job-before-return-error.patch added to -mm tree
Message-Id: <20220428220010.56645C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: ocfs2_mount_volume does cleanup job before return error
has been added to the -mm tree.  Its filename is
     ocfs2-ocfs2_mount_volume-does-cleanup-job-before-return-error.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-ocfs2_mount_volume-does-cleanup-job-before-return-error.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-ocfs2_mount_volume-does-cleanup-job-before-return-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Subject: ocfs2: ocfs2_mount_volume does cleanup job before return error

After this patch, when error, ocfs2_fill_super doesn't take care to
release resources which are allocated in ocfs2_mount_volume.

Link: https://lkml.kernel.org/r/20220424130952.2436-5-heming.zhao@suse.com
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/super.c |   35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

--- a/fs/ocfs2/super.c~ocfs2-ocfs2_mount_volume-does-cleanup-job-before-return-error
+++ a/fs/ocfs2/super.c
@@ -1803,11 +1803,10 @@ static int ocfs2_get_sector(struct super
 static int ocfs2_mount_volume(struct super_block *sb)
 {
 	int status = 0;
-	int unlock_super = 0;
 	struct ocfs2_super *osb = OCFS2_SB(sb);
 
 	if (ocfs2_is_hard_readonly(osb))
-		goto leave;
+		goto out;
 
 	mutex_init(&osb->obs_trim_fs_mutex);
 
@@ -1817,44 +1816,56 @@ static int ocfs2_mount_volume(struct sup
 		if (status == -EBADR && ocfs2_userspace_stack(osb))
 			mlog(ML_ERROR, "couldn't mount because cluster name on"
 			" disk does not match the running cluster name.\n");
-		goto leave;
+		goto out;
 	}
 
 	status = ocfs2_super_lock(osb, 1);
 	if (status < 0) {
 		mlog_errno(status);
-		goto leave;
+		goto out_dlm;
 	}
-	unlock_super = 1;
 
 	/* This will load up the node map and add ourselves to it. */
 	status = ocfs2_find_slot(osb);
 	if (status < 0) {
 		mlog_errno(status);
-		goto leave;
+		goto out_super_lock;
 	}
 
 	/* load all node-local system inodes */
 	status = ocfs2_init_local_system_inodes(osb);
 	if (status < 0) {
 		mlog_errno(status);
-		goto leave;
+		goto out_super_lock;
 	}
 
 	status = ocfs2_check_volume(osb);
 	if (status < 0) {
 		mlog_errno(status);
-		goto leave;
+		goto out_system_inodes;
 	}
 
 	status = ocfs2_truncate_log_init(osb);
-	if (status < 0)
+	if (status < 0) {
 		mlog_errno(status);
+		goto out_system_inodes;
+	}
 
-leave:
-	if (unlock_super)
-		ocfs2_super_unlock(osb, 1);
+	ocfs2_super_unlock(osb, 1);
+	return 0;
 
+out_system_inodes:
+	if (osb->local_alloc_state == OCFS2_LA_ENABLED)
+		ocfs2_shutdown_local_alloc(osb);
+	ocfs2_release_system_inodes(osb);
+	/* before journal shutdown, we should release slot_info */
+	ocfs2_free_slot_info(osb);
+	ocfs2_journal_shutdown(osb);
+out_super_lock:
+	ocfs2_super_unlock(osb, 1);
+out_dlm:
+	ocfs2_dlm_shutdown(osb, 0);
+out:
 	return status;
 }
 
_

Patches currently in -mm which might be from ocfs2-devel@oss.oracle.com are

ocfs2-fix-mounting-crash-if-journal-is-not-alloced.patch
ocfs2-change-return-type-of-ocfs2_resmap_init.patch
ocfs2-ocfs2_initialize_super-does-cleanup-job-before-return-error.patch
ocfs2-ocfs2_mount_volume-does-cleanup-job-before-return-error.patch
ocfs2-rewrite-error-handling-of-ocfs2_fill_super.patch

