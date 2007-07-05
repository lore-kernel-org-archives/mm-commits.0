From: akpm@linux-foundation.org
Subject: + i386-text-edit-lock-alternative-instructions.patch added to -mm tree
Date: Thu, 05 Jul 2007 12:46:55 -0700
Message-ID: <200707051946.l65Jktmr015354@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50687 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758302AbXGETrn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 15:47:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, ak@suse.de


The patch titled
     i386: Text Edit Lock: alternative instructions
has been added to the -mm tree.  Its filename is
     i386-text-edit-lock-alternative-instructions.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: Text Edit Lock: alternative instructions
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

alternative.c can use the text edit lock to remove CPU HOTPLUG special cases.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/alternative.c |    5 +++++
 1 files changed, 5 insertions(+)

diff -puN arch/i386/kernel/alternative.c~i386-text-edit-lock-alternative-instructions arch/i386/kernel/alternative.c
--- a/arch/i386/kernel/alternative.c~i386-text-edit-lock-alternative-instructions
+++ a/arch/i386/kernel/alternative.c
@@ -4,6 +4,7 @@
 #include <linux/list.h>
 #include <asm/alternative.h>
 #include <asm/sections.h>
+#include <asm/cacheflush.h>
 
 #ifdef CONFIG_HOTPLUG_CPU
 static int smp_alt_once;
@@ -185,9 +186,11 @@ void apply_alternatives(struct alt_instr
 				__FUNCTION__, a->instr, instr);
 		}
 #endif
+		kernel_text_lock((unsigned long)instr, a->instrlen);
 		memcpy(instr, a->replacement, a->replacementlen);
 		diff = a->instrlen - a->replacementlen;
 		nop_out(instr + a->replacementlen, diff);
+		kernel_text_unlock((unsigned long)instr, a->instrlen);
 	}
 }
 
@@ -352,6 +355,7 @@ void apply_paravirt(struct paravirt_patc
 	for (p = start; p < end; p++) {
 		unsigned int used;
 
+		kernel_text_lock((unsigned long)p->instr, p->len);
 		used = paravirt_ops.patch(p->instrtype, p->clobbers, p->instr,
 					  p->len);
 
@@ -359,6 +363,7 @@ void apply_paravirt(struct paravirt_patc
 
 		/* Pad the rest with nops */
 		nop_out(p->instr + used, p->len - used);
+		kernel_text_unlock((unsigned long)p->instr, p->len);
 	}
 
 	/* Sync to be conservative, in case we patched following
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

powerpc-promc-remove-undef-printk.patch
i386-text-edit-lock.patch
i386-text-edit-lock-alternative-instructions.patch
i386-text-edit-lock-kprobes.patch
