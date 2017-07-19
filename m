From: akpm@linux-foundation.org
Subject: + block-dac960-shut-up-format-overflow-warning.patch added to -mm tree
Date: Wed, 19 Jul 2017 14:50:34 -0700
Message-ID: <596fd42a.1VDx1Z2lrpOkfdUf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34142 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755117AbdGSVuf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jul 2017 17:50:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: block: DAC960: shut up format-overflow warning
has been added to the -mm tree.  Its filename is
     block-dac960-shut-up-format-overflow-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/block-dac960-shut-up-format-overflow-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/block-dac960-shut-up-format-overflow-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kbuild-disable-wformat-truncation-warnings-by-default.patch
scsi-megaraid-fix-format-overflow-warning.patch
scsi-mpt3sas-fix-format-overflow-warning.patch
scsi-fusion-fix-string-overflow-warning.patch
scsi-gdth-avoid-buffer-overflow-warning.patch
scsi-fnic-fix-format-string-overflow-warning.patch
scsi-gdth-increase-the-procfs-event-buffer-size.patch
usbvision-i2c-fix-format-overflow-warning.patch
hwmon-applesmc-fix-format-string-overflow.patch
x86-intel-mid-fix-a-format-string-overflow-warning.patch
platform-x86-alienware-wmi-fix-format-string-overflow-warning.patch
block-dac960-shut-up-format-overflow-warning.patch
fscache-fix-fscache_objlist_show-format-processing.patch
ib-mlx4-fix-sprintf-format-warning.patch

