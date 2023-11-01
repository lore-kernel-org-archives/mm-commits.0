Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1A5AC4332F
	for <mm-commits@archiver.kernel.org>; Wed,  1 Nov 2023 19:47:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347374AbjKATrb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Nov 2023 15:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347364AbjKATra (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Nov 2023 15:47:30 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E50DA
        for <mm-commits@vger.kernel.org>; Wed,  1 Nov 2023 12:47:24 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33BD6C433C7;
        Wed,  1 Nov 2023 19:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698868044;
        bh=EmRMFZIh94m8ymORVltsCo9aX9KLcD4tovMgMSwWkFU=;
        h=Date:To:From:Subject:From;
        b=RCAvmkYzWm3QDsTtGIzdrenjZARc3LPHDrkAk2YXZbTrH2RU61Mvz5tWL004efR+X
         voPiOSFHLngfbNjaQ7FY3AQvvkzYfQtJ42jqA2wHib2qC7AzFqbQZ2i3m0yVKLON7c
         bIXGk7bBKRtwgu4Z+KpvB3WgQG9tgYapISGiAsBA=
Date:   Wed, 01 Nov 2023 12:47:23 -0700
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
        jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
        jindui71@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-replace-bug_on-at-ocfs2_num_free_extents-with-ocfs2_error.patch removed from -mm tree
Message-Id: <20231101194724.33BD6C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ocfs2: replace BUG_ON() at ocfs2_num_free_extents() with ocfs2_error()
has been removed from the -mm tree.  Its filename was
     ocfs2-replace-bug_on-at-ocfs2_num_free_extents-with-ocfs2_error.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


