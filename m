From: akpm@linux-foundation.org
Subject: - libata-add-ncq-blacklist-entries-from-silicon-image-windows.patch removed from -mm tree
Date: Wed, 04 Apr 2007 19:00:20 -0700
Message-ID: <200704050200.l3520KpQ004810@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38013 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075AbXDECAW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 4 Apr 2007 22:00:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hancockr@shaw.ca, htejun@gmail.com, mm-commits@vger.kernel.org


The patch titled
     libata: add NCQ blacklist entries from Silicon Image Windows  driver (v2)
has been removed from the -mm tree.  Its filename was
     libata-add-ncq-blacklist-entries-from-silicon-image-windows.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: libata: add NCQ blacklist entries from Silicon Image Windows  driver (v2)
From: Robert Hancock <hancockr@shaw.ca>

This adds some NCQ blacklist entries taken from the Silicon Image 3124/3132
Windows driver .inf files.  There are some confirming reports of problems
with these drives under Linux (for example
http://lkml.org/lkml/2007/3/4/178) so let's disable NCQ on these drives.

Signed-off-by: Robert Hancock <hancockr@shaw.ca>
Acked-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |    5 +++++
 1 files changed, 5 insertions(+)

diff -puN drivers/ata/libata-core.c~libata-add-ncq-blacklist-entries-from-silicon-image-windows drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-add-ncq-blacklist-entries-from-silicon-image-windows
+++ a/drivers/ata/libata-core.c
@@ -3438,6 +3438,11 @@ static const struct ata_blacklist_entry 
 	{ "Maxtor 6L250S0",     "BANC1G10",     ATA_HORKAGE_NONCQ },
 	/* NCQ hard hangs device under heavier load, needs hard power cycle */
 	{ "Maxtor 6B250S0",	"BANC1B70",	ATA_HORKAGE_NONCQ },
+	/* Blacklist entries taken from Silicon Image 3124/3132
+	   Windows driver .inf file - also several Linux problem reports */
+	{ "HTS541060G9SA00",    "MB3OC60D",     ATA_HORKAGE_NONCQ, },
+	{ "HTS541080G9SA00",    "MB4OC60D",     ATA_HORKAGE_NONCQ, },
+	{ "HTS541010G9SA00",    "MBZOC60D",     ATA_HORKAGE_NONCQ, },
 
 	/* Devices with NCQ limits */
 
_

Patches currently in -mm which might be from hancockr@shaw.ca are

origin.patch
git-libata-all.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
