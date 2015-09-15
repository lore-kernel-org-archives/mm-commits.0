From: akpm@linux-foundation.org
Subject: +
 powerpc-numa-do-not-allocate-bootmem-memory-for-non-existing-nodes.patch
 added to -mm tree
Date: Tue, 15 Sep 2015 14:36:16 -0700
Message-ID: <55f88f50.GHGH3xOtniDv5zfB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48418 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbbIOVgR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Sep 2015 17:36:17 -0400
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

