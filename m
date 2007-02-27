From: akpm@linux-foundation.org
Subject: + libata-add-ncq-blacklist-entries-from-silicon-image-windows.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:39:21 -0800
Message-ID: <200702272039.l1RKdPhP027692@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50906 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558AbXB0Uko (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:40:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hancockr@shaw.ca


The patch titled
     libata: add NCQ blacklist entries from Silicon Image Windows driver
has been added to the -mm tree.  Its filename is
     libata-add-ncq-blacklist-entries-from-silicon-image-windows.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -3371,6 +3371,13 @@ static const struct ata_blacklist_entry 
 
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

git-libata-all.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
libata-warn-if-speed-limited-due-to-40-wire-cable-v2.patch
sata_nv-kill-old-private-bmdma-helper-functions.patch
sata_nv-complain-on-spurious-completion-notifiers.patch
libata-add-ncq-blacklist-entries-from-silicon-image-windows.patch
