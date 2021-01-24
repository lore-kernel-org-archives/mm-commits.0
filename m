Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2A22C433E0
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:50:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAC5722D06
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:50:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbhAXBud (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 23 Jan 2021 20:50:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:49932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726481AbhAXBuW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 23 Jan 2021 20:50:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AE6222D06;
        Sun, 24 Jan 2021 01:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611452992;
        bh=Hh+FNBTAnW2VOaHYVmbGw9k4I3XtaM4244eCtS/AgKw=;
        h=Date:From:To:Subject:From;
        b=Dyy881ICjLjrC7hWQU70wEda031J1vRG3JEIPjZDD9zs7BTSnGRqVikoMKY7eS1Kt
         v9IhZpKwOgtXSeCK2NqYRwZtjGkl11gnjeKx44j1ofzILFoBdqkiNa2/NykGmbFACm
         58Ha9zCkxIrOypdRPlQq7riWmCrL5/q87HjqmTqs=
Date:   Sat, 23 Jan 2021 17:49:51 -0800
From:   akpm@linux-foundation.org
To:     hch@lst.de, kent.overstreet@gmail.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  + mm-filemap-simplify-generic_file_read_iter.patch added
 to -mm tree
Message-ID: <20210124014951.C4_h4dUY4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: simplify generic_file_read_iter
has been added to the -mm tree.  Its filename is
     mm-filemap-simplify-generic_file_read_iter.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-filemap-simplify-generic_file_read_iter.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-filemap-simplify-generic_file_read_iter.patch

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
Subject: mm/filemap: simplify generic_file_read_iter

Avoid the pointless goto out just for returning retval.

Link: https://lkml.kernel.org/r/20210122160140.223228-19-willy@infradead.org
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/mm/filemap.c~mm-filemap-simplify-generic_file_read_iter
+++ a/mm/filemap.c
@@ -2536,7 +2536,7 @@ generic_file_read_iter(struct kiocb *ioc
 	ssize_t retval = 0;
 
 	if (!count)
-		goto out; /* skip atime */
+		return 0; /* skip atime */
 
 	if (iocb->ki_flags & IOCB_DIRECT) {
 		struct file *file = iocb->ki_filp;
@@ -2554,7 +2554,7 @@ generic_file_read_iter(struct kiocb *ioc
 						iocb->ki_pos,
 					        iocb->ki_pos + count - 1);
 			if (retval < 0)
-				goto out;
+				return retval;
 		}
 
 		file_accessed(file);
@@ -2578,12 +2578,10 @@ generic_file_read_iter(struct kiocb *ioc
 		 */
 		if (retval < 0 || !count || iocb->ki_pos >= size ||
 		    IS_DAX(inode))
-			goto out;
+			return retval;
 	}
 
-	retval = filemap_read(iocb, iter, retval);
-out:
-	return retval;
+	return filemap_read(iocb, iter, retval);
 }
 EXPORT_SYMBOL(generic_file_read_iter);
 
_

Patches currently in -mm which might be from hch@lst.de are

mm-filemap-rename-generic_file_buffered_read-to-filemap_read.patch
mm-filemap-simplify-generic_file_read_iter.patch

