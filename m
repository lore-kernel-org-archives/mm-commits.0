From: akpm@linux-foundation.org
Subject: + mm-fix-handling-of-panic_on_oom-when-cpusets-are-in-use.patch added to -mm tree
Date: Wed, 25 Apr 2007 17:52:29 -0700
Message-ID: <200704260052.l3Q0qTx9017405@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57700 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753073AbXDZAwr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 20:52:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: y-goto@jp.fujitsu.com, bcrl@kvack.org, clameter@sgi.com, pj@sgi.com, rientjes@google.com, solo@google.com


The patch titled
     mm: fix handling of panic_on_oom when cpusets are in use
has been added to the -mm tree.  Its filename is
     mm-fix-handling-of-panic_on_oom-when-cpusets-are-in-use.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm: fix handling of panic_on_oom when cpusets are in use
From: Yasunori Goto <y-goto@jp.fujitsu.com>

The current panic_on_oom may not work if there is a process using
cpusets/mempolicy, because other nodes' memory may remain.  But some people
want failover by panic ASAP even if they are used.  This patch makes new
setting for its request.

This is tested on my ia64 box which has 3 nodes.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Ethan Solomita <solo@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |   23 +++++++++++++++++------
 mm/oom_kill.c               |    3 +++
 2 files changed, 20 insertions(+), 6 deletions(-)

diff -puN Documentation/sysctl/vm.txt~mm-fix-handling-of-panic_on_oom-when-cpusets-are-in-use Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-fix-handling-of-panic_on_oom-when-cpusets-are-in-use
+++ a/Documentation/sysctl/vm.txt
@@ -198,11 +198,22 @@ and may not be fast.
 
 panic_on_oom
 
-This enables or disables panic on out-of-memory feature.  If this is set to 1,
-the kernel panics when out-of-memory happens.  If this is set to 0, the kernel
-will kill some rogue process, called oom_killer.  Usually, oom_killer can kill
-rogue processes and system will survive.  If you want to panic the system
-rather than killing rogue processes, set this to 1.
+This enables or disables panic on out-of-memory feature.
 
-The default value is 0.
+If this is set to 0, the kernel will kill some rogue process,
+called oom_killer.  Usually, oom_killer can kill rogue processes and
+system will survive.
+
+If this is set to 1, the kernel panics when out-of-memory happens.
+However, if a process limits using nodes by mempolicy/cpusets,
+and those nodes become memory exhaustion status, one process
+may be killed by oom-killer. No panic occurs in this case.
+Because other nodes' memory may be free. This means system total status
+may be not fatal yet.
 
+If this is set to 2, the kernel panics compulsorily even on the
+above-mentioned.
+
+The default value is 0.
+1 and 2 are for failover of clustering. Please select either
+according to your policy of failover.
diff -puN mm/oom_kill.c~mm-fix-handling-of-panic_on_oom-when-cpusets-are-in-use mm/oom_kill.c
--- a/mm/oom_kill.c~mm-fix-handling-of-panic_on_oom-when-cpusets-are-in-use
+++ a/mm/oom_kill.c
@@ -413,6 +413,9 @@ void out_of_memory(struct zonelist *zone
 		show_mem();
 	}
 
+	if (sysctl_panic_on_oom == 2)
+		panic("out of memory. Compulsory panic_on_oom is selected.\n");
+
 	cpuset_lock();
 	read_lock(&tasklist_lock);
 
_

Patches currently in -mm which might be from y-goto@jp.fujitsu.com are

move-free-pages-between-lists-on-steal-fix-2.patch
move-free-pages-between-lists-on-steal-do-not-cross-section-boundary-when-moving-pages-between-mobility-lists.patch
handle-kernelcore=-boot-parameter-in-common-code-to-avoid-boot-problem-on-ia64.patch
fix-section-mismatch-of-memory-hotplug-related-code.patch
add-white-list-into-modpostc-for-memory-hotplug-code-and-ia64s-machvec-section.patch
mm-fix-handling-of-panic_on_oom-when-cpusets-are-in-use.patch
