From: akpm@linux-foundation.org
Subject: - isd200-fix-memory-leak-in-isd200_get_inquiry_data.patch removed from -mm tree
Date: Fri, 21 Mar 2008 13:31:39 -0700
Message-ID: <200803212031.m2LKVdnw009088@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58650 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755658AbYCUUcK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 16:32:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bharrosh@panasas.com, James.Bottomley@HansenPartnership.com, greg@kroah.com, stern@rowland.harvard.edu, mm-commits@vger.kernel.org


The patch titled
     isd200: fix memory leak in isd200_get_inquiry_data
has been removed from the -mm tree.  Its filename was
     isd200-fix-memory-leak-in-isd200_get_inquiry_data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: isd200: fix memory leak in isd200_get_inquiry_data
From: Boaz Harrosh <bharrosh@panasas.com>

If the inquiry fails then the info structure on us->extra was not freed.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/storage/isd200.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/usb/storage/isd200.c~isd200-fix-memory-leak-in-isd200_get_inquiry_data drivers/usb/storage/isd200.c
--- a/drivers/usb/storage/isd200.c~isd200-fix-memory-leak-in-isd200_get_inquiry_data
+++ a/drivers/usb/storage/isd200.c
@@ -1230,6 +1230,7 @@ static int isd200_get_inquiry_data( stru
 	    
 			/* Free driver structure */	    
 			us->extra_destructor(info);
+			kfree(info);
 			us->extra = NULL;
 			us->extra_destructor = NULL;
 		}
_

Patches currently in -mm which might be from bharrosh@panasas.com are

origin.patch
git-scsi-misc.patch

