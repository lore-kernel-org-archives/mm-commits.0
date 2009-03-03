From: akpm@linux-foundation.org
Subject: + binfmt_flat-fix-data-sections-alignment.patch added to -mm tree
Date: Tue, 03 Mar 2009 13:41:34 -0800
Message-ID: <200903032141.n23LfZPc006347@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48529 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754624AbZCCVn1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Mar 2009 16:43:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: os@emlix.com, cooloney@kernel.org, dhowells@redhat.com, geert@linux-m68k.org, gerg@snapgear.com, hyok.choi@samsung.com, jw@emlix.com, lethal@linux-sh.org, rmk@arm.linux.org.uk


The patch titled
     binfmt_flat: fix data sections alignment
has been added to the -mm tree.  Its filename is
     binfmt_flat-fix-data-sections-alignment.patch

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
Subject: binfmt_flat: fix data sections alignment
From: Oskar Schirmer <os@emlix.com>

The flat loader uses an architecture's flat_stack_align() to align the
stack but assumes word-alignment is enough for the data sections.

However, on the Xtensa S6000 we need an alignment of more than wordsize
for data that is loaded to 128bit wide registers.

This patch replaces the specific flat_stack_align() with a more generic
flat_data_align() that is then used for both stack, the data and bss
section.

It also fixes m32r which was obviously kaput, aligning an uninitialized
stack entry instead of the stack pointer.

We tried to verify brain-wise that all the alignments on other archs are
still correct but please note that we have only one xtensa-based box to
test this patch on.  It works here with a required data alignment of 16
bytes.

Signed-off-by: Oskar Schirmer <os@emlix.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Bryan Wu <cooloney@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Johannes Weiner <jw@emlix.com>
Cc: Greg Ungerer <gerg@snapgear.com>
Cc: Hyok S. Choi <hyok.choi@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/flat.h      |    4 +---
 arch/blackfin/include/asm/flat.h |    2 +-
 arch/h8300/include/asm/flat.h    |    2 +-
 arch/m68k/include/asm/flat.h     |    2 +-
 arch/sh/include/asm/flat.h       |    2 +-
 fs/binfmt_flat.c                 |   28 ++++++++++++++--------------
 include/asm-m32r/flat.h          |    2 +-
 7 files changed, 20 insertions(+), 22 deletions(-)

diff -puN arch/arm/include/asm/flat.h~binfmt_flat-fix-data-sections-alignment arch/arm/include/asm/flat.h
--- a/arch/arm/include/asm/flat.h~binfmt_flat-fix-data-sections-alignment
+++ a/arch/arm/include/asm/flat.h
@@ -5,9 +5,7 @@
 #ifndef __ARM_FLAT_H__
 #define __ARM_FLAT_H__
 
-/* An odd number of words will be pushed after this alignment, so
-   deliberately misalign the value.  */
-#define	flat_stack_align(sp)	sp = (void *)(((unsigned long)(sp) - 4) | 4)
+#define	flat_data_align()			8
 #define	flat_argvp_envp_on_stack()		1
 #define	flat_old_ram_flag(flags)		(flags)
 #define	flat_reloc_valid(reloc, size)		((reloc) <= (size))
diff -puN arch/blackfin/include/asm/flat.h~binfmt_flat-fix-data-sections-alignment arch/blackfin/include/asm/flat.h
--- a/arch/blackfin/include/asm/flat.h~binfmt_flat-fix-data-sections-alignment
+++ a/arch/blackfin/include/asm/flat.h
@@ -10,7 +10,7 @@
 
 #include <asm/unaligned.h>
 
-#define	flat_stack_align(sp)	/* nothing needed */
+#define	flat_data_align()			sizeof(void *)
 #define	flat_argvp_envp_on_stack()		0
 #define	flat_old_ram_flag(flags)		(flags)
 
diff -puN arch/h8300/include/asm/flat.h~binfmt_flat-fix-data-sections-alignment arch/h8300/include/asm/flat.h
--- a/arch/h8300/include/asm/flat.h~binfmt_flat-fix-data-sections-alignment
+++ a/arch/h8300/include/asm/flat.h
@@ -5,7 +5,7 @@
 #ifndef __H8300_FLAT_H__
 #define __H8300_FLAT_H__
 
-#define	flat_stack_align(sp)			/* nothing needed */
+#define	flat_data_align()			sizeof(void *)
 #define	flat_argvp_envp_on_stack()		1
 #define	flat_old_ram_flag(flags)		1
 #define	flat_reloc_valid(reloc, size)		((reloc) <= (size))
diff -puN arch/m68k/include/asm/flat.h~binfmt_flat-fix-data-sections-alignment arch/m68k/include/asm/flat.h
--- a/arch/m68k/include/asm/flat.h~binfmt_flat-fix-data-sections-alignment
+++ a/arch/m68k/include/asm/flat.h
@@ -5,7 +5,7 @@
 #ifndef __M68KNOMMU_FLAT_H__
 #define __M68KNOMMU_FLAT_H__
 
-#define	flat_stack_align(sp)			/* nothing needed */
+#define	flat_data_align(sp)			sizeof(void *)
 #define	flat_argvp_envp_on_stack()		1
 #define	flat_old_ram_flag(flags)		(flags)
 #define	flat_reloc_valid(reloc, size)		((reloc) <= (size))
diff -puN arch/sh/include/asm/flat.h~binfmt_flat-fix-data-sections-alignment arch/sh/include/asm/flat.h
--- a/arch/sh/include/asm/flat.h~binfmt_flat-fix-data-sections-alignment
+++ a/arch/sh/include/asm/flat.h
@@ -12,7 +12,7 @@
 #ifndef __ASM_SH_FLAT_H
 #define __ASM_SH_FLAT_H
 
-#define	flat_stack_align(sp)			/* nothing needed */
+#define	flat_data_align(sp)			sizeof(void *)
 #define	flat_argvp_envp_on_stack()		0
 #define	flat_old_ram_flag(flags)		(flags)
 #define	flat_reloc_valid(reloc, size)		((reloc) <= (size))
diff -puN fs/binfmt_flat.c~binfmt_flat-fix-data-sections-alignment fs/binfmt_flat.c
--- a/fs/binfmt_flat.c~binfmt_flat-fix-data-sections-alignment
+++ a/fs/binfmt_flat.c
@@ -115,19 +115,17 @@ static unsigned long create_flat_tables(
 	char uninitialized_var(dummy);
 
 	sp = (unsigned long *) ((-(unsigned long)sizeof(char *))&(unsigned long) p);
+	sp -= (envc + argc + 2) + 1 + (flat_argvp_envp_on_stack() ? 2 : 0);
+	sp = (unsigned long *) ((-(unsigned long)flat_data_align())&(unsigned long) sp);
+	argv = sp + 1 + (flat_argvp_envp_on_stack() ? 2 : 0);
+	envp = argv + (argc + 1);
 
-	sp -= envc+1;
-	envp = sp;
-	sp -= argc+1;
-	argv = sp;
-
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
@@ -558,7 +556,8 @@ static int load_flat_file(struct linux_b
 			ret = realdatastart;
 			goto err;
 		}
-		datapos = realdatastart + MAX_SHARED_LIBS * sizeof(unsigned long);
+		datapos = ALIGN(realdatastart + MAX_SHARED_LIBS * sizeof(unsigned long),
+				flat_data_align());
 
 		DBG_FLT("BINFMT_FLAT: Allocated data+bss+stack (%d bytes): %x\n",
 				(int)(data_len + bss_len + stack_len), (int)datapos);
@@ -604,9 +603,10 @@ static int load_flat_file(struct linux_b
 		}
 
 		realdatastart = textpos + ntohl(hdr->data_start);
-		datapos = realdatastart + MAX_SHARED_LIBS * sizeof(unsigned long);
-		reloc = (unsigned long *) (textpos + ntohl(hdr->reloc_start) +
-				MAX_SHARED_LIBS * sizeof(unsigned long));
+		datapos = ALIGN(realdatastart + MAX_SHARED_LIBS * sizeof(unsigned long),
+				flat_data_align());
+
+		reloc = (unsigned long *) (datapos+(ntohl(hdr->reloc_start)-text_len));
 		memp = textpos;
 		memp_size = len;
 #ifdef CONFIG_BINFMT_ZFLAT
@@ -854,7 +854,7 @@ static int load_flat_binary(struct linux
 	stack_len = TOP_OF_ARGS - bprm->p;             /* the strings */
 	stack_len += (bprm->argc + 1) * sizeof(char *); /* the argv array */
 	stack_len += (bprm->envc + 1) * sizeof(char *); /* the envp array */
