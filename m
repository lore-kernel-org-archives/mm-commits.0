From: akpm@linux-foundation.org
Subject: + x86_64-free_bootmem-should-take-phy.patch added to -mm tree
Date: Thu, 13 Mar 2008 15:04:00 -0700
Message-ID: <200803132204.m2DM40eb002671@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60091 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752734AbYCMWE0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Mar 2008 18:04:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yhlu.kernel@gmail.com, ak@suse.de, clameter@sgi.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86_64: free_bootmem should take a physical address
has been added to the -mm tree.  Its filename is
     x86_64-free_bootmem-should-take-phy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86_64: free_bootmem should take a physical address
From: "Yinghai Lu" <yhlu.kernel@gmail.com>

So use nodedata_phys directly.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/numa_64.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/x86/mm/numa_64.c~x86_64-free_bootmem-should-take-phy arch/x86/mm/numa_64.c
--- a/arch/x86/mm/numa_64.c~x86_64-free_bootmem-should-take-phy
+++ a/arch/x86/mm/numa_64.c
@@ -221,8 +221,7 @@ void __init setup_node_bootmem(int nodei
 				 bootmap_pages<<PAGE_SHIFT, PAGE_SIZE);
 	if (bootmap == NULL)  {
 		if (nodedata_phys < start || nodedata_phys >= end)
-			free_bootmem((unsigned long)node_data[nodeid],
-				     pgdat_size);
+			free_bootmem(nodedata_phys, pgdat_size);
 		node_data[nodeid] = NULL;
 		return;
 	}
_

Patches currently in -mm which might be from yhlu.kernel@gmail.com are

mm-fix-boundary-checking-in-free_bootmem_core.patch
mm-fix-boundary-checking-in-free_bootmem_core-fix.patch
git-x86.patch
x86_64-free_bootmem-should-take-phy.patch
mm-make-mem_map-allocation-continuous.patch
mm-make-mem_map-allocation-continuous-checkpatch-fixes.patch
mm-fix-alloc_bootmem_core-to-use-fast-searching-for-all-nodes.patch
mm-allocate-section_map-for-sparse_init.patch

