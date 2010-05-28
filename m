From: akpm@linux-foundation.org
Subject: + flat-split-the-stack-data-alignments.patch added to -mm tree
Date: Fri, 28 May 2010 15:36:21 -0700
Message-ID: <201005282236.o4SMaL2S018443@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55199 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751121Ab0E1Wl4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 May 2010 18:41:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, David.Woodhouse@intel.com, davidm@snapgear.com, dhowells@redhat.com, geert@linux-m68k.org, gerg@uclinux.org, herbert@gondor.hengli.com.au, jie@codesourcery.com, lethal@linux-sh.org, monstr@monstr.eu, penberg@cs.helsinki.fi, takata@linux-m32r.org, ysato@users.sourceforge.jp


The patch titled
     fs/binfmt_flat.c: split the stack & data alignments
has been added to the -mm tree.  Its filename is
     flat-split-the-stack-data-alignments.patch

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
Subject: fs/binfmt_flat.c: split the stack & data alignments
From: Mike Frysinger <vapier@gentoo.org>

The stack and data have different alignment requirements, so don't force
them to wear the same shoe.  Increase the data alignment to match that
which the elf2flt linker script has always been using: 0x20 bytes.  Not
only does this bring the kernel loader in line with the toolchain, but it
also fixes a swath of gcc tests which try to force larger alignment values
but randomly fail when the FLAT loader fails to deliver.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Woodhouse <David.Woodhouse@intel.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: David McCullough <davidm@snapgear.com>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Tested-by: Michal Simek <monstr@monstr.eu>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jie Zhang <jie@codesourcery.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_flat.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff -puN fs/binfmt_flat.c~flat-split-the-stack-data-alignments fs/binfmt_flat.c
--- a/fs/binfmt_flat.c~flat-split-the-stack-data-alignments
+++ a/fs/binfmt_flat.c
@@ -56,15 +56,22 @@
 #endif
 
 /*
- * User data (stack, data section and bss) needs to be aligned
- * for the same reasons as SLAB memory is, and to the same amount.
- * Avoid duplicating architecture specific code by using the same
- * macro as with SLAB allocation:
+ * User data (data section and bss) needs to be aligned.
+ * We pick 0x20 here because it is the max value elf2flt has always
+ * used in producing FLAT files, and because it seems to be large
+ * enough to make all the gcc alignment related tests happy.
+ */
+#define FLAT_DATA_ALIGN	(0x20)
+
+/*
+ * User data (stack) also needs to be aligned.
+ * Here we can be a bit looser than the data sections since this
+ * needs to only meet arch ABI requirements.
  */
 #ifdef ARCH_SLAB_MINALIGN
-#define FLAT_DATA_ALIGN	(ARCH_SLAB_MINALIGN)
+#define FLAT_STACK_ALIGN	(ARCH_SLAB_MINALIGN)
 #else
-#define FLAT_DATA_ALIGN	(sizeof(void *))
+#define FLAT_STACK_ALIGN	(sizeof(void *))
 #endif
 
 #define RELOC_FAILED 0xff00ff01		/* Relocation incorrect somewhere */
@@ -129,7 +136,7 @@ static unsigned long create_flat_tables(
 
 	sp = (unsigned long *)p;
 	sp -= (envc + argc + 2) + 1 + (flat_argvp_envp_on_stack() ? 2 : 0);
-	sp = (unsigned long *) ((unsigned long)sp & -FLAT_DATA_ALIGN);
+	sp = (unsigned long *) ((unsigned long)sp & -FLAT_STACK_ALIGN);
 	argv = sp + 1 + (flat_argvp_envp_on_stack() ? 2 : 0);
 	envp = argv + (argc + 1);
 
@@ -876,7 +883,7 @@ static int load_flat_binary(struct linux
 	stack_len = TOP_OF_ARGS - bprm->p;             /* the strings */
 	stack_len += (bprm->argc + 1) * sizeof(char *); /* the argv array */
 	stack_len += (bprm->envc + 1) * sizeof(char *); /* the envp array */
-	stack_len += FLAT_DATA_ALIGN - 1;  /* reserve for upcoming alignment */
+	stack_len += FLAT_STACK_ALIGN - 1;  /* reserve for upcoming alignment */
 	
 	res = load_flat_file(bprm, &libinfo, 0, &stack_len);
 	if (IS_ERR_VALUE(res))
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
linux-next.patch
flat-split-the-stack-data-alignments.patch
flat-tweak-default-stack-alignment.patch

