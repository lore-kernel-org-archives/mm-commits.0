From: akpm@linux-foundation.org
Subject: - edac-x38-use-the-architectures-readq-function.patch removed from -mm tree
Date: Tue, 06 Jan 2009 15:59:15 -0800
Message-ID: <200901062359.n06NxGS7002647@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46593 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751230AbZAFX7U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2009 18:59:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mitake@clustcom.com, dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     edac x38: use the architecture's readq() function
has been removed from the -mm tree.  Its filename was
     edac-x38-use-the-architectures-readq-function.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac x38: use the architecture's readq() function
From: Hitoshi Mitake <mitake@clustcom.com>

Make x38_edac.c use the kernel's readq() function when it is compiled for
x86_64.

[akpm@linux-foundation.org: simplify Kconfig]
[akpm@linux-foundation.org: fix i386 build]
Signed-off-by: Hitoshi Mitake <mitake@clustcom.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/Kconfig    |    2 +-
 drivers/edac/x38_edac.c |   12 +++++++-----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff -puN drivers/edac/Kconfig~edac-x38-use-the-architectures-readq-function drivers/edac/Kconfig
--- a/drivers/edac/Kconfig~edac-x38-use-the-architectures-readq-function
+++ a/drivers/edac/Kconfig
@@ -104,7 +104,7 @@ config EDAC_I3000
 
 config EDAC_X38
 	tristate "Intel X38"
-	depends on EDAC_MM_EDAC && PCI && X86
+	depends on EDAC_MM_EDAC && PCI && X86_64
 	help
 	  Support for error detection and correction on the Intel
 	  X38 server chipsets.
diff -puN drivers/edac/x38_edac.c~edac-x38-use-the-architectures-readq-function drivers/edac/x38_edac.c
--- a/drivers/edac/x38_edac.c~edac-x38-use-the-architectures-readq-function
+++ a/drivers/edac/x38_edac.c
@@ -162,10 +162,12 @@ static void x38_clear_error_info(struct 
 			 X38_ERRSTS_BITS);
 }
 
-static u64 x38_readq(const void __iomem *addr)
+#ifndef CONFIG_X86_64
+static u64 readq(const void __iomem *addr)
 {
 	return readl(addr) | (((u64)readl(addr + 4)) << 32);
 }
+#endif	/* CONFIG_X86_64 */
 
 static void x38_get_and_clear_error_info(struct mem_ctl_info *mci,
 				 struct x38_error_info *info)
@@ -184,9 +186,9 @@ static void x38_get_and_clear_error_info
 	if (!(info->errsts & X38_ERRSTS_BITS))
 		return;
 
-	info->eccerrlog[0] = x38_readq(window + X38_C0ECCERRLOG);
+	info->eccerrlog[0] = readq(window + X38_C0ECCERRLOG);
 	if (x38_channel_num == 2)
-		info->eccerrlog[1] = x38_readq(window + X38_C1ECCERRLOG);
+		info->eccerrlog[1] = readq(window + X38_C1ECCERRLOG);
 
 	pci_read_config_word(pdev, X38_ERRSTS, &info->errsts2);
 
@@ -197,10 +199,10 @@ static void x38_get_and_clear_error_info
 	 * should be UE info.
 	 */
 	if ((info->errsts ^ info->errsts2) & X38_ERRSTS_BITS) {
-		info->eccerrlog[0] = x38_readq(window + X38_C0ECCERRLOG);
+		info->eccerrlog[0] = readq(window + X38_C0ECCERRLOG);
 		if (x38_channel_num == 2)
 			info->eccerrlog[1] =
-				x38_readq(window + X38_C1ECCERRLOG);
+				readq(window + X38_C1ECCERRLOG);
 	}
 
 	x38_clear_error_info(mci);
_

Patches currently in -mm which might be from mitake@clustcom.com are

edac-x38-use-the-architectures-readq-function.patch

