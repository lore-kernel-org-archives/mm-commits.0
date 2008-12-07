From: akpm@linux-foundation.org
Subject: + pagemap-fix-32-bit-pagemap-regression.patch added to -mm tree
Date: Sat, 06 Dec 2008 23:59:28 -0800
Message-ID: <200812070759.mB77xSdM012530@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47123 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753470AbYLGH7z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 7 Dec 2008 02:59:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mpm@selenic.com, adobriyan@gmail.com, dave@linux.vnet.ibm.com, dgraham@nortel.com, stable@kernel.org


The patch titled
     pagemap: fix 32-bit pagemap regression
has been added to the -mm tree.  Its filename is
     pagemap-fix-32-bit-pagemap-regression.patch

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
Subject: pagemap: fix 32-bit pagemap regression
From: Matt Mackall <mpm@selenic.com>

The large pages fix from bcf8039ed45 ("pagemap: fix large pages in
pagemap") broke 32-bit pagemap.

Signed-off-by: Matt Mackall <mpm@selenic.com>
Reported-by: Doug Graham <dgraham@nortel.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: <stable@kernel.org>		[2.6.26.x, 2.6.27.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/proc/task_mmu.c~pagemap-fix-32-bit-pagemap-regression fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~pagemap-fix-32-bit-pagemap-regression
+++ a/fs/proc/task_mmu.c
@@ -557,9 +557,9 @@ static u64 swap_pte_to_pagemap_entry(pte
 	return swp_type(e) | (swp_offset(e) << MAX_SWAPFILES_SHIFT);
 }
 
-static unsigned long pte_to_pagemap_entry(pte_t pte)
+static u64 pte_to_pagemap_entry(pte_t pte)
 {
-	unsigned long pme = 0;
+	u64 pme = 0;
 	if (is_swap_pte(pte))
 		pme = PM_PFRAME(swap_pte_to_pagemap_entry(pte))
 			| PM_PSHIFT(PAGE_SHIFT) | PM_SWAP;
_

Patches currently in -mm which might be from mpm@selenic.com are

pagemap-fix-32-bit-pagemap-regression.patch
linux-next.patch

