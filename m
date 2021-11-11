Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D767C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:41:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DF2561872
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:41:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234023AbhKKCoV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:44:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:49728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234019AbhKKCoT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:44:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C3CC61260;
        Thu, 11 Nov 2021 02:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598491;
        bh=Ol2SfLfztToRbBxcQwUKs2IYj6aPadx8aTMuIlmLvEc=;
        h=Date:From:To:Subject:From;
        b=eYOEvtKKbz/InI2rrHsgIByb7V01/d3dvkQC5WCoSemv0hNAJ+BuerEQ5g8v+QA5N
         T/tllScsdXEvrIvQi4r1kTF8CM7Cu3n53uJxsgmaoiDzXELduh944LYTVtW6OMLHz9
         8Y3SCHZDkSpCE0Fojp8w/2KE9PWpNNi/ky0zhl9A=
Date:   Wed, 10 Nov 2021 18:41:31 -0800
From:   akpm@linux-foundation.org
To:     hch@lst.de, jack@suse.cz, miquel.raynal@bootlin.com,
        mm-commits@vger.kernel.org, richard@nod.at, vigneshr@ti.com
Subject:  [merged] mm-dont-automatically-unregister-bdis.patch
 removed from -mm tree
Message-ID: <20211111024131.wUK05E4f7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: don't automatically unregister bdis
has been removed from the -mm tree.  Its filename was
     mm-dont-automatically-unregister-bdis.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from hch@lst.de are

mm-unexport-folio_memcg_unlock.patch
mm-unexport-unlock_page_memcg.patch

