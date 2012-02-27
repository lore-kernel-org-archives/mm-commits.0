From: akpm@linux-foundation.org
Subject: [merged] ia64-use-generic-posix_typesh.patch removed from -mm tree
Date: Mon, 27 Feb 2012 14:29:39 -0800
Message-ID: <20120227222939.780F6A02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:60147 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755476Ab2B0W3l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2012 17:29:41 -0500
Received: by mail-we0-f202.google.com with SMTP id x9so41106wej.1
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2012 14:29:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hpa@zytor.com, fenghua.yu@intel.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: use generic posix_types.h
has been removed from the -mm tree.  Its filename was
     ia64-use-generic-posix_typesh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "H. Peter Anvin" <hpa@zytor.com>
Subject: ia64: use generic posix_types.h

Change the ia64 architecture to use <asm-generic/posix_types.h>.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/posix_types.h |  121 --------------------------
 1 file changed, 3 insertions(+), 118 deletions(-)

diff -puN arch/ia64/include/asm/posix_types.h~ia64-use-generic-posix_typesh arch/ia64/include/asm/posix_types.h
--- a/arch/ia64/include/asm/posix_types.h~ia64-use-generic-posix_typesh
+++ a/arch/ia64/include/asm/posix_types.h
@@ -1,126 +1,11 @@
 #ifndef _ASM_IA64_POSIX_TYPES_H
 #define _ASM_IA64_POSIX_TYPES_H
 
-/*
- * This file is generally used by user-level software, so you need to
- * be a little careful about namespace pollution etc.  Also, we cannot
- * assume GCC is being used.
- *
- * Based on <asm-alpha/posix_types.h>.
- *
- * Modified 1998-2000, 2003
- *	David Mosberger-Tang <davidm@hpl.hp.com>, Hewlett-Packard Co
- */
-
-typedef unsigned long	__kernel_ino_t;
-typedef unsigned int	__kernel_mode_t;
 typedef unsigned int	__kernel_nlink_t;
-typedef long		__kernel_off_t;
-typedef long long	__kernel_loff_t;
-typedef int		__kernel_pid_t;
-typedef int		__kernel_ipc_pid_t;
-typedef unsigned int	__kernel_uid_t;
-typedef unsigned int	__kernel_gid_t;
-typedef unsigned long	__kernel_size_t;
-typedef long		__kernel_ssize_t;
-typedef long		__kernel_ptrdiff_t;
-typedef long		__kernel_time_t;
-typedef long		__kernel_suseconds_t;
-typedef long		__kernel_clock_t;
-typedef int		__kernel_timer_t;
-typedef int		__kernel_clockid_t;
-typedef int		__kernel_daddr_t;
-typedef char *		__kernel_caddr_t;
-typedef unsigned long	__kernel_sigset_t;	/* at least 32 bits */
-typedef unsigned short	__kernel_uid16_t;
-typedef unsigned short	__kernel_gid16_t;
-
-typedef struct {
-	int	val[2];
-} __kernel_fsid_t;
-
-typedef __kernel_uid_t __kernel_old_uid_t;
-typedef __kernel_gid_t __kernel_old_gid_t;
-typedef __kernel_uid_t __kernel_uid32_t;
-typedef __kernel_gid_t __kernel_gid32_t;
-
-typedef unsigned int	__kernel_old_dev_t;
-
-# ifdef __KERNEL__
-
-#  ifndef __GNUC__
-
-#define	__FD_SET(d, set)	((set)->fds_bits[__FDELT(d)] |= __FDMASK(d))
-#define	__FD_CLR(d, set)	((set)->fds_bits[__FDELT(d)] &= ~__FDMASK(d))
-#define	__FD_ISSET(d, set)	(((set)->fds_bits[__FDELT(d)] & __FDMASK(d)) != 0)
-#define	__FD_ZERO(set)	\
-  ((void) memset ((void *) (set), 0, sizeof (__kernel_fd_set)))
+#define __kernel_nlink_t __kernel_nlink_t
 
-#  else /* !__GNUC__ */
-
-/* With GNU C, use inline functions instead so args are evaluated only once: */
-
-#undef __FD_SET
-static __inline__ void __FD_SET(unsigned long fd, __kernel_fd_set *fdsetp)
-{
-	unsigned long _tmp = fd / __NFDBITS;
-	unsigned long _rem = fd % __NFDBITS;
-	fdsetp->fds_bits[_tmp] |= (1UL<<_rem);
-}
-
-#undef __FD_CLR
-static __inline__ void __FD_CLR(unsigned long fd, __kernel_fd_set *fdsetp)
-{
-	unsigned long _tmp = fd / __NFDBITS;
-	unsigned long _rem = fd % __NFDBITS;
-	fdsetp->fds_bits[_tmp] &= ~(1UL<<_rem);
-}
-
-#undef __FD_ISSET
-static __inline__ int __FD_ISSET(unsigned long fd, const __kernel_fd_set *p)
-{ 
-	unsigned long _tmp = fd / __NFDBITS;
-	unsigned long _rem = fd % __NFDBITS;
-	return (p->fds_bits[_tmp] & (1UL<<_rem)) != 0;
-}
-
-/*
- * This will unroll the loop for the normal constant case (8 ints,
- * for a 256-bit fd_set)
- */
-#undef __FD_ZERO
-static __inline__ void __FD_ZERO(__kernel_fd_set *p)
-{
-	unsigned long *tmp = p->fds_bits;
-	int i;
-
-	if (__builtin_constant_p(__FDSET_LONGS)) {
-		switch (__FDSET_LONGS) {
-		      case 16:
-			tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
-			tmp[ 4] = 0; tmp[ 5] = 0; tmp[ 6] = 0; tmp[ 7] = 0;
-			tmp[ 8] = 0; tmp[ 9] = 0; tmp[10] = 0; tmp[11] = 0;
-			tmp[12] = 0; tmp[13] = 0; tmp[14] = 0; tmp[15] = 0;
-			return;
-
-		      case 8:
-			tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
-			tmp[ 4] = 0; tmp[ 5] = 0; tmp[ 6] = 0; tmp[ 7] = 0;
-			return;
+typedef unsigned long	__kernel_sigset_t;	/* at least 32 bits */
 
-		      case 4:
-			tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
-			return;
-		}
-	}
-	i = __FDSET_LONGS;
-	while (i) {
-		i--;
-		*tmp = 0;
-		tmp++;
-	}
-}
+#include <asm-generic/posix_types.h>
 
-#  endif /* !__GNUC__ */
-# endif /* __KERNEL__ */
 #endif /* _ASM_IA64_POSIX_TYPES_H */
_

Patches currently in -mm which might be from hpa@zytor.com are

origin.patch
linux-next.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
platform-x86-kill-off-moorestown.patch
intel_scu_ipc-remove-moorestown-support.patch
platform-x86-intel_mid_thermal-add-msic_thermal-alias.patch
platform-x86-intel_mid_thermal-convert-to-use-intel-msic-api.patch
platform-x86-intel_mid_thermal-turn-off-thermistor-voltage-by-default.patch
intel_mid_powerbtn-use-msic-read-write-instead-of-ipc_scu.patch
intel_mid_powerbtn-mark-irq-as-irqf_no_suspend.patch
x86-olpc-add-debugfs-interface-for-ec-commands.patch
x86-mm-fix-the-size-calculation-of-mapping-tables.patch
alix2-supplement-driver-to-include-gpio-button-support.patch
net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
x86-change-percpu_read_stable-to-this_cpu_read_stable.patch
x86-change-percpu_read_stable-to-this_cpu_read_stable-fix.patch
hugetlbfs-fix-hugetlb_get_unmapped_area.patch
hugetlb-drop-prev_vma-in-hugetlb_get_unmapped_area_topdown.patch
hugetlb-try-to-search-again-if-it-is-really-needed.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
mm-do-not-reset-cached_hole_size-when-vma-is-unmapped.patch
mm-search-from-free_area_cache-for-the-bigger-size.patch
percpu-remove-percpu_xxx-functions.patch
smp-start-up-non-boot-cpus-asynchronously.patch
smp-start-up-non-boot-cpus-asynchronously-fix.patch
bitops-rename-for_each_set_bit_cont-in-favor-of-analogous-listh-function.patch
bitops-remove-for_each_set_bit_cont.patch
bitops-introduce-for_each_clear_bit.patch
x86-use-for_each_clear_bit_from.patch
ipc-provide-generic-compat-versions-of-ipc-syscalls.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch

