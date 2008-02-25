From: akpm@linux-foundation.org
Subject: - futex-runtime-enable-pi-and-robust-functionality.patch removed from -mm tree
Date: Sun, 24 Feb 2008 16:45:24 -0800
Message-ID: <200802250045.m1P0jO4P006258@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:33355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754293AbYBYAtK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 24 Feb 2008 19:49:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, buytenh@wantstofly.org, mingo@elte.hu, riku.voipio@movial.fi, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     futex: runtime enable pi and robust functionality
has been removed from the -mm tree.  Its filename was
     futex-runtime-enable-pi-and-robust-functionality.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: futex: runtime enable pi and robust functionality
From: Thomas Gleixner <tglx@linutronix.de>

Not all architectures implement futex_atomic_cmpxchg_inatomic().  The default
implementation returns -ENOSYS, which is currently not handled inside of the
futex guts.

Futex PI calls and robust list exits with a held futex result in an endless
loop in the futex code on architectures which have no support.

Fixing up every place where futex_atomic_cmpxchg_inatomic() is called would
add a fair amount of extra if/else constructs to the already complex code.  It
is also not possible to disable the robust feature before user space tries to
register robust lists.

Compile time disabling is not a good idea either, as there are already
architectures with runtime detection of futex_atomic_cmpxchg_inatomic support.

Detect the functionality at runtime instead by calling
cmpxchg_futex_value_locked() with a NULL pointer from the futex initialization
code.  This is guaranteed to fail, but the call of
futex_atomic_cmpxchg_inatomic() happens with pagefaults disabled.

On architectures, which use the asm-generic implementation or have a runtime
CPU feature detection, a -ENOSYS return value disables the PI/robust features.

On architectures with a working implementation the call returns -EFAULT and
the PI/robust features are enabled.

The relevant syscalls return -ENOSYS and the robust list exit code is blocked,
when the detection fails.

Fixes http://lkml.org/lkml/2008/2/11/149
Originally reported by: Lennart Buytenhek

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Riku Voipio <riku.voipio@movial.fi>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/futex.h |    1 +
 kernel/futex.c        |   38 ++++++++++++++++++++++++++++++++++----
 kernel/futex_compat.c |    9 +++++++++
 3 files changed, 44 insertions(+), 4 deletions(-)

diff -puN include/linux/futex.h~futex-runtime-enable-pi-and-robust-functionality include/linux/futex.h
--- a/include/linux/futex.h~futex-runtime-enable-pi-and-robust-functionality
+++ a/include/linux/futex.h
@@ -167,6 +167,7 @@ union futex_key {
 #ifdef CONFIG_FUTEX
 extern void exit_robust_list(struct task_struct *curr);
 extern void exit_pi_state_list(struct task_struct *curr);
+extern int futex_cmpxchg_enabled;
 #else
 static inline void exit_robust_list(struct task_struct *curr)
 {
diff -puN kernel/futex.c~futex-runtime-enable-pi-and-robust-functionality kernel/futex.c
--- a/kernel/futex.c~futex-runtime-enable-pi-and-robust-functionality
+++ a/kernel/futex.c
@@ -60,6 +60,8 @@
 
 #include "rtmutex_common.h"
 
+int __read_mostly futex_cmpxchg_enabled;
+
 #define FUTEX_HASHBITS (CONFIG_BASE_SMALL ? 4 : 8)
 
 /*
@@ -469,6 +471,8 @@ void exit_pi_state_list(struct task_stru
 	struct futex_hash_bucket *hb;
 	union futex_key key;
 
+	if (!futex_cmpxchg_enabled)
+		return;
 	/*
 	 * We are a ZOMBIE and nobody can enqueue itself on
 	 * pi_state_list anymore, but we have to be careful
@@ -1870,6 +1874,8 @@ asmlinkage long
 sys_set_robust_list(struct robust_list_head __user *head,
 		    size_t len)
 {
+	if (!futex_cmpxchg_enabled)
+		return -ENOSYS;
 	/*
 	 * The kernel knows only one size for now:
 	 */
@@ -1894,6 +1900,9 @@ sys_get_robust_list(int pid, struct robu
 	struct robust_list_head __user *head;
 	unsigned long ret;
 
+	if (!futex_cmpxchg_enabled)
+		return -ENOSYS;
+
 	if (!pid)
 		head = current->robust_list;
 	else {
@@ -1997,6 +2006,9 @@ void exit_robust_list(struct task_struct
 	unsigned long futex_offset;
 	int rc;
 
+	if (!futex_cmpxchg_enabled)
+		return;
+
 	/*
 	 * Fetch the list head (which was registered earlier, via
 	 * sys_set_robust_list()):
@@ -2051,7 +2063,7 @@ void exit_robust_list(struct task_struct
 long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 		u32 __user *uaddr2, u32 val2, u32 val3)
 {
-	int ret;
+	int ret = -ENOSYS;
 	int cmd = op & FUTEX_CMD_MASK;
 	struct rw_semaphore *fshared = NULL;
 
@@ -2083,13 +2095,16 @@ long do_futex(u32 __user *uaddr, int op,
 		ret = futex_wake_op(uaddr, fshared, uaddr2, val, val2, val3);
 		break;
 	case FUTEX_LOCK_PI:
-		ret = futex_lock_pi(uaddr, fshared, val, timeout, 0);
+		if (futex_cmpxchg_enabled)
+			ret = futex_lock_pi(uaddr, fshared, val, timeout, 0);
 		break;
 	case FUTEX_UNLOCK_PI:
-		ret = futex_unlock_pi(uaddr, fshared);
+		if (futex_cmpxchg_enabled)
+			ret = futex_unlock_pi(uaddr, fshared);
 		break;
 	case FUTEX_TRYLOCK_PI:
-		ret = futex_lock_pi(uaddr, fshared, 0, timeout, 1);
+		if (futex_cmpxchg_enabled)
+			ret = futex_lock_pi(uaddr, fshared, 0, timeout, 1);
 		break;
 	default:
 		ret = -ENOSYS;
@@ -2145,8 +2160,23 @@ static struct file_system_type futex_fs_
 
 static int __init init(void)
 {
+	u32 curval;
 	int i;
 
+	/*
+	 * This will fail and we want it. Some arch implementations do
+	 * runtime detection of the futex_atomic_cmpxchg_inatomic()
+	 * functionality. We want to know that before we call in any
+	 * of the complex code paths. Also we want to prevent
+	 * registration of robust lists in that case. NULL is
+	 * guaranteed to fault and we get -EFAULT on functional
+	 * implementation, the non functional ones will return
+	 * -ENOSYS.
+	 */
+	curval = cmpxchg_futex_value_locked(NULL, 0, 0);
+	if (curval == -EFAULT)
+		futex_cmpxchg_enabled = 1;
+
 	for (i = 0; i < ARRAY_SIZE(futex_queues); i++) {
 		plist_head_init(&futex_queues[i].chain, &futex_queues[i].lock);
 		spin_lock_init(&futex_queues[i].lock);
diff -puN kernel/futex_compat.c~futex-runtime-enable-pi-and-robust-functionality kernel/futex_compat.c
--- a/kernel/futex_compat.c~futex-runtime-enable-pi-and-robust-functionality
+++ a/kernel/futex_compat.c
@@ -54,6 +54,9 @@ void compat_exit_robust_list(struct task
 	compat_long_t futex_offset;
 	int rc;
 
+	if (!futex_cmpxchg_enabled)
+		return;
+
 	/*
 	 * Fetch the list head (which was registered earlier, via
 	 * sys_set_robust_list()):
@@ -115,6 +118,9 @@ asmlinkage long
 compat_sys_set_robust_list(struct compat_robust_list_head __user *head,
 			   compat_size_t len)
 {
+	if (!futex_cmpxchg_enabled)
+		return -ENOSYS;
+
 	if (unlikely(len != sizeof(*head)))
 		return -EINVAL;
 
@@ -130,6 +136,9 @@ compat_sys_get_robust_list(int pid, comp
 	struct compat_robust_list_head __user *head;
 	unsigned long ret;
 
+	if (!futex_cmpxchg_enabled)
+		return -ENOSYS;
+
 	if (!pid)
 		head = current->compat_robust_list;
 	else {
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
