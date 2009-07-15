From: akpm@linux-foundation.org
Subject: [alternative-merged] cciss-fix-the-termination-of-the-scanning-thread.patch removed from -mm tree
Date: Wed, 15 Jul 2009 15:08:26 -0700
Message-ID: <200907152208.n6FM8QXr001982@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754793AbZGOWJi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Jul 2009 18:09:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.miller@hp.com, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     cciss: fix the termination of the scanning thread
has been removed from the -mm tree.  Its filename was
     cciss-fix-the-termination-of-the-scanning-thread.patch

This patch was dropped because an alternative patch was merged

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
@@ -4125,6 +4125,7 @@ static void __devexit cciss_remove_one(s
 		return;
 	}
 
+	complete(hba[i]->rescan_wait);
 	kthread_stop(hba[i]->cciss_scan_thread);
 
 	remove_proc_entry(hba[i]->devname, proc_cciss);
_

Patches currently in -mm which might be from mike.miller@hp.com are

linux-next.patch
cciss-remove-logical-drive-sysfs-entries-during-driver-cleanup.patch
cciss-use-only-one-scan-thread.patch
cciss-kick-off-logical-drive-topology-rescan-through-sysfs.patch
cciss-fix-the-termination-of-the-scanning-thread.patch

