From: akpm@linux-foundation.org
Subject: + x86-fake-numa-assign-cpus-to-nodes-in-round-robin-manner.patch added to -mm tree
Date: Mon, 11 Oct 2010 16:04:29 -0700
Message-ID: <201010112304.o9BN4T1P023454@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40823 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751422Ab0JKXEv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Oct 2010 19:04:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: knikanth@suse.de, hpa@zytor.com, mingo@elte.hu, rientjes@google.com, tglx@linutronix.de


The patch titled
     x86 fake numa: assign CPUs to nodes in round-robin manner
has been added to the -mm tree.  Its filename is
     x86-fake-numa-assign-cpus-to-nodes-in-round-robin-manner.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86 fake numa: assign CPUs to nodes in round-robin manner
From: Nikanth Karthikesan <knikanth@suse.de>

commit d9c2d5ac6af87b4491bff107113aaf16f6c2b2d9 "x86, numa: Use near(er)
online node instead of roundrobin for NUMA" changed NUMA initialization on
Intel to choose the nearest online node or first node.  Fake NUMA would be
better of with round-robin initialization, instead of the all CPUS on
first node.  Change the choice of first node, back to round-robin.

For testing NUMA kernel behaviour without cpusets and NUMA aware
applications, it would be better to have cpus in different nodes, rather
than all in a single node.  With cpusets migration of tasks scenarios
cannot not be tested.

I guess having it round-robin shouldn't affect the use cases for all cpus
on the first node.

The code comments in arch/x86/mm/numa_64.c:759 indicate that this used to
be the case, which was changed by commit d9c2d5ac6.  It changed from
roundrobin to nearer or first node.  And I couldn't find any reason for
this change in its changelog.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/intel.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN arch/x86/kernel/cpu/intel.c~x86-fake-numa-assign-cpus-to-nodes-in-round-robin-manner arch/x86/kernel/cpu/intel.c
--- a/arch/x86/kernel/cpu/intel.c~x86-fake-numa-assign-cpus-to-nodes-in-round-robin-manner
+++ a/arch/x86/kernel/cpu/intel.c
@@ -284,9 +284,7 @@ static void __cpuinit srat_detect_node(s
 	/* Don't do the funky fallback heuristics the AMD version employs
 	   for now. */
 	node = apicid_to_node[apicid];
-	if (node == NUMA_NO_NODE)
-		node = first_node(node_online_map);
-	else if (!node_online(node)) {
+	if (node == NUMA_NO_NODE || !node_online(node)) {
 		/* reuse the value from init_cpu_to_node() */
 		node = cpu_to_node(cpu);
 	}
_

Patches currently in -mm which might be from knikanth@suse.de are

linux-next.patch
x86-fake-numa-assign-cpus-to-nodes-in-round-robin-manner.patch
documentation-filesystems-proctxt-improve-smaps-field-documentation.patch
mm-smaps-export-mlock-information.patch
proc-pid-smaps-export-amount-of-anonymous-memory-in-a-mapping.patch
proc-pid-smaps-export-amount-of-anonymous-memory-in-a-mapping-doc.patch
proc-pid-pagemap-document-in-documentation-filesystems-proctxt.patch

