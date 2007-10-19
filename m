From: akpm@linux-foundation.org
Subject: - cpu-hotplug-slab-fix-memory-leak-in-cpu-hotplug-error-path.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:41:52 -0700
Message-ID: <200710190341.l9J3fqR0012852@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40637 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966455AbXJSD5M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:57:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, clameter@sgi.com, ego@in.ibm.com, oleg@tv-sign.ru, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     cpu hotplug: slab: fix memory leak in cpu hotplug error path
has been removed from the -mm tree.  Its filename was
     cpu-hotplug-slab-fix-memory-leak-in-cpu-hotplug-error-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
git-x86.patch
