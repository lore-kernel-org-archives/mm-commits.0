From: akpm@linux-foundation.org
Subject: [merged] sd-tell-the-user-when-a-disks-capacity-is-adjusted.patch removed from -mm tree
Date: Fri, 06 Mar 2009 11:28:28 -0800
Message-ID: <200903061928.n26JSS7I022770@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35310 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755128AbZCFT2z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Mar 2009 14:28:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stern@rowland.harvard.edu, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     sd: tell the user when a disk's capacity is adjusted
has been removed from the -mm tree.  Its filename was
     sd-tell-the-user-when-a-disks-capacity-is-adjusted.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1387,18 +1387,22 @@ repeat:
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
