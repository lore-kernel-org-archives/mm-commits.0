Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69C8CC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:41:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4876961354
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:41:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234012AbhKKCoO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:44:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:49632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233954AbhKKCoO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:44:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95100610F7;
        Thu, 11 Nov 2021 02:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598485;
        bh=fAL1+lf9N7URtigqs8dxfalGhxC9GZMfllV2kFxcX84=;
        h=Date:From:To:Subject:From;
        b=w7oWIFpJa+QFypKkJvy7MmBDhwy9UB1+hsuqcPk2BqerPJq6wlv+SHCsHOJ8pkR1I
         cJQ+/gWF47tHQcwMI1557eVlghroHDq0DrZ7yBQmpYlZTHcacgz1XpaYrjOrryb0cN
         3LPk3EKIBYx9djS0YCb6IOHl5SuRrSzpLiXlKSZQ=
Date:   Wed, 10 Nov 2021 18:41:22 -0800
From:   akpm@linux-foundation.org
To:     hch@lst.de, jack@suse.cz, miquel.raynal@bootlin.com,
        mm-commits@vger.kernel.org, richard@nod.at, vigneshr@ti.com
Subject:  [merged] mm-export-bdi_unregister.patch removed from -mm
 tree
Message-ID: <20211111024122.awnoXujue%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: export bdi_unregister
has been removed from the -mm tree.  Its filename was
     mm-export-bdi_unregister.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/backing-dev.c~mm-export-bdi_unregister
+++ a/mm/backing-dev.c
@@ -958,6 +958,7 @@ void bdi_unregister(struct backing_dev_i
 		bdi->owner = NULL;
 	}
 }
+EXPORT_SYMBOL(bdi_unregister);
 
 static void release_bdi(struct kref *ref)
 {
_

Patches currently in -mm which might be from hch@lst.de are

mm-unexport-folio_memcg_unlock.patch
mm-unexport-unlock_page_memcg.patch

