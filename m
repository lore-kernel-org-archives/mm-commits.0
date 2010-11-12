From: akpm@linux-foundation.org
Subject: + fs-select-fix-information-leak-to-userspace-fix.patch added to -mm tree
Date: Fri, 12 Nov 2010 12:09:14 -0800
Message-ID: <201011122009.oACK9EhP029173@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52590 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932761Ab0KLUJp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Nov 2010 15:09:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, segooon@gmail.com, viro@zeniv.linux.org.uk


The patch titled
     fs-select-fix-information-leak-to-userspace-fix
has been added to the -mm tree.  Its filename is
     fs-select-fix-information-leak-to-userspace-fix.patch

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
Subject: fs-select-fix-information-leak-to-userspace-fix
From: Andrew Morton <akpm@linux-foundation.org>

avoid the memset on architectures which don't need it

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Vasiliy Kulikov <segooon@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/select.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/select.c~fs-select-fix-information-leak-to-userspace-fix fs/select.c
--- a/fs/select.c~fs-select-fix-information-leak-to-userspace-fix
+++ a/fs/select.c
@@ -306,7 +306,8 @@ static int poll_select_copy_remaining(st
 		rts.tv_sec = rts.tv_nsec = 0;
 
 	if (timeval) {
-		memset(&rtv, 0, sizeof(rtv));
+		if (sizeof(rtv) > sizeof(rtv.tv_sec) + sizeof(rtv.tv_usec))
+			memset(&rtv, 0, sizeof(rtv));
 		rtv.tv_sec = rts.tv_sec;
 		rtv.tv_usec = rts.tv_nsec / NSEC_PER_USEC;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
atomic-add-atomic_inc_not_zero_hint.patch
restrict-unprivileged-access-to-kernel-syslog.patch
backlight-add-low-threshold-to-pwm-backlight.patch
hpet-factor-timer-allocate-from-open.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-vmap-area-cache.patch
arch-x86-kernel-entry_32s-work-around-gas-2161-glitch.patch
arch-x86-kernel-entry_64s-fix-build-with-gas-2161.patch
arch-x86-kernel-entry_32s-i386-too.patch
arch-x86-include-asm-fixmaph-mark-__set_fixmap_offset-as-__always_inline.patch
arch-x86-kernel-apic-io_apicc-fix-warning.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
irq-use-per_cpu-kstat_irqs-checkpatch-fixes.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
sync_inode_metadata-fix-comment.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
lib-add-generic-exponentially-weighted-moving-average-ewma-function-fix.patch
fs-select-fix-information-leak-to-userspace-fix.patch
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

