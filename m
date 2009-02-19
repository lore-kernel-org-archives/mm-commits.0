From: akpm@linux-foundation.org
Subject: + sd-tell-the-user-when-a-disks-capacity-is-adjusted.patch added to -mm tree
Date: Thu, 19 Feb 2009 13:50:56 -0800
Message-ID: <200902192150.n1JLouvY025314@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35319 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757438AbZBSVvv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 16:51:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stern@rowland.harvard.edu, jens.axboe@oracle.com


The patch titled
     sd: tell the user when a disk's capacity is adjusted
has been added to the -mm tree.  Its filename is
     sd-tell-the-user-when-a-disks-capacity-is-adjusted.patch

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
Subject: sd: tell the user when a disk's capacity is adjusted
From: Alan Stern <stern@rowland.harvard.edu>

This patch (as1188) combines the tests for decrementing a drive's reported
capacity and expands the comment.  It also adds an informational message
to the system log, informing the user when the reported value has been
changed.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sd.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff -puN drivers/scsi/sd.c~sd-tell-the-user-when-a-disks-capacity-is-adjusted drivers/scsi/sd.c
--- a/drivers/scsi/sd.c~sd-tell-the-user-when-a-disks-capacity-is-adjusted
+++ a/drivers/scsi/sd.c
@@ -1386,18 +1386,22 @@ repeat:
 		sd_read_protection_type(sdkp, buffer);
 	}	
 
-	/* Some devices return the total number of sectors, not the
-	 * highest sector number.  Make the necessary adjustment. */
-	if (sdp->fix_capacity) {
+	/* Some devices are known to return the total number of blocks,
+	 * not the highest block number.  Some devices have versions
+	 * which do this and others which do not.  Some devices we might
+	 * suspect of doing this but we don't know for certain.
+	 *
+	 * If we know the reported capacity is wrong, decrement it.  If
+	 * we can only guess, then assume the number of blocks is even
+	 * (usually true but not always) and err on the side of lowering
+	 * the capacity.
+	 */
+	if (sdp->fix_capacity ||
+	    (sdp->guess_capacity && (sdkp->capacity & 0x01))) {
+		sd_printk(KERN_INFO, sdkp, "Adjusting the sector count "
+				"from its reported value: %llu\n",
+				(unsigned long long) sdkp->capacity);
 		--sdkp->capacity;
