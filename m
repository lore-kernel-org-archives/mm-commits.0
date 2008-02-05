From: akpm@linux-foundation.org
Subject: - vmalloc-clean-up-page-array-indexing.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:29:42 -0800
Message-ID: <200802052229.m15MTNI7011974@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48615 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932209AbYBEWnB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:43:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     vmalloc: clean up page array indexing
has been removed from the -mm tree.  Its filename was
     vmalloc-clean-up-page-array-indexing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmalloc: clean up page array indexing
From: Christoph Lameter <clameter@sgi.com>

The page array is repeatedly indexed both in vunmap and vmalloc_area_node(). 
Add a temporary variable to make it easier to read (and easier to patch
later).

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff -puN mm/vmalloc.c~vmalloc-clean-up-page-array-indexing mm/vmalloc.c
--- a/mm/vmalloc.c~vmalloc-clean-up-page-array-indexing
+++ a/mm/vmalloc.c
@@ -384,8 +384,10 @@ static void __vunmap(const void *addr, i
 		int i;
 
 		for (i = 0; i < area->nr_pages; i++) {
-			BUG_ON(!area->pages[i]);
-			__free_page(area->pages[i]);
+			struct page *page = area->pages[i];
+
+			BUG_ON(!page);
+			__free_page(page);
 		}
 
 		if (area->flags & VM_VPAGES)
@@ -489,15 +491,19 @@ void *__vmalloc_area_node(struct vm_stru
 	}
 
 	for (i = 0; i < area->nr_pages; i++) {
+		struct page *page;
+
 		if (node < 0)
-			area->pages[i] = alloc_page(gfp_mask);
+			page = alloc_page(gfp_mask);
 		else
-			area->pages[i] = alloc_pages_node(node, gfp_mask, 0);
-		if (unlikely(!area->pages[i])) {
+			page = alloc_pages_node(node, gfp_mask, 0);
+
+		if (unlikely(!page)) {
 			/* Successfully allocated i pages, free them in __vunmap() */
 			area->nr_pages = i;
 			goto fail;
 		}
+		area->pages[i] = page;
 	}
 
 	if (map_vm_area(area, prot, &pages))
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
gregkh-driver-kset-move-sys-slab-to-sys-kernel-slab-slabinfo-fallback-from-sys-kernel-slab-to-sys-slab.patch
git-unionfs.patch
git-slub.patch
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
