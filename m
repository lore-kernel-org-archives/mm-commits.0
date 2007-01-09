From: akpm@osdl.org
Subject: + cyber2010-framebuffer-on-arm-netwinder-fix.patch added to -mm tree
Date: Tue, 09 Jan 2007 14:17:36 -0800
Message-ID: <200701092217.l09MHb1s016910@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48201 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932451AbXAIWSY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 9 Jan 2007 17:18:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: woodys@xandros.com, adaplas@pol.net, jsimmons@infradead.org, ralf@linux-mips.org


The patch titled
     cyber2010 framebuffer on ARM Netwinder fix
has been added to the -mm tree.  Its filename is
     cyber2010-framebuffer-on-arm-netwinder-fix.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cyber2010 framebuffer on ARM Netwinder fix
From: Woody Suwalski <woodys@xandros.com>

The Netwinder machines with Cyber2010 crash badly when starting Xserver. 
The workaround is to disable pci burst option for this revision of video
chip.

Signed-off-by: Woody Suwalski <woodys@xandros.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: James Simmons <jsimmons@infradead.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/cyber2000fb.c |   22 +++++++++++++++-------
 1 files changed, 15 insertions(+), 7 deletions(-)

diff -puN drivers/video/cyber2000fb.c~cyber2010-framebuffer-on-arm-netwinder-fix drivers/video/cyber2000fb.c
--- a/drivers/video/cyber2000fb.c~cyber2010-framebuffer-on-arm-netwinder-fix
+++ a/drivers/video/cyber2000fb.c
@@ -1539,16 +1539,24 @@ static int cyberpro_pci_enable_mmio(stru
 	/*
 	 * Allow the CyberPro to accept PCI burst accesses
 	 */
-	val = cyber2000_grphr(EXT_BUS_CTL, cfb);
-	if (!(val & EXT_BUS_CTL_PCIBURST_WRITE)) {
-		printk(KERN_INFO "%s: enabling PCI bursts\n", cfb->fb.fix.id);
+	if (cfb->id == ID_CYBERPRO_2010)
+	{
+		printk(KERN_INFO "%s: NOT enabling PCI bursts\n", cfb->fb.fix.id);
+	}
+	else
+	{
+		val = cyber2000_grphr(EXT_BUS_CTL, cfb);
+		if (!(val & EXT_BUS_CTL_PCIBURST_WRITE)) {
+			printk(KERN_INFO "%s: enabling PCI bursts\n",
+				cfb->fb.fix.id);
 
-		val |= EXT_BUS_CTL_PCIBURST_WRITE;
+			val |= EXT_BUS_CTL_PCIBURST_WRITE;
 
-		if (cfb->id == ID_CYBERPRO_5000)
-			val |= EXT_BUS_CTL_PCIBURST_READ;
+			if (cfb->id == ID_CYBERPRO_5000)
+				val |= EXT_BUS_CTL_PCIBURST_READ;
 
-		cyber2000_grphw(EXT_BUS_CTL, val, cfb);
+			cyber2000_grphw(EXT_BUS_CTL, val, cfb);
+		}
 	}
 
 	return 0;
_

Patches currently in -mm which might be from woodys@xandros.com are

cyber2010-framebuffer-on-arm-netwinder-fix.patch
