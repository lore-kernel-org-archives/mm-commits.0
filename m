From: akpm@linux-foundation.org
Subject: + block-ccissc-remove-pointless-curr_queue-calculation.patch added to -mm tree
Date: Mon, 28 Jul 2008 21:06:12 -0700
Message-ID: <200807290406.m6T46C6C013294@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55516 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750818AbYG2EG6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 00:06:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hare@suse.de, mike.miller@hp.com


The patch titled
     block/cciss.c: remove pointless curr_queue calculation
has been added to the -mm tree.  Its filename is
     block-ccissc-remove-pointless-curr_queue-calculation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
aic7xxx-introduce-dont_generate_debug_code-keyword-in-aicasm-parser.patch
aic7xxx-update-reg-files.patch
aic7xxx-update-_shipped-files.patch
block-ccissc-remove-pointless-curr_queue-calculation.patch

