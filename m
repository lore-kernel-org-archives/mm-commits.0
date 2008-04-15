From: akpm@linux-foundation.org
Subject: + bootmem-node-setup-agnostic-free_bootmem.patch added to -mm tree
Date: Mon, 14 Apr 2008 23:23:18 -0700
Message-ID: <200804150623.m3F6NInZ014509@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52002 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752346AbYDOGYD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 02:24:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@saeurebad.de, ak@suse.de, clameter@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, mingo@elte.hu, y-goto@jp.fujitsu.com, yhlu.kernel@gmail.com


The patch titled
     bootmem: node-setup agnostic free_bootmem()
has been added to the -mm tree.  Its filename is
     bootmem-node-setup-agnostic-free_bootmem.patch

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

bootmem-revert-mm-fix-boundary-checking-in-free_bootmem_core.patch
bootmem-node-setup-agnostic-free_bootmem.patch
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

