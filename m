From: akpm@linux-foundation.org
Subject: + m68knommu-blackfin-remove-old-assembler-only-flags-bit-definitions.patch added to -mm tree
Date: Thu, 19 Aug 2010 16:20:51 -0700
Message-ID: <201008192320.o7JNKpuF014395@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43351 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751559Ab0HSXVN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Aug 2010 19:21:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: phdm@macqel.be, geert@linux-m68k.org, gerg@snapgear.com, vapier@gentoo.org


The patch titled
     m68k{nommu}/blackfin : remove old assembler-only flags bit definitions
has been added to the -mm tree.  Its filename is
     m68knommu-blackfin-remove-old-assembler-only-flags-bit-definitions.patch

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
Subject: m68k{nommu}/blackfin : remove old assembler-only flags bit definitions
From: Philippe De Muyter <phdm@macqel.be>

Long ago, PT_TRACESYS_OFF and friends were introduced as hard defines to
avoid straight constants in assembler parts of linux m68k.  They are not
used anymore, and were not updated to follow changes in linux kernel. 
Remove them.  When similar constants are needed, they are now generated
using asm-offsets.c.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Acked-by: Mike Frysinger <vapier@gentoo.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@snapgear.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/include/asm/entry.h |    8 --------
 arch/m68k/include/asm/entry_mm.h  |    8 --------
 arch/m68k/include/asm/entry_no.h  |   10 ----------
 3 files changed, 26 deletions(-)

diff -puN arch/blackfin/include/asm/entry.h~m68knommu-blackfin-remove-old-assembler-only-flags-bit-definitions arch/blackfin/include/asm/entry.h
--- a/arch/blackfin/include/asm/entry.h~m68knommu-blackfin-remove-old-assembler-only-flags-bit-definitions
+++ a/arch/blackfin/include/asm/entry.h
@@ -15,14 +15,6 @@
 #define	LFLUSH_I_AND_D	0x00000808
 #define	LSIGTRAP	5
 
-/* process bits for task_struct.flags */
-#define	PF_TRACESYS_OFF	3
-#define	PF_TRACESYS_BIT	5
-#define	PF_PTRACED_OFF	3
-#define	PF_PTRACED_BIT	4
-#define	PF_DTRACE_OFF	1
-#define	PF_DTRACE_BIT	5
-
 /*
  * NOTE!  The single-stepping code assumes that all interrupt handlers
  * start by saving SYSCFG on the stack with their first instruction.
diff -puN arch/m68k/include/asm/entry_mm.h~m68knommu-blackfin-remove-old-assembler-only-flags-bit-definitions arch/m68k/include/asm/entry_mm.h
--- a/arch/m68k/include/asm/entry_mm.h~m68knommu-blackfin-remove-old-assembler-only-flags-bit-definitions
+++ a/arch/m68k/include/asm/entry_mm.h
@@ -47,14 +47,6 @@
 
 LFLUSH_I_AND_D = 0x00000808
 
-/* process bits for task_struct.ptrace */
-PT_TRACESYS_OFF = 3
-PT_TRACESYS_BIT = 1
-PT_PTRACED_OFF = 3
-PT_PTRACED_BIT = 0
-PT_DTRACE_OFF = 3
-PT_DTRACE_BIT = 2
-
 #define SAVE_ALL_INT save_all_int
 #define SAVE_ALL_SYS save_all_sys
 #define RESTORE_ALL restore_all
diff -puN arch/m68k/include/asm/entry_no.h~m68knommu-blackfin-remove-old-assembler-only-flags-bit-definitions arch/m68k/include/asm/entry_no.h
--- a/arch/m68k/include/asm/entry_no.h~m68knommu-blackfin-remove-old-assembler-only-flags-bit-definitions
+++ a/arch/m68k/include/asm/entry_no.h
@@ -32,16 +32,6 @@
 
 #ifdef __ASSEMBLY__
 
-/* process bits for task_struct.flags */
-PF_TRACESYS_OFF = 3
-PF_TRACESYS_BIT = 5
-PF_PTRACED_OFF = 3
-PF_PTRACED_BIT = 4
-PF_DTRACE_OFF = 1
-PF_DTRACE_BIT = 5
-
-LENOSYS = 38
