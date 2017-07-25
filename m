From: akpm@linux-foundation.org
Subject: [merged] scsi-megaraid-fix-format-overflow-warning.patch
 removed from -mm tree
Date: Tue, 25 Jul 2017 10:40:25 -0700
Message-ID: <20170725174025.2ousNfJaa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50520 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751531AbdGYRk1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jul 2017 13:40:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: scsi: megaraid: fix format-overflow warning
has been removed from the -mm tree.  Its filename was
     scsi-megaraid-fix-format-overflow-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: scsi: megaraid: fix format-overflow warning

gcc-7 complains that the firmware version strings might overflow
for some values:

drivers/scsi/megaraid.c: In function 'megaraid_probe_one':
drivers/scsi/megaraid.c:314:33: error: '%d' directive writing between 1 and 2 bytes into a region of size between 1 and 2 [-Werror=format-overflow=]
drivers/scsi/megaraid.c:314:33: note: directive argument in the range [0, 15]
drivers/scsi/megaraid.c:314:3: note: 'sprintf' output between 7 and 9 bytes into a destination of size 7
drivers/scsi/megaraid.c:320:35: error: '%d' directive writing between 1 and 2 bytes into a region of size between 1 and 2 [-Werror=format-overflow=]
drivers/scsi/megaraid.c:320:35: note: directive argument in the range [0, 15]
drivers/scsi/megaraid.c:320:3: note: 'sprintf' output between 7 and 9 bytes into a destination of size 7

This makes the code use a truncating snprintf() instead, which shuts
up that warning.

Link: http://lkml.kernel.org/r/20170714120720.906842-3-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/megaraid.c~scsi-megaraid-fix-format-overflow-warning drivers/scsi/megaraid.c
--- a/drivers/scsi/megaraid.c~scsi-megaraid-fix-format-overflow-warning
+++ a/drivers/scsi/megaraid.c
@@ -311,13 +311,15 @@ mega_query_adapter(adapter_t *adapter)
 	   right 8 bits making them zero. This 0 value was hardcoded to fix
 	   sparse warnings. */
 	if (adapter->product_info.subsysvid == PCI_VENDOR_ID_HP) {
-		sprintf (adapter->fw_version, "%c%d%d.%d%d",
+		snprintf(adapter->fw_version, sizeof(adapter->fw_version),
+			 "%c%d%d.%d%d",
 			 adapter->product_info.fw_version[2],
 			 0,
 			 adapter->product_info.fw_version[1] & 0x0f,
 			 0,
 			 adapter->product_info.fw_version[0] & 0x0f);
-		sprintf (adapter->bios_version, "%c%d%d.%d%d",
+		snprintf(adapter->bios_version, sizeof(adapter->fw_version),
+			 "%c%d%d.%d%d",
 			 adapter->product_info.bios_version[2],
 			 0,
 			 adapter->product_info.bios_version[1] & 0x0f,
_

Patches currently in -mm which might be from arnd@arndb.de are

kasan-avoid-wmaybe-uninitialized-warning.patch
block-dac960-shut-up-format-overflow-warning.patch
fscache-fix-fscache_objlist_show-format-processing.patch
ib-mlx4-fix-sprintf-format-warning.patch

