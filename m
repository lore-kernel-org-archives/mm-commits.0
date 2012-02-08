From: akpm@linux-foundation.org
Subject: + m32r-use-generic-posix_typesh.patch added to -mm tree
Date: Wed, 08 Feb 2012 15:48:23 -0800
Message-ID: <20120208234823.499F6A023F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:59946 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757826Ab2BHXsZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Feb 2012 18:48:25 -0500
Received: by wgbds12 with SMTP id ds12so34874wgb.1
        for <mm-commits@vger.kernel.org>; Wed, 08 Feb 2012 15:48:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hpa@zytor.com, takata@linux-m32r.org


The patch titled
     Subject: m32r: use generic posix_types.h
has been added to the -mm tree.  Its filename is
     m32r-use-generic-posix_typesh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "H. Peter Anvin" <hpa@zytor.com>
Subject: m32r: use generic posix_types.h

Change the m32r architecture to use <asm-generic/posix_types.h>.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/include/asm/posix_types.h |  108 ++------------------------
 1 file changed, 9 insertions(+), 99 deletions(-)

diff -puN arch/m32r/include/asm/posix_types.h~m32r-use-generic-posix_typesh arch/m32r/include/asm/posix_types.h
--- a/arch/m32r/include/asm/posix_types.h~m32r-use-generic-posix_typesh
+++ a/arch/m32r/include/asm/posix_types.h
@@ -7,112 +7,22 @@
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
-static __inline__ void __FD_SET(unsigned long __fd, __kernel_fd_set *__fdsetp)
-{
-	unsigned long __tmp = __fd / __NFDBITS;
-	unsigned long __rem = __fd % __NFDBITS;
-	__fdsetp->fds_bits[__tmp] |= (1UL<<__rem);
-}
-
-#undef	__FD_CLR
-static __inline__ void __FD_CLR(unsigned long __fd, __kernel_fd_set *__fdsetp)
-{
-	unsigned long __tmp = __fd / __NFDBITS;
-	unsigned long __rem = __fd % __NFDBITS;
-	__fdsetp->fds_bits[__tmp] &= ~(1UL<<__rem);
-}
-
-
-#undef	__FD_ISSET
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
-#undef	__FD_ZERO
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
-
-#endif /* defined(__KERNEL__) */
+#include <asm-generic/posix_types.h>
 
 #endif  /* _ASM_M32R_POSIX_TYPES_H */
_
Subject: Subject: m32r: use generic posix_types.h

Patches currently in -mm which might be from hpa@zytor.com are

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
hugetlbfs-fix-hugetlb_get_unmapped_area.patch
hugetlb-drop-prev_vma-in-hugetlb_get_unmapped_area_topdown.patch
hugetlb-try-to-search-again-if-it-is-really-needed.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
mm-do-not-reset-cached_hole_size-when-vma-is-unmapped.patch
mm-search-from-free_area_cache-for-the-bigger-size.patch
percpu-remove-percpu_xxx-functions.patch
smp-start-up-non-boot-cpus-asynchronously.patch
smp-start-up-non-boot-cpus-asynchronously-fix.patch
posix_types-make-__kernel_id32_t-default-to-unsigned-int.patch
posix_types-make-it-possible-to-override-__kernel_fsid_t.patch
alpha-use-generic-posix_typesh.patch
arm-use-generic-posix_typesh.patch
avr32-use-generic-posix_typesh.patch
cris-use-generic-posix_typesh.patch
frv-use-generic-posix_typesh.patch
h8300-use-generic-posix_typesh.patch
ia64-use-generic-posix_typesh.patch
m32r-use-generic-posix_typesh.patch
m68k-use-generic-posix_typesh.patch
mips-use-generic-posix_typesh.patch
mn10300-use-generic-posix_typesh.patch
parisc-use-generic-posix_typesh.patch
powerpc-use-generic-posix_typesh.patch
s390-use-generic-posix_typesh.patch
sh-remove-unnecessary-posix_typesh-type-overrides.patch
sparc-use-generic-posix_typesh.patch
x86-use-generic-posix_typesh.patch
xtensa-use-generic-posix_typesh.patch
posix_types-remove-fd_set-macros.patch
bitops-rename-for_each_set_bit_cont-in-favor-of-analogous-listh-function.patch
bitops-remove-for_each_set_bit_cont.patch
bitops-introduce-for_each_clear_bit.patch
x86-use-for_each_clear_bit_from.patch
ipc-provide-generic-compat-versions-of-ipc-syscalls.patch

