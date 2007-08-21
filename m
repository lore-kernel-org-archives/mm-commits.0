From: akpm@linux-foundation.org
Subject: - x86_64-remove-str-macros.patch removed from -mm tree
Date: Mon, 20 Aug 2007 22:33:40 -0700
Message-ID: <200708210533.l7L5XeKS008817@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52403 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751996AbXHUFeB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Aug 2007 01:34:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gcosta@redhat.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86_64: remove STR() macros
has been removed from the -mm tree.  Its filename was
     x86_64-remove-str-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: remove STR() macros
From: Glauber de Oliveira Costa <gcosta@redhat.com>

Remove the __STR() and STR() macros from x86_64 header files.  They seem to
be legacy, and has no more users.  Even if there were users, they should
use __stringify() instead.

In fact, there were one third place in which this macro was defined
(ia32_binfmt.c), and used just below.  In this file, usage was properly
converted to __stringify()

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/ia32/ia32_binfmt.c |    5 +----
 include/asm-x86_64/hw_irq.h    |    3 ---
 include/asm-x86_64/system.h    |    3 ---
 3 files changed, 1 insertion(+), 10 deletions(-)

diff -puN arch/x86_64/ia32/ia32_binfmt.c~x86_64-remove-str-macros arch/x86_64/ia32/ia32_binfmt.c
--- a/arch/x86_64/ia32/ia32_binfmt.c~x86_64-remove-str-macros
+++ a/arch/x86_64/ia32/ia32_binfmt.c
@@ -67,11 +67,8 @@ struct file;
 
 #define jiffies_to_timeval(a,b) do { (b)->tv_usec = 0; (b)->tv_sec = (a)/HZ; }while(0)
 
-#define __STR(x) #x
-#define STR(x) __STR(x)
-
 #define _GET_SEG(x) \
-	({ __u32 seg; asm("movl %%" STR(x) ",%0" : "=r"(seg)); seg; })
+	({ __u32 seg; asm("movl %%" __stringify(x) ",%0" : "=r"(seg)); seg; })
 
 /* Assumes current==process to be dumped */
 #undef	ELF_CORE_COPY_REGS
diff -puN include/asm-x86_64/hw_irq.h~x86_64-remove-str-macros include/asm-x86_64/hw_irq.h
--- a/include/asm-x86_64/hw_irq.h~x86_64-remove-str-macros
+++ a/include/asm-x86_64/hw_irq.h
@@ -149,9 +149,6 @@ extern atomic_t irq_mis_count;
 
 #define IO_APIC_IRQ(x) (((x) >= 16) || ((1<<(x)) & io_apic_irqs))
 
-#define __STR(x) #x
-#define STR(x) __STR(x)
-
 #include <asm/ptrace.h>
 
 #define IRQ_NAME2(nr) nr##_interrupt(void)
diff -puN include/asm-x86_64/system.h~x86_64-remove-str-macros include/asm-x86_64/system.h
--- a/include/asm-x86_64/system.h~x86_64-remove-str-macros
+++ a/include/asm-x86_64/system.h
@@ -7,9 +7,6 @@
 
 #ifdef __KERNEL__
 
-#define __STR(x) #x
-#define STR(x) __STR(x)
-
 #define __SAVE(reg,offset) "movq %%" #reg ",(14-" #offset ")*8(%%rsp)\n\t"
 #define __RESTORE(reg,offset) "movq (14-" #offset ")*8(%%rsp),%%" #reg "\n\t"
 
_

Patches currently in -mm which might be from gcosta@redhat.com are

git-kvm.patch
