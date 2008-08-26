From: akpm@linux-foundation.org
Subject: + libata-reorder-ata_device-to-remove-8-bytes-of-padding-on-64-bits.patch added to -mm tree
Date: Tue, 26 Aug 2008 15:48:17 -0700
Message-ID: <200808262248.m7QMmH8H031827@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60821 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751597AbYHZWtn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Aug 2008 18:49:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@rsk.demon.co.uk, jeff@garzik.org


The patch titled
     libata: reorder ata_device to remove 8 bytes of padding on 64 bits
has been added to the -mm tree.  Its filename is
     libata-reorder-ata_device-to-remove-8-bytes-of-padding-on-64-bits.patch

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
Subject: libata: reorder ata_device to remove 8 bytes of padding on 64 bits
From: Richard Kennedy <richard@rsk.demon.co.uk>

reduce size by 8 bytes from 1160 to 1152 allowing it to fit in 1 fewer
cachelines.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/libata.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/libata.h~libata-reorder-ata_device-to-remove-8-bytes-of-padding-on-64-bits include/linux/libata.h
--- a/include/linux/libata.h~libata-reorder-ata_device-to-remove-8-bytes-of-padding-on-64-bits
+++ a/include/linux/libata.h
@@ -554,8 +554,8 @@ struct ata_ering {
 struct ata_device {
 	struct ata_link		*link;
 	unsigned int		devno;		/* 0 or 1 */
-	unsigned long		flags;		/* ATA_DFLAG_xxx */
 	unsigned int		horkage;	/* List of broken features */
+	unsigned long		flags;		/* ATA_DFLAG_xxx */
 	struct scsi_device	*sdev;		/* attached SCSI device */
 #ifdef CONFIG_ATA_ACPI
 	acpi_handle		acpi_handle;
_

Patches currently in -mm which might be from richard@rsk.demon.co.uk are

linux-next.patch
hrtimer-reorder-struct-hrtimer-to-save-8-bytes-on-64-bit-builds.patch
libata-reorder-ata_device-to-remove-8-bytes-of-padding-on-64-bits.patch

