From: akpm@linux-foundation.org
Subject: - alpha-fix-hard_smp_processor_id-compile-error.patch removed from -mm tree
Date: Tue, 15 May 2007 11:07:07 -0700
Message-ID: <200705151807.l4FI77cC014146@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47033 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755751AbXEOSIQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 14:08:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: horms@verge.net.au, fernando@oss.ntt.co.jp, ink@jurassic.park.msu.ru, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha: fix hard_smp_processor_id compile error
has been removed from the -mm tree.  Its filename was
     alpha-fix-hard_smp_processor_id-compile-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: alpha: fix hard_smp_processor_id compile error
From: Simon Horman <horms@verge.net.au>

"Remove hardcoding of hard_smp_processor_id on UP systems",
2f4dfe206a2fc07099dfad77a8ea2f4b4ae2140f in Linus' tree, moved
the definition of hard_smp_processor_id linux/smp.h to asm/smp.h
for UP systems. This causes a regression on Alpha.

cc1: warnings being treated as errors
arch/alpha/kernel/setup.c: In function 'setup_arch':
arch/alpha/kernel/setup.c:506: warning: implicit declaration of function 'hard_smp_processor_id'
make[1]: *** [arch/alpha/kernel/setup.o] error 1
make: *** [arch/alpha/kernel] error 2

By including asm/smp.h non-conditionally in asm/mmu_context.h
the problem appears to be resolved.

Cc: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Signed-off-by: Simon Horman <horms@verge.net.au>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/mmu_context.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-alpha/mmu_context.h~alpha-fix-hard_smp_processor_id-compile-error include/asm-alpha/mmu_context.h
--- a/include/asm-alpha/mmu_context.h~alpha-fix-hard_smp_processor_id-compile-error
+++ a/include/asm-alpha/mmu_context.h
@@ -85,8 +85,8 @@ __reload_thread(struct pcb_struct *pcb)
  * +-------------+----------------+--------------+
  */
 
-#ifdef CONFIG_SMP
 #include <asm/smp.h>
+#ifdef CONFIG_SMP
 #define cpu_last_asn(cpuid)	(cpu_data[cpuid].last_asn)
 #else
 extern unsigned long last_asn;
_

Patches currently in -mm which might be from horms@verge.net.au are

origin.patch
arm-fix-hard_smp_processor_id-compile-error.patch
git-ia64.patch
use-menuconfig-objects-ipvs.patch
