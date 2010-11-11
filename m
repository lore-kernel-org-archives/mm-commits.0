From: akpm@linux-foundation.org
Subject: + restrict-unprivileged-access-to-kernel-syslog-fix.patch added to -mm tree
Date: Wed, 10 Nov 2010 16:13:55 -0800
Message-ID: <201011110013.oAB0DtZ1014293@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33896 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932110Ab0KKAOW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Nov 2010 19:14:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, drosenberg@vsecurity.com, eugeneteo@kernel.org, kees.cook@canonical.com, mingo@elte.hu, torvalds@linux-foundation.org


The patch titled
     restrict-unprivileged-access-to-kernel-syslog-checkpatch-fixes-fix
has been added to the -mm tree.  Its filename is
     restrict-unprivileged-access-to-kernel-syslog-fix.patch

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
Subject: restrict-unprivileged-access-to-kernel-syslog-checkpatch-fixes-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: Eugene Teo <eugeneteo@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Kees Cook <kees.cook@canonical.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/kernel.txt |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN Documentation/sysctl/kernel.txt~restrict-unprivileged-access-to-kernel-syslog-fix Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~restrict-unprivileged-access-to-kernel-syslog-fix
+++ a/Documentation/sysctl/kernel.txt
@@ -216,11 +216,14 @@ to decide what to do with it.
 
 dmesg_restrict:
 
-This toggle indicates whether unprivileged users are prevented
-from using dmesg(8) to view messages from the kernel's log
-buffer.  By default, it is set to (0), resulting in no
-restrictions.  When set to (1), users must have CAP_SYS_ADMIN
-to use dmesg(8).
+This toggle indicates whether unprivileged users are prevented from using
+dmesg(8) to view messages from the kernel's log buffer.  When
+dmesg_restrict is set to (0) there are no restrictions.  When
+dmesg_restrict is set set to (1), users must have CAP_SYS_ADMIN to use
+dmesg(8).
+
+The kernel config option CONFIG_SECURITY_DMESG_RESTRICT sets the default
+value of dmesg_restrict.
 
 ==============================================================
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
hpet-factor-timer-allocate-from-open.patch
atomic-add-atomic_inc_not_zero_hint-checkpatch-fixes.patch
linux-next.patch
next-remove-localversion.patch
arch-x86-kernel-entry_64s-fix-build-with-gas-2161.patch
arch-x86-kernel-entry_32s-i386-too.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-misc-bh1770glcc-error-handling-in-bh1770_power_state_store.patch
restrict-unprivileged-access-to-kernel-syslog-fix.patch
mm-vmap-area-cache.patch
arch-x86-kernel-apic-io_apicc-fix-warning.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
irq-use-per_cpu-kstat_irqs-checkpatch-fixes.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-add-led-trigger-for-input-subsystem-led-events.patch
backlight-add-low-threshold-to-pwm-backlight.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
sync_inode_metadata-fix-comment.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
memcg-make-throttle_vm_writeout-memcg-aware-fix.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch
pps-add-async-pps-event-handler-fix.patch
memstick-add-driver-for-ricoh-r5c592-card-reader-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

