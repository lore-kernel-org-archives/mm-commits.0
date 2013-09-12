From: akpm@linux-foundation.org
Subject: [merged] cciss-set-max-scatter-gather-entries-to-32-on-p600.patch removed from -mm tree
Date: Thu, 12 Sep 2013 12:42:07 -0700
Message-ID: <5232190f.ehtcMKHrOIqBjIIA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57953 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab3ILTmI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:42:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, thenzl@redhat.com, steve.cameron@hp.com, bubrown@redhat.com, axboe@kernel.dk, mike.miller@hp.com

Subject: [merged] cciss-set-max-scatter-gather-entries-to-32-on-p600.patch removed from -mm tree
To: mike.miller@hp.com,axboe@kernel.dk,bubrown@redhat.com,steve.cameron@hp.com,thenzl@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:42:07 -0700


The patch titled
     Subject: cciss: set max scatter gather entries to 32 on P600
has been removed from the -mm tree.  Its filename was
     cciss-set-max-scatter-gather-entries-to-32-on-p600.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

