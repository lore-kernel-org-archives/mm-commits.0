From: akpm@linux-foundation.org
Subject: [merged] cciss-make-cciss_revalidate-not-loop-through-ciss_max_luns-volumes-unnecessarily.patch removed from -mm tree
Date: Thu, 10 Feb 2011 12:16:13 -0800
Message-ID: <201102102016.p1AKGDeS016274@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38690 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756879Ab1BJUQU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Feb 2011 15:16:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: scameron@beardog.cce.hp.com, mm-commits@vger.kernel.org


The patch titled
     cciss: make cciss_revalidate not loop through CISS_MAX_LUNS volumes unnecessarily.
has been removed from the -mm tree.  Its filename was
     cciss-make-cciss_revalidate-not-loop-through-ciss_max_luns-volumes-unnecessarily.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cciss: make cciss_revalidate not loop through CISS_MAX_LUNS volumes unnecessarily.
From: Stephen M. Cameron <StephenM.Cameron>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/cciss.c~cciss-make-cciss_revalidate-not-loop-through-ciss_max_luns-volumes-unnecessarily drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-make-cciss_revalidate-not-loop-through-ciss_max_luns-volumes-unnecessarily
+++ a/drivers/block/cciss.c
@@ -2833,7 +2833,7 @@ static int cciss_revalidate(struct gendi
 	sector_t total_size;
 	InquiryData_struct *inq_buff = NULL;
 
-	for (logvol = 0; logvol < CISS_MAX_LUN; logvol++) {
+	for (logvol = 0; logvol <= h->highest_lun; logvol++) {
 		if (!h->drv[logvol])
 			continue;
 		if (memcmp(h->drv[logvol]->LunID, drv->LunID,
_

Patches currently in -mm which might be from scameron@beardog.cce.hp.com are

origin.patch
linux-next.patch

