Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD590C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 29 Dec 2021 23:37:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233358AbhL2XhD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Dec 2021 18:37:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233344AbhL2XhC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Dec 2021 18:37:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4023FC061574
        for <mm-commits@vger.kernel.org>; Wed, 29 Dec 2021 15:37:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3BA05B819C4
        for <mm-commits@vger.kernel.org>; Wed, 29 Dec 2021 23:37:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D142BC36AEA;
        Wed, 29 Dec 2021 23:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640821019;
        bh=U6F65NtotazS3tGQfD+uEJCXw60FSfLngq0DV7qLlY4=;
        h=Date:From:To:Subject:From;
        b=t0IL7q5jd6VfXG/8ZGhERqoMaqzzHGvBMRCXadjiQTuUc5c6y0JKPYWZlooQiRV0H
         DKY1avYKf32qS1XcLQ+MmoCEvNtbSW/pM+uPMKvXax86AdGvRYB6DX3JoRSxhBKwK8
         6atFZF73/iXQYHd+D900gjY5CBdNIw13mbJNoxeQ=
Date:   Wed, 29 Dec 2021 15:36:59 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, konishi.ryusuke@gmail.com,
        colin.i.king@gmail.com
Subject:  + nilfs2-remove-redundant-pointer-sbufs.patch added to -mm
 tree
Message-ID: <20211229233659.Xdyt4%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: remove redundant pointer sbufs
has been added to the -mm tree.  Its filename is
     nilfs2-remove-redundant-pointer-sbufs.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/nilfs2-remove-redundant-pointer-sbufs.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-remove-redundant-pointer-sbufs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Colin Ian King <colin.i.king@gmail.com>
Subject: nilfs2: remove redundant pointer sbufs

Pointer sbufs is being assigned a value but it's not being used later on. 
The pointer is redundant and can be removed.  Cleans up scan-build static
analysis warning:

fs/nilfs2/page.c:203:8: warning: Although the value stored to 'sbufs'
is used in the enclosing expression, the value is never actually read
from 'sbufs' [deadcode.DeadStores]
        sbh = sbufs = page_buffers(src);

Link: https://lkml.kernel.org/r/20211211180955.550380-1-colin.i.king@gmail.com
Link: https://lkml.kernel.org/r/1640712476-15136-1-git-send-email-konishi.ryusuke@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/page.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nilfs2/page.c~nilfs2-remove-redundant-pointer-sbufs
+++ a/fs/nilfs2/page.c
@@ -195,12 +195,12 @@ void nilfs_page_bug(struct page *page)
  */
 static void nilfs_copy_page(struct page *dst, struct page *src, int copy_dirty)
 {
-	struct buffer_head *dbh, *dbufs, *sbh, *sbufs;
+	struct buffer_head *dbh, *dbufs, *sbh;
 	unsigned long mask = NILFS_BUFFER_INHERENT_BITS;
 
 	BUG_ON(PageWriteback(dst));
 
-	sbh = sbufs = page_buffers(src);
+	sbh = page_buffers(src);
 	if (!page_has_buffers(dst))
 		create_empty_buffers(dst, sbh->b_size, 0);
 
_

Patches currently in -mm which might be from colin.i.king@gmail.com are

mm-migrate-remove-redundant-variables-used-in-a-for-loop.patch
nilfs2-remove-redundant-pointer-sbufs.patch
kernel-sysctlc-remove-unused-variable-ten_thousand.patch

