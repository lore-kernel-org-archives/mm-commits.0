From: akpm@linux-foundation.org
Subject: - bootmem-node-setup-agnostic-free_bootmem.patch removed from -mm tree
Date: Tue, 15 Apr 2008 00:16:13 -0700
Message-ID: <200804150716.m3F7GDrS016390@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41102 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753098AbYDOHRF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 03:17:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@saeurebad.de, ak@suse.de, clameter@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, mingo@elte.hu, y-goto@jp.fujitsu.com, yhlu.kernel@gmail.com, mm-commits@vger.kernel.org


The patch titled
     bootmem: node-setup agnostic free_bootmem()
has been removed from the -mm tree.  Its filename was
     bootmem-node-setup-agnostic-free_bootmem.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bootmem: node-setup agnostic free_bootmem()
From: Johannes Weiner <hannes@saeurebad.de>

Make free_bootmem() look up the node holding the specified address range which
lets it work transparently on single-node and multi-node configurations.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Acked-by: Andi Kleen <ak@suse.de>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN mm/bootmem.c~bootmem-node-setup-agnostic-free_bootmem mm/bootmem.c
--- a/mm/bootmem.c~bootmem-node-setup-agnostic-free_bootmem
+++ a/mm/bootmem.c
@@ -421,7 +421,15 @@ int __init reserve_bootmem(unsigned long
 
 void __init free_bootmem(unsigned long addr, unsigned long size)
 {
-	free_bootmem_core(NODE_DATA(0)->bdata, addr, size);
+	bootmem_data_t *bdata;
+
+	list_for_each_entry (bdata, &bdata_list, list) {
+		if (addr < bdata->node_boot_start)
+			continue;
+		free_bootmem_core(bdata, addr, size);
+		return;
+	}
+	BUG();
 }
 
 unsigned long __init free_all_bootmem(void)
_

Patches currently in -mm which might be from hannes@saeurebad.de are

bootmem-node-setup-agnostic-free_bootmem.patch
bootmem-node-setup-agnostic-free_bootmem-checkpatch-fixes.patch
git-x86.patch
arm-remove-redundant-display-of-free-swap-space-in-show_mem.patch
git-powerpc.patch
git-ia64.patch
git-mips.patch
parisc-remove-redundant-display-of-free-swap-space-in-show_mem.patch
git-s390.patch
git-xtensa.patch
mm-remove-unused-max_nodes_shift.patch
m68k-remove-redundant-display-of-free-swap-space-in-show_mem.patch
cris-remove-redundant-display-of-free-swap-space-in-show_mem.patch
add-warn_on_secs-macro-simplification.patch
add-warn_on_secs-macro-simplification-fix.patch
add-warn_on_secs-macro-simplification-fix-fix.patch

