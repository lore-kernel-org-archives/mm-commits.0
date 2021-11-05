Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 298CAC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:36:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14E6061242
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:36:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232950AbhKEUjg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:39:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:34432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231842AbhKEUjg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:39:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B52CA611C0;
        Fri,  5 Nov 2021 20:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144616;
        bh=eTuZqzSlv2o5SvGn4sWCrct+xzq3D9/H3R/OlwuiCRI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ew6W1QYPpN5JauFr8k2f8M/svicGXD69dr6aS/l+wSP2nHIWZht3pcIxgJezUdwZJ
         vVdT77DvAVoyvwZY2qqPY3Lc1D2X/opkkWCmfiq9Mw+dhZVVvtz5jqL2Pt8NeSgOXS
         X/0rTqgrJ8JoaT1kvbE1xK9wwp/LzQfdD3w74J3c=
Date:   Fri, 05 Nov 2021 13:36:55 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hch@lst.de, jack@suse.cz,
        linux-mm@kvack.org, miquel.raynal@bootlin.com,
        mm-commits@vger.kernel.org, richard@nod.at,
        torvalds@linux-foundation.org, vigneshr@ti.com
Subject:  [patch 043/262] mtd: call bdi_unregister explicitly
Message-ID: <20211105203655.7f7DgwdJ4%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
