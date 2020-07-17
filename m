Return-Path: <SRS0=ColI=A4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4027AC433E1
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jul 2020 20:20:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E28D2076A
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jul 2020 20:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595017209;
	bh=SEUJoTDfj+oVHAQnRQ42kKjxGO9GK1L+aCRPCmTVxr8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=TolPaexMvvbEu5YZvFZvX16UBQuBoO2W6HBd8A7+d8LPGuLt7TUu8uA49jWKUYn2c
	 3wI/LIkO1lqYeU+DvhiPELpm5cVDKHIR31yNPWanEPr18MsKh2g53XuVe09zoCzE2C
	 zOCPdYW9RC9/doakDdjNvJBy9QY+toHOd/qazLmI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbgGQUUI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Jul 2020 16:20:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:59970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726771AbgGQUUI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 17 Jul 2020 16:20:08 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A750D20704;
        Fri, 17 Jul 2020 20:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595017207;
        bh=SEUJoTDfj+oVHAQnRQ42kKjxGO9GK1L+aCRPCmTVxr8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=OVE9g9Fe4ctcBNY+tYLhiA9+nnFaiXTIpQDi/F1opNQoUyhZOJMA8l7nFokY0u5cl
         CTyg7jJoT1vGpEu3bbxOnpgqFt2PS52pdpsMIBZGGZ2P9EKBHqhNHE3wbEDWi0gt/A
         kMD3Ia3P4vfUwYfGtZlN+9GP7DlTryQSNIcDaojI=
Date:   Fri, 17 Jul 2020 13:20:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adrien+dev@schischi.me, bernd.amend@gmail.com, drosen@google.com,
        groeck@chromium.org, hch@lst.de, mm-commits@vger.kernel.org,
        phillip@squashfs.org.uk
Subject:  +
 squashfs-fix-length-field-overlap-check-in-metadata-reading.patch added to
 -mm tree
Message-ID: <20200717202007.f0idUL0Hn%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: squashfs: fix length field overlap check in metadata reading
has been added to the -mm tree.  Its filename is
     squashfs-fix-length-field-overlap-check-in-metadata-reading.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/squashfs-fix-length-field-overlap-check-in-metadata-reading.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/squashfs-fix-length-field-overlap-check-in-metadata-reading.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: squashfs: fix length field overlap check in metadata reading

This is a regression introduced by the "migrate from ll_rw_block usage to
BIO" patch.

Squashfs packs structures on byte boundaries, and due to that the length
field (of the metadata block) may not be fully in the current block.  The
new code rewrote and introduced a faulty check for that edge case.

Link: http://lkml.kernel.org/r/20200717195536.16069-1-phillip@squashfs.org.uk
Fixes: 93e72b3c612adcaca1 ("squashfs: migrate from ll_rw_block usage to BIO")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Reported-by: Bernd Amend <bernd.amend@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Adrien Schildknecht <adrien+dev@schischi.me>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Daniel Rosenberg <drosen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/block.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/squashfs/block.c~squashfs-fix-length-field-overlap-check-in-metadata-reading
+++ a/fs/squashfs/block.c
@@ -175,7 +175,7 @@ int squashfs_read_data(struct super_bloc
 		/* Extract the length of the metadata block */
 		data = page_address(bvec->bv_page) + bvec->bv_offset;
 		length = data[offset];
-		if (offset <= bvec->bv_len - 1) {
+		if (offset < bvec->bv_len - 1) {
 			length |= data[offset + 1] << 8;
 		} else {
 			if (WARN_ON_ONCE(!bio_next_segment(bio, &iter_all))) {
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

squashfs-fix-length-field-overlap-check-in-metadata-reading.patch

