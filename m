From: akpm@linux-foundation.org
Subject: + fs-direct-io-remove-redundant-comparison.patch added to -mm
 tree
Date: Fri, 21 Feb 2014 12:24:28 -0800
Message-ID: <5307b5fc.EryeNB5V67RDQ2NX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58118 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbaBUUY3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Feb 2014 15:24:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, jmoyer@redhat.com, guz.fnst@cn.fujitsu.com

Subject: + fs-direct-io-remove-redundant-comparison.patch added to -mm tree
To: guz.fnst@cn.fujitsu.com,jmoyer@redhat.com,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Fri, 21 Feb 2014 12:24:28 -0800


The patch titled
     Subject: fs/direct-io: remove redundant comparison
has been added to the -mm tree.  Its filename is
     fs-direct-io-remove-redundant-comparison.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-direct-io-remove-redundant-comparison.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-direct-io-remove-redundant-comparison.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: fs/direct-io: remove redundant comparison

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

fs-direct-io-remove-redundant-comparison.patch

