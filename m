From: akpm@linux-foundation.org
Subject: - memory-cgroup-hierarchy-documentation-v4.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:48:34 -0800
Message-ID: <200901082248.n08MmYAb027885@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53399 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758210AbZAHWtR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:49:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balbir@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, rientjes@google.com, xemul@openvz.org, yamamoto@valinux.c


The patch titled
     memcg: memory cgroup hierarchy documentation
has been removed from the -mm tree.  Its filename was
     memory-cgroup-hierarchy-documentation-v4.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: memory cgroup hierarchy documentation
From: Balbir Singh <balbir@linux.vnet.ibm.com>

Documentation updates for hierarchy support

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/controllers/memory.txt |   38 ++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff -puN Documentation/controllers/memory.txt~memory-cgroup-hierarchy-documentation-v4 Documentation/controllers/memory.txt
--- a/Documentation/controllers/memory.txt~memory-cgroup-hierarchy-documentation-v4
+++ a/Documentation/controllers/memory.txt
@@ -289,8 +289,44 @@ will be charged as a new owner of it.
   Because rmdir() moves all pages to parent, some out-of-use page caches can be
   moved to the parent. If you want to avoid that, force_empty will be useful.
 
+6. Hierarchy support
 
-6. TODO
+The memory controller supports a deep hierarchy and hierarchical accounting.
+The hierarchy is created by creating the appropriate cgroups in the
+cgroup filesystem. Consider for example, the following cgroup filesystem
+hierarchy
+
+		root
+	     /  |   \
+           /	|    \
+	  a	b	c
+			| \
+			|  \
+			d   e
+
+In the diagram above, with hierarchical accounting enabled, all memory
+usage of e, is accounted to its ancestors up until the root (i.e, c and root),
+that has memory.use_hierarchy enabled.  If one of the ancestors goes over its
+limit, the reclaim algorithm reclaims from the tasks in the ancestor and the
+children of the ancestor.
+
+6.1 Enabling hierarchical accounting and reclaim
+
+The memory controller by default disables the hierarchy feature. Support
+can be enabled by writing 1 to memory.use_hierarchy file of the root cgroup
+
+# echo 1 > memory.use_hierarchy
+
+The feature can be disabled by
+
+# echo 0 > memory.use_hierarchy
+
+NOTE1: Enabling/disabling will fail if the cgroup already has other
+cgroups created below it.
+
+NOTE2: This feature can be enabled/disabled per subtree.
+
+7. TODO
 
 1. Add support for accounting huge pages (as a separate controller)
 2. Make per-cgroup scanner reclaim not-shared pages first
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

origin.patch
linux-next.patch

