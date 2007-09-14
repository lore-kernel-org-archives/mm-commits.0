From: akpm@linux-foundation.org
Subject: + alpha-lock-bitops-fix.patch added to -mm tree
Date: Thu, 13 Sep 2007 17:51:02 -0700
Message-ID: <200709140051.l8E0p2Et014088@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37313 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752864AbXINAwL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Sep 2007 20:52:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, ink@jurassic.park.msu.ru, npiggin@suse.de, rth@twiddle.net


The patch titled
     alpha bitops.h must #include <asm/barrier.h>
has been added to the -mm tree.  Its filename is
     alpha-lock-bitops-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: alpha bitops.h must #include <asm/barrier.h>
From: Adrian Bunk <bunk@kernel.org>

In file included from /home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/include/linux/bitops.h:17,
                 from /home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/include/linux/kernel.h:15,
                 from /home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/include/linux/sched.h:50,
                 from /home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/arch/alpha/kernel/asm-offsets.c:9:
include2/asm/bitops.h: In function 'clear_bit_unlock':
include2/asm/bitops.h:75: error: implicit declaration of function 'smp_mb'
make[2]: *** [arch/alpha/kernel/asm-offsets.s] Error 1

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/bitops.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/asm-alpha/bitops.h~alpha-lock-bitops-fix include/asm-alpha/bitops.h
--- a/include/asm-alpha/bitops.h~alpha-lock-bitops-fix
+++ a/include/asm-alpha/bitops.h
@@ -6,6 +6,7 @@
 #endif
 
 #include <asm/compiler.h>
+#include <asm/barrier.h>
 
 /*
  * Copyright 1994, Linus Torvalds.
_

Patches currently in -mm which might be from bunk@kernel.org are

fix-serial_core_console-driver-dependencies.patch
git-alsa.patch
arm-extern-inline-static-inline.patch
omap1-leds-innovatorc-remove-dead-code.patch
ppc-remove-apus-support.patch
git-dvb.patch
git-kbuild.patch
pass-g-to-assembler-under-config_debug_info-fix.patch
fix-ide-ide-hook-acpi-psx-method-to-ide-power-on-off.patch
fix-ide-ide-remove-ide-dma-check.patch
drivers-mtd-mtdbdic-is-no-longer-an-own-module.patch
git-nfsd.patch
drivers-scsi-immc-fix-check-after-use.patch
git-wireless.patch
fix-x86_64-mm-unwinder.patch
i386-visws-extern-inline-static-inline.patch
file-capabilities-clear-fcaps-on-inode-change-fix.patch
security-cleanups.patch
make-kernel-power-maincsuspend_enter-static.patch
uml-fix-inlines.patch
kconfig-syntax-cleanups.patch
kernel-time-timekeepingc-cleanups.patch
make-fs-libfscsimple_commit_write-static.patch
allow-disabling-dnotify-without-embedded.patch
use-erestart_restartblock-if-poll-is-interrupted-by-a-signal-fix.patch
remove-include-asm-ipch.patch
n_hdlcc-fix-check-after-use.patch
kernel-sys_nic-add-dummy-sys_ni_syscall-prototype.patch
make-kernel-profilectime_hook-static.patch
drivers-block-ccissc-fix-check-after-use.patch
remove-fs-ext2-balloccreserve_blocks.patch
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
bitmaph-remove-dead-artifacts.patch
sysctl-parport-remove-binary-paths-fix.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
remove-asm-bitopsh-includes.patch
forbid-asm-bitopsh-direct-inclusion.patch
alpha-lock-bitops-fix.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
remove-asm-bitopsh-includes-reiser4.patch
