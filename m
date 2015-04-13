From: akpm@linux-foundation.org
Subject: [merged] documentation-memcg-update-memcg-kmem-status.patch
 removed from -mm tree
Date: Mon, 13 Apr 2015 12:58:21 -0700
Message-ID: <552c1fdd.uArRb81UAfKK/cRx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57796 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbbDMT6V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Apr 2015 15:58:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, corbet@lwn.net, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/memcg: update memcg/kmem status
has been removed from the -mm tree.  Its filename was
     documentation-memcg-update-memcg-kmem-status.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: Documentation/memcg: update memcg/kmem status

Memcg/kmem reclaim support has been finally merged. Reflect this in the
documentation.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |    8 +++-----
 init/Kconfig                     |    6 ------
 2 files changed, 3 insertions(+), 11 deletions(-)

diff -puN Documentation/cgroups/memory.txt~documentation-memcg-update-memcg-kmem-status Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~documentation-memcg-update-memcg-kmem-status
+++ a/Documentation/cgroups/memory.txt
@@ -275,11 +275,6 @@ When oom event notifier is registered, e
 
 2.7 Kernel Memory Extension (CONFIG_MEMCG_KMEM)
 
-WARNING: Current implementation lacks reclaim support. That means allocation
-	 attempts will fail when close to the limit even if there are plenty of
-	 kmem available for reclaim. That makes this option unusable in real
-	 life so DO NOT SELECT IT unless for development purposes.
-
 With the Kernel memory extension, the Memory Controller is able to limit
 the amount of kernel memory used by the system. Kernel memory is fundamentally
 different than user memory, since it can't be swapped out, which makes it
@@ -345,6 +340,9 @@ set:
     In this case, the admin could set up K so that the sum of all groups is
     never greater than the total memory, and freely set U at the cost of his
     QoS.
+    WARNING: In the current implementation, memory reclaim will NOT be
+    triggered for a cgroup when it hits K while staying below U, which makes
+    this setup impractical.
 
     U != 0, K >= U:
     Since kmem charges will also be fed to the user counter and reclaim will be
diff -puN init/Kconfig~documentation-memcg-update-memcg-kmem-status init/Kconfig
--- a/init/Kconfig~documentation-memcg-update-memcg-kmem-status
+++ a/init/Kconfig
@@ -1032,12 +1032,6 @@ config MEMCG_KMEM
 	  the kmem extension can use it to guarantee that no group of processes
 	  will ever exhaust kernel resources alone.
 
-	  WARNING: Current implementation lacks reclaim support. That means
-	  allocation attempts will fail when close to the limit even if there
-	  are plenty of kmem available for reclaim. That makes this option
-	  unusable in real life so DO NOT SELECT IT unless for development
-	  purposes.
