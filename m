From: akpm@linux-foundation.org
Subject: + futex-fix-init-order.patch added to -mm tree
Date: Thu, 14 Feb 2008 17:49:06 -0800
Message-ID: <200802150149.m1F1n63q013903@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57339 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761501AbYBOBts (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 20:49:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, buytenh@wantstofly.org, mingo@elte.hu, riku.voipio@movial.fi, stable@kernel.org


The patch titled
     futex: fix init order
has been added to the -mm tree.  Its filename is
     futex-fix-init-order.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: futex: fix init order
From: Thomas Gleixner <tglx@linutronix.de>

When the futex init code fails to initialize the futex pseudo file system it
returns early without initializing the hash queues.  Should the boot succeed
then a futex syscall which tries to enqueue a waiter on the hashqueue will
crash due to the unitilialized plist heads.

Initialize the hash queues before the filesystem.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Riku Voipio <riku.voipio@movial.fi>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/futex.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN kernel/futex.c~futex-fix-init-order kernel/futex.c
--- a/kernel/futex.c~futex-fix-init-order
+++ a/kernel/futex.c
@@ -2145,8 +2145,14 @@ static struct file_system_type futex_fs_
 
 static int __init init(void)
 {
-	int i = register_filesystem(&futex_fs_type);
+	int i;
 
+	for (i = 0; i < ARRAY_SIZE(futex_queues); i++) {
+		plist_head_init(&futex_queues[i].chain, &futex_queues[i].lock);
+		spin_lock_init(&futex_queues[i].lock);
+	}
+
+	i = register_filesystem(&futex_fs_type);
 	if (i)
 		return i;
 
@@ -2156,10 +2162,6 @@ static int __init init(void)
 		return PTR_ERR(futex_mnt);
 	}
 
-	for (i = 0; i < ARRAY_SIZE(futex_queues); i++) {
-		plist_head_init(&futex_queues[i].chain, &futex_queues[i].lock);
-		spin_lock_init(&futex_queues[i].lock);
-	}
 	return 0;
 }
 __initcall(init);
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
hrtimer-fix-abs-clock-realtimepatch.patch
git-kvm.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
pci-disable-decoding-during-sizing-of-bars.patch
execute-tasklets-in-the-same-order-they-were-queued.patch
git-x86.patch
git-x86-cpa-build-fix.patch
x86-amd-thermal-interrupt-support.patch
x86-remove-pt_regs-arg-from-smp_thermal_interrupt.patch
x86-visws-fix-printk-format-warnings.patch
x86-minor-cleanup-of-comments-in-processorh.patch
documentation-i386-io-apictxt-fix-description.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used.patch
rtc-cmos-display-hpet-emulation-mode.patch
x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486.patch
xtime_lock-vs-update_process_times.patch
dmi-prevent-linked-list-corruption-resent.patch
x86-fix-clearcopy_user_page-declarations-in-pageh.patch
futex-fix-init-order.patch
futex-runtime-enable-pi-and-robust-functionality.patch
futex-disable-pi-robust-on-archs-w-o-valid-implementation.patch
x86-configurable-dmi-scanning-code.patch
asm-futexh-should-include-linux-uaccessh.patch
