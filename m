From: akpm@linux-foundation.org
Subject: [merged] m68k-use-generic-posix_typesh.patch removed from -mm tree
Date: Mon, 27 Feb 2012 14:29:43 -0800
Message-ID: <20120227222943.568ACA02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qw0-f74.google.com ([209.85.216.74]:52201 "EHLO
	mail-qw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755476Ab2B0W3o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2012 17:29:44 -0500
Received: by mail-qw0-f74.google.com with SMTP id g24so96602qab.1
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2012 14:29:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hpa@zytor.com, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Subject: m68k: use generic posix_types.h
has been removed from the -mm tree.  Its filename was
     m68k-use-generic-posix_typesh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "H. Peter Anvin" <hpa@zytor.com>
Subject: m68k: use generic posix_types.h

Change the m68k architecture to use <asm-generic/posix_types.h>.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/include/asm/posix_types.h |   51 ++++----------------------
 1 file changed, 9 insertions(+), 42 deletions(-)

diff -puN arch/m68k/include/asm/posix_types.h~m68k-use-generic-posix_typesh arch/m68k/include/asm/posix_types.h
--- a/arch/m68k/include/asm/posix_types.h~m68k-use-generic-posix_typesh
+++ a/arch/m68k/include/asm/posix_types.h
@@ -7,55 +7,22 @@
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
-#define	__FD_SET(d, set)	((set)->fds_bits[__FDELT(d)] |= __FDMASK(d))
-
-#undef	__FD_CLR
-#define	__FD_CLR(d, set)	((set)->fds_bits[__FDELT(d)] &= ~__FDMASK(d))
-
-#undef	__FD_ISSET
-#define	__FD_ISSET(d, set)	(!!((set)->fds_bits[__FDELT(d)] & __FDMASK(d)))
-
-#undef	__FD_ZERO
-#define __FD_ZERO(fdsetp) (memset (fdsetp, 0, sizeof(*(fd_set *)fdsetp)))
-
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

