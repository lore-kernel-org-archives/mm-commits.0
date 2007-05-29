From: akpm@linux-foundation.org
Subject: + b44-ssb-fix-an-invalid-pointer-casting.patch added to -mm tree
Date: Tue, 29 May 2007 16:14:40 -0700
Message-ID: <200705292314.l4TNEeoi014066@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:33876 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750965AbXE2XPv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 19:15:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mb@bu3sch.de, linville@tuxdriver.com, zambrano@broadcom.com


The patch titled
     b44-ssb: fix an invalid pointer casting
has been added to the -mm tree.  Its filename is
     b44-ssb-fix-an-invalid-pointer-casting.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: b44-ssb: fix an invalid pointer casting
From: Michael Buesch <mb@bu3sch.de>

This fixes a bug introduced by me with the ssb porting.  A u32 integer is
casted to a u16* pointer, which is gonna break, obviously.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>
Cc: Gary Zambrano <zambrano@broadcom.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/b44.c |   26 +++++++++++++++++---------
 1 files changed, 17 insertions(+), 9 deletions(-)

diff -puN drivers/net/b44.c~b44-ssb-fix-an-invalid-pointer-casting drivers/net/b44.c
--- a/drivers/net/b44.c~b44-ssb-fix-an-invalid-pointer-casting
+++ a/drivers/net/b44.c
@@ -1568,6 +1568,22 @@ static void b44_setup_pseudo_magicp(stru
 
 }
 
+#ifdef CONFIG_B44_PCI
+static void b44_setup_wol_pci(struct b44 *bp)
+{
+	u16 val;
+
+	if (bp->sdev->bus->bustype != SSB_BUSTYPE_SSB) {
+		val = br32(bp, SSB_TMSLOW);
+		bw32(bp, SSB_TMSLOW, val | SSB_TMSLOW_PE);
+		pci_read_config_word(bp->sdev->bus->host_pci, SSB_PMCSR, &val);
+		pci_write_config_word(bp->sdev->bus->host_pci, SSB_PMCSR, val | SSB_PE);
+	}
+}
+#else
+static inline void b44_setup_wol_pci(struct b44 *bp) { }
+#endif /* CONFIG_B44_PCI */
+
 static void b44_setup_wol(struct b44 *bp)
 {
 	u32 val;
@@ -1594,15 +1610,7 @@ static void b44_setup_wol(struct b44 *bp
  	} else {
  		b44_setup_pseudo_magicp(bp);
  	}
-
-#ifdef CONFIG_B44_PCI
-	if (bp->sdev->bus->bustype != SSB_BUSTYPE_SSB) {
-		val = br32(bp, SSB_TMSLOW);
-		bw32(bp, SSB_TMSLOW, val | SSB_TMSLOW_PE);
-	}
-	pci_read_config_word(bp->sdev->bus->host_pci, SSB_PMCSR, (u16 *)(&val));
-	pci_write_config_word(bp->sdev->bus->host_pci, SSB_PMCSR, val | SSB_PE);
-#endif /* CONFIG_B44_PCI */
+	b44_setup_wol_pci(bp);
 }
 
 static int b44_close(struct net_device *dev)
_

Patches currently in -mm which might be from mb@bu3sch.de are

git-wireless.patch
b44-ssb-fix-an-invalid-pointer-casting.patch
