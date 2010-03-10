From: akpm@linux-foundation.org
Subject: [folded] add-generic-sys_ipc-wrapper-fix.patch removed from -mm tree
Date: Wed, 10 Mar 2010 14:49:28 -0800
Message-ID: <201003102249.o2AMnSd0008490@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36834 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757394Ab0CJW47 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Mar 2010 17:56:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, benh@kernel.crashing.org, hch@lst.de, heiko.carstens@de.ibm.com, hpa@zytor.com, jdike@addtoit.com, jmorris@namei.org, lethal@linux-sh.org, mi


The patch titled
     add-generic-sys_ipc-wrapper-fix
has been removed from the -mm tree.  Its filename was
     add-generic-sys_ipc-wrapper-fix.patch

This patch was dropped because it was folded into add-generic-sys_ipc-wrapper.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: add-generic-sys_ipc-wrapper-fix
From: Andrew Morton <akpm@linux-foundation.org>

i386 allnoconfig:

arch/x86/built-in.o: In function `sys_call_table':
: undefined reference to `sys_ipc'

Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Schwab <schwab@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: James Morris <jmorris@namei.org>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys_ni.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/sys_ni.c~add-generic-sys_ipc-wrapper-fix kernel/sys_ni.c
--- a/kernel/sys_ni.c~add-generic-sys_ipc-wrapper-fix
+++ a/kernel/sys_ni.c
@@ -126,6 +126,7 @@ cond_syscall(sys_setreuid16);
 cond_syscall(sys_setuid16);
 cond_syscall(sys_vm86old);
 cond_syscall(sys_vm86);
+cond_syscall(sys_ipc);
 cond_syscall(compat_sys_ipc);
 cond_syscall(compat_sys_sysctl);
 cond_syscall(sys_flock);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

add-generic-sys_ipc-wrapper.patch
add-generic-sys_ipc-wrapper-fix.patch
broadsheetfb-support-storing-waveform-fix.patch
drivers-char-memc-cleanups.patch
drivers-char-memc-cleanups-fix.patch
drivers-char-memc-cleanups-fix-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-move-charges-of-anonymous-swap-fix-3-fix.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
mn10300-remove-the-obsolete-and-unnecessary-dma-api-comments-fix.patch
documentation-convert-pci-dma-mappingtxt-to-use-the-generic-dma-api-fix.patch
pps-linuxpps-clients-support-v3-checkpatch-fixes.patch
pps-serial-clients-support-warning-fixes.patch
sysctl-extern-cleanup-binfmts-fix.patch
sysctl-extern-cleanup-module-fix.patch
linux-next.patch
linux-next-fixups.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-i2c-busses-i2c-xiicc-is-borked.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
led-driver-for-the-soekris-net5501-board-checkpatch-fixes.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
3x59x-fix-pci-resource-management.patch
kernel-schedc-suppress-unused-var-warning.patch
usb-serial-ftdi-add-contec-vendor-and-product-id-fix.patch
drivers-char-tty_bufferc-fix-min-warnings.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
add-a-new-vt-mode-which-is-like-vt_process-but-doesnt-require-a-vt_reldisp-ioctl-call-checkpatch-fixes.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
bitops-remove-temporary-for_each_bit.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch

