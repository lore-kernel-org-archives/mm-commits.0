From: akpm@linux-foundation.org
Subject: + include-linux-kernelh-roundup-work-around-a-gcc-33-miscompile.patch added to -mm tree
Date: Mon, 08 Nov 2010 16:13:52 -0800
Message-ID: <201011090013.oA90DqcO018071@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56753 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753014Ab0KIAOh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Nov 2010 19:14:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, eparis@redhat.com, jmorris@namei.org, penguin-kernel@I-love.SAKURA.ne.jp, randy.dunlap@oracle.com


The patch titled
     include/linux/kernel.h:roundup(): work around a gcc-3.3 miscompile
has been added to the -mm tree.  Its filename is
     include-linux-kernelh-roundup-work-around-a-gcc-33-miscompile.patch

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
Subject: include/linux/kernel.h:roundup(): work around a gcc-3.3 miscompile
From: Andrew Morton <akpm@linux-foundation.org>

gcc-3.3.5 (at least) is failing to optimise away the divide when `y' is a
constant 64-bit power-of-two value - it emits a call to __divdi3().

It turns out that defining `y' as const prevents this.

Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Tested-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN include/linux/kernel.h~include-linux-kernelh-roundup-work-around-a-gcc-33-miscompile include/linux/kernel.h
--- a/include/linux/kernel.h~include-linux-kernelh-roundup-work-around-a-gcc-33-miscompile
+++ a/include/linux/kernel.h
@@ -58,9 +58,11 @@ extern const char linux_proc_banner[];
 
 #define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
 #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
+
+/* The `const' in roundup() prevents gcc-3.3 from calling __divdi3 */
 #define roundup(x, y) (					\
 {							\
-	typeof(y) __y = y;				\
+	const typeof(y) __y = y;			\
 	(((x) + (__y - 1)) / __y) * __y;		\
 }							\
 )
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

hpet-factor-timer-allocate-from-open.patch
atomic-add-atomic_inc_not_zero_hint-checkpatch-fixes.patch
include-linux-kernelh-roundup-work-around-a-gcc-33-miscompile.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
arch-x86-kernel-entry_64s-fix-build-with-gas-2161.patch
arch-x86-kernel-entry_32s-i386-too.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-misc-isl29020c-dont-ignore-the-i2c_smbus_read_byte_data-return-value.patch
drivers-misc-bh1770glcc-error-handling-in-bh1770_power_state_store.patch
mm-vmap-area-cache.patch
arch-x86-kernel-apic-io_apicc-fix-warning.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-add-led-trigger-for-input-subsystem-led-events.patch
backlight-add-low-threshold-to-pwm-backlight.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch
sync_inode_metadata-fix-comment.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch
pps-add-async-pps-event-handler-fix.patch
memstick-add-driver-for-ricoh-r5c592-card-reader-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

