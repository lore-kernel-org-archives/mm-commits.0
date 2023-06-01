Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4C3FC7EE2E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jun 2023 22:29:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233220AbjFAW3t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Jun 2023 18:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233233AbjFAW3g (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2023 18:29:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07C0612C
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 15:29:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CBFB64A89
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 22:29:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4EEAC433D2;
        Thu,  1 Jun 2023 22:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685658573;
        bh=mpOJjn5a2ddCDVokB72IgYdahIfg8qAXxGhUm9qO0Jw=;
        h=Date:To:From:Subject:From;
        b=JhpRFTjY/VW+CZossfmTHkQKP33iRTzm61K3Q9NE+DCuPpodSgNLrv+O7Lor+D0vl
         nU++2FrQ1SUM4A78OAOj/+ghn941YpPiALssnyfdon7cy81ud3I1viNJS9qj5oMMjk
         5Lif3e2Oh72Ecnh8fZuyS+4PTnpJErTTY/PzHmqU=
Date:   Thu, 01 Jun 2023 15:29:32 -0700
To:     mm-commits@vger.kernel.org, xiubli@redhat.com, willy@infradead.org,
        viro@zeniv.linux.org.uk, tytso@mit.edu,
        trond.myklebust@hammerspace.com, mszeredi@redhat.com,
        miklos@szeredi.hu, johannes.thumshirn@wdc.com, jaegeuk@kernel.org,
        idryomov@gmail.com, hare@suse.de, dlemoal@kernel.org,
        djwong@kernel.org, chao@kernel.org, brauner@kernel.org,
        axboe@kernel.dk, anna@kernel.org, agruenba@redhat.com, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fuse-use-direct_write_fallback.patch added to mm-unstable branch
Message-Id: <20230601222932.E4EEAC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fuse: use direct_write_fallback
has been added to the -mm mm-unstable branch.  Its filename is
     fuse-use-direct_write_fallback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fuse-use-direct_write_fallback.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: fuse: use direct_write_fallback
Date: Thu, 1 Jun 2023 16:59:04 +0200

Use the generic direct_write_fallback helper instead of duplicating the
logic.

Link: https://lkml.kernel.org/r/20230601145904.1385409-13-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Anna Schumaker <anna@kernel.org>
Cc: Chao Yu <chao@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Xiubo Li <xiubli@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/file.c |   24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

--- a/fs/fuse/file.c~fuse-use-direct_write_fallback
+++ a/fs/fuse/file.c
@@ -1340,7 +1340,6 @@ static ssize_t fuse_cache_write_iter(str
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
 	ssize_t written = 0;
-	ssize_t written_buffered = 0;
 	struct inode *inode = mapping->host;
 	ssize_t err;
 	struct fuse_conn *fc = get_fuse_conn(inode);
@@ -1377,30 +1376,11 @@ writethrough:
 		goto out;
 
 	if (iocb->ki_flags & IOCB_DIRECT) {
-		loff_t pos, endbyte;
-
 		written = generic_file_direct_write(iocb, from);
 		if (written < 0 || !iov_iter_count(from))
 			goto out;
-
-		written_buffered = fuse_perform_write(iocb, from);
-		if (written_buffered < 0) {
-			err = written_buffered;
-			goto out;
-		}
-		pos = iocb->ki_pos - written_buffered;
-		endbyte = iocb->ki_pos - 1;
-
-		err = filemap_write_and_wait_range(file->f_mapping, pos,
-						   endbyte);
-		if (err)
-			goto out;
-
-		invalidate_mapping_pages(file->f_mapping,
-					 pos >> PAGE_SHIFT,
-					 endbyte >> PAGE_SHIFT);
-
-		written += written_buffered;
+		written = direct_write_fallback(iocb, from, written,
+				fuse_perform_write(iocb, from));
 	} else {
 		written = fuse_perform_write(iocb, from);
 	}
_

Patches currently in -mm which might be from hch@lst.de are

backing_dev-remove-current-backing_dev_info.patch
iomap-update-ki_pos-a-little-later-in-iomap_dio_complete.patch
filemap-update-ki_pos-in-generic_perform_write.patch
filemap-add-a-kiocb_write_and_wait-helper.patch
filemap-add-a-kiocb_invalidate_pages-helper.patch
filemap-add-a-kiocb_invalidate_post_direct_write-helper.patch
iomap-update-ki_pos-in-iomap_file_buffered_write.patch
iomap-use-kiocb_write_and_wait-and-kiocb_invalidate_pages.patch
fs-factor-out-a-direct_write_fallback-helper.patch
fuse-update-ki_pos-in-fuse_perform_write.patch
fuse-drop-redundant-arguments-to-fuse_perform_write.patch
fuse-use-direct_write_fallback.patch
squashfs-dont-include-buffer_headh.patch

