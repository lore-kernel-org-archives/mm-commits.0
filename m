From: akpm@linux-foundation.org
Subject: + powerpc-mm-numa-use-setup_nr_node_ids-instead-of-opencoding.patch added to -mm tree
Date: Tue, 26 Mar 2013 13:14:35 -0700
Message-ID: <20130326201435.D221631C102@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:50246 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599Ab3CZUOh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Mar 2013 16:14:37 -0400
Received: by mail-gh0-f201.google.com with SMTP id r13so279788ghr.0
        for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2013 13:14:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cody@linux.vnet.ibm.com, benh@kernel.crashing.org, hpa@zytor.com, mingo@redhat.com, yinghai@kernel.org


The patch titled
     Subject: powerpc/mm/numa: use setup_nr_node_ids() instead of opencoding.
has been added to the -mm tree.  Its filename is
     powerpc-mm-numa-use-setup_nr_node_ids-instead-of-opencoding.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: powerpc/mm/numa: use setup_nr_node_ids() instead of opencoding.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>
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
+		setup_nr_node_ids()
 
 	/* allocate the map */
 	for (node = 0; node < nr_node_ids; node++)
_

Patches currently in -mm which might be from cody@linux.vnet.ibm.com are

page_alloc-make-setup_nr_node_ids-usable-for-arch-init-code.patch
x86-mm-numa-use-setup_nr_node_ids-instead-of-opencoding.patch
powerpc-mm-numa-use-setup_nr_node_ids-instead-of-opencoding.patch

