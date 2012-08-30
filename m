From: akpm@linux-foundation.org
Subject: + x86-mm-initc-devmem_is_allowed-off-by-one.patch added to -mm tree
Date: Thu, 30 Aug 2012 15:13:01 -0700
Message-ID: <20120830221301.9FAFF1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:56552 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab2H3WND (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Aug 2012 18:13:03 -0400
Received: by qcqs25 with SMTP id s25so274832qcq.1
        for <mm-commits@vger.kernel.org>; Thu, 30 Aug 2012 15:13:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tmac@hp.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     Subject: x86/mm/init.c: devmem_is_allowed() off by one
has been added to the -mm tree.  Its filename is
     x86-mm-initc-devmem_is_allowed-off-by-one.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: T Makphaibulchoke <tmac@hp.com>
Subject: x86/mm/init.c: devmem_is_allowed() off by one

Fix an off-by-one error in devmem_is_allowed(), which allows accesses to
physical addresses 0x100000-0x100fff, an extra page past 1MB.

Signed-off-by: T Makphaibulchoke <tmac@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/mm/init.c~x86-mm-initc-devmem_is_allowed-off-by-one arch/x86/mm/init.c
--- a/arch/x86/mm/init.c~x86-mm-initc-devmem_is_allowed-off-by-one
+++ a/arch/x86/mm/init.c
@@ -319,7 +319,7 @@ unsigned long __init_refok init_memory_m
  */
 int devmem_is_allowed(unsigned long pagenr)
 {
-	if (pagenr <= 256)
+	if (pagenr < 256)
 		return 1;
 	if (iomem_is_exclusive(pagenr << PAGE_SHIFT))
 		return 0;
_

Patches currently in -mm which might be from tmac@hp.com are

x86-mm-initc-devmem_is_allowed-off-by-one.patch

