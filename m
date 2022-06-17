Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64EB9C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:58:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237443AbiFQC66 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379274AbiFQC65 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:58:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0683E65D09
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:58:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 937A461D44
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:58:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB4EFC3411A;
        Fri, 17 Jun 2022 02:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655434736;
        bh=CBK3yXqWP6LPy5hLP2akH+gJtTTOd/W7Njuft2YkhAY=;
        h=Date:To:From:Subject:From;
        b=iG5YNqZhKJXCbnlS6ksjOAcqJXUUGWsQ3uMh+ZmviZUuxDYvUvXMxEg70YEkaIlRG
         yJglxIzL6n7gXYSgfJAyqGCux1OJbF2LiI0OHlbiNbt46/NotMt0j5F9EpBnXvKekh
         pyd387epc4kHGIsBUdZi6Kx08FKD278b9+Lc3KWs=
Date:   Thu, 16 Jun 2022 19:58:55 -0700
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        joseph.qi@linux.alibaba.com, jlbec@evilplan.org, ghe@suse.com,
        gechangwei@live.cn, junxiao.bi@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-kill-ebusy-from-dlmfs_evict_inode.patch removed from -mm tree
Message-Id: <20220617025855.EB4EFC3411A@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ocfs2: kill EBUSY from dlmfs_evict_inode
has been removed from the -mm tree.  Its filename was
     ocfs2-kill-ebusy-from-dlmfs_evict_inode.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: kill EBUSY from dlmfs_evict_inode
Date: Tue, 7 Jun 2022 10:12:26 -0700

When unlinking a dlmfs, first it will invoke dlmfs_unlink(), and then
invoke dlmfs_evict_inode(), user_dlm_destroy_lock() is invoked in both
places, the second one from dlmfs_evict_inode() will get EBUSY error
because USER_LOCK_IN_TEARDOWN is already set in lockres.  This doesn't
affect any function, just the error log is annoying.

Link: https://lkml.kernel.org/r/20220607171226.86672-1-junxiao.bi@oracle.com
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmfs/dlmfs.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/fs/ocfs2/dlmfs/dlmfs.c~ocfs2-kill-ebusy-from-dlmfs_evict_inode
+++ a/fs/ocfs2/dlmfs/dlmfs.c
@@ -296,17 +296,25 @@ static void dlmfs_evict_inode(struct ino
 {
 	int status;
 	struct dlmfs_inode_private *ip;
+	struct user_lock_res *lockres;
+	int teardown;
 
 	clear_inode(inode);
 
 	mlog(0, "inode %lu\n", inode->i_ino);
 
 	ip = DLMFS_I(inode);
+	lockres = &ip->ip_lockres;
 
 	if (S_ISREG(inode->i_mode)) {
-		status = user_dlm_destroy_lock(&ip->ip_lockres);
-		if (status < 0)
-			mlog_errno(status);
+		spin_lock(&lockres->l_lock);
+		teardown = !!(lockres->l_flags & USER_LOCK_IN_TEARDOWN);
+		spin_unlock(&lockres->l_lock);
+		if (!teardown) {
+			status = user_dlm_destroy_lock(lockres);
+			if (status < 0)
+				mlog_errno(status);
+		}
 		iput(ip->ip_parent);
 		goto clear_fields;
 	}
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are


