From: akpm@linux-foundation.org
Subject: +
 powerpc-numa-do-not-allocate-bootmem-memory-for-non-existing-nodes.patch
 added to -mm tree
Date: Tue, 06 Oct 2015 12:31:34 -0700
Message-ID: <56142196.smoi3ojEXjtyZZ0W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59898 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbbJFTbf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Oct 2015 15:31:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raghavendra.kt@linux.vnet.ibm.com, anton@samba.org, benh@kernel.crashing.org, gkurz@linux.vnet.ibm.com, grant.likely@linaro.org, mpe@ellerman.id.au, nacc@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com, paulus@samba.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/powerpc/mm/numa.c: do not allocate bootmem memory for non existing nodes
has been added to the -mm tree.  Its filename is
     powerpc-numa-do-not-allocate-bootmem-memory-for-non-existing-nodes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-numa-do-not-allocate-bootmem-memory-for-non-existing-nodes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-numa-do-not-allocate-bootmem-memory-for-non-existing-nodes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Subject: arch/powerpc/mm/numa.c: do not allocate bootmem memory for non existing nodes

With the setup_nr_nodes(), we have already initialized
node_possible_map.  So it is safe to use for_each_node here.

There are many places in the kernel that use hardcoded 'for' loop with
nr_node_ids, because all other architectures have numa nodes populated
serially.  That should be reason we had maintained the same for
powerpc.

But, since sparse numa node ids possible on powerpc, we unnecessarily
allocate memory for non existent numa nodes.

For e.g., on a system with 0,1,16,17 as numa nodes nr_node_ids=18 and
we allocate memory for nodes 2-14.  This patch we allocate memory for
only existing numa nodes.

The patch is boot tested on a 4 node tuleta, confirming with printks
that it works as expected.

Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Anton Blanchard <anton@samba.org>
Cc: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Cc: Greg Kurz <gkurz@linux.vnet.ibm.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/numa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/mm/numa.c~powerpc-numa-do-not-allocate-bootmem-memory-for-non-existing-nodes arch/powerpc/mm/numa.c
--- a/arch/powerpc/mm/numa.c~powerpc-numa-do-not-allocate-bootmem-memory-for-non-existing-nodes
+++ a/arch/powerpc/mm/numa.c
@@ -80,7 +80,7 @@ static void __init setup_node_to_cpumask
 		setup_nr_node_ids();
 
 	/* allocate the map */
-	for (node = 0; node < nr_node_ids; node++)
+	for_each_node(node)
 		alloc_bootmem_cpumask_var(&node_to_cpumask_map[node]);
 
 	/* cpumask_of_node() will now work */
_

Patches currently in -mm which might be from raghavendra.kt@linux.vnet.ibm.com are

mm-replace-nr_node_ids-for-loop-with-for_each_node-in-list-lru.patch
powerpc-numa-do-not-allocate-bootmem-memory-for-non-existing-nodes.patch

