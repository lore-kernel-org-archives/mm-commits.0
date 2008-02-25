From: akpm@linux-foundation.org
Subject: - futex-fix-init-order.patch removed from -mm tree
Date: Sun, 24 Feb 2008 16:45:21 -0800
Message-ID: <200802250045.m1P0jLl2006255@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53643 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754646AbYBYAtP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 24 Feb 2008 19:49:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, buytenh@wantstofly.org, mingo@elte.hu, riku.voipio@movial.fi, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     futex: fix init order
has been removed from the -mm tree.  Its filename was
     futex-fix-init-order.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-hrt.patch
git-kvm.patch
execute-tasklets-in-the-same-order-they-were-queued.patch
git-x86.patch
documentation-i386-io-apictxt-fix-description.patch
add-the-dff-desktop-form-factor-dell-optiplex-745-to-the-reboot-errata-list.patch
x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486.patch
x86-fix-clearcopy_user_page-declarations-in-pageh.patch
x86-visws-fix-printk-format-warnings.patch
fix-typo-in-tick-broadcastc.patch
x86-configurable-dmi-scanning-code.patch
kprobes-introduce-kprobe_handle_fault.patch
kprobes-remove-preempt_enable-disable-from-kprobe_handle_fault.patch
fix-shadowed-variables-in-kernel-posix-cpu-timersc.patch
timers-simplify-lockdep-stuff.patch
hrtimers-simplify-lockdep-stuff.patch
kill-double_spin_lock.patch
ntp-make-the-kernel-ntp-code-hand-64-bit-unsigned-values-to-do_div.patch
asm-futexh-should-include-linux-uaccessh.patch
init-move-setup-of-nr_cpu_ids-to-as-early-as-possible-v3.patch
generic-percpu-infrastructure-to-rebase-the-per-cpu-area-to-zero-v3.patch
x86_64-fold-pda-into-per-cpu-area-v3.patch
x86_64-cleanup-non-smp-usage-of-cpu-maps-v3.patch
