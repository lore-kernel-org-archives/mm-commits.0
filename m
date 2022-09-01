Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93C8BC67868
	for <mm-commits@archiver.kernel.org>; Thu,  1 Sep 2022 19:07:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233557AbiIATHM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Sep 2022 15:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233644AbiIATHG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Sep 2022 15:07:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D53E7287C
        for <mm-commits@vger.kernel.org>; Thu,  1 Sep 2022 12:07:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDCAF61D84
        for <mm-commits@vger.kernel.org>; Thu,  1 Sep 2022 19:07:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 400B6C433C1;
        Thu,  1 Sep 2022 19:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662059222;
        bh=Cn652OV+V0hcnSwY7CrwJmruOmbRoWQl2QN/ul1a3tM=;
        h=Date:To:From:Subject:From;
        b=g1CX4uobLIfVjQjy79pbtCe4H/MtF1vgK2R04mq4iY8Ih7NVK9Ovr39NTkJZUrGL/
         BurhfQAPEhPSukmr2i0VBM/dKNFQmDmKWu5h4XIgHT+a+u7nXAcmbNYJccLpW0g1aa
         WJcAPRmh/UiuyyVtyEVDeGg4CSIhgYoXXjtjb1lA=
Date:   Thu, 01 Sep 2022 12:07:01 -0700
To:     mm-commits@vger.kernel.org, jack@suse.cz, yi.zhang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-buffer-remove-bh_submit_read-helper.patch added to mm-unstable branch
Message-Id: <20220901190702.400B6C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/buffer: remove bh_submit_read() helper
has been added to the -mm mm-unstable branch.  Its filename is
     fs-buffer-remove-bh_submit_read-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-buffer-remove-bh_submit_read-helper.patch

This patch will later appear in the mm-unstable branch at
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
From: Zhang Yi <yi.zhang@huawei.com>
Subject: fs/buffer: remove bh_submit_read() helper
Date: Thu, 1 Sep 2022 21:35:05 +0800

bh_submit_read() has no user anymore, just remove it.

Link: https://lkml.kernel.org/r/20220901133505.2510834-15-yi.zhang@huawei.com
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |   25 -------------------------
 include/linux/buffer_head.h |    1 -
 2 files changed, 26 deletions(-)

--- a/fs/buffer.c~fs-buffer-remove-bh_submit_read-helper
+++ a/fs/buffer.c
@@ -3025,31 +3025,6 @@ void __bh_read_batch(int nr, struct buff
 }
 EXPORT_SYMBOL(__bh_read_batch);
 
-/**
- * bh_submit_read - Submit a locked buffer for reading
- * @bh: struct buffer_head
- *
- * Returns zero on success and -EIO on error.
- */
-int bh_submit_read(struct buffer_head *bh)
-{
-	BUG_ON(!buffer_locked(bh));
-
-	if (buffer_uptodate(bh)) {
-		unlock_buffer(bh);
-		return 0;
-	}
-
-	get_bh(bh);
-	bh->b_end_io = end_buffer_read_sync;
-	submit_bh(REQ_OP_READ, bh);
-	wait_on_buffer(bh);
-	if (buffer_uptodate(bh))
-		return 0;
-	return -EIO;
-}
-EXPORT_SYMBOL(bh_submit_read);
-
 void __init buffer_init(void)
 {
 	unsigned long nrpages;
--- a/include/linux/buffer_head.h~fs-buffer-remove-bh_submit_read-helper
+++ a/include/linux/buffer_head.h
@@ -230,7 +230,6 @@ int submit_bh(blk_opf_t, struct buffer_h
 void write_boundary_block(struct block_device *bdev,
 			sector_t bblock, unsigned blocksize);
 int bh_uptodate_or_lock(struct buffer_head *bh);
-int bh_submit_read(struct buffer_head *bh);
 int __bh_read(struct buffer_head *bh, blk_opf_t op_flags, bool wait);
 void __bh_read_batch(int nr, struct buffer_head *bhs[],
 		     blk_opf_t op_flags, bool force_lock);
_

Patches currently in -mm which might be from yi.zhang@huawei.com are

fs-buffer-remove-__breadahead_gfp.patch
fs-buffer-add-some-new-buffer-read-helpers.patch
fs-buffer-replace-ll_rw_block.patch
gfs2-replace-ll_rw_block.patch
isofs-replace-ll_rw_block.patch
jbd2-replace-ll_rw_block.patch
ntfs3-replace-ll_rw_block.patch
ocfs2-replace-ll_rw_block.patch
reiserfs-replace-ll_rw_block.patch
udf-replace-ll_rw_block.patch
ufs-replace-ll_rw_block.patch
fs-buffer-remove-ll_rw_block-helper.patch
ext2-replace-bh_submit_read-helper-with-bh_read_locked.patch
fs-buffer-remove-bh_submit_read-helper.patch

