From: akpm@linux-foundation.org
Subject: [merged] alpha-fix-build-failures.patch removed from -mm
 tree
Date: Wed, 04 Oct 2017 12:39:51 -0700
Message-ID: <20171004193951.bzkCIwB6Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33220 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbdJDTjx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2017 15:39:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ink@jurassic.park.msu.ru, mattst88@gmail.com, mm-commits@vger.kernel.org, rth@twiddle.net, sudipm.mukherjee@gmail.com


The patch titled
     Subject: alpha: fix build failures
has been removed from the -mm tree.  Its filename was
     alpha-fix-build-failures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: alpha: fix build failures

The build of alpha allmodconfig is giving error:
arch/alpha/include/asm/mmu_context.h: In function 'ev5_switch_mm':
arch/alpha/include/asm/mmu_context.h:160:2: error:
	implicit declaration of function 'task_thread_info';
	did you mean 'init_thread_info'? [-Werror=implicit-function-declaration]

The file 'mmu_context.h' needed an extra header file.

Link: http://lkml.kernel.org/r/1505668810-7497-1-git-send-email-sudipm.mukherjee@gmail.com
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/mmu_context.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/alpha/include/asm/mmu_context.h~alpha-fix-build-failures arch/alpha/include/asm/mmu_context.h
--- a/arch/alpha/include/asm/mmu_context.h~alpha-fix-build-failures
+++ a/arch/alpha/include/asm/mmu_context.h
@@ -8,6 +8,7 @@
  */
 
 #include <linux/mm_types.h>
+#include <linux/sched.h>
 
 #include <asm/machvec.h>
 #include <asm/compiler.h>
_

Patches currently in -mm which might be from sudipm.mukherjee@gmail.com are


