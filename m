From: akpm@linux-foundation.org
Subject: - arch-ia64-eliminate-null-test-and-memset-after-alloc_bootmem.patch removed from -mm tree
Date: Wed, 10 Dec 2008 11:29:21 -0800
Message-ID: <200812101929.mBAJTLBG021784@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52290 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755274AbYLJT31 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Dec 2008 14:29:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     arch/ia64: eliminate NULL test and memset after alloc_bootmem
has been removed from the -mm tree.  Its filename was
     arch-ia64-eliminate-null-test-and-memset-after-alloc_bootmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/ia64: eliminate NULL test and memset after alloc_bootmem
From: Julia Lawall <julia@diku.dk>

As noted by Akinobu Mita in patch b1fceac2b9e04d278316b2faddf276015fc06e3b,
alloc_bootmem and related functions never return NULL and always return a
zeroed region of memory.  Thus a NULL test or memset after calls to these
functions is unnecessary.

This was fixed using the following semantic patch.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression E;
statement S;
@@

E = \(alloc_bootmem\|alloc_bootmem_low\|alloc_bootmem_pages\|alloc_bootmem_low_pages\|alloc_bootmem_node\|alloc_bootmem_low_pages_node\|alloc_bootmem_pages_node\)(...)
... when != E
(
- BUG_ON (E == NULL);
|
- if (E == NULL) S
)

@@
expression E,E1;
@@

E = \(alloc_bootmem\|alloc_bootmem_low\|alloc_bootmem_pages\|alloc_bootmem_low_pages\|alloc_bootmem_node\|alloc_bootmem_low_pages_node\|alloc_bootmem_pages_node\)(...)
... when != E
- memset(E,0,E1);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/sn/kernel/setup.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN arch/ia64/sn/kernel/setup.c~arch-ia64-eliminate-null-test-and-memset-after-alloc_bootmem arch/ia64/sn/kernel/setup.c
--- a/arch/ia64/sn/kernel/setup.c~arch-ia64-eliminate-null-test-and-memset-after-alloc_bootmem
+++ a/arch/ia64/sn/kernel/setup.c
@@ -512,7 +512,6 @@ static void __init sn_init_pdas(char **c
 	for_each_online_node(cnode) {
 		nodepdaindr[cnode] =
 		    alloc_bootmem_node(NODE_DATA(cnode), sizeof(nodepda_t));
-		memset(nodepdaindr[cnode], 0, sizeof(nodepda_t));
 		memset(nodepdaindr[cnode]->phys_cpuid, -1,
 		    sizeof(nodepdaindr[cnode]->phys_cpuid));
 		spin_lock_init(&nodepdaindr[cnode]->ptc_lock);
@@ -521,11 +520,9 @@ static void __init sn_init_pdas(char **c
 	/*
 	 * Allocate & initialize nodepda for TIOs.  For now, put them on node 0.
 	 */
-	for (cnode = num_online_nodes(); cnode < num_cnodes; cnode++) {
+	for (cnode = num_online_nodes(); cnode < num_cnodes; cnode++)
 		nodepdaindr[cnode] =
 		    alloc_bootmem_node(NODE_DATA(0), sizeof(nodepda_t));
-		memset(nodepdaindr[cnode], 0, sizeof(nodepda_t));
-	}
 
 	/*
 	 * Now copy the array of nodepda pointers to each nodepda.
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
arch-arm-eliminate-null-test-and-memset-after-alloc_bootmem.patch
arch-avr32-eliminate-null-test-and-memset-after-alloc_bootmem.patch
powerpc-chrp-add-missing-of_node_put-in-pcic.patch
powerpc-powermac-add-missing-of_node_put.patch
drivers-media-video-cx88-cx88-alsac-adjust-error-handling-code.patch
drivers-mtd-maps-nettelc-use-array_size.patch
net-tipc-bcasth-use-array_size.patch
fs-namespacec-drop-code-after-return.patch
mm-page_allocc-eliminate-null-test-and-memset-after-alloc_bootmem.patch
drivers-macintosh-add-missing-of_node_put-in-therm_adt746xc.patch

