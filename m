From: akpm@linux-foundation.org
Subject: - blackfin-arch-fix-bug-bf561-rev-id-are-8-bit.patch removed from -mm tree
Date: Mon, 30 Apr 2007 12:10:12 -0700
Message-ID: <200704301910.l3UJACRO012401@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41303 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946662AbXD3TKQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 15:10:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bryan.wu@analog.com, mm-commits@vger.kernel.org


The patch titled
     blackfin arch fix bug bf561 rev ID are 8-bit
has been removed from the -mm tree.  Its filename was
     blackfin-arch-fix-bug-bf561-rev-id-are-8-bit.patch

This patch was dropped because it was folded into blackfin-arch.patch

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

origin.patch
blackfin-Documentation.patch
blackfin-arch.patch
blackfin-arch-fix-bug-bf561-rev-id-are-8-bit.patch
blackfin-arch-fix-bug-prevent-warning-in-case-bf531-is-target.patch
blackfin-arch-fix-stamp537-isp1716-irq-setting-bug.patch
blackfin-arch-fix-bug-interrupt-setup-problem-request_irq.patch
blackfin-arch-pnav-and-bluetechnix-cm-bf537-use-the-mac.patch
blackfin-arch-always-include-linux-kallsysms-header-file.patch
blackfin-arch-sync-with-uclibc-no-functional-changes.patch
blackfin-arch-using-asm-generic-pgtable-header-file-by.patch
blackfin-arch-add-missing-__clear_user-function-to.patch
blackfin-arch-use-boot_command_line-instead-of.patch
blackfin-arch-fix-some-coding-style-in-include.patch
blackfin-arch-add-scm_timestampns-and-siocgstampns-to.patch
blackfin-arch-add-missing-blackfin-support-in-lib.patch
blackfin-arch-fix-bug-data-cannot-be-put-into-l1-data.patch
blackfin-arch-source-kernel-preemption-option.patch
blackfin-arch-workaround-bf561-anomaly-05000266.patch
blackfin-arch-define-a-new-cacheline_aligned-attribute-to-put-it-in-l1-data-memory-with-linkscript-update.patch
blackfin-arch-fix-bug-asserting-gpio-requested-doesnt-make-sense-with-gpio-whole-port-accesses.patch
blackfin-arch-04-and-05-silicon-doesnt-exist-for-bf534-bf536-adn-bf537-so-dont-let-people-select-the-option.patch
blackfin-arch-fix-coding-style-in-ints-priority-sc-c-file.patch
blackfin-arch-fix-bug-refuse-to-boot-if-rootfs-image-is-not-attached-when-mtd_uclinux-is-selected.patch
blackfin-arch-move-revid-function-into-global-headers-as-inline-functions.patch
blackfin-arch-need-linux-ttyh-header-for-console_init-prototype.patch
blackfin-arch-convert-most-blackfin-specific-spi-register-settings-to-common-spi-framework-settings.patch
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
blackfin-spi-controller-driver-update-according-to-david-brownells-review.patch
blackfin-serial-core-driver-uart1-should-depend-on-bf534-bf536-bf537-remove-experimental-marking-from-on-chip-serial-core-driver-and-make-options-less-wordy.patch
move-die-notifier-handling-to-common-code-fix.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
revoke-core-code-generic_file_revoke-stub-for-nommu.patch
vdso-print-fatal-signals-fix-compiling-error-bug-in.patch
