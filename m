Return-Path: <SRS0=1ZdY=CA=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7959AC433E5
	for <mm-commits@archiver.kernel.org>; Sat, 22 Aug 2020 17:30:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53AF12173E
	for <mm-commits@archiver.kernel.org>; Sat, 22 Aug 2020 17:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598117415;
	bh=KGDgqhgQ554eNYkFxDH0RXIq76+O0vCG2qjQY/Frqlc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=1pyn5ybqTXIzFJ5vk75AI9qsPiykQ5/oFM50WWtUZcbGf+yN/VPpSmFa5K1h842L2
	 c6di0KjO3+FPunhWhaFiDzfQ3sabGVxmPVPy9XRIg6qo4uaMtXaNJCK8WrEpKZt668
	 DK1M6LYfi7yzaBFkULC5v/GNkly77nA8xXX85iTs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728434AbgHVRaO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 Aug 2020 13:30:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:53924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728400AbgHVRaC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 22 Aug 2020 13:30:02 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F9E62086A;
        Sat, 22 Aug 2020 17:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598117400;
        bh=KGDgqhgQ554eNYkFxDH0RXIq76+O0vCG2qjQY/Frqlc=;
        h=Date:From:To:Subject:From;
        b=XoiclJep1dlMrY+PMZiOSs8w148z/YF2wGxdWwxVc5heZk3RIQ8FJGhcp4YZjHda7
         pX2xAS3u4V7JgiphV8l0znvy5NZRYFDVZUnzDQbu/7ZRiDvZTMXezgQNAL7Vad6eNG
         B2Tyvi2dvS4Gpe+hl5ihAYTpk7n7kr8LJ8fIpPXo=
Date:   Sat, 22 Aug 2020 10:30:00 -0700
From:   akpm@linux-foundation.org
To:     adrien+dev@schischi.me, drosen@google.com, groeck@chromium.org,
        hch@lst.de, mm-commits@vger.kernel.org,
        nicolas.prochazka@gmail.com, phillip@squashfs.org.uk,
        pliard@google.com, shimada@walbrix.com, stable@vger.kernel.org
Subject:  [merged]
 squashfs-avoid-bio_alloc-failure-with-1mbyte-blocks.patch removed from -mm
 tree
Message-ID: <20200822173000.1Xnt4z59r%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: squashfs: avoid bio_alloc() failure with 1Mbyte blocks
has been removed from the -mm tree.  Its filename was
     squashfs-avoid-bio_alloc-failure-with-1mbyte-blocks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: squashfs: avoid bio_alloc() failure with 1Mbyte blocks

This is a regression introduced by the patch "migrate from ll_rw_block
usage to BIO".

Bio_alloc() is limited to 256 pages (1 Mbyte).  This can cause a failure
when reading 1 Mbyte block filesystems.  The problem is a datablock can be
fully (or almost uncompressed), requiring 256 pages, but, because blocks
are not aligned to page boundaries, it may require 257 pages to read.

Bio_kmalloc() can handle 1024 pages, and so use this for the edge
condition.

Link: http://lkml.kernel.org/r/20200815035637.15319-1-phillip@squashfs.org.uk
Fixes: 93e72b3c612a ("squashfs: migrate from ll_rw_block usage to BIO")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Reported-by: Nicolas Prochazka <nicolas.prochazka@gmail.com>
Reported-by: Tomoatsu Shimada <shimada@walbrix.com>
Reviewed-by: Guenter Roeck <groeck@chromium.org>
Cc: Philippe Liard <pliard@google.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Adrien Schildknecht <adrien+dev@schischi.me>
Cc: Daniel Rosenberg <drosen@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/block.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/squashfs/block.c~squashfs-avoid-bio_alloc-failure-with-1mbyte-blocks
+++ a/fs/squashfs/block.c
@@ -87,7 +87,11 @@ static int squashfs_bio_read(struct supe
 	int error, i;
 	struct bio *bio;
 
-	bio = bio_alloc(GFP_NOIO, page_count);
+	if (page_count <= BIO_MAX_PAGES)
+		bio = bio_alloc(GFP_NOIO, page_count);
+	else
+		bio = bio_kmalloc(GFP_NOIO, page_count);
+
 	if (!bio)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are


