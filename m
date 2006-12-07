From: akpm@osdl.org
Subject: - elf-always-define-elf_addr_t-in-linux-elfh.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:05:09 -0800
Message-ID: <200612072305.kB7N59Lk030122@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52423 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163898AbWLGXFd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:05:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: magnus@valinux.co.jp, drow@false.org, jakub@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     elf: Always define elf_addr_t in linux/elf.h
has been removed from the -mm tree.  Its filename was
     elf-always-define-elf_addr_t-in-linux-elfh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: elf: Always define elf_addr_t in linux/elf.h
From: Magnus Damm <magnus@valinux.co.jp>

Define elf_addr_t in linux/elf.h.  The size of the type is determined using
ELF_CLASS.  This allows us to remove the defines that today are spread all
over .c and .h files.

Signed-off-by: Magnus Damm <magnus@valinux.co.jp>
Cc: Daniel Jacobowitz <drow@false.org>
Cc: Roland McGrath <roland@redhat.com>
Cc: Jakub Jelinek <jakub@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/ia64/ia32/ia32priv.h          |    2 --
 arch/mips/kernel/binfmt_elfn32.c   |    1 -
 arch/mips/kernel/binfmt_elfo32.c   |    1 -
 arch/mips/kernel/irixelf.c         |    4 ----
 arch/parisc/kernel/binfmt_elf32.c  |    1 -
 arch/s390/kernel/binfmt_elf32.c    |    1 -
 arch/sparc64/kernel/binfmt_elf32.c |    1 -
 arch/x86_64/ia32/ia32_binfmt.c     |    2 --
 fs/binfmt_elf.c                    |    4 ----
 fs/binfmt_elf_fdpic.c              |    3 ---
 include/asm-powerpc/elf.h          |    2 --
 include/linux/elf.h                |    2 ++
 12 files changed, 2 insertions(+), 22 deletions(-)

diff -puN arch/ia64/ia32/ia32priv.h~elf-always-define-elf_addr_t-in-linux-elfh arch/ia64/ia32/ia32priv.h
--- a/arch/ia64/ia32/ia32priv.h~elf-always-define-elf_addr_t-in-linux-elfh
+++ a/arch/ia64/ia32/ia32priv.h
@@ -330,8 +330,6 @@ struct old_linux32_dirent {
 void ia64_elf32_init(struct pt_regs *regs);
 #define ELF_PLAT_INIT(_r, load_addr)	ia64_elf32_init(_r)
 
-#define elf_addr_t	u32
-
 /* This macro yields a bitmask that programs can use to figure out
    what instruction set this CPU supports.  */
 #define ELF_HWCAP	0
diff -puN arch/mips/kernel/binfmt_elfn32.c~elf-always-define-elf_addr_t-in-linux-elfh arch/mips/kernel/binfmt_elfn32.c
--- a/arch/mips/kernel/binfmt_elfn32.c~elf-always-define-elf_addr_t-in-linux-elfh
+++ a/arch/mips/kernel/binfmt_elfn32.c
@@ -90,7 +90,6 @@ struct elf_prpsinfo32
 	char	pr_psargs[ELF_PRARGSZ];	/* initial part of arg list */
 };
 
-#define elf_addr_t	u32
 #define elf_caddr_t	u32
 #define init_elf_binfmt init_elfn32_binfmt
 
diff -puN arch/mips/kernel/binfmt_elfo32.c~elf-always-define-elf_addr_t-in-linux-elfh arch/mips/kernel/binfmt_elfo32.c
--- a/arch/mips/kernel/binfmt_elfo32.c~elf-always-define-elf_addr_t-in-linux-elfh
+++ a/arch/mips/kernel/binfmt_elfo32.c
@@ -92,7 +92,6 @@ struct elf_prpsinfo32
 	char	pr_psargs[ELF_PRARGSZ];	/* initial part of arg list */
 };
 
-#define elf_addr_t	u32
 #define elf_caddr_t	u32
 #define init_elf_binfmt init_elf32_binfmt
 
diff -puN arch/mips/kernel/irixelf.c~elf-always-define-elf_addr_t-in-linux-elfh arch/mips/kernel/irixelf.c
--- a/arch/mips/kernel/irixelf.c~elf-always-define-elf_addr_t-in-linux-elfh
+++ a/arch/mips/kernel/irixelf.c
@@ -52,10 +52,6 @@ static struct linux_binfmt irix_format =
 	irix_core_dump, PAGE_SIZE
 };
 
-#ifndef elf_addr_t
-#define elf_addr_t unsigned long
-#endif
-
 #ifdef DEBUG
 /* Debugging routines. */
 static char *get_elf_p_type(Elf32_Word p_type)
diff -puN arch/parisc/kernel/binfmt_elf32.c~elf-always-define-elf_addr_t-in-linux-elfh arch/parisc/kernel/binfmt_elf32.c
--- a/arch/parisc/kernel/binfmt_elf32.c~elf-always-define-elf_addr_t-in-linux-elfh
+++ a/arch/parisc/kernel/binfmt_elf32.c
@@ -75,7 +75,6 @@ struct elf_prpsinfo32
 	char	pr_psargs[ELF_PRARGSZ];	/* initial part of arg list */
 };
 
-#define elf_addr_t	unsigned int
 #define init_elf_binfmt init_elf32_binfmt
 
 #define ELF_PLATFORM  ("PARISC32\0")
diff -puN arch/s390/kernel/binfmt_elf32.c~elf-always-define-elf_addr_t-in-linux-elfh arch/s390/kernel/binfmt_elf32.c
--- a/arch/s390/kernel/binfmt_elf32.c~elf-always-define-elf_addr_t-in-linux-elfh
+++ a/arch/s390/kernel/binfmt_elf32.c
@@ -176,7 +176,6 @@ struct elf_prpsinfo32
 
 #include <linux/highuid.h>
 
-#define elf_addr_t	u32
 /*
 #define init_elf_binfmt init_elf32_binfmt
 */
diff -puN arch/sparc64/kernel/binfmt_elf32.c~elf-always-define-elf_addr_t-in-linux-elfh arch/sparc64/kernel/binfmt_elf32.c
--- a/arch/sparc64/kernel/binfmt_elf32.c~elf-always-define-elf_addr_t-in-linux-elfh
+++ a/arch/sparc64/kernel/binfmt_elf32.c
@@ -141,7 +141,6 @@ cputime_to_compat_timeval(const cputime_
 	value->tv_sec = jiffies / HZ;
 }
 
-#define elf_addr_t	u32
 #undef start_thread
 #define start_thread start_thread32
 #define init_elf_binfmt init_elf32_binfmt
diff -puN arch/x86_64/ia32/ia32_binfmt.c~elf-always-define-elf_addr_t-in-linux-elfh arch/x86_64/ia32/ia32_binfmt.c
--- a/arch/x86_64/ia32/ia32_binfmt.c~elf-always-define-elf_addr_t-in-linux-elfh
+++ a/arch/x86_64/ia32/ia32_binfmt.c
@@ -305,8 +305,6 @@ MODULE_AUTHOR("Eric Youngdale, Andi Klee
 #undef MODULE_DESCRIPTION
 #undef MODULE_AUTHOR
 
-#define elf_addr_t __u32
-
 static void elf32_init(struct pt_regs *);
 
 #define ARCH_HAS_SETUP_ADDITIONAL_PAGES 1
diff -puN fs/binfmt_elf.c~elf-always-define-elf_addr_t-in-linux-elfh fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~elf-always-define-elf_addr_t-in-linux-elfh
+++ a/fs/binfmt_elf.c
@@ -47,10 +47,6 @@ static int load_elf_binary(struct linux_
 static int load_elf_library(struct file *);
 static unsigned long elf_map (struct file *, unsigned long, struct elf_phdr *, int, int);
 
-#ifndef elf_addr_t
-#define elf_addr_t unsigned long
-#endif
-
 /*
  * If we don't support core dumping, then supply a NULL so we
  * don't even try.
diff -puN fs/binfmt_elf_fdpic.c~elf-always-define-elf_addr_t-in-linux-elfh fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~elf-always-define-elf_addr_t-in-linux-elfh
+++ a/fs/binfmt_elf_fdpic.c
@@ -40,9 +40,6 @@
 #include <asm/pgalloc.h>
 
 typedef char *elf_caddr_t;
-#ifndef elf_addr_t
-#define elf_addr_t unsigned long
-#endif
 
 #if 0
 #define kdebug(fmt, ...) printk("FDPIC "fmt"\n" ,##__VA_ARGS__ )
diff -puN include/asm-powerpc/elf.h~elf-always-define-elf_addr_t-in-linux-elfh include/asm-powerpc/elf.h
--- a/include/asm-powerpc/elf.h~elf-always-define-elf_addr_t-in-linux-elfh
+++ a/include/asm-powerpc/elf.h
@@ -124,12 +124,10 @@ typedef elf_greg_t32 elf_gregset_t32[ELF
 # define ELF_DATA	ELFDATA2MSB
   typedef elf_greg_t64 elf_greg_t;
   typedef elf_gregset_t64 elf_gregset_t;
-# define elf_addr_t unsigned long
 #else
   /* Assumption: ELF_ARCH == EM_PPC and ELF_CLASS == ELFCLASS32 */
   typedef elf_greg_t32 elf_greg_t;
   typedef elf_gregset_t32 elf_gregset_t;
-# define elf_addr_t __u32
 #endif /* ELF_ARCH */
 
 /* Floating point registers */
diff -puN include/linux/elf.h~elf-always-define-elf_addr_t-in-linux-elfh include/linux/elf.h
--- a/include/linux/elf.h~elf-always-define-elf_addr_t-in-linux-elfh
+++ a/include/linux/elf.h
@@ -358,6 +358,7 @@ extern Elf32_Dyn _DYNAMIC [];
 #define elfhdr		elf32_hdr
 #define elf_phdr	elf32_phdr
 #define elf_note	elf32_note
+#define elf_addr_t	Elf32_Off
 
 #else
 
@@ -365,6 +366,7 @@ extern Elf64_Dyn _DYNAMIC [];
 #define elfhdr		elf64_hdr
 #define elf_phdr	elf64_phdr
 #define elf_note	elf64_note
+#define elf_addr_t	Elf64_Off
 
 #endif
 
_

Patches currently in -mm which might be from magnus@valinux.co.jp are

origin.patch

