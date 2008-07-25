From: akpm@linux-foundation.org
Subject: - include-asm-ptraceh-userspace-headers-cleanup.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:59:39 -0700
Message-ID: <200807252259.m6PMxdTD003406@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53906 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752945AbYGYXCZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:02:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, chris@zankel.net, dhowells@redhat.com, gerg@uclinux.org, grundler@parisc-linux.org, jesper.nilsson@axis.com, lethal@linux-sh.org, linux-arch@vger.kernel.org, oleg@tv-


The patch titled
     include/asm/ptrace.h userspace headers cleanup
has been removed from the -mm tree.  Its filename was
     include-asm-ptraceh-userspace-headers-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include/asm/ptrace.h userspace headers cleanup
From: Adrian Bunk <bunk@kernel.org>

This patch contains the following cleanups for the asm/ptrace.h
userspace headers:

- include/asm-generic/Kbuild.asm already lists ptrace.h, remove
  the superfluous listings in the Kbuild files of the following
  architectures:
  - cris
  - frv
  - powerpc
  - x86
- don't expose function prototypes and macros to userspace:
  - arm
  - blackfin
  - cris
  - mn10300
  - parisc
- remove #ifdef CONFIG_'s around #define's:
  - blackfin
  - m68knommu
- sh: AFAIK __SH5__ should work in both kernel and userspace,
      no need to leak CONFIG_SUPERH64 to userspace
- xtensa: cosmetical change to remove empty
            #ifndef __ASSEMBLY__ #else #endif
          from the userspace headers

Not changed by this patch is the fact that the following architectures
have a different struct pt_regs depending on CONFIG_ variables:
- h8300
- m68knommu
- mips

This does not work in userspace.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: <linux-arch@vger.kernel.org>
Cc: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Acked-by: Grant Grundler <grundler@parisc-linux.org>
Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
Acked-by: Chris Zankel <chris@zankel.net>
Acked-by: David Howells <dhowells@redhat.com>
Acked-by: Paul Mackerras <paulus@samba.org>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-arm/ptrace.h           |    6 ++----
 include/asm-blackfin/ptrace.h      |    6 ++++--
 include/asm-cris/arch-v10/Kbuild   |    1 -
 include/asm-cris/arch-v10/ptrace.h |    4 ++++
 include/asm-cris/arch-v32/Kbuild   |    1 -
 include/asm-cris/arch-v32/ptrace.h |    4 ++++
 include/asm-cris/ptrace.h          |    4 +++-
 include/asm-frv/Kbuild             |    1 -
 include/asm-m68knommu/ptrace.h     |    2 --
 include/asm-mn10300/ptrace.h       |    8 ++++++--
 include/asm-parisc/ptrace.h        |    4 +++-
 include/asm-powerpc/Kbuild         |    1 -
 include/asm-sh/ptrace.h            |    2 +-
 include/asm-x86/Kbuild             |    1 -
 include/asm-xtensa/ptrace.h        |   10 +++++-----
 15 files changed, 32 insertions(+), 23 deletions(-)

diff -puN include/asm-arm/ptrace.h~include-asm-ptraceh-userspace-headers-cleanup include/asm-arm/ptrace.h
--- a/include/asm-arm/ptrace.h~include-asm-ptraceh-userspace-headers-cleanup
+++ a/include/asm-arm/ptrace.h
@@ -139,8 +139,6 @@ static inline int valid_user_regs(struct
 	return 0;
 }
 
-#endif	/* __KERNEL__ */
-
 #define pc_pointer(v) \
 	((v) & ~PCMASK)
 
@@ -153,10 +151,10 @@ extern unsigned long profile_pc(struct p
 #define profile_pc(regs) instruction_pointer(regs)
 #endif
 
-#ifdef __KERNEL__
 #define predicate(x)		((x) & 0xf0000000)
 #define PREDICATE_ALWAYS	0xe0000000
-#endif
+
+#endif /* __KERNEL__ */
 
 #endif /* __ASSEMBLY__ */
 
diff -puN include/asm-blackfin/ptrace.h~include-asm-ptraceh-userspace-headers-cleanup include/asm-blackfin/ptrace.h
--- a/include/asm-blackfin/ptrace.h~include-asm-ptraceh-userspace-headers-cleanup
+++ a/include/asm-blackfin/ptrace.h
@@ -83,14 +83,14 @@ struct pt_regs {
 #define PTRACE_GETREGS            12
 #define PTRACE_SETREGS            13	/* ptrace signal  */
 
-#ifdef CONFIG_BINFMT_ELF_FDPIC
 #define PTRACE_GETFDPIC           31
 #define PTRACE_GETFDPIC_EXEC      0
 #define PTRACE_GETFDPIC_INTERP    1
-#endif
 
 #define PS_S  (0x0002)
 
+#ifdef __KERNEL__
+
 /* user_mode returns true if only one bit is set in IPEND, other than the
    master interrupt enable.  */
 #define user_mode(regs) (!(((regs)->ipend & ~0x10) & (((regs)->ipend & ~0x10) - 1)))
@@ -98,6 +98,8 @@ struct pt_regs {
 #define profile_pc(regs) instruction_pointer(regs)
 extern void show_regs(struct pt_regs *);
 
+#endif  /*  __KERNEL__  */
+
 #endif				/* __ASSEMBLY__ */
 
 /*
diff -puN include/asm-cris/arch-v10/Kbuild~include-asm-ptraceh-userspace-headers-cleanup include/asm-cris/arch-v10/Kbuild
--- a/include/asm-cris/arch-v10/Kbuild~include-asm-ptraceh-userspace-headers-cleanup
+++ a/include/asm-cris/arch-v10/Kbuild
@@ -1,4 +1,3 @@
-header-y += ptrace.h
 header-y += user.h
 header-y += svinto.h
 header-y += sv_addr_ag.h
diff -puN include/asm-cris/arch-v10/ptrace.h~include-asm-ptraceh-userspace-headers-cleanup include/asm-cris/arch-v10/ptrace.h
--- a/include/asm-cris/arch-v10/ptrace.h~include-asm-ptraceh-userspace-headers-cleanup
+++ a/include/asm-cris/arch-v10/ptrace.h
@@ -106,10 +106,14 @@ struct switch_stack {
 	unsigned long return_ip; /* ip that _resume will return to */
 };
 
+#ifdef __KERNEL__
+
 /* bit 8 is user-mode flag */
 #define user_mode(regs) (((regs)->dccr & 0x100) != 0)
 #define instruction_pointer(regs) ((regs)->irp)
 #define profile_pc(regs) instruction_pointer(regs)
 extern void show_regs(struct pt_regs *);
 
+#endif  /*  __KERNEL__  */
+
 #endif
diff -puN include/asm-cris/arch-v32/Kbuild~include-asm-ptraceh-userspace-headers-cleanup include/asm-cris/arch-v32/Kbuild
--- a/include/asm-cris/arch-v32/Kbuild~include-asm-ptraceh-userspace-headers-cleanup
+++ a/include/asm-cris/arch-v32/Kbuild
@@ -1,3 +1,2 @@
-header-y += ptrace.h
 header-y += user.h
 header-y += cryptocop.h
diff -puN include/asm-cris/arch-v32/ptrace.h~include-asm-ptraceh-userspace-headers-cleanup include/asm-cris/arch-v32/ptrace.h
--- a/include/asm-cris/arch-v32/ptrace.h~include-asm-ptraceh-userspace-headers-cleanup
+++ a/include/asm-cris/arch-v32/ptrace.h
@@ -106,9 +106,13 @@ struct switch_stack {
 	unsigned long return_ip; /* ip that _resume will return to */
 };
 
+#ifdef __KERNEL__
+
 #define user_mode(regs) (((regs)->ccs & (1 << (U_CCS_BITNR + CCS_SHIFT))) != 0)
 #define instruction_pointer(regs) ((regs)->erp)
 extern void show_regs(struct pt_regs *);
 #define profile_pc(regs) instruction_pointer(regs)
 
+#endif  /*  __KERNEL__  */
+
 #endif
diff -puN include/asm-cris/ptrace.h~include-asm-ptraceh-userspace-headers-cleanup include/asm-cris/ptrace.h
--- a/include/asm-cris/ptrace.h~include-asm-ptraceh-userspace-headers-cleanup
+++ a/include/asm-cris/ptrace.h
@@ -4,11 +4,13 @@
 #include <asm/arch/ptrace.h>
 
 #ifdef __KERNEL__
+
 /* Arbitrarily choose the same ptrace numbers as used by the Sparc code. */
 #define PTRACE_GETREGS            12
 #define PTRACE_SETREGS            13
-#endif
 
 #define profile_pc(regs) instruction_pointer(regs)
 
+#endif /* __KERNEL__ */
+
 #endif /* _CRIS_PTRACE_H */
diff -puN include/asm-frv/Kbuild~include-asm-ptraceh-userspace-headers-cleanup include/asm-frv/Kbuild
--- a/include/asm-frv/Kbuild~include-asm-ptraceh-userspace-headers-cleanup
+++ a/include/asm-frv/Kbuild
@@ -3,4 +3,3 @@ include include/asm-generic/Kbuild.asm
 header-y += registers.h
 
 unifdef-y += termios.h
-unifdef-y += ptrace.h
diff -puN include/asm-m68knommu/ptrace.h~include-asm-ptraceh-userspace-headers-cleanup include/asm-m68knommu/ptrace.h
--- a/include/asm-m68knommu/ptrace.h~include-asm-ptraceh-userspace-headers-cleanup
+++ a/include/asm-m68knommu/ptrace.h
@@ -68,10 +68,8 @@ struct switch_stack {
 /* Arbitrarily choose the same ptrace numbers as used by the Sparc code. */
 #define PTRACE_GETREGS            12
 #define PTRACE_SETREGS            13
-#ifdef CONFIG_FPU
 #define PTRACE_GETFPREGS          14
 #define PTRACE_SETFPREGS          15
-#endif
 
 #ifdef __KERNEL__
 
diff -puN include/asm-mn10300/ptrace.h~include-asm-ptraceh-userspace-headers-cleanup include/asm-mn10300/ptrace.h
--- a/include/asm-mn10300/ptrace.h~include-asm-ptraceh-userspace-headers-cleanup
+++ a/include/asm-mn10300/ptrace.h
@@ -88,12 +88,16 @@ extern struct pt_regs *__frame; /* curre
 /* options set using PTRACE_SETOPTIONS */
 #define PTRACE_O_TRACESYSGOOD     0x00000001
 
-#if defined(__KERNEL__) && !defined(__ASSEMBLY__)
+#if defined(__KERNEL__)
+
+#if !defined(__ASSEMBLY__)
 #define user_mode(regs)			(((regs)->epsw & EPSW_nSL) == EPSW_nSL)
 #define instruction_pointer(regs)	((regs)->pc)
 extern void show_regs(struct pt_regs *);
-#endif
+#endif  /*  !__ASSEMBLY  */
 
 #define profile_pc(regs) ((regs)->pc)
 
+#endif  /*  __KERNEL__  */
+
 #endif /* _ASM_PTRACE_H */
diff -puN include/asm-parisc/ptrace.h~include-asm-ptraceh-userspace-headers-cleanup include/asm-parisc/ptrace.h
--- a/include/asm-parisc/ptrace.h~include-asm-ptraceh-userspace-headers-cleanup
+++ a/include/asm-parisc/ptrace.h
@@ -33,7 +33,6 @@ struct pt_regs {
 	unsigned long ipsw;	/* CR22 */
 };
 
-#define task_regs(task) ((struct pt_regs *) ((char *)(task) + TASK_REGS))
 /*
  * The numbers chosen here are somewhat arbitrary but absolutely MUST
  * not overlap with any of the number assigned in <linux/ptrace.h>.
@@ -43,8 +42,11 @@ struct pt_regs {
  * since we have taken branch traps too)
  */
 #define PTRACE_SINGLEBLOCK	12	/* resume execution until next branch */
+
 #ifdef __KERNEL__
 
+#define task_regs(task) ((struct pt_regs *) ((char *)(task) + TASK_REGS))
+
 /* XXX should we use iaoq[1] or iaoq[0] ? */
 #define user_mode(regs)			(((regs)->iaoq[0] & 3) ? 1 : 0)
 #define user_space(regs)		(((regs)->iasq[1] != 0) ? 1 : 0)
diff -puN include/asm-powerpc/Kbuild~include-asm-ptraceh-userspace-headers-cleanup include/asm-powerpc/Kbuild
--- a/include/asm-powerpc/Kbuild~include-asm-ptraceh-userspace-headers-cleanup
+++ a/include/asm-powerpc/Kbuild
@@ -29,7 +29,6 @@ unifdef-y += elf.h
 unifdef-y += nvram.h
 unifdef-y += param.h
 unifdef-y += posix_types.h
-unifdef-y += ptrace.h
 unifdef-y += seccomp.h
 unifdef-y += signal.h
 unifdef-y += spu_info.h
diff -puN include/asm-sh/ptrace.h~include-asm-ptraceh-userspace-headers-cleanup include/asm-sh/ptrace.h
--- a/include/asm-sh/ptrace.h~include-asm-ptraceh-userspace-headers-cleanup
+++ a/include/asm-sh/ptrace.h
@@ -5,7 +5,7 @@
  * Copyright (C) 1999, 2000  Niibe Yutaka
  *
  */
-#if defined(__SH5__) || defined(CONFIG_SUPERH64)
+#if defined(__SH5__)
 struct pt_regs {
 	unsigned long long pc;
 	unsigned long long sr;
diff -puN include/asm-x86/Kbuild~include-asm-ptraceh-userspace-headers-cleanup include/asm-x86/Kbuild
--- a/include/asm-x86/Kbuild~include-asm-ptraceh-userspace-headers-cleanup
+++ a/include/asm-x86/Kbuild
@@ -19,7 +19,6 @@ unifdef-y += msr.h
 unifdef-y += mtrr.h
 unifdef-y += posix_types_32.h
 unifdef-y += posix_types_64.h
-unifdef-y += ptrace.h
 unifdef-y += unistd_32.h
 unifdef-y += unistd_64.h
 unifdef-y += vm86.h
diff -puN include/asm-xtensa/ptrace.h~include-asm-ptraceh-userspace-headers-cleanup include/asm-xtensa/ptrace.h
--- a/include/asm-xtensa/ptrace.h~include-asm-ptraceh-userspace-headers-cleanup
+++ a/include/asm-xtensa/ptrace.h
@@ -73,10 +73,10 @@
 #define PTRACE_GETXTREGS	18
 #define PTRACE_SETXTREGS	19
 
-#ifndef __ASSEMBLY__
-
 #ifdef __KERNEL__
 
+#ifndef __ASSEMBLY__
+
 /*
  * This struct defines the way the registers are stored on the
  * kernel stack during a system call or other kernel entry.
@@ -122,14 +122,14 @@ extern void show_regs(struct pt_regs *);
 # ifndef CONFIG_SMP
 #  define profile_pc(regs) instruction_pointer(regs)
 # endif
-#endif /* __KERNEL__ */
 
 #else	/* __ASSEMBLY__ */
 
-#ifdef __KERNEL__
 # include <asm/asm-offsets.h>
 #define PT_REGS_OFFSET	  (KERNEL_STACK_SIZE - PT_USER_SIZE)
-#endif
 
 #endif	/* !__ASSEMBLY__ */
+
+#endif  /* __KERNEL__ */
+
 #endif	/* _XTENSA_PTRACE_H */
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
uninline-arch_pick_mmap_layout.patch
include-video-atmel_lcdch-must-include-linux-workqueueh.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
if-0-ses_match_host.patch
git-xtensa.patch
include-linux-kernelh-userspace-header-cleanup.patch
parport-sharec-proper-externs.patch
tpm_biosc-make-2-structs-static.patch
drm-make-drm_minors_cleanup-static.patch
make-cgroup_seqfile_release-static.patch
make-pnp_add_card_id-static.patch
make-parport_cs_release-static.patch
make-mm-sparsec-make-a-function-static.patch
mm-allocpercpuc-make-4-functions-static.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch
drivers-char-rtcc-make-2-functions-static.patch
make-init-do_mountsc-root_device_name-static.patch
make-macfb_setup-static.patch
video-console-sticonrec-make-code-static.patch
video-console-sticonrec-make-code-static-checkpatch-fixes.patch
video-stifbc-make-2-functions-static.patch
reiser4.patch

