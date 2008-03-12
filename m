From: akpm@linux-foundation.org
Subject: + isd200-fix-memory-leak-in-isd200_get_inquiry_data.patch added to -mm tree
Date: Tue, 11 Mar 2008 21:59:19 -0700
Message-ID: <200803120459.m2C4xJr1011025@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60204 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752174AbYCLE7y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Mar 2008 00:59:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bharrosh@panasas.com, gregkh@suse.de, mdharm-usb@one-eyed-alien.net, oliver@neukum.org, stern@rowland.harvard.edu


The patch titled
     isd200: Fix memory leak in isd200_get_inquiry_data
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
Subject: isd200: Fix memory leak in isd200_get_inquiry_data
From: Boaz Harrosh <bharrosh@panasas.com>

If the inquiry fails then the call to us->extra_destructor() is assumed to
also free the info structure.  So make that so in isd200_free_info_ptrs()

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Oliver Neukum <oliver@neukum.org>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/storage/isd200.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/usb/storage/isd200.c~isd200-fix-memory-leak-in-isd200_get_inquiry_data drivers/usb/storage/isd200.c
--- a/drivers/usb/storage/isd200.c~isd200-fix-memory-leak-in-isd200_get_inquiry_data
+++ a/drivers/usb/storage/isd200.c
@@ -1471,6 +1471,9 @@ static void isd200_free_info_ptrs(void *
 		kfree(info->id);
 		kfree(info->RegsBuf);
 		kfree(info->sense_buffer);
+		kfree(info);
+		us->extra = NULL;
+		us->extra_destructor = NULL;
 	}
 }
 
_

Patches currently in -mm which might be from bharrosh@panasas.com are

git-scsi-misc.patch
gdth-allocate-sense_buffer-to-prevent-null-pointer-dereference.patch
isd200-allocate-sense_buffer-for-hacked-up-scsi_cmnd.patch
isd200-allocate-sense_buffer-for-hacked-up-scsi_cmnd-checkpatch-fixes.patch
isd200-fix-memory-leak-in-isd200_get_inquiry_data.patch

