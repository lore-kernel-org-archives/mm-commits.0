From: akpm@linux-foundation.org
Subject: + block-dont-count_vm_events-for-discard-bio-in-submit_bio.patch added to -mm tree
Date: Wed, 23 Jun 2010 12:41:51 -0700
Message-ID: <201006231941.o5NJfpY0027641@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36261 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752441Ab0FWTmR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jun 2010 15:42:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tao.ma@oracle.com, axboe@kernel.dk, hch@lst.de, stable@kernel.org


The patch titled
     block: don't count_vm_events for discard bio in submit_bio.
has been added to the -mm tree.  Its filename is
     block-dont-count_vm_events-for-discard-bio-in-submit_bio.patch

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
Subject: block: don't count_vm_events for discard bio in submit_bio.
From: Tao Ma <tao.ma@oracle.com>

In submit_bio() we count vm events by checking READ/WRITE.  But actually
DISCARD_NOBARRIER also has the WRITE flag set.  It looks as if in
blkdev_issue_discard(), we also add a page as the payload and the
bio_has_data check isn't enough.  So add another check for discard bio.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN block/blk-core.c~block-dont-count_vm_events-for-discard-bio-in-submit_bio block/blk-core.c
--- a/block/blk-core.c~block-dont-count_vm_events-for-discard-bio-in-submit_bio
+++ a/block/blk-core.c
@@ -1598,7 +1598,7 @@ void submit_bio(int rw, struct bio *bio)
 	 * If it's a regular read/write or a barrier with data attached,
 	 * go through the normal accounting stuff before submission.
 	 */
-	if (bio_has_data(bio)) {
+	if (bio_has_data(bio) && !(rw & BIO_RW_DISCARD)) {
 		if (rw & WRITE) {
 			count_vm_events(PGPGOUT, count);
 		} else {
_

Patches currently in -mm which might be from tao.ma@oracle.com are

linux-next.patch
block-dont-count_vm_events-for-discard-bio-in-submit_bio.patch

