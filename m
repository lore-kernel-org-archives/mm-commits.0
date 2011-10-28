From: akpm@linux-foundation.org
Subject: [merged] dio-remove-unused-dio-parameter-from-dio_bio_add_page.patch removed from -mm tree
Date: Fri, 28 Oct 2011 15:11:07 -0700
Message-ID: <201110282211.p9SMB7MO009169@hpaq3.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:33163 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343Ab1J1WLR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2011 18:11:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, axboe@kernel.dk, hch@lst.de, jmoyer@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dio: remove unused dio parameter from dio_bio_add_page()
has been removed from the -mm tree.  Its filename was
     dio-remove-unused-dio-parameter-from-dio_bio_add_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: dio: remove unused dio parameter from dio_bio_add_page()

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/direct-io.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/direct-io.c~dio-remove-unused-dio-parameter-from-dio_bio_add_page fs/direct-io.c
--- a/fs/direct-io.c~dio-remove-unused-dio-parameter-from-dio_bio_add_page
+++ a/fs/direct-io.c
@@ -651,7 +651,7 @@ out:
  *
  * Return zero on success.  Non-zero means the caller needs to start a new BIO.
  */
-static inline int dio_bio_add_page(struct dio *dio, struct dio_submit *sdio)
+static inline int dio_bio_add_page(struct dio_submit *sdio)
 {
 	int ret;
 
@@ -724,11 +724,11 @@ static inline int dio_send_cur_page(stru
 			goto out;
 	}
 
-	if (dio_bio_add_page(dio, sdio) != 0) {
+	if (dio_bio_add_page(sdio) != 0) {
 		dio_bio_submit(dio, sdio);
 		ret = dio_new_bio(dio, sdio, sdio->cur_page_block, map_bh);
 		if (ret == 0) {
-			ret = dio_bio_add_page(dio, sdio);
+			ret = dio_bio_add_page(sdio);
 			BUG_ON(ret != 0);
 		}
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

