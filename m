From: akpm@linux-foundation.org
Subject: [folded] change-acquire-release_console_sem-to-console_lock-unlock-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 25 Jan 2011 14:59:42 -0800
Message-ID: <201101252259.p0PMxgXW013031@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60937 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752905Ab1AYXAA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Jan 2011 18:00:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gregkh@suse.de, mingo@elte.hu, tglx@tglx.de, torbenh@gmx.de, mm-commits@vger.kernel.org


The patch titled
     change-acquire-release_console_sem-to-console_lock-unlock-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     change-acquire-release_console_sem-to-console_lock-unlock-checkpatch-fixes.patch

This patch was dropped because it was folded into change-acquire-release_console_sem-to-console_lock-unlock.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: change-acquire-release_console_sem-to-console_lock-unlock-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#1175: FILE: drivers/video/arkfb.c:26:
+#include <linux/console.h> /* Why should fb driver call console functions? because console_lock() */

WARNING: line over 80 characters
#1992: FILE: drivers/video/s3fb.c:25:
+#include <linux/console.h> /* Why should fb driver call console functions? because console_lock() */

WARNING: line over 80 characters
#2259: FILE: drivers/video/vt8623fb.c:26:
+#include <linux/console.h> /* Why should fb driver call console functions? because console_lock() */

WARNING: line over 80 characters
#2386: FILE: kernel/printk.c:607:
+ * We try to grab the console_lock.  If we succeed, it's easy - we log the output and

WARNING: Statements terminations use 1 semicolon
#2440: FILE: kernel/printk.c:996:
+	console_lock();;

WARNING: Statements terminations use 1 semicolon
#2459: FILE: kernel/printk.c:1030:
+		console_lock();;

total: 0 errors, 6 warnings, 2244 lines checked

./patches/change-acquire-release_console_sem-to-console_lock-unlock.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Greg KH <gregkh@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@tglx.de>
Cc: Torben Hohn <torbenh@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/printk.c~change-acquire-release_console_sem-to-console_lock-unlock-checkpatch-fixes kernel/printk.c
--- a/kernel/printk.c~change-acquire-release_console_sem-to-console_lock-unlock-checkpatch-fixes
+++ a/kernel/printk.c
@@ -993,7 +993,7 @@ void suspend_console(void)
 	if (!console_suspend_enabled)
 		return;
 	printk("Suspending console(s) (use no_console_suspend to debug)\n");
-	console_lock();;
+	console_lock();
 	console_suspended = 1;
 	up(&console_sem);
 }
@@ -1027,7 +1027,7 @@ static int __cpuinit console_cpu_notify(
 	case CPU_DYING:
 	case CPU_DOWN_FAILED:
 	case CPU_UP_CANCELED:
-		console_lock();;
+		console_lock();
 		console_unlock();
 	}
 	return NOTIFY_OK;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-pgtable-genericc-fix-config_swap=n-build.patch
change-acquire-release_console_sem-to-console_lock-unlock.patch
change-acquire-release_console_sem-to-console_lock-unlock-fix-2.patch
memcg-fix-race-at-move_parent-around-compound_order-checkpatch-fixes.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-convert-bd2802-driver-to-dev_pm_ops-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
drbd-fix-warning.patch
mm.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
scatterlist-new-helper-functions.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

