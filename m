From: akpm@linux-foundation.org
Subject: + isd200-fix-memory-leak-in-isd200_get_inquiry_data.patch added to -mm tree
Date: Thu, 13 Mar 2008 12:53:03 -0700
Message-ID: <200803131953.m2DJr3Bc030084@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53247 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752319AbYCMTzX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Mar 2008 15:55:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bharrosh@panasas.com, greg@kroah.com, stern@rowland.harvard.edu


The patch titled
     isd200: fix memory leak in isd200_get_inquiry_data
has been added to the -mm tree.  Its filename is
     isd200-fix-memory-leak-in-isd200_get_inquiry_data.patch

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
Subject: isd200: fix memory leak in isd200_get_inquiry_data
From: Boaz Harrosh <bharrosh@panasas.com>

If the inquiry fails then the info structure on us->extra was not freed.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>
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

git-scsi-misc.patch
gdth-allocate-sense_buffer-to-prevent-null-pointer-dereference.patch
isd200-fix-memory-leak-in-isd200_get_inquiry_data.patch

