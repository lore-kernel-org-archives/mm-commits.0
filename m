Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47267C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:41:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3023261994
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:41:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234027AbhKKCoY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:44:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:49788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234019AbhKKCoY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:44:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CE1A61284;
        Thu, 11 Nov 2021 02:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598495;
        bh=n1sF9Jt8ghr4LDSuhs5y7NxdTepv4W9XyM95B+T/dQI=;
        h=Date:From:To:Subject:From;
        b=ZUF9JMXM/M+c0euHGZ8A9Ke8WOGEbClpQKgjbU9gnBtocUnUVl0J6Mq4j9g+T3JeR
         DFdeS5hHwxK3+POWvG+vIh1OhkX55FsM3WAAK7Sjy1J3/sdCojb456IObNO496Mi7Q
         yS50fwonP4X7AA9OZWzNNG1eDO7DhDy3UKa8UQTI=
Date:   Wed, 10 Nov 2021 18:41:35 -0800
From:   akpm@linux-foundation.org
To:     asml.silence@gmail.com, axboe@kernel.dk, clm@fb.com,
        david@fromorbit.com, jack@suse.cz, josef@redhat.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-dont-read-i_size-of-inode-unless-we-need-it.patch removed from -mm tree
Message-ID: <20211111024135.wm7XwTDfO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: don't read i_size of inode unless we need it
has been removed from the -mm tree.  Its filename was
     mm-dont-read-i_size-of-inode-unless-we-need-it.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


