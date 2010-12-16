From: akpm@linux-foundation.org
Subject: + fix-lockup-detector-compile-fixes-from-removing-the-old-x86-nmi-watchdog.patch added to -mm tree
Date: Thu, 16 Dec 2010 14:31:15 -0800
Message-ID: <201012162304.oBGN4Ghj005822@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35758 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750855Ab0LPXEm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Dec 2010 18:04:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dzickus@redhat.com, gorcunov@gmail.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     fix "lockup detector: Compile fixes from removing the old x86 nmi watchdog"
has been added to the -mm tree.  Its filename is
     fix-lockup-detector-compile-fixes-from-removing-the-old-x86-nmi-watchdog.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix "lockup detector: Compile fixes from removing the old x86 nmi watchdog"
From: Andrew Morton <akpm@linux-foundation.org>

i386 allnoconfig:

arch/x86/kernel/apic/hw_nmi.c:29: error: redefinition of 'touch_nmi_watchdog'
include/linux/nmi.h:23: error: previous definition of 'touch_nmi_watchdog' was here

Please don't break bisection when fixing this :(

Cc: Don Zickus <dzickus@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nmi.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/kernel/apic/hw_nmi.c~fix-lockup-detector-compile-fixes-from-removing-the-old-x86-nmi-watchdog arch/x86/kernel/apic/hw_nmi.c
diff -puN include/linux/nmi.h~fix-lockup-detector-compile-fixes-from-removing-the-old-x86-nmi-watchdog include/linux/nmi.h
--- a/include/linux/nmi.h~fix-lockup-detector-compile-fixes-from-removing-the-old-x86-nmi-watchdog
+++ a/include/linux/nmi.h
@@ -18,7 +18,7 @@
 #include <asm/nmi.h>
 extern void touch_nmi_watchdog(void);
 #else
-#ifndef CONFIG_HARDLOCKUP_DETECTOR
+#ifdef CONFIG_HARDLOCKUP_DETECTOR
 static inline void touch_nmi_watchdog(void)
 {
 	touch_softlockup_watchdog();
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
fix-lockup-detector-compile-fixes-from-removing-the-old-x86-nmi-watchdog.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
delayacct-fix-iotop-on-x86_64-fix.patch
mm-vmap-area-cache.patch
arch-x86-kernel-apic-io_apicc-fix-warning.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
sync_inode_metadata-fix-comment.patch
fs-mpagec-consolidate-code-checkpatch-fixes.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path-fix.patch
mm-deactivate-invalidated-pages-fix.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix2.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit-fix.patch
fs-select-fix-information-leak-to-userspace-fix.patch
drivers-telephony-ixjc-fix-warning.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
sysctl-remove-obsolete-comments-fix.patch
user_ns-improve-the-user_ns-on-the-slab-packaging-fix.patch
pps-add-async-pps-event-handler-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

