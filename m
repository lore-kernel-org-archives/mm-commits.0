From: akpm@linux-foundation.org
Subject: + change-acquire-release_console_sem-to-console_lock-unlock-checkpatch-fixes.patch added to -mm tree
Date: Thu, 20 Jan 2011 12:38:21 -0800
Message-ID: <201101202038.p0KKcMPC000998@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50907 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753343Ab1ATUjL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Jan 2011 15:39:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, gregkh@suse.de, mingo@elte.hu, tglx@tglx.de, torbenh@gmx.de


The patch titled
     change-acquire-release_console_sem-to-console_lock-unlock-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     change-acquire-release_console_sem-to-console_lock-unlock-checkpatch-fixes.patch

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

change-acquire-release_console_sem-to-console_lock-unlock-checkpatch-fixes.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-compaction-prevent-division-by-zero-during-user-requested-compaction-fix.patch
fs-direct-ioc-dont-try-to-allocate-more-than-bio_max_pages-in-a-bio-fix.patch
memcg-fix-used-bit-handling-at-uncharge-in-thp-fix.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
sigma-firmware-loader-for-analog-devices-sigmastudio-fix.patch
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

