From: akpm@linux-foundation.org
Subject: + blackfin-arch-fix-bug-bf561-rev-id-are-8-bit.patch added to -mm tree
Date: Thu, 29 Mar 2007 15:15:53 -0700
Message-ID: <200703292215.l2TMFuJ3013552@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41060 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422657AbXC2WQA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 18:16:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan.wu@analog.com


The patch titled
     blackfin arch fix bug bf561 rev ID are 8-bit
has been added to the -mm tree.  Its filename is
     blackfin-arch-fix-bug-bf561-rev-id-are-8-bit.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: blackfin arch fix bug bf561 rev ID are 8-bit
From: "Wu, Bryan" <bryan.wu@analog.com>

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/kernel/setup.c            |    3 +++
 include/asm-blackfin/mach-bf561/bf561.h |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff -puN arch/blackfin/kernel/setup.c~blackfin-arch-fix-bug-bf561-rev-id-are-8-bit arch/blackfin/kernel/setup.c
--- a/arch/blackfin/kernel/setup.c~blackfin-arch-fix-bug-bf561-rev-id-are-8-bit
+++ a/arch/blackfin/kernel/setup.c
@@ -117,6 +117,9 @@ static u_int get_dsp_rev_id(void)
 {
 	u_int id;
 	id = bfin_read_DSPID() & 0xffff;
+#if defined(CONFIG_BF561)
+	id>>=8;
+#endif
 	return id;
 }
 
diff -puN include/asm-blackfin/mach-bf561/bf561.h~blackfin-arch-fix-bug-bf561-rev-id-are-8-bit include/asm-blackfin/mach-bf561/bf561.h
--- a/include/asm-blackfin/mach-bf561/bf561.h~blackfin-arch-fix-bug-bf561-rev-id-are-8-bit
+++ a/include/asm-blackfin/mach-bf561/bf561.h
@@ -30,7 +30,7 @@
 #ifndef __MACH_BF561_H__
 #define __MACH_BF561_H__
 
-#define SUPPORTED_DSPID		0x300
+#define SUPPORTED_DSPID		0x3
 
 #define OFFSET_(x) ((x) & 0x0000FFFF)
 #define L1_ISRAM		0xFFA00000
_

Patches currently in -mm which might be from bryan.wu@analog.com are

blackfin-Documentation.patch
blackfin-arch.patch
blackfin-arch-balance-parenthesis-in-macros.patch
blackfin-arch-2.6.21-rc4-mm1-update.patch
blackfin-arch-fix-struct-dmasg-packing-bug.patch
blackfin-arch-cleanup-cache-header-file.patch
blackfin-arch-fix-reboot-kernel-mounting-spi-flash-print-error-bug.patch
blackfin-arch-fix-compiling-error-in-flat-c-file.patch
blackfin-arch-power-management-replace-firmware-disk-mode.patch
blackfin-arch-add-kdebug-header-file.patch
blackfin-arch-fix-bug-bf561-rev-id-are-8-bit.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
blackfin-on-chip-ethernet-mac-controller-driver.patch
blackfin-on-chip-ethernet-mac-controller-driver-update.patch
blackfin-patch-add-blackfin-support-in-smc91x.patch
blackfin-on-chip-rtc-controller-driver.patch
blackfin-on-chip-rtc-controller-driver-fix-rtc_update_irq-augument.patch
blackfin-blackfin-on-chip-spi-controller-driver.patch
blackfin-blackfin-on-chip-spi-controller-driver-cleanup-and-coding-style-fixing.patch
blackfin-blackfin-on-chip-spi-controller-driver-fix-reboot-kernel-mounting-spi-flash-print-error-bug.patch
blackfin-arch-fix-bug-prevent-warning-in-case-bf531-is-target.patch
blackfin-blackfin-utrace-patch.patch
utrace-nommu-fixup-support-utrace.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
revoke-core-code-generic_file_revoke-stub-for-nommu.patch
vdso-print-fatal-signals-fix-compiling-error-bug-in.patch
