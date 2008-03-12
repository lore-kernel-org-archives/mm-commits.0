From: akpm@linux-foundation.org
Subject: + mm-fix-boundary-checking-in-free_bootmem_core.patch added to -mm tree
Date: Tue, 11 Mar 2008 22:38:05 -0700
Message-ID: <200803120538.m2C5c5pp012325@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57205 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751633AbYCLFjA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Mar 2008 01:39:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yhlu.kernel@gmail.com, ak@suse.de, clameter@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, mingo@elte.hu, y-goto@jp.fujitsu.com


The patch titled
     mm: fix boundary checking in free_bootmem_core
has been added to the -mm tree.  Its filename is
     mm-fix-boundary-checking-in-free_bootmem_core.patch

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
Subject: mm: fix boundary checking in free_bootmem_core
From: "Yinghai Lu" <yhlu.kernel@gmail.com>

So call it when numa is enabled, we don't know which node have that range. 
and make it more robust.

Try to trim it to get valid sidx, and eidx.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff -puN mm/bootmem.c~mm-fix-boundary-checking-in-free_bootmem_core mm/bootmem.c
--- a/mm/bootmem.c~mm-fix-boundary-checking-in-free_bootmem_core
+++ a/mm/bootmem.c
@@ -125,6 +125,7 @@ static int __init reserve_bootmem_core(b
 	BUG_ON(!size);
 	BUG_ON(PFN_DOWN(addr) >= bdata->node_low_pfn);
 	BUG_ON(PFN_UP(addr + size) > bdata->node_low_pfn);
+	BUG_ON(addr < bdata->node_boot_start);
 
 	sidx = PFN_DOWN(addr - bdata->node_boot_start);
 	eidx = PFN_UP(addr + size - bdata->node_boot_start);
@@ -156,21 +157,31 @@ static void __init free_bootmem_core(boo
 	unsigned long sidx, eidx;
 	unsigned long i;
 
+	BUG_ON(!size);
+
+	/* out range */
+	if (addr + size < bdata->node_boot_start ||
+		PFN_DOWN(addr) > bdata->node_low_pfn)
+		return;
 	/*
 	 * round down end of usable mem, partially free pages are
 	 * considered reserved.
 	 */
-	BUG_ON(!size);
-	BUG_ON(PFN_DOWN(addr + size) > bdata->node_low_pfn);
 
-	if (addr < bdata->last_success)
+	if (addr >= bdata->node_boot_start && addr < bdata->last_success)
 		bdata->last_success = addr;
 
 	/*
-	 * Round up the beginning of the address.
+	 * Round up to index to the range.
 	 */
-	sidx = PFN_UP(addr) - PFN_DOWN(bdata->node_boot_start);
+	if (PFN_UP(addr) > PFN_DOWN(bdata->node_boot_start))
+		sidx = PFN_UP(addr) - PFN_DOWN(bdata->node_boot_start);
+	else
+		sidx = 0;
+
 	eidx = PFN_DOWN(addr + size - bdata->node_boot_start);
+	if (eidx > bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start))
+		eidx = bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start);
 
 	for (i = sidx; i < eidx; i++) {
 		if (unlikely(!test_and_clear_bit(i, bdata->node_bootmem_map)))
_

Patches currently in -mm which might be from yhlu.kernel@gmail.com are

git-x86.patch
mm-make-mem_map-allocation-continuous.patch
mm-make-mem_map-allocation-continuous-checkpatch-fixes.patch
mm-fix-alloc_bootmem_core-to-use-fast-searching-for-all-nodes.patch
mm-fix-boundary-checking-in-free_bootmem_core.patch

