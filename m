From: akpm@linux-foundation.org
Subject: + flat-fix-data-sections-alignment.patch added to -mm tree
Date: Wed, 04 Mar 2009 14:28:54 -0800
Message-ID: <200903042228.n24MSsTI010401@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47794 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751280AbZCDWaI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2009 17:30:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: os@emlix.com, cooloney@kernel.org, dhowells@redhat.com, geert@linux-m68k.org, gerg@uclinux.org, jw@emlix.com, lethal@linux-sh.org, rmk@arm.linux.org.uk


The patch titled
     flat: fix data sections alignment
has been added to the -mm tree.  Its filename is
     flat-fix-data-sections-alignment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: flat: fix data sections alignment
From: Oskar Schirmer <os@emlix.com>

The flat loader uses an architecture's flat_stack_align() to align the
stack but assumes word-alignment is enough for the data sections.

However, on the Xtensa S6000 we have registers up to 128bit width
which can be used from userspace and therefor need userspace stack and
data-section alignment of at least this size.

This patch drops flat_stack_align() and uses the same alignment that
is required for slab caches, ARCH_SLAB_MINALIGN, or wordsize if it's
not defined by the architecture.

It also fixes m32r which was obviously kaput, aligning an
uninitialized stack entry instead of the stack pointer.

Signed-off-by: Oskar Schirmer <os@emlix.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Bryan Wu <cooloney@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Johannes Weiner <jw@emlix.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/flat.h      |    3 --
 arch/blackfin/include/asm/flat.h |    1 
 arch/h8300/include/asm/flat.h    |    1 
 arch/m68k/include/asm/flat.h     |    1 
 arch/sh/include/asm/flat.h       |    1 
 fs/binfmt_flat.c                 |   37 +++++++++++++++++------------
 include/asm-m32r/flat.h          |    1 
 7 files changed, 22 insertions(+), 23 deletions(-)

diff -puN arch/arm/include/asm/flat.h~flat-fix-data-sections-alignment arch/arm/include/asm/flat.h
--- a/arch/arm/include/asm/flat.h~flat-fix-data-sections-alignment
+++ a/arch/arm/include/asm/flat.h
@@ -5,9 +5,6 @@
 #ifndef __ARM_FLAT_H__
 #define __ARM_FLAT_H__
 
-/* An odd number of words will be pushed after this alignment, so
-   deliberately misalign the value.  */
-#define	flat_stack_align(sp)	sp = (void *)(((unsigned long)(sp) - 4) | 4)
 #define	flat_argvp_envp_on_stack()		1
 #define	flat_old_ram_flag(flags)		(flags)
 #define	flat_reloc_valid(reloc, size)		((reloc) <= (size))
diff -puN arch/blackfin/include/asm/flat.h~flat-fix-data-sections-alignment arch/blackfin/include/asm/flat.h
--- a/arch/blackfin/include/asm/flat.h~flat-fix-data-sections-alignment
+++ a/arch/blackfin/include/asm/flat.h
@@ -10,7 +10,6 @@
 
 #include <asm/unaligned.h>
 
-#define	flat_stack_align(sp)	/* nothing needed */
 #define	flat_argvp_envp_on_stack()		0
 #define	flat_old_ram_flag(flags)		(flags)
 
diff -puN arch/h8300/include/asm/flat.h~flat-fix-data-sections-alignment arch/h8300/include/asm/flat.h
--- a/arch/h8300/include/asm/flat.h~flat-fix-data-sections-alignment
+++ a/arch/h8300/include/asm/flat.h
@@ -5,7 +5,6 @@
 #ifndef __H8300_FLAT_H__
 #define __H8300_FLAT_H__
 
-#define	flat_stack_align(sp)			/* nothing needed */
 #define	flat_argvp_envp_on_stack()		1
 #define	flat_old_ram_flag(flags)		1
 #define	flat_reloc_valid(reloc, size)		((reloc) <= (size))
diff -puN arch/m68k/include/asm/flat.h~flat-fix-data-sections-alignment arch/m68k/include/asm/flat.h
--- a/arch/m68k/include/asm/flat.h~flat-fix-data-sections-alignment
+++ a/arch/m68k/include/asm/flat.h
@@ -5,7 +5,6 @@
 #ifndef __M68KNOMMU_FLAT_H__
 #define __M68KNOMMU_FLAT_H__
 
-#define	flat_stack_align(sp)			/* nothing needed */
 #define	flat_argvp_envp_on_stack()		1
 #define	flat_old_ram_flag(flags)		(flags)
 #define	flat_reloc_valid(reloc, size)		((reloc) <= (size))
diff -puN arch/sh/include/asm/flat.h~flat-fix-data-sections-alignment arch/sh/include/asm/flat.h
--- a/arch/sh/include/asm/flat.h~flat-fix-data-sections-alignment
+++ a/arch/sh/include/asm/flat.h
@@ -12,7 +12,6 @@
 #ifndef __ASM_SH_FLAT_H
 #define __ASM_SH_FLAT_H
 
-#define	flat_stack_align(sp)			/* nothing needed */
 #define	flat_argvp_envp_on_stack()		0
 #define	flat_old_ram_flag(flags)		(flags)
 #define	flat_reloc_valid(reloc, size)		((reloc) <= (size))
diff -puN fs/binfmt_flat.c~flat-fix-data-sections-alignment fs/binfmt_flat.c
--- a/fs/binfmt_flat.c~flat-fix-data-sections-alignment
+++ a/fs/binfmt_flat.c
@@ -41,6 +41,7 @@
 #include <asm/uaccess.h>
 #include <asm/unaligned.h>
 #include <asm/cacheflush.h>
+#include <asm/page.h>
 
 /****************************************************************************/
 
@@ -54,6 +55,12 @@
 #define	DBG_FLT(a...)
 #endif
 
+#ifdef ARCH_SLAB_MINALIGN
+#define FLAT_DATA_ALIGN	(ARCH_SLAB_MINALIGN)
+#else
+#define FLAT_DATA_ALIGN	(sizeof(void *))
+#endif
+
 #define RELOC_FAILED 0xff00ff01		/* Relocation incorrect somewhere */
 #define UNLOADED_LIB 0x7ff000ff		/* Placeholder for unused library */
 
@@ -114,20 +121,18 @@ static unsigned long create_flat_tables(
 	int envc = bprm->envc;
 	char uninitialized_var(dummy);
 
-	sp = (unsigned long *) ((-(unsigned long)sizeof(char *))&(unsigned long) p);
-
-	sp -= envc+1;
-	envp = sp;
-	sp -= argc+1;
-	argv = sp;
+	sp = (unsigned long *)p;
+	sp -= (envc + argc + 2) + 1 + (flat_argvp_envp_on_stack() ? 2 : 0);
+	sp = (unsigned long *) ((unsigned long)sp & -FLAT_DATA_ALIGN);
+	argv = sp + 1 + (flat_argvp_envp_on_stack() ? 2 : 0);
+	envp = argv + (argc + 1);
 
-	flat_stack_align(sp);
 	if (flat_argvp_envp_on_stack()) {
-		--sp; put_user((unsigned long) envp, sp);
-		--sp; put_user((unsigned long) argv, sp);
+		put_user((unsigned long) envp, sp + 2);
+		put_user((unsigned long) argv, sp + 1);
 	}
 
-	put_user(argc,--sp);
+	put_user(argc,sp);
 	current->mm->arg_start = (unsigned long) p;
 	while (argc-->0) {
 		put_user((unsigned long) p, argv++);
@@ -558,7 +563,8 @@ static int load_flat_file(struct linux_b
 			ret = realdatastart;
 			goto err;
 		}
-		datapos = realdatastart + MAX_SHARED_LIBS * sizeof(unsigned long);
+		datapos = ALIGN(realdatastart + MAX_SHARED_LIBS * sizeof(unsigned long),
+				FLAT_DATA_ALIGN);
 
 		DBG_FLT("BINFMT_FLAT: Allocated data+bss+stack (%d bytes): %x\n",
 				(int)(data_len + bss_len + stack_len), (int)datapos);
@@ -604,9 +610,10 @@ static int load_flat_file(struct linux_b
 		}
 
 		realdatastart = textpos + ntohl(hdr->data_start);
-		datapos = realdatastart + MAX_SHARED_LIBS * sizeof(unsigned long);
-		reloc = (unsigned long *) (textpos + ntohl(hdr->reloc_start) +
-				MAX_SHARED_LIBS * sizeof(unsigned long));
+		datapos = ALIGN(realdatastart + MAX_SHARED_LIBS * sizeof(unsigned long),
+				FLAT_DATA_ALIGN);
+
+		reloc = (unsigned long *) (datapos+(ntohl(hdr->reloc_start)-text_len));
 		memp = textpos;
 		memp_size = len;
 #ifdef CONFIG_BINFMT_ZFLAT
@@ -854,7 +861,7 @@ static int load_flat_binary(struct linux
 	stack_len = TOP_OF_ARGS - bprm->p;             /* the strings */
 	stack_len += (bprm->argc + 1) * sizeof(char *); /* the argv array */
 	stack_len += (bprm->envc + 1) * sizeof(char *); /* the envp array */
