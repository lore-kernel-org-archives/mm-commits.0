From: akpm@linux-foundation.org
Subject: + change-acquire-release_console_sem-to-console_lock-unlock-fix-2.patch added to -mm tree
Date: Fri, 21 Jan 2011 00:23:30 -0800
Message-ID: <201101210823.p0L8NURC030863@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48097 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752335Ab1AUIXt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Jan 2011 03:23:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, gregkh@suse.de, mingo@elte.hu, tglx@tglx.de, torbenh@gmx.de


The patch titled
     change-acquire-release_console_sem-to-console_lock-unlock-fix-2
has been added to the -mm tree.  Its filename is
     change-acquire-release_console_sem-to-console_lock-unlock-fix-2.patch

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
Subject: change-acquire-release_console_sem-to-console_lock-unlock-fix-2
From: Andrew Morton <akpm@linux-foundation.org>

make console_trylock return 1 on success, per Geert

Cc: Greg KH <gregkh@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@tglx.de>
Cc: Torben Hohn <torbenh@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/printk.c~change-acquire-release_console_sem-to-console_lock-unlock-fix-2 kernel/printk.c
--- a/kernel/printk.c~change-acquire-release_console_sem-to-console_lock-unlock-fix-2
+++ a/kernel/printk.c
@@ -1058,7 +1058,7 @@ EXPORT_SYMBOL(console_lock);
  * Tried to acquire a lock which guarantees that the caller has
  * exclusive access to the console system and the console_drivers list.
  *
- * returns -1 on success, and 0 on failure to acquire the lock.
+ * returns 1 on success, and 0 on failure to acquire the lock.
  */
 int console_trylock(void)
 {
@@ -1070,7 +1070,7 @@ int console_trylock(void)
 	}
 	console_locked = 1;
 	console_may_schedule = 0;
-	return -1;
+	return 1;
 }
 EXPORT_SYMBOL(console_trylock);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-compaction-prevent-division-by-zero-during-user-requested-compaction.patch
fs-direct-ioc-dont-try-to-allocate-more-than-bio_max_pages-in-a-bio.patch
memcg-fix-used-bit-handling-at-uncharge-in-thp.patch
linux-next.patch
linux-next-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
change-acquire-release_console_sem-to-console_lock-unlock-checkpatch-fixes.patch
change-acquire-release_console_sem-to-console_lock-unlock-fix-2.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-convert-bd2802-driver-to-dev_pm_ops-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
drivers-message-fusion-mptsasc-fix-warning.patch
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

