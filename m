Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA308C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Jun 2022 19:16:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235288AbiFHTQq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Jun 2022 15:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234646AbiFHTQq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jun 2022 15:16:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC450515A5
        for <mm-commits@vger.kernel.org>; Wed,  8 Jun 2022 12:16:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68A41B829B3
        for <mm-commits@vger.kernel.org>; Wed,  8 Jun 2022 19:16:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08EACC34116;
        Wed,  8 Jun 2022 19:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654715802;
        bh=8b8WtB3jh8oHsF9CVp9WaKMezK6m6AS+PttRgAH4nxg=;
        h=Date:To:From:Subject:From;
        b=V8xNZp9ZVtEU8wmnVZf+A242TWIof8+Ts9WOM0JYXb4G8ElyjhYH0HGwcYKWMVIrm
         jkPGh7lQdrj3jMWaxRWh38tQtUHMUUy8zpm7HdYlOAkBsteTY47Pj3ZwS6pSsv+cNP
         NGnZmLsdmwJGGUVONNjsHFwe8bsKYvqZm22C/c8w=
Date:   Wed, 08 Jun 2022 12:16:41 -0700
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
        jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
        ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-kill-ebusy-from-dlmfs_evict_inode.patch added to mm-nonmm-unstable branch
Message-Id: <20220608191642.08EACC34116@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: kill EBUSY from dlmfs_evict_inode
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-kill-ebusy-from-dlmfs_evict_inode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-kill-ebusy-from-dlmfs_evict_inode.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Junxiao Bi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
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

Patches currently in -mm which might be from ocfs2-devel@oss.oracle.com are

ocfs2-kill-ebusy-from-dlmfs_evict_inode.patch

