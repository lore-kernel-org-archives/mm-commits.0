Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97227ECAAD1
	for <mm-commits@archiver.kernel.org>; Sat, 27 Aug 2022 23:06:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbiH0XGQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 27 Aug 2022 19:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiH0XGN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 27 Aug 2022 19:06:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F6126134
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 16:06:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C77CB60EED
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 23:06:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23472C433D6;
        Sat, 27 Aug 2022 23:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661641571;
        bh=B5VbImg52lr4EmljYTS4zRXZU+jBcfz0/xGXtOtvcCo=;
        h=Date:To:From:Subject:From;
        b=tej0UL3ZVOM77+lRddBHIKguSz8GAGzNivAMona+QC4oKrViJdY1ysNBo2iCFzR6X
         FL0OS1TkSoRL/P/YuOEVkMGUhipRK0TyYh8CM+HofFNWrBf35B1CxTeO3i8qfrsqdN
         x/nhLbnXppc+hfAbqJ4uXP+o2xc9FAiWVb9YfZNw=
Date:   Sat, 27 Aug 2022 16:06:10 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        trond.myklebust@hammerspace.com, miklos@szeredi.hu,
        logang@deltatee.com, jack@suse.cz, hch@infradead.org,
        djwong@kernel.org, axboe@kernel.dk, anna@kernel.org,
        jhubbard@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] fuse-convert-direct-io-paths-to-use-foll_pin.patch removed from -mm tree
Message-Id: <20220827230611.23472C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fuse: convert direct IO paths to use FOLL_PIN
has been removed from the -mm tree.  Its filename was
     fuse-convert-direct-io-paths-to-use-foll_pin.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: fuse: convert direct IO paths to use FOLL_PIN
Date: Sat, 27 Aug 2022 01:36:07 -0700

Convert the fuse filesystem to use pin_user_pages_fast() and
unpin_user_page(), instead of get_user_pages_fast() and put_page().

Link: https://lkml.kernel.org/r/20220827083607.2345453-7-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Anna Schumaker <anna@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dev.c    |    8 ++++++--
 fs/fuse/file.c   |   31 ++++++++++++++++++++-----------
 fs/fuse/fuse_i.h |    1 +
 3 files changed, 27 insertions(+), 13 deletions(-)

--- a/fs/fuse/dev.c~fuse-convert-direct-io-paths-to-use-foll_pin
+++ a/fs/fuse/dev.c
@@ -675,7 +675,10 @@ static void fuse_copy_finish(struct fuse
 			flush_dcache_page(cs->pg);
 			set_page_dirty_lock(cs->pg);
 		}
-		put_page(cs->pg);
+		if (cs->pipebufs)
+			put_page(cs->pg);
+		else
+			dio_w_unpin_user_page(cs->pg);
 	}
 	cs->pg = NULL;
 }
@@ -730,7 +733,8 @@ static int fuse_copy_fill(struct fuse_co
 		}
 	} else {
 		size_t off;
-		err = iov_iter_get_pages2(cs->iter, &page, PAGE_SIZE, 1, &off);
+		err = dio_w_iov_iter_pin_pages(cs->iter, &page, PAGE_SIZE, 1,
+					       &off);
 		if (err < 0)
 			return err;
 		BUG_ON(!err);
--- a/fs/fuse/file.c~fuse-convert-direct-io-paths-to-use-foll_pin
+++ a/fs/fuse/file.c
@@ -625,14 +625,19 @@ void fuse_read_args_fill(struct fuse_io_
 }
 
 static void fuse_release_user_pages(struct fuse_args_pages *ap,
-				    bool should_dirty)
+				    bool should_dirty, bool is_kvec)
 {
 	unsigned int i;
 
-	for (i = 0; i < ap->num_pages; i++) {
-		if (should_dirty)
-			set_page_dirty_lock(ap->pages[i]);
-		put_page(ap->pages[i]);
+	if (is_kvec) {
+		for (i = 0; i < ap->num_pages; i++) {
+			if (should_dirty)
+				set_page_dirty_lock(ap->pages[i]);
+			put_page(ap->pages[i]);
+		}
+	} else {
+		dio_w_unpin_user_pages_dirty_lock(ap->pages, ap->num_pages,
+						  should_dirty);
 	}
 }
 
@@ -733,7 +738,7 @@ static void fuse_aio_complete_req(struct
 	struct fuse_io_priv *io = ia->io;
 	ssize_t pos = -1;
 
-	fuse_release_user_pages(&ia->ap, io->should_dirty);
+	fuse_release_user_pages(&ia->ap, io->should_dirty, io->is_kvec);
 
 	if (err) {
 		/* Nothing */
@@ -1414,10 +1419,10 @@ static int fuse_get_user_pages(struct fu
 	while (nbytes < *nbytesp && ap->num_pages < max_pages) {
 		unsigned npages;
 		size_t start;
-		ret = iov_iter_get_pages2(ii, &ap->pages[ap->num_pages],
-					*nbytesp - nbytes,
-					max_pages - ap->num_pages,
-					&start);
+		ret = dio_w_iov_iter_pin_pages(ii, &ap->pages[ap->num_pages],
+					       *nbytesp - nbytes,
+					       max_pages - ap->num_pages,
+					       &start);
 		if (ret < 0)
 			break;
 
@@ -1483,6 +1488,9 @@ ssize_t fuse_direct_io(struct fuse_io_pr
 		fl_owner_t owner = current->files;
 		size_t nbytes = min(count, nmax);
 
+		/* For use in fuse_release_user_pages(): */
+		io->is_kvec = iov_iter_is_kvec(iter);
+
 		err = fuse_get_user_pages(&ia->ap, iter, &nbytes, write,
 					  max_pages);
 		if (err && !nbytes)
@@ -1498,7 +1506,8 @@ ssize_t fuse_direct_io(struct fuse_io_pr
 		}
 
 		if (!io->async || nres < 0) {
-			fuse_release_user_pages(&ia->ap, io->should_dirty);
+			fuse_release_user_pages(&ia->ap, io->should_dirty,
+						io->is_kvec);
 			fuse_io_free(ia);
 		}
 		ia = NULL;
--- a/fs/fuse/fuse_i.h~fuse-convert-direct-io-paths-to-use-foll_pin
+++ a/fs/fuse/fuse_i.h
@@ -290,6 +290,7 @@ struct fuse_io_priv {
 	struct kiocb *iocb;
 	struct completion *done;
 	bool blocking;
+	bool is_kvec;
 };
 
 #define FUSE_IO_PRIV_SYNC(i) \
_

Patches currently in -mm which might be from jhubbard@nvidia.com are


