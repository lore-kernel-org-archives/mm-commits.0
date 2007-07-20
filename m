From: akpm@linux-foundation.org
Subject: + async_tx-fix-kmap_atomic-usage-in-async_memcpy.patch added to -mm tree
Date: Thu, 19 Jul 2007 23:17:38 -0700
Message-ID: <200707200617.l6K6HcaM011054@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47850 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753559AbXGTGSw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 02:18:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.j.williams@intel.com, akpm@linux-foundation.org, johnpol@2ka.mipt.ru


The patch titled
     async_tx: fix kmap_atomic usage in async_memcpy
has been added to the -mm tree.  Its filename is
     async_tx-fix-kmap_atomic-usage-in-async_memcpy.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: async_tx: fix kmap_atomic usage in async_memcpy
From: Dan Williams <dan.j.williams@intel.com>

Andrew Morton:
	[async_memcpy] is very wrong if both ASYNC_TX_KMAP_DST and
	ASYNC_TX_KMAP_SRC can ever be set.  We'll end up using the same kmap
	slot for both src add dest and we get either corrupted data or a BUG.

Evgeniy Polyakov:
	Btw, shouldn't it always be kmap_atomic() even if flag is not set.
	That pages are usual one returned by alloc_page().

So fix the usage of kmap_atomic and kill the ASYNC_TX_KMAP_DST and
ASYNC_TX_KMAP_SRC flags.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 crypto/async_tx/async_memcpy.c |   19 ++++---------------
 drivers/md/raid5.c             |    4 ++--
 include/linux/async_tx.h       |    6 ------
 3 files changed, 6 insertions(+), 23 deletions(-)

diff -puN crypto/async_tx/async_memcpy.c~async_tx-fix-kmap_atomic-usage-in-async_memcpy crypto/async_tx/async_memcpy.c
--- a/crypto/async_tx/async_memcpy.c~async_tx-fix-kmap_atomic-usage-in-async_memcpy
+++ a/crypto/async_tx/async_memcpy.c
@@ -36,7 +36,6 @@
  * @offset: offset in pages to start transaction
  * @len: length in bytes
  * @flags: ASYNC_TX_ASSUME_COHERENT, ASYNC_TX_ACK, ASYNC_TX_DEP_ACK,
- *	ASYNC_TX_KMAP_SRC, ASYNC_TX_KMAP_DST
  * @depend_tx: memcpy depends on the result of this transaction
  * @cb_fn: function to call when the memcpy completes
  * @cb_param: parameter to pass to the callback routine
@@ -88,23 +87,13 @@ async_memcpy(struct page *dest, struct p
 					__FUNCTION__);
 		}
 
-		if (flags & ASYNC_TX_KMAP_DST)
-			dest_buf = kmap_atomic(dest, KM_USER0) + dest_offset;
-		else
-			dest_buf = page_address(dest) + dest_offset;
-
-		if (flags & ASYNC_TX_KMAP_SRC)
-			src_buf = kmap_atomic(src, KM_USER0) + src_offset;
-		else
-			src_buf = page_address(src) + src_offset;
+		dest_buf = kmap_atomic(dest, KM_USER0) + dest_offset;
+		src_buf = kmap_atomic(src, KM_USER1) + src_offset;
 
 		memcpy(dest_buf, src_buf, len);
 
-		if (flags & ASYNC_TX_KMAP_DST)
-			kunmap_atomic(dest_buf, KM_USER0);
-
-		if (flags & ASYNC_TX_KMAP_SRC)
-			kunmap_atomic(src_buf, KM_USER0);
+		kunmap_atomic(dest_buf, KM_USER0);
+		kunmap_atomic(src_buf, KM_USER1);
 
 		async_tx_sync_epilog(flags, depend_tx, cb_fn, cb_param);
 	}
diff -puN drivers/md/raid5.c~async_tx-fix-kmap_atomic-usage-in-async_memcpy drivers/md/raid5.c
--- a/drivers/md/raid5.c~async_tx-fix-kmap_atomic-usage-in-async_memcpy
+++ a/drivers/md/raid5.c
@@ -493,12 +493,12 @@ async_copy_data(int frombio, struct bio 
 			if (frombio)
 				tx = async_memcpy(page, bio_page, page_offset,
 					b_offset, clen,
-					ASYNC_TX_DEP_ACK | ASYNC_TX_KMAP_SRC,
+					ASYNC_TX_DEP_ACK,
 					tx, NULL, NULL);
 			else
 				tx = async_memcpy(bio_page, page, b_offset,
 					page_offset, clen,
-					ASYNC_TX_DEP_ACK | ASYNC_TX_KMAP_DST,
+					ASYNC_TX_DEP_ACK,
 					tx, NULL, NULL);
 		}
 		if (clen < len) /* hit end of page */
diff -puN include/linux/async_tx.h~async_tx-fix-kmap_atomic-usage-in-async_memcpy include/linux/async_tx.h
--- a/include/linux/async_tx.h~async_tx-fix-kmap_atomic-usage-in-async_memcpy
+++ a/include/linux/async_tx.h
@@ -51,10 +51,6 @@ struct dma_chan_ref {
  * @ASYNC_TX_ACK: immediately ack the descriptor, precludes setting up a
  * dependency chain
  * @ASYNC_TX_DEP_ACK: ack the dependency descriptor.  Useful for chaining.
- * @ASYNC_TX_KMAP_SRC: if the transaction is to be performed synchronously
- * take an atomic mapping (KM_USER0) on the source page(s)
- * @ASYNC_TX_KMAP_DST: if the transaction is to be performed synchronously
- * take an atomic mapping (KM_USER0) on the dest page(s)
  */
 enum async_tx_flags {
 	ASYNC_TX_XOR_ZERO_DST	 = (1 << 0),
@@ -62,8 +58,6 @@ enum async_tx_flags {
 	ASYNC_TX_ASSUME_COHERENT = (1 << 2),
 	ASYNC_TX_ACK		 = (1 << 3),
 	ASYNC_TX_DEP_ACK	 = (1 << 4),
-	ASYNC_TX_KMAP_SRC	 = (1 << 5),
-	ASYNC_TX_KMAP_DST	 = (1 << 6),
 };
 
 #ifdef CONFIG_DMA_ENGINE
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

origin.patch
async_tx-fix-kmap_atomic-usage-in-async_memcpy.patch
raid5-add-the-stripe_queue-object-for-tracking-raid.patch
raid5-add-the-stripe_queue-object-for-tracking-raid-io-requests-take2.patch
raid5-use-stripe_queues-to-prioritize-the-most.patch
