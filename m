From: akpm@linux-foundation.org
Subject: - mm-fix-boundary-checking-in-free_bootmem_core-fix.patch removed from -mm tree
Date: Fri, 21 Mar 2008 12:42:11 -0700
Message-ID: <200803211942.m2LJgEsX006938@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40448 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752252AbYCUTmq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 15:42:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yhlu.kernel@gmail.com, ak@suse.de, clameter@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, mingo@elte.hu, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mm: make free_bootmem to loop bdata_list
has been removed from the -mm tree.  Its filename was
     mm-fix-boundary-checking-in-free_bootmem_core-fix.patch

This patch was dropped because it was folded into mm-fix-boundary-checking-in-free_bootmem_core.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: make free_bootmem to loop bdata_list
From: "Yinghai Lu" <yhlu.kernel@gmail.com>

make the free_bootmem_core could handle out of range case. we could use
bdata_list to make sure the range can be freed for sure.

so next time, we don't need to loop online nodes and could use
free_bootmem directly.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/bootmem.c~mm-fix-boundary-checking-in-free_bootmem_core-fix mm/bootmem.c
--- a/mm/bootmem.c~mm-fix-boundary-checking-in-free_bootmem_core-fix
+++ a/mm/bootmem.c
@@ -432,7 +432,9 @@ int __init reserve_bootmem(unsigned long
 
 void __init free_bootmem(unsigned long addr, unsigned long size)
 {
-	free_bootmem_core(NODE_DATA(0)->bdata, addr, size);
+	bootmem_data_t *bdata;
+	list_for_each_entry(bdata, &bdata_list, list)
+		free_bootmem_core(bdata, addr, size);
 }
 
 unsigned long __init free_all_bootmem(void)
_

Patches currently in -mm which might be from yhlu.kernel@gmail.com are

mm-fix-boundary-checking-in-free_bootmem_core.patch
mm-fix-boundary-checking-in-free_bootmem_core-fix.patch
git-x86.patch
x86_64-free_bootmem-should-take-phy.patch
x86_64-do-not-reserve-ramdisk-two-times.patch
mm-make-mem_map-allocation-continuous.patch
mm-make-mem_map-allocation-continuous-checkpatch-fixes.patch
mm-fix-alloc_bootmem_core-to-use-fast-searching-for-all-nodes.patch
mm-allocate-section_map-for-sparse_init.patch

