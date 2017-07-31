From: akpm@linux-foundation.org
Subject: [merged]
 block-dac960-shut-up-format-overflow-warning.patch removed from -mm tree
Date: Mon, 31 Jul 2017 12:18:41 -0700
Message-ID: <20170731191841.Orztmr8RH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41786 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751126AbdGaTSm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Jul 2017 15:18:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: block: DAC960: shut up format-overflow warning
has been removed from the -mm tree.  Its filename was
     block-dac960-shut-up-format-overflow-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: block: DAC960: shut up format-overflow warning

gcc-7 points out that a large controller number would overflow the
string length for the procfs name and the firmware version string:

drivers/block/DAC960.c: In function 'DAC960_Probe':
drivers/block/DAC960.c:6591:38: warning: 'sprintf' may write a terminating nul past the end of the destination [-Wformat-overflow=]
drivers/block/DAC960.c: In function 'DAC960_V1_ReadControllerConfiguration':
drivers/block/DAC960.c:1681:40: error: '%02d' directive writing between 2 and 3 bytes into a region of size between 2 and 5 [-Werror=format-overflow=]
drivers/block/DAC960.c:1681:40: note: directive argument in the range [0, 255]
drivers/block/DAC960.c:1681:3: note: 'sprintf' output between 10 and 14 bytes into a destination of size 12

Both of these seem appropriately sized, and using snprintf()
instead of sprintf() improves this by ensuring that even
incorrect data won't cause undefined behavior here.

Link: http://lkml.kernel.org/r/20170714120720.906842-20-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/DAC960.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN drivers/block/DAC960.c~block-dac960-shut-up-format-overflow-warning drivers/block/DAC960.c
--- a/drivers/block/DAC960.c~block-dac960-shut-up-format-overflow-warning
+++ a/drivers/block/DAC960.c
@@ -1678,9 +1678,12 @@ static bool DAC960_V1_ReadControllerConf
       Enquiry2->FirmwareID.FirmwareType = '0';
       Enquiry2->FirmwareID.TurnID = 0;
     }
-  sprintf(Controller->FirmwareVersion, "%d.%02d-%c-%02d",
-	  Enquiry2->FirmwareID.MajorVersion, Enquiry2->FirmwareID.MinorVersion,
-	  Enquiry2->FirmwareID.FirmwareType, Enquiry2->FirmwareID.TurnID);
+  snprintf(Controller->FirmwareVersion, sizeof(Controller->FirmwareVersion),
+	   "%d.%02d-%c-%02d",
+	   Enquiry2->FirmwareID.MajorVersion,
+	   Enquiry2->FirmwareID.MinorVersion,
+	   Enquiry2->FirmwareID.FirmwareType,
+	   Enquiry2->FirmwareID.TurnID);
   if (!((Controller->FirmwareVersion[0] == '5' &&
 	 strcmp(Controller->FirmwareVersion, "5.06") >= 0) ||
 	(Controller->FirmwareVersion[0] == '4' &&
@@ -6588,7 +6591,8 @@ static void DAC960_CreateProcEntries(DAC
 			    &dac960_proc_fops);
 	}
 
-	sprintf(Controller->ControllerName, "c%d", Controller->ControllerNumber);
+	snprintf(Controller->ControllerName, sizeof(Controller->ControllerName),
+		 "c%d", Controller->ControllerNumber);
 	ControllerProcEntry = proc_mkdir(Controller->ControllerName,
 					 DAC960_ProcDirectoryEntry);
 	proc_create_data("initial_status", 0, ControllerProcEntry, &dac960_initial_status_proc_fops, Controller);
_

Patches currently in -mm which might be from arnd@arndb.de are

kasan-avoid-wmaybe-uninitialized-warning-v3.patch
fscache-fix-fscache_objlist_show-format-processing.patch
ib-mlx4-fix-sprintf-format-warning.patch
iopoll-avoid-wint-in-bool-context-warning.patch
kbuild-use-fshort-wchar-globally.patch

