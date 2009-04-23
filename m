From: akpm@linux-foundation.org
Subject: + scsi-fix-sign-extension-with-15tb-usb-storage-lbd=y.patch added to -mm tree
Date: Wed, 22 Apr 2009 21:38:16 -0700
Message-ID: <200904230438.n3N4cGP0025245@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32994 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750710AbZDWElQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Apr 2009 00:41:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dave@linux.vnet.ibm.com, James.Bottomley@HansenPartnership.com, viro@zeniv.linux.org.uk, willy@linux.intel.com


The patch titled
     scsi: fix sign extension with 1.5TB usb-storage LBD=y
has been added to the -mm tree.  Its filename is
     scsi-fix-sign-extension-with-15tb-usb-storage-lbd=y.patch

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
Subject: scsi: fix sign extension with 1.5TB usb-storage LBD=y
From: Dave Hansen <dave@linux.vnet.ibm.com>

Shifting an unsigned char implicitly casts it to a signed int.  This
caused 'lba' to sign-extend and Linux would then try READ CAPACITY 16
which was not supported by at least one drive.  Using the
get_unaligned_be*() helpers keeps us from having to worry about how the
extension might occur.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sd.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff -puN drivers/scsi/sd.c~scsi-fix-sign-extension-with-15tb-usb-storage-lbd=y drivers/scsi/sd.c
--- a/drivers/scsi/sd.c~scsi-fix-sign-extension-with-15tb-usb-storage-lbd=y
+++ a/drivers/scsi/sd.c
@@ -50,6 +50,7 @@
 #include <linux/string_helpers.h>
 #include <linux/async.h>
 #include <asm/uaccess.h>
+#include <asm/unaligned.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -1345,12 +1346,8 @@ static int read_capacity_16(struct scsi_
 		return -EINVAL;
 	}
 
-	sector_size =	(buffer[8] << 24) | (buffer[9] << 16) |
-			(buffer[10] << 8) | buffer[11];
-	lba =  (((u64)buffer[0] << 56) | ((u64)buffer[1] << 48) |
-		((u64)buffer[2] << 40) | ((u64)buffer[3] << 32) |
-		((u64)buffer[4] << 24) | ((u64)buffer[5] << 16) |
-		((u64)buffer[6] << 8) | (u64)buffer[7]);
+	sector_size = get_unaligned_be32(&buffer[8]);
+	lba = get_unaligned_be64(&buffer[0]);
 
 	sd_read_protection_type(sdkp, buffer);
 
@@ -1401,10 +1398,8 @@ static int read_capacity_10(struct scsi_
 		return -EINVAL;
 	}
 
-	sector_size =	(buffer[4] << 24) | (buffer[5] << 16) |
-			(buffer[6] << 8) | buffer[7];
-	lba =	(buffer[0] << 24) | (buffer[1] << 16) |
-		(buffer[2] << 8) | buffer[3];
+	sector_size = get_unaligned_be32(&buffer[4]);
+	lba = get_unaligned_be32(&buffer[0]);
 
 	if ((sizeof(sdkp->capacity) == 4) && (lba == 0xffffffff)) {
 		sd_printk(KERN_ERR, sdkp, "Too big for this kernel. Use a "
_

Patches currently in -mm which might be from dave@linux.vnet.ibm.com are

linux-next.patch
scsi-fix-sign-extension-with-15tb-usb-storage-lbd=y.patch

