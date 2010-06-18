From: akpm@linux-foundation.org
Subject: + x86-fix-wrong-page-aligned-size-calculation-in-ioremapping-code.patch added to -mm tree
Date: Fri, 18 Jun 2010 14:24:52 -0700
Message-ID: <201006182124.o5ILOq8W024226@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753037Ab0FRVZV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jun 2010 17:25:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: florz@florz.de, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: fix wrong page aligned size calculation in ioremapping code
has been added to the -mm tree.  Its filename is
     x86-fix-wrong-page-aligned-size-calculation-in-ioremapping-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: fix wrong page aligned size calculation in ioremapping code
From: Florian Zumbiehl <florz@florz.de>

x86 early_iounmap(): fix off-by-one error in page alignment of allocation
size for sizes where size%PAGE_SIZE==1.

Signed-off-by: Florian Zumbiehl <florz@florz.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/ioremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/mm/ioremap.c~x86-fix-wrong-page-aligned-size-calculation-in-ioremapping-code arch/x86/mm/ioremap.c
--- a/arch/x86/mm/ioremap.c~x86-fix-wrong-page-aligned-size-calculation-in-ioremapping-code
+++ a/arch/x86/mm/ioremap.c
@@ -613,7 +613,7 @@ void __init early_iounmap(void __iomem *
 		return;
 	}
 	offset = virt_addr & ~PAGE_MASK;
-	nrpages = PAGE_ALIGN(offset + size - 1) >> PAGE_SHIFT;
+	nrpages = PAGE_ALIGN(offset + size) >> PAGE_SHIFT;
 
 	idx = FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*slot;
 	while (nrpages > 0) {
_

Patches currently in -mm which might be from florz@florz.de are

x86-fix-wrong-page-aligned-size-calculation-in-ioremapping-code.patch
wrong-page-aligned-size-calculation-in-ioremapping-code.patch

