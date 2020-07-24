Return-Path: <SRS0=g5V1=BD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE888C433EB
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 04:15:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFE592064B
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 04:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595564141;
	bh=4FftRsrLnSVZlOac7ovP38tViYU+X9KzWfXXsW9BEws=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=RdAI9KYOO4K3mCv2tb4Ts0Qtnzk6zJBWQ8AdiLiJr88n21ad3wTIcIi832xkaZvph
	 cRicwUngDn3cArINp0Ogp6lYlN8IB7pX1ommVSgnA9qLY5jMwUV9j71vDX5fRLhOVn
	 RKHM9e59Xwp9PghGCZ1JhA3z/TvOZO1Zcow/SnXs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbgGXEPl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Jul 2020 00:15:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:54126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgGXEPl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Jul 2020 00:15:41 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 677FB2064C;
        Fri, 24 Jul 2020 04:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595564140;
        bh=4FftRsrLnSVZlOac7ovP38tViYU+X9KzWfXXsW9BEws=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=r7s0dXBLMCUJmNXoDlBkxLlQTfmhApl6t9qEazRcu5YtZMKgNpRX2PA/SoPj2dL2T
         8+k2CDC/nW2m8MLx6AbrwR2bkPQvDkdSUWGqpIzxCAHgjwFEvfWFt+/pVTTxilG9RK
         uiEQcYbAL2h2vmxOEipyEIBiuwU8SH5j7b1ZLKIc=
Date:   Thu, 23 Jul 2020 21:15:40 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adrien+dev@schischi.me, akpm@linux-foundation.org,
        bernd.amend@gmail.com, drosen@google.com, groeck@chromium.org,
        hch@lst.de, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        phillip@squashfs.org.uk, torvalds@linux-foundation.org
Subject:  [patch 11/15] squashfs: fix length field overlap check in
 metadata reading
Message-ID: <20200724041540.wz6q4aH2w%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
