Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63652C64991
	for <mm-commits@archiver.kernel.org>; Thu,  1 Sep 2022 19:06:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233452AbiIATGp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Sep 2022 15:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233401AbiIATGn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Sep 2022 15:06:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 667446DAE0
        for <mm-commits@vger.kernel.org>; Thu,  1 Sep 2022 12:06:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15765B825DC
        for <mm-commits@vger.kernel.org>; Thu,  1 Sep 2022 19:06:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8723C433C1;
        Thu,  1 Sep 2022 19:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662059199;
        bh=SpOQjPl+EknRXkyhVi5ZqoDgZ60vvGumdagGNN1KJ7U=;
        h=Date:To:From:Subject:From;
        b=Fhsbpq+jLHzrmqfWGWLMfd9M2gsJ24rEjecJDxLMvko0MF1c6cZ9/FijLNTLhYjPT
         xJlIRhxR43bRdX+s8FjnL/qJvE4q95TK9CQgZQvNlSm5HLNZQhbsfIUj/stEHHRJ7s
         +5Vf3mtQNlCQLkS0dfYf342ypdRzdUGJSk6T7IrY=
Date:   Thu, 01 Sep 2022 12:06:39 -0700
To:     mm-commits@vger.kernel.org, jack@suse.cz, yi.zhang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + gfs2-replace-ll_rw_block.patch added to mm-unstable branch
Message-Id: <20220901190639.C8723C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: gfs2: replace ll_rw_block()
has been added to the -mm mm-unstable branch.  Its filename is
     gfs2-replace-ll_rw_block.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/gfs2-replace-ll_rw_block.patch

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
Subject: gfs2: replace ll_rw_block()
Date: Thu, 1 Sep 2022 21:34:55 +0800

ll_rw_block() is not safe for the sync read path because it cannot
guarantee that always submitting read IO if the buffer has been locked,
so stop using it. We also switch to new bh_readahead() helper for the
readahead path.

Link: https://lkml.kernel.org/r/20220901133505.2510834-5-yi.zhang@huawei.com
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/meta_io.c |    7 ++-----
 fs/gfs2/quota.c   |    8 ++------
 2 files changed, 4 insertions(+), 11 deletions(-)

--- a/fs/gfs2/meta_io.c~gfs2-replace-ll_rw_block
+++ a/fs/gfs2/meta_io.c
@@ -525,8 +525,7 @@ struct buffer_head *gfs2_meta_ra(struct
 
 	if (buffer_uptodate(first_bh))
 		goto out;
-	if (!buffer_locked(first_bh))
-		ll_rw_block(REQ_OP_READ | REQ_META | REQ_PRIO, 1, &first_bh);
+	bh_read_nowait(first_bh, REQ_META | REQ_PRIO);
 
 	dblock++;
 	extlen--;
@@ -534,9 +533,7 @@ struct buffer_head *gfs2_meta_ra(struct
 	while (extlen) {
 		bh = gfs2_getbuf(gl, dblock, CREATE);
 
-		if (!buffer_uptodate(bh) && !buffer_locked(bh))
-			ll_rw_block(REQ_OP_READ | REQ_RAHEAD | REQ_META |
-				    REQ_PRIO, 1, &bh);
+		bh_readahead(bh, REQ_RAHEAD | REQ_META | REQ_PRIO);
 		brelse(bh);
 		dblock++;
 		extlen--;
--- a/fs/gfs2/quota.c~gfs2-replace-ll_rw_block
+++ a/fs/gfs2/quota.c
@@ -745,12 +745,8 @@ static int gfs2_write_buf_to_page(struct
 		}
 		if (PageUptodate(page))
 			set_buffer_uptodate(bh);
-		if (!buffer_uptodate(bh)) {
-			ll_rw_block(REQ_OP_READ | REQ_META | REQ_PRIO, 1, &bh);
-			wait_on_buffer(bh);
-			if (!buffer_uptodate(bh))
-				goto unlock_out;
-		}
+		if (bh_read(bh, REQ_META | REQ_PRIO) < 0)
+			goto unlock_out;
 		if (gfs2_is_jdata(ip))
 			gfs2_trans_add_data(ip->i_gl, bh);
 		else
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

