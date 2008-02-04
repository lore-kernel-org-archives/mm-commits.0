From: akpm@linux-foundation.org
Subject: - page-allocator-clean-up-pcp-draining-functions-swsusp-fix.patch removed from -mm tree
Date: Sun, 03 Feb 2008 19:51:03 -0800
Message-ID: <200802040350.m143oip3012533@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44230 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753752AbYBDDvb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 3 Feb 2008 22:51:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, dwalker@mvista.com, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     page-allocator-clean-up-pcp-draining-functions swsusp fix
has been removed from the -mm tree.  Its filename was
     page-allocator-clean-up-pcp-draining-functions-swsusp-fix.patch

This patch was dropped because it was folded into page-allocator-clean-up-pcp-draining-functions.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page-allocator-clean-up-pcp-draining-functions swsusp fix
From: Christoph Lameter <clameter@sgi.com>

Re-export drain_local_pages() again and use it for software suspend:

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Daniel Walker <dwalker@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h     |    1 +
 kernel/power/snapshot.c |    2 +-
 mm/page_alloc.c         |    2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/gfp.h~page-allocator-clean-up-pcp-draining-functions-swsusp-fix include/linux/gfp.h
--- a/include/linux/gfp.h~page-allocator-clean-up-pcp-draining-functions-swsusp-fix
+++ a/include/linux/gfp.h
@@ -229,5 +229,6 @@ extern void FASTCALL(free_cold_page(stru
 void page_alloc_init(void);
 void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp);
 void drain_all_pages(void);
+void drain_local_pages(void *dummy);
 
 #endif /* __LINUX_GFP_H */
diff -puN kernel/power/snapshot.c~page-allocator-clean-up-pcp-draining-functions-swsusp-fix kernel/power/snapshot.c
--- a/kernel/power/snapshot.c~page-allocator-clean-up-pcp-draining-functions-swsusp-fix
+++ a/kernel/power/snapshot.c
@@ -1203,7 +1203,7 @@ asmlinkage int swsusp_save(void)
 
 	printk(KERN_INFO "PM: Creating hibernation image: \n");
 
-	drain_all_pages();
+	drain_local_pages(NULL);
 	nr_pages = count_data_pages();
 	nr_highmem = count_highmem_pages();
 	printk(KERN_INFO "PM: Need to copy %u pages\n", nr_pages + nr_highmem);
diff -puN mm/page_alloc.c~page-allocator-clean-up-pcp-draining-functions-swsusp-fix mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-clean-up-pcp-draining-functions-swsusp-fix
+++ a/mm/page_alloc.c
@@ -925,7 +925,7 @@ static void drain_pages(unsigned int cpu
 /*
  * Spill all of this CPU's per-cpu pages back into the buddy allocator.
  */
-static void drain_local_pages(void *arg)
+void drain_local_pages(void *arg)
 {
 	drain_pages(smp_processor_id());
 }
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
move-vmalloc_to_page-to-mm-vmalloc.patch
vmalloc-add-const-to-void-parameters.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch
is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries.patch
vmalloc-clean-up-page-array-indexing.patch
vunmap-return-page-array-passed-on-vmap.patch
slub-move-count_partial.patch
slub-rename-numa-defrag_ratio-to-remote_node_defrag_ratio.patch
slub-consolidate-add_partial-and-add_partial_tail-to-one-function.patch
slub-use-non-atomic-bit-unlock.patch
slub-fix-coding-style-violations.patch
slub-noinline-some-functions-to-avoid-them-being-folded-into-alloc-free.patch
slub-move-kmem_cache_node-determination-into-add_full-and-add_partial.patch
slub-avoid-checking-for-a-valid-object-before-zeroing-on-the-fast-path.patch
slub-__slab_alloc-exit-path-consolidation.patch
slub-provide-unique-end-marker-for-each-slab.patch
slub-avoid-referencing-kmem_cache-structure-in-__slab_alloc.patch
slub-optional-fast-path-using-cmpxchg_local.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock.patch
slub-restructure-slab-alloc.patch
slub-comment-kmem_cache_cpu-structure.patch
slub-fix-sysfs-refcounting.patch
vm-allow-get_page_unless_zero-on-compound-pages.patch
bufferhead-revert-constructor-removal.patch
swapin_readahead-excise-numa-bogosity.patch
page-allocator-clean-up-pcp-draining-functions.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix-fix.patch
vmstat-small-revisions-to-refresh_cpu_vm_stats.patch
page-allocator-get-rid-of-the-list-of-cold-pages.patch
page-allocator-get-rid-of-the-list-of-cold-pages-fix.patch
vmstat-remove-prefetch.patch
set_page_refcounted-vm_bug_on-fix.patch
page-migraton-handle-orphaned-pages.patch
page-migraton-handle-orphaned-pages-fix.patch
mm-fix-section-mismatch-warning-in-sparsec.patch
percpu-__percpu_alloc_mask-can-dynamically-size-percpu_data.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
add-cmpxchg_local-to-asm-generic-for-per-cpu-atomic-operations.patch
add-cmpxchg_local-cmpxchg64-and-cmpxchg64_local-to-ia64.patch
dentries-extract-common-code-to-remove-dentry-from-lru.patch
dentries-extract-common-code-to-remove-dentry-from-lru-fix.patch
modules-handle-symbols-that-have-a-zero-value.patch
modules-include-sectionsh-to-avoid-defining-linker-variables.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch
