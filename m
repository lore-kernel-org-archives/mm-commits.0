From: akpm@linux-foundation.org
Subject: + cciss-fix-the-termination-of-the-scanning-thread.patch added to -mm tree
Date: Mon, 15 Jun 2009 15:42:42 -0700
Message-ID: <200906152242.n5FMggeb025108@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47439 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901AbZFOWnv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Jun 2009 18:43:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mike.miller@hp.com, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, stable@kernel.org


The patch titled
     cciss: fix the termination of the scanning thread
has been added to the -mm tree.  Its filename is
     cciss-fix-the-termination-of-the-scanning-thread.patch

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
Subject: cciss: fix the termination of the scanning thread
From: Mike Miller <mike.miller@hp.com>

scan_thread may be block in wait_for_completion(), and kthread_stop() is
not sufficient to break a wait_for_completion().  Add the needed
complete().

This should fix hangs which some testers reported.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/block/cciss.c~cciss-fix-the-termination-of-the-scanning-thread drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-fix-the-termination-of-the-scanning-thread
+++ a/drivers/block/cciss.c
@@ -4115,6 +4115,7 @@ static void __devexit cciss_remove_one(s
 		return;
 	}
 
+	complete(hba[i]->rescan_wait);
 	kthread_stop(hba[i]->cciss_scan_thread);
 
 	remove_proc_entry(hba[i]->devname, proc_cciss);
_

Patches currently in -mm which might be from mike.miller@hp.com are

origin.patch
cciss-fix-the-termination-of-the-scanning-thread.patch

