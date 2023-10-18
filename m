Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A42C8CDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:44:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235235AbjJRVoS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbjJRVoB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:44:01 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F071FE
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:43:59 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B673C433C9;
        Wed, 18 Oct 2023 21:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697665439;
        bh=YqiLq5tA8iVwCRJbMNsyaG8gK3fLO6AmmD3kpA06f4E=;
        h=Date:To:From:Subject:From;
        b=lAgUrdwiQt1bnmLJ9+5+2vbzi+UVUbE4BglbjQ87YCgMQC39IiIZKJ1HYHGbYm6+H
         p7G+Tpc+W5DfK9QFeaFPSIVwlpw1ImHfjbMfLDR1TkJsn5EmNw1TKluTVh8A9dDfzv
         uhl6z1nSBJsPRSbVIRVWwTIIByoKMJf2KYD7vqQI=
Date:   Wed, 18 Oct 2023 14:43:58 -0700
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
        jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
        artem.chernyshev@red-soft.ru, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fs-ocfs2-check-status-values.patch removed from -mm tree
Message-Id: <20231018214359.5B673C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs: ocfs2: check status values
has been removed from the -mm tree.  Its filename was
     fs-ocfs2-check-status-values.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


