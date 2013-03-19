From: akpm@linux-foundation.org
Subject: + dma-debug-fix-locking-bug-in-check_unmap.patch added to -mm tree
Date: Tue, 19 Mar 2013 13:19:46 -0700
Message-ID: <20130319201946.D137B31C1EF@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:56347 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298Ab3CSUTv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Mar 2013 16:19:51 -0400
Received: by mail-ve0-f202.google.com with SMTP id m1so86388ves.5
        for <mm-commits@vger.kernel.org>; Tue, 19 Mar 2013 13:19:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexander.h.duyck@intel.com, joro@8bytes.org, konrad.wilk@oracle.com, kubakici@wp.pl, shuah.khan@hp.com


The patch titled
     Subject: dma-debug: fix locking bug in check_unmap()
has been added to the -mm tree.  Its filename is
     dma-debug-fix-locking-bug-in-check_unmap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: dma-debug: fix locking bug in check_unmap()

In check_unmap() it is possible to get into a dead-locked state if
dma_mapping_error is called.  The problem is that the bucket is locked in
check_unmap, and locked again by debug_dma_mapping_error which is called
by dma_mapping_error.  To resolve that we must release the lock on the
bucket before making the call to dma_mapping_error.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Shuah Khan <shuah.khan@hp.com>
Cc: Jakub Kicinski <kubakici@wp.pl>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dma-debug.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN lib/dma-debug.c~dma-debug-fix-locking-bug-in-check_unmap lib/dma-debug.c
--- a/lib/dma-debug.c~dma-debug-fix-locking-bug-in-check_unmap
+++ a/lib/dma-debug.c
@@ -862,17 +862,18 @@ static void check_unmap(struct dma_debug
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
+				   "DMA-API: device driver tries to free an invalid DMA memory address\n");
+		} else {
+			err_printk(ref->dev, NULL,
+				   "DMA-API: device driver tries to free DMA memory it has not allocated [device address=0x%016llx] [size=%llu bytes]\n",
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
@@ -936,7 +937,6 @@ static void check_unmap(struct dma_debug
 	hash_bucket_del(entry);
 	dma_entry_free(entry);
 
-out:
 	put_hash_bucket(bucket, &flags);
 }
 
_

Patches currently in -mm which might be from alexander.h.duyck@intel.com are

linux-next.patch
dma-debug-fix-locking-bug-in-check_unmap.patch
dma-debug-fix-locking-bug-in-check_unmap-fix.patch
dma-debug-update-dma-debug-api-to-better-handle-multiple-mappings-of-a-buffer.patch

