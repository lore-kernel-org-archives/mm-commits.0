From: akpm@linux-foundation.org
Subject: - x86-fix-ticket-spin-lock-asm-constraints.patch removed from -mm tree
Date: Sat, 13 Sep 2008 00:45:26 -0700
Message-ID: <200809130745.m8D7jQkm026767@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52239 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753073AbYIMHpw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 13 Sep 2008 03:45:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, hpa@zytor.com, mingo@elte.hu, npiggin@suse.de, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: fix ticket spin lock asm constraints
has been removed from the -mm tree.  Its filename was
     x86-fix-ticket-spin-lock-asm-constraints.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
adjust-init-section-definitions.patch
kconfig-eliminate-def_bool-n-constructs.patch

