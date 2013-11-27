From: akpm@linux-foundation.org
Subject: + firmware-dmi_scan-generalize-for-use-by-other-archs.patch added to -mm tree
Date: Wed, 27 Nov 2013 13:56:42 -0800
Message-ID: <52966a9a.8jjHhChyl+CZcWcO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51920 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584Ab3K0V4r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Nov 2013 16:56:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mingo@elte.hu, grant.likely@linaro.org, ard.biesheuvel@linaro.org

Subject: + firmware-dmi_scan-generalize-for-use-by-other-archs.patch added to -mm tree
To: ard.biesheuvel@linaro.org,grant.likely@linaro.org,mingo@elte.hu
From: akpm@linux-foundation.org
Date: Wed, 27 Nov 2013 13:56:42 -0800


The patch titled
     Subject: firmware/dmi_scan: generalize for use by other archs
has been added to the -mm tree.  Its filename is
     firmware-dmi_scan-generalize-for-use-by-other-archs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/firmware-dmi_scan-generalize-for-use-by-other-archs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/firmware-dmi_scan-generalize-for-use-by-other-archs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: firmware/dmi_scan: generalize for use by other archs

This patch makes a couple of changes to the SMBIOS/DMI scanning
code so it can be used on other archs (such as ARM and arm64):
(a) wrap the calls to ioremap()/iounmap(), this allows the use of a
    flavor of ioremap() more suitable for random unaligned access;
(b) allow the non-EFI fallback probe into hardcoded physical address
    0xF0000 to be disabled.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Acked-by: Grant Likely <grant.likely@linaro.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/Kconfig           |    1 +
 arch/ia64/include/asm/dmi.h |    8 +++++---
 arch/x86/Kconfig            |    1 +
 arch/x86/include/asm/dmi.h  |    6 ++++--
 drivers/firmware/Kconfig    |    3 +++
 drivers/firmware/dmi_scan.c |   20 ++++++++++----------
 6 files changed, 24 insertions(+), 15 deletions(-)

diff -puN arch/ia64/Kconfig~firmware-dmi_scan-generalize-for-use-by-other-archs arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~firmware-dmi_scan-generalize-for-use-by-other-archs
+++ a/arch/ia64/Kconfig
@@ -104,6 +104,7 @@ config HAVE_SETUP_PER_CPU_AREA
 config DMI
 	bool
 	default y
+	select DMI_SCAN_MACHINE_NON_EFI_FALLBACK
 
 config EFI
 	bool
diff -puN arch/ia64/include/asm/dmi.h~firmware-dmi_scan-generalize-for-use-by-other-archs arch/ia64/include/asm/dmi.h
--- a/arch/ia64/include/asm/dmi.h~firmware-dmi_scan-generalize-for-use-by-other-archs
+++ a/arch/ia64/include/asm/dmi.h
@@ -5,8 +5,10 @@
 #include <asm/io.h>
 
 /* Use normal IO mappings for DMI */
-#define dmi_ioremap ioremap
-#define dmi_iounmap(x,l) iounmap(x)
-#define dmi_alloc(l) kzalloc(l, GFP_ATOMIC)
+#define dmi_early_remap		ioremap
+#define dmi_early_unmap(x, l)	iounmap(x)
+#define dmi_remap		ioremap
+#define dmi_unmap		iounmap
+#define dmi_alloc(l)		kzalloc(l, GFP_ATOMIC)
 
 #endif
diff -puN arch/x86/Kconfig~firmware-dmi_scan-generalize-for-use-by-other-archs arch/x86/Kconfig
--- a/arch/x86/Kconfig~firmware-dmi_scan-generalize-for-use-by-other-archs
+++ a/arch/x86/Kconfig
@@ -745,6 +745,7 @@ config APB_TIMER
 # The code disables itself when not needed.
 config DMI
 	default y
+	select DMI_SCAN_MACHINE_NON_EFI_FALLBACK
 	bool "Enable DMI scanning" if EXPERT
 	---help---
 	  Enabled scanning of DMI to identify machine quirks. Say Y
diff -puN arch/x86/include/asm/dmi.h~firmware-dmi_scan-generalize-for-use-by-other-archs arch/x86/include/asm/dmi.h
--- a/arch/x86/include/asm/dmi.h~firmware-dmi_scan-generalize-for-use-by-other-archs
+++ a/arch/x86/include/asm/dmi.h
@@ -13,7 +13,9 @@ static __always_inline __init void *dmi_
 }
 
 /* Use early IO mappings for DMI because it's initialized early */
-#define dmi_ioremap early_ioremap
-#define dmi_iounmap early_iounmap
+#define dmi_early_remap		early_ioremap
+#define dmi_early_unmap		early_iounmap
+#define dmi_remap		ioremap
+#define dmi_unmap		iounmap
 
 #endif /* _ASM_X86_DMI_H */
diff -puN drivers/firmware/Kconfig~firmware-dmi_scan-generalize-for-use-by-other-archs drivers/firmware/Kconfig
--- a/drivers/firmware/Kconfig~firmware-dmi_scan-generalize-for-use-by-other-archs
+++ a/drivers/firmware/Kconfig
@@ -108,6 +108,9 @@ config DMI_SYSFS
 	  under /sys/firmware/dmi when this option is enabled and
 	  loaded.
 
+config DMI_SCAN_MACHINE_NON_EFI_FALLBACK
+	bool
+
 config ISCSI_IBFT_FIND
 	bool "iSCSI Boot Firmware Table Attributes"
 	depends on X86
diff -puN drivers/firmware/dmi_scan.c~firmware-dmi_scan-generalize-for-use-by-other-archs drivers/firmware/dmi_scan.c
--- a/drivers/firmware/dmi_scan.c~firmware-dmi_scan-generalize-for-use-by-other-archs
+++ a/drivers/firmware/dmi_scan.c
@@ -116,7 +116,7 @@ static int __init dmi_walk_early(void (*
 {
 	u8 *buf;
 
-	buf = dmi_ioremap(dmi_base, dmi_len);
+	buf = dmi_early_remap(dmi_base, dmi_len);
 	if (buf == NULL)
 		return -1;
 
@@ -124,7 +124,7 @@ static int __init dmi_walk_early(void (*
 
 	add_device_randomness(buf, dmi_len);
 
-	dmi_iounmap(buf, dmi_len);
+	dmi_early_unmap(buf, dmi_len);
 	return 0;
 }
 
@@ -527,18 +527,18 @@ void __init dmi_scan_machine(void)
 		 * needed during early boot.  This also means we can
 		 * iounmap the space when we're done with it.
 		 */
-		p = dmi_ioremap(efi.smbios, 32);
+		p = dmi_early_remap(efi.smbios, 32);
 		if (p == NULL)
 			goto error;
 		memcpy_fromio(buf, p, 32);
-		dmi_iounmap(p, 32);
+		dmi_early_unmap(p, 32);
 
 		if (!dmi_present(buf)) {
 			dmi_available = 1;
 			goto out;
 		}
-	} else {
-		p = dmi_ioremap(0xF0000, 0x10000);
+	} else if (IS_ENABLED(CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK)) {
+		p = dmi_early_remap(0xF0000, 0x10000);
 		if (p == NULL)
 			goto error;
 
@@ -554,12 +554,12 @@ void __init dmi_scan_machine(void)
 			memcpy_fromio(buf + 16, q, 16);
 			if (!dmi_present(buf)) {
 				dmi_available = 1;
-				dmi_iounmap(p, 0x10000);
+				dmi_early_unmap(p, 0x10000);
 				goto out;
 			}
 			memcpy(buf, buf + 16, 16);
 		}
-		dmi_iounmap(p, 0x10000);
+		dmi_early_unmap(p, 0x10000);
 	}
  error:
 	pr_info("DMI not present or invalid.\n");
@@ -831,13 +831,13 @@ int dmi_walk(void (*decode)(const struct
 	if (!dmi_available)
 		return -1;
 
-	buf = ioremap(dmi_base, dmi_len);
+	buf = dmi_remap(dmi_base, dmi_len);
 	if (buf == NULL)
 		return -1;
 
 	dmi_table(buf, dmi_len, dmi_num, decode, private_data);
 
-	iounmap(buf);
+	dmi_unmap(buf);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(dmi_walk);
_

Patches currently in -mm which might be from ard.biesheuvel@linaro.org are

origin.patch
firmware-dmi_scan-generalize-for-use-by-other-archs.patch

