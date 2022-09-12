Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFF22C54EE9
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:34:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbiILDey (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiILDdX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:33:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C411329818
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:30:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7CB12B80C75
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:30:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E306C433D6;
        Mon, 12 Sep 2022 03:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953429;
        bh=RiT03U45WdzAuxrIL0uFM/8eGV3cUSOunOFI90h2/dI=;
        h=Date:To:From:Subject:From;
        b=Zlhk0iq/hYJendCG8TXWiQ63LDitBvB2qeMWyrYEQ/PTX/DDaxCcxpceK0jaVOM7k
         WT0HbxeCIZHm/nLKwVgvqxtHpdPP5gmLazdFl1htH+BiLfumU9aRMxs4rVBRK9OruS
         xrfMuhTLRURv6mZKbJxiVFMGrMhvKkBUOz4w30Rw=
Date:   Sun, 11 Sep 2022 20:30:28 -0700
To:     mm-commits@vger.kernel.org, jack@suse.cz, hch@lst.de,
        yi.zhang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] isofs-replace-ll_rw_block.patch removed from -mm tree
Message-Id: <20220912033029.2E306C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: isofs: replace ll_rw_block()
has been removed from the -mm tree.  Its filename was
     isofs-replace-ll_rw_block.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhang Yi <yi.zhang@huawei.com>
Subject: isofs: replace ll_rw_block()
Date: Thu, 1 Sep 2022 21:34:56 +0800

ll_rw_block() is not safe for the sync read path because it cannot
guarantee that submitting read IO if the buffer has been locked. We
could get false positive EIO return from zisofs_uncompress_block() if
he buffer has been locked by others. So stop using ll_rw_block(),
switch to sync helper instead.

Link: https://lkml.kernel.org/r/20220901133505.2510834-6-yi.zhang@huawei.com
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/isofs/compress.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/isofs/compress.c~isofs-replace-ll_rw_block
+++ a/fs/isofs/compress.c
@@ -82,7 +82,7 @@ static loff_t zisofs_uncompress_block(st
 		return 0;
 	}
 	haveblocks = isofs_get_blocks(inode, blocknum, bhs, needblocks);
-	ll_rw_block(REQ_OP_READ, haveblocks, bhs);
+	bh_read_batch(haveblocks, bhs);
 
 	curbh = 0;
 	curpage = 0;
_

Patches currently in -mm which might be from yi.zhang@huawei.com are


