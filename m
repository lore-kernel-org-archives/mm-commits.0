From: akpm@linux-foundation.org
Subject: - i386-fix-early-usage-of-atomic_add_return-and.patch removed from -mm tree
Date: Tue, 29 May 2007 11:53:11 -0700
Message-ID: <200705291853.l4TIrAJ6008450@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:49793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763201AbXE2SyE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:54:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     i386: fix early usage of atomic_add_return and local_add_return on real i386
has been removed from the -mm tree.  Its filename was
     i386-fix-early-usage-of-atomic_add_return-and.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-drm.patch
s390-spinlock-initializer-cleanup.patch
i386-hpet-check-if-the-counter-works.patch
