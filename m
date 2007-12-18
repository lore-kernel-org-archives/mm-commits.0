From: akpm@linux-foundation.org
Subject: - initrd-fix-virtual-physical-mix-up-in-overwrite-test.patch removed from -mm tree
Date: Tue, 18 Dec 2007 03:01:39 -0800
Message-ID: <200712181101.lBIB1dB1031604@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48206 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752210AbXLRLCX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Dec 2007 06:02:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, benh@kernel.crashing.org, chris@zankel.net, galak@gate.crashing.org, grundler@parisc-linux.org, kyle@mcmartin.ca, nickpiggin@yahoo.com.au, paulus@samba.org, ralf


The patch titled
     initrd: fix virtual/physical mix-up in overwrite test
has been removed from the -mm tree.  Its filename was
     initrd-fix-virtual-physical-mix-up-in-overwrite-test.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: initrd: fix virtual/physical mix-up in overwrite test
From: Geert Uytterhoeven <geert@linux-m68k.org>

On recent kernels, I get the following error when using an initrd:

| initrd overwritten (0x00b78000 < 0x07668000) - disabling it.

My Amiga 4000 has 12 MiB of RAM at physical address 0x07400000 (virtual
0x00000000).
The initrd is located at the end of RAM: 0x00b78000 - 0x00c00000 (virtual).
The overwrite test compares the (virtual) initrd location to the (physical)
first available memory location, which fails.

This patch converts initrd_start to a page frame number, so it can be safely
compared with min_low_pfn.

Before the introduction of discontiguous memory support on m68k
(12d810c1b8c2b913d48e629e2b5c01d105029839), min_low_pfn was just left
untouched by the m68k-specific code (zero, I guess), and everything worked
fine.

On several platforms, initrd_below_start_ok is set to 1:

| arch/mips/kernel/setup.c:       initrd_below_start_ok = 1;
| arch/parisc/mm/init.c:                  initrd_below_start_ok = 1;
| arch/powerpc/kernel/prom.c:                     initrd_below_start_ok = 1;
| arch/ppc/platforms/hdpu.c:                      initrd_below_start_ok = 1;
| arch/xtensa/kernel/setup.c:             initrd_below_start_ok = 1;

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Christian Zankel <chris@zankel.net>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN init/main.c~initrd-fix-virtual-physical-mix-up-in-overwrite-test init/main.c
--- a/init/main.c~initrd-fix-virtual-physical-mix-up-in-overwrite-test
+++ a/init/main.c
@@ -598,9 +598,9 @@ asmlinkage void __init start_kernel(void
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	if (initrd_start && !initrd_below_start_ok &&
-			initrd_start < min_low_pfn << PAGE_SHIFT) {
+			virt_to_pfn(initrd_start) < min_low_pfn) {
 		printk(KERN_CRIT "initrd overwritten (0x%08lx < 0x%08lx) - "
-		    "disabling it.\n",initrd_start,min_low_pfn << PAGE_SHIFT);
+		    "disabling it.\n", virt_to_pfn(initrd_start), min_low_pfn);
 		initrd_start = 0;
 	}
 #endif
_

Patches currently in -mm which might be from geert@linux-m68k.org are

initrd-fix-virtual-physical-mix-up-in-overwrite-test.patch
sdio-fix-module-device-table-definition-for-m68k.patch
git-scsi-misc.patch
m68k-use-cc-cross-prefix.patch
m68k-array_size-cleanup.patch
dio-array_size-cleanup.patch
dio-array_size-cleanup-update.patch
dio-array_size-cleanup-update-checkpatch-fixes.patch
m68k-balance-ioremap-and-iounmap-in-m68k-atari-hades-pcic.patch
nubus-kill-drivers-nubus-nubus_symsc.patch
m68k-kill-arch-m68k-mac-mac_ksymsc.patch
m68k-kill-arch-m68k-hp300-ksymsc.patch
m68k-kill-arch-m68k-amiga-amiga_ksymsc.patch
m68k-kill-arch-m68k-atari-atari_ksymsc.patch
m68k-kill-arch-m68k-mvme16x-mvme16x_ksymsc.patch
mac68k-macii-adb-comment-correction.patch
mac68k-remove-dead-code.patch
mac68k-add-nubus-card-definitions-and-a-typo-fix.patch
mac68k-remove-dead-mac_adbkeycodes.patch
uml-borrow-consth-techniques.patch
remove-pointless-casts-from-void-pointers.patch
cleanup-after-apus-removal.patch
amiga-serial-driver-port_write_mutex-fixup.patch
add-cmpxchg_local-to-m86k.patch
