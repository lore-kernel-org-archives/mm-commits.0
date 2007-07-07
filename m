From: akpm@linux-foundation.org
Subject: - i386-text-edit-lock-alternative-instructions.patch removed from -mm tree
Date: Fri, 06 Jul 2007 17:26:12 -0700
Message-ID: <200707070030.l670UNVG029691@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59090 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751955AbXGGAaj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jul 2007 20:30:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     i386: Text Edit Lock: alternative instructions
has been removed from the -mm tree.  Its filename was
     i386-text-edit-lock-alternative-instructions.patch

This patch was dropped because it had testing failures

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
i386-text-edit-lock-alternative-instructions.patch
i386-text-edit-lock-kprobes.patch
immediate-values-global-modules-list-and-module-mutex.patch
immediate-value-architecture-independent-code.patch
immediate-values-non-optimized-architectures.patch
immediate-value-add-kconfig-menus.patch
immediate-values-kprobe-header-fix.patch
immediate-value-i386-optimization.patch
immediate-value-powerpc-optimization.patch
immediate-value-documentation.patch
f00f-bug-fixup-for-i386-use-immediate-values.patch
scheduler-profiling-use-immediate-values.patch
scheduler-profiling-use-immediate-values-fix.patch
cxgb3-vs-immediate-stuff.patch
use-data_data-in-cris.patch
add-missing-data_data-in-powerpc.patch
use-data_data-in-xtensa.patch
linux-kernel-markers-architecture-independent-code.patch
linux-kernel-markers-add-kconfig-menus-for-the-marker-code.patch
linux-kernel-markers-documentation.patch
port-of-blktrace-to-the-linux-kernel-markers.patch
port-of-blktrace-to-the-linux-kernel-markers-fix.patch
