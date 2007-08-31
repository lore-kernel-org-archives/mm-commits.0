From: akpm@linux-foundation.org
Subject: + x86_64-add-parenthesis-to-irq-vector-macros.patch added to -mm tree
Date: Fri, 31 Aug 2007 13:05:09 -0700
Message-ID: <200708312005.l7VK59Gp024318@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40037 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751389AbXHaUFQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 16:05:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rostedt@goodmis.org, ak@suse.de


The patch titled
     x86_64: add parenthesis to IRQ vector macros
has been added to the -mm tree.  Its filename is
     x86_64-add-parenthesis-to-irq-vector-macros.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: add parenthesis to IRQ vector macros
From: Steven Rostedt <rostedt@goodmis.org>

It is not good taste to have macros with additions that do not have
parenthesis's around them.  This patch parethesizes the IRQ vector macros
for x86_64 arch.

Note, this caused me a bit of heart-ache debugging lguest64.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86_64/hw_irq.h |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff -puN include/asm-x86_64/hw_irq.h~x86_64-add-parenthesis-to-irq-vector-macros include/asm-x86_64/hw_irq.h
--- a/include/asm-x86_64/hw_irq.h~x86_64-add-parenthesis-to-irq-vector-macros
+++ a/include/asm-x86_64/hw_irq.h
@@ -40,22 +40,22 @@
 /*
  * Vectors 0x30-0x3f are used for ISA interrupts.
  */
-#define IRQ0_VECTOR		FIRST_EXTERNAL_VECTOR + 0x10
-#define IRQ1_VECTOR		IRQ0_VECTOR + 1
-#define IRQ2_VECTOR		IRQ0_VECTOR + 2
-#define IRQ3_VECTOR		IRQ0_VECTOR + 3
-#define IRQ4_VECTOR		IRQ0_VECTOR + 4
-#define IRQ5_VECTOR		IRQ0_VECTOR + 5 
-#define IRQ6_VECTOR		IRQ0_VECTOR + 6
-#define IRQ7_VECTOR		IRQ0_VECTOR + 7
-#define IRQ8_VECTOR		IRQ0_VECTOR + 8
-#define IRQ9_VECTOR		IRQ0_VECTOR + 9
-#define IRQ10_VECTOR		IRQ0_VECTOR + 10
-#define IRQ11_VECTOR		IRQ0_VECTOR + 11
-#define IRQ12_VECTOR		IRQ0_VECTOR + 12
-#define IRQ13_VECTOR		IRQ0_VECTOR + 13
-#define IRQ14_VECTOR		IRQ0_VECTOR + 14
-#define IRQ15_VECTOR		IRQ0_VECTOR + 15
+#define IRQ0_VECTOR		(FIRST_EXTERNAL_VECTOR + 0x10)
+#define IRQ1_VECTOR		(IRQ0_VECTOR + 1)
+#define IRQ2_VECTOR		(IRQ0_VECTOR + 2)
+#define IRQ3_VECTOR		(IRQ0_VECTOR + 3)
+#define IRQ4_VECTOR		(IRQ0_VECTOR + 4)
+#define IRQ5_VECTOR		(IRQ0_VECTOR + 5)
+#define IRQ6_VECTOR		(IRQ0_VECTOR + 6)
+#define IRQ7_VECTOR		(IRQ0_VECTOR + 7)
+#define IRQ8_VECTOR		(IRQ0_VECTOR + 8)
+#define IRQ9_VECTOR		(IRQ0_VECTOR + 9)
+#define IRQ10_VECTOR		(IRQ0_VECTOR + 10)
+#define IRQ11_VECTOR		(IRQ0_VECTOR + 11)
+#define IRQ12_VECTOR		(IRQ0_VECTOR + 12)
+#define IRQ13_VECTOR		(IRQ0_VECTOR + 13)
+#define IRQ14_VECTOR		(IRQ0_VECTOR + 14)
+#define IRQ15_VECTOR		(IRQ0_VECTOR + 15)
 
 /*
  * Special IRQ vectors used by the SMP architecture, 0xf0-0xff
_

Patches currently in -mm which might be from rostedt@goodmis.org are

x86_64-add-parenthesis-to-irq-vector-macros.patch
