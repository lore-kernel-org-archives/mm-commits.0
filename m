Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC362C77B7A
	for <mm-commits@archiver.kernel.org>; Fri, 19 May 2023 21:53:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbjESVxv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 May 2023 17:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbjESVxu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 May 2023 17:53:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9847112C
        for <mm-commits@vger.kernel.org>; Fri, 19 May 2023 14:53:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24CA865B7E
        for <mm-commits@vger.kernel.org>; Fri, 19 May 2023 21:53:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78DE7C433EF;
        Fri, 19 May 2023 21:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684533226;
        bh=ObZnrpRNZXm0pyde7cks1vULUEy+6q2XXlf3fjTxm/0=;
        h=Date:To:From:Subject:From;
        b=uzXqbYIyhGzcNTJ5+xDtp3s2V4EZa8WvPWWVSoFEBSLguvXwEaOkXHL4O3I6b1L8D
         RXXlhXSbRkYraCjWDGkpp3NGsIaiokqV7uoKC50D7sLhOohQzAnjgUYaUxjIFLLpbe
         EItryMotCKzI1rKaMpN6Nivwg8NrcqKeHCSk4za0=
Date:   Fri, 19 May 2023 14:53:46 -0700
To:     mm-commits@vger.kernel.org, xiubli@redhat.com, willy@infradead.org,
        viro@zeniv.linux.org.uk, tytso@mit.edu,
        trond.myklebust@hammerspace.com, miklos@szeredi.hu,
        jaegeuk@kernel.org, idryomov@gmail.com, dlemoal@kernel.org,
        djwong@kernel.org, chao@kernel.org, brauner@kernel.org,
        axboe@kernel.dk, anna@kernel.org, agruenba@redhat.com, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + iomap-assign-current-backing_dev_info-in-iomap_file_buffered_write.patch added to mm-unstable branch
Message-Id: <20230519215346.78DE7C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: iomap: assign current->backing_dev_info in iomap_file_buffered_write
has been added to the -mm mm-unstable branch.  Its filename is
     iomap-assign-current-backing_dev_info-in-iomap_file_buffered_write.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/iomap-assign-current-backing_dev_info-in-iomap_file_buffered_write.patch

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
Subject: iomap: assign current->backing_dev_info in iomap_file_buffered_write
Date: Fri, 19 May 2023 11:35:16 +0200

Move the assignment to current->backing_dev_info from the callers into
iomap_file_buffered_write to reduce boiler plate code and reduce the scope
to just around the page dirtying loop.

Note that zonefs was missing this assignment before.

Link: https://lkml.kernel.org/r/20230519093521.133226-9-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Anna Schumaker <anna@kernel.org>
Cc: Chao Yu <chao@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/file.c         |    3 ---
 fs/iomap/buffered-io.c |    3 +++
 fs/xfs/xfs_file.c      |    5 -----
 3 files changed, 3 insertions(+), 8 deletions(-)

--- a/fs/gfs2/file.c~iomap-assign-current-backing_dev_info-in-iomap_file_buffered_write
+++ a/fs/gfs2/file.c
@@ -25,7 +25,6 @@
 #include <linux/dlm.h>
 #include <linux/dlm_plock.h>
 #include <linux/delay.h>
-#include <linux/backing-dev.h>
 #include <linux/fileattr.h>
 
 #include "gfs2.h"
@@ -1041,11 +1040,9 @@ retry:
 			goto out_unlock;
 	}
 
-	current->backing_dev_info = inode_to_bdi(inode);
 	pagefault_disable();
 	ret = iomap_file_buffered_write(iocb, from, &gfs2_iomap_ops);
 	pagefault_enable();
-	current->backing_dev_info = NULL;
 	if (ret > 0)
 		written += ret;
 
--- a/fs/iomap/buffered-io.c~iomap-assign-current-backing_dev_info-in-iomap_file_buffered_write
+++ a/fs/iomap/buffered-io.c
@@ -3,6 +3,7 @@
  * Copyright (C) 2010 Red Hat, Inc.
  * Copyright (C) 2016-2019 Christoph Hellwig.
  */
+#include <linux/backing-dev.h>
 #include <linux/module.h>
 #include <linux/compiler.h>
 #include <linux/fs.h>
@@ -869,8 +870,10 @@ iomap_file_buffered_write(struct kiocb *
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		iter.flags |= IOMAP_NOWAIT;
 
+	current->backing_dev_info = inode_to_bdi(iter.inode);
 	while ((ret = iomap_iter(&iter, ops)) > 0)
 		iter.processed = iomap_write_iter(&iter, i);
+	current->backing_dev_info = NULL;
 
 	if (unlikely(ret < 0))
 		return ret;
--- a/fs/xfs/xfs_file.c~iomap-assign-current-backing_dev_info-in-iomap_file_buffered_write
+++ a/fs/xfs/xfs_file.c
@@ -27,7 +27,6 @@
 
 #include <linux/dax.h>
 #include <linux/falloc.h>
-#include <linux/backing-dev.h>
 #include <linux/mman.h>
 #include <linux/fadvise.h>
 #include <linux/mount.h>
@@ -717,9 +716,6 @@ write_retry:
 	if (ret)
 		goto out;
 
-	/* We can write back this queue in page reclaim */
-	current->backing_dev_info = inode_to_bdi(inode);
-
 	trace_xfs_file_buffered_write(iocb, from);
 	ret = iomap_file_buffered_write(iocb, from,
 			&xfs_buffered_write_iomap_ops);
@@ -751,7 +747,6 @@ write_retry:
 		goto write_retry;
 	}
 
-	current->backing_dev_info = NULL;
 out:
 	if (iolock)
 		xfs_iunlock(ip, iolock);
_

Patches currently in -mm which might be from hch@lst.de are

iomap-update-ki_pos-a-little-later-in-iomap_dio_complete.patch
filemap-update-ki_pos-in-generic_perform_write.patch
filemap-assign-current-backing_dev_info-in-generic_perform_write.patch
filemap-add-a-kiocb_write_and_wait-helper.patch
filemap-add-a-kiocb_invalidate_pages-helper.patch
filemap-add-a-kiocb_invalidate_post_write-helper.patch
iomap-update-ki_pos-in-iomap_file_buffered_write.patch
iomap-assign-current-backing_dev_info-in-iomap_file_buffered_write.patch
iomap-use-kiocb_write_and_wait-and-kiocb_invalidate_pages.patch
fs-factor-out-a-direct_write_fallback-helper.patch
fuse-update-ki_pos-in-fuse_perform_write.patch
fuse-drop-redundant-arguments-to-fuse_perform_write.patch
fuse-use-direct_write_fallback.patch
squashfs-dont-include-buffer_headh.patch

