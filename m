From: akpm@linux-foundation.org
Subject: [merged] parisc-use-generic-posix_typesh.patch removed from -mm tree
Date: Mon, 27 Feb 2012 14:29:49 -0800
Message-ID: <20120227222949.6CFC7A02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:56395 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536Ab2B0W3u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2012 17:29:50 -0500
Received: by yenq2 with SMTP id q2so136480yen.1
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2012 14:29:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hpa@zytor.com, deller@gmx.de, jejb@parisc-linux.org, kyle@mcmartin.ca, mm-commits@vger.kernel.org


The patch titled
     Subject: parisc: use generic posix_types.h
has been removed from the -mm tree.  Its filename was
     parisc-use-generic-posix_typesh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "H. Peter Anvin" <hpa@zytor.com>
Subject: parisc: use generic posix_types.h

Change the parisc architecture to use <asm-generic/posix_types.h>.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: James Bottomley <jejb@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/include/asm/posix_types.h |  119 +-----------------------
 1 file changed, 9 insertions(+), 110 deletions(-)

diff -puN arch/parisc/include/asm/posix_types.h~parisc-use-generic-posix_typesh arch/parisc/include/asm/posix_types.h
--- a/arch/parisc/include/asm/posix_types.h~parisc-use-generic-posix_typesh
+++ a/arch/parisc/include/asm/posix_types.h
@@ -6,123 +6,22 @@
  * be a little careful about namespace pollution etc.  Also, we cannot
  * assume GCC is being used.
  */
-typedef unsigned long		__kernel_ino_t;
+
 typedef unsigned short		__kernel_mode_t;
+#define __kernel_mode_t __kernel_mode_t
+
 typedef unsigned short		__kernel_nlink_t;
-typedef long			__kernel_off_t;
-typedef int			__kernel_pid_t;
+#define __kernel_nlink_t __kernel_nlink_t
+
 typedef unsigned short		__kernel_ipc_pid_t;
-typedef unsigned int		__kernel_uid_t;
-typedef unsigned int		__kernel_gid_t;
-typedef int			__kernel_suseconds_t;
-typedef long			__kernel_clock_t;
-typedef int			__kernel_timer_t;
-typedef int			__kernel_clockid_t;
-typedef int			__kernel_daddr_t;
-/* Note these change from narrow to wide kernels */
-#ifdef CONFIG_64BIT
-typedef unsigned long		__kernel_size_t;
-typedef long			__kernel_ssize_t;
-typedef long			__kernel_ptrdiff_t;
-#else
-typedef unsigned int		__kernel_size_t;
-typedef int			__kernel_ssize_t;
-typedef int			__kernel_ptrdiff_t;
-#endif
-typedef long			__kernel_time_t;
-typedef char *			__kernel_caddr_t;
+#define __kernel_ipc_pid_t __kernel_ipc_pid_t
 
-typedef unsigned short		__kernel_uid16_t;
-typedef unsigned short		__kernel_gid16_t;
-typedef unsigned int		__kernel_uid32_t;
-typedef unsigned int		__kernel_gid32_t;
+typedef int			__kernel_suseconds_t;
+#define __kernel_suseconds_t __kernel_suseconds_t
 
-#ifdef __GNUC__
-typedef long long		__kernel_loff_t;
 typedef long long		__kernel_off64_t;
 typedef unsigned long long	__kernel_ino64_t;
-#endif
-
-typedef unsigned int		__kernel_old_dev_t;
-
-typedef struct {
-	int	val[2];
-} __kernel_fsid_t;
-
-/* compatibility stuff */
-typedef __kernel_uid_t __kernel_old_uid_t;
-typedef __kernel_gid_t __kernel_old_gid_t;
-
-#if defined(__KERNEL__)
-
-#undef __FD_SET
-static __inline__ void __FD_SET(unsigned long __fd, __kernel_fd_set *__fdsetp)
-{
-	unsigned long __tmp = __fd / __NFDBITS;
-	unsigned long __rem = __fd % __NFDBITS;
-	__fdsetp->fds_bits[__tmp] |= (1UL<<__rem);
-}
-
-#undef __FD_CLR
-static __inline__ void __FD_CLR(unsigned long __fd, __kernel_fd_set *__fdsetp)
-{
-	unsigned long __tmp = __fd / __NFDBITS;
-	unsigned long __rem = __fd % __NFDBITS;
-	__fdsetp->fds_bits[__tmp] &= ~(1UL<<__rem);
-}
-
-#undef __FD_ISSET
-static __inline__ int __FD_ISSET(unsigned long __fd, const __kernel_fd_set *__p)
-{ 
-	unsigned long __tmp = __fd / __NFDBITS;
-	unsigned long __rem = __fd % __NFDBITS;
-	return (__p->fds_bits[__tmp] & (1UL<<__rem)) != 0;
-}
-
-/*
- * This will unroll the loop for the normal constant case (8 ints,
- * for a 256-bit fd_set)
- */
-#undef __FD_ZERO
-static __inline__ void __FD_ZERO(__kernel_fd_set *__p)
-{
-	unsigned long *__tmp = __p->fds_bits;
-	int __i;
-
-	if (__builtin_constant_p(__FDSET_LONGS)) {
-		switch (__FDSET_LONGS) {
-		case 16:
-			__tmp[ 0] = 0; __tmp[ 1] = 0;
-			__tmp[ 2] = 0; __tmp[ 3] = 0;
-			__tmp[ 4] = 0; __tmp[ 5] = 0;
-			__tmp[ 6] = 0; __tmp[ 7] = 0;
-			__tmp[ 8] = 0; __tmp[ 9] = 0;
-			__tmp[10] = 0; __tmp[11] = 0;
-			__tmp[12] = 0; __tmp[13] = 0;
-			__tmp[14] = 0; __tmp[15] = 0;
-			return;
-
-		case 8:
-			__tmp[ 0] = 0; __tmp[ 1] = 0;
-			__tmp[ 2] = 0; __tmp[ 3] = 0;
-			__tmp[ 4] = 0; __tmp[ 5] = 0;
-			__tmp[ 6] = 0; __tmp[ 7] = 0;
-			return;
-
-		case 4:
-			__tmp[ 0] = 0; __tmp[ 1] = 0;
-			__tmp[ 2] = 0; __tmp[ 3] = 0;
-			return;
-		}
-	}
-	__i = __FDSET_LONGS;
-	while (__i) {
-		__i--;
-		*__tmp = 0;
-		__tmp++;
-	}
-}
 
-#endif /* defined(__KERNEL__) */
+#include <asm-generic/posix_types.h>
 
 #endif
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

