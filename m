Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53380C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:37:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E63460E08
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:37:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232997AbhKEUjs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:39:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:34636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231842AbhKEUjs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:39:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9CDB60E05;
        Fri,  5 Nov 2021 20:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144628;
        bh=k7WljE0iQVEK2JtPw8YULivJdqphpmtM/3TtjO4wdWc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=sx4/h36y7mqB0iHe9hbEfNxMJs0UrlNaBNQvX9l+cdSRw2qreQ3w3LoSEr31PiSSV
         9mBP838UTeG5NwRQoovDLEDTcAZhWQcXhugjy5dutQTBBkOW96+mJvhkVJ3dYrP7C2
         osmfkhbqsIjr4Gqtze2d4i7Ebtf37/cUpYiyb9a4=
Date:   Fri, 05 Nov 2021 13:37:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, asml.silence@gmail.com, axboe@kernel.dk,
        clm@fb.com, david@fromorbit.com, jack@suse.cz, josef@redhat.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 047/262] mm: don't read i_size of inode unless we
 need it
Message-ID: <20211105203707.MxPJku2CF%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
