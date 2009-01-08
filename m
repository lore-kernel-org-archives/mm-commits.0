From: akpm@linux-foundation.org
Subject: - generic-swap-sparc-rename-swap-to-swap_ulong.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:51:10 -0800
Message-ID: <200901082251.n08MpALc030311@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37906 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763185AbZAHWvN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:51:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     generic swap(): sparc: rename swap() to swap_ulong()
has been removed from the -mm tree.  Its filename was
     generic-swap-sparc-rename-swap-to-swap_ulong.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: generic swap(): sparc: rename swap() to swap_ulong()
From: Wu Fengguang <fengguang.wu@intel.com>

In preparation for the introduction of a generic swap() macro.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/sun4m_smp.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN arch/sparc/kernel/sun4m_smp.c~generic-swap-sparc-rename-swap-to-swap_ulong arch/sparc/kernel/sun4m_smp.c
--- a/arch/sparc/kernel/sun4m_smp.c~generic-swap-sparc-rename-swap-to-swap_ulong
+++ a/arch/sparc/kernel/sun4m_smp.c
@@ -54,7 +54,8 @@ extern int __smp4m_processor_id(void);
 #define SMP_PRINTK(x)
 #endif
 
-static inline unsigned long swap(volatile unsigned long *ptr, unsigned long val)
+static inline unsigned long
+swap_ulong(volatile unsigned long *ptr, unsigned long val)
 {
 	__asm__ __volatile__("swap [%1], %0\n\t" :
 			     "=&r" (val), "=&r" (ptr) :
@@ -90,7 +91,7 @@ void __cpuinit smp4m_callin(void)
 	 * to call the scheduler code.
 	 */
 	/* Allow master to continue. */
-	swap(&cpu_callin_map[cpuid], 1);
+	swap_ulong(&cpu_callin_map[cpuid], 1);
 
 	/* XXX: What's up with all the flushes? */
 	local_flush_cache_all();
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch

