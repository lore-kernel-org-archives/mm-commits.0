From: akpm@linux-foundation.org
Subject: [merged] cciss-fix-memory-leak-in-cciss_init_one.patch removed from -mm tree
Date: Tue, 25 Aug 2009 11:43:28 -0700
Message-ID: <200908251843.n7PIhSbi010170@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36317 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755805AbZHYSpa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Aug 2009 14:45:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.dumazet@gmail.com, fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, mike.miller@hp.com, scameron@beardog.cca.cpqcorp.net, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     cciss: fix memory leak in cciss_init_one()
has been removed from the -mm tree.  Its filename was
     cciss-fix-memory-leak-in-cciss_init_one.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cciss: fix memory leak in cciss_init_one()
From: Eric Dumazet <eric.dumazet@gmail.com>

commit 22bece00dc1f28dd3374c55e464c9f02eb642876 (cciss: fix regression
firmware not displayed in procfs) added a small memory leak in
cciss_init_one()

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>
Cc: <stable@kernel.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/block/cciss.c~cciss-fix-memory-leak-in-cciss_init_one drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-fix-memory-leak-in-cciss_init_one
+++ a/drivers/block/cciss.c
@@ -3889,7 +3889,7 @@ static int __devinit cciss_init_one(stru
 	int j = 0;
 	int rc;
 	int dac, return_code;
-	InquiryData_struct *inq_buff = NULL;
+	InquiryData_struct *inq_buff;
 
 	if (reset_devices) {
 		/* Reset the controller with a PCI power-cycle */
@@ -4029,6 +4029,7 @@ static int __devinit cciss_init_one(stru
 		printk(KERN_WARNING "cciss: unable to determine firmware"
 			" version of controller\n");
 	}
+	kfree(inq_buff);
 
 	cciss_procinit(i);
 
@@ -4045,7 +4046,6 @@ static int __devinit cciss_init_one(stru
 	return 1;
 
 clean4:
-	kfree(inq_buff);
 	kfree(hba[i]->cmd_pool_bits);
 	if (hba[i]->cmd_pool)
 		pci_free_consistent(hba[i]->pdev,
_

Patches currently in -mm which might be from eric.dumazet@gmail.com are

linux-next.patch

