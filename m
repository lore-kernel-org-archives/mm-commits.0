From: akpm@linux-foundation.org
Subject: +
 mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4.patch added
 to -mm tree
Date: Tue, 21 Jul 2015 13:55:43 -0700
Message-ID: <55aeb1cf.5v+P51bJ5jhRVDkN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40989 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbbGUUzo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jul 2015 16:55:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: emunson@akamai.com, catalin.marinas@arm.com, geert@linux-m68k.org, heiko.carstens@de.ibm.com, linux@roeck-us.net, mhocko@suse.cz, sfr@canb.auug.org.au, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mlock: Add new mlock, munlock, and munlockall system calls
has been added to the -mm tree.  Its filename is
     mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric B Munson <emunson@akamai.com>
Subject: mm: mlock: Add new mlock, munlock, and munlockall system calls

With the refactored mlock code, introduce new system calls for mlock,
munlock, and munlockall.  The new calls will allow the user to specify
what lock states are being added or cleared.  mlock2 and munlock2 are
trivial at the moment, but a follow on patch will add a new mlock state
making them useful.

munlock2 addresses a limitation of the current implementation.  If a
user calls mlockall(MCL_CURRENT | MCL_FUTURE) and then later decides
that MCL_FUTURE should be removed, they would have to call munlockall()
followed by mlockall(MCL_CURRENT) which could potentially be very
expensive.  The new munlockall2 system call allows a user to simply
clear the MCL_FUTURE flag.

Signed-off-by: Eric B Munson <emunson@akamai.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: linux-alpha@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: adi-buildroot-devel@lists.sourceforge.net
Cc: linux-cris-kernel@axis.com
Cc: linux-ia64@vger.kernel.org
Cc: linux-m68k@lists.linux-m68k.org
Cc: linux-mips@linux-mips.org
Cc: linux-am33-list@redhat.com
Cc: linux-parisc@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-s390@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Cc: sparclinux@vger.kernel.org
Cc: linux-xtensa@linux-xtensa.org
Cc: linux-api@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Cc: linux-mm@kvack.org
---
Changes from V3:
* Do a (hopefully) complete job of adding the new system calls

index a56e608..1d09392 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/uapi/asm/unistd.h      |    3 ++
 arch/arm/include/asm/unistd.h             |    2 -
 arch/arm/include/uapi/asm/unistd.h        |    3 ++
 arch/arm/kernel/calls.S                   |    2 -
 arch/avr32/include/uapi/asm/unistd.h      |    3 ++
 arch/blackfin/include/uapi/asm/unistd.h   |    3 ++
 arch/ia64/include/asm/unistd.h            |    2 -
 arch/ia64/include/uapi/asm/unistd.h       |    3 ++
 arch/m68k/include/asm/unistd.h            |    2 -
 arch/m68k/include/uapi/asm/unistd.h       |    3 ++
 arch/microblaze/include/uapi/asm/unistd.h |    3 ++
 arch/mips/include/uapi/asm/unistd.h       |   21 ++++++++++++++------
 arch/parisc/include/uapi/asm/unistd.h     |    5 +++-
 arch/powerpc/include/uapi/asm/unistd.h    |    3 ++
 arch/s390/include/uapi/asm/unistd.h       |    5 +++-
 arch/s390/kernel/compat_wrapper.c         |    3 ++
 arch/sparc/include/uapi/asm/unistd.h      |    5 +++-
 arch/x86/entry/syscalls/syscall_64.tbl    |    1 
 arch/xtensa/include/uapi/asm/unistd.h     |    4 +--
 19 files changed, 61 insertions(+), 15 deletions(-)

diff -puN arch/alpha/include/uapi/asm/unistd.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4 arch/alpha/include/uapi/asm/unistd.h
--- a/arch/alpha/include/uapi/asm/unistd.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4
+++ a/arch/alpha/include/uapi/asm/unistd.h
@@ -475,5 +475,8 @@
 #define __NR_getrandom			511
 #define __NR_memfd_create		512
 #define __NR_execveat			513
+#define __NR_mlock2			514
+#define __NR_munlock2			515
+#define __NR_munlockall2		516
 
 #endif /* _UAPI_ALPHA_UNISTD_H */
diff -puN arch/arm/include/asm/unistd.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4 arch/arm/include/asm/unistd.h
--- a/arch/arm/include/asm/unistd.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4
+++ a/arch/arm/include/asm/unistd.h
@@ -19,7 +19,7 @@
  * This may need to be greater than __NR_last_syscall+1 in order to
  * account for the padding in the syscall table
  */
-#define __NR_syscalls  (388)
+#define __NR_syscalls  (392)
 
 /*
  * *NOTE*: This is a ghost syscall private to the kernel.  Only the
diff -puN arch/arm/include/uapi/asm/unistd.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4 arch/arm/include/uapi/asm/unistd.h
--- a/arch/arm/include/uapi/asm/unistd.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4
+++ a/arch/arm/include/uapi/asm/unistd.h
@@ -414,6 +414,9 @@
 #define __NR_memfd_create		(__NR_SYSCALL_BASE+385)
 #define __NR_bpf			(__NR_SYSCALL_BASE+386)
 #define __NR_execveat			(__NR_SYSCALL_BASE+387)
+#define __NR_mlock2			(__NR_SYSCALL_BASE+388)
+#define __NR_munlock2			(__NR_SYSCALL_BASE+389)
+#define __NR_munlockall2		(__NR_SYSCALL_BASE+390)
 
 /*
  * The following SWIs are ARM private.
diff -puN arch/arm/kernel/calls.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4 arch/arm/kernel/calls.S
--- a/arch/arm/kernel/calls.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4
+++ a/arch/arm/kernel/calls.S
@@ -399,7 +399,7 @@
 		CALL(sys_execveat)
 		CALL(sys_mlock2)
 		CALL(sys_munlock2)
-/* 400 */	CALL(sys_munlockall2)
+/* 390 */	CALL(sys_munlockall2)
 #ifndef syscalls_counted
 .equ syscalls_padding, ((NR_syscalls + 3) & ~3) - NR_syscalls
 #define syscalls_counted
diff -puN arch/avr32/include/uapi/asm/unistd.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4 arch/avr32/include/uapi/asm/unistd.h
--- a/arch/avr32/include/uapi/asm/unistd.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4
+++ a/arch/avr32/include/uapi/asm/unistd.h
@@ -333,5 +333,8 @@
 #define __NR_memfd_create	318
 #define __NR_bpf		319
 #define __NR_execveat		320
+#define __NR_mlock2		321
+#define __NR_munlock2		322
+#define __NR_munlockall2	323
 
 #endif /* _UAPI__ASM_AVR32_UNISTD_H */
diff -puN arch/blackfin/include/uapi/asm/unistd.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4 arch/blackfin/include/uapi/asm/unistd.h
--- a/arch/blackfin/include/uapi/asm/unistd.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4
+++ a/arch/blackfin/include/uapi/asm/unistd.h
@@ -433,6 +433,9 @@
 #define __IGNORE_munlock
 #define __IGNORE_mlockall
 #define __IGNORE_munlockall
+#define __IGNORE_mlock2
+#define __IGNORE_munlock2
+#define __IGNORE_munlockall2
 #define __IGNORE_mincore
 #define __IGNORE_madvise
 #define __IGNORE_remap_file_pages
diff -puN arch/ia64/include/asm/unistd.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4 arch/ia64/include/asm/unistd.h
--- a/arch/ia64/include/asm/unistd.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4
+++ a/arch/ia64/include/asm/unistd.h
@@ -11,7 +11,7 @@
 
 
 
-#define NR_syscalls			319 /* length of syscall table */
+#define NR_syscalls			322 /* length of syscall table */
 
 /*
  * The following defines stop scripts/checksyscalls.sh from complaining about
diff -puN arch/ia64/include/uapi/asm/unistd.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4 arch/ia64/include/uapi/asm/unistd.h
--- a/arch/ia64/include/uapi/asm/unistd.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4
+++ a/arch/ia64/include/uapi/asm/unistd.h
@@ -332,5 +332,8 @@
 #define __NR_memfd_create		1340
 #define __NR_bpf			1341
 #define __NR_execveat			1342
+#define __NR_mlock2			1343
+#define __NR_munlock2			1344
+#define __NR_munlockall2		1345
 
 #endif /* _UAPI_ASM_IA64_UNISTD_H */
diff -puN arch/m68k/include/asm/unistd.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4 arch/m68k/include/asm/unistd.h
--- a/arch/m68k/include/asm/unistd.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4
+++ a/arch/m68k/include/asm/unistd.h
@@ -4,7 +4,7 @@
 #include <uapi/asm/unistd.h>
 
 
-#define NR_syscalls		356
+#define NR_syscalls		359
 
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_OLD_STAT
diff -puN arch/m68k/include/uapi/asm/unistd.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4 arch/m68k/include/uapi/asm/unistd.h
--- a/arch/m68k/include/uapi/asm/unistd.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4
+++ a/arch/m68k/include/uapi/asm/unistd.h
@@ -361,5 +361,8 @@
 #define __NR_memfd_create	353
 #define __NR_bpf		354
 #define __NR_execveat		355
+#define __NR_mlock2		356
+#define __NR_munlock2		357
+#define __NR_munlockall2	358
 
 #endif /* _UAPI_ASM_M68K_UNISTD_H_ */
diff -puN arch/microblaze/include/uapi/asm/unistd.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4 arch/microblaze/include/uapi/asm/unistd.h
--- a/arch/microblaze/include/uapi/asm/unistd.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4
+++ a/arch/microblaze/include/uapi/asm/unistd.h
@@ -404,5 +404,8 @@
 #define __NR_memfd_create	386
 #define __NR_bpf		387
 #define __NR_execveat		388
+#define __NR_mlock2		389 /* ok - nommu or mmu */
+#define __NR_munlock2		390 /* ok - nommu or mmu */
+#define __NR_munlockall2	391 /* ok - nommu or mmu */
 
 #endif /* _UAPI_ASM_MICROBLAZE_UNISTD_H */
diff -puN arch/mips/include/uapi/asm/unistd.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4 arch/mips/include/uapi/asm/unistd.h
--- a/arch/mips/include/uapi/asm/unistd.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4
+++ a/arch/mips/include/uapi/asm/unistd.h
@@ -377,16 +377,19 @@
 #define __NR_memfd_create		(__NR_Linux + 354)
 #define __NR_bpf			(__NR_Linux + 355)
 #define __NR_execveat			(__NR_Linux + 356)
+#define __NR_mlock2			(__NR_Linux + 357)
+#define __NR_munlock2			(__NR_Linux + 358)
+#define __NR_munlockall2		(__NR_Linux + 359)
 
 /*
  * Offset of the last Linux o32 flavoured syscall
  */
-#define __NR_Linux_syscalls		356
+#define __NR_Linux_syscalls		359
 
 #endif /* _MIPS_SIM == _MIPS_SIM_ABI32 */
 
 #define __NR_O32_Linux			4000
-#define __NR_O32_Linux_syscalls		356
+#define __NR_O32_Linux_syscalls		359
 
 #if _MIPS_SIM == _MIPS_SIM_ABI64
 
@@ -711,16 +714,19 @@
 #define __NR_memfd_create		(__NR_Linux + 314)
 #define __NR_bpf			(__NR_Linux + 315)
 #define __NR_execveat			(__NR_Linux + 316)
+#define __NR_mlock2			(__NR_Linux + 317)
+#define __NR_munlock2			(__NR_Linux + 318)
+#define __NR_munlockall2		(__NR_Linux + 319)
 
 /*
  * Offset of the last Linux 64-bit flavoured syscall
  */
-#define __NR_Linux_syscalls		316
+#define __NR_Linux_syscalls		319
 
 #endif /* _MIPS_SIM == _MIPS_SIM_ABI64 */
 
 #define __NR_64_Linux			5000
-#define __NR_64_Linux_syscalls		316
+#define __NR_64_Linux_syscalls		319
 
 #if _MIPS_SIM == _MIPS_SIM_NABI32
 
@@ -1049,15 +1055,18 @@
 #define __NR_memfd_create		(__NR_Linux + 318)
 #define __NR_bpf			(__NR_Linux + 319)
 #define __NR_execveat			(__NR_Linux + 320)
+#define __NR_mlock2			(__NR_Linux + 321)
+#define __NR_munlock2			(__NR_Linux + 322)
+#define __NR_munlockall2		(__NR_Linux + 323)
 
 /*
  * Offset of the last N32 flavoured syscall
  */
-#define __NR_Linux_syscalls		320
+#define __NR_Linux_syscalls		323
 
 #endif /* _MIPS_SIM == _MIPS_SIM_NABI32 */
 
 #define __NR_N32_Linux			6000
-#define __NR_N32_Linux_syscalls		320
+#define __NR_N32_Linux_syscalls		323
 
 #endif /* _UAPI_ASM_UNISTD_H */
diff -puN arch/parisc/include/uapi/asm/unistd.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4 arch/parisc/include/uapi/asm/unistd.h
--- a/arch/parisc/include/uapi/asm/unistd.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4
+++ a/arch/parisc/include/uapi/asm/unistd.h
@@ -358,8 +358,11 @@
 #define __NR_memfd_create	(__NR_Linux + 340)
 #define __NR_bpf		(__NR_Linux + 341)
 #define __NR_execveat		(__NR_Linux + 342)
+#define __NR_mlock2		(__NR_Linux + 343)
+#define __NR_munlock2		(__NR_Linux + 344)
+#define __NR_munlockall2	(__NR_Linux + 345)
 
-#define __NR_Linux_syscalls	(__NR_execveat + 1)
+#define __NR_Linux_syscalls	(__NR_munlockall2 + 1)
 
 
 #define __IGNORE_select		/* newselect */
diff -puN arch/powerpc/include/uapi/asm/unistd.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4 arch/powerpc/include/uapi/asm/unistd.h
--- a/arch/powerpc/include/uapi/asm/unistd.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4
+++ a/arch/powerpc/include/uapi/asm/unistd.h
@@ -387,5 +387,8 @@
 #define __NR_execveat		362
 #define __NR_switch_endian	363
 #define __NR_userfaultfd	364
+#define __NR_mlock2		365
+#define __NR_munlock2		366
+#define __NR_munlockall2	367
 
 #endif /* _UAPI_ASM_POWERPC_UNISTD_H_ */
diff -puN arch/s390/include/uapi/asm/unistd.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4 arch/s390/include/uapi/asm/unistd.h
--- a/arch/s390/include/uapi/asm/unistd.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4
+++ a/arch/s390/include/uapi/asm/unistd.h
@@ -290,7 +290,10 @@
 #define __NR_s390_pci_mmio_write	352
 #define __NR_s390_pci_mmio_read		353
 #define __NR_execveat		354
-#define NR_syscalls 355
+#define __NR_mlock2		355
+#define __NR_munlock2		356
+#define __NR_munlockall2	357
+#define NR_syscalls 358
 
 /* 
  * There are some system calls that are not present on 64 bit, some
diff -puN arch/s390/kernel/compat_wrapper.c~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4 arch/s390/kernel/compat_wrapper.c
--- a/arch/s390/kernel/compat_wrapper.c~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4
+++ a/arch/s390/kernel/compat_wrapper.c
@@ -220,3 +220,6 @@ COMPAT_SYSCALL_WRAP2(memfd_create, const
 COMPAT_SYSCALL_WRAP3(bpf, int, cmd, union bpf_attr *, attr, unsigned int, size);
 COMPAT_SYSCALL_WRAP3(s390_pci_mmio_write, const unsigned long, mmio_addr, const void __user *, user_buffer, const size_t, length);
 COMPAT_SYSCALL_WRAP3(s390_pci_mmio_read, const unsigned long, mmio_addr, void __user *, user_buffer, const size_t, length);
+COMPAT_SYSCALL_WRAP3(mlock2, unsigned long, start, size_t, len, int, flags);
+COMPAT_SYSCALL_WRAP3(munlock2, unsigned long, start, size_t, len, int, flags);
+COMPAT_SYSCALL_WRAP1(munlockall2, int, flags);
diff -puN arch/sparc/include/uapi/asm/unistd.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4 arch/sparc/include/uapi/asm/unistd.h
--- a/arch/sparc/include/uapi/asm/unistd.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4
+++ a/arch/sparc/include/uapi/asm/unistd.h
@@ -416,8 +416,11 @@
 #define __NR_memfd_create	348
 #define __NR_bpf		349
 #define __NR_execveat		350
+#define __NR_mlock2		351
+#define __NR_munlock2		352
+#define __NR_munlockall2	353
 
-#define NR_syscalls		351
+#define NR_syscalls		354
 
 /* Bitmask values returned from kern_features system call.  */
 #define KERN_FEATURE_MIXED_MODE_STACK	0x00000001
diff -puN arch/x86/entry/syscalls/syscall_64.tbl~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4 arch/x86/entry/syscalls/syscall_64.tbl
--- a/arch/x86/entry/syscalls/syscall_64.tbl~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4
+++ a/arch/x86/entry/syscalls/syscall_64.tbl
@@ -334,6 +334,7 @@
 325	common	munlock2		sys_munlock2
 326	common	munlockall2		sys_munlockall2
 
+
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
 # for native 64-bit operation.
diff -puN arch/xtensa/include/uapi/asm/unistd.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4 arch/xtensa/include/uapi/asm/unistd.h
--- a/arch/xtensa/include/uapi/asm/unistd.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4
+++ a/arch/xtensa/include/uapi/asm/unistd.h
@@ -756,9 +756,9 @@ __SYSCALL(341, sys_execveat, 5)
 #define __NR_mlock2				342
 __SYSCALL(342, sys_mlock2, 3)
 #define __NR_munlock2				343
-__SYSCALL(342, sys_munlock2, 3)
+__SYSCALL(343, sys_munlock2, 3)
 #define __NR_munlockall2			344
-__SYSCALL(342, sys_munlock2, 1)
+__SYSCALL(344, sys_munlock2, 1)
 
 #define __NR_syscall_count			345
 
_

Patches currently in -mm which might be from emunson@akamai.com are

mm-mlock-refactor-mlock-munlock-and-munlockall-code.patch
mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls.patch
mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4.patch
mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix.patch
mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix-2.patch
mm-gup-add-mm_lock_present.patch
mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it.patch
mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4.patch
mm-mmap-add-mmap-flag-to-request-vm_lockonfault.patch
mm-mmap-add-mmap-flag-to-request-vm_lockonfault-v4.patch
selftests-vm-add-tests-for-lock-on-fault.patch
selftests-vm-add-tests-for-lock-on-fault-v4.patch

