Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00A4CC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 02:57:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D323061439
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 02:57:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232641AbhJVDAB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Oct 2021 23:00:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:33922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232626AbhJVC77 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 21 Oct 2021 22:59:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED8E96142A;
        Fri, 22 Oct 2021 02:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634871463;
        bh=QFMD3kJd1XAbN/TQFe8veZv01342ZVb0sm1wVcH8ygU=;
        h=Date:From:To:Subject:From;
        b=gPejCMi3NP+HUcUexRuDVJ6v/T7EZt12nVJnfoEg6beoJT/bEoA0o1+DiHIgkPAjT
         nXBBm/Ex+7GBpJNh3T1J4MYvbJR/aWE8cHvOli8mC9UkYzrbosiCM0lp22cJ6o6BvT
         RPFO6FiOBzfnp9VRkwW5U9G9r1iKpG+sGNWYKoX0=
Date:   Thu, 21 Oct 2021 19:57:42 -0700
From:   akpm@linux-foundation.org
To:     hch@lst.de, jack@suse.cz, miquel.raynal@bootlin.com,
        mm-commits@vger.kernel.org, richard@nod.at, vigneshr@ti.com
Subject:  + mtd-call-bdi_unregister-explicitly.patch added to -mm
 tree
Message-ID: <20211022025742.J1tauFZz2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mtd: call bdi_unregister explicitly
has been added to the -mm tree.  Its filename is
     mtd-call-bdi_unregister-explicitly.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mtd-call-bdi_unregister-explicitly.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mtd-call-bdi_unregister-explicitly.patch

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
Subject: mtd: call bdi_unregister explicitly

Call bdi_unregister explicitly instead of relying on the automatic
unregistration.

Link: https://lkml.kernel.org/r/20211021124441.668816-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
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

mm-dont-include-linux-daxh-in-linux-mempolicyh.patch
mm-export-bdi_unregister.patch
mtd-call-bdi_unregister-explicitly.patch
fs-explicitly-unregister-per-superblock-bdis.patch
mm-dont-automatically-unregister-bdis.patch
mm-simplify-bdi-refcounting.patch
mm-unexport-folio_memcg_unlock.patch
mm-unexport-unlock_page_memcg.patch

