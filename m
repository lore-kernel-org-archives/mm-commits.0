From: akpm@linux-foundation.org
Subject: - usb-storage-unusual_devs-entries-for-iriver-t10-and-datafab-cfsm-reader.patch removed from -mm tree
Date: Mon, 04 Aug 2008 13:07:36 -0700
Message-ID: <200808042007.m74K7aH8027798@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761142AbYHDUHr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 16:07:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stern@rowland.harvard.edu, greg@kroah.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     usb-storage: unusual_devs entries for iRiver T10 and Datafab CF+SM=
 reader
has been removed from the -mm tree.  Its filename was
     usb-storage-unusual_devs-entries-for-iriver-t10-and-datafab-cfsm-r=
eader.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: usb-storage: unusual_devs entries for iRiver T10 and Datafab C=
=46+SM reader
=46rom: Alan Stern <stern@rowland.harvard.edu>

This patch (as1115) adds unusual_devs entries with the IGNORE_RESIDE fl=
ag
for the iRiver T10 and the Simple Tech/Datafab CF+SM card reader.=20
Apparently these devices provide reasonable residue values for READ and
WRITE operations, but not for others like INQUIRY or READ CAPACITY.

This fixes the iRiver T10 problem reported in Bugzilla #11125.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/storage/unusual_devs.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN drivers/usb/storage/unusual_devs.h~usb-storage-unusual_devs-e=
ntries-for-iriver-t10-and-datafab-cfsm-reader drivers/usb/storage/unusu=
al_devs.h
--- a/drivers/usb/storage/unusual_devs.h~usb-storage-unusual_devs-entri=
es-for-iriver-t10-and-datafab-cfsm-reader
+++ a/drivers/usb/storage/unusual_devs.h
@@ -1185,6 +1185,13 @@ UNUSUAL_DEV(  0x07c4, 0xa400, 0x0000, 0x
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_FIX_INQUIRY ),
=20
+/* Reported by Rauch Wolke <rauchwolke@gmx.net> */
+UNUSUAL_DEV(  0x07c4, 0xa4a5, 0x0000, 0xffff,
+		"Simple Tech/Datafab",
+		"CF+SM Reader",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_IGNORE_RESIDUE ),
+
 /* Casio QV 2x00/3x00/4000/8000 digital still cameras are not conforma=
nt
  * to the USB storage specification in two ways:
  * - They tell us they are using transport protocol CBI. In reality th=
ey
@@ -1767,6 +1774,13 @@ UNUSUAL_DEV(  0x2770, 0x915d, 0x0010, 0x
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_FIX_CAPACITY ),
=20
+/* Reported by Andrey Rahmatullin <wrar@altlinux.org> */
+UNUSUAL_DEV(  0x4102, 0x1020, 0x0100,  0x0100,
+		"iRiver",
+		"MP3 T10",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_IGNORE_RESIDUE ),
+
 /*
  * David H=C3=A4rdeman <david@2gen.com>
  * The key makes the SCSI stack print confusing (but harmless) message=
s
_

Patches currently in -mm which might be from stern@rowland.harvard.edu =
are

linux-next.patch
usb-hubc-fix-build-with-config_pm=3Dn.patch
unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
