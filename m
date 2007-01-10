From: akpm@osdl.org
Subject: - get-rid-of-arch_have_xtime_lock.patch removed from -mm tree
Date: Wed, 10 Jan 2007 15:02:37 -0800
Message-ID: <200701102302.l0AN2bWX010753@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33197 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965161AbXAJXC7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jan 2007 18:02:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dada1@cosmosbay.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     get rid of ARCH_HAVE_XTIME_LOCK
has been removed from the -mm tree.  Its filename was
     get-rid-of-arch_have_xtime_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: get rid of ARCH_HAVE_XTIME_LOCK
From: Eric Dumazet <dada1@cosmosbay.com>

ARCH_HAVE_XTIME_LOCK is used by x86_64 arch .  This arch needs to place a
read only copy of xtime_lock into vsyscall page.  This read only copy is
named __xtime_lock, and xtime_lock is defined in
arch/x86_64/kernel/vmlinux.lds.S as an alias.  So the declaration of
xtime_lock in kernel/timer.c was guarded by ARCH_HAVE_XTIME_LOCK define,
defined to true on x86_64.

We can get same result with _attribute__((weak)) in the declaration. linker
should do the job.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-x86_64/vsyscall.h |    5 -----
 include/linux/time.h          |    2 +-
 kernel/timer.c                |    4 +---
 3 files changed, 2 insertions(+), 9 deletions(-)

diff -puN include/asm-x86_64/vsyscall.h~get-rid-of-arch_have_xtime_lock include/asm-x86_64/vsyscall.h
--- a/include/asm-x86_64/vsyscall.h~get-rid-of-arch_have_xtime_lock
+++ a/include/asm-x86_64/vsyscall.h
@@ -56,11 +56,6 @@ extern struct vxtime_data vxtime;
 extern int vgetcpu_mode;
 extern struct timezone sys_tz;
 extern int sysctl_vsyscall;
-extern seqlock_t xtime_lock;
-
-extern int sysctl_vsyscall;
-
-#define ARCH_HAVE_XTIME_LOCK 1
 
 #endif /* __KERNEL__ */
 
diff -puN include/linux/time.h~get-rid-of-arch_have_xtime_lock include/linux/time.h
--- a/include/linux/time.h~get-rid-of-arch_have_xtime_lock
+++ a/include/linux/time.h
@@ -90,7 +90,7 @@ static inline struct timespec timespec_s
 
 extern struct timespec xtime;
 extern struct timespec wall_to_monotonic;
-extern seqlock_t xtime_lock;
+extern seqlock_t xtime_lock __attribute__((weak));
 
 void timekeeping_init(void);
 
diff -puN kernel/timer.c~get-rid-of-arch_have_xtime_lock kernel/timer.c
--- a/kernel/timer.c~get-rid-of-arch_have_xtime_lock
+++ a/kernel/timer.c
@@ -1162,11 +1162,9 @@ static inline void calc_load(unsigned lo
  * This read-write spinlock protects us from races in SMP while
  * playing with xtime and avenrun.
  */
-#ifndef ARCH_HAVE_XTIME_LOCK
-__cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
+__attribute__((weak)) __cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
 
 EXPORT_SYMBOL(xtime_lock);
-#endif
 
 /*
  * This function runs timers and the timer-tq in bottom half context.
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

struct-vfsmount-keep-mnt_count-mnt_expiry_mark-away-from-mnt_flags.patch
avoid-one-conditional-branch-in-touch_atime.patch
