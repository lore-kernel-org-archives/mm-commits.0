From: akpm@linux-foundation.org
Subject: [merged] dio-remove-unnecessary-dio-argument-from-dio_pages_present.patch removed from -mm tree
Date: Fri, 28 Oct 2011 15:11:04 -0700
Message-ID: <201110282211.p9SMB4Lg020765@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:7058 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809Ab1J1WLM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2011 18:11:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, axboe@kernel.dk, hch@lst.de, jmoyer@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dio: remove unnecessary dio argument from dio_pages_present()
has been removed from the -mm tree.  Its filename was
     dio-remove-unnecessary-dio-argument-from-dio_pages_present.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: dio: remove unnecessary dio argument from dio_pages_present()

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

origin.patch
linux-next.patch
brlocks-lglocks-clean-up-code.patch
brlocks-lglocks-clean-up-code-checkpatch-fixes.patch
hwpoison-convert-pr_debugs-to-pr_infos.patch
lib-bitmapc-quiet-sparse-noise-about-address-space.patch
lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch
vfs-cache-request_queue-in-struct-block_device.patch
dio-optimize-cache-misses-in-the-submission-path-v2.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
dio-optimize-cache-misses-in-the-submission-path-v2-fix.patch

