From: akpm@linux-foundation.org
Subject: + cpu-hotplug-slab-fix-memory-leak-in-cpu-hotplug-error-path.patch added to -mm tree
Date: Thu, 26 Jul 2007 13:51:24 -0700
Message-ID: <200707262051.l6QKpOJa020273@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49922 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932935AbXGZUvp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 16:51:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, clameter@sgi.com, ego@in.ibm.com, oleg@tv-sign.ru, penberg@cs.helsinki.fi


The patch titled
     cpu hotplug: slab: fix memory leak in cpu hotplug error path
has been added to the -mm tree.  Its filename is
     cpu-hotplug-slab-fix-memory-leak-in-cpu-hotplug-error-path.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cpu hotplug: slab: fix memory leak in cpu hotplug error path
From: Akinobu Mita <akinobu.mita@gmail.com>

This patch fixes memory leak in error path.

In reality, we don't need to call cpuup_canceled(cpu) for now.  But upcoming
cpu hotplug error handling change needs this.

Cc: Christoph Lameter <clameter@sgi.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN mm/slab.c~cpu-hotplug-slab-fix-memory-leak-in-cpu-hotplug-error-path mm/slab.c
--- a/mm/slab.c~cpu-hotplug-slab-fix-memory-leak-in-cpu-hotplug-error-path
+++ a/mm/slab.c
@@ -1282,13 +1282,18 @@ static int __cpuinit cpuup_prepare(long 
 			shared = alloc_arraycache(node,
 				cachep->shared * cachep->batchcount,
 				0xbaadf00d);
-			if (!shared)
+			if (!shared) {
+				kfree(nc);
 				goto bad;
+			}
 		}
 		if (use_alien_caches) {
 			alien = alloc_alien_cache(node, cachep->limit);
-			if (!alien)
+			if (!alien) {
+				kfree(shared);
+				kfree(nc);
 				goto bad;
+			}
 		}
 		cachep->array[cpu] = nc;
 		l3 = cachep->nodelists[node];
@@ -1315,6 +1320,7 @@ static int __cpuinit cpuup_prepare(long 
 	}
 	return 0;
 bad:
+	cpuup_canceled(cpu);
 	return -ENOMEM;
 }
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
cpu-hotplug-slab-cleanup-cpuup_callback.patch
cpu-hotplug-slab-fix-memory-leak-in-cpu-hotplug-error-path.patch
cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch
cpu-hotplug-topology-remove-topology_dev_map.patch
cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-msr-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-cpuid-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-mce-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling.patch
