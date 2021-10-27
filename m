Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D759C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 21:02:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 575316109F
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 21:02:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240980AbhJ0VEu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Oct 2021 17:04:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:53468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244156AbhJ0VEu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 Oct 2021 17:04:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E130460E78;
        Wed, 27 Oct 2021 21:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635368544;
        bh=7QEsG/68tF1PsMXy4xj1uWMVzrQKG8MvJQe5VRBoHFs=;
        h=Date:From:To:Subject:From;
        b=KB5Kk/rD5Lhwo0K1xUtf/9GYyYSzDU4qP8PhakTQ5/qbRxWbYYftyCYzYStMhMoBr
         ce5EArbvuz6j/9+hRbyp6/4Fc/q7ug4GBIcgDu5sSx5tzc1QyWhzQXYA5TdTXiPcHR
         bw+m8pkroXH5c7cKze9HGN6E4xdzqA/upEj+jdro=
Date:   Wed, 27 Oct 2021 14:02:23 -0700
From:   akpm@linux-foundation.org
To:     gechangwei@live.cn, ghe@suse.com, jack@suse.cz,
        jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com,
        mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com
Subject:  + ocfs2-do-not-zero-pages-beyond-i_size.patch added to
 -mm tree
Message-ID: <20211027210223.HJIuhmPHY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: do not zero pages beyond i_size
has been added to the -mm tree.  Its filename is
     ocfs2-do-not-zero-pages-beyond-i_size.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-do-not-zero-pages-beyond-i_size.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-do-not-zero-pages-beyond-i_size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: ocfs2: do not zero pages beyond i_size

ocfs2_zero_range_for_truncate() can try to zero pages beyond current inode
size despite the fact that underlying blocks should be already zeroed out
and writeback will skip writing such pages anyway.  Avoid the pointless
work.

Link: https://lkml.kernel.org/r/20211025151332.11301-2-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <jiangqi903@gmail.com>
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

ocfs2-fix-data-corruption-on-truncate.patch
ocfs2-do-not-zero-pages-beyond-i_size.patch

