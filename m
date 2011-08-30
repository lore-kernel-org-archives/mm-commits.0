From: akpm@linux-foundation.org
Subject: + dio-remove-unnecessary-dio-argument-from-dio_pages_present.patch added to -mm tree
Date: Tue, 30 Aug 2011 16:54:01 -0700
Message-ID: <201108302354.p7UNs1q8026574@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60721 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753835Ab1H3Xyf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Aug 2011 19:54:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, axboe@kernel.dk, hch@lst.de, jmoyer@redhat.com


The patch titled
     dio: remove unnecessary dio argument from dio_pages_present()
has been added to the -mm tree.  Its filename is
     dio-remove-unnecessary-dio-argument-from-dio_pages_present.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dio: remove unnecessary dio argument from dio_pages_present()
From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/direct-io.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/direct-io.c~dio-remove-unnecessary-dio-argument-from-dio_pages_present fs/direct-io.c
--- a/fs/direct-io.c~dio-remove-unnecessary-dio-argument-from-dio_pages_present
+++ a/fs/direct-io.c
@@ -191,7 +191,7 @@ EXPORT_SYMBOL_GPL(inode_dio_done);
 /*
  * How many pages are in the queue?
  */
-static inline unsigned dio_pages_present(struct dio *dio, struct dio_submit *sdio)
+static inline unsigned dio_pages_present(struct dio_submit *sdio)
 {
 	return sdio->tail - sdio->head;
 }
@@ -247,13 +247,13 @@ out:
  */
 static inline struct page *dio_get_page(struct dio *dio, struct dio_submit *sdio)
 {
-	if (dio_pages_present(dio, sdio) == 0) {
+	if (dio_pages_present(sdio) == 0) {
 		int ret;
 
 		ret = dio_refill_pages(dio, sdio);
 		if (ret)
 			return ERR_PTR(ret);
-		BUG_ON(dio_pages_present(dio, sdio) == 0);
+		BUG_ON(dio_pages_present(sdio) == 0);
 	}
 	return dio->pages[sdio->head++];
 }
@@ -435,7 +435,7 @@ static inline void dio_bio_submit(struct
  */
 static inline void dio_cleanup(struct dio *dio, struct dio_submit *sdio)
 {
-	while (dio_pages_present(dio, sdio))
+	while (dio_pages_present(sdio))
 		page_cache_release(dio_get_page(dio, sdio));
 }
 
_

Patches currently in -mm which might be from ak@linux.intel.com are

linux-next.patch
dio-separate-fields-only-used-in-the-submission-path-from-struct-dio.patch
dio-separate-fields-only-used-in-the-submission-path-from-struct-dio-checkpatch-fixes.patch
dio-fix-a-wrong-comment.patch
dio-rearrange-fields-in-dio-dio_submit-to-avoid-holes.patch
dio-use-a-slab-cache-for-struct-dio.patch
dio-separate-map_bh-from-dio-v2.patch
dio-inline-the-complete-submission-path-v2.patch
dio-inline-the-complete-submission-path-v2-checkpatch-fixes.patch
dio-merge-direct_io_walker-into-__blockdev_direct_io.patch
dio-merge-direct_io_walker-into-__blockdev_direct_io-checkpatch-fixes.patch
dio-remove-unnecessary-dio-argument-from-dio_pages_present.patch
dio-remove-unused-dio-parameter-from-dio_bio_add_page.patch
vfs-cache-request_queue-in-struct-block_device.patch
dio-optimize-cache-misses-in-the-submission-path-v2.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch

