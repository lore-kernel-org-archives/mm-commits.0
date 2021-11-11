Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E07BAC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:41:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C63D261872
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:41:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234013AbhKKCoR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:44:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:49664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233954AbhKKCoP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:44:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C1CA61354;
        Thu, 11 Nov 2021 02:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598487;
        bh=00i9VsMGFIOB+ayw+9ORZha6yDjWT6cWu+3snwmVU54=;
        h=Date:From:To:Subject:From;
        b=mfooaXvIoLlbCDJsqPsaNkVDdRVxi8nOuqWmS2wbBI42BS81jllUSHLSPs574wuly
         rN+NT1QvZAueepOxsDdf4TLAObOVkriSRT68Xkij6tMTH2lkOqKNeAkY616avYqRUN
         dUqtMm5tsGMJ7BKB/QBrcZpi4vZAiO2pt4/bGSXE=
Date:   Wed, 10 Nov 2021 18:41:27 -0800
From:   akpm@linux-foundation.org
To:     hch@lst.de, jack@suse.cz, miquel.raynal@bootlin.com,
        mm-commits@vger.kernel.org, richard@nod.at, vigneshr@ti.com
Subject:  [merged] mtd-call-bdi_unregister-explicitly.patch removed
 from -mm tree
Message-ID: <20211111024127.jBdoaGLXC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mtd: call bdi_unregister explicitly
has been removed from the -mm tree.  Its filename was
     mtd-call-bdi_unregister-explicitly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mtd: call bdi_unregister explicitly

Call bdi_unregister explicitly instead of relying on the automatic
unregistration.

Link: https://lkml.kernel.org/r/20211021124441.668816-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/mtdcore.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mtd/mtdcore.c~mtd-call-bdi_unregister-explicitly
+++ a/drivers/mtd/mtdcore.c
@@ -2409,6 +2409,7 @@ static void __exit cleanup_mtd(void)
 	if (proc_mtd)
 		remove_proc_entry("mtd", NULL);
 	class_unregister(&mtd_class);
+	bdi_unregister(mtd_bdi);
 	bdi_put(mtd_bdi);
 	idr_destroy(&mtd_idr);
 }
_

Patches currently in -mm which might be from hch@lst.de are

mm-unexport-folio_memcg_unlock.patch
mm-unexport-unlock_page_memcg.patch

