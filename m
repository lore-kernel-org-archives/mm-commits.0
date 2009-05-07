From: akpm@linux-foundation.org
Subject: [merged] x86-hookup-sys_rt_tgsigqueueinfo.patch removed from -mm tree
Date: Thu, 07 May 2009 12:16:56 -0700
Message-ID: <200905071916.n47JGu46020732@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53684 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754887AbZEGTWI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 May 2009 15:22:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, drepper@redhat.com, linux-abi@vger.kernel.org, linux-arch@vger.kernel.org, oleg@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     x86: hook up sys_rt_tgsigqueueinfo
has been removed from the -mm tree.  Its filename was
     x86-hookup-sys_rt_tgsigqueueinfo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: hook up sys_rt_tgsigqueueinfo
From: Thomas Gleixner <tglx@linutronix.de>

Make the new sys_rt_tgsigqueueinfo available for x86.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: <linux-abi@vger.kernel.org>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/ia32/ia32entry.S          |    1 +
 arch/x86/include/asm/unistd_32.h   |    1 +
 arch/x86/include/asm/unistd_64.h   |    2 ++
 arch/x86/kernel/syscall_table_32.S |    1 +
 4 files changed, 5 insertions(+)

diff -puN arch/x86/ia32/ia32entry.S~x86-hookup-sys_rt_tgsigqueueinfo arch/x86/ia32/ia32entry.S
--- a/arch/x86/ia32/ia32entry.S~x86-hookup-sys_rt_tgsigqueueinfo
+++ a/arch/x86/ia32/ia32entry.S
@@ -830,4 +830,5 @@ ia32_sys_call_table:
 	.quad sys_inotify_init1
 	.quad compat_sys_preadv
 	.quad compat_sys_pwritev
+	.quad compat_sys_rt_tgsigqueueinfo	/* 335 */
 ia32_syscall_end:
diff -puN arch/x86/include/asm/unistd_32.h~x86-hookup-sys_rt_tgsigqueueinfo arch/x86/include/asm/unistd_32.h
--- a/arch/x86/include/asm/unistd_32.h~x86-hookup-sys_rt_tgsigqueueinfo
+++ a/arch/x86/include/asm/unistd_32.h
@@ -340,6 +340,7 @@
 #define __NR_inotify_init1	332
 #define __NR_preadv		333
 #define __NR_pwritev		334
+#define __NR_rt_tgsigqueueinfo	335
 
 #ifdef __KERNEL__
 
diff -puN arch/x86/include/asm/unistd_64.h~x86-hookup-sys_rt_tgsigqueueinfo arch/x86/include/asm/unistd_64.h
--- a/arch/x86/include/asm/unistd_64.h~x86-hookup-sys_rt_tgsigqueueinfo
+++ a/arch/x86/include/asm/unistd_64.h
@@ -657,6 +657,8 @@ __SYSCALL(__NR_inotify_init1, sys_inotif
 __SYSCALL(__NR_preadv, sys_preadv)
 #define __NR_pwritev				296
 __SYSCALL(__NR_pwritev, sys_pwritev)
+#define __NR_rt_tgsigqueueinfo			297
+__SYSCALL(__NR_rt_tgsigqueueinfo, sys_rt_tgsigqueueinfo)
 
 
 #ifndef __NO_STUBS
diff -puN arch/x86/kernel/syscall_table_32.S~x86-hookup-sys_rt_tgsigqueueinfo arch/x86/kernel/syscall_table_32.S
--- a/arch/x86/kernel/syscall_table_32.S~x86-hookup-sys_rt_tgsigqueueinfo
+++ a/arch/x86/kernel/syscall_table_32.S
@@ -334,3 +334,4 @@ ENTRY(sys_call_table)
 	.long sys_inotify_init1
 	.long sys_preadv
 	.long sys_pwritev
+	.long sys_rt_tgsigqueueinfo	/* 335 */
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
linux-next.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
x86-simplify-highmem-related-kconfig-entries.patch
x86-enable-gart-iommu-only-after-setting-up-protection-methods.patch
avr32-remove-obsolete-hw_interrupt_type.patch
time-move-calc_load-call-out-from-xtime_lock-protection.patch
clocksource-sanity-check-sysfs-clocksource-changes.patch
ia64-remove-obsolete-no_irq_type.patch
ia64-remove-obsolete-irq_desc_t-typedef.patch
ia64-remove-obsolete-hw_interrupt_type.patch
drivers-mfd-remove-obsolete-irq_desc_t-typedef.patch
parisc-remove-obsolete-hw_interrupt_type.patch
alpha-remove-obsolete-hw_interrupt_type.patch
m32r-remove-obsolete-hw_interrupt_type.patch
um-remove-obsolete-hw_interrupt_type.patch
kmap_types-make-most-arches-use-generic-header-file.patch
remove-put_cpu_no_resched.patch
remove-put_cpu_no_resched-fix.patch
irqs-add-irqf_sample_random-to-the-feature-removal-scheduletxt-deprecated-list.patch

