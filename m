From: akpm@linux-foundation.org
Subject: + cciss-set-max-scatter-gather-entries-to-32-on-p600.patch added
 to -mm tree
Date: Wed, 14 Aug 2013 14:14:22 -0700
Message-ID: <520bf32e.+GkPrxcf+HqscOoY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55294 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932914Ab3HNVOX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Aug 2013 17:14:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, thenzl@redhat.com, steve.cameron@hp.com, bubrown@redhat.com, axboe@kernel.dk, mike.miller@hp.com

Subject: + cciss-set-max-scatter-gather-entries-to-32-on-p600.patch added to -mm tree
To: mike.miller@hp.com,axboe@kernel.dk,bubrown@redhat.com,steve.cameron@hp.com,thenzl@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 14 Aug 2013 14:14:22 -0700


The patch titled
     Subject: cciss: set max scatter gather entries to 32 on P600
has been added to the -mm tree.  Its filename is
     cciss-set-max-scatter-gather-entries-to-32-on-p600.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cciss-set-max-scatter-gather-entries-to-32-on-p600.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cciss-set-max-scatter-gather-entries-to-32-on-p600.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Miller <mike.miller@hp.com>
Subject: cciss: set max scatter gather entries to 32 on P600

At one time we used to set the maximum number of scatter gather elements
on all Smart Array controllers to 32.  At some point in time the firmware
began to write the "appropriate" value for each controller into the config
table.  The cciss driver would then read that and set h->maxsgentries.

        h->maxsgentries = readl(&(h->cfgtable->MaxSGElements);

On the P600 that value is 544.  Under some workloads a significant
performance reduction may result.  This patch forces the P600 to use only
32 scatter gather elements.  Other controllers are not affected.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: Dwight (Bud) Brown <bubrown@redhat.com>
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Acked-by: Stephen M. Cameron <steve.cameron@hp.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/block/cciss.c~cciss-set-max-scatter-gather-entries-to-32-on-p600 drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-set-max-scatter-gather-entries-to-32-on-p600
+++ a/drivers/block/cciss.c
@@ -4258,6 +4258,13 @@ static void cciss_find_board_params(ctlr
 	h->nr_cmds = h->max_commands - 4 - cciss_tape_cmds;
 	h->maxsgentries = readl(&(h->cfgtable->MaxSGElements));
 	/*
+	 * The P600 may exhibit poor performnace under some workloads
+	 * if we use the value in the configuration table. Limit this
+	 * controller to MAXSGENTRIES (32) instead.
+	 */
+	if (h->board_id == 0x3225103C)
+		h->maxsgentries = MAXSGENTRIES;
+	/*
 	 * Limit in-command s/g elements to 32 save dma'able memory.
 	 * Howvever spec says if 0, use 31
 	 */
_

Patches currently in -mm which might be from mike.miller@hp.com are

cciss-set-max-scatter-gather-entries-to-32-on-p600.patch

