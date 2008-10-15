From: akpm@linux-foundation.org
Subject: - libata-reorder-ata_device-to-remove-8-bytes-of-padding-on-64-bits.patch removed from -mm tree
Date: Wed, 15 Oct 2008 14:13:33 -0700
Message-ID: <200810152113.m9FLDXWW005579@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55998 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753234AbYJOVOj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 17:14:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@rsk.demon.co.uk, alan@redhat.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     libata: reorder ata_device to remove 8 bytes of padding on 64 bits
has been removed from the -mm tree.  Its filename was
     libata-reorder-ata_device-to-remove-8-bytes-of-padding-on-64-bits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

