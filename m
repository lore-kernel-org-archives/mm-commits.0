From: akpm@linux-foundation.org
Subject: [merged] m32r-fix-build-failure.patch removed from -mm tree
Date: Fri, 27 May 2016 11:42:11 -0700
Message-ID: <57489503.bmnthzgdWCw0ARLK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42407 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbcE0SmN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 14:42:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudipm.mukherjee@gmail.com, sudip.mukherjee@codethink.co.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: m32r: fix build failure
has been removed from the -mm tree.  Its filename was
     m32r-fix-build-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


