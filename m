From: akpm@linux-foundation.org
Subject: [merged] x86-pageattr-test-remove-srandom32-call.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:02:23 -0700
Message-ID: <20130430190223.85F4D5A41E9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:55512 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933507Ab3D3TCY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:02:24 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so87439ggm.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:02:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: pageattr-test: remove srandom32 call
has been removed from the -mm tree.  Its filename was
     x86-pageattr-test-remove-srandom32-call.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: x86: pageattr-test: remove srandom32 call

pageattr-test calls srandom32() once every test iteration.  But calling
srandom32() after late_initcalls is not meaningfull.  Because the random
states for random32() is mixed by good random numbers in late_initcall
prandom_reseed().

So this removes the call to srandom32().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pageattr-test.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/x86/mm/pageattr-test.c~x86-pageattr-test-remove-srandom32-call arch/x86/mm/pageattr-test.c
--- a/arch/x86/mm/pageattr-test.c~x86-pageattr-test-remove-srandom32-call
+++ a/arch/x86/mm/pageattr-test.c
@@ -130,7 +130,6 @@ static int pageattr_test(void)
 	}
 
 	failed += print_split(&sa);
-	srandom32(100);
 
 	for (i = 0; i < NTEST; i++) {
 		unsigned long pfn = random32() % max_pfn_mapped;
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
drivers-net-rename-random32-to-prandom_u32.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
drivers-net-rename-random32-to-prandom_u32-fix-fix.patch
remove-unused-random32-and-srandom32.patch
notifier-error-inject-fix-module-names-in-kconfig.patch

