From: akpm@linux-foundation.org
Subject: +
 mm-truncate-avoid-pointless-cleancache_invalidate_inode-calls.patch added
 to -mm tree
Date: Tue, 25 Apr 2017 13:57:08 -0700
Message-ID: <58ffb824.VOdfkoWWgUWomqas%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51850 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1954577AbdDYU5K (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Apr 2017 16:57:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, axboe@kernel.dk, hannes@cmpxchg.org, hch@lst.de, jack@suse.cz, konrad.wilk@oracle.com, kuznet@virtuozzo.com, n.borisov.lkml@gmail.com, ross.zwisler@linux.intel.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/truncate: avoid pointless cleancache_invalidate_inode() calls.
has been added to the -mm tree.  Its filename is
     mm-truncate-avoid-pointless-cleancache_invalidate_inode-calls.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-truncate-avoid-pointless-cleancache_invalidate_inode-calls.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-truncate-avoid-pointless-cleancache_invalidate_inode-calls.patch

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
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Alexey Kuznetsov <kuznet@virtuozzo.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Nikolay Borisov <n.borisov.lkml@gmail.com
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

fs-fix-data-invalidation-in-the-cleancache-during-direct-io.patch
fs-block_dev-always-invalidate-cleancache-in-invalidate_bdev.patch
mm-truncate-bail-out-early-from-invalidate_inode_pages2_range-if-mapping-is-empty.patch
mm-truncate-avoid-pointless-cleancache_invalidate_inode-calls.patch

