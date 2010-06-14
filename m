From: akpm@linux-foundation.org
Subject: + floppy-silence-warning-during-disk-test.patch added to -mm tree
Date: Mon, 14 Jun 2010 12:39:20 -0700
Message-ID: <201006141939.o5EJdKPp026909@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43528 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754768Ab0FNTjY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jun 2010 15:39:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shemminger@vyatta.com, axboe@kernel.dk


The patch titled
     floppy: silence warning during disk test
has been added to the -mm tree.  Its filename is
     floppy-silence-warning-during-disk-test.patch

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
Subject: floppy: silence warning during disk test
From: Stephen Hemminger <shemminger@vyatta.com>

The first thing the floppy does is read block 0 to test geometry and to
test for disk presence.  If disk is not present this causes a console
warning message about failed I/O.  Set flag to silence.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/block/floppy.c~floppy-silence-warning-during-disk-test drivers/block/floppy.c
--- a/drivers/block/floppy.c~floppy-silence-warning-during-disk-test
+++ a/drivers/block/floppy.c
@@ -3829,6 +3829,7 @@ static int __floppy_read_block_0(struct 
 	bio.bi_size = size;
 	bio.bi_bdev = bdev;
 	bio.bi_sector = 0;
+	bio.bi_flags = BIO_QUIET;
 	init_completion(&complete);
 	bio.bi_private = &complete;
 	bio.bi_end_io = floppy_rb0_complete;
_

Patches currently in -mm which might be from shemminger@vyatta.com are

linux-next.patch
floppy-initialize-debug-jiffies-offset.patch
floppy-remove-unnecessary-inlines.patch
floppy-silence-warning-during-disk-test.patch
floppy-use-atomic-type-for-usage_count.patch
floppy-cmos-attribute-should-be-static.patch
floppy-fix-signed-unsigned-warnings.patch
floppy-use-wait_event_interruptible.patch
floppy-use-warning-macros.patch
floppy-make-controller-const.patch

