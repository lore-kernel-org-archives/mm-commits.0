From: akpm@linux-foundation.org
Subject: + edac-i5100-fix-unmask-ecc-bits.patch added to -mm tree
Date: Fri, 27 Jun 2008 16:09:06 -0700
Message-ID: <200806272309.m5RN96NN010810@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932106AbYF0XJ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Jun 2008 19:09:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ajones@riverbed.com, dougthompson@xmission.com


The patch titled
     edac: i5100 fix unmask ecc bits
has been added to the -mm tree.  Its filename is
     edac-i5100-fix-unmask-ecc-bits.patch

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
Subject: edac: i5100 fix unmask ecc bits
From: Arthur Jones <ajones@riverbed.com>

Explicitly unmask ECC errors we are interested in reporting.

Signed-off-by: Arthur Jones <ajones@riverbed.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i5100_edac.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/edac/i5100_edac.c~edac-i5100-fix-unmask-ecc-bits drivers/edac/i5100_edac.c
--- a/drivers/edac/i5100_edac.c~edac-i5100-fix-unmask-ecc-bits
+++ a/drivers/edac/i5100_edac.c
@@ -75,6 +75,7 @@
 #define		I5100_FERR_NF_MEM_ANY(a)  ((a) & I5100_FERR_NF_MEM_ANY_MASK)
 #define	I5100_NERR_NF_MEM	0xa4	/* MC Next Non-Fatal Errors */
 #define		I5100_NERR_NF_MEM_ANY(a)  I5100_FERR_NF_MEM_ANY(a)
+#define I5100_EMASK_MEM		0xa8	/* MC Error Mask Register */
 
 /* device 21 and 22, func 0 */
 #define I5100_MTR_0	0x154	/* Memory Technology Registers 0-3 */
@@ -709,6 +710,11 @@ static int __devinit i5100_init_one(stru
 		goto bail;
 	}
 
+	/* enable error reporting... */
+	pci_read_config_dword(pdev, I5100_EMASK_MEM, &dw);
+	dw &= ~I5100_FERR_NF_MEM_ANY_MASK;
+	pci_write_config_dword(pdev, I5100_EMASK_MEM, dw);
+
 	/* device 21, func 0, Channel 0 Memory Map, Error Flag/Mask, etc... */
 	ch0mm = pci_get_device_func(PCI_VENDOR_ID_INTEL,
 				    PCI_DEVICE_ID_INTEL_5100_21, 0);
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

