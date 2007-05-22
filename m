From: akpm@linux-foundation.org
Subject: + i386-fix-early-usage-of-atomic_add_return-and.patch added to -mm tree
Date: Tue, 22 May 2007 09:59:23 -0700
Message-ID: <200705221659.l4MGxNe0005933@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44052 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758341AbXEVRB1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 May 2007 13:01:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de


The patch titled
     i386: fix early usage of atomic_add_return and local_add_return on real i386
has been added to the -mm tree.  Its filename is
     i386-fix-early-usage-of-atomic_add_return-and.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: fix early usage of atomic_add_return and local_add_return on real i386
From: Thomas Gleixner <tglx@linutronix.de>

The check (boot_cpu_data.x86 == 3) in atomic_add_return() and
local_add_return() fails, when those operations are used before
boot_cpu_data is filled in.

Change the check to (boot_cpu_data.x86 <= 3) to fix this.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/atomic.h |    2 +-
 include/asm-i386/local.h  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/asm-i386/atomic.h~i386-fix-early-usage-of-atomic_add_return-and include/asm-i386/atomic.h
--- a/include/asm-i386/atomic.h~i386-fix-early-usage-of-atomic_add_return-and
+++ a/include/asm-i386/atomic.h
@@ -182,7 +182,7 @@ static __inline__ int atomic_add_return(
 	int __i;
 #ifdef CONFIG_M386
 	unsigned long flags;
-	if(unlikely(boot_cpu_data.x86==3))
+	if(unlikely(boot_cpu_data.x86 <= 3))
 		goto no_xadd;
 #endif
 	/* Modern 486+ processor */
diff -puN include/asm-i386/local.h~i386-fix-early-usage-of-atomic_add_return-and include/asm-i386/local.h
--- a/include/asm-i386/local.h~i386-fix-early-usage-of-atomic_add_return-and
+++ a/include/asm-i386/local.h
@@ -135,7 +135,7 @@ static __inline__ long local_add_return(
 	long __i;
 #ifdef CONFIG_M386
 	unsigned long flags;
-	if(unlikely(boot_cpu_data.x86==3))
+	if(unlikely(boot_cpu_data.x86 <= 3))
 		goto no_xadd;
 #endif
 	/* Modern 486+ processor */
_

Patches currently in -mm which might be from tglx@linutronix.de are

ignore-bogus-acpi-info-for-offline-cpus.patch
nohz-rate-limit-the-local-softirq-pending-warning-output.patch
drm-spinlock-initializer-cleanup.patch
s390-spinlock-initializer-cleanup.patch
i386-hpet-check-if-the-counter-works.patch
doc-clocksources.patch
prevent-going-idle-with-softirq-pending.patch
fix-crash-with-irqpoll-due-to-the-irqf_irqpoll-flag.patch
i386-fix-early-usage-of-atomic_add_return-and.patch
