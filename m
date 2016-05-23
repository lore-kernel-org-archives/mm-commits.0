From: akpm@linux-foundation.org
Subject: + m32r-fix-build-failure.patch added to -mm tree
Date: Mon, 23 May 2016 13:48:29 -0700
Message-ID: <57436c9d.KK5HosxZl2eC5zL/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39539 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbcEWUsa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 16:48:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudipm.mukherjee@gmail.com, sudip.mukherjee@codethink.co.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: m32r: fix build failure
has been added to the -mm tree.  Its filename is
     m32r-fix-build-failure.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/m32r-fix-build-failure.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/m32r-fix-build-failure.patch

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
Subject: m32r: fix build failure

m32r allmodconfig build was failing with the error: ERROR:
"smp_flush_cache_all" [drivers/misc/lkdtm.ko] undefined!

lkdtm driver at drivers/misc is using flush_icache_range() which for m32r
is defined as smp_flush_cache_all() if CONFIG_SMP is defined.  But as
smp_flush_cache_all() was not exported so the build was failing with the
error of undefined symbol.

Link: http://lkml.kernel.org/r/1464001182-8329-1-git-send-email-sudipm.mukherjee@gmail.com
Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/kernel/smp.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/m32r/kernel/smp.c~m32r-fix-build-failure arch/m32r/kernel/smp.c
--- a/arch/m32r/kernel/smp.c~m32r-fix-build-failure
+++ a/arch/m32r/kernel/smp.c
@@ -164,6 +164,7 @@ void smp_flush_cache_all(void)
 	spin_unlock(&flushcache_lock);
 	preempt_enable();
 }
+EXPORT_SYMBOL(smp_flush_cache_all);
 
 void smp_flush_cache_all_interrupt(void)
 {
_

Patches currently in -mm which might be from sudipm.mukherjee@gmail.com are

m32r-fix-build-failure.patch

