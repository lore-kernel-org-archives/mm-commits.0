Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D1B9CD8CAE
	for <mm-commits@archiver.kernel.org>; Tue, 10 Oct 2023 18:19:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234079AbjJJSTv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Oct 2023 14:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234102AbjJJSTs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Oct 2023 14:19:48 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A309D
        for <mm-commits@vger.kernel.org>; Tue, 10 Oct 2023 11:19:46 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F0D0C433C8;
        Tue, 10 Oct 2023 18:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696961986;
        bh=DRaW0sgU1LBvugqs1iaBCT/kyQ4j2rrGUozWUX5sTpk=;
        h=Date:To:From:Subject:From;
        b=v/P83KpDoTxw//V/fe4W0KP3qDLkcjuXhxHRiLEzmcUSuMyz4Pxqw70NheV0EDErv
         wYlRp+qRJdfxGOogUZzQwTClyLCKnnHzeV2pfYyJvfB7Yn6y0uik301n1EGF//NhjA
         hZl7IubfLZpUEHwbE7kOhbZj0+3P5hYokpaSxesc=
Date:   Tue, 10 Oct 2023 11:19:36 -0700
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
        jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
        artem.chernyshev@red-soft.ru, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-ocfs2-check-status-values.patch added to mm-nonmm-unstable branch
Message-Id: <20231010181944.1F0D0C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: ocfs2: check status values
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fs-ocfs2-check-status-values.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-ocfs2-check-status-values.patch

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
From: Artem Chernyshev <artem.chernyshev@red-soft.ru>
Subject: fs: ocfs2: check status values
Date: Mon, 9 Oct 2023 17:11:11 +0300

Test return values before overwriting.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Link: https://lkml.kernel.org/r/20231009141111.149858-1-artem.chernyshev@red-soft.ru
Signed-off-by: Artem Chernyshev <artem.chernyshev@red-soft.ru>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c       |    8 ++++++++
 fs/ocfs2/quota_local.c |    4 ++++
 2 files changed, 12 insertions(+)

--- a/fs/ocfs2/namei.c~fs-ocfs2-check-status-values
+++ a/fs/ocfs2/namei.c
@@ -1597,6 +1597,10 @@ static int ocfs2_rename(struct mnt_idmap
 	if (update_dot_dot) {
 		status = ocfs2_update_entry(old_inode, handle,
 					    &old_inode_dot_dot_res, new_dir);
+		if (status < 0) {
+			mlog_errno(status);
+			goto bail;
+		}
 		drop_nlink(old_dir);
 		if (new_inode) {
 			drop_nlink(new_inode);
@@ -1636,6 +1640,10 @@ static int ocfs2_rename(struct mnt_idmap
 							 INODE_CACHE(old_dir),
 							 old_dir_bh,
 							 OCFS2_JOURNAL_ACCESS_WRITE);
+			if (status < 0) {
+				mlog_errno(status);
+				goto bail;
+			}
 			fe = (struct ocfs2_dinode *) old_dir_bh->b_data;
 			ocfs2_set_links_count(fe, old_dir->i_nlink);
 			ocfs2_journal_dirty(handle, old_dir_bh);
--- a/fs/ocfs2/quota_local.c~fs-ocfs2-check-status-values
+++ a/fs/ocfs2/quota_local.c
@@ -1240,6 +1240,10 @@ int ocfs2_create_local_dquot(struct dquo
 				     &od->dq_local_phys_blk,
 				     &pcount,
 				     NULL);
+	if (status < 0) {
+		mlog_errno(status);
+		goto out;
+	}
 
 	/* Initialize dquot structure on disk */
 	status = ocfs2_local_write_dquot(dquot);
_

Patches currently in -mm which might be from artem.chernyshev@red-soft.ru are

fs-ocfs2-check-status-values.patch

