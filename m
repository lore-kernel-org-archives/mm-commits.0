From: akpm@linux-foundation.org
Subject: + all-arch-remove-system-call-sys_sysctl.patch added to -mm
 tree
Date: Tue, 16 Jun 2020 11:49:34 -0700
Message-ID: <20200616184934.CQWcy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726805AbgFPSti (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 16 Jun 2020 14:49:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhouyanjie@wanyeetech.com, yzaikin@google.com, ysato@users.sourceforge.jp, yamada.masahiro@socionext.com, will@kernel.org, viro@zeniv.linux.org.uk, vbabka@suse.cz, tsbogend@alpha.franken.de, tony.luck@intel.com, tglx@linutronix.de, svens@stackframe.org, sudeep.holla@arm.com, sfr@canb.auug.org.au, sargun@sargun.me, samitolvanen@google.com, rth@twiddle.net, rdunlap@infradead.org, ravi.bangoria@linux.ibm.com, peterz@infradead.org, paulus@samba.org, paulmck@kernel.org, paulburton@kernel.org, olof@lixom.net, oleg@redhat.com, npiggin@gmail.com, naveen.n.rao@linux.vnet.ibm.com, namhyung@kernel.org, mszeredi@redhat.com, mpe@ellerman.id.au, monstr@monstr.eu, mingo@redhat.com, minchan@kernel.org, mcgrof@kernel.org, mattst88@gmail.com, martin.petersen@oracle.com


The patch titled
     Subject: all arch: remove system call sys_sysctl
has been added to the -mm tree.  Its filename is
     all-arch-remove-system-call-sys_sysctl.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/all-arch-remove-system-call-sy=
s_sysctl.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/all-arch-remove-system-call-sy=
s_sysctl.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xiaoming Ni <nixiaoming@huawei.com>
Subject: all arch: remove system call sys_sysctl

Since commit 61a47c1ad3a4dc ("sysctl: Remove the sysctl system call"),
sys_sysctl is actually unavailable: any input can only return an error.

We have been warning about people using the sysctl system call for years
and believe there are no more users.  Even if there are users of this
interface if they have not complained or fixed their code by now they
probably are not going to, so there is no point in warning them any
longer.

So completely remove sys_sysctl on all architectures.

Link: http://lkml.kernel.org/r/20200616030734.87257-1-nixiaoming@huawei.com
Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
Acked-by: Will Deacon <will@kernel.org>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Bin Meng <bin.meng@windriver.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: chenzefeng <chenzefeng2@huawei.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christian Brauner <christian@brauner.io>
Cc: Chris Zankel <chris@zankel.net>
Cc: David Howells <dhowells@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Diego Elio Petten=C3=B2 <flameeyes@flameeyes.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Kars de Jong <jongk@linux-m68k.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Marco Elver <elver@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Cc: Nick Piggin <npiggin@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Olof Johansson <olof@lixom.net>
Cc: Paul Burton <paulburton@kernel.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Rich Felker <dalias@libc.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Sargun Dhillon <sargun@sargun.me>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Cc: Sven Schnelle <svens@stackframe.org>
Cc: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Zhou Yanjie <zhouyanjie@wanyeetech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/syscalls/syscall.tbl             |    2=20
 arch/arm/configs/am200epdkit_defconfig             |    1=20
 arch/arm/tools/syscall.tbl                         |    2=20
 arch/arm64/include/asm/unistd32.h                  |    4=20
 arch/ia64/kernel/syscalls/syscall.tbl              |    2=20
 arch/m68k/kernel/syscalls/syscall.tbl              |    2=20
 arch/microblaze/kernel/syscalls/syscall.tbl        |    2=20
 arch/mips/configs/cu1000-neo_defconfig             |    1=20
 arch/mips/kernel/syscalls/syscall_n32.tbl          |    2=20
 arch/mips/kernel/syscalls/syscall_n64.tbl          |    2=20
 arch/mips/kernel/syscalls/syscall_o32.tbl          |    2=20
 arch/parisc/kernel/syscalls/syscall.tbl            |    2=20
 arch/powerpc/kernel/syscalls/syscall.tbl           |    2=20
 arch/s390/kernel/syscalls/syscall.tbl              |    2=20
 arch/sh/configs/dreamcast_defconfig                |    1=20
 arch/sh/configs/espt_defconfig                     |    1=20
 arch/sh/configs/hp6xx_defconfig                    |    1=20
 arch/sh/configs/landisk_defconfig                  |    1=20
 arch/sh/configs/lboxre2_defconfig                  |    1=20
 arch/sh/configs/microdev_defconfig                 |    1=20
 arch/sh/configs/migor_defconfig                    |    1=20
 arch/sh/configs/r7780mp_defconfig                  |    1=20
 arch/sh/configs/r7785rp_defconfig                  |    1=20
 arch/sh/configs/rts7751r2d1_defconfig              |    1=20
 arch/sh/configs/rts7751r2dplus_defconfig           |    1=20
 arch/sh/configs/se7206_defconfig                   |    1=20
 arch/sh/configs/se7343_defconfig                   |    1=20
 arch/sh/configs/se7619_defconfig                   |    1=20
 arch/sh/configs/se7705_defconfig                   |    1=20
 arch/sh/configs/se7750_defconfig                   |    1=20
 arch/sh/configs/se7751_defconfig                   |    1=20
 arch/sh/configs/secureedge5410_defconfig           |    1=20
 arch/sh/configs/sh03_defconfig                     |    1=20
 arch/sh/configs/sh7710voipgw_defconfig             |    1=20
 arch/sh/configs/sh7757lcr_defconfig                |    1=20
 arch/sh/configs/sh7763rdp_defconfig                |    1=20
 arch/sh/configs/shmin_defconfig                    |    1=20
 arch/sh/configs/titan_defconfig                    |    1=20
 arch/sh/kernel/syscalls/syscall.tbl                |    2=20
 arch/sparc/kernel/syscalls/syscall.tbl             |    2=20
 arch/x86/entry/syscalls/syscall_32.tbl             |    2=20
 arch/x86/entry/syscalls/syscall_64.tbl             |    2=20
 arch/xtensa/kernel/syscalls/syscall.tbl            |    2=20
 include/linux/compat.h                             |    1=20
 include/linux/syscalls.h                           |    2=20
 include/linux/sysctl.h                             |    6=20
 kernel/Makefile                                    |    2=20
 kernel/sys_ni.c                                    |    1=20
 kernel/sysctl_binary.c                             |  171 -----------
 tools/perf/arch/powerpc/entry/syscalls/syscall.tbl |    2=20
 tools/perf/arch/s390/entry/syscalls/syscall.tbl    |    2=20
 tools/perf/arch/x86/entry/syscalls/syscall_64.tbl  |    2=20
 52 files changed, 24 insertions(+), 227 deletions(-)

--- a/arch/alpha/kernel/syscalls/syscall.tbl~all-arch-remove-system-call-sy=
s_sysctl
+++ a/arch/alpha/kernel/syscalls/syscall.tbl
@@ -249,7 +249,7 @@
 316	common	mlockall			sys_mlockall
 317	common	munlockall			sys_munlockall
 318	common	sysinfo				sys_sysinfo
-319	common	_sysctl				sys_sysctl
+319	common	_sysctl				sys_ni_syscall
 # 320 was sys_idle
 321	common	oldumount			sys_oldumount
 322	common	swapon				sys_swapon
--- a/arch/arm64/include/asm/unistd32.h~all-arch-remove-system-call-sys_sys=
ctl
+++ a/arch/arm64/include/asm/unistd32.h
@@ -308,8 +308,8 @@ __SYSCALL(__NR_writev, compat_sys_writev
 __SYSCALL(__NR_getsid, sys_getsid)
 #define __NR_fdatasync 148
 __SYSCALL(__NR_fdatasync, sys_fdatasync)
-#define __NR__sysctl 149
-__SYSCALL(__NR__sysctl, compat_sys_sysctl)
+			/* 149 was sys_sysctl */
+__SYSCALL(149, sys_ni_syscall)
 #define __NR_mlock 150
 __SYSCALL(__NR_mlock, sys_mlock)
 #define __NR_munlock 151
--- a/arch/arm/configs/am200epdkit_defconfig~all-arch-remove-system-call-sy=
s_sysctl
+++ a/arch/arm/configs/am200epdkit_defconfig
@@ -3,7 +3,6 @@ CONFIG_LOCALVERSION=3D"gum"
 CONFIG_SYSVIPC=3Dy
 CONFIG_SYSFS_DEPRECATED_V2=3Dy
 CONFIG_EXPERT=3Dy
-# CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_EPOLL is not set
 # CONFIG_SHMEM is not set
 # CONFIG_VM_EVENT_COUNTERS is not set
--- a/arch/arm/tools/syscall.tbl~all-arch-remove-system-call-sys_sysctl
+++ a/arch/arm/tools/syscall.tbl
@@ -162,7 +162,7 @@
 146	common	writev			sys_writev
 147	common	getsid			sys_getsid
 148	common	fdatasync		sys_fdatasync
-149	common	_sysctl			sys_sysctl
+149	common	_sysctl			sys_ni_syscall
 150	common	mlock			sys_mlock
 151	common	munlock			sys_munlock
 152	common	mlockall		sys_mlockall
--- a/arch/ia64/kernel/syscalls/syscall.tbl~all-arch-remove-system-call-sys=
_sysctl
+++ a/arch/ia64/kernel/syscalls/syscall.tbl
@@ -135,7 +135,7 @@
 123	common	writev				sys_writev
 124	common	pread64				sys_pread64
 125	common	pwrite64			sys_pwrite64
-126	common	_sysctl				sys_sysctl
+126	common	_sysctl				sys_ni_syscall
 127	common	mmap				sys_mmap
 128	common	munmap				sys_munmap
 129	common	mlock				sys_mlock
--- a/arch/m68k/kernel/syscalls/syscall.tbl~all-arch-remove-system-call-sys=
_sysctl
+++ a/arch/m68k/kernel/syscalls/syscall.tbl
@@ -156,7 +156,7 @@
 146	common	writev				sys_writev
 147	common	getsid				sys_getsid
 148	common	fdatasync			sys_fdatasync
-149	common	_sysctl				sys_sysctl
+149	common	_sysctl				sys_ni_syscall
 150	common	mlock				sys_mlock
 151	common	munlock				sys_munlock
 152	common	mlockall			sys_mlockall
--- a/arch/microblaze/kernel/syscalls/syscall.tbl~all-arch-remove-system-ca=
ll-sys_sysctl
+++ a/arch/microblaze/kernel/syscalls/syscall.tbl
@@ -156,7 +156,7 @@
 146	common	writev				sys_writev
 147	common	getsid				sys_getsid
 148	common	fdatasync			sys_fdatasync
-149	common	_sysctl				sys_sysctl
+149	common	_sysctl				sys_ni_syscall
 150	common	mlock				sys_mlock
 151	common	munlock				sys_munlock
 152	common	mlockall			sys_mlockall
--- a/arch/mips/configs/cu1000-neo_defconfig~all-arch-remove-system-call-sy=
s_sysctl
+++ a/arch/mips/configs/cu1000-neo_defconfig
@@ -17,7 +17,6 @@ CONFIG_CGROUP_CPUACCT=3Dy
 CONFIG_NAMESPACES=3Dy
 CONFIG_USER_NS=3Dy
 CONFIG_CC_OPTIMIZE_FOR_SIZE=3Dy
-CONFIG_SYSCTL_SYSCALL=3Dy
 CONFIG_KALLSYMS_ALL=3Dy
 CONFIG_EMBEDDED=3Dy
 # CONFIG_VM_EVENT_COUNTERS is not set
--- a/arch/mips/kernel/syscalls/syscall_n32.tbl~all-arch-remove-system-call=
-sys_sysctl
+++ a/arch/mips/kernel/syscalls/syscall_n32.tbl
@@ -159,7 +159,7 @@
 149	n32	munlockall			sys_munlockall
 150	n32	vhangup				sys_vhangup
 151	n32	pivot_root			sys_pivot_root
-152	n32	_sysctl				compat_sys_sysctl
+152	n32	_sysctl				sys_ni_syscall
 153	n32	prctl				sys_prctl
 154	n32	adjtimex			sys_adjtimex_time32
 155	n32	setrlimit			compat_sys_setrlimit
--- a/arch/mips/kernel/syscalls/syscall_n64.tbl~all-arch-remove-system-call=
-sys_sysctl
+++ a/arch/mips/kernel/syscalls/syscall_n64.tbl
@@ -159,7 +159,7 @@
 149	n64	munlockall			sys_munlockall
 150	n64	vhangup				sys_vhangup
 151	n64	pivot_root			sys_pivot_root
-152	n64	_sysctl				sys_sysctl
+152	n64	_sysctl				sys_ni_syscall
 153	n64	prctl				sys_prctl
 154	n64	adjtimex			sys_adjtimex
 155	n64	setrlimit			sys_setrlimit
--- a/arch/mips/kernel/syscalls/syscall_o32.tbl~all-arch-remove-system-call=
-sys_sysctl
+++ a/arch/mips/kernel/syscalls/syscall_o32.tbl
@@ -164,7 +164,7 @@
 150	o32	unused150			sys_ni_syscall
 151	o32	getsid				sys_getsid
 152	o32	fdatasync			sys_fdatasync
-153	o32	_sysctl				sys_sysctl			compat_sys_sysctl
+153	o32	_sysctl				sys_ni_syscall
 154	o32	mlock				sys_mlock
 155	o32	munlock				sys_munlock
 156	o32	mlockall			sys_mlockall
--- a/arch/parisc/kernel/syscalls/syscall.tbl~all-arch-remove-system-call-s=
ys_sysctl
+++ a/arch/parisc/kernel/syscalls/syscall.tbl
@@ -163,7 +163,7 @@
 146	common	writev			sys_writev			compat_sys_writev
 147	common	getsid			sys_getsid
 148	common	fdatasync		sys_fdatasync
-149	common	_sysctl			sys_sysctl			compat_sys_sysctl
+149	common	_sysctl			sys_ni_syscall
 150	common	mlock			sys_mlock
 151	common	munlock			sys_munlock
 152	common	mlockall		sys_mlockall
--- a/arch/powerpc/kernel/syscalls/syscall.tbl~all-arch-remove-system-call-=
sys_sysctl
+++ a/arch/powerpc/kernel/syscalls/syscall.tbl
@@ -197,7 +197,7 @@
 146	common	writev				sys_writev			compat_sys_writev
 147	common	getsid				sys_getsid
 148	common	fdatasync			sys_fdatasync
-149	nospu	_sysctl				sys_sysctl			compat_sys_sysctl
+149	nospu	_sysctl				sys_ni_syscall
 150	common	mlock				sys_mlock
 151	common	munlock				sys_munlock
 152	common	mlockall			sys_mlockall
--- a/arch/s390/kernel/syscalls/syscall.tbl~all-arch-remove-system-call-sys=
_sysctl
+++ a/arch/s390/kernel/syscalls/syscall.tbl
@@ -138,7 +138,7 @@
 146  common	writev			sys_writev			compat_sys_writev
 147  common	getsid			sys_getsid			sys_getsid
 148  common	fdatasync		sys_fdatasync			sys_fdatasync
-149  common	_sysctl			sys_sysctl			compat_sys_sysctl
+149  common	_sysctl			sys_ni_syscall
 150  common	mlock			sys_mlock			sys_mlock
 151  common	munlock			sys_munlock			sys_munlock
 152  common	mlockall		sys_mlockall			sys_mlockall
--- a/arch/sh/configs/dreamcast_defconfig~all-arch-remove-system-call-sys_s=
ysctl
+++ a/arch/sh/configs/dreamcast_defconfig
@@ -1,7 +1,6 @@
 CONFIG_SYSVIPC=3Dy
 CONFIG_BSD_PROCESS_ACCT=3Dy
 CONFIG_LOG_BUF_SHIFT=3D14
-# CONFIG_SYSCTL_SYSCALL is not set
 CONFIG_SLAB=3Dy
 CONFIG_PROFILING=3Dy
 CONFIG_MODULES=3Dy
--- a/arch/sh/configs/espt_defconfig~all-arch-remove-system-call-sys_sysctl
+++ a/arch/sh/configs/espt_defconfig
@@ -5,7 +5,6 @@ CONFIG_LOG_BUF_SHIFT=3D14
 CONFIG_NAMESPACES=3Dy
 CONFIG_UTS_NS=3Dy
 CONFIG_IPC_NS=3Dy
-# CONFIG_SYSCTL_SYSCALL is not set
 CONFIG_SLAB=3Dy
 CONFIG_PROFILING=3Dy
 CONFIG_OPROFILE=3Dy
--- a/arch/sh/configs/hp6xx_defconfig~all-arch-remove-system-call-sys_sysctl
+++ a/arch/sh/configs/hp6xx_defconfig
@@ -3,7 +3,6 @@ CONFIG_IKCONFIG=3Dy
 CONFIG_IKCONFIG_PROC=3Dy
 CONFIG_LOG_BUF_SHIFT=3D14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-# CONFIG_SYSCTL_SYSCALL is not set
 CONFIG_SLAB=3Dy
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_CPU_SUBTYPE_SH7709=3Dy
--- a/arch/sh/configs/landisk_defconfig~all-arch-remove-system-call-sys_sys=
ctl
+++ a/arch/sh/configs/landisk_defconfig
@@ -1,6 +1,5 @@
 CONFIG_SYSVIPC=3Dy
 CONFIG_LOG_BUF_SHIFT=3D14
-# CONFIG_SYSCTL_SYSCALL is not set
 CONFIG_KALLSYMS_EXTRA_PASS=3Dy
 CONFIG_SLAB=3Dy
 CONFIG_MODULES=3Dy
--- a/arch/sh/configs/lboxre2_defconfig~all-arch-remove-system-call-sys_sys=
ctl
+++ a/arch/sh/configs/lboxre2_defconfig
@@ -1,6 +1,5 @@
 CONFIG_SYSVIPC=3Dy
 CONFIG_LOG_BUF_SHIFT=3D14
-# CONFIG_SYSCTL_SYSCALL is not set
 CONFIG_KALLSYMS_EXTRA_PASS=3Dy
 CONFIG_SLAB=3Dy
 CONFIG_MODULES=3Dy
--- a/arch/sh/configs/microdev_defconfig~all-arch-remove-system-call-sys_sy=
sctl
+++ a/arch/sh/configs/microdev_defconfig
@@ -2,7 +2,6 @@ CONFIG_BSD_PROCESS_ACCT=3Dy
 CONFIG_LOG_BUF_SHIFT=3D14
 CONFIG_BLK_DEV_INITRD=3Dy
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-# CONFIG_SYSCTL_SYSCALL is not set
 CONFIG_SLAB=3Dy
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_CPU_SUBTYPE_SH4_202=3Dy
--- a/arch/sh/configs/migor_defconfig~all-arch-remove-system-call-sys_sysctl
+++ a/arch/sh/configs/migor_defconfig
@@ -4,7 +4,6 @@ CONFIG_IKCONFIG_PROC=3Dy
 CONFIG_LOG_BUF_SHIFT=3D14
 CONFIG_BLK_DEV_INITRD=3Dy
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-# CONFIG_SYSCTL_SYSCALL is not set
 CONFIG_SLAB=3Dy
 CONFIG_PROFILING=3Dy
 CONFIG_OPROFILE=3Dy
--- a/arch/sh/configs/r7780mp_defconfig~all-arch-remove-system-call-sys_sys=
ctl
+++ a/arch/sh/configs/r7780mp_defconfig
@@ -3,7 +3,6 @@ CONFIG_BSD_PROCESS_ACCT=3Dy
 CONFIG_IKCONFIG=3Dy
 CONFIG_IKCONFIG_PROC=3Dy
 CONFIG_LOG_BUF_SHIFT=3D14
-# CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
 CONFIG_SLAB=3Dy
--- a/arch/sh/configs/r7785rp_defconfig~all-arch-remove-system-call-sys_sys=
ctl
+++ a/arch/sh/configs/r7785rp_defconfig
@@ -7,7 +7,6 @@ CONFIG_RCU_TRACE=3Dy
 CONFIG_IKCONFIG=3Dy
 CONFIG_IKCONFIG_PROC=3Dy
 CONFIG_LOG_BUF_SHIFT=3D14
-# CONFIG_SYSCTL_SYSCALL is not set
 CONFIG_SLAB=3Dy
 CONFIG_PROFILING=3Dy
 CONFIG_OPROFILE=3Dy
--- a/arch/sh/configs/rts7751r2d1_defconfig~all-arch-remove-system-call-sys=
_sysctl
+++ a/arch/sh/configs/rts7751r2d1_defconfig
@@ -1,7 +1,6 @@
 CONFIG_SYSVIPC=3Dy
 CONFIG_LOG_BUF_SHIFT=3D14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-# CONFIG_SYSCTL_SYSCALL is not set
 CONFIG_SLAB=3Dy
 CONFIG_PROFILING=3Dy
 CONFIG_OPROFILE=3Dy
--- a/arch/sh/configs/rts7751r2dplus_defconfig~all-arch-remove-system-call-=
sys_sysctl
+++ a/arch/sh/configs/rts7751r2dplus_defconfig
@@ -1,7 +1,6 @@
 CONFIG_SYSVIPC=3Dy
 CONFIG_LOG_BUF_SHIFT=3D14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-# CONFIG_SYSCTL_SYSCALL is not set
 CONFIG_SLAB=3Dy
 CONFIG_PROFILING=3Dy
 CONFIG_OPROFILE=3Dy
--- a/arch/sh/configs/se7206_defconfig~all-arch-remove-system-call-sys_sysc=
tl
+++ a/arch/sh/configs/se7206_defconfig
@@ -18,7 +18,6 @@ CONFIG_USER_NS=3Dy
 CONFIG_PID_NS=3Dy
 CONFIG_BLK_DEV_INITRD=3Dy
 # CONFIG_UID16 is not set
-# CONFIG_SYSCTL_SYSCALL is not set
 CONFIG_KALLSYMS_ALL=3Dy
 # CONFIG_ELF_CORE is not set
 # CONFIG_COMPAT_BRK is not set
--- a/arch/sh/configs/se7343_defconfig~all-arch-remove-system-call-sys_sysc=
tl
+++ a/arch/sh/configs/se7343_defconfig
@@ -2,7 +2,6 @@
 CONFIG_SYSVIPC=3Dy
 CONFIG_POSIX_MQUEUE=3Dy
 CONFIG_LOG_BUF_SHIFT=3D14
-# CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
 # CONFIG_SHMEM is not set
--- a/arch/sh/configs/se7619_defconfig~all-arch-remove-system-call-sys_sysc=
tl
+++ a/arch/sh/configs/se7619_defconfig
@@ -1,7 +1,6 @@
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_LOG_BUF_SHIFT=3D14
 # CONFIG_UID16 is not set
-# CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_ELF_CORE is not set
--- a/arch/sh/configs/se7705_defconfig~all-arch-remove-system-call-sys_sysc=
tl
+++ a/arch/sh/configs/se7705_defconfig
@@ -2,7 +2,6 @@
 CONFIG_LOG_BUF_SHIFT=3D14
 CONFIG_BLK_DEV_INITRD=3Dy
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-# CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 CONFIG_SLAB=3Dy
--- a/arch/sh/configs/se7750_defconfig~all-arch-remove-system-call-sys_sysc=
tl
+++ a/arch/sh/configs/se7750_defconfig
@@ -5,7 +5,6 @@ CONFIG_IKCONFIG=3Dy
 CONFIG_IKCONFIG_PROC=3Dy
 CONFIG_LOG_BUF_SHIFT=3D14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-# CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_HOTPLUG is not set
 CONFIG_SLAB=3Dy
 CONFIG_MODULES=3Dy
--- a/arch/sh/configs/se7751_defconfig~all-arch-remove-system-call-sys_sysc=
tl
+++ a/arch/sh/configs/se7751_defconfig
@@ -3,7 +3,6 @@ CONFIG_BSD_PROCESS_ACCT=3Dy
 CONFIG_LOG_BUF_SHIFT=3D14
 CONFIG_BLK_DEV_INITRD=3Dy
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-# CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_HOTPLUG is not set
 CONFIG_SLAB=3Dy
 CONFIG_MODULES=3Dy
--- a/arch/sh/configs/secureedge5410_defconfig~all-arch-remove-system-call-=
sys_sysctl
+++ a/arch/sh/configs/secureedge5410_defconfig
@@ -1,7 +1,6 @@
 # CONFIG_SWAP is not set
 CONFIG_LOG_BUF_SHIFT=3D14
 CONFIG_BLK_DEV_INITRD=3Dy
-# CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_HOTPLUG is not set
 CONFIG_SLAB=3Dy
 # CONFIG_BLK_DEV_BSG is not set
--- a/arch/sh/configs/sh03_defconfig~all-arch-remove-system-call-sys_sysctl
+++ a/arch/sh/configs/sh03_defconfig
@@ -3,7 +3,6 @@ CONFIG_POSIX_MQUEUE=3Dy
 CONFIG_BSD_PROCESS_ACCT=3Dy
 CONFIG_LOG_BUF_SHIFT=3D14
 CONFIG_BLK_DEV_INITRD=3Dy
-# CONFIG_SYSCTL_SYSCALL is not set
 CONFIG_SLAB=3Dy
 CONFIG_PROFILING=3Dy
 CONFIG_OPROFILE=3Dm
--- a/arch/sh/configs/sh7710voipgw_defconfig~all-arch-remove-system-call-sy=
s_sysctl
+++ a/arch/sh/configs/sh7710voipgw_defconfig
@@ -2,7 +2,6 @@
 CONFIG_SYSVIPC=3Dy
 CONFIG_POSIX_MQUEUE=3Dy
 CONFIG_LOG_BUF_SHIFT=3D14
-# CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
 # CONFIG_SHMEM is not set
--- a/arch/sh/configs/sh7757lcr_defconfig~all-arch-remove-system-call-sys_s=
ysctl
+++ a/arch/sh/configs/sh7757lcr_defconfig
@@ -8,7 +8,6 @@ CONFIG_TASK_XACCT=3Dy
 CONFIG_TASK_IO_ACCOUNTING=3Dy
 CONFIG_LOG_BUF_SHIFT=3D14
 CONFIG_BLK_DEV_INITRD=3Dy
-# CONFIG_SYSCTL_SYSCALL is not set
 CONFIG_KALLSYMS_ALL=3Dy
 CONFIG_SLAB=3Dy
 CONFIG_MODULES=3Dy
--- a/arch/sh/configs/sh7763rdp_defconfig~all-arch-remove-system-call-sys_s=
ysctl
+++ a/arch/sh/configs/sh7763rdp_defconfig
@@ -5,7 +5,6 @@ CONFIG_LOG_BUF_SHIFT=3D14
 CONFIG_NAMESPACES=3Dy
 CONFIG_UTS_NS=3Dy
 CONFIG_IPC_NS=3Dy
-# CONFIG_SYSCTL_SYSCALL is not set
 CONFIG_SLAB=3Dy
 CONFIG_PROFILING=3Dy
 CONFIG_OPROFILE=3Dy
--- a/arch/sh/configs/shmin_defconfig~all-arch-remove-system-call-sys_sysctl
+++ a/arch/sh/configs/shmin_defconfig
@@ -1,7 +1,6 @@
 # CONFIG_SWAP is not set
 CONFIG_LOG_BUF_SHIFT=3D14
 # CONFIG_UID16 is not set
-# CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_BUG is not set
--- a/arch/sh/configs/titan_defconfig~all-arch-remove-system-call-sys_sysctl
+++ a/arch/sh/configs/titan_defconfig
@@ -6,7 +6,6 @@ CONFIG_IKCONFIG_PROC=3Dy
 CONFIG_LOG_BUF_SHIFT=3D16
 CONFIG_BLK_DEV_INITRD=3Dy
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-# CONFIG_SYSCTL_SYSCALL is not set
 CONFIG_SLAB=3Dy
 CONFIG_MODULES=3Dy
 CONFIG_MODULE_UNLOAD=3Dy
--- a/arch/sh/kernel/syscalls/syscall.tbl~all-arch-remove-system-call-sys_s=
ysctl
+++ a/arch/sh/kernel/syscalls/syscall.tbl
@@ -156,7 +156,7 @@
 146	common	writev				sys_writev
 147	common	getsid				sys_getsid
 148	common	fdatasync			sys_fdatasync
-149	common	_sysctl				sys_sysctl
+149	common	_sysctl				sys_ni_syscall
 150	common	mlock				sys_mlock
 151	common	munlock				sys_munlock
 152	common	mlockall			sys_mlockall
--- a/arch/sparc/kernel/syscalls/syscall.tbl~all-arch-remove-system-call-sy=
s_sysctl
+++ a/arch/sparc/kernel/syscalls/syscall.tbl
@@ -300,7 +300,7 @@
 249	64	nanosleep		sys_nanosleep
 250	32	mremap			sys_mremap
 250	64	mremap			sys_64_mremap
-251	common	_sysctl			sys_sysctl			compat_sys_sysctl
+251	common	_sysctl			sys_ni_syscall
 252	common	getsid			sys_getsid
 253	common	fdatasync		sys_fdatasync
 254	32	nfsservctl		sys_ni_syscall			sys_nis_syscall
--- a/arch/x86/entry/syscalls/syscall_32.tbl~all-arch-remove-system-call-sy=
s_sysctl
+++ a/arch/x86/entry/syscalls/syscall_32.tbl
@@ -160,7 +160,7 @@
 146	i386	writev			sys_writev			compat_sys_writev
 147	i386	getsid			sys_getsid
 148	i386	fdatasync		sys_fdatasync
-149	i386	_sysctl			sys_sysctl			compat_sys_sysctl
+149	i386	_sysctl			sys_ni_syscall
 150	i386	mlock			sys_mlock
 151	i386	munlock			sys_munlock
 152	i386	mlockall		sys_mlockall
--- a/arch/x86/entry/syscalls/syscall_64.tbl~all-arch-remove-system-call-sy=
s_sysctl
+++ a/arch/x86/entry/syscalls/syscall_64.tbl
@@ -164,7 +164,7 @@
 153	common	vhangup			sys_vhangup
 154	common	modify_ldt		sys_modify_ldt
 155	common	pivot_root		sys_pivot_root
-156	64	_sysctl			sys_sysctl
+156	64	_sysctl			sys_ni_syscall
 157	common	prctl			sys_prctl
 158	common	arch_prctl		sys_arch_prctl
 159	common	adjtimex		sys_adjtimex
--- a/arch/xtensa/kernel/syscalls/syscall.tbl~all-arch-remove-system-call-s=
ys_sysctl
+++ a/arch/xtensa/kernel/syscalls/syscall.tbl
@@ -222,7 +222,7 @@
 204	common	quotactl			sys_quotactl
 # 205 was old nfsservctl
 205	common	nfsservctl			sys_ni_syscall
-206	common	_sysctl				sys_sysctl
+206	common	_sysctl				sys_ni_syscall
 207	common	bdflush				sys_bdflush
 208	common	uname				sys_newuname
 209	common	sysinfo				sys_sysinfo
--- a/include/linux/compat.h~all-arch-remove-system-call-sys_sysctl
+++ a/include/linux/compat.h
@@ -855,7 +855,6 @@ asmlinkage long compat_sys_select(int n,
 asmlinkage long compat_sys_ustat(unsigned dev, struct compat_ustat __user =
*u32);
 asmlinkage long compat_sys_recv(int fd, void __user *buf, compat_size_t le=
n,
 				unsigned flags);
-asmlinkage long compat_sys_sysctl(struct compat_sysctl_args __user *args);
=20
 /* obsolete: fs/readdir.c */
 asmlinkage long compat_sys_old_readdir(unsigned int fd,
--- a/include/linux/syscalls.h~all-arch-remove-system-call-sys_sysctl
+++ a/include/linux/syscalls.h
@@ -48,7 +48,6 @@ struct statfs;
 struct statfs64;
 struct statx;
 struct fsinfo_params;
-struct __sysctl_args;
 struct sysinfo;
 struct timespec;
 struct __kernel_old_timeval;
@@ -1123,7 +1122,6 @@ asmlinkage long sys_send(int, void __use
 asmlinkage long sys_bdflush(int func, long data);
 asmlinkage long sys_oldumount(char __user *name);
 asmlinkage long sys_uselib(const char __user *library);
-asmlinkage long sys_sysctl(struct __sysctl_args __user *args);
 asmlinkage long sys_sysfs(int option,
 				unsigned long arg1, unsigned long arg2);
 asmlinkage long sys_fork(void);
--- a/include/linux/sysctl.h~all-arch-remove-system-call-sys_sysctl
+++ a/include/linux/sysctl.h
@@ -74,15 +74,13 @@ int proc_do_static_key(struct ctl_table
  * sysctl names can be mirrored automatically under /proc/sys.  The
  * procname supplied controls /proc naming.
  *
- * The table's mode will be honoured both for sys_sysctl(2) and
- * proc-fs access.
+ * The table's mode will be honoured for proc-fs access.
  *
  * Leaf nodes in the sysctl tree will be represented by a single file
  * under /proc; non-leaf nodes will be represented by directories.  A
  * null procname disables /proc mirroring at this node.
  *
- * sysctl(2) can automatically manage read and write requests through
- * the sysctl table.  The data and maxlen fields of the ctl_table
+ * The data and maxlen fields of the ctl_table
  * struct enable minimal validation of the values being written to be
  * performed, and the mode field allows minimal authentication.
  *=20
--- a/kernel/Makefile~all-arch-remove-system-call-sys_sysctl
+++ a/kernel/Makefile
@@ -5,7 +5,7 @@
=20
 obj-y     =3D fork.o exec_domain.o panic.o \
 	    cpu.o exit.o softirq.o resource.o \
-	    sysctl.o sysctl_binary.o capability.o ptrace.o user.o \
+	    sysctl.o capability.o ptrace.o user.o \
 	    signal.o sys.o umh.o workqueue.o pid.o task_work.o \
 	    extable.o params.o \
 	    kthread.o sys_ni.o nsproxy.o \
--- a/kernel/sysctl_binary.c
+++ /dev/null
@@ -1,171 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-#include <linux/stat.h>
-#include <linux/sysctl.h>
-#include "../fs/xfs/xfs_sysctl.h"
-#include <linux/sunrpc/debug.h>
-#include <linux/string.h>
-#include <linux/syscalls.h>
-#include <linux/namei.h>
-#include <linux/mount.h>
-#include <linux/fs.h>
-#include <linux/nsproxy.h>
-#include <linux/pid_namespace.h>
-#include <linux/file.h>
-#include <linux/ctype.h>
-#include <linux/netdevice.h>
-#include <linux/kernel.h>
-#include <linux/uuid.h>
-#include <linux/slab.h>
-#include <linux/compat.h>
-
-static ssize_t binary_sysctl(const int *name, int nlen,
-	void __user *oldval, size_t oldlen, void __user *newval, size_t newlen)
-{
-	return -ENOSYS;
-}
-
-static void deprecated_sysctl_warning(const int *name, int nlen)
-{
-	int i;
-
-	/*
-	 * CTL_KERN/KERN_VERSION is used by older glibc and cannot
-	 * ever go away.
-	 */
-	if (nlen >=3D 2 && name[0] =3D=3D CTL_KERN && name[1] =3D=3D KERN_VERSION)
-		return;
-
-	if (printk_ratelimit()) {
-		printk(KERN_INFO
-			"warning: process `%s' used the deprecated sysctl "
-			"system call with ", current->comm);
-		for (i =3D 0; i < nlen; i++)
-			printk(KERN_CONT "%d.", name[i]);
-		printk(KERN_CONT "\n");
-	}
-	return;
-}
-
-#define WARN_ONCE_HASH_BITS 8
-#define WARN_ONCE_HASH_SIZE (1<<WARN_ONCE_HASH_BITS)
-
-static DECLARE_BITMAP(warn_once_bitmap, WARN_ONCE_HASH_SIZE);
-
-#define FNV32_OFFSET 2166136261U
-#define FNV32_PRIME 0x01000193
-
-/*
- * Print each legacy sysctl (approximately) only once.
- * To avoid making the tables non-const use a external
- * hash-table instead.
- * Worst case hash collision: 6, but very rarely.
- * NOTE! We don't use the SMP-safe bit tests. We simply
- * don't care enough.
- */
-static void warn_on_bintable(const int *name, int nlen)
-{
-	int i;
-	u32 hash =3D FNV32_OFFSET;
-
-	for (i =3D 0; i < nlen; i++)
-		hash =3D (hash ^ name[i]) * FNV32_PRIME;
-	hash %=3D WARN_ONCE_HASH_SIZE;
-	if (__test_and_set_bit(hash, warn_once_bitmap))
-		return;
-	deprecated_sysctl_warning(name, nlen);
-}
-
-static ssize_t do_sysctl(int __user *args_name, int nlen,
-	void __user *oldval, size_t oldlen, void __user *newval, size_t newlen)
-{
-	int name[CTL_MAXNAME];
-	int i;
-
-	/* Check args->nlen. */
-	if (nlen < 0 || nlen > CTL_MAXNAME)
-		return -ENOTDIR;
-	/* Read in the sysctl name for simplicity */
-	for (i =3D 0; i < nlen; i++)
-		if (get_user(name[i], args_name + i))
-			return -EFAULT;
-
-	warn_on_bintable(name, nlen);
-
-	return binary_sysctl(name, nlen, oldval, oldlen, newval, newlen);
-}
-
-SYSCALL_DEFINE1(sysctl, struct __sysctl_args __user *, args)
-{
-	struct __sysctl_args tmp;
-	size_t oldlen =3D 0;
-	ssize_t result;
-
-	if (copy_from_user(&tmp, args, sizeof(tmp)))
-		return -EFAULT;
-
-	if (tmp.oldval && !tmp.oldlenp)
-		return -EFAULT;
-
-	if (tmp.oldlenp && get_user(oldlen, tmp.oldlenp))
-		return -EFAULT;
-
-	result =3D do_sysctl(tmp.name, tmp.nlen, tmp.oldval, oldlen,
-			   tmp.newval, tmp.newlen);
-
-	if (result >=3D 0) {
-		oldlen =3D result;
-		result =3D 0;
-	}
-
-	if (tmp.oldlenp && put_user(oldlen, tmp.oldlenp))
-		return -EFAULT;
-
-	return result;
-}
-
-
-#ifdef CONFIG_COMPAT
-
-struct compat_sysctl_args {
-	compat_uptr_t	name;
-	int		nlen;
-	compat_uptr_t	oldval;
-	compat_uptr_t	oldlenp;
-	compat_uptr_t	newval;
-	compat_size_t	newlen;
-	compat_ulong_t	__unused[4];
-};
-
-COMPAT_SYSCALL_DEFINE1(sysctl, struct compat_sysctl_args __user *, args)
-{
-	struct compat_sysctl_args tmp;
-	compat_size_t __user *compat_oldlenp;
-	size_t oldlen =3D 0;
-	ssize_t result;
-
-	if (copy_from_user(&tmp, args, sizeof(tmp)))
-		return -EFAULT;
-
-	if (tmp.oldval && !tmp.oldlenp)
-		return -EFAULT;
-
-	compat_oldlenp =3D compat_ptr(tmp.oldlenp);
-	if (compat_oldlenp && get_user(oldlen, compat_oldlenp))
-		return -EFAULT;
-
-	result =3D do_sysctl(compat_ptr(tmp.name), tmp.nlen,
-			   compat_ptr(tmp.oldval), oldlen,
-			   compat_ptr(tmp.newval), tmp.newlen);
-
-	if (result >=3D 0) {
-		oldlen =3D result;
-		result =3D 0;
-	}
-
-	if (compat_oldlenp && put_user(oldlen, compat_oldlenp))
-		return -EFAULT;
-
-	return result;
-}
-
-#endif /* CONFIG_COMPAT */
--- a/kernel/sys_ni.c~all-arch-remove-system-call-sys_sysctl
+++ a/kernel/sys_ni.c
@@ -371,7 +371,6 @@ COND_SYSCALL(socketcall);
 COND_SYSCALL_COMPAT(socketcall);
=20
 /* compat syscalls for arm64, x86, ... */
-COND_SYSCALL_COMPAT(sysctl);
 COND_SYSCALL_COMPAT(fanotify_mark);
=20
 /* x86 */
--- a/tools/perf/arch/powerpc/entry/syscalls/syscall.tbl~all-arch-remove-sy=
stem-call-sys_sysctl
+++ a/tools/perf/arch/powerpc/entry/syscalls/syscall.tbl
@@ -193,7 +193,7 @@
 146	common	writev				sys_writev			compat_sys_writev
 147	common	getsid				sys_getsid
 148	common	fdatasync			sys_fdatasync
-149	nospu	_sysctl				sys_sysctl			compat_sys_sysctl
+149	nospu	_sysctl				sys_ni_syscall
 150	common	mlock				sys_mlock
 151	common	munlock				sys_munlock
 152	common	mlockall			sys_mlockall
--- a/tools/perf/arch/s390/entry/syscalls/syscall.tbl~all-arch-remove-syste=
m-call-sys_sysctl
+++ a/tools/perf/arch/s390/entry/syscalls/syscall.tbl
@@ -138,7 +138,7 @@
 146  common	writev			sys_writev			compat_sys_writev
 147  common	getsid			sys_getsid			sys_getsid
 148  common	fdatasync		sys_fdatasync			sys_fdatasync
-149  common	_sysctl			sys_sysctl			compat_sys_sysctl
+149  common	_sysctl			sys_ni_syscall
 150  common	mlock			sys_mlock			compat_sys_mlock
 151  common	munlock			sys_munlock			compat_sys_munlock
 152  common	mlockall		sys_mlockall			sys_mlockall
--- a/tools/perf/arch/x86/entry/syscalls/syscall_64.tbl~all-arch-remove-sys=
tem-call-sys_sysctl
+++ a/tools/perf/arch/x86/entry/syscalls/syscall_64.tbl
@@ -164,7 +164,7 @@
 153	common	vhangup			sys_vhangup
 154	common	modify_ldt		sys_modify_ldt
 155	common	pivot_root		sys_pivot_root
-156	64	_sysctl			sys_sysctl
+156	64	_sysctl			sys_ni_syscall
 157	common	prctl			sys_prctl
 158	common	arch_prctl		sys_arch_prctl
 159	common	adjtimex		sys_adjtimex
_

Patches currently in -mm which might be from nixiaoming@huawei.com are

all-arch-remove-system-call-sys_sysctl.patch
