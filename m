Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73076C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 02:57:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A69261440
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 02:57:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232590AbhJVDAF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Oct 2021 23:00:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232649AbhJVDAE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 21 Oct 2021 23:00:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF01861439;
        Fri, 22 Oct 2021 02:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634871468;
        bh=rZz8xll0LO1+2OytB5UsLhbUkwVFc+GWyVDv5zicYp4=;
        h=Date:From:To:Subject:From;
        b=IXKrGgcy7iyoXvK+KBMz52eOmuVfEbD5RWt59L26wnuuD8xRIWrMA7N/ppGLDMcGe
         34b2OmpvWVt8eH+AzpCI9i3URt8DeIUKhESx5yP/RW4Td5bdnV/WOE3uGfA4BBgiCS
         BJLQD1CNPerkPICMOQpH929gudzdQObslrq9F9eU=
Date:   Thu, 21 Oct 2021 19:57:47 -0700
From:   akpm@linux-foundation.org
To:     hch@lst.de, jack@suse.cz, miquel.raynal@bootlin.com,
        mm-commits@vger.kernel.org, richard@nod.at, vigneshr@ti.com
Subject:  + mm-dont-automatically-unregister-bdis.patch added to
 -mm tree
Message-ID: <20211022025747.qokVTfq4h%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: don't automatically unregister bdis
has been added to the -mm tree.  Its filename is
     mm-dont-automatically-unregister-bdis.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-dont-automatically-unregister-bdis.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-dont-automatically-unregister-bdis.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: don't automatically unregister bdis

All BDI users now unregister explicitly.

Link: https://lkml.kernel.org/r/20211021124441.668816-5-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/backing-dev.c~mm-dont-automatically-unregister-bdis
+++ a/mm/backing-dev.c
@@ -972,8 +972,7 @@ static void release_bdi(struct kref *ref
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

mm-dont-include-linux-daxh-in-linux-mempolicyh.patch
mm-export-bdi_unregister.patch
mtd-call-bdi_unregister-explicitly.patch
fs-explicitly-unregister-per-superblock-bdis.patch
mm-dont-automatically-unregister-bdis.patch
mm-simplify-bdi-refcounting.patch
mm-unexport-folio_memcg_unlock.patch
mm-unexport-unlock_page_memcg.patch

