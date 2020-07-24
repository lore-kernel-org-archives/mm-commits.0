Return-Path: <SRS0=g5V1=BD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68456C433E3
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 23:38:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3919A2070E
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 23:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595633920;
	bh=pFQn52XOfp1zZE3zKgK/DF7hv4vRmQNd3x5Z5Q91t5k=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=UyyrCFfOBZ88lcnMg9yUh/ZsXZZ41JdEyEGzV+dUNQUaR9Q/1pjVJm0j9IkxE+Zh7
	 s0WOfQQAfQOMVdzNjCc14izQeSn6Cc9CfSVaodVxtJmAPtegxxpUyq3KodAatEqfOG
	 7ofS/yKes/Uc2IJ4TzTsMqXJ7d9PIDPUonZdWP0M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgGXXij (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Jul 2020 19:38:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:44412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726552AbgGXXij (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Jul 2020 19:38:39 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91FF9206E3;
        Fri, 24 Jul 2020 23:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595633919;
        bh=pFQn52XOfp1zZE3zKgK/DF7hv4vRmQNd3x5Z5Q91t5k=;
        h=Date:From:To:Subject:From;
        b=PT3wn+qET52OKNFMg2qsgP0HiKP1w6ZG9De9p3gwEjDQXDljrR5uyAYZsiry7sK2E
         IblMPROXOyY24yAyDpxHakP4pYNl5UDxOQ4Xeo60YqtOylNiiwPk8Qxwf9OuDzxF0M
         olCQd/S4h/b4XaN3zmNKj012+fmH9HGKVMXUciMc=
Date:   Fri, 24 Jul 2020 16:38:38 -0700
From:   akpm@linux-foundation.org
To:     adrien+dev@schischi.me, bernd.amend@gmail.com, drosen@google.com,
        groeck@chromium.org, hch@lst.de, mm-commits@vger.kernel.org,
        phillip@squashfs.org.uk
Subject:  [merged]
 squashfs-fix-length-field-overlap-check-in-metadata-reading.patch removed
 from -mm tree
Message-ID: <20200724233838.cPL9au5Ep%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: squashfs: fix length field overlap check in metadata reading
has been removed from the -mm tree.  Its filename was
     squashfs-fix-length-field-overlap-check-in-metadata-reading.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


