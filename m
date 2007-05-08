From: akpm@linux-foundation.org
Subject: - fault-injection-fix-failslab-with-config_numa.patch removed from -mm tree
Date: Mon, 07 May 2007 17:03:31 -0700
Message-ID: <200705080003.l4803V5f008958@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50458 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967342AbXEHAD5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:03:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, clameter@sgi.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     fault injection: fix failslab with CONFIG_NUMA
has been removed from the -mm tree.  Its filename was
     fault-injection-fix-failslab-with-config_numa.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fault injection: fix failslab with CONFIG_NUMA
From: Akinobu Mita <akinobu.mita@gmail.com>

Currently failslab injects failures into ____cache_alloc().  But with enabling
CONFIG_NUMA it's not enough to let actual slab allocator functions (kmalloc,
kmem_cache_alloc, ...) return NULL.

This patch moves fault injection hook inside of __cache_alloc() and
__cache_alloc_node().  These are lower call path than ____cache_alloc() and
enable to inject faulures to slab allocators with CONFIG_NUMA.

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN mm/slab.c~fault-injection-fix-failslab-with-config_numa mm/slab.c
--- a/mm/slab.c~fault-injection-fix-failslab-with-config_numa
+++ a/mm/slab.c
@@ -3170,7 +3170,7 @@ static int __init failslab_debugfs(void)
 	struct dentry *dir;
 	int err;
 
-       	err = init_fault_attr_dentries(&failslab.attr, "failslab");
+	err = init_fault_attr_dentries(&failslab.attr, "failslab");
 	if (err)
 		return err;
 	dir = failslab.attr.dentries.dir;
@@ -3208,9 +3208,6 @@ static inline void *____cache_alloc(stru
 
 	check_irq_off();
 
-	if (should_failslab(cachep, flags))
-		return NULL;
-
 	ac = cpu_cache_get(cachep);
 	if (likely(ac->avail)) {
 		STATS_INC_ALLOCHIT(cachep);
@@ -3402,6 +3399,9 @@ __cache_alloc_node(struct kmem_cache *ca
 	unsigned long save_flags;
 	void *ptr;
 
+	if (should_failslab(cachep, flags))
+		return NULL;
+
 	cache_alloc_debugcheck_before(cachep, flags);
 	local_irq_save(save_flags);
 
@@ -3472,6 +3472,9 @@ __cache_alloc(struct kmem_cache *cachep,
 	unsigned long save_flags;
 	void *objp;
 
+	if (should_failslab(cachep, flags))
+		return NULL;
+
 	cache_alloc_debugcheck_before(cachep, flags);
 	local_irq_save(save_flags);
 	objp = __do_cache_alloc(cachep, flags);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
git-alsa.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
fault-injection-disable-stacktrace-filter-for-x86-64.patch
use-slab_panic-flag-cleanup.patch
simplify-the-stacktrace-code.patch
dtlk-fix-error-checks-in-module_init.patch
procfs-use-simple_read_from_buffer.patch
cm4000_cs-fix-error-paths.patch
cm4000_cs-use-bitrev.patch
use-simple_read_from_buffer-in-fs.patch
use-simple_read_from_buffer-in-kernel.patch
sunrpc-fix-error-path-in-module_init.patch
