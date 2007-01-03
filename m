From: akpm@osdl.org
Subject: + spin_lock_irq-enable-interrupts-while-spinning-x86_64-implementation.patch added to -mm tree
Date: Wed, 03 Jan 2007 13:12:47 -0800
Message-ID: <200701032112.l03LClwr031382@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50553 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932118AbXACVNF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 3 Jan 2007 16:13:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kiran@scalex86.org, ak@suse.de, md@google.com, mingo@elte.hu, pravin.shelar@calsoftinc.com, shai@scalex86.org


The patch titled
     spin_lock_irq: Enable interrupts while spinning: x86_64 implementation
has been added to the -mm tree.  Its filename is
     spin_lock_irq-enable-interrupts-while-spinning-x86_64-implementation.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spin_lock_irq: Enable interrupts while spinning: x86_64 implementation
From: Ravikiran G Thirumalai <kiran@scalex86.org>

Implement interrupt enabling while spinning for lock for spin_lock_irq

Signed-off by: Pravin B. Shelar <pravin.shelar@calsoftinc.com>
Signed-off by: Ravikiran Thirumalai <kiran@scalex86.org>
Signed-off by: Shai Fultheim <shai@scalex86.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Cc: Michael Davidson <md@google.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-x86_64/spinlock.h |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletion(-)

diff -puN include/asm-x86_64/spinlock.h~spin_lock_irq-enable-interrupts-while-spinning-x86_64-implementation include/asm-x86_64/spinlock.h
--- a/include/asm-x86_64/spinlock.h~spin_lock_irq-enable-interrupts-while-spinning-x86_64-implementation
+++ a/include/asm-x86_64/spinlock.h
@@ -63,7 +63,21 @@ static inline void __raw_spin_lock_flags
 		"5:\n\t"
 		: "+m" (lock->slock) : "r" ((unsigned)flags) : "memory");
 }
-#define __raw_spin_lock_irq(lock) __raw_spin_lock(lock)
+static inline void __raw_spin_lock_irq(raw_spinlock_t *lock)
+{
+	asm volatile(
+		"\n1:\t"
+		LOCK_PREFIX " ; decl %0\n\t"
+		"jns 2f\n"
+		"sti\n"		/* Enable interrupts during spin */
+		"3:\n"
+		"rep;nop\n\t"
+		"cmpl $0,%0\n\t"
+		"jle 3b\n\t"
+		"cli\n"
+		"jmp 1b\n"
+		"2:\t" : "+m" (lock->slock) : : "memory");
+}
 #endif
 
 static inline int __raw_spin_trylock(raw_spinlock_t *lock)
_

Patches currently in -mm which might be from kiran@scalex86.org are

x86-fix-dev_to_node-for-x86-and-x86_64.patch
mm-set-hashdist_default-to-1-for-x86_64-numa.patch
spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch.patch
spin_lock_irq-enable-interrupts-while-spinning-x86_64-implementation.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation.patch
slab-leaks3-default-y.patch
