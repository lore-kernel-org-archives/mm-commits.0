From: akpm@linux-foundation.org
Subject: [merged] bcache-use-kvfree-in-various-places.patch removed from
 -mm tree
Date: Mon, 06 Jul 2015 12:47:57 -0700
Message-ID: <559adb6d.qqenbAiVMCepPgVh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59643 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755791AbbGFTr5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 15:47:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@kernel.org, kmo@daterainc.com, mm-commits@vger.kernel.org


The patch titled
     Subject: bcache: use kvfree() in various places
has been removed from the -mm tree.  Its filename was
     bcache-use-kvfree-in-various-places.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Pekka Enberg <penberg@kernel.org>
Subject: bcache: use kvfree() in various places

Use kvfree() instead of open-coding it.

Signed-off-by: Pekka Enberg <penberg@kernel.org>
Cc: Kent Overstreet <kmo@daterainc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/bcache/super.c |   10 ++--------
 drivers/md/bcache/util.h  |   10 ++--------
 2 files changed, 4 insertions(+), 16 deletions(-)

diff -puN drivers/md/bcache/super.c~bcache-use-kvfree-in-various-places drivers/md/bcache/super.c
--- a/drivers/md/bcache/super.c~bcache-use-kvfree-in-various-places
+++ a/drivers/md/bcache/super.c
@@ -760,14 +760,8 @@ static void bcache_device_free(struct bc
 	bio_split_pool_free(&d->bio_split_hook);
 	if (d->bio_split)
 		bioset_free(d->bio_split);
-	if (is_vmalloc_addr(d->full_dirty_stripes))
-		vfree(d->full_dirty_stripes);
-	else
-		kfree(d->full_dirty_stripes);
-	if (is_vmalloc_addr(d->stripe_sectors_dirty))
-		vfree(d->stripe_sectors_dirty);
-	else
-		kfree(d->stripe_sectors_dirty);
+	kvfree(d->full_dirty_stripes);
+	kvfree(d->stripe_sectors_dirty);
 
 	closure_debug_destroy(&d->cl);
 }
diff -puN drivers/md/bcache/util.h~bcache-use-kvfree-in-various-places drivers/md/bcache/util.h
--- a/drivers/md/bcache/util.h~bcache-use-kvfree-in-various-places
+++ a/drivers/md/bcache/util.h
@@ -52,10 +52,7 @@ struct closure;
 
 #define free_heap(heap)							\
 do {									\
-	if (is_vmalloc_addr((heap)->data))				\
-		vfree((heap)->data);					\
-	else								\
-		kfree((heap)->data);					\
+	kvfree((heap)->data);						\
 	(heap)->data = NULL;						\
 } while (0)
 
@@ -163,10 +160,7 @@ do {									\
 
 #define free_fifo(fifo)							\
 do {									\
-	if (is_vmalloc_addr((fifo)->data))				\
-		vfree((fifo)->data);					\
-	else								\
-		kfree((fifo)->data);					\
+	kvfree((fifo)->data);						\
 	(fifo)->data = NULL;						\
 } while (0)
 
_

Patches currently in -mm which might be from penberg@kernel.org are

slab-infrastructure-for-bulk-object-allocation-and-freeing-v3.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing-v3-fix.patch
slub-bulk-alloc-extract-objects-from-the-per-cpu-slab.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch

