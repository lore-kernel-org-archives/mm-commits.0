From: akpm@linux-foundation.org
Subject: - pagemap-fix-32-bit-pagemap-regression.patch removed from -mm tree
Date: Wed, 10 Dec 2008 11:29:00 -0800
Message-ID: <200812101929.mBAJT0XR021546@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37660 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752783AbYLJTfz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Dec 2008 14:35:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpm@selenic.com, adobriyan@gmail.com, dave@linux.vnet.ibm.com, dgraham@nortel.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     pagemap: fix 32-bit pagemap regression
has been removed from the -mm tree.  Its filename was
     pagemap-fix-32-bit-pagemap-regression.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pagemap: fix 32-bit pagemap regression
From: Matt Mackall <mpm@selenic.com>

The large pages fix from bcf8039ed45 broke 32-bit pagemap by pulling the
pagemap entry code out into a function with the wrong return type. 
Pagemap entries are 64 bits on all systems and unsigned long is only 32
bits on 32-bit systems.

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

origin.patch
linux-next.patch
shmem-remove-unused-shmem_get_unmapped_area.patch
shmem-unify-regular-and-tiny-shmem.patch
random-dont-try-to-look-at-entropy_count-outside-the-lock.patch

