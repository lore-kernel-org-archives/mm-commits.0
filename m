From: akpm@linux-foundation.org
Subject: [merged]
 mm-slub-fix-corrupted-freechain-in-deactivate_slab.patch removed from -mm
 tree
Date: Tue, 02 Jun 2020 14:37:48 -0700
Message-ID: <20200602213748.J1vK10_rv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726320AbgFBVht (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 17:37:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, dongli.zhang@oracle.com, iamjoonsoo.kim@lge.com, joe.jin@oracle.com, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com


The patch titled
     Subject: mm/slub.c: fix corrupted freechain in deactivate_slab()
has been removed from the -mm tree.  Its filename was
     mm-slub-fix-corrupted-freechain-in-deactivate_slab.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dongli Zhang <dongli.zhang@oracle.com>
Subject: mm/slub.c: fix corrupted freechain in deactivate_slab()

The slub_debug is able to fix the corrupted slab freelist/page.  However,
alloc_debug_processing() only checks the validity of current and next
freepointer during allocation path.  As a result, once some objects have
their freepointers corrupted, deactivate_slab() may lead to page fault.

Below is from a test kernel module when 'slub_debug=PUF,kmalloc-128
slub_nomerge'.  The test kernel corrupts the freepointer of one free
object on purpose.  Unfortunately, deactivate_slab() does not detect it
when iterating the freechain.

[ 92.665260] BUG: unable to handle page fault for address: 00000000123456f8
[ 92.671597] #PF: supervisor read access in kernel mode
[ 92.676159] #PF: error_code(0x0000) - not-present page
[ 92.681666] PGD 0 P4D 0
[ 92.684923] Oops: 0000 [#1] SMP PTI
... ...
[ 92.706684] RIP: 0010:deactivate_slab.isra.92+0xed/0x490
... ...
[ 92.819781] Call Trace:
[ 92.823129]  ? ext4_htree_store_dirent+0x30/0xf0
[ 92.829488]  ? ext4_htree_store_dirent+0x30/0xf0
[ 92.834852]  ? stack_trace_save+0x46/0x70
[ 92.839342]  ? init_object+0x66/0x80
[ 92.843729]  ? ___slab_alloc+0x536/0x570
[ 92.847664]  ___slab_alloc+0x536/0x570
[ 92.851696]  ? __find_get_block+0x23d/0x2c0
[ 92.856763]  ? ext4_htree_store_dirent+0x30/0xf0
[ 92.862258]  ? _cond_resched+0x10/0x40
[ 92.866925]  ? __getblk_gfp+0x27/0x2a0
[ 92.872136]  ? ext4_htree_store_dirent+0x30/0xf0
[ 92.878394]  ? __slab_alloc+0x17/0x30
[ 92.883222]  __slab_alloc+0x17/0x30
[ 92.887210]  __kmalloc+0x1d9/0x200
[ 92.891448]  ext4_htree_store_dirent+0x30/0xf0
[ 92.896748]  htree_dirblock_to_tree+0xcb/0x1c0
[ 92.902398]  ext4_htree_fill_tree+0x1bc/0x2d0
[ 92.907749]  ext4_readdir+0x54f/0x920
[ 92.912725]  iterate_dir+0x88/0x190
[ 92.917072]  __x64_sys_getdents+0xa6/0x140
[ 92.922760]  ? fillonedir+0xb0/0xb0
[ 92.927020]  ? do_syscall_64+0x49/0x170
[ 92.931603]  ? __ia32_sys_getdents+0x130/0x130
[ 92.937012]  do_syscall_64+0x49/0x170
[ 92.940754]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Therefore, this patch adds extra consistency check in deactivate_slab(). 
Once an object's freepointer is corrupted, all following objects starting
at this object are isolated.

[akpm@linux-foundation.org: fix build with CONFIG_SLAB_DEBUG=n]
Link: http://lkml.kernel.org/r/20200331031450.12182-1-dongli.zhang@oracle.com
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Cc: Joe Jin <joe.jin@oracle.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/mm/slub.c~mm-slub-fix-corrupted-freechain-in-deactivate_slab
+++ a/mm/slub.c
@@ -679,6 +679,20 @@ static void slab_fix(struct kmem_cache *
 	va_end(args);
 }
 
+static bool freelist_corrupted(struct kmem_cache *s, struct page *page,
+			       void *freelist, void *nextfree)
+{
+	if ((s->flags & SLAB_CONSISTENCY_CHECKS) &&
+	    !check_valid_pointer(s, page, nextfree)) {
+		object_err(s, page, freelist, "Freechain corrupt");
+		freelist = NULL;
+		slab_fix(s, "Isolate corrupted freechain");
+		return true;
+	}
+
+	return false;
+}
+
 static void print_trailer(struct kmem_cache *s, struct page *page, u8 *p)
 {
 	unsigned int off;	/* Offset of last byte */
@@ -1410,6 +1424,11 @@ static inline void inc_slabs_node(struct
 static inline void dec_slabs_node(struct kmem_cache *s, int node,
 							int objects) {}
 
+static bool freelist_corrupted(struct kmem_cache *s, struct page *page,
+			       void *freelist, void *nextfree)
+{
+	return false;
+}
 #endif /* CONFIG_SLUB_DEBUG */
 
 /*
@@ -2093,6 +2112,14 @@ static void deactivate_slab(struct kmem_
 		void *prior;
 		unsigned long counters;
 
+		/*
+		 * If 'nextfree' is invalid, it is possible that the object at
+		 * 'freelist' is already corrupted.  So isolate all objects
+		 * starting at 'freelist'.
+		 */
+		if (freelist_corrupted(s, page, freelist, nextfree))
+			break;
+
 		do {
 			prior = page->freelist;
 			counters = page->counters;
_

Patches currently in -mm which might be from dongli.zhang@oracle.com are
