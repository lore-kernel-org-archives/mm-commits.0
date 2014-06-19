From: akpm@linux-foundation.org
Subject: + slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
 added to -mm tree
Date: Thu, 19 Jun 2014 15:49:38 -0700
Message-ID: <53a36902.3KPMLh1vVn5Hh5T6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52573 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965631AbaFSWtj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jun 2014 18:49:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, penberg@kernel.org, iamjoonsoo.kim@lge.com, cl@linux.com, cl@gentwo.org, akpm@linux-foundation.org


The patch titled
     Subject: slab-use-get_node-and-kmem_cache_node-functions-fix-2
has been added to the -mm tree.  Its filename is
     slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: slab-use-get_node-and-kmem_cache_node-functions-fix-2

mm/slab.c: In function 'slab_set_debugobj_lock_classes':
mm/slab.c:524: error: 'h' undeclared (first use in this function)
mm/slab.c:524: error: (Each undeclared identifier is reported only once
mm/slab.c:524: error: for each function it appears in.)
mm/slab.c:524: warning: left-hand operand of comma expression has no effect
mm/slab.c: In function 'cpuup_prepare':
mm/slab.c:1308: warning: passing argument 2 of 'slab_set_debugobj_lock_classes_node' makes pointer from integer without a cast
mm/slab.c:513: note: expected 'struct kmem_cache_node *' but argument is of type 'int'

Cc: Christoph Lameter <cl@gentwo.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/slab.c~slab-use-get_node-and-kmem_cache_node-functions-fix-2 mm/slab.c
--- a/mm/slab.c~slab-use-get_node-and-kmem_cache_node-functions-fix-2
+++ a/mm/slab.c
@@ -521,7 +521,7 @@ static void slab_set_debugobj_lock_class
 	int node;
 	struct kmem_cache_node *n;
 
-	for_each_kmem_cache_node(cachep, node, h)
+	for_each_kmem_cache_node(cachep, node, n)
 		slab_set_debugobj_lock_classes_node(cachep, n);
 }
 
@@ -1305,7 +1305,7 @@ static int cpuup_prepare(long cpu)
 		kfree(shared);
 		free_alien_cache(alien);
 		if (cachep->flags & SLAB_DEBUG_OBJECTS)
-			slab_set_debugobj_lock_classes_node(cachep, node);
+			slab_set_debugobj_lock_classes_node(cachep, n);
 		else if (!OFF_SLAB(cachep) &&
 			 !(cachep->flags & SLAB_DESTROY_BY_RCU))
 			on_slab_lock_classes_node(cachep, n);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
hugetlb-fix-copy_hugetlb_page_range-to-handle-migration-hwpoisoned-entry-checkpatch-fixes.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
mm-thp-fix-debug_pagealloc-oops-in-copy_page_rep-checkpatch-fixes.patch
shmem-fix-faulting-into-a-hole-while-its-punched-checkpatch-fixes.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
ia64-arch-ia64-include-uapi-asm-fcntlh-needs-personalityh.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
mm.patch
slub-use-new-node-functions-checkpatch-fixes.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
mm-memcontrol-rewrite-charge-api-fix.patch
mm-memcontrol-rewrite-uncharge-api-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
fs-isofs-logging-clean-up-fix.patch
initramfs-support-initramfs-that-is-more-than-2g-checkpatch-fixes.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

