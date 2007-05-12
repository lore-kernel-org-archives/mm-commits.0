From: akpm@linux-foundation.org
Subject: - x86_64-mm-new-syscall.patch removed from -mm tree
Date: Fri, 11 May 2007 22:32:42 -0700
Message-ID: <200705120532.l4C5Wg1r002057@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56799 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756739AbXELFcs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:32:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86_64: new syscall
has been removed from the -mm tree.  Its filename was
     x86_64-mm-new-syscall.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: new syscall
From: Andi Kleen <ak@suse.de>

Add epoll_pwait()

(akpm: stolen from Andi's queue, because I want to send the signalfd patches
which also add syscalls.  Not sure what the __IGNORE_getcpu is for).

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86_64/unistd.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN include/asm-x86_64/unistd.h~x86_64-mm-new-syscall include/asm-x86_64/unistd.h
--- a/include/asm-x86_64/unistd.h~x86_64-mm-new-syscall
+++ a/include/asm-x86_64/unistd.h
@@ -621,6 +621,9 @@ __SYSCALL(__NR_vmsplice, sys_vmsplice)
 __SYSCALL(__NR_move_pages, sys_move_pages)
 #define __NR_utimensat		280
 __SYSCALL(__NR_utimensat, sys_utimensat)
+#define __IGNORE_getcpu		/* implemented as a vsyscall */
+#define __NR_epoll_pwait	281
+__SYSCALL(__NR_epoll_pwait, sys_epoll_pwait)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
_

Patches currently in -mm which might be from ak@suse.de are

origin.patch
fault-injection-disable-stacktrace-filter-for-x86-64.patch
x86_64-use-signalfd-and-timerfd-compat-syscalls.patch
remove-pci_dac_dma_-apis.patch
git-pciseg.patch
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
quicklist-support-for-x86_64.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
x86_64-fix-e820_hole_size-based-on-address-ranges.patch
x86_64-acpi-disable-srat-when-numa-emulation-succeeds.patch
x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa-2.patch
x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
i386-hpet-check-if-the-counter-works.patch
x86-use-elfnoteh-to-generate-vsyscall-notes.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-fix.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-update.patch
i386-pci-fixup-for-siemens-nixdorf-ag-fsc-multiprocessor-interrupt-controllers.patch
i386-efi-fix-proc-iomem-type-for-kexec-tools.patch
x86_64-o_excl-on-dev-mcelog.patch
x86_64-support-poll-on-dev-mcelog.patch
i386-x86-64-fix-section-mismatch.patch
change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-v6-zonelist-fix.patch
change-zonelist-order-auto-configuration.patch
change-zonelist-order-documentaion.patch
split-usermodehelper-setup-from-execution.patch
add-common-orderly_poweroff.patch
tidy-up-usermode-helper-waiting-a-bit.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-guest-code.patch
lguest-the-host-code.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-console-driver.patch
lguest-the-net-driver.patch
lguest-the-block-driver.patch
lguest-the-documentation-example-launcher.patch
clockevents-fix-resume-logic-updated-version.patch
