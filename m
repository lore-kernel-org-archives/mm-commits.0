From: akpm@linux-foundation.org
Subject: [merged] cross-arch-dont-corrupt-personality-flags-upon-exec.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:13:52 -0700
Message-ID: <20121005201353.0E41D100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:34492 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567Ab2JEUNz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:13:55 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so235045ggm.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:13:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkosina@suse.cz, chris@zankel.net, davem@davemloft.net, dhowells@redhat.com, egtvedt@samfundet.no, geert@linux-m68k.org, hskinnemoen@gmail.com, jesper.nilsson@axis.com, jonas@southpole.se, lennox.wu@gmail.com, lethal@linux-sh.org, liqin.chen@sunplusct.com, monstr@monstr.eu, msalter@redhat.com, rkuo@codeaurora.org, starvik@axis.com, takata@linux-m32r.org, vapier@gentoo.org, yasutake.koichi@jp.panasonic.com, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: cross-arch: don't corrupt personality flags upon exec()
has been removed from the -mm tree.  Its filename was
     cross-arch-dont-corrupt-personality-flags-upon-exec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiri Kosina <jkosina@suse.cz>
Subject: cross-arch: don't corrupt personality flags upon exec()

Historically, the top three bytes of personality have been used for things
such as ADDR_NO_RANDOMIZE, which made sense only for specific
architectures.

We now however have a flag there that is general no matter the
architecture (UNAME26); generally we have to be careful to preserve the
personality flags across exec().

This patch tries to fix all architectures that forcefully overwrite
personality flags during exec() (ppc32 and s390 have been fixed recently
by commits f9783ec86 and 59e4c3a2f in a similar way already).

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Mark Salter <msalter@redhat.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/include/asm/elf.h      |    3 ++-
 arch/blackfin/include/asm/elf.h   |    3 ++-
 arch/c6x/include/asm/elf.h        |    3 ++-
 arch/cris/include/asm/elf.h       |    3 ++-
 arch/frv/include/asm/elf.h        |    3 ++-
 arch/h8300/include/asm/elf.h      |    3 ++-
 arch/hexagon/include/asm/elf.h    |    3 ++-
 arch/m32r/include/asm/elf.h       |    3 ++-
 arch/m68k/include/asm/elf.h       |    3 ++-
 arch/microblaze/include/asm/elf.h |    3 ++-
 arch/mn10300/include/asm/elf.h    |    3 ++-
 arch/openrisc/include/asm/elf.h   |    3 ++-
 arch/score/include/asm/elf.h      |    2 +-
 arch/sh/include/asm/elf.h         |    3 ++-
 arch/sparc/include/asm/elf_32.h   |    3 ++-
 arch/xtensa/include/asm/elf.h     |    3 ++-
 16 files changed, 31 insertions(+), 16 deletions(-)

diff -puN arch/avr32/include/asm/elf.h~cross-arch-dont-corrupt-personality-flags-upon-exec arch/avr32/include/asm/elf.h
--- a/arch/avr32/include/asm/elf.h~cross-arch-dont-corrupt-personality-flags-upon-exec
+++ a/arch/avr32/include/asm/elf.h
@@ -102,6 +102,7 @@ typedef struct user_fpu_struct elf_fpreg
 
 #define ELF_PLATFORM  (NULL)
 
-#define SET_PERSONALITY(ex) set_personality(PER_LINUX_32BIT)
+#define SET_PERSONALITY(ex) \
+	set_personality(PER_LINUX_32BIT | (current->personality & (~PER_MASK)))
 
 #endif /* __ASM_AVR32_ELF_H */
diff -puN arch/blackfin/include/asm/elf.h~cross-arch-dont-corrupt-personality-flags-upon-exec arch/blackfin/include/asm/elf.h
--- a/arch/blackfin/include/asm/elf.h~cross-arch-dont-corrupt-personality-flags-upon-exec
+++ a/arch/blackfin/include/asm/elf.h
@@ -132,6 +132,7 @@ do {											\
 
 #define ELF_PLATFORM  (NULL)
 
-#define SET_PERSONALITY(ex) set_personality(PER_LINUX)
+#define SET_PERSONALITY(ex) \
+	set_personality(PER_LINUX | (current->personality & (~PER_MASK)))
 
 #endif
diff -puN arch/c6x/include/asm/elf.h~cross-arch-dont-corrupt-personality-flags-upon-exec arch/c6x/include/asm/elf.h
--- a/arch/c6x/include/asm/elf.h~cross-arch-dont-corrupt-personality-flags-upon-exec
+++ a/arch/c6x/include/asm/elf.h
@@ -77,7 +77,8 @@ do {								\
 
 #define ELF_PLATFORM  (NULL)
 
-#define SET_PERSONALITY(ex) set_personality(PER_LINUX)
+#define SET_PERSONALITY(ex) \
+	set_personality(PER_LINUX | (current->personality & (~PER_MASK)))
 
 /* C6X specific section types */
 #define SHT_C6000_UNWIND	0x70000001
diff -puN arch/cris/include/asm/elf.h~cross-arch-dont-corrupt-personality-flags-upon-exec arch/cris/include/asm/elf.h
--- a/arch/cris/include/asm/elf.h~cross-arch-dont-corrupt-personality-flags-upon-exec
+++ a/arch/cris/include/asm/elf.h
@@ -86,6 +86,7 @@ typedef unsigned long elf_fpregset_t;
 
 #define ELF_PLATFORM  (NULL)
 
-#define SET_PERSONALITY(ex) set_personality(PER_LINUX)
+#define SET_PERSONALITY(ex) \
+	set_personality(PER_LINUX | (current->personality & (~PER_MASK)))
 
 #endif
diff -puN arch/frv/include/asm/elf.h~cross-arch-dont-corrupt-personality-flags-upon-exec arch/frv/include/asm/elf.h
--- a/arch/frv/include/asm/elf.h~cross-arch-dont-corrupt-personality-flags-upon-exec
+++ a/arch/frv/include/asm/elf.h
@@ -137,6 +137,7 @@ do {											\
 
 #define ELF_PLATFORM  (NULL)
 
-#define SET_PERSONALITY(ex) set_personality(PER_LINUX)
+#define SET_PERSONALITY(ex) \
+	set_personality(PER_LINUX | (current->personality & (~PER_MASK)))
 
 #endif
diff -puN arch/h8300/include/asm/elf.h~cross-arch-dont-corrupt-personality-flags-upon-exec arch/h8300/include/asm/elf.h
--- a/arch/h8300/include/asm/elf.h~cross-arch-dont-corrupt-personality-flags-upon-exec
+++ a/arch/h8300/include/asm/elf.h
@@ -54,7 +54,8 @@ typedef unsigned long elf_fpregset_t;
 
 #define ELF_PLATFORM  (NULL)
 
-#define SET_PERSONALITY(ex) set_personality(PER_LINUX)
+#define SET_PERSONALITY(ex) \
+	set_personality(PER_LINUX | (current->personality & (~PER_MASK)))
 
 #define R_H8_NONE       0
 #define R_H8_DIR32      1
diff -puN arch/hexagon/include/asm/elf.h~cross-arch-dont-corrupt-personality-flags-upon-exec arch/hexagon/include/asm/elf.h
--- a/arch/hexagon/include/asm/elf.h~cross-arch-dont-corrupt-personality-flags-upon-exec
+++ a/arch/hexagon/include/asm/elf.h
@@ -217,7 +217,8 @@ do {					\
 #define ELF_PLATFORM  (NULL)
 
 #ifdef __KERNEL__
-#define SET_PERSONALITY(ex) set_personality(PER_LINUX)
+#define SET_PERSONALITY(ex) \
+	set_personality(PER_LINUX | (current->personality & (~PER_MASK)))
 #endif
 
 #define ARCH_HAS_SETUP_ADDITIONAL_PAGES 1
diff -puN arch/m32r/include/asm/elf.h~cross-arch-dont-corrupt-personality-flags-upon-exec arch/m32r/include/asm/elf.h
--- a/arch/m32r/include/asm/elf.h~cross-arch-dont-corrupt-personality-flags-upon-exec
+++ a/arch/m32r/include/asm/elf.h
@@ -128,6 +128,7 @@ typedef elf_fpreg_t elf_fpregset_t;
    intent than poking at uname or /proc/cpuinfo.  */
 #define ELF_PLATFORM	(NULL)
 
-#define SET_PERSONALITY(ex) set_personality(PER_LINUX)
+#define SET_PERSONALITY(ex) \
+	set_personality(PER_LINUX | (current->personality & (~PER_MASK)))
 
 #endif  /* _ASM_M32R__ELF_H */
diff -puN arch/m68k/include/asm/elf.h~cross-arch-dont-corrupt-personality-flags-upon-exec arch/m68k/include/asm/elf.h
--- a/arch/m68k/include/asm/elf.h~cross-arch-dont-corrupt-personality-flags-upon-exec
+++ a/arch/m68k/include/asm/elf.h
@@ -113,6 +113,7 @@ typedef struct user_m68kfp_struct elf_fp
 
 #define ELF_PLATFORM  (NULL)
 
-#define SET_PERSONALITY(ex) set_personality(PER_LINUX)
+#define SET_PERSONALITY(ex) \
+	set_personality(PER_LINUX | (current->personality & (~PER_MASK)))
 
 #endif
diff -puN arch/microblaze/include/asm/elf.h~cross-arch-dont-corrupt-personality-flags-upon-exec arch/microblaze/include/asm/elf.h
--- a/arch/microblaze/include/asm/elf.h~cross-arch-dont-corrupt-personality-flags-upon-exec
+++ a/arch/microblaze/include/asm/elf.h
@@ -116,7 +116,8 @@ do {							\
 } while (0)
 
 #ifdef __KERNEL__
-#define SET_PERSONALITY(ex) set_personality(PER_LINUX_32BIT)
+#define SET_PERSONALITY(ex) \
+	set_personality(PER_LINUX_32BIT | (current->personality & (~PER_MASK)))
 #endif
 
 #endif /* __uClinux__ */
diff -puN arch/mn10300/include/asm/elf.h~cross-arch-dont-corrupt-personality-flags-upon-exec arch/mn10300/include/asm/elf.h
--- a/arch/mn10300/include/asm/elf.h~cross-arch-dont-corrupt-personality-flags-upon-exec
+++ a/arch/mn10300/include/asm/elf.h
@@ -151,7 +151,8 @@ do {						\
 #define ELF_PLATFORM  (NULL)
 
 #ifdef __KERNEL__
-#define SET_PERSONALITY(ex) set_personality(PER_LINUX)
+#define SET_PERSONALITY(ex) \
+	set_personality(PER_LINUX | (current->personality & (~PER_MASK)))
 #endif
 
 #endif /* _ASM_ELF_H */
diff -puN arch/openrisc/include/asm/elf.h~cross-arch-dont-corrupt-personality-flags-upon-exec arch/openrisc/include/asm/elf.h
--- a/arch/openrisc/include/asm/elf.h~cross-arch-dont-corrupt-personality-flags-upon-exec
+++ a/arch/openrisc/include/asm/elf.h
@@ -110,7 +110,8 @@ extern void dump_elf_thread(elf_greg_t *
 
 #define ELF_PLATFORM	(NULL)
 
-#define SET_PERSONALITY(ex) set_personality(PER_LINUX)
+#define SET_PERSONALITY(ex) \
+	set_personality(PER_LINUX | (current->personality & (~PER_MASK)))
 
 #endif /* __KERNEL__ */
 #endif
diff -puN arch/score/include/asm/elf.h~cross-arch-dont-corrupt-personality-flags-upon-exec arch/score/include/asm/elf.h
--- a/arch/score/include/asm/elf.h~cross-arch-dont-corrupt-personality-flags-upon-exec
+++ a/arch/score/include/asm/elf.h
@@ -54,7 +54,7 @@ typedef elf_fpreg_t	elf_fpregset_t;
 
 #define SET_PERSONALITY(ex)					\
 do {								\
-	set_personality(PER_LINUX);				\
+	set_personality(PER_LINUX | (current->personality & (~PER_MASK))); \
 } while (0)
 
 struct task_struct;
diff -puN arch/sh/include/asm/elf.h~cross-arch-dont-corrupt-personality-flags-upon-exec arch/sh/include/asm/elf.h
--- a/arch/sh/include/asm/elf.h~cross-arch-dont-corrupt-personality-flags-upon-exec
+++ a/arch/sh/include/asm/elf.h
@@ -183,7 +183,8 @@ do {									\
 } while (0)
 #endif
 
-#define SET_PERSONALITY(ex) set_personality(PER_LINUX_32BIT)
+#define SET_PERSONALITY(ex) \
+	set_personality(PER_LINUX_32BIT | (current->personality & (~PER_MASK)))
 
 #ifdef CONFIG_VSYSCALL
 /* vDSO has arch_setup_additional_pages */
diff -puN arch/sparc/include/asm/elf_32.h~cross-arch-dont-corrupt-personality-flags-upon-exec arch/sparc/include/asm/elf_32.h
--- a/arch/sparc/include/asm/elf_32.h~cross-arch-dont-corrupt-personality-flags-upon-exec
+++ a/arch/sparc/include/asm/elf_32.h
@@ -128,6 +128,7 @@ typedef struct {
 
 #define ELF_PLATFORM	(NULL)
 
-#define SET_PERSONALITY(ex) set_personality(PER_LINUX)
+#define SET_PERSONALITY(ex) \
+	set_personality(PER_LINUX | (current->personality & (~PER_MASK)))
 
 #endif /* !(__ASMSPARC_ELF_H) */
diff -puN arch/xtensa/include/asm/elf.h~cross-arch-dont-corrupt-personality-flags-upon-exec arch/xtensa/include/asm/elf.h
--- a/arch/xtensa/include/asm/elf.h~cross-arch-dont-corrupt-personality-flags-upon-exec
+++ a/arch/xtensa/include/asm/elf.h
@@ -189,7 +189,8 @@ typedef struct {
 #endif
 } elf_xtregs_t;
 
-#define SET_PERSONALITY(ex) set_personality(PER_LINUX_32BIT)
+#define SET_PERSONALITY(ex) \
+	set_personality(PER_LINUX_32BIT | (current->personality & (~PER_MASK)))
 
 struct task_struct;
 
_

Patches currently in -mm which might be from jkosina@suse.cz are

origin.patch
linux-next.patch
memorytxt-remove-stray-information.patch
cpu-hotplug-debug-detect-imbalance-between-get_online_cpus-and-put_online_cpus.patch
cpu-hotplug-debug-detect-imbalance-between-get_online_cpus-and-put_online_cpus-fix.patch

