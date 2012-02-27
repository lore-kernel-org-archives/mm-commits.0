From: akpm@linux-foundation.org
Subject: [merged] x86-use-generic-posix_typesh.patch removed from -mm tree
Date: Mon, 27 Feb 2012 14:30:01 -0800
Message-ID: <20120227223001.E4074A02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:60300 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755492Ab2B0WaF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Feb 2012 17:30:05 -0500
Received: by laai8 with SMTP id i8so57087laa.1
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2012 14:30:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: use generic posix_types.h
has been removed from the -mm tree.  Its filename was
     x86-use-generic-posix_typesh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "H. Peter Anvin" <hpa@zytor.com>
Subject: x86: use generic posix_types.h

Change the x86 architecture to use <asm-generic/posix_types.h>.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/posix_types_32.h |   75 ++--------------
 arch/x86/include/asm/posix_types_64.h |  106 ------------------------
 2 files changed, 12 insertions(+), 169 deletions(-)

diff -puN arch/x86/include/asm/posix_types_32.h~x86-use-generic-posix_typesh arch/x86/include/asm/posix_types_32.h
--- a/arch/x86/include/asm/posix_types_32.h~x86-use-generic-posix_typesh
+++ a/arch/x86/include/asm/posix_types_32.h
@@ -7,79 +7,22 @@
  * assume GCC is being used.
  */
 
-typedef unsigned long	__kernel_ino_t;
 typedef unsigned short	__kernel_mode_t;
+#define __kernel_mode_t __kernel_mode_t
+
 typedef unsigned short	__kernel_nlink_t;
-typedef long		__kernel_off_t;
-typedef int		__kernel_pid_t;
+#define __kernel_nlink_t __kernel_nlink_t
+
 typedef unsigned short	__kernel_ipc_pid_t;
+#define __kernel_ipc_pid_t __kernel_ipc_pid_t
+
 typedef unsigned short	__kernel_uid_t;
 typedef unsigned short	__kernel_gid_t;
-typedef unsigned int	__kernel_size_t;
-typedef int		__kernel_ssize_t;
-typedef int		__kernel_ptrdiff_t;
-typedef long		__kernel_time_t;
-typedef long		__kernel_suseconds_t;
-typedef long		__kernel_clock_t;
-typedef int		__kernel_timer_t;
-typedef int		__kernel_clockid_t;
-typedef int		__kernel_daddr_t;
-typedef char *		__kernel_caddr_t;
-typedef unsigned short	__kernel_uid16_t;
-typedef unsigned short	__kernel_gid16_t;
-typedef unsigned int	__kernel_uid32_t;
-typedef unsigned int	__kernel_gid32_t;
+#define __kernel_uid_t __kernel_uid_t
 
-typedef unsigned short	__kernel_old_uid_t;
-typedef unsigned short	__kernel_old_gid_t;
 typedef unsigned short	__kernel_old_dev_t;
+#define __kernel_old_dev_t __kernel_old_dev_t
 
-#ifdef __GNUC__
-typedef long long	__kernel_loff_t;
-#endif
-
-typedef struct {
-	int	val[2];
-} __kernel_fsid_t;
-
-#if defined(__KERNEL__)
-
-#undef	__FD_SET
-#define __FD_SET(fd,fdsetp)					\
-	asm volatile("btsl %1,%0":				\
-		     "+m" (*(__kernel_fd_set *)(fdsetp))	\
-		     : "r" ((int)(fd)))
-
-#undef	__FD_CLR
-#define __FD_CLR(fd,fdsetp)					\
-	asm volatile("btrl %1,%0":				\
-		     "+m" (*(__kernel_fd_set *)(fdsetp))	\
-		     : "r" ((int) (fd)))
-
-#undef	__FD_ISSET
-#define __FD_ISSET(fd,fdsetp)					\
-	(__extension__						\
-	 ({							\
-	 unsigned char __result;				\
-	 asm volatile("btl %1,%2 ; setb %0"			\
-		      : "=q" (__result)				\
-		      : "r" ((int)(fd)),			\
-			"m" (*(__kernel_fd_set *)(fdsetp)));	\
-	 __result;						\
-}))
-
-#undef	__FD_ZERO
-#define __FD_ZERO(fdsetp)					\
-do {								\
-	int __d0, __d1;						\
-	asm volatile("cld ; rep ; stosl"			\
-		     : "=m" (*(__kernel_fd_set *)(fdsetp)),	\
-		       "=&c" (__d0), "=&D" (__d1)		\
-		     : "a" (0), "1" (__FDSET_LONGS),		\
-		       "2" ((__kernel_fd_set *)(fdsetp))	\
-		     : "memory");				\
-} while (0)
-
-#endif /* defined(__KERNEL__) */
+#include <asm-generic/posix_types.h>
 
 #endif /* _ASM_X86_POSIX_TYPES_32_H */
diff -puN arch/x86/include/asm/posix_types_64.h~x86-use-generic-posix_typesh arch/x86/include/asm/posix_types_64.h
--- a/arch/x86/include/asm/posix_types_64.h~x86-use-generic-posix_typesh
+++ a/arch/x86/include/asm/posix_types_64.h
@@ -7,113 +7,13 @@
  * assume GCC is being used.
  */
 
-typedef unsigned long	__kernel_ino_t;
-typedef unsigned int	__kernel_mode_t;
-typedef unsigned long	__kernel_nlink_t;
-typedef long		__kernel_off_t;
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
-typedef unsigned short	__kernel_uid16_t;
-typedef unsigned short	__kernel_gid16_t;
-
-#ifdef __GNUC__
-typedef long long	__kernel_loff_t;
-#endif
-
-typedef struct {
-	int	val[2];
-} __kernel_fsid_t;
-
 typedef unsigned short __kernel_old_uid_t;
 typedef unsigned short __kernel_old_gid_t;
-typedef __kernel_uid_t __kernel_uid32_t;
-typedef __kernel_gid_t __kernel_gid32_t;
+#define __kernel_old_uid_t __kernel_old_uid_t
 
 typedef unsigned long	__kernel_old_dev_t;
+#define __kernel_old_dev_t __kernel_old_dev_t
 
-#ifdef __KERNEL__
-
-#undef __FD_SET
-static inline void __FD_SET(unsigned long fd, __kernel_fd_set *fdsetp)
-{
-	unsigned long _tmp = fd / __NFDBITS;
-	unsigned long _rem = fd % __NFDBITS;
-	fdsetp->fds_bits[_tmp] |= (1UL<<_rem);
-}
-
-#undef __FD_CLR
-static inline void __FD_CLR(unsigned long fd, __kernel_fd_set *fdsetp)
-{
-	unsigned long _tmp = fd / __NFDBITS;
-	unsigned long _rem = fd % __NFDBITS;
-	fdsetp->fds_bits[_tmp] &= ~(1UL<<_rem);
-}
-
-#undef __FD_ISSET
-static inline int __FD_ISSET(unsigned long fd, __const__ __kernel_fd_set *p)
-{
-	unsigned long _tmp = fd / __NFDBITS;
-	unsigned long _rem = fd % __NFDBITS;
-	return (p->fds_bits[_tmp] & (1UL<<_rem)) != 0;
-}
-
-/*
- * This will unroll the loop for the normal constant cases (8 or 32 longs,
- * for 256 and 1024-bit fd_sets respectively)
- */
-#undef __FD_ZERO
-static inline void __FD_ZERO(__kernel_fd_set *p)
-{
-	unsigned long *tmp = p->fds_bits;
-	int i;
-
-	if (__builtin_constant_p(__FDSET_LONGS)) {
-		switch (__FDSET_LONGS) {
-		case 32:
-			tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
-			tmp[ 4] = 0; tmp[ 5] = 0; tmp[ 6] = 0; tmp[ 7] = 0;
-			tmp[ 8] = 0; tmp[ 9] = 0; tmp[10] = 0; tmp[11] = 0;
-			tmp[12] = 0; tmp[13] = 0; tmp[14] = 0; tmp[15] = 0;
-			tmp[16] = 0; tmp[17] = 0; tmp[18] = 0; tmp[19] = 0;
-			tmp[20] = 0; tmp[21] = 0; tmp[22] = 0; tmp[23] = 0;
-			tmp[24] = 0; tmp[25] = 0; tmp[26] = 0; tmp[27] = 0;
-			tmp[28] = 0; tmp[29] = 0; tmp[30] = 0; tmp[31] = 0;
-			return;
-		case 16:
-			tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
-			tmp[ 4] = 0; tmp[ 5] = 0; tmp[ 6] = 0; tmp[ 7] = 0;
-			tmp[ 8] = 0; tmp[ 9] = 0; tmp[10] = 0; tmp[11] = 0;
-			tmp[12] = 0; tmp[13] = 0; tmp[14] = 0; tmp[15] = 0;
-			return;
-		case 8:
-			tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
-			tmp[ 4] = 0; tmp[ 5] = 0; tmp[ 6] = 0; tmp[ 7] = 0;
-			return;
-		case 4:
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
-
-#endif /* defined(__KERNEL__) */
+#include <asm-generic/posix_types.h>
 
 #endif /* _ASM_X86_POSIX_TYPES_64_H */
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

