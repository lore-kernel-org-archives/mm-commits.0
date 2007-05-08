From: akpm@linux-foundation.org
Subject: + slub-get-rid-of-finish_bootstrap.patch added to -mm tree
Date: Tue, 08 May 2007 14:48:49 -0700
Message-ID: <200705082148.l48LmnTw002617@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43527 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968354AbXEHVsw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 17:48:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     SLUB: get rid of finish_bootstrap
has been added to the -mm tree.  Its filename is
     slub-get-rid-of-finish_bootstrap.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: get rid of finish_bootstrap
From: Christoph Lameter <clameter@sgi.com>

Its only purpose was to bring some sort of symmetry to sysfs usage when
dealing with bootstrapping per cpu flushing.  Since we do not time out slabs
anymore we have no need to run finish_bootstrap even without sysfs.  Fold it
back into slab_sysfs_init and drop the initcall for the !SYFS case.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   30 ++++++++++--------------------
 1 files changed, 10 insertions(+), 20 deletions(-)

diff -puN mm/slub.c~slub-get-rid-of-finish_bootstrap mm/slub.c
--- a/mm/slub.c~slub-get-rid-of-finish_bootstrap
+++ a/mm/slub.c
@@ -1699,23 +1699,6 @@ static int calculate_sizes(struct kmem_c
 
 }
 
-static int __init finish_bootstrap(void)
-{
-	struct list_head *h;
-	int err;
-
-	slab_state = SYSFS;
-
-	list_for_each(h, &slab_caches) {
-		struct kmem_cache *s =
-			container_of(h, struct kmem_cache, list);
-
-		err = sysfs_slab_add(s);
-		BUG_ON(err);
-	}
-	return 0;
-}
-
 static int kmem_cache_open(struct kmem_cache *s, gfp_t gfpflags,
 		const char *name, size_t size,
 		size_t align, unsigned long flags,
@@ -3482,6 +3465,7 @@ static int sysfs_slab_alias(struct kmem_
 
 static int __init slab_sysfs_init(void)
 {
+	struct list_head *h;
 	int err;
 
 	err = subsystem_register(&slab_subsys);
@@ -3490,7 +3474,15 @@ static int __init slab_sysfs_init(void)
 		return -ENOSYS;
 	}
 
-	finish_bootstrap();
+	slab_state = SYSFS;
+
+	list_for_each(h, &slab_caches) {
+		struct kmem_cache *s =
+			container_of(h, struct kmem_cache, list);
+
+		err = sysfs_slab_add(s);
+		BUG_ON(err);
+	}
 
 	while (alias_list) {
 		struct saved_alias *al = alias_list;
@@ -3506,6 +3498,4 @@ static int __init slab_sysfs_init(void)
 }
 
 __initcall(slab_sysfs_init);
-#else
-__initcall(finish_bootstrap);
 #endif
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slub-add-support-for-dynamic-cacheline-size-determination.patch
slub-add-support-for-dynamic-cacheline-size-determination-fix.patch
slub-after-object-padding-only-needed-for-redzoning.patch
slub-slabinfo-upgrade.patch
slub-use-check_valid_pointer-in-kmem_ptr_validate.patch
slub-clean-up-krealloc.patch
slub-clean-up-krealloc-fix.patch
slub-get-rid-of-finish_bootstrap.patch
slub-update-comments.patch
slub-add-macros-for-scanning-objects-in-a-slab.patch
slub-move-resiliency-check-into-sysfs-section.patch
slub-introduce-debugslabpage.patch
slub-consolidate-trace-code.patch
slub-move-tracking-definitions-and-check_valid_pointer-away-from-debug-code.patch
slub-add-config_slub_debug.patch
slub-include-lifetime-stats-and-sets-of-cpus--nodes-in-tracking-output.patch
slub-include-lifetime-stats-and-sets-of-cpus--nodes-in-tracking-output-fix.patch
slub-rework-slab-order-determination.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-reduce-antifrag-max-order.patch
slub-i386-support.patch
remove-constructor-from-buffer_head.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
revoke-core-code-slab-allocators-remove-slab_debug_initial-flag-revoke.patch
vmstat-use-our-own-timer-events.patch
vmstat-use-our-own-timer-events-fix.patch
make-vm-statistics-update-interval-configurable.patch
make-vm-statistics-update-interval-configurable-fix.patch
move-remote-node-draining-out-of-slab-allocators.patch
