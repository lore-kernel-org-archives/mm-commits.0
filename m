From: akpm@linux-foundation.org
Subject: - slub-comment-kmem_cache_cpu-structure.patch removed from -mm tree
Date: Mon, 04 Feb 2008 18:45:56 -0800
Message-ID: <200802050245.m152jcx8031193@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60842 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751413AbYBECpl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2008 21:45:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: comment kmem_cache_cpu structure
has been removed from the -mm tree.  Its filename was
     slub-comment-kmem_cache_cpu-structure.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: SLUB: comment kmem_cache_cpu structure
From: Christoph Lameter <clameter@sgi.com>

Add some comments explaining the fields of the kmem_cache_cpu structure.

Signed-off-by: Chrsitoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slub_def.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN include/linux/slub_def.h~slub-comment-kmem_cache_cpu-structure include/linux/slub_def.h
--- a/include/linux/slub_def.h~slub-comment-kmem_cache_cpu-structure
+++ a/include/linux/slub_def.h
@@ -12,12 +12,12 @@
 #include <linux/kobject.h>
 
 struct kmem_cache_cpu {
-	void **freelist;
-	struct page *page;
-	int node;
-	unsigned int offset;
-	unsigned int objsize;
-	unsigned int objects;
+	void **freelist;	/* Pointer to first free per cpu object */
+	struct page *page;	/* The slab from which we are allocating */
+	int node;		/* The node of the page (or -1 for debug) */
+	unsigned int offset;	/* Freepointer offset (in word units) */
+	unsigned int objsize;	/* Size of an object (from kmem_cache) */
+	unsigned int objects;	/* Objects per slab (from kmem_cache) */
 };
 
 struct kmem_cache_node {
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
move-vmalloc_to_page-to-mm-vmalloc.patch
vmalloc-add-const-to-void-parameters.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch
is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries.patch
vmalloc-clean-up-page-array-indexing.patch
slub-comment-kmem_cache_cpu-structure.patch
slub-fix-sysfs-refcounting.patch
vm-allow-get_page_unless_zero-on-compound-pages.patch
bufferhead-revert-constructor-removal.patch
swapin_readahead-excise-numa-bogosity.patch
page-allocator-clean-up-pcp-draining-functions.patch
vmstat-small-revisions-to-refresh_cpu_vm_stats.patch
page-allocator-get-rid-of-the-list-of-cold-pages.patch
vmstat-remove-prefetch.patch
set_page_refcounted-vm_bug_on-fix.patch
page-migraton-handle-orphaned-pages.patch
mm-fix-section-mismatch-warning-in-sparsec.patch
gregkh-driver-kset-move-sys-slab-to-sys-kernel-slab-slabinfo-fallback-from-sys-kernel-slab-to-sys-slab.patch
git-unionfs.patch
git-newsetup.patch
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
