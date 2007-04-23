From: akpm@linux-foundation.org
Subject: + fault-injection-fix-failslab-with-config_numa.patch added to -mm tree
Date: Sun, 22 Apr 2007 17:34:49 -0700
Message-ID: <200704230034.l3N0YnCg004186@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45250 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030351AbXDWAe6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 22 Apr 2007 20:34:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, clameter@sgi.com, penberg@cs.helsinki.fi


The patch titled
     fault injection: fix failslab with CONFIG_NUMA
has been added to the -mm tree.  Its filename is
     fault-injection-fix-failslab-with-config_numa.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fault injection: fix failslab with CONFIG_NUMA
From: Akinobu Mita <akinobu.mita@gmail.com>

Currently failslab injects failures into ____cache_alloc().  But with enabling
CONFIG_NUMA it's not enough to let actual slab allocator functions (kmalloc,
kmem_cache_alloc, ...) return NULL.

This patch moves fault injection hook inside of __cache_alloc() and
__cache_alloc_node().  These are lower call path than ____cache_alloc() and
enable to inject faulures to slab allocators with CONFIG_NUMA.

Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN mm/slab.c~fault-injection-fix-failslab-with-config_numa mm/slab.c
--- a/mm/slab.c~fault-injection-fix-failslab-with-config_numa
+++ a/mm/slab.c
@@ -3141,7 +3141,7 @@ static int __init failslab_debugfs(void)
 	struct dentry *dir;
 	int err;
 
-       	err = init_fault_attr_dentries(&failslab.attr, "failslab");
+	err = init_fault_attr_dentries(&failslab.attr, "failslab");
 	if (err)
 		return err;
 	dir = failslab.attr.dentries.dir;
@@ -3179,9 +3179,6 @@ static inline void *____cache_alloc(stru
 
 	check_irq_off();
 
-	if (should_failslab(cachep, flags))
-		return NULL;
-
 	ac = cpu_cache_get(cachep);
 	if (likely(ac->avail)) {
 		STATS_INC_ALLOCHIT(cachep);
@@ -3373,6 +3370,9 @@ __cache_alloc_node(struct kmem_cache *ca
 	unsigned long save_flags;
 	void *ptr;
 
+	if (should_failslab(cachep, flags))
+		return NULL;
+
 	cache_alloc_debugcheck_before(cachep, flags);
 	local_irq_save(save_flags);
 
@@ -3443,6 +3443,9 @@ __cache_alloc(struct kmem_cache *cachep,
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

fault-injection-add-entry-to-maintainers.patch
mod_sysfs_setup-doesnt-return-errno-when-kobject_add_dir-failure-occurs.patch
git-dvb.patch
git-ieee1394.patch
git-net.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
fault-injection-disable-stacktrace-filter-for-x86-64.patch
slob-handle-slab_panic-flag.patch
use-slab_panic-flag-cleanup.patch
fault-injection-fix-failslab-with-config_numa.patch
simplify-the-stacktrace-code.patch
dtlk-fix-error-checks-in-module_init.patch
dtlk-fix-error-checks-in-module_init-fix.patch
