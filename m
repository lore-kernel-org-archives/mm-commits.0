From: akpm@linux-foundation.org
Subject: + drivers-block-drbd-drbd_nlc-use-bitmap_parse-instead-of-__bitmap_parse.patch added to -mm tree
Date: Mon, 20 Jun 2011 15:19:53 -0700
Message-ID: <201106202219.p5KMJrEK025996@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33179 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756119Ab1FTWUF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Jun 2011 18:20:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hartleys@visionengravers.com, axboe@kernel.dk, drbd-dev@lists.linbit.com, hsweeten@visionengravers.com, philipp.reisner@linbit.com


The patch titled
     drivers/block/drbd/drbd_nl.c: use bitmap_parse instead of __bitmap_parse
has been added to the -mm tree.  Its filename is
     drivers-block-drbd-drbd_nlc-use-bitmap_parse-instead-of-__bitmap_parse.patch

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
Subject: drivers/block/drbd/drbd_nl.c: use bitmap_parse instead of __bitmap_parse
From: H Hartley Sweeten <hartleys@visionengravers.com>

The buffer 'sc.cpu_mask' is a kernel buffer.  If bitmap_parse is used
instead of __bitmap_parse the extra parameter that indicates a kernel
buffer is not needed.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Lars Ellenberg <drbd-dev@lists.linbit.com>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/drbd/drbd_nl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/block/drbd/drbd_nl.c~drivers-block-drbd-drbd_nlc-use-bitmap_parse-instead-of-__bitmap_parse drivers/block/drbd/drbd_nl.c
--- a/drivers/block/drbd/drbd_nl.c~drivers-block-drbd-drbd_nlc-use-bitmap_parse-instead-of-__bitmap_parse
+++ a/drivers/block/drbd/drbd_nl.c
@@ -1829,10 +1829,10 @@ static int drbd_nl_syncer_conf(struct dr
 
 	/* silently ignore cpu mask on UP kernel */
 	if (nr_cpu_ids > 1 && sc.cpu_mask[0] != 0) {
-		err = __bitmap_parse(sc.cpu_mask, 32, 0,
+		err = bitmap_parse(sc.cpu_mask, 32,
 				cpumask_bits(new_cpu_mask), nr_cpu_ids);
 		if (err) {
-			dev_warn(DEV, "__bitmap_parse() failed with %d\n", err);
+			dev_warn(DEV, "bitmap_parse() failed with %d\n", err);
 			retcode = ERR_CPU_MASK_PARSE;
 			goto fail;
 		}
_

Patches currently in -mm which might be from hartleys@visionengravers.com are

linux-next.patch
drivers-block-drbd-drbd_nlc-use-bitmap_parse-instead-of-__bitmap_parse.patch
lib-lcmc-quiet-sparse-noise.patch

