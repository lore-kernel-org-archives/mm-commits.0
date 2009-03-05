From: akpm@linux-foundation.org
Subject: + flat-fix-data-sections-alignment-update.patch added to -mm tree
Date: Thu, 05 Mar 2009 14:40:58 -0800
Message-ID: <200903052240.n25MexIg009742@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58326 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753224AbZCEWmS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Mar 2009 17:42:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: os@emlix.com, cooloney@kernel.org, dhowells@redhat.com, geert@linux-m68k.org, gerg@uclinux.org, jw@emlix.com, lethal@linux-sh.org, rmk@arm.linux.org.uk, vapier.adi@gmail.com


The patch titled
     flat: fix data sections alignment v3
has been added to the -mm tree.  Its filename is
     flat-fix-data-sections-alignment-update.patch

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
Subject: flat: fix data sections alignment v3
From: Oskar Schirmer <os@emlix.com>

v3:
- checkpatch-clean (Andrew Morton)
- fixed the alignment space upon allocation calculation (Mike Frysinger)
- added a comment for the use of ARCH_SLAB_MINALIGN (Paul Mundt)

v2:
- replace local flat_data_align by ARCH_SLAB_MINALIGN (Paul Mundt)

Signed-off-by: Oskar Schirmer <os@emlix.com>
Signed-off-by: Johannes Weiner <jw@emlix.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Bryan Wu <cooloney@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_flat.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff -puN fs/binfmt_flat.c~flat-fix-data-sections-alignment-update fs/binfmt_flat.c
--- a/fs/binfmt_flat.c~flat-fix-data-sections-alignment-update
+++ a/fs/binfmt_flat.c
@@ -55,6 +55,12 @@
 #define	DBG_FLT(a...)
 #endif
 
+/*
+ * User data (stack, data section and bss) needs to be aligned
+ * for the same reasons as SLAB memory is, and to the same amount.
+ * Avoid duplicating architecture specific code by using the same
+ * macro as with SLAB allocation:
+ */
 #ifdef ARCH_SLAB_MINALIGN
 #define FLAT_DATA_ALIGN	(ARCH_SLAB_MINALIGN)
 #else
@@ -563,7 +569,8 @@ static int load_flat_file(struct linux_b
 			ret = realdatastart;
 			goto err;
 		}
-		datapos = ALIGN(realdatastart + MAX_SHARED_LIBS * sizeof(unsigned long),
+		datapos = ALIGN(realdatastart +
+				MAX_SHARED_LIBS * sizeof(unsigned long),
 				FLAT_DATA_ALIGN);
 
 		DBG_FLT("BINFMT_FLAT: Allocated data+bss+stack (%d bytes): %x\n",
@@ -610,10 +617,12 @@ static int load_flat_file(struct linux_b
 		}
 
 		realdatastart = textpos + ntohl(hdr->data_start);
-		datapos = ALIGN(realdatastart + MAX_SHARED_LIBS * sizeof(unsigned long),
+		datapos = ALIGN(realdatastart +
+				MAX_SHARED_LIBS * sizeof(unsigned long),
 				FLAT_DATA_ALIGN);
 
-		reloc = (unsigned long *) (datapos+(ntohl(hdr->reloc_start)-text_len));
+		reloc = (unsigned long *)
+			(datapos + (ntohl(hdr->reloc_start) - text_len));
 		memp = textpos;
 		memp_size = len;
 #ifdef CONFIG_BINFMT_ZFLAT
@@ -861,7 +870,7 @@ static int load_flat_binary(struct linux
 	stack_len = TOP_OF_ARGS - bprm->p;             /* the strings */
 	stack_len += (bprm->argc + 1) * sizeof(char *); /* the argv array */
 	stack_len += (bprm->envc + 1) * sizeof(char *); /* the envp array */
-	stack_len += FLAT_DATA_ALIGN;
+	stack_len += FLAT_DATA_ALIGN - 1;  /* reserve for upcoming alignment */
 	
 	res = load_flat_file(bprm, &libinfo, 0, &stack_len);
 	if (res > (unsigned long)-4096)
_

Patches currently in -mm which might be from os@emlix.com are

xtensa-enforce-slab-alignment-to-maximum-register-width.patch
xtensa-add-flat-support.patch
xtensa-add-flat-support-checkpatch-fixes.patch
flat-fix-data-sections-alignment.patch
flat-fix-data-sections-alignment-update.patch

