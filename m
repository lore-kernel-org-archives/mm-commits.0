From: akpm@linux-foundation.org
Subject: - libata-add-ncq-blacklist-entries-from-silicon-image-windows.patch removed from -mm tree
Date: Tue, 06 Mar 2007 13:26:52 -0800
Message-ID: <200703062126.l26LQr86009974@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58891 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965136AbXCFV06 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 16:26:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hancockr@shaw.ca, mm-commits@vger.kernel.org


The patch titled
     libata: add NCQ blacklist entries from Silicon Image Windows driver
has been removed from the -mm tree.  Its filename was
     libata-add-ncq-blacklist-entries-from-silicon-image-windows.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: libata: add NCQ blacklist entries from Silicon Image Windows driver
From: Robert Hancock <hancockr@shaw.ca>

This patch adds in some NCQ blacklist entries taken from the Silicon Image
Windows drivers' .inf files for the 3124 and 3132 controllers.  These
entries were marked as ""DisableSataQueueing".  Assume these are in their
blacklist for a reason and disable NCQ on these drives.

Signed-off-by: Robert Hancock <hancockr@shaw.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/ata/libata-core.c~libata-add-ncq-blacklist-entries-from-silicon-image-windows drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-add-ncq-blacklist-entries-from-silicon-image-windows
+++ a/drivers/ata/libata-core.c
@@ -3368,6 +3368,13 @@ static const struct ata_blacklist_entry 
 
 	/* Devices with NCQ limits */
 
+	/* The following blacklist entries are taken from the Windows
+	   driver .inf files for the Silicon Image 3124 and 3132. */
+	{ "Maxtor 7B250S0",	"BANC1B70",	ATA_HORKAGE_NONCQ, },
+	{ "HTS541060G9SA00",	"MB3OC60D",	ATA_HORKAGE_NONCQ, },
+	{ "HTS541080G9SA00",	"MB4OC60D",	ATA_HORKAGE_NONCQ, },
+	{ "HTS541010G9SA00",	"MBZOC60D",	ATA_HORKAGE_NONCQ, },
+
 	/* End Marker */
 	{ }
 };
_

Patches currently in -mm which might be from hancockr@shaw.ca are

sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
libata-warn-if-speed-limited-due-to-40-wire-cable-v2.patch
libata-add-ncq-blacklist-entries-from-silicon-image-windows.patch
sata_nv-dont-read-shadow-registers-when-in-adma-mode.patch
