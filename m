From: akpm@linux-foundation.org
Subject: + generic-swap-sparc-rename-swap-to-swap_ulong.patch added to -mm tree
Date: Wed, 03 Dec 2008 00:19:06 -0800
Message-ID: <200812030819.mB38J62r010208@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54659 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750924AbYLCITJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2008 03:19:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, davem@davemloft.net


The patch titled
     generic swap(): sparc: rename swap() to swap_ulong()
has been added to the -mm tree.  Its filename is
     generic-swap-sparc-rename-swap-to-swap_ulong.patch

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

linux-next.patch
9p-convert-d_iname-references-to-d_namename.patch
nfs-remove-redundant-tests-on-reading-new-pages.patch
generic-swap-ath9k-rename-swap-to-swap_array.patch
generic-swap-sparc-rename-swap-to-swap_ulong.patch
generic-swap-iphase-rename-swap-to-swap_byte_order.patch
generic-swap-lib-sortc-rename-swap-to-swap_func.patch
generic-swap-introduce-global-macro-swapa-b.patch
generic-swap-ext3-remove-local-swap-macro.patch
generic-swap-ext4-remove-local-swap-macro.patch
generic-swap-sched-remove-local-swap-macro.patch
generic-swap-dcache-use-swap-instead-of-private-do_switch.patch

