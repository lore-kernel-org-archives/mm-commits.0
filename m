From: akpm@linux-foundation.org
Subject: + cciss-make-cciss_revalidate-not-loop-through-ciss_max_luns-volumes-unnecessarily.patch added to -mm tree
Date: Thu, 06 Jan 2011 11:51:43 -0800
Message-ID: <201101061951.p06JpiuW011984@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751404Ab1AFTvw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jan 2011 14:51:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: scameron@beardog.cce.hp.com


The patch titled
     cciss: make cciss_revalidate not loop through CISS_MAX_LUNS volumes unnecessarily.
has been added to the -mm tree.  Its filename is
     cciss-make-cciss_revalidate-not-loop-through-ciss_max_luns-volumes-unnecessarily.patch

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

linux-next.patch
cciss-fix-botched-tag-masking-for-scsi-tape-commands.patch
cciss-make-cciss_revalidate-not-loop-through-ciss_max_luns-volumes-unnecessarily.patch

