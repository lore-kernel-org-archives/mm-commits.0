From: akpm@linux-foundation.org
Subject: [merged] x86-mm-numa-use-setup_nr_node_ids-instead-of-opencoding.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:48:30 -0700
Message-ID: <20130430184830.832465A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:48308 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932871Ab3D3Ssb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:48:31 -0400
Received: by mail-vc0-f201.google.com with SMTP id gf12so85191vcb.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:48:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cody@linux.vnet.ibm.com, benh@kernel.crashing.org, hpa@zytor.com, mingo@redhat.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: x86/mm/numa: use setup_nr_node_ids() instead of opencoding.
has been removed from the -mm tree.  Its filename was
     x86-mm-numa-use-setup_nr_node_ids-instead-of-opencoding.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: x86/mm/numa: use setup_nr_node_ids() instead of opencoding.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/numa.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN arch/x86/mm/numa.c~x86-mm-numa-use-setup_nr_node_ids-instead-of-opencoding arch/x86/mm/numa.c
--- a/arch/x86/mm/numa.c~x86-mm-numa-use-setup_nr_node_ids-instead-of-opencoding
+++ a/arch/x86/mm/numa.c
@@ -114,14 +114,11 @@ void numa_clear_node(int cpu)
  */
 void __init setup_node_to_cpumask_map(void)
 {
-	unsigned int node, num = 0;
+	unsigned int node;
 
 	/* setup nr_node_ids if not done yet */
-	if (nr_node_ids == MAX_NUMNODES) {
-		for_each_node_mask(node, node_possible_map)
-			num = node;
-		nr_node_ids = num + 1;
-	}
+	if (nr_node_ids == MAX_NUMNODES)
+		setup_nr_node_ids();
 
 	/* allocate the map */
 	for (node = 0; node < nr_node_ids; node++)
_

Patches currently in -mm which might be from cody@linux.vnet.ibm.com are

origin.patch
linux-next.patch

