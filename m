From: akpm@linux-foundation.org
Subject: + parisc-fix-wrong-page-aligned-size-calculation-in-ioremapping-code.patch added to -mm tree
Date: Fri, 18 Jun 2010 14:25:51 -0700
Message-ID: <201006182125.o5ILPpXZ024263@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51023 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753037Ab0FRV0K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jun 2010 17:26:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: florz@florz.de, deller@gmx.de, jejb@parisc-linux.org, kyle@mcmartin.ca


The patch titled
     parisc: fix wrong page aligned size calculation in ioremapping code
has been added to the -mm tree.  Its filename is
     parisc-fix-wrong-page-aligned-size-calculation-in-ioremapping-code.patch

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
Subject: parisc: fix wrong page aligned size calculation in ioremapping code
From: Florian Zumbiehl <florz@florz.de>

parisc __ioremap(): fix off-by-one error in page alignment of allocation
size for sizes where size%PAGE_SIZE==1.

Signed-off-by: Florian Zumbiehl <florz@florz.de>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/mm/ioremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/parisc/mm/ioremap.c~parisc-fix-wrong-page-aligned-size-calculation-in-ioremapping-code arch/parisc/mm/ioremap.c
--- a/arch/parisc/mm/ioremap.c~parisc-fix-wrong-page-aligned-size-calculation-in-ioremapping-code
+++ a/arch/parisc/mm/ioremap.c
@@ -71,7 +71,7 @@ void __iomem * __ioremap(unsigned long p
 	 */
 	offset = phys_addr & ~PAGE_MASK;
 	phys_addr &= PAGE_MASK;
-	size = PAGE_ALIGN(last_addr) - phys_addr;
+	size = PAGE_ALIGN(last_addr + 1) - phys_addr;
 
 	/*
 	 * Ok, go for it..
_

Patches currently in -mm which might be from florz@florz.de are

x86-fix-wrong-page-aligned-size-calculation-in-ioremapping-code.patch
parisc-fix-wrong-page-aligned-size-calculation-in-ioremapping-code.patch

