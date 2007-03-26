From: akpm@linux-foundation.org
Subject: + vdso-print-fatal-signals-fix-compiling-error-bug-in.patch added to -mm tree
Date: Mon, 26 Mar 2007 14:05:10 -0700
Message-ID: <200703262105.l2QL5DFV030410@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51862 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178AbXCZVFQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Mar 2007 17:05:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan.wu@analog.com


The patch titled
     vdso print fatal signals: fix compiling error bug in nommu arch
has been added to the -mm tree.  Its filename is
     vdso-print-fatal-signals-fix-compiling-error-bug-in.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: vdso print fatal signals: fix compiling error bug in nommu arch
From: "Wu, Bryan" <bryan.wu@analog.com>

As struct mm_struct vm_mm is hidden in struct vm_area_struct in NOMMU
arch, this is a fixing method when compiling failure on blackfin arch.

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    4 ++++
 1 files changed, 4 insertions(+)

diff -puN kernel/signal.c~vdso-print-fatal-signals-fix-compiling-error-bug-in kernel/signal.c
--- a/kernel/signal.c~vdso-print-fatal-signals-fix-compiling-error-bug-in
+++ a/kernel/signal.c
@@ -807,7 +807,11 @@ static void pad_len_spaces(int len)
 
 static int print_vma(struct vm_area_struct *vma)
 {
+#ifdef CONFIG_MMU
 	struct mm_struct *mm = vma->vm_mm;
+#else
+	struct mm_struct *mm = 0;
+#endif
 	struct file *file = vma->vm_file;
 	int flags = vma->vm_flags;
 	unsigned long ino = 0;
_

Patches currently in -mm which might be from bryan.wu@analog.com are

blackfin-Documentation.patch
blackfin-arch.patch
blackfin-arch-balance-parenthesis-in-macros.patch
blackfin-arch-2.6.21-rc4-mm1-update.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
blackfin-on-chip-ethernet-mac-controller-driver.patch
blackfin-on-chip-ethernet-mac-controller-driver-update.patch
blackfin-patch-add-blackfin-support-in-smc91x.patch
blackfin-on-chip-rtc-controller-driver.patch
blackfin-blackfin-on-chip-spi-controller-driver.patch
blackfin-arch-fix-struct-dmasg-packing-bug.patch
blackfin-arch-cleanup-cache-header-file.patch
blackfin-arch-fix-reboot-kernel-mounting-spi-flash.patch
blackfin-arch-fix-compiling-error-in-flat-c-file.patch
blackfin-arch-power-management-replace-firmware-disk.patch
blackfin-arch-add-kdebug-header-file.patch
blackfin-rtc-fix-rtc_update_irq-augument.patch
blackfin-spi-driver-cleanup-and-coding-style-fixing.patch
blackfin-spi-driver-fix-reboot-kernel-mounting-spi.patch
blackfin-blackfin-utrace-patch.patch
utrace-nommu-fixup-support-utrace.patch
vdso-print-fatal-signals-fix-compiling-error-bug-in.patch
