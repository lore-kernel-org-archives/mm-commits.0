From: akpm@linux-foundation.org
Subject: [patch 087/102] fs/block_dev: always invalidate cleancache
 in invalidate_bdev()
Date: Wed, 03 May 2017 14:56:02 -0700
Message-ID: <20170503215602.vDOtH3-NR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53960 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751198AbdECV6U (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:58:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aryabinin@virtuozzo.com, axboe@kernel.dk, hannes@cmpxchg.org, hch@lst.de, jack@suse.cz, konrad.wilk@oracle.com, kuznet@virtuozzo.com, mm-commits@vger.kernel.org, n.borisov.lkml@gmail.com, ross.zwisler@linux.intel.com, stable@vger.kernel.org, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk

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
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Alexey Kuznetsov <kuznet@virtuozzo.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Nikolay Borisov <n.borisov.lkml@gmail.com>
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
