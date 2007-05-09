From: akpm@linux-foundation.org
Subject: - slab-use-cpu_lock_.patch removed from -mm tree
Date: Wed, 09 May 2007 14:51:31 -0700
Message-ID: <200705092151.l49LpVis002886@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45618 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753568AbXEIWKC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 18:10:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, ego@in.ibm.com, oleg@tv-sign.ru, penberg@cs.helsinki.fi, vatsa@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     slab: use CPU_LOCK_[ACQUIRE|RELEASE]
has been removed from the -mm tree.  Its filename was
     slab-use-cpu_lock_.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: slab: use CPU_LOCK_[ACQUIRE|RELEASE]
From: Heiko Carstens <heiko.carstens@de.ibm.com>

Looks like this was forgotten when CPU_LOCK_[ACQUIRE|RELEASE] was
introduced.

Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Gautham Shenoy <ego@in.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff -puN mm/slab.c~slab-use-cpu_lock_ mm/slab.c
--- a/mm/slab.c~slab-use-cpu_lock_
+++ a/mm/slab.c
@@ -1186,8 +1186,10 @@ static int __cpuinit cpuup_callback(stru
 	int memsize = sizeof(struct kmem_list3);
 
 	switch (action) {
-	case CPU_UP_PREPARE:
+	case CPU_LOCK_ACQUIRE:
 		mutex_lock(&cache_chain_mutex);
+		break;
+	case CPU_UP_PREPARE:
 		/*
 		 * We need to do this right in the beginning since
 		 * alloc_arraycache's are going to use this list.
@@ -1274,16 +1276,9 @@ static int __cpuinit cpuup_callback(stru
 		}
 		break;
 	case CPU_ONLINE:
-		mutex_unlock(&cache_chain_mutex);
 		start_cpu_timer(cpu);
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
-	case CPU_DOWN_PREPARE:
-		mutex_lock(&cache_chain_mutex);
-		break;
-	case CPU_DOWN_FAILED:
-		mutex_unlock(&cache_chain_mutex);
-		break;
 	case CPU_DEAD:
 		/*
 		 * Even if all the cpus of a node are down, we don't free the
@@ -1354,6 +1349,8 @@ free_array_cache:
 				continue;
 			drain_freelist(cachep, l3, l3->free_objects);
 		}
+		break;
+	case CPU_LOCK_RELEASE:
 		mutex_unlock(&cache_chain_mutex);
 		break;
 	}
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
git-s390.patch
s390-spinlock-initializer-cleanup.patch
