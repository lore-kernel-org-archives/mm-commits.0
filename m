From: akpm@linux-foundation.org
Subject: [patch 01/51] alpha: fix build failures
Date: Tue, 03 Oct 2017 16:14:15 -0700
Message-ID: <59d419c7.YNGAQEfQb9wYYOAt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58288 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751177AbdJCXOQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 19:14:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, sudipm.mukherjee@gmail.com, ink@jurassic.park.msu.ru, mattst88@gmail.com, rth@twiddle.net

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
