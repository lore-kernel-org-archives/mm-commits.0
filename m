From: akpm@linux-foundation.org
Subject: + scsi-megaraid_sas-update-the-version-and-changelog.patch added to -mm tree
Date: Tue, 29 Apr 2008 13:45:18 -0700
Message-ID: <200804292045.m3TKjIbB008887@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36131 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752770AbYD2UpW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 16:45:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bo.yang@lsi.com


The patch titled
     scsi: megaraid_sas: update the Version and Changelog
has been added to the -mm tree.  Its filename is
     scsi-megaraid_sas-update-the-version-and-changelog.patch

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
Subject: scsi: megaraid_sas: update the Version and Changelog
From: bo yang <bo.yang@lsi.com>

Update the Version and Changelog for megaraid_sas Driver

Signed-off-by: Bo Yang <bo.yang@lsi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/scsi/ChangeLog.megaraid_sas |   22 ++++++++++++++++++++
 drivers/scsi/megaraid/megaraid_sas.c      |    2 -
 drivers/scsi/megaraid/megaraid_sas.h      |    6 ++---
 3 files changed, 26 insertions(+), 4 deletions(-)

diff -puN Documentation/scsi/ChangeLog.megaraid_sas~scsi-megaraid_sas-update-the-version-and-changelog Documentation/scsi/ChangeLog.megaraid_sas
--- a/Documentation/scsi/ChangeLog.megaraid_sas~scsi-megaraid_sas-update-the-version-and-changelog
+++ a/Documentation/scsi/ChangeLog.megaraid_sas
@@ -1,3 +1,25 @@
+1 Release Date    : Mon. March 10 11:02:31 PDT 2008 -
+			(emaild-id:megaraidlinux@lsi.com)
+			Sumant Patro
+			Bo Yang
+
+2 Current Version : 00.00.03.20-RC1
+3 Older Version   : 00.00.03.16
+
+1. Rollback the sense info implementation
+	Sense buffer ptr data type in the ioctl path is reverted back
+	to u32 * as in previous versions of driver.
+
+2. Fixed the driver frame count.
+	When Driver sent wrong frame count to firmware.  As this
+	particular command is sent to drive, FW is seeing continuous
+	chip resets and so the command will timeout.
+
+3. Add the new controller(1078DE) support to the driver
+	and Increase the max_wait to 60 from 10 in the controller
+	operational status.  With this max_wait increase, driver will
+	make sure the FW will 	finish the pending cmd for KDUMP case.
+
 1 Release Date    : Thur. Nov. 07 16:30:43 PST 2007 -
 			(emaild-id:megaraidlinux@lsi.com)
 			Sumant Patro
diff -puN drivers/scsi/megaraid/megaraid_sas.c~scsi-megaraid_sas-update-the-version-and-changelog drivers/scsi/megaraid/megaraid_sas.c
--- a/drivers/scsi/megaraid/megaraid_sas.c~scsi-megaraid_sas-update-the-version-and-changelog
+++ a/drivers/scsi/megaraid/megaraid_sas.c
@@ -10,7 +10,7 @@
  *	   2 of the License, or (at your option) any later version.
  *
  * FILE		: megaraid_sas.c
- * Version	: v00.00.03.16-rc1
+ * Version	: v00.00.03.20-rc1
  *
  * Authors:
  *	(email-id : megaraidlinux@lsi.com)
diff -puN drivers/scsi/megaraid/megaraid_sas.h~scsi-megaraid_sas-update-the-version-and-changelog drivers/scsi/megaraid/megaraid_sas.h
--- a/drivers/scsi/megaraid/megaraid_sas.h~scsi-megaraid_sas-update-the-version-and-changelog
+++ a/drivers/scsi/megaraid/megaraid_sas.h
@@ -18,9 +18,9 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"00.00.03.16-rc1"
-#define MEGASAS_RELDATE				"Nov. 07, 2007"
-#define MEGASAS_EXT_VERSION			"Thu. Nov. 07 10:09:32 PDT 2007"
+#define MEGASAS_VERSION			"00.00.03.20-rc1"
+#define MEGASAS_RELDATE			"March 10, 2008"
+#define MEGASAS_EXT_VERSION		"Mon. March 10 11:02:31 PDT 2008"
 
 /*
  * Device IDs
_

Patches currently in -mm which might be from bo.yang@lsi.com are

origin.patch
scsi-megaraid_sas-update-the-version-and-changelog.patch

