From: akpm@linux-foundation.org
Subject: - ata-increase-allowed-config-flags.patch removed from -mm tree
Date: Fri, 21 Sep 2007 14:08:20 -0700
Message-ID: <200709212108.l8LL8KL0023566@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51041 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762598AbXIUVJN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 17:09:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kristen.c.accardi@intel.com, hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     ata: increase allowed config flags
has been removed from the -mm tree.  Its filename was
     ata-increase-allowed-config-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ata: increase allowed config flags
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

In anticipation of more features, increase number of config flags
allowed, and move the init flags.

Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Hugh Dickens <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/libata.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/libata.h~ata-increase-allowed-config-flags include/linux/libata.h
--- a/include/linux/libata.h~ata-increase-allowed-config-flags
+++ a/include/linux/libata.h
@@ -140,11 +140,11 @@ enum {
 	ATA_DFLAG_ACPI_PENDING	= (1 << 5), /* ACPI resume action pending */
 	ATA_DFLAG_ACPI_FAILED	= (1 << 6), /* ACPI on devcfg has failed */
 	ATA_DFLAG_AN		= (1 << 7), /* device supports AN */
-	ATA_DFLAG_CFG_MASK	= (1 << 8) - 1,
+	ATA_DFLAG_CFG_MASK	= (1 << 12) - 1,
 
-	ATA_DFLAG_PIO		= (1 << 8), /* device limited to PIO mode */
-	ATA_DFLAG_NCQ_OFF	= (1 << 9), /* device limited to non-NCQ mode */
-	ATA_DFLAG_SPUNDOWN	= (1 << 10), /* XXX: for spindown_compat */
+	ATA_DFLAG_PIO		= (1 << 12), /* device limited to PIO mode */
+	ATA_DFLAG_NCQ_OFF	= (1 << 13), /* device limited to non-NCQ mode */
+	ATA_DFLAG_SPUNDOWN	= (1 << 14), /* XXX: for spindown_compat */
 	ATA_DFLAG_INIT_MASK	= (1 << 16) - 1,
 
 	ATA_DFLAG_DETACH	= (1 << 16),
_

Patches currently in -mm which might be from kristen.c.accardi@intel.com are

git-libata-all.patch
scsi-expose-an-support-to-user-space.patch
libata-expose-an-to-user-space.patch
scsi-send-media-state-change-modification-events.patch
scsi-use-notifier-chain-for-asynchronous-event.patch
