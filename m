From: akpm@linux-foundation.org
Subject: - smpboot-cachesize-comparison-fix-in-smp_tune_scheduling.patch removed from -mm tree
Date: Fri, 01 Jun 2007 00:06:25 -0700
Message-ID: <200706010706.l5176OB2004713@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:54937 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758811AbXFAHGh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 03:06:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jarkao2@o2.pl, ak@suse.de, mingo@elte.hu, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     smpboot: cachesize comparison fix in smp_tune_scheduling()
has been removed from the -mm tree.  Its filename was
     smpboot-cachesize-comparison-fix-in-smp_tune_scheduling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: smpboot: cachesize comparison fix in smp_tune_scheduling()
From: Jarek Poplawski <jarkao2@o2.pl>

boot_cpu_data.x86_cache_size is signed int and can be < 0 too.

Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/smpboot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/smpboot.c~smpboot-cachesize-comparison-fix-in-smp_tune_scheduling arch/i386/kernel/smpboot.c
--- a/arch/i386/kernel/smpboot.c~smpboot-cachesize-comparison-fix-in-smp_tune_scheduling
+++ a/arch/i386/kernel/smpboot.c
@@ -948,7 +948,7 @@ static void smp_tune_scheduling(void)
 	if (cpu_khz) {
 		cachesize = boot_cpu_data.x86_cache_size;
 
-		if (cachesize > 0)
+		if ((long)cachesize > 0)
 			max_cache_size = cachesize * 1024;
 	}
 }
_

Patches currently in -mm which might be from jarkao2@o2.pl are

origin.patch
