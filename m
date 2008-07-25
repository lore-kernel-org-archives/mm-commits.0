From: akpm@linux-foundation.org
Subject: - edac-i5100-fix-enable-ecc-hardware.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:03:52 -0700
Message-ID: <200807252303.m6PN3qKs003991@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37607 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753922AbYGYXE1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:04:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ajones@riverbed.com, dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     edac: i5100 fix enable ecc hardware
has been removed from the -mm tree.  Its filename was
     edac-i5100-fix-enable-ecc-hardware.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: i5100 fix enable ecc hardware
From: Arthur Jones <ajones@riverbed.com>

It is possible that the BIOS did not enable ECC at boot time.  We check
for that case and fail to load if it is true.

Signed-off-by: Arthur Jones <ajones@riverbed.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i5100_edac.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN drivers/edac/i5100_edac.c~edac-i5100-fix-enable-ecc-hardware drivers/edac/i5100_edac.c
--- a/drivers/edac/i5100_edac.c~edac-i5100-fix-enable-ecc-hardware
+++ a/drivers/edac/i5100_edac.c
@@ -24,6 +24,8 @@
 /* register addresses and bit field accessors... */
 
 /* device 16, func 1 */
+#define I5100_MC		0x40	/* Memory Control Register */
+#define		I5100_MC_ERRDETEN(a)	((a) >> 5 & 1)
 #define I5100_MS		0x44	/* Memory Status Register */
 #define I5100_SPDDATA		0x48	/* Serial Presence Detect Status Reg */
 #define		I5100_SPDDATA_RDO(a)	((a) >> 15 & 1)
@@ -688,6 +690,14 @@ static int __devinit i5100_init_one(stru
 		goto bail;
 	}
 
+	/* ECC enabled? */
+	pci_read_config_dword(pdev, I5100_MC, &dw);
+	if (!I5100_MC_ERRDETEN(dw)) {
+		printk(KERN_INFO "i5100_edac: ECC not enabled.\n");
+		ret = -ENODEV;
+		goto bail;
+	}
+
 	/* figure out how many ranks, from strapped state of 48GB_Mode input */
 	pci_read_config_dword(pdev, I5100_MS, &dw);
 	ranksperch = !!(dw & (1 << 8)) * 2 + 4;
_

Patches currently in -mm which might be from ajones@riverbed.com are

origin.patch

