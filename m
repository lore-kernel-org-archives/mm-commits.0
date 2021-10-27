Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29855C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 20:15:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F88F610A0
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 20:15:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236779AbhJ0USD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Oct 2021 16:18:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:57714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236554AbhJ0USC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 Oct 2021 16:18:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8DCA60EC0;
        Wed, 27 Oct 2021 20:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635365736;
        bh=NeNNdE2MgvYsN1PSVUQswocS+dX9T+Nf2n4NewUBSg4=;
        h=Date:From:To:Subject:From;
        b=mOTgPHV2mrEpgWeWnLOiwD82WUNuB3HUR9Brv2sKotcqI0nloQGDuDWv4YrrT/0k9
         9LLdzzxUCAtkkRWOSPs1HRp2JZp7Icl8wVUtCU6m/MuLhLdeQSar1pZ8WwfVJKbje2
         S8899Dv4IxByG0UMfedvNQin9PtHUc+u3ff0IOmo=
Date:   Wed, 27 Oct 2021 13:15:36 -0700
From:   akpm@linux-foundation.org
To:     asml.silence@gmail.com, axboe@kernel.dk, clm@fb.com,
        david@fromorbit.com, jack@suse.cz, josef@redhat.com,
        mm-commits@vger.kernel.org
Subject:  + mm-dont-read-i_size-of-inode-unless-we-need-it.patch
 added to -mm tree
Message-ID: <20211027201536.Y_pPgGyw-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: don't read i_size of inode unless we need it
has been added to the -mm tree.  Its filename is
     mm-dont-read-i_size-of-inode-unless-we-need-it.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-dont-read-i_size-of-inode-unless-we-need-it.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-dont-read-i_size-of-inode-unless-we-need-it.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jens Axboe <axboe@kernel.dk>
Subject: mm: don't read i_size of inode unless we need it

We always go through i_size_read(), and we rarely end up needing it. Push
the read to down where we need to check it, which avoids it for most
cases.

It looks like we can even remove this check entirely, which might be
worth pursuing. But at least this takes it out of the hot path.

Link: https://lkml.kernel.org/r/6b67981f-57d4-c80e-bc07-6020aa601381@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Acked-by: Chris Mason <clm@fb.com>
Cc: Josef Bacik <josef@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/filemap.c~mm-dont-read-i_size-of-inode-unless-we-need-it
+++ a/mm/filemap.c
@@ -2740,9 +2740,7 @@ generic_file_read_iter(struct kiocb *ioc
 		struct file *file = iocb->ki_filp;
 		struct address_space *mapping = file->f_mapping;
 		struct inode *inode = mapping->host;
-		loff_t size;
 
-		size = i_size_read(inode);
 		if (iocb->ki_flags & IOCB_NOWAIT) {
 			if (filemap_range_needs_writeback(mapping, iocb->ki_pos,
 						iocb->ki_pos + count - 1))
@@ -2774,8 +2772,9 @@ generic_file_read_iter(struct kiocb *ioc
 		 * the rest of the read.  Buffered reads will not work for
 		 * DAX files, so don't bother trying.
 		 */
-		if (retval < 0 || !count || iocb->ki_pos >= size ||
-		    IS_DAX(inode))
+		if (retval < 0 || !count || IS_DAX(inode))
+			return retval;
+		if (iocb->ki_pos >= i_size_read(inode))
 			return retval;
 	}
 
_

Patches currently in -mm which might be from axboe@kernel.dk are

mm-dont-read-i_size-of-inode-unless-we-need-it.patch
mm-move-more-expensive-part-of-xa-setup-out-of-mapping-check.patch

