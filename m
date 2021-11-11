Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E694C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:39:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23F7C61354
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:39:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233812AbhKKCmY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:42:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:48062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233120AbhKKCmY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:42:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7D9461284;
        Thu, 11 Nov 2021 02:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598376;
        bh=QrOpprsRO4cP0LK8UTiCPRSuXPCG1eDCwvB7iwR3KcQ=;
        h=Date:From:To:Subject:From;
        b=GORcq/r2XzT3oebX2F+zrvG7WJgLIhvgxqgBJsrbWLEOfQIlrKTuJVst592BZadUb
         Q0CH+8Tb8BcEeU4RJP8NdJnrC69KTfTHUkqNP7il0w/RIDZcuDL9PmHN9WtQ5U3Y9U
         O+7A3fWan6TNdokDfxC7nEyJc9YVKZ/ZKBBiJos0=
Date:   Wed, 10 Nov 2021 18:39:35 -0800
From:   akpm@linux-foundation.org
To:     gechangwei@live.cn, ghe@suse.com, jack@suse.cz, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com
Subject:  [merged] ocfs2-do-not-zero-pages-beyond-i_size.patch
 removed from -mm tree
Message-ID: <20211111023935.4RjbE6P6X%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: do not zero pages beyond i_size
has been removed from the -mm tree.  Its filename was
     ocfs2-do-not-zero-pages-beyond-i_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: ocfs2: do not zero pages beyond i_size

ocfs2_zero_range_for_truncate() can try to zero pages beyond current inode
size despite the fact that underlying blocks should be already zeroed out
and writeback will skip writing such pages anyway.  Avoid the pointless
work.

Link: https://lkml.kernel.org/r/20211025151332.11301-2-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/fs/ocfs2/alloc.c~ocfs2-do-not-zero-pages-beyond-i_size
+++ a/fs/ocfs2/alloc.c
@@ -6923,13 +6923,12 @@ static int ocfs2_grab_eof_pages(struct i
 }
 
 /*
- * Zero the area past i_size but still within an allocated
- * cluster. This avoids exposing nonzero data on subsequent file
- * extends.
+ * Zero partial cluster for a hole punch or truncate. This avoids exposing
+ * nonzero data on subsequent file extends.
  *
  * We need to call this before i_size is updated on the inode because
  * otherwise block_write_full_page() will skip writeout of pages past
- * i_size. The new_i_size parameter is passed for this reason.
+ * i_size.
  */
 int ocfs2_zero_range_for_truncate(struct inode *inode, handle_t *handle,
 				  u64 range_start, u64 range_end)
@@ -6947,6 +6946,15 @@ int ocfs2_zero_range_for_truncate(struct
 	if (!ocfs2_sparse_alloc(OCFS2_SB(sb)))
 		return 0;
 
+	/*
+	 * Avoid zeroing pages fully beyond current i_size. It is pointless as
+	 * underlying blocks of those pages should be already zeroed out and
+	 * page writeback will skip them anyway.
+	 */
+	range_end = min_t(u64, range_end, i_size_read(inode));
+	if (range_start >= range_end)
+		return 0;
+
 	pages = kcalloc(ocfs2_pages_per_cluster(sb),
 			sizeof(struct page *), GFP_NOFS);
 	if (pages == NULL) {
@@ -6955,9 +6963,6 @@ int ocfs2_zero_range_for_truncate(struct
 		goto out;
 	}
 
-	if (range_start == range_end)
-		goto out;
-
 	ret = ocfs2_extent_map_get_blocks(inode,
 					  range_start >> sb->s_blocksize_bits,
 					  &phys, NULL, &ext_flags);
_

Patches currently in -mm which might be from jack@suse.cz are


