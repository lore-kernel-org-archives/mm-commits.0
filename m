From: akpm@linux-foundation.org
Subject: - block-ccissc-remove-pointless-curr_queue-calculation.patch removed from -mm tree
Date: Wed, 06 Aug 2008 13:56:11 -0700
Message-ID: <200808062056.m76KuBDo014644@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39866 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758734AbYHFU4p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2008 16:56:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hare@suse.de, mike.miller@hp.com, mm-commits@vger.kernel.org


The patch titled
     block/cciss.c: remove pointless curr_queue calculation
has been removed from the -mm tree.  Its filename was
     block-ccissc-remove-pointless-curr_queue-calculation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: block/cciss.c: remove pointless curr_queue calculation
From: Hannes Reinecke <hare@suse.de>

curr_queue is a local variable in a for loop, and it's being initialized
at the start of each loop.  So any assignment at the end of the loop is
pointless.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Cc: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/block/cciss.c~block-ccissc-remove-pointless-curr_queue-calculation drivers/block/cciss.c
--- a/drivers/block/cciss.c~block-ccissc-remove-pointless-curr_queue-calculation
+++ a/drivers/block/cciss.c
@@ -1292,8 +1292,6 @@ static void cciss_check_queues(ctlr_info
 				h->next_to_run = curr_queue;
 				break;
 			}
-		} else {
-			curr_queue = (curr_queue + 1) % (h->highest_lun + 1);
 		}
 	}
 }
_

Patches currently in -mm which might be from hare@suse.de are

aic7xxx-introduce-dont_generate_debug_code-keyword-in-aicasm-parser.patch
aic7xxx-update-reg-files.patch
aic7xxx-update-_shipped-files.patch

