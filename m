From: akpm@linux-foundation.org
Subject: [merged]
 arch-define-cpu_big_endian-for-all-fixed-big-endian-archs.patch removed
 from -mm tree
Date: Mon, 11 Sep 2017 12:41:16 -0700
Message-ID: <20170911194116.fXlwX4SZg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49818 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751027AbdIKTlS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:41:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, babu.moger@oracle.com, davem@davemloft.net, deller@gmx.de, geert@linux-m68k.org, gregkh@linuxfoundation.org, jcmvbkbc@gmail.com, jejb@parisc-linux.org, jonas@southpole.se, mingo@elte.hu, mm-commits@vger.kernel.org, monstr@monstr.eu, mpe@ellerman.id.au, peterz@infradead.org, shorne@gmail.com, stefan.kristiansson@saunalahti.fi, viro@zeniv.linux.org.uk, ysato@users.sourceforge.jp


The patch titled
     Subject: arch: define CPU_BIG_ENDIAN for all fixed big endian archs
has been removed from the -mm tree.  Its filename was
     arch-define-cpu_big_endian-for-all-fixed-big-endian-archs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Babu Moger <babu.moger@oracle.com>
Subject: arch: define CPU_BIG_ENDIAN for all fixed big endian archs

Patch series "Define CPU_BIG_ENDIAN or warn for inconsistencies", v3.

While working on enabling queued rwlock on SPARC, found this following
code in include/asm-generic/qrwlock.h which uses CONFIG_CPU_BIG_ENDIAN to
clear a byte.

static inline u8 *__qrwlock_write_byte(struct qrwlock *lock)
 {
	return (u8 *)lock + 3 * IS_BUILTIN(CONFIG_CPU_BIG_ENDIAN);
 }

Problem is many of the fixed big endian architectures don't define
CPU_BIG_ENDIAN and clears the wrong byte.

Define CPU_BIG_ENDIAN for all the fixed big endian architecture to fix it.

Also found few more references of this config parameter in
drivers/of/base.c
drivers/of/fdt.c
drivers/tty/serial/earlycon.c
drivers/tty/serial/serial_core.c
Be aware that this may cause regressions if someone has worked-around
problems in the above code already. Remove the work-around.

Here is our original discussion
https://lkml.org/lkml/2017/5/24/620

Link: http://lkml.kernel.org/r/1499358861-179979-2-git-send-email-babu.moger@oracle.com
Signed-off-by: Babu Moger <babu.moger@oracle.com>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Stafford Horne <shorne@gmail.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/Kconfig      |    3 +++
 arch/h8300/Kconfig    |    3 +++
 arch/m68k/Kconfig     |    3 +++
 arch/openrisc/Kconfig |    3 +++
 arch/parisc/Kconfig   |    3 +++
 arch/sparc/Kconfig    |    3 +++
 6 files changed, 18 insertions(+)

diff -puN arch/frv/Kconfig~arch-define-cpu_big_endian-for-all-fixed-big-endian-archs arch/frv/Kconfig
--- a/arch/frv/Kconfig~arch-define-cpu_big_endian-for-all-fixed-big-endian-archs
+++ a/arch/frv/Kconfig
@@ -17,6 +17,9 @@ config FRV
 	select HAVE_DEBUG_STACKOVERFLOW
 	select ARCH_NO_COHERENT_DMA_MMAP
 
+config CPU_BIG_ENDIAN
+	def_bool y
+
 config ZONE_DMA
 	bool
 	default y
diff -puN arch/h8300/Kconfig~arch-define-cpu_big_endian-for-all-fixed-big-endian-archs arch/h8300/Kconfig
--- a/arch/h8300/Kconfig~arch-define-cpu_big_endian-for-all-fixed-big-endian-archs
+++ a/arch/h8300/Kconfig
@@ -23,6 +23,9 @@ config H8300
 	select HAVE_ARCH_HASH
 	select CPU_NO_EFFICIENT_FFS
 
+config CPU_BIG_ENDIAN
+	def_bool y
+
 config RWSEM_GENERIC_SPINLOCK
 	def_bool y
 
diff -puN arch/m68k/Kconfig~arch-define-cpu_big_endian-for-all-fixed-big-endian-archs arch/m68k/Kconfig
--- a/arch/m68k/Kconfig~arch-define-cpu_big_endian-for-all-fixed-big-endian-archs
+++ a/arch/m68k/Kconfig
@@ -24,6 +24,9 @@ config M68K
 	select OLD_SIGSUSPEND3
 	select OLD_SIGACTION
 
+config CPU_BIG_ENDIAN
+	def_bool y
+
 config RWSEM_GENERIC_SPINLOCK
 	bool
 	default y
diff -puN arch/openrisc/Kconfig~arch-define-cpu_big_endian-for-all-fixed-big-endian-archs arch/openrisc/Kconfig
--- a/arch/openrisc/Kconfig~arch-define-cpu_big_endian-for-all-fixed-big-endian-archs
+++ a/arch/openrisc/Kconfig
@@ -29,6 +29,9 @@ config OPENRISC
 	select CPU_NO_EFFICIENT_FFS if !OPENRISC_HAVE_INST_FF1
 	select NO_BOOTMEM
 
+config CPU_BIG_ENDIAN
+	def_bool y
+
 config MMU
 	def_bool y
 
diff -puN arch/parisc/Kconfig~arch-define-cpu_big_endian-for-all-fixed-big-endian-archs arch/parisc/Kconfig
--- a/arch/parisc/Kconfig~arch-define-cpu_big_endian-for-all-fixed-big-endian-archs
+++ a/arch/parisc/Kconfig
@@ -59,6 +59,9 @@ config PARISC
 config CPU_BIG_ENDIAN
 	def_bool y
 
+config CPU_BIG_ENDIAN
+	def_bool y
+
 config MMU
 	def_bool y
 
diff -puN arch/sparc/Kconfig~arch-define-cpu_big_endian-for-all-fixed-big-endian-archs arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~arch-define-cpu_big_endian-for-all-fixed-big-endian-archs
+++ a/arch/sparc/Kconfig
@@ -97,6 +97,9 @@ config ARCH_PROC_KCORE_TEXT
 config CPU_BIG_ENDIAN
 	def_bool y
 
+config CPU_BIG_ENDIAN
+	def_bool y
+
 config ARCH_ATU
 	bool
 	default y if SPARC64
_

Patches currently in -mm which might be from babu.moger@oracle.com are


