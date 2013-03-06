From: akpm@linux-foundation.org
Subject: + x86-pageattr-test-remove-srandom32-call.patch added to -mm tree
Date: Tue, 05 Mar 2013 17:01:53 -0800
Message-ID: <20130306010153.CF57A5A4253@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:46928 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab3CFBBz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Mar 2013 20:01:55 -0500
Received: by mail-qc0-f202.google.com with SMTP id k26so275244qcs.3
        for <mm-commits@vger.kernel.org>; Tue, 05 Mar 2013 17:01:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de


The patch titled
     Subject: x86: pageattr-test: remove srandom32 call
has been added to the -mm tree.  Its filename is
     x86-pageattr-test-remove-srandom32-call.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
raid6test-use-prandom_bytes.patch
uuid-use-prandom_bytes.patch
x86-pageattr-test-remove-srandom32-call.patch
x86-rename-random32-to-prandom_u32.patch
lib-rename-random32-to-prandom_u32.patch
mm-rename-random32-to-prandom_u32.patch
kernel-rename-random32-to-prandom_u32.patch
drbd-rename-random32-to-prandom_u32.patch
infiniband-rename-random32-to-prandom_u32.patch
mmc-rename-random32-to-prandom_u32.patch
video-uvesafb-rename-random32-to-prandom_u32.patch
xfs-rename-random32-to-prandom_u32.patch
uwb-rename-random32-to-prandom_u32.patch
lguest-rename-random32-to-prandom_u32.patch
scsi-rename-random32-to-prandom_u32.patch
drivers-net-rename-random32-to-prandom_u32.patch
net-sunrpc-rename-random32-to-prandom_u32.patch
net-sched-rename-random32-to-prandom_u32.patch
net-netfilter-rename-random32-to-prandom_u32.patch
net-core-rename-random32-to-prandom_u32.patch
net-core-remove-duplicate-statements-by-do-while-loop.patch
net-rename-random32-to-prandom.patch
remove-unused-random32-and-srandom32.patch

