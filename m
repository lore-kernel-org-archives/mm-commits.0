From: akpm@linux-foundation.org
Subject: + move-die-notifier-handling-to-common-code-fix.patch added to -mm tree
Date: Fri, 06 Apr 2007 14:23:04 -0700
Message-ID: <200704062123.l36LN4n9019285@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34637 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933058AbXDFVXS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 17:23:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan.wu@analog.com, ak@suse.de, hch@lst.de


The patch titled
     move die notifier handling to common code fix vmalloc_sync_all in nommu
has been added to the -mm tree.  Its filename is
     move-die-notifier-handling-to-common-code-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: move die notifier handling to common code fix vmalloc_sync_all in nommu
From: "Wu, Bryan" <bryan.wu@analog.com>

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    8 ++++++++
 1 files changed, 8 insertions(+)

diff -puN mm/nommu.c~move-die-notifier-handling-to-common-code-fix mm/nommu.c
--- a/mm/nommu.c~move-die-notifier-handling-to-common-code-fix
+++ a/mm/nommu.c
@@ -261,6 +261,14 @@ void vunmap(void *addr)
 }
 
 /*
+ * Implement a stub for vmalloc_sync_all() if the architecture chose not to
+ * have one.
+ */
+void  __attribute__((weak)) vmalloc_sync_all(void)
+{
+}
+
+/*
  *  sys_brk() for the most part doesn't need the global kernel
  *  lock, except when an application is doing something nasty
  *  like trying to un-brk an area that has already been mapped
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
blackfin-arch-fix-bug-prevent-warning-in-case-bf531-is-target.patch
blackfin-arch-fix-stamp537-isp1716-irq-setting-bug.patch
blackfin-arch-fix-bug-interrupt-setup-problem-request_irq.patch
blackfin-arch-pnav-and-bluetechnix-cm-bf537-use-the-mac.patch
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
move-die-notifier-handling-to-common-code-fix.patch
blackfin-blackfin-utrace-patch.patch
utrace-nommu-fixup-support-utrace.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
revoke-core-code-generic_file_revoke-stub-for-nommu.patch
vdso-print-fatal-signals-fix-compiling-error-bug-in.patch
blackfin-arch-always-include-linux-kallsysms-header-file.patch
blackfin-arch-sync-with-uclibc-no-functional-changes.patch
blackfin-arch-using-asm-generic-pgtable-header-file-by.patch
blackfin-arch-add-missing-__clear_user-function-to.patch
blackfin-arch-use-boot_command_line-instead-of.patch
usb-gadget-rndis-fix-struct-rndis_packet_msg_type.patch
blackfin-arch-fix-some-coding-style-in-include.patch
blackfin-arch-add-scm_timestampns-and-siocgstampns-to.patch
