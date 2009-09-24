From: akpm@linux-foundation.org
Subject: [merged] memory-controller-soft-limit-documentation-v9.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:34:35 -0700
Message-ID: <200909241934.n8OJYZa6031140@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32838 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754454AbZIXTe5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:34:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lizf@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memory controller: soft limit documentation
has been removed from the -mm tree.  Its filename was
     memory-controller-soft-limit-documentation-v9.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory controller: soft limit documentation
From: Balbir Singh <balbir@linux.vnet.ibm.com>

Soft limits is a new feature for the memory resource controller, something
similar has existed in the group scheduler in the form of shares.  The CPU
controllers interpretation of shares is very different though.  

Soft limits are the most useful feature to have for environments where the
administrator wants to overcommit the system, such that only on memory
contention do the limits become active.  The current soft limits
implementation provides a soft_limit_in_bytes interface for the memory
controller and not for memory+swap controller.  The implementation
maintains an RB-Tree of groups that exceed their soft limit and starts
reclaiming from the group that exceeds this limit by the maximum amount.

This patch:

Add documentation for soft limits

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |   37 ++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff -puN Documentation/cgroups/memory.txt~memory-controller-soft-limit-documentation-v9 Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memory-controller-soft-limit-documentation-v9
+++ a/Documentation/cgroups/memory.txt
@@ -379,7 +379,42 @@ cgroups created below it.
 
 NOTE2: This feature can be enabled/disabled per subtree.
 
-7. TODO
+7. Soft limits
+
+Soft limits allow for greater sharing of memory. The idea behind soft limits
+is to allow control groups to use as much of the memory as needed, provided
+
+a. There is no memory contention
+b. They do not exceed their hard limit
+
+When the system detects memory contention or low memory control groups
+are pushed back to their soft limits. If the soft limit of each control
+group is very high, they are pushed back as much as possible to make
+sure that one control group does not starve the others of memory.
+
+Please note that soft limits is a best effort feature, it comes with
+no guarantees, but it does its best to make sure that when memory is
+heavily contended for, memory is allocated based on the soft limit
+hints/setup. Currently soft limit based reclaim is setup such that
+it gets invoked from balance_pgdat (kswapd).
+
+7.1 Interface
+
+Soft limits can be setup by using the following commands (in this example we
+assume a soft limit of 256 megabytes)
+
+# echo 256M > memory.soft_limit_in_bytes
+
+If we want to change this to 1G, we can at any time use
+
+# echo 1G > memory.soft_limit_in_bytes
+
+NOTE1: Soft limits take effect over a long period of time, since they involve
+       reclaiming memory for balancing between memory cgroups
+NOTE2: It is recommended to set the soft limit always below the hard limit,
+       otherwise the hard limit will take precedence.
+
+8. TODO
 
 1. Add support for accounting huge pages (as a separate controller)
 2. Make per-cgroup scanner reclaim not-shared pages first
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

origin.patch

