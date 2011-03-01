From: akpm@linux-foundation.org
Subject: + x86-work-around-old-gas-bug.patch added to -mm tree
Date: Tue, 01 Mar 2011 15:52:26 -0800
Message-ID: <201103012352.p21NqRN1006974@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756534Ab1CAXxL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Mar 2011 18:53:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com, hpa@zytor.com, jbeulich@novell.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: work around old gas bug
has been added to the -mm tree.  Its filename is
     x86-work-around-old-gas-bug.patch

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
Subject: x86: work around old gas bug
From: Shaohua Li <shaohua.li@intel.com>

> arch/x86/kernel/entry_64.S: Assembler messages:
> arch/x86/kernel/entry_64.S:984: Error: junk at end of line, first unrecognized character is `1'
> arch/x86/kernel/entry_64.S:984: Error: too many positional arguments
> arch/x86/kernel/entry_64.S:984: Error: junk at end of line, first unrecognized character is `1'
> arch/x86/kernel/entry_64.S:984: Error: too many positional arguments
> arch/x86/kernel/entry_64.S:984: Error: junk at end of line, first unrecognized character is `1'
> arch/x86/kernel/entry_64.S:984: Error: too many positional arguments
> arch/x86/kernel/entry_64.S:984: Error: junk at end of line, first unrecognized character is `1'
> arch/x86/kernel/entry_64.S:984: Error: too many positional arguments
> arch/x86/kernel/entry_64.S:984: Error: junk at end of line, first unrecognized character is `1'
> arch/x86/kernel/entry_64.S:984: Error: too many positional arguments
> arch/x86/kernel/entry_64.S:984: Error: junk at end of line, first unrecognized character is `1'
> arch/x86/kernel/entry_64.S:984: Error: too many positional arguments
> arch/x86/kernel/entry_64.S:984: Error: junk at end of line, first unrecognized character is `1'
> arch/x86/kernel/entry_64.S:984: Error: too many positional arguments
> arch/x86/kernel/entry_64.S:984: Error: junk at end of line, first unrecognized character is `1'
> arch/x86/kernel/entry_64.S:984: Error: too many positional arguments
> arch/x86/kernel/entry_64.S:984: Error: junk at end of line, first unrecognized character is `1'
> arch/x86/kernel/entry_64.S:984: Error: too many positional arguments
> arch/x86/kernel/entry_64.S:984: Error: junk at end of line, first unrecognized character is `1'
> arch/x86/kernel/entry_64.S:984: Error: too many positional arguments
> arch/x86/kernel/entry_64.S:984: Error: junk at end of line, first unrecognized character is `1'
> arch/x86/kernel/entry_64.S:984: Error: too many positional arguments
> arch/x86/kernel/entry_64.S:984: Error: junk at end of line, first unrecognized character is `1'
> arch/x86/kernel/entry_64.S:984: Error: too many positional arguments
> arch/x86/kernel/entry_64.S:984: Error: junk at end of line, first unrecognized character is `1'
> arch/x86/kernel/entry_64.S:984: Error: too many positional arguments
> arch/x86/kernel/entry_64.S:984: Error: junk at end of line, first unrecognized character is `1'
> arch/x86/kernel/entry_64.S:984: Error: too many positional arguments
> arch/x86/kernel/entry_64.S:984: Error: junk at end of line, first unrecognized character is `1'
> arch/x86/kernel/entry_64.S:984: Error: too many positional arguments
> arch/x86/kernel/entry_64.S:984: Error: junk at end of line, first unrecognized character is `1'
> arch/x86/kernel/entry_64.S:984: Error: too many positional arguments
> make[1]: *** [arch/x86/kernel/entry_64.o] Error 1
> make: *** [arch/x86/kernel/entry_64.o] Error 2
>
> Due to
>
> #ifdef CONFIG_SMP
> .irp idx,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,
>         16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
> .if NUM_INVALIDATE_TLB_VECTORS > \idx
> apicinterrupt (INVALIDATE_TLB_VECTOR_START)+\idx \
>         invalidate_interrupt\idx smp_invalidate_interrupt
> .endif
> .endr
> #endif
>

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/entry_arch.h |  164 ++++++++++++++++++++++++++--
 arch/x86/kernel/entry_64.S        |  133 +++++++++++++++++++++-
 2 files changed, 285 insertions(+), 12 deletions(-)

diff -puN arch/x86/include/asm/entry_arch.h~x86-work-around-old-gas-bug arch/x86/include/asm/entry_arch.h
--- a/arch/x86/include/asm/entry_arch.h~x86-work-around-old-gas-bug
+++ a/arch/x86/include/asm/entry_arch.h
@@ -16,14 +16,166 @@ BUILD_INTERRUPT(call_function_single_int
 BUILD_INTERRUPT(irq_move_cleanup_interrupt,IRQ_MOVE_CLEANUP_VECTOR)
 BUILD_INTERRUPT(reboot_interrupt,REBOOT_VECTOR)
 
-.irp idx,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15, \
-	16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
-.if NUM_INVALIDATE_TLB_VECTORS > \idx
-BUILD_INTERRUPT3(invalidate_interrupt\idx,
-		 (INVALIDATE_TLB_VECTOR_START)+\idx,
+.if NUM_INVALIDATE_TLB_VECTORS > 0
+BUILD_INTERRUPT3(invalidate_interrupt0,
+		 (INVALIDATE_TLB_VECTOR_START)+0,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 1
+BUILD_INTERRUPT3(invalidate_interrupt1,
+		 (INVALIDATE_TLB_VECTOR_START)+1,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 2
+BUILD_INTERRUPT3(invalidate_interrupt2,
+		 (INVALIDATE_TLB_VECTOR_START)+2,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 3
+BUILD_INTERRUPT3(invalidate_interrupt3,
+		 (INVALIDATE_TLB_VECTOR_START)+3,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 4
+BUILD_INTERRUPT3(invalidate_interrupt4,
+		 (INVALIDATE_TLB_VECTOR_START)+4,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 5
+BUILD_INTERRUPT3(invalidate_interrupt5,
+		 (INVALIDATE_TLB_VECTOR_START)+5,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 6
+BUILD_INTERRUPT3(invalidate_interrupt6,
+		 (INVALIDATE_TLB_VECTOR_START)+6,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 7
+BUILD_INTERRUPT3(invalidate_interrupt7,
+		 (INVALIDATE_TLB_VECTOR_START)+7,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 8
+BUILD_INTERRUPT3(invalidate_interrupt8,
+		 (INVALIDATE_TLB_VECTOR_START)+8,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 9
+BUILD_INTERRUPT3(invalidate_interrupt9,
+		 (INVALIDATE_TLB_VECTOR_START)+9,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 10
+BUILD_INTERRUPT3(invalidate_interrupt10,
+		 (INVALIDATE_TLB_VECTOR_START)+10,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 11
+BUILD_INTERRUPT3(invalidate_interrupt11,
+		 (INVALIDATE_TLB_VECTOR_START)+11,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 12
+BUILD_INTERRUPT3(invalidate_interrupt12,
+		 (INVALIDATE_TLB_VECTOR_START)+12,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 13
+BUILD_INTERRUPT3(invalidate_interrupt13,
+		 (INVALIDATE_TLB_VECTOR_START)+13,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 14
+BUILD_INTERRUPT3(invalidate_interrupt14,
+		 (INVALIDATE_TLB_VECTOR_START)+14,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 15
+BUILD_INTERRUPT3(invalidate_interrupt15,
+		 (INVALIDATE_TLB_VECTOR_START)+15,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 16
+BUILD_INTERRUPT3(invalidate_interrupt16,
+		 (INVALIDATE_TLB_VECTOR_START)+16,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 17
+BUILD_INTERRUPT3(invalidate_interrupt17,
+		 (INVALIDATE_TLB_VECTOR_START)+17,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 18
+BUILD_INTERRUPT3(invalidate_interrupt18,
+		 (INVALIDATE_TLB_VECTOR_START)+18,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 19
+BUILD_INTERRUPT3(invalidate_interrupt19,
+		 (INVALIDATE_TLB_VECTOR_START)+19,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 20
+BUILD_INTERRUPT3(invalidate_interrupt20,
+		 (INVALIDATE_TLB_VECTOR_START)+20,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 21
+BUILD_INTERRUPT3(invalidate_interrupt21,
+		 (INVALIDATE_TLB_VECTOR_START)+21,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 22
+BUILD_INTERRUPT3(invalidate_interrupt22,
+		 (INVALIDATE_TLB_VECTOR_START)+22,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 23
+BUILD_INTERRUPT3(invalidate_interrupt23,
+		 (INVALIDATE_TLB_VECTOR_START)+23,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 24
+BUILD_INTERRUPT3(invalidate_interrupt24,
+		 (INVALIDATE_TLB_VECTOR_START)+24,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 25
+BUILD_INTERRUPT3(invalidate_interrupt25,
+		 (INVALIDATE_TLB_VECTOR_START)+25,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 26
+BUILD_INTERRUPT3(invalidate_interrupt26,
+		 (INVALIDATE_TLB_VECTOR_START)+26,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 27
+BUILD_INTERRUPT3(invalidate_interrupt27,
+		 (INVALIDATE_TLB_VECTOR_START)+27,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 28
+BUILD_INTERRUPT3(invalidate_interrupt28,
+		 (INVALIDATE_TLB_VECTOR_START)+28,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 29
+BUILD_INTERRUPT3(invalidate_interrupt29,
+		 (INVALIDATE_TLB_VECTOR_START)+29,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 30
+BUILD_INTERRUPT3(invalidate_interrupt30,
+		 (INVALIDATE_TLB_VECTOR_START)+30,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 31
+BUILD_INTERRUPT3(invalidate_interrupt31,
+		 (INVALIDATE_TLB_VECTOR_START)+31,
 		 smp_invalidate_interrupt)
 .endif
-.endr
 #endif
 
 BUILD_INTERRUPT(x86_platform_ipi, X86_PLATFORM_IPI_VECTOR)
diff -puN arch/x86/kernel/entry_64.S~x86-work-around-old-gas-bug arch/x86/kernel/entry_64.S
--- a/arch/x86/kernel/entry_64.S~x86-work-around-old-gas-bug
+++ a/arch/x86/kernel/entry_64.S
@@ -975,13 +975,134 @@ apicinterrupt X86_PLATFORM_IPI_VECTOR \
 	x86_platform_ipi smp_x86_platform_ipi
 
 #ifdef CONFIG_SMP
-.irp idx,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15, \
-	16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
-.if NUM_INVALIDATE_TLB_VECTORS > \idx
-apicinterrupt (INVALIDATE_TLB_VECTOR_START)+\idx \
-	invalidate_interrupt\idx smp_invalidate_interrupt
+.if NUM_INVALIDATE_TLB_VECTORS > 0
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+0 \
+	invalidate_interrupt0 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 1
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+1 \
+	invalidate_interrupt1 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 2
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+2 \
+	invalidate_interrupt2 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 3
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+3 \
+	invalidate_interrupt3 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 4
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+4 \
+	invalidate_interrupt4 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 5
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+5 \
+	invalidate_interrupt5 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 6
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+6 \
+	invalidate_interrupt6 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 7
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+7 \
+	invalidate_interrupt7 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 8
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+8 \
+	invalidate_interrupt8 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 9
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+9 \
+	invalidate_interrupt9 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 10
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+10 \
+	invalidate_interrupt10 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 11
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+11 \
+	invalidate_interrupt11 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 12
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+12 \
+	invalidate_interrupt12 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 13
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+13 \
+	invalidate_interrupt13 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 14
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+14 \
+	invalidate_interrupt14 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 15
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+15 \
+	invalidate_interrupt15 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 16
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+16 \
+	invalidate_interrupt16 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 17
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+17 \
+	invalidate_interrupt17 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 18
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+18 \
+	invalidate_interrupt18 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 19
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+19 \
+	invalidate_interrupt19 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 20
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+20 \
+	invalidate_interrupt20 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 21
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+21 \
+	invalidate_interrupt21 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 22
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+22 \
+	invalidate_interrupt22 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 23
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+23 \
+	invalidate_interrupt23 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 24
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+24 \
+	invalidate_interrupt24 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 25
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+25 \
+	invalidate_interrupt25 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 26
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+26 \
+	invalidate_interrupt26 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 27
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+27 \
+	invalidate_interrupt27 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 28
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+28 \
+	invalidate_interrupt28 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 29
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+29 \
+	invalidate_interrupt29 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 30
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+30 \
+	invalidate_interrupt30 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 31
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+31 \
+	invalidate_interrupt31 smp_invalidate_interrupt
 .endif
-.endr
 #endif
 
 apicinterrupt THRESHOLD_APIC_VECTOR \
_

Patches currently in -mm which might be from shaohua.li@intel.com are

linux-next.patch
x86-work-around-old-gas-bug.patch
mm-vmscan-kswapd-should-not-free-an-excessive-number-of-pages-when-balancing-small-zones.patch
fs-ioctlc-remove-unnecessary-variable.patch

