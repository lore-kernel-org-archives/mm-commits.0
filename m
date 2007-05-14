From: akpm@linux-foundation.org
Subject: + alpha-fix-hard_smp_processor_id-compile-error.patch added to -mm tree
Date: Mon, 14 May 2007 12:19:38 -0700
Message-ID: <200705141919.l4EJJcDC023999@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40758 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754726AbXENTUp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 May 2007 15:20:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: horms@verge.net.au, fernando@oss.ntt.co.jp, ink@jurassic.park.msu.ru, rth@twiddle.net


The patch titled
     alpha: fix hard_smp_processor_id compile error
has been added to the -mm tree.  Its filename is
     alpha-fix-hard_smp_processor_id-compile-error.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 insertion(+), 1 deletion(-)

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

alpha-fix-hard_smp_processor_id-compile-error.patch
git-ia64.patch
use-menuconfig-objects-ipvs.patch
