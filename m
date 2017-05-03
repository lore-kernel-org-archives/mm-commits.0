From: akpm@linux-foundation.org
Subject: [patch 088/102] mm/truncate: bail out early from
 invalidate_inode_pages2_range() if mapping is empty
Date: Wed, 03 May 2017 14:56:06 -0700
Message-ID: <20170503215606.rGIF-yVnZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53960 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751851AbdECV6U (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:58:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aryabinin@virtuozzo.com, axboe@kernel.dk, hannes@cmpxchg.org, hch@lst.de, jack@suse.cz, konrad.wilk@oracle.com, kuznet@virtuozzo.com, mm-commits@vger.kernel.org, n.borisov.lkml@gmail.com, ross.zwisler@linux.intel.com, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk

From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: mm/truncate: bail out early from invalidate_inode_pages2_range() if mapping is empty

If mapping is empty (both ->nrpages and ->nrexceptional is zero) we can
avoid pointless lookups in empty radix tree and bail out immediately after
cleancache invalidation.

Link: http://lkml.kernel.org/r/20170424164135.22350-4-aryabinin@virtuozzo.com
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/truncate.c~mm-truncate-bail-out-early-from-invalidate_inode_pages2_range-if-mapping-is-empty mm/truncate.c
--- a/mm/truncate.c~mm-truncate-bail-out-early-from-invalidate_inode_pages2_range-if-mapping-is-empty
+++ a/mm/truncate.c
@@ -624,6 +624,9 @@ int invalidate_inode_pages2_range(struct
 	int did_range_unmap = 0;
 
 	cleancache_invalidate_inode(mapping);
+	if (mapping->nrpages == 0 && mapping->nrexceptional == 0)
+		return 0;
+
 	pagevec_init(&pvec, 0);
 	index = start;
 	while (index <= end && pagevec_lookup_entries(&pvec, mapping, index,
_
