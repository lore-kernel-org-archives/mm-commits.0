From: akpm@osdl.org
Subject: + slab-use-cpu_lock_.patch added to -mm tree
Date: Tue, 09 Jan 2007 13:20:25 -0800
Message-ID: <200701092120.l09LKPQE015599@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44907 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932348AbXAIVUs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 9 Jan 2007 16:20:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, ego@in.ibm.com, oleg@tv-sign.ru, penberg@cs.helsinki.fi, vatsa@in.ibm.com


The patch titled
     slab: use CPU_LOCK_[ACQUIRE|RELEASE]
has been added to the -mm tree.  Its filename is
     slab-use-cpu_lock_.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/slab.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff -puN mm/slab.c~slab-use-cpu_lock_ mm/slab.c
--- a/mm/slab.c~slab-use-cpu_lock_
+++ a/mm/slab.c
@@ -1177,8 +1177,10 @@ static int __cpuinit cpuup_callback(stru
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
@@ -1264,16 +1266,9 @@ static int __cpuinit cpuup_callback(stru
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
@@ -1344,6 +1339,8 @@ free_array_cache:
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
fix-sparsemem-on-cell.patch
ehca-avoid-crash-on-kthread_create-failure.patch
ehca-fix-memleak-on-module-unloading.patch
git-s390.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed.patch
slab-use-cpu_lock_.patch
