From: akpm@linux-foundation.org
Subject: + x86-fix-ticket-spin-lock-asm-constraints.patch added to -mm tree
Date: Tue, 02 Sep 2008 15:08:59 -0700
Message-ID: <200809022208.m82M8xqE015260@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44774 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752113AbYIBWKK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 18:10:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com, hpa@zytor.com, mingo@elte.hu, npiggin@suse.de, tglx@linutronix.de


The patch titled
     x86: fix ticket spin lock asm constraints
has been added to the -mm tree.  Its filename is
     x86-fix-ticket-spin-lock-asm-constraints.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: fix ticket spin lock asm constraints
From: Jan Beulich <jbeulich@novell.com>

In addition to these changes I doubt the 'volatile' on all the ticket lock
asm()-s are really necessary.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/spinlock.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/asm-x86/spinlock.h~x86-fix-ticket-spin-lock-asm-constraints include/asm-x86/spinlock.h
--- a/include/asm-x86/spinlock.h~x86-fix-ticket-spin-lock-asm-constraints
+++ a/include/asm-x86/spinlock.h
@@ -101,7 +101,7 @@ static __always_inline int __ticket_spin
 		     "1:"
 		     "sete %b1\n\t"
 		     "movzbl %b1,%0\n\t"
-		     : "=&a" (tmp), "=Q" (new), "+m" (lock->slock)
+		     : "=&a" (tmp), "=&Q" (new), "+m" (lock->slock)
 		     :
 		     : "memory", "cc");
 
@@ -146,7 +146,7 @@ static __always_inline void __ticket_spi
 		     /* don't need lfence here, because loads are in-order */
 		     "jmp 1b\n"
 		     "2:"
-		     : "+Q" (inc), "+m" (lock->slock), "=r" (tmp)
+		     : "+r" (inc), "+m" (lock->slock), "=&r" (tmp)
 		     :
 		     : "memory", "cc");
 }
@@ -166,7 +166,7 @@ static __always_inline int __ticket_spin
 		     "1:"
 		     "sete %b1\n\t"
 		     "movzbl %b1,%0\n\t"
-		     : "=&a" (tmp), "=r" (new), "+m" (lock->slock)
+		     : "=&a" (tmp), "=&q" (new), "+m" (lock->slock)
 		     :
 		     : "memory", "cc");
 
_

Patches currently in -mm which might be from jbeulich@novell.com are

linux-next.patch
x86-init-annotations-in-early_printk-setup.patch
x86-adjust-dependencies-for-config_x86_cmov.patch
x86-pgd_cdtor-cleanup.patch
x86-x86_physvirt_bits-field-also-for-i386.patch
x86-adjust-vmalloc_sync_all-for-xen-2nd-try.patch
x86-fix-ticket-spin-lock-asm-constraints.patch
x86-64-reduce-boot-fixmap-space.patch
x86-64-add-two-__cpuinit-annotations.patch
x86-64-eliminate-dead-code.patch
x86-64-slightly-streamline-32-bit-syscall-entry-code.patch
adjust-init-section-definitions.patch
kconfig-eliminate-def_bool-n-constructs.patch

