Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3D8EC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 11 Mar 2022 04:54:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237372AbiCKE4A (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Mar 2022 23:56:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232891AbiCKEz7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Mar 2022 23:55:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96FDE14D73B;
        Thu, 10 Mar 2022 20:54:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BC0D6192A;
        Fri, 11 Mar 2022 04:54:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E386C340EC;
        Fri, 11 Mar 2022 04:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646974496;
        bh=snpIX8ADJzXm4HmjLZb00uX/3IvxVv2l/wGvTrG5A4U=;
        h=Date:To:From:Subject:From;
        b=w60LLe6KoeMA6QSatgEKWq3Tk3AOb4iBwl3cqjAB/JfTUHpoGWoI+m5NycdhUxYH/
         tkdy8sWCS49pVsk2b/9X4tAHs2SsTAvMS8WYjfzWkUpxVP68+6Gz1LfxK9yRnb+n9a
         mTy5mWh5McH/BLesq6NsDzBc7EjUob9r5+TIjM0I=
Date:   Thu, 10 Mar 2022 20:54:55 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        piaojun@huawei.com, mark@fasheh.com, junxiao.bi@oracle.com,
        jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
        joseph.qi@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-crash-when-initialize-filecheck-kobj-fails.patch added to -mm tree
Message-Id: <20220311045456.8E386C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix crash when initialize filecheck kobj fails
has been added to the -mm tree.  Its filename is
     ocfs2-fix-crash-when-initialize-filecheck-kobj-fails.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-crash-when-initialize-filecheck-kobj-fails.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-crash-when-initialize-filecheck-kobj-fails.patch

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
Subject: ocfs2: fix crash when initialize filecheck kobj fails

Once s_root is set, genric_shutdown_super() will be called if fill_super()
fails.  That means, we will call ocfs2_dismount_volume() twice in such
case, which can lead to kernel crash.  Fix this issue by initializing
filecheck kobj before setting s_root.

Link: https://lkml.kernel.org/r/20220310081930.86305-1-joseph.qi@linux.alibaba.com
Fixes: 5f483c4abb50 ("ocfs2: add kobject for online file check")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/super.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/fs/ocfs2/super.c~ocfs2-fix-crash-when-initialize-filecheck-kobj-fails
+++ a/fs/ocfs2/super.c
@@ -1105,17 +1105,6 @@ static int ocfs2_fill_super(struct super
 		goto read_super_error;
 	}
 
-	root = d_make_root(inode);
-	if (!root) {
-		status = -ENOMEM;
-		mlog_errno(status);
-		goto read_super_error;
-	}
-
-	sb->s_root = root;
-
-	ocfs2_complete_mount_recovery(osb);
-
 	osb->osb_dev_kset = kset_create_and_add(sb->s_id, NULL,
 						&ocfs2_kset->kobj);
 	if (!osb->osb_dev_kset) {
@@ -1133,6 +1122,17 @@ static int ocfs2_fill_super(struct super
 		goto read_super_error;
 	}
 
+	root = d_make_root(inode);
+	if (!root) {
+		status = -ENOMEM;
+		mlog_errno(status);
+		goto read_super_error;
+	}
+
+	sb->s_root = root;
+
+	ocfs2_complete_mount_recovery(osb);
+
 	if (ocfs2_mount_local(osb))
 		snprintf(nodestr, sizeof(nodestr), "local");
 	else
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-fix-crash-when-initialize-filecheck-kobj-fails.patch
ocfs2-cleanup-some-return-variables.patch

