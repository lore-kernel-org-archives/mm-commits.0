Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10EE5C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:36:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF20961252
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:36:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbhKEUjd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:39:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:34388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231842AbhKEUjc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:39:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C37E611C0;
        Fri,  5 Nov 2021 20:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144612;
        bh=TYOkewgMcv8aVJYVpBRuZQ4keM8guxXKpPSzDyaFzRY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Q3sV0JYtwM3fSC0fuqAzP5m/OcF6RsVLq+eZWpyXtLVnD8itFdbIw6O2kWETUyHMg
         rpOUyQWl0nVf6PU/PSoyyAOtjMz0Zr6Ls6xwK5bnj6Y4o5DwtSSS3p/StulwiiGWlW
         n9p7uReLFdXAFM3kp8TgqvEy/ZxpFjGc6CeDEiWQ=
Date:   Fri, 05 Nov 2021 13:36:52 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hch@lst.de, jack@suse.cz,
        linux-mm@kvack.org, miquel.raynal@bootlin.com,
        mm-commits@vger.kernel.org, richard@nod.at,
        torvalds@linux-foundation.org, vigneshr@ti.com
Subject:  [patch 042/262] mm: export bdi_unregister
Message-ID: <20211105203652._au34liRg%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
