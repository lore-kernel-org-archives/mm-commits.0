From: akpm@linux-foundation.org
Subject: + ata-convert-gsi-to-irq-on-ia64.patch added to -mm tree
Date: Wed, 14 Feb 2007 23:37:03 -0800
Message-ID: <200702150737.l1F7b3VJ023161@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37994 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964965AbXBOHi2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 02:38:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yanmin_zhang@linux.intel.com, jeff@garzik.org, stable@kernel.org, tony.luck@intel.com, yanmin.zhang@intel.com


The patch titled
     ATA: convert GSI to irq on ia64
has been added to the -mm tree.  Its filename is
     ata-convert-gsi-to-irq-on-ia64.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ATA: convert GSI to irq on ia64
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>

If an ATA drive uses legacy mode, ata driver will choose 14 and 15 as the
fixed irq number.  On ia64 platform, such numbers are GSI and should be
converted to irq vector.

Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/Kconfig                 |    1 +
 include/asm-ia64/libata-portmap.h |   12 ++++++++++++
 2 files changed, 13 insertions(+)

diff -puN arch/ia64/Kconfig~ata-convert-gsi-to-irq-on-ia64 arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~ata-convert-gsi-to-irq-on-ia64
+++ a/arch/ia64/Kconfig
@@ -11,6 +11,7 @@ menu "Processor type and features"
 
 config IA64
 	bool
+	select ATA_NONSTANDARD if ATA
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
diff -puN /dev/null include/asm-ia64/libata-portmap.h
--- /dev/null
+++ a/include/asm-ia64/libata-portmap.h
@@ -0,0 +1,12 @@
+#ifndef __ASM_IA64_LIBATA_PORTMAP_H
+#define __ASM_IA64_LIBATA_PORTMAP_H
+
+#define ATA_PRIMARY_CMD		0x1F0
+#define ATA_PRIMARY_CTL		0x3F6
+#define ATA_PRIMARY_IRQ(dev)	isa_irq_to_vector(14)
+
+#define ATA_SECONDARY_CMD	0x170
+#define ATA_SECONDARY_CTL	0x376
+#define ATA_SECONDARY_IRQ(dev)	isa_irq_to_vector(15)
+
+#endif
_

Patches currently in -mm which might be from yanmin_zhang@linux.intel.com are

ata-convert-gsi-to-irq-on-ia64.patch
