From: akpm@linux-foundation.org
Subject: [patch 87/96] MIPS: SMP: move asmlinkage before return
 type
Date: Wed, 12 Jul 2017 14:37:25 -0700
Message-ID: <20170712213725.82NZIltjW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55266 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752363AbdGLVhb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:37:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, mm-commits@vger.kernel.org, ralf@linux-mips.org, torvalds@linux-foundation.org

From: Joe Perches <joe@perches.com>
Subject: MIPS: SMP: move asmlinkage before return type

Make the code like the rest of the kernel.

Link: http://lkml.kernel.org/r/756d3fb543e981b9284e756fa27616725a354b28.1499284835.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Ralf Baechle <ralf@linux-mips.org>	
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/smp.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/mips/include/asm/smp.h~mips-smp-move-asmlinkage-before-return-type arch/mips/include/asm/smp.h
--- a/arch/mips/include/asm/smp.h~mips-smp-move-asmlinkage-before-return-type
+++ a/arch/mips/include/asm/smp.h
@@ -47,7 +47,7 @@ extern int __cpu_logical_map[NR_CPUS];
 /* Mask of CPUs which are currently definitely operating coherently */
 extern cpumask_t cpu_coherent_mask;
 
-extern void asmlinkage smp_bootstrap(void);
+extern asmlinkage void smp_bootstrap(void);
 
 extern void calculate_cpu_foreign_map(void);
 
_
