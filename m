From: akpm@linux-foundation.org
Subject: [merged] fs-direct-io-remove-redundant-comparison.patch removed
 from -mm tree
Date: Fri, 04 Apr 2014 12:30:44 -0700
Message-ID: <533f0864.YkV5xfcf5bmgc699%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42810 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182AbaDDTao (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:30:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, jmoyer@redhat.com, guz.fnst@cn.fujitsu.com

Subject: [merged] fs-direct-io-remove-redundant-comparison.patch removed from -mm tree
To: guz.fnst@cn.fujitsu.com,jmoyer@redhat.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:30:44 -0700


The patch titled
     Subject: fs/direct-io.c: remove redundant comparison
has been removed from the -mm tree.  Its filename was
     fs-direct-io-remove-redundant-comparison.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: fs/direct-io.c: remove redundant comparison

The return value of bio_get_nr_vecs() cannot be bigger than BIO_MAX_PAGES,
so we can remove redundant the comparison between nr_pages and
BIO_MAX_PAGES.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/direct-io.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/direct-io.c~fs-direct-io-remove-redundant-comparison fs/direct-io.c
--- a/fs/direct-io.c~fs-direct-io-remove-redundant-comparison
+++ a/fs/direct-io.c
@@ -664,7 +664,6 @@ static inline int dio_new_bio(struct dio
 		goto out;
 	sector = start_sector << (sdio->blkbits - 9);
 	nr_pages = min(sdio->pages_in_io, bio_get_nr_vecs(map_bh->b_bdev));
-	nr_pages = min(nr_pages, BIO_MAX_PAGES);
 	BUG_ON(nr_pages <= 0);
 	dio_bio_alloc(dio, sdio, map_bh->b_bdev, sector, nr_pages);
 	sdio->boundary = 0;
_

Patches currently in -mm which might be from guz.fnst@cn.fujitsu.com are

origin.patch
linux-next.patch

