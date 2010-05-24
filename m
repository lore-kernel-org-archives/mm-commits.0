From: akpm@linux-foundation.org
Subject: + numa-x86_64-use-generic-percpu-var-numa_node_id-implementation-fix3.patch added to -mm tree
Date: Mon, 24 May 2010 11:36:23 -0700
Message-ID: <201005241836.o4OIaNZh009068@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51767 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751050Ab0EXShH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 May 2010 14:37:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Lee.Schermerhorn@hp.com, lee.schermerhorn@hp.com, rdunlap@xenotime.net


The patch titled
     numa-x86_64-use-generic-percpu-var-numa_node_id-implementation-fix3
has been added to the -mm tree.  Its filename is
     numa-x86_64-use-generic-percpu-var-numa_node_id-implementation-fix3.patch

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
Subject: numa-x86_64-use-generic-percpu-var-numa_node_id-implementation-fix3
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

On Sun, 2010-05-16 at 16:37 -0700, Randy Dunlap wrote:
> include/linux/topology.h:248: error: implicit declaration of function 'cpu_to_node'
>
>
> config attached.

Hmmm, i386 NUMA.

With the following patch, your config builds correctly.  !NUMA i386
still builds, as well.

Lee

Fix i386 numa build:  define cpu_to_node() stub same as
early_cpu_to_node() for i386 numa builds.  Just return node
from cpu_to_node_map[].

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/topology.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN arch/x86/include/asm/topology.h~numa-x86_64-use-generic-percpu-var-numa_node_id-implementation-fix3 arch/x86/include/asm/topology.h
--- a/arch/x86/include/asm/topology.h~numa-x86_64-use-generic-percpu-var-numa_node_id-implementation-fix3
+++ a/arch/x86/include/asm/topology.h
@@ -53,10 +53,12 @@
 extern int cpu_to_node_map[];
 
 /* Returns the number of the node containing CPU 'cpu' */
-static inline int early_cpu_to_node(int cpu)
+static inline int __cpu_to_node(int cpu)
 {
 	return cpu_to_node_map[cpu];
 }
+#define early_cpu_to_node __cpu_to_node
+#define cpu_to_node __cpu_to_node
 
 #else /* CONFIG_X86_64 */
 
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

vmscan-page_check_references-check-low-order-lumpy-reclaim-properly.patch
vmscan-page_check_references-check-low-order-lumpy-reclaim-properly-update.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
numa-x86_64-use-generic-percpu-var-numa_node_id-implementation-fix3.patch

