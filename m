From: akpm@linux-foundation.org
Subject: +
 fs-block_dev-always-invalidate-cleancache-in-invalidate_bdev.patch added to -mm tree
Date: Tue, 25 Apr 2017 13:56:58 -0700
Message-ID: <58ffb81a.NfaTsxcXBI8VN027%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51800 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1954553AbdDYU5B (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Apr 2017 16:57:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, axboe@kernel.dk, hannes@cmpxchg.org, hch@lst.de, jack@suse.cz, konrad.wilk@oracle.com, kuznet@virtuozzo.com, n.borisov.lkml@gmail.com, ross.zwisler@linux.intel.com, stable@vger.kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/block_dev: always invalidate cleancache in invalidate_bdev()
has been added to the -mm tree.  Its filename is
     fs-block_dev-always-invalidate-cleancache-in-invalidate_bdev.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-block_dev-always-invalidate-cleancache-in-invalidate_bdev.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-block_dev-always-invalidate-cleancache-in-invalidate_bdev.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: fs/block_dev: always invalidate cleancache in invalidate_bdev()

invalidate_bdev() calls cleancache_invalidate_inode() iff ->nrpages != 0
which doen't make any sense.
Make sure that invalidate_bdev() always calls cleancache_invalidate_inode()
regardless of mapping->nrpages value.

Fixes: c515e1fd361c ("mm/fs: add hooks to support cleancache")
Link: http://lkml.kernel.org/r/20170424164135.22350-3-aryabinin@virtuozzo.com
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Alexey Kuznetsov <kuznet@virtuozzo.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Nikolay Borisov <n.borisov.lkml@gmail.com
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN fs/block_dev.c~fs-block_dev-always-invalidate-cleancache-in-invalidate_bdev fs/block_dev.c
--- a/fs/block_dev.c~fs-block_dev-always-invalidate-cleancache-in-invalidate_bdev
+++ a/fs/block_dev.c
@@ -103,12 +103,11 @@ void invalidate_bdev(struct block_device
 {
 	struct address_space *mapping = bdev->bd_inode->i_mapping;
 
-	if (mapping->nrpages == 0)
-		return;
