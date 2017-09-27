From: akpm@linux-foundation.org
Subject: + alpha-fix-build-failures.patch added to -mm tree
Date: Wed, 27 Sep 2017 13:50:35 -0700
Message-ID: <59cc0f1b.pRv3YF9bWlMUuRMT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36750 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751708AbdI0Uug (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Sep 2017 16:50:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudipm.mukherjee@gmail.com, ink@jurassic.park.msu.ru, mattst88@gmail.com, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     Subject: alpha: fix build failures
has been added to the -mm tree.  Its filename is
     alpha-fix-build-failures.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/alpha-fix-build-failures.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/alpha-fix-build-failures.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

alpha-fix-build-failures.patch
m32r-define-cpu_big_endian.patch

