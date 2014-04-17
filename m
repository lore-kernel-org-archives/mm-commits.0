From: akpm@linux-foundation.org
Subject: + sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall.patch
 added to -mm tree
Date: Thu, 17 Apr 2014 13:51:13 -0700
Message-ID: <53503ec1.AWQ305Qltj1yLjF3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60132 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaDQUvP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Apr 2014 16:51:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yasutake.koichi@jp.panasonic.com, tglx@linutronix.de, starvik@axis.com, realmz6@gmail.com, ralf@linux-mips.org, paulus@samba.org, oleg@redhat.com, monstr@monstr.eu, mingo@redhat.com, jesper.nilsson@axis.com, jejb@parisc-linux.org, hpa@zytor.com, heiko.carstens@de.ibm.com, gerg@uclinux.org, geert@linux-m68k.org, dhowells@redhat.com, deller@gmx.de, davem@davemloft.net, benh@kernel.crashing.org, fabf@skynet.be

Subject: + sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall.patch added to -mm tree
To: fabf@skynet.be,benh@kernel.crashing.org,davem@davemloft.net,deller@gmx.de,dhowells@redhat.com,geert@linux-m68k.org,gerg@uclinux.org,heiko.carstens@de.ibm.com,hpa@zytor.com,jejb@parisc-linux.org,jesper.nilsson@axis.com,mingo@redhat.com,monstr@monstr.eu,oleg@redhat.com,paulus@samba.org,ralf@linux-mips.org,realmz6@gmail.com,starvik@axis.com,tglx@linutronix.de,yasutake.koichi@jp.panasonic.com
From: akpm@linux-foundation.org
Date: Thu, 17 Apr 2014 13:51:13 -0700


The patch titled
     Subject: sys_sgetmask/sys_ssetmask: add CONFIG_SGETMASK_SYSCALL
has been added to the -mm tree.  Its filename is
     sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: sys_sgetmask/sys_ssetmask: add CONFIG_SGETMASK_SYSCALL

sys_sgetmask and sys_ssetmask are obsolete system calls no longer
supported in libc.

This patch replaces architecture related __ARCH_WANT_SYS_SGETMAX by expert
mode configuration.That option is enabled by default for those
architectures.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Steven Miao <realmz6@gmail.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/include/asm/unistd.h   |    1 -
 arch/cris/include/asm/unistd.h       |    1 -
 arch/frv/include/asm/unistd.h        |    1 -
 arch/m68k/include/asm/unistd.h       |    1 -
 arch/microblaze/include/asm/unistd.h |    1 -
 arch/mips/include/asm/unistd.h       |    1 -
 arch/mn10300/include/asm/unistd.h    |    1 -
 arch/parisc/include/asm/unistd.h     |    1 -
 arch/powerpc/include/asm/unistd.h    |    1 -
 arch/sh/include/asm/unistd.h         |    1 -
 arch/sparc/include/asm/unistd.h      |    1 -
 arch/x86/include/asm/unistd.h        |    1 -
 init/Kconfig                         |   10 ++++++++++
 kernel/signal.c                      |    4 ++--
 kernel/sys_ni.c                      |    2 ++
 15 files changed, 14 insertions(+), 14 deletions(-)

diff -puN arch/blackfin/include/asm/unistd.h~sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall arch/blackfin/include/asm/unistd.h
--- a/arch/blackfin/include/asm/unistd.h~sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall
+++ a/arch/blackfin/include/asm/unistd.h
@@ -12,7 +12,6 @@
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
 #define __ARCH_WANT_SYS_PAUSE
-#define __ARCH_WANT_SYS_SGETMASK
 #define __ARCH_WANT_SYS_TIME
 #define __ARCH_WANT_SYS_FADVISE64
 #define __ARCH_WANT_SYS_GETPGRP
diff -puN arch/cris/include/asm/unistd.h~sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall arch/cris/include/asm/unistd.h
--- a/arch/cris/include/asm/unistd.h~sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall
+++ a/arch/cris/include/asm/unistd.h
@@ -15,7 +15,6 @@
 #define __ARCH_WANT_SYS_GETHOSTNAME
 #define __ARCH_WANT_SYS_IPC
 #define __ARCH_WANT_SYS_PAUSE
-#define __ARCH_WANT_SYS_SGETMASK
 #define __ARCH_WANT_SYS_SIGNAL
 #define __ARCH_WANT_SYS_TIME
 #define __ARCH_WANT_SYS_UTIME
diff -puN arch/frv/include/asm/unistd.h~sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall arch/frv/include/asm/unistd.h
--- a/arch/frv/include/asm/unistd.h~sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall
+++ a/arch/frv/include/asm/unistd.h
@@ -13,7 +13,6 @@
 /* #define __ARCH_WANT_SYS_GETHOSTNAME */
 #define __ARCH_WANT_SYS_IPC
 #define __ARCH_WANT_SYS_PAUSE
-/* #define __ARCH_WANT_SYS_SGETMASK */
 /* #define __ARCH_WANT_SYS_SIGNAL */
 #define __ARCH_WANT_SYS_TIME
 #define __ARCH_WANT_SYS_UTIME
diff -puN arch/m68k/include/asm/unistd.h~sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall arch/m68k/include/asm/unistd.h
--- a/arch/m68k/include/asm/unistd.h~sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall
+++ a/arch/m68k/include/asm/unistd.h
@@ -13,7 +13,6 @@
 #define __ARCH_WANT_SYS_GETHOSTNAME
 #define __ARCH_WANT_SYS_IPC
 #define __ARCH_WANT_SYS_PAUSE
-#define __ARCH_WANT_SYS_SGETMASK
 #define __ARCH_WANT_SYS_SIGNAL
 #define __ARCH_WANT_SYS_TIME
 #define __ARCH_WANT_SYS_UTIME
diff -puN arch/microblaze/include/asm/unistd.h~sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall arch/microblaze/include/asm/unistd.h
--- a/arch/microblaze/include/asm/unistd.h~sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall
+++ a/arch/microblaze/include/asm/unistd.h
@@ -19,7 +19,6 @@
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
 #define __ARCH_WANT_SYS_PAUSE
-#define __ARCH_WANT_SYS_SGETMASK
 #define __ARCH_WANT_SYS_SIGNAL
 #define __ARCH_WANT_SYS_TIME
 #define __ARCH_WANT_SYS_UTIME
diff -puN arch/mips/include/asm/unistd.h~sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall arch/mips/include/asm/unistd.h
--- a/arch/mips/include/asm/unistd.h~sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall
+++ a/arch/mips/include/asm/unistd.h
@@ -29,7 +29,6 @@
 #define __ARCH_WANT_SYS_GETHOSTNAME
 #define __ARCH_WANT_SYS_IPC
 #define __ARCH_WANT_SYS_PAUSE
-#define __ARCH_WANT_SYS_SGETMASK
 #define __ARCH_WANT_SYS_UTIME
 #define __ARCH_WANT_SYS_WAITPID
 #define __ARCH_WANT_SYS_SOCKETCALL
diff -puN arch/mn10300/include/asm/unistd.h~sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall arch/mn10300/include/asm/unistd.h
--- a/arch/mn10300/include/asm/unistd.h~sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall
+++ a/arch/mn10300/include/asm/unistd.h
@@ -26,7 +26,6 @@
 #define __ARCH_WANT_SYS_GETHOSTNAME
 #define __ARCH_WANT_SYS_IPC
 #define __ARCH_WANT_SYS_PAUSE
-#define __ARCH_WANT_SYS_SGETMASK
 #define __ARCH_WANT_SYS_SIGNAL
 #define __ARCH_WANT_SYS_TIME
 #define __ARCH_WANT_SYS_UTIME
diff -puN arch/parisc/include/asm/unistd.h~sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall arch/parisc/include/asm/unistd.h
--- a/arch/parisc/include/asm/unistd.h~sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall
+++ a/arch/parisc/include/asm/unistd.h
@@ -145,7 +145,6 @@ type name(type1 arg1, type2 arg2, type3
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
 #define __ARCH_WANT_SYS_PAUSE
-#define __ARCH_WANT_SYS_SGETMASK
 #define __ARCH_WANT_SYS_SIGNAL
 #define __ARCH_WANT_SYS_TIME
 #define __ARCH_WANT_COMPAT_SYS_TIME
diff -puN arch/powerpc/include/asm/unistd.h~sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall arch/powerpc/include/asm/unistd.h
--- a/arch/powerpc/include/asm/unistd.h~sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall
+++ a/arch/powerpc/include/asm/unistd.h
@@ -29,7 +29,6 @@
 #define __ARCH_WANT_SYS_GETHOSTNAME
 #define __ARCH_WANT_SYS_IPC
 #define __ARCH_WANT_SYS_PAUSE
-#define __ARCH_WANT_SYS_SGETMASK
 #define __ARCH_WANT_SYS_SIGNAL
 #define __ARCH_WANT_SYS_TIME
 #define __ARCH_WANT_SYS_UTIME
diff -puN arch/sh/include/asm/unistd.h~sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall arch/sh/include/asm/unistd.h
--- a/arch/sh/include/asm/unistd.h~sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall
+++ a/arch/sh/include/asm/unistd.h
@@ -11,7 +11,6 @@
 # define __ARCH_WANT_SYS_GETHOSTNAME
 # define __ARCH_WANT_SYS_IPC
 # define __ARCH_WANT_SYS_PAUSE
-# define __ARCH_WANT_SYS_SGETMASK
 # define __ARCH_WANT_SYS_SIGNAL
 # define __ARCH_WANT_SYS_TIME
 # define __ARCH_WANT_SYS_UTIME
diff -puN arch/sparc/include/asm/unistd.h~sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall arch/sparc/include/asm/unistd.h
--- a/arch/sparc/include/asm/unistd.h~sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall
+++ a/arch/sparc/include/asm/unistd.h
@@ -25,7 +25,6 @@
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
 #define __ARCH_WANT_SYS_PAUSE
-#define __ARCH_WANT_SYS_SGETMASK
 #define __ARCH_WANT_SYS_SIGNAL
 #define __ARCH_WANT_SYS_TIME
 #define __ARCH_WANT_SYS_UTIME
diff -puN arch/x86/include/asm/unistd.h~sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall arch/x86/include/asm/unistd.h
--- a/arch/x86/include/asm/unistd.h~sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall
+++ a/arch/x86/include/asm/unistd.h
@@ -41,7 +41,6 @@
 # define __ARCH_WANT_SYS_OLD_GETRLIMIT
 # define __ARCH_WANT_SYS_OLD_UNAME
 # define __ARCH_WANT_SYS_PAUSE
-# define __ARCH_WANT_SYS_SGETMASK
 # define __ARCH_WANT_SYS_SIGNAL
 # define __ARCH_WANT_SYS_SIGPENDING
 # define __ARCH_WANT_SYS_SIGPROCMASK
diff -puN init/Kconfig~sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall init/Kconfig
--- a/init/Kconfig~sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall
+++ a/init/Kconfig
@@ -1304,6 +1304,16 @@ config UID16
 	help
 	  This enables the legacy 16-bit UID syscall wrappers.
 
+config SGETMASK_SYSCALL
+	bool "sgetmask/ssetmask syscalls support" if EXPERT
+	def_bool PARISC || MN10300 || BLACKFIN || M68K || PPC || MIPS || X86 || SPARC || CRIS || MICROBLAZE || SUPERH
+	---help---
+	  sys_sgetmask and sys_ssetmask are obsolete system calls
+	  no longer supported in libc but still enabled by default in some
+	  architectures.
+
+	  If unsure, leave the default option here.
+
 config SYSFS_SYSCALL
 	bool "Sysfs syscall support" if EXPERT
 	default y
diff -puN kernel/signal.c~sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall kernel/signal.c
--- a/kernel/signal.c~sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall
+++ a/kernel/signal.c
@@ -3496,7 +3496,7 @@ COMPAT_SYSCALL_DEFINE3(sigaction, int, s
 }
 #endif
 
-#ifdef __ARCH_WANT_SYS_SGETMASK
+#ifdef CONFIG_SGETMASK_SYSCALL
 
 /*
  * For backwards compatibility.  Functionality superseded by sigprocmask.
@@ -3517,7 +3517,7 @@ SYSCALL_DEFINE1(ssetmask, int, newmask)
 
 	return old;
 }
-#endif /* __ARCH_WANT_SGETMASK */
+#endif /* CONFIG_SGETMASK_SYSCALL */
 
 #ifdef __ARCH_WANT_SYS_SIGNAL
 /*
diff -puN kernel/sys_ni.c~sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall kernel/sys_ni.c
--- a/kernel/sys_ni.c~sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall
+++ a/kernel/sys_ni.c
@@ -135,6 +135,8 @@ cond_syscall(sys_setresgid16);
 cond_syscall(sys_setresuid16);
 cond_syscall(sys_setreuid16);
 cond_syscall(sys_setuid16);
+cond_syscall(sys_sgetmask);
+cond_syscall(sys_ssetmask);
 cond_syscall(sys_vm86old);
 cond_syscall(sys_vm86);
 cond_syscall(sys_ipc);
_

Patches currently in -mm which might be from fabf@skynet.be are

ntfs-remove-null-value-assignments.patch
ocfs2-remove-null-assignments-on-static.patch
fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch
sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall.patch
fs-binfmt_elfc-fix-bool-assignements.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
linux-next.patch
ufs-sb-mutex-merge-mutex_destroy.patch

