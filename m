From: akpm@linux-foundation.org
Subject: - slub-rename-numa-defrag_ratio-to-remote_node_defrag_ratio.patch removed from -mm tree
Date: Mon, 04 Feb 2008 18:53:40 -0800
Message-ID: <200802050253.m152rLPO031496@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33257 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752198AbYBECxY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2008 21:53:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: Rename NUMA defrag_ratio to remote_node_defrag_ratio
has been removed from the -mm tree.  Its filename was
     slub-rename-numa-defrag_ratio-to-remote_node_defrag_ratio.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: SLUB: Rename NUMA defrag_ratio to remote_node_defrag_ratio
From: Christoph Lameter <clameter@sgi.com>

The NUMA defrag works by allocating objects from partial slabs on remote
nodes.  Rename it to

	remote_node_defrag_ratio

to be clear about this.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slub_def.h |    5 ++++-
 mm/slub.c                |   17 +++++++++--------
 2 files changed, 13 insertions(+), 9 deletions(-)

diff -puN include/linux/slub_def.h~slub-rename-numa-defrag_ratio-to-remote_node_defrag_ratio include/linux/slub_def.h
--- a/include/linux/slub_def.h~slub-rename-numa-defrag_ratio-to-remote_node_defrag_ratio
+++ a/include/linux/slub_def.h
@@ -59,7 +59,10 @@ struct kmem_cache {
 #endif
 
 #ifdef CONFIG_NUMA
-	int defrag_ratio;
+	/*
+	 * Defragmentation by allocating from a remote node.
+	 */
+	int remote_node_defrag_ratio;
 	struct kmem_cache_node *node[MAX_NUMNODES];
 #endif
 #ifdef CONFIG_SMP
diff -puN mm/slub.c~slub-rename-numa-defrag_ratio-to-remote_node_defrag_ratio mm/slub.c
--- a/mm/slub.c~slub-rename-numa-defrag_ratio-to-remote_node_defrag_ratio
+++ a/mm/slub.c
@@ -1292,7 +1292,8 @@ static struct page *get_any_partial(stru
 	 * expensive if we do it every time we are trying to find a slab
 	 * with available objects.
 	 */
-	if (!s->defrag_ratio || get_cycles() % 1024 > s->defrag_ratio)
+	if (!s->remote_node_defrag_ratio ||
+			get_cycles() % 1024 > s->remote_node_defrag_ratio)
 		return NULL;
 
 	zonelist = &NODE_DATA(slab_node(current->mempolicy))
@@ -2206,7 +2207,7 @@ static int kmem_cache_open(struct kmem_c
 
 	s->refcount = 1;
 #ifdef CONFIG_NUMA
-	s->defrag_ratio = 100;
+	s->remote_node_defrag_ratio = 100;
 #endif
 	if (!init_kmem_cache_nodes(s, gfpflags & ~SLUB_DMA))
 		goto error;
@@ -3848,21 +3849,21 @@ static ssize_t free_calls_show(struct km
 SLAB_ATTR_RO(free_calls);
 
 #ifdef CONFIG_NUMA
-static ssize_t defrag_ratio_show(struct kmem_cache *s, char *buf)
+static ssize_t remote_node_defrag_ratio_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%d\n", s->defrag_ratio / 10);
+	return sprintf(buf, "%d\n", s->remote_node_defrag_ratio / 10);
 }
 
-static ssize_t defrag_ratio_store(struct kmem_cache *s,
+static ssize_t remote_node_defrag_ratio_store(struct kmem_cache *s,
 				const char *buf, size_t length)
 {
 	int n = simple_strtoul(buf, NULL, 10);
 
 	if (n < 100)
-		s->defrag_ratio = n * 10;
+		s->remote_node_defrag_ratio = n * 10;
 	return length;
 }
-SLAB_ATTR(defrag_ratio);
+SLAB_ATTR(remote_node_defrag_ratio);
 #endif
 
 static struct attribute * slab_attrs[] = {
@@ -3893,7 +3894,7 @@ static struct attribute * slab_attrs[] =
 	&cache_dma_attr.attr,
 #endif
 #ifdef CONFIG_NUMA
-	&defrag_ratio_attr.attr,
+	&remote_node_defrag_ratio_attr.attr,
 #endif
 	NULL
 };
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
move-vmalloc_to_page-to-mm-vmalloc.patch
vmalloc-add-const-to-void-parameters.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch
is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries.patch
vmalloc-clean-up-page-array-indexing.patch
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
