Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F31FCECAAD3
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:34:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbiILDeq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiILDdT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:33:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 924B927FF1
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:30:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C9EBB80C76
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:30:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03DEFC433C1;
        Mon, 12 Sep 2022 03:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953428;
        bh=ht+AFZH0oFcGoknxhNl7g2J6fsc/iFx3nDSYsSOThQM=;
        h=Date:To:From:Subject:From;
        b=FCZHwl7/Ywr9gkImunup6xSqNdJknXdJKATEMmJuhAd0JeqOU+fFd4iAn27uAF2nd
         Vo0ZYc2YEfLq5O7fZmP0h0BUIHNtbPReccT0Dlmj0Z2ztxnPXaw7zSwcEdkWAWu2na
         vbcPWhEt1MxeNiO8yw1LfPTFoMIhVqM8SB63jkq0=
Date:   Sun, 11 Sep 2022 20:30:27 -0700
To:     mm-commits@vger.kernel.org, jack@suse.cz, hch@lst.de,
        agruenba@redhat.com, yi.zhang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] gfs2-replace-ll_rw_block.patch removed from -mm tree
Message-Id: <20220912033028.03DEFC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: gfs2: replace ll_rw_block()
has been removed from the -mm tree.  Its filename was
     gfs2-replace-ll_rw_block.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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


