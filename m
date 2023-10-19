Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4180CDB47E
	for <mm-commits@archiver.kernel.org>; Thu, 19 Oct 2023 01:25:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjJSBZI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 21:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjJSBZI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 21:25:08 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0AFD114
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 18:25:05 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BDCAC433C8;
        Thu, 19 Oct 2023 01:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697678705;
        bh=0y1O4NAuMB9KrTOdbR3otrXsE7DeR2mzoPedGXMD7DU=;
        h=Date:To:From:Subject:From;
        b=aZDRcATHmxEuMq9flATwi14CD2m4E7n5MbLL7T7HwIV5v4H+SUAe8RiDW6vViGW+i
         y4xgXz+p9DDiKqXVJ7rpAhafjqDDEBv3jkfakhrZ5Vlq1QVvnx29kLqq07qC7FseMN
         FoChCMlzXPLuYdOH0lDENc1DOJY3v9wejfvHdtpg=
Date:   Wed, 18 Oct 2023 18:25:04 -0700
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
        jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
        jindui71@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-replace-bug_on-at-ocfs2_num_free_extents-with-ocfs2_error.patch added to mm-nonmm-unstable branch
Message-Id: <20231019012505.3BDCAC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: replace BUG_ON() at ocfs2_num_free_extents() with ocfs2_error()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-replace-bug_on-at-ocfs2_num_free_extents-with-ocfs2_error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-replace-bug_on-at-ocfs2_num_free_extents-with-ocfs2_error.patch

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
From: Jia Rui <jindui71@gmail.com>
Subject: ocfs2: replace BUG_ON() at ocfs2_num_free_extents() with ocfs2_error()
Date: Thu, 19 Oct 2023 03:18:11 +0800

The BUG_ON() at ocfs2_num_free_extents() handles the error that
l_tree_deepth of leaf extent block just read form disk is invalid.  This
error is mostly caused by file system metadata corruption on the disk. 
There is no need to call BUG_ON() to handle such errors.  We can return
error code, since the caller can deal with errors from
ocfs2_num_free_extents().  Also, we should make the file system read-only
to avoid the damage from expanding.

Therefore, BUG_ON() is removed and ocfs2_error() is called instead.

Link: https://lkml.kernel.org/r/20231018191811.412458-1-jindui71@gmail.com
Signed-off-by: Jia Rui <jindui71@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/alloc.c~ocfs2-replace-bug_on-at-ocfs2_num_free_extents-with-ocfs2_error
+++ a/fs/ocfs2/alloc.c
@@ -967,7 +967,14 @@ int ocfs2_num_free_extents(struct ocfs2_
 		el = &eb->h_list;
 	}
 
-	BUG_ON(el->l_tree_depth != 0);
+	if (el->l_tree_depth != 0) {
+		retval = ocfs2_error(ocfs2_metadata_cache_get_super(et->et_ci),
+				"Owner %llu has leaf extent block %llu with an invalid l_tree_depth of %u\n",
+				(unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
+				(unsigned long long)last_eb_blk,
+				le16_to_cpu(el->l_tree_depth));
+		goto bail;
+	}
 
 	retval = le16_to_cpu(el->l_count) - le16_to_cpu(el->l_next_free_rec);
 bail:
_

Patches currently in -mm which might be from jindui71@gmail.com are

ocfs2-replace-bug_on-at-ocfs2_num_free_extents-with-ocfs2_error.patch

