From: akpm@linux-foundation.org
Subject: + edac-i5100-fix-enable-ecc-hardware.patch added to -mm tree
Date: Fri, 27 Jun 2008 16:09:04 -0700
Message-ID: <200806272309.m5RN95IZ010807@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36024 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932169AbYF0XJ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Jun 2008 19:09:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ajones@riverbed.com


The patch titled
     edac: i5100 fix enable ecc hardware
has been added to the -mm tree.  Its filename is
     edac-i5100-fix-enable-ecc-hardware.patch

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
Subject: edac: i5100 fix enable ecc hardware
From: Arthur Jones <ajones@riverbed.com>

It is possible that the BIOS did not enable ECC at boot time.  We check
for that case and fail to load if it is true.

Signed-off-by: Arthur Jones <ajones@riverbed.com>
Signed-off-by: Arthur Jones <ajones@riverbed.com>
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

edac-i5100-new-intel-chipset-driver.patch
edac-i5100-fix-missing-bits.patch
edac-i5100-fix-enable-ecc-hardware.patch
edac-i5100-fix-unmask-ecc-bits.patch
edac-core-fix-to-use-dynamic-kobject.patch
edac-core-fix-workq-timer.patch
edac-core-fix-redundant-sysfs-controls-to-parameters.patch
edac-core-fix-static-to-dynamic-kset.patch
edac-core-fix-added-newline-to-sysfs-dimm-labels.patch

