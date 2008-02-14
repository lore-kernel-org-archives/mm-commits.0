From: akpm@linux-foundation.org
Subject: + futex-disable-pi-robust-on-archs-w-o-valid-implementation.patch added to -mm tree
Date: Thu, 14 Feb 2008 13:46:51 -0800
Message-ID: <200802142146.m1ELkplS004497@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52912 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760191AbYBNVri (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 16:47:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, buytenh@wantstofly.org, mingo@elte.hu, riku.voipio@movial.fi, stable@kernel.org


The patch titled
     futex: disable PI/robust on archs w/o valid implementation
has been added to the -mm tree.  Its filename is
     futex-disable-pi-robust-on-archs-w-o-valid-implementation.patch

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
Subject: futex: disable PI/robust on archs w/o valid implementation
From: Thomas Gleixner <tglx@linutronix.de>

We have to disable the complete PI/robust functionality for those archs, which
do not implement futex_atomic_cmpxchg_inatomic().  The code in question relies
on a valid implementation and does not expect -ENOSYS, which is returned by
the stub implementation in asm-generic/futex.h

Pointed out by: Mikael Pettersson, Riku Voipio and Adrian Bunk

This patch is intended for easy backporting and needs to be cleaned up further
for current mainline.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Lennert Buytenhek <buytenh@wantstofly.org>
Tested-by: Riku Voipio <riku.voipio@movial.fi>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/futex.h |    2 ++
 kernel/futex.c              |   13 +++++++++++++
 2 files changed, 15 insertions(+)

diff -puN include/asm-generic/futex.h~futex-disable-pi-robust-on-archs-w-o-valid-implementation include/asm-generic/futex.h
--- a/include/asm-generic/futex.h~futex-disable-pi-robust-on-archs-w-o-valid-implementation
+++ a/include/asm-generic/futex.h
@@ -55,5 +55,7 @@ futex_atomic_cmpxchg_inatomic(int __user
 	return -ENOSYS;
 }
 
+#define FUTEX_ATOMIC_CMPXCHG_NOT_IMPLEMENTED
+
 #endif
 #endif
diff -puN kernel/futex.c~futex-disable-pi-robust-on-archs-w-o-valid-implementation kernel/futex.c
--- a/kernel/futex.c~futex-disable-pi-robust-on-archs-w-o-valid-implementation
+++ a/kernel/futex.c
@@ -1870,6 +1870,9 @@ asmlinkage long
 sys_set_robust_list(struct robust_list_head __user *head,
 		    size_t len)
 {
+#ifdef FUTEX_ATOMIC_CMPXCHG_NOT_IMPLEMENTED
+	return -ENOSYS;
+#else
 	/*
 	 * The kernel knows only one size for now:
 	 */
@@ -1879,6 +1882,7 @@ sys_set_robust_list(struct robust_list_h
 	current->robust_list = head;
 
 	return 0;
+#endif
 }
 
 /**
@@ -1891,6 +1895,9 @@ asmlinkage long
 sys_get_robust_list(int pid, struct robust_list_head __user * __user *head_ptr,
 		    size_t __user *len_ptr)
 {
+#ifdef FUTEX_ATOMIC_CMPXCHG_NOT_IMPLEMENTED
+	return -ENOSYS;
+#else
 	struct robust_list_head __user *head;
 	unsigned long ret;
 
@@ -1920,6 +1927,7 @@ err_unlock:
 	rcu_read_unlock();
 
 	return ret;
+#endif
 }
 
 /*
@@ -2082,6 +2090,9 @@ long do_futex(u32 __user *uaddr, int op,
 	case FUTEX_WAKE_OP:
 		ret = futex_wake_op(uaddr, fshared, uaddr2, val, val2, val3);
 		break;
+
+#ifndef FUTEX_ATOMIC_CMPXCHG_NOT_IMPLEMENTED
+
 	case FUTEX_LOCK_PI:
 		ret = futex_lock_pi(uaddr, fshared, val, timeout, 0);
 		break;
@@ -2091,6 +2102,8 @@ long do_futex(u32 __user *uaddr, int op,
 	case FUTEX_TRYLOCK_PI:
 		ret = futex_lock_pi(uaddr, fshared, 0, timeout, 1);
 		break;
+#endif
+
 	default:
 		ret = -ENOSYS;
 	}
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
futex-disable-pi-robust-on-archs-w-o-valid-implementation.patch
x86-configurable-dmi-scanning-code.patch
asm-futexh-should-include-linux-uaccessh.patch
