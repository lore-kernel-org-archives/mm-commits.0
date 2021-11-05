Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73862C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:37:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5259D6125F
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:37:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232954AbhKEUjm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:39:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:34520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231842AbhKEUjm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:39:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCEA461242;
        Fri,  5 Nov 2021 20:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144622;
        bh=whFe3f09wOkOblZuiOhkmdNFJjqy8eyUdcc/AyCZSxo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=W7KgDrzY4E4V56cknMYQW+oYGS+Ui83/U8ArReRajRz5R2dy3hKbp45LdXnEBPB6x
         aJe4ZZXZJWb2D3gAbRoHSZIQeM4oLT5fxF3O4voxnG1pz1QG9kSHYwa9LOZHk4zqex
         zdn5ssdCo4DQE8E2k7dZSUZuDpJRUz1ot6mzqg1E=
Date:   Fri, 05 Nov 2021 13:37:01 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hch@lst.de, jack@suse.cz,
        linux-mm@kvack.org, miquel.raynal@bootlin.com,
        mm-commits@vger.kernel.org, richard@nod.at,
        torvalds@linux-foundation.org, vigneshr@ti.com
Subject:  [patch 045/262] mm: don't automatically unregister bdis
Message-ID: <20211105203701.M3N9WiZBX%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Subject: mm: don't automatically unregister bdis

All BDI users now unregister explicitly.

Link: https://lkml.kernel.org/r/20211021124441.668816-5-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/backing-dev.c~mm-dont-automatically-unregister-bdis
+++ a/mm/backing-dev.c
@@ -965,8 +965,7 @@ static void release_bdi(struct kref *ref
 	struct backing_dev_info *bdi =
 			container_of(ref, struct backing_dev_info, refcnt);
 
-	if (test_bit(WB_registered, &bdi->wb.state))
-		bdi_unregister(bdi);
+	WARN_ON_ONCE(test_bit(WB_registered, &bdi->wb.state));
 	WARN_ON_ONCE(bdi->dev);
 	wb_exit(&bdi->wb);
 	kfree(bdi);
_
