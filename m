From: akpm@linux-foundation.org
Subject: [merged] powerpc-mm-numa-use-setup_nr_node_ids-instead-of-opencoding.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:48:33 -0700
Message-ID: <20130430184833.85D395A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:62872 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932871Ab3D3Sse (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:48:34 -0400
Received: by mail-gg0-f201.google.com with SMTP id y3so84956ggc.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:48:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cody@linux.vnet.ibm.com, benh@kernel.crashing.org, hpa@zytor.com, mingo@redhat.com, sfr@canb.auug.org.au, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/mm/numa: use setup_nr_node_ids() instead of opencoding.
has been removed from the -mm tree.  Its filename was
     powerpc-mm-numa-use-setup_nr_node_ids-instead-of-opencoding.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: powerpc/mm/numa: use setup_nr_node_ids() instead of opencoding.

[sfr@canb.auug.org.au: add missing semicolon]
Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/numa.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN arch/powerpc/mm/numa.c~powerpc-mm-numa-use-setup_nr_node_ids-instead-of-opencoding arch/powerpc/mm/numa.c
--- a/arch/powerpc/mm/numa.c~powerpc-mm-numa-use-setup_nr_node_ids-instead-of-opencoding
+++ a/arch/powerpc/mm/numa.c
@@ -62,14 +62,11 @@ static int distance_lookup_table[MAX_NUM
  */
 static void __init setup_node_to_cpumask_map(void)
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

