Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D79FEC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 02:57:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0F876142A
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 02:57:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232643AbhJVC76 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Oct 2021 22:59:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:33890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232590AbhJVC76 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 21 Oct 2021 22:59:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E8B861425;
        Fri, 22 Oct 2021 02:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634871461;
        bh=g1P+JGbubHsuVqLKigWOcZdJXuQGJKVDY7k5BrYPXLU=;
        h=Date:From:To:Subject:From;
        b=QAzVyJSBhUw9v97KdOwUMV6XkEzC4EoV93a5ToKce9vo1DmMKZ8ky3wPOkd/JZUIw
         55BHfRIG1uPzXGsejgIMuXbsOl6Pgpn/53r8Mwx1ftw0YunaNXpWoYQXaUbv2F/1XG
         Gz+NNGcPZeC8f4BTfftOpfrchEIa5z7/0kNW2ejY=
Date:   Thu, 21 Oct 2021 19:57:40 -0700
From:   akpm@linux-foundation.org
To:     hch@lst.de, jack@suse.cz, miquel.raynal@bootlin.com,
        mm-commits@vger.kernel.org, richard@nod.at, vigneshr@ti.com
Subject:  + mm-export-bdi_unregister.patch added to -mm tree
Message-ID: <20211022025740.Fyt2qALcf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: export bdi_unregister
has been added to the -mm tree.  Its filename is
     mm-export-bdi_unregister.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-export-bdi_unregister.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-export-bdi_unregister.patch

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
Subject: mm: export bdi_unregister

Patch series "simplify bdi unregistation".

This series simplifies the BDI code to get rid of the magic
auto-unregister feature that hid a recent block layer refcounting bug.


This patch (of 5):

To wind down the magic auto-unregister semantics we'll need to push this
into modular code.

Link: https://lkml.kernel.org/r/20211021124441.668816-1-hch@lst.de
Link: https://lkml.kernel.org/r/20211021124441.668816-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Vignesh Raghavendra <vigneshr@ti.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/backing-dev.c~mm-export-bdi_unregister
+++ a/mm/backing-dev.c
@@ -965,6 +965,7 @@ void bdi_unregister(struct backing_dev_i
 		bdi->owner = NULL;
 	}
 }
+EXPORT_SYMBOL(bdi_unregister);
 
 static void release_bdi(struct kref *ref)
 {
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

