From: akpm@linux-foundation.org
Subject: + sh-remove-unnecessary-posix_typesh-type-overrides.patch added to -mm tree
Date: Wed, 08 Feb 2012 15:48:36 -0800
Message-ID: <20120208234836.EEA11A023F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:33287 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757826Ab2BHXsn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Feb 2012 18:48:43 -0500
Received: by ghrr17 with SMTP id r17so113417ghr.1
        for <mm-commits@vger.kernel.org>; Wed, 08 Feb 2012 15:48:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hpa@zytor.com, lethal@linux-sh.org


The patch titled
     Subject: sh: remove unnecessary posix_types.h type overrides
has been added to the -mm tree.  Its filename is
     sh-remove-unnecessary-posix_typesh-type-overrides.patch

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
Subject: sh: remove unnecessary posix_types.h type overrides

Remove type overrides in <asm/posix_types.h> for the sh architecture that
are no longer necessary.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/posix_types_32.h |    5 -----
 arch/sh/include/asm/posix_types_64.h |    4 ----
 2 files changed, 9 deletions(-)

diff -puN arch/sh/include/asm/posix_types_32.h~sh-remove-unnecessary-posix_typesh-type-overrides arch/sh/include/asm/posix_types_32.h
--- a/arch/sh/include/asm/posix_types_32.h~sh-remove-unnecessary-posix_typesh-type-overrides
+++ a/arch/sh/include/asm/posix_types_32.h
@@ -12,11 +12,6 @@ typedef unsigned short	__kernel_uid_t;
 typedef unsigned short	__kernel_gid_t;
 #define __kernel_gid_t __kernel_gid_t
 
-typedef unsigned int	__kernel_uid32_t;
-#define __kernel_uid32_t __kernel_uid32_t
-typedef unsigned int	__kernel_gid32_t;
-#define __kernel_gid32_t __kernel_gid32_t
-
 typedef unsigned short	__kernel_old_uid_t;
 #define __kernel_old_uid_t __kernel_old_uid_t
 typedef unsigned short	__kernel_old_gid_t;
diff -puN arch/sh/include/asm/posix_types_64.h~sh-remove-unnecessary-posix_typesh-type-overrides arch/sh/include/asm/posix_types_64.h
--- a/arch/sh/include/asm/posix_types_64.h~sh-remove-unnecessary-posix_typesh-type-overrides
+++ a/arch/sh/include/asm/posix_types_64.h
@@ -17,10 +17,6 @@ typedef int		__kernel_ssize_t;
 #define __kernel_ssize_t __kernel_ssize_t
 typedef int		__kernel_ptrdiff_t;
 #define __kernel_ptrdiff_t __kernel_ptrdiff_t
-typedef unsigned int	__kernel_uid32_t;
-#define __kernel_uid32_t __kernel_uid32_t
-typedef unsigned int	__kernel_gid32_t;
-#define __kernel_gid32_t __kernel_gid32_t
 
 typedef unsigned short	__kernel_old_uid_t;
 #define __kernel_old_uid_t __kernel_old_uid_t
_
Subject: Subject: sh: remove unnecessary posix_types.h type overrides

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

