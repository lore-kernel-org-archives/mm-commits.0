From: akpm@linux-foundation.org
Subject: + x86-mm-numa-use-setup_nr_node_ids-instead-of-opencoding.patch added to -mm tree
Date: Tue, 26 Mar 2013 13:14:33 -0700
Message-ID: <20130326201433.D21635A4158@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:49074 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599Ab3CZUOf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Mar 2013 16:14:35 -0400
Received: by mail-vb0-f73.google.com with SMTP id fq11so192627vbb.0
        for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2013 13:14:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cody@linux.vnet.ibm.com, benh@kernel.crashing.org, hpa@zytor.com, mingo@redhat.com, yinghai@kernel.org


The patch titled
     Subject: x86/mm/numa: use setup_nr_node_ids() instead of opencoding.
has been added to the -mm tree.  Its filename is
     x86-mm-numa-use-setup_nr_node_ids-instead-of-opencoding.patch

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

page_alloc-make-setup_nr_node_ids-usable-for-arch-init-code.patch
x86-mm-numa-use-setup_nr_node_ids-instead-of-opencoding.patch
powerpc-mm-numa-use-setup_nr_node_ids-instead-of-opencoding.patch

