From: akpm@linux-foundation.org
Subject: - edac-e752x-bit-mask-fix.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:45:35 -0800
Message-ID: <200702122245.l1CMjZcg013723@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45141 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030292AbXBLWpv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:45:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bapper@mvista.com, ak@suse.de, alan@lxorguk.ukuu.org.uk, djiang@mvista.com, ebiederm@xmission.com, norsk5@xmission.com, mm-commits@vger.kernel.org


The patch titled
     EDAC: e752x bit mask fix
has been removed from the -mm tree.  Its filename was
     edac-e752x-bit-mask-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/e752x_edac.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

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

origin.patch
