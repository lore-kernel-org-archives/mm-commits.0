From: akpm@linux-foundation.org
Subject: [merged]
 documentation-memcg-warn-about-incomplete-kmemcg-state.patch removed from
 -mm tree
Date: Thu, 05 Jun 2014 12:50:03 -0700
Message-ID: <5390c9eb.kiOGWTPnZZ91xOqN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55942 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbaFETuE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:50:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, vdavydov@parallels.com

Subject: [merged] documentation-memcg-warn-about-incomplete-kmemcg-state.patch removed from -mm tree
To: vdavydov@parallels.com,hannes@cmpxchg.org,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:50:03 -0700


The patch titled
     Subject: Documentation/memcg: warn about incomplete kmemcg state
has been removed from the -mm tree.  Its filename was
     documentation-memcg-warn-about-incomplete-kmemcg-state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: Documentation/memcg: warn about incomplete kmemcg state

Kmemcg is currently under development and lacks some important features. 
In particular, it does not have support of kmem reclaim on memory pressure
inside cgroup, which practically makes it unusable in real life.  Let's
warn about it in both Kconfig and Documentation to prevent complaints
arising.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |    5 +++++
 init/Kconfig                     |    6 ++++++
 2 files changed, 11 insertions(+)

diff -puN Documentation/cgroups/memory.txt~documentation-memcg-warn-about-incomplete-kmemcg-state Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~documentation-memcg-warn-about-incomplete-kmemcg-state
+++ a/Documentation/cgroups/memory.txt
@@ -270,6 +270,11 @@ When oom event notifier is registered, e
 
 2.7 Kernel Memory Extension (CONFIG_MEMCG_KMEM)
 
+WARNING: Current implementation lacks reclaim support. That means allocation
+	 attempts will fail when close to the limit even if there are plenty of
+	 kmem available for reclaim. That makes this option unusable in real
+	 life so DO NOT SELECT IT unless for development purposes.
+
 With the Kernel memory extension, the Memory Controller is able to limit
 the amount of kernel memory used by the system. Kernel memory is fundamentally
 different than user memory, since it can't be swapped out, which makes it
diff -puN init/Kconfig~documentation-memcg-warn-about-incomplete-kmemcg-state init/Kconfig
--- a/init/Kconfig~documentation-memcg-warn-about-incomplete-kmemcg-state
+++ a/init/Kconfig
@@ -996,6 +996,12 @@ config MEMCG_KMEM
 	  the kmem extension can use it to guarantee that no group of processes
 	  will ever exhaust kernel resources alone.
 
+	  WARNING: Current implementation lacks reclaim support. That means
+	  allocation attempts will fail when close to the limit even if there
+	  are plenty of kmem available for reclaim. That makes this option
+	  unusable in real life so DO NOT SELECT IT unless for development
+	  purposes.
+
 config CGROUP_HUGETLB
 	bool "HugeTLB Resource Controller for Control Groups"
 	depends on RESOURCE_COUNTERS && HUGETLB_PAGE
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
linux-next.patch

