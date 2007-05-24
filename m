From: akpm@linux-foundation.org
Subject: + smpboot-cachesize-comparison-fix-in-smp_tune_scheduling.patch added to -mm tree
Date: Thu, 24 May 2007 16:02:12 -0700
Message-ID: <200705242302.l4ON2Cbh005747@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38545 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752119AbXEXXCc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 May 2007 19:02:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jarkao2@o2.pl, ak@suse.de, mingo@elte.hu, nickpiggin@yahoo.com.au


The patch titled
     smpboot: cachesize comparison fix in smp_tune_scheduling()
has been added to the -mm tree.  Its filename is
     smpboot-cachesize-comparison-fix-in-smp_tune_scheduling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 insertion(+), 1 deletion(-)

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

documentation-memory-barrierstxt-various-fixes.patch
smpboot-cachesize-comparison-fix-in-smp_tune_scheduling.patch
