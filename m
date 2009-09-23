From: akpm@linux-foundation.org
Subject: [merged] x86-default-pcibus-cpumask-to-all-cpus-if-it-lacks-affinity.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:05:32 -0700
Message-ID: <200909232005.n8NK5W3k023547@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43709 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752128AbZIWUHH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:07:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, jbarnes@virtuousgeek.org, sjayaraman@suse.de, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     x86: default pcibus cpumask to all cpus if it lacks affinity
has been removed from the -mm tree.  Its filename was
     x86-default-pcibus-cpumask-to-all-cpus-if-it-lacks-affinity.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: default pcibus cpumask to all cpus if it lacks affinity
From: David Rientjes <rientjes@google.com>

The early initialization of the pci bus to node mapping leaves all busses
with a node id of -1 if it lacks memory affinity.  Thus, cpumask_of_pcibus
must return all online cpus for such busses.

Signed-off-by: David Rientjes <rientjes@google.com>
Tested-by: Suresh Jayaraman <sjayaraman@suse.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pci.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN arch/x86/include/asm/pci.h~x86-default-pcibus-cpumask-to-all-cpus-if-it-lacks-affinity arch/x86/include/asm/pci.h
--- a/arch/x86/include/asm/pci.h~x86-default-pcibus-cpumask-to-all-cpus-if-it-lacks-affinity
+++ a/arch/x86/include/asm/pci.h
@@ -143,7 +143,11 @@ static inline int __pcibus_to_node(const
 static inline const struct cpumask *
 cpumask_of_pcibus(const struct pci_bus *bus)
 {
-	return cpumask_of_node(__pcibus_to_node(bus));
+	int node;
+
+	node = __pcibus_to_node(bus);
+	return (node == -1) ? cpu_online_mask :
+			      cpumask_of_node(node);
 }
 #endif
 
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
hugetlb_file_setup-use-c-not-cpp.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch

