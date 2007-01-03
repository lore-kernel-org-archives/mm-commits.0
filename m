From: akpm@osdl.org
Subject: + edac-e752x-bit-mask-fix.patch added to -mm tree
Date: Tue, 02 Jan 2007 16:38:29 -0800
Message-ID: <200701030038.l030cT6K002895@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50283 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839AbXACAin (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 19:38:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bapper@mvista.com, ak@suse.de, alan@lxorguk.ukuu.org.uk, djiang@mvista.com, ebiederm@xmission.com, norsk5@xmission.com


The patch titled
     EDAC: e752x bit mask fix
has been added to the -mm tree.  Its filename is
     edac-e752x-bit-mask-fix.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: EDAC: e752x bit mask fix
From: Brian Pomerantz <bapper@mvista.com>

The fatal vs.  non-fatal mask for the sysbus FERR status is incorrect
according to the E7520 datasheet.  This patch corrects the mask to correctly
handle fatal and non-fatal errors.

Signed-off-by: Brian Pomerantz <bapper@mvista.com>
Signed-off-by: Dave Jiang <djiang@mvista.com>
Signed-off-by: Doug Thompson <norsk5@xmission.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <ak@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/edac/e752x_edac.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/edac/e752x_edac.c~edac-e752x-bit-mask-fix drivers/edac/e752x_edac.c
--- a/drivers/edac/e752x_edac.c~edac-e752x-bit-mask-fix
+++ a/drivers/edac/e752x_edac.c
@@ -556,17 +556,17 @@ static void e752x_check_sysbus(struct e7
 	error32 = (stat32 >> 16) & 0x3ff;
 	stat32 = stat32 & 0x3ff;
 
-	if(stat32 & 0x083)
-		sysbus_error(1, stat32 & 0x083, error_found, handle_error);
+	if(stat32 & 0x087)
+		sysbus_error(1, stat32 & 0x087, error_found, handle_error);
 
-	if(stat32 & 0x37c)
-		sysbus_error(0, stat32 & 0x37c, error_found, handle_error);
+	if(stat32 & 0x378)
+		sysbus_error(0, stat32 & 0x378, error_found, handle_error);
 
-	if(error32 & 0x083)
-		sysbus_error(1, error32 & 0x083, error_found, handle_error);
+	if(error32 & 0x087)
+		sysbus_error(1, error32 & 0x087, error_found, handle_error);
 
-	if(error32 & 0x37c)
-		sysbus_error(0, error32 & 0x37c, error_found, handle_error);
+	if(error32 & 0x378)
+		sysbus_error(0, error32 & 0x378, error_found, handle_error);
 }
 
 static void e752x_check_membuf (struct e752x_error_info *info,
_

Patches currently in -mm which might be from bapper@mvista.com are

edac-e752x-bit-mask-fix.patch
edac-e752x-byte-access-fix.patch
