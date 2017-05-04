From: akpm@linux-foundation.org
Subject: [merged]
 mm-truncate-avoid-pointless-cleancache_invalidate_inode-calls.patch removed
 from -mm tree
Date: Thu, 04 May 2017 12:13:37 -0700
Message-ID: <20170504191337.1zMaIi1lm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52002 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756334AbdEDTNo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 May 2017 15:13:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, axboe@kernel.dk, hannes@cmpxchg.org, hch@lst.de, jack@suse.cz, konrad.wilk@oracle.com, kuznet@virtuozzo.com, mm-commits@vger.kernel.org, n.borisov.lkml@gmail.com, ross.zwisler@linux.intel.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: mm/truncate: avoid pointless cleancache_invalidate_inode() calls.
has been removed from the -mm tree.  Its filename was
     mm-truncate-avoid-pointless-cleancache_invalidate_inode-calls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: mm/truncate: avoid pointless cleancache_invalidate_inode() calls.

cleancache_invalidate_inode() called truncate_inode_pages_range()
and invalidate_inode_pages2_range() twice - on entry and on exit.
It's stupid and waste of time. It's enough to call it once at
exit.

Link: http://lkml.kernel.org/r/20170424164135.22350-5-aryabinin@virtuozzo.com
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

 mm/truncate.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN mm/truncate.c~mm-truncate-avoid-pointless-cleancache_invalidate_inode-calls mm/truncate.c
--- a/mm/truncate.c~mm-truncate-avoid-pointless-cleancache_invalidate_inode-calls
+++ a/mm/truncate.c
@@ -266,9 +266,8 @@ void truncate_inode_pages_range(struct a
 	pgoff_t		index;
 	int		i;
 
-	cleancache_invalidate_inode(mapping);
 	if (mapping->nrpages == 0 && mapping->nrexceptional == 0)
-		return;
+		goto out;
 
 	/* Offsets within partial pages */
 	partial_start = lstart & (PAGE_SIZE - 1);
@@ -363,7 +362,7 @@ void truncate_inode_pages_range(struct a
 	 * will be released, just zeroed, so we can bail out now.
 	 */
 	if (start >= end)
-		return;
+		goto out;
 
 	index = start;
 	for ( ; ; ) {
@@ -410,6 +409,8 @@ void truncate_inode_pages_range(struct a
 		pagevec_release(&pvec);
 		index++;
 	}
+
+out:
 	cleancache_invalidate_inode(mapping);
 }
 EXPORT_SYMBOL(truncate_inode_pages_range);
@@ -623,9 +624,8 @@ int invalidate_inode_pages2_range(struct
 	int ret2 = 0;
 	int did_range_unmap = 0;
 
-	cleancache_invalidate_inode(mapping);
 	if (mapping->nrpages == 0 && mapping->nrexceptional == 0)
-		return 0;
+		goto out;
 
 	pagevec_init(&pvec, 0);
 	index = start;
@@ -689,6 +689,8 @@ int invalidate_inode_pages2_range(struct
 		cond_resched();
 		index++;
 	}
+
+out:
 	cleancache_invalidate_inode(mapping);
 	return ret;
 }
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are


