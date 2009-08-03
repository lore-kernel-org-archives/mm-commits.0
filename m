From: akpm@linux-foundation.org
Subject: + i386-fix-double-accounting-in-reserve_top_address.patch added to -mm tree
Date: Mon, 03 Aug 2009 13:47:21 -0700
Message-ID: <200908032047.n73KlLMU017192@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47639 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753459AbZHCUrv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Aug 2009 16:47:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: JBeulich@novell.com, jbeulich@novell.com


The patch titled
     i386: fix double accounting in reserve_top_address()
has been added to the -mm tree.  Its filename is
     i386-fix-double-accounting-in-reserve_top_address.patch

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
Subject: i386: fix double accounting in reserve_top_address()
From: "Jan Beulich" <JBeulich@novell.com>

With VMALLOC_END included in the calculation of MAXMEM (as of 2.6.28) it
is no longer correct to also bump __VMALLOC_RESERVE in
reserve_top_address().  Doing so results in needlessly small lowmem.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pgtable.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/x86/mm/pgtable.c~i386-fix-double-accounting-in-reserve_top_address arch/x86/mm/pgtable.c
--- a/arch/x86/mm/pgtable.c~i386-fix-double-accounting-in-reserve_top_address
+++ a/arch/x86/mm/pgtable.c
@@ -329,7 +329,6 @@ void __init reserve_top_address(unsigned
 	printk(KERN_INFO "Reserving virtual address space above 0x%08x\n",
 	       (int)-reserve);
 	__FIXADDR_TOP = -reserve - PAGE_SIZE;
-	__VMALLOC_RESERVE += reserve;
 #endif
 }
 
_

Patches currently in -mm which might be from JBeulich@novell.com are

linux-next.patch
i386-fix-double-accounting-in-reserve_top_address.patch

