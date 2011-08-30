From: akpm@linux-foundation.org
Subject: + dio-remove-unused-dio-parameter-from-dio_bio_add_page.patch added to -mm tree
Date: Tue, 30 Aug 2011 16:51:06 -0700
Message-ID: <201108302351.p7UNp6Dv026394@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52712 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753704Ab1H3Xvo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Aug 2011 19:51:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, axboe@kernel.dk, hch@lst.de, jmoyer@redhat.com


The patch titled
     dio: remove unused dio parameter from dio_bio_add_page()
has been added to the -mm tree.  Its filename is
     dio-remove-unused-dio-parameter-from-dio_bio_add_page.patch

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
Subject: dio: remove unused dio parameter from dio_bio_add_page()
From: Andi Kleen <ak@linux.intel.com>

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
@@ -655,7 +655,7 @@ out:
  *
  * Return zero on success.  Non-zero means the caller needs to start a new BIO.
  */
-static inline int dio_bio_add_page(struct dio *dio, struct dio_submit *sdio)
+static inline int dio_bio_add_page(struct dio_submit *sdio)
 {
 	int ret;
 
@@ -728,11 +728,11 @@ static inline int dio_send_cur_page(stru
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

