From: akpm@linux-foundation.org
Subject: [merged] dma-debug-fix-locking-bug-in-check_unmap.patch removed from -mm tree
Date: Mon, 25 Mar 2013 12:45:19 -0700
Message-ID: <20130325194519.869E731C1E1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:41505 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932858Ab3CYTpV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Mar 2013 15:45:21 -0400
Received: by mail-vb0-f73.google.com with SMTP id fq11so85305vbb.0
        for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2013 12:45:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.h.duyck@intel.com, joro@8bytes.org, konrad.wilk@oracle.com, kubakici@wp.pl, shuah.khan@hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-debug: fix locking bug in check_unmap()
has been removed from the -mm tree.  Its filename was
     dma-debug-fix-locking-bug-in-check_unmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: dma-debug: fix locking bug in check_unmap()

In check_unmap() it is possible to get into a dead-locked state if
dma_mapping_error is called.  The problem is that the bucket is locked in
check_unmap, and locked again by debug_dma_mapping_error which is called
by dma_mapping_error.  To resolve that we must release the lock on the
bucket before making the call to dma_mapping_error.

[akpm@linux-foundation.org: restore 80-col trickery to be consistent with the rest of the file]
Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Reviewed-by: Shuah Khan <shuah.khan@hp.com>
Tested-by: Shuah Khan <shuah.khan@hp.com>
Cc: Jakub Kicinski <kubakici@wp.pl>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dma-debug.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff -puN lib/dma-debug.c~dma-debug-fix-locking-bug-in-check_unmap lib/dma-debug.c
--- a/lib/dma-debug.c~dma-debug-fix-locking-bug-in-check_unmap
+++ a/lib/dma-debug.c
@@ -862,17 +862,21 @@ static void check_unmap(struct dma_debug
 	entry = bucket_find_exact(bucket, ref);
 
 	if (!entry) {
+		/* must drop lock before calling dma_mapping_error */
+		put_hash_bucket(bucket, &flags);
+
 		if (dma_mapping_error(ref->dev, ref->dev_addr)) {
 			err_printk(ref->dev, NULL,
-				   "DMA-API: device driver tries "
-				   "to free an invalid DMA memory address\n");
-			return;
+				   "DMA-API: device driver tries to free an "
+				   "invalid DMA memory address\n");
+		} else {
+			err_printk(ref->dev, NULL,
+				   "DMA-API: device driver tries to free DMA "
+				   "memory it has not allocated [device "
+				   "address=0x%016llx] [size=%llu bytes]\n",
+				   ref->dev_addr, ref->size);
 		}
-		err_printk(ref->dev, NULL, "DMA-API: device driver tries "
-			   "to free DMA memory it has not allocated "
-			   "[device address=0x%016llx] [size=%llu bytes]\n",
-			   ref->dev_addr, ref->size);
-		goto out;
+		return;
 	}
 
 	if (ref->size != entry->size) {
@@ -936,7 +940,6 @@ static void check_unmap(struct dma_debug
 	hash_bucket_del(entry);
 	dma_entry_free(entry);
 
-out:
 	put_hash_bucket(bucket, &flags);
 }
 
_

Patches currently in -mm which might be from alexander.h.duyck@intel.com are

linux-next.patch

