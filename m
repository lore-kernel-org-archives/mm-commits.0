From: akpm@linux-foundation.org
Subject: [merged] i386-fix-double-accounting-in-reserve_top_address.patch removed from -mm tree
Date: Thu, 06 Aug 2009 13:31:15 -0700
Message-ID: <200908062031.n76KVFip004423@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44157 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756084AbZHFUbq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Aug 2009 16:31:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: JBeulich@novell.com, jbeulich@novell.com, mm-commits@vger.kernel.org


The patch titled
     i386: fix double accounting in reserve_top_address()
has been removed from the -mm tree.  Its filename was
     i386-fix-double-accounting-in-reserve_top_address.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

