From: akpm@linux-foundation.org
Subject: [merged]
 slab-fix-wrong-retval-on-kmem_cache_create_memcg-error-path-2.patch removed from -mm tree
Date: Thu, 30 Jan 2014 12:05:16 -0800
Message-ID: <52eab07c.kWZojNAQP9SWrl1l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42379 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417AbaA3UFR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Jan 2014 15:05:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vdavydov@parallels.com, rientjes@google.com, penberg@kernel.org, cl@linux.com, davej@redhat.com

Subject: [merged] slab-fix-wrong-retval-on-kmem_cache_create_memcg-error-path-2.patch removed from -mm tree
To: davej@redhat.com,cl@linux.com,penberg@kernel.org,rientjes@google.com,vdavydov@parallels.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 30 Jan 2014 12:05:16 -0800


The patch titled
     Subject: slab: fix wrong retval on kmem_cache_create_memcg error path
has been removed from the -mm tree.  Its filename was
     slab-fix-wrong-retval-on-kmem_cache_create_memcg-error-path-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Jones <davej@redhat.com>
Subject: slab: fix wrong retval on kmem_cache_create_memcg error path

On kmem_cache_create_memcg() error path we set 'err', but leave 's' (the
new cache ptr) undefined.  The latter can be NULL if we could not allocate
the cache, or pointing to a freed area if we failed somewhere later while
trying to initialize it.  Initially we checked 'err' immediately before
exiting the function and returned NULL if it was set ignoring the value of
's':

    out_unlock:
        ...
        if (err) {
            /* report error */
            return NULL;
        }
        return s;

Recently this check was, in fact, broken by commit f717eb3abb5e ("slab: do
not panic if we fail to create memcg cache"), which turned it to:

    out_unlock:
        ...
        if (err && !memcg) {
            /* report error */
            return NULL;
        }
        return s;

As a result, if we are failing creating a cache for a memcg, we will skip
the check and return 's' that can contain crap.  Obviously, commit
f717eb3abb5e intended not to return crap on error allocating a cache for a
memcg, but only to remove the error reporting in this case, so the check
should look like this:

    out_unlock:
        ...
        if (err) {
            if (!memcg)
                return NULL;
            /* report error */
            return NULL;
        }
        return s;

[rientjes@google.com: despaghettification]
[vdavydov@parallels.com: patch monkeying]
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Dave Jones <davej@redhat.com>
Reported-by: Dave Jones <davej@redhat.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff -puN mm/slab_common.c~slab-fix-wrong-retval-on-kmem_cache_create_memcg-error-path-2 mm/slab_common.c
--- a/mm/slab_common.c~slab-fix-wrong-retval-on-kmem_cache_create_memcg-error-path-2
+++ a/mm/slab_common.c
@@ -233,14 +233,17 @@ out_unlock:
 	mutex_unlock(&slab_mutex);
 	put_online_cpus();
 
-	/*
-	 * There is no point in flooding logs with warnings or especially
-	 * crashing the system if we fail to create a cache for a memcg. In
-	 * this case we will be accounting the memcg allocation to the root
-	 * cgroup until we succeed to create its own cache, but it isn't that
-	 * critical.
-	 */
-	if (err && !memcg) {
+	if (err) {
+		/*
+		 * There is no point in flooding logs with warnings or
+		 * especially crashing the system if we fail to create a cache
+		 * for a memcg. In this case we will be accounting the memcg
+		 * allocation to the root cgroup until we succeed to create its
+		 * own cache, but it isn't that critical.
+		 */
+		if (!memcg)
+			return NULL;
+
 		if (flags & SLAB_PANIC)
 			panic("kmem_cache_create: Failed to create slab '%s'. Error %d\n",
 				name, err);
_

Patches currently in -mm which might be from davej@redhat.com are

origin.patch
numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug.patch
numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug-fix.patch
numa-mem-hotplug-fix-array-index-overflow-when-synchronizing-nid-to-memblockreserved.patch
linux-next.patch

