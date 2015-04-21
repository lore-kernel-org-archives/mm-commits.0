From: akpm@linux-foundation.org
Subject: +
 slab-correct-size_index-table-before-replacing-the-bootstrap-kmem_cache_node.patch added to -mm tree
Date: Tue, 21 Apr 2015 15:48:55 -0700
Message-ID: <5536d3d7.ntICgkmHyTdB72EZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34877 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879AbbDUWs4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Apr 2015 18:48:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.sanders@imgtec.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: correct size_index table before replacing the bootstrap kmem_cache_node.
has been added to the -mm tree.  Its filename is
     slab-correct-size_index-table-before-replacing-the-bootstrap-kmem_cache_node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-correct-size_index-table-before-replacing-the-bootstrap-kmem_cache_node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-correct-size_index-table-before-replacing-the-bootstrap-kmem_cache_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Sanders <daniel.sanders@imgtec.com>
Subject: slab: correct size_index table before replacing the bootstrap kmem_cache_node.

This patch moves the initialization of the size_index table slightly
earlier so that the first few kmem_cache_node's can be safely allocated
when KMALLOC_MIN_SIZE is large.

There are currently two ways to generate indices into kmalloc_caches (via
kmalloc_index() and via the size_index table in slab_common.c) and on some
arches (possibly only MIPS) they potentially disagree with each other
until create_kmalloc_caches() has been called.  It seems that the
intention is that the size_index table is a fast equivalent to
kmalloc_index() and that create_kmalloc_caches() patches the table to
return the correct value for the cases where kmalloc_index()'s
if-statements apply.

The failing sequence was:
* kmalloc_caches contains NULL elements
* kmem_cache_init initialises the element that 'struct
  kmem_cache_node' will be allocated to. For 32-bit Mips, this is a
  56-byte struct and kmalloc_index returns KMALLOC_SHIFT_LOW (7).
* init_list is called which calls kmalloc_node to allocate a 'struct
  kmem_cache_node'.
* kmalloc_slab selects the kmem_caches element using
  size_index[size_index_elem(size)]. For MIPS, size is 56, and the
  expression returns 6.
* This element of kmalloc_caches is NULL and allocation fails.
* If it had not already failed, it would have called
  create_kmalloc_caches() at this point which would have changed
  size_index[size_index_elem(size)] to 7.

I don't believe the bug to be LLVM specific but GCC doesn't normally
encounter the problem.  I haven't been able to identify exactly what GCC
is doing better (probably inlining) but it seems that GCC is managing to
optimize to the point that it eliminates the problematic allocations. 
This theory is supported by the fact that GCC can be made to fail in the
same way by changing inline, __inline, __inline__, and __always_inline in
include/linux/compiler-gcc.h such that they don't actually inline things.

Signed-off-by: Daniel Sanders <daniel.sanders@imgtec.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c        |    1 +
 mm/slab.h        |    1 +
 mm/slab_common.c |   36 +++++++++++++++++++++---------------
 mm/slub.c        |    1 +
 4 files changed, 24 insertions(+), 15 deletions(-)

diff -puN mm/slab.c~slab-correct-size_index-table-before-replacing-the-bootstrap-kmem_cache_node mm/slab.c
--- a/mm/slab.c~slab-correct-size_index-table-before-replacing-the-bootstrap-kmem_cache_node
+++ a/mm/slab.c
@@ -1454,6 +1454,7 @@ void __init kmem_cache_init(void)
 	kmalloc_caches[INDEX_NODE] = create_kmalloc_cache("kmalloc-node",
 				kmalloc_size(INDEX_NODE), ARCH_KMALLOC_FLAGS);
 	slab_state = PARTIAL_NODE;
+	setup_kmalloc_cache_index_table();
 
 	slab_early_init = 0;
 
diff -puN mm/slab.h~slab-correct-size_index-table-before-replacing-the-bootstrap-kmem_cache_node mm/slab.h
--- a/mm/slab.h~slab-correct-size_index-table-before-replacing-the-bootstrap-kmem_cache_node
+++ a/mm/slab.h
@@ -71,6 +71,7 @@ unsigned long calculate_alignment(unsign
 
 #ifndef CONFIG_SLOB
 /* Kmalloc array related functions */
+void setup_kmalloc_cache_index_table(void);
 void create_kmalloc_caches(unsigned long);
 
 /* Find the kmalloc slab corresponding for a certain size */
diff -puN mm/slab_common.c~slab-correct-size_index-table-before-replacing-the-bootstrap-kmem_cache_node mm/slab_common.c
--- a/mm/slab_common.c~slab-correct-size_index-table-before-replacing-the-bootstrap-kmem_cache_node
+++ a/mm/slab_common.c
@@ -784,25 +784,20 @@ struct kmem_cache *kmalloc_slab(size_t s
 }
 
 /*
- * Create the kmalloc array. Some of the regular kmalloc arrays
- * may already have been created because they were needed to
- * enable allocations for slab creation.
+ * Patch up the size_index table if we have strange large alignment
+ * requirements for the kmalloc array. This is only the case for
+ * MIPS it seems. The standard arches will not generate any code here.
+ *
+ * Largest permitted alignment is 256 bytes due to the way we
+ * handle the index determination for the smaller caches.
+ *
+ * Make sure that nothing crazy happens if someone starts tinkering
+ * around with ARCH_KMALLOC_MINALIGN
  */
-void __init create_kmalloc_caches(unsigned long flags)
+void __init setup_kmalloc_cache_index_table(void)
 {
 	int i;
 
-	/*
-	 * Patch up the size_index table if we have strange large alignment
-	 * requirements for the kmalloc array. This is only the case for
-	 * MIPS it seems. The standard arches will not generate any code here.
-	 *
-	 * Largest permitted alignment is 256 bytes due to the way we
-	 * handle the index determination for the smaller caches.
-	 *
-	 * Make sure that nothing crazy happens if someone starts tinkering
-	 * around with ARCH_KMALLOC_MINALIGN
-	 */
 	BUILD_BUG_ON(KMALLOC_MIN_SIZE > 256 ||
 		(KMALLOC_MIN_SIZE & (KMALLOC_MIN_SIZE - 1)));
 
@@ -833,6 +828,17 @@ void __init create_kmalloc_caches(unsign
 		for (i = 128 + 8; i <= 192; i += 8)
 			size_index[size_index_elem(i)] = 8;
 	}
+}
+
+/*
+ * Create the kmalloc array. Some of the regular kmalloc arrays
+ * may already have been created because they were needed to
+ * enable allocations for slab creation.
+ */
+void __init create_kmalloc_caches(unsigned long flags)
+{
+	int i;
+
 	for (i = KMALLOC_SHIFT_LOW; i <= KMALLOC_SHIFT_HIGH; i++) {
 		if (!kmalloc_caches[i]) {
 			kmalloc_caches[i] = create_kmalloc_cache(NULL,
diff -puN mm/slub.c~slab-correct-size_index-table-before-replacing-the-bootstrap-kmem_cache_node mm/slub.c
--- a/mm/slub.c~slab-correct-size_index-table-before-replacing-the-bootstrap-kmem_cache_node
+++ a/mm/slub.c
@@ -3700,6 +3700,7 @@ void __init kmem_cache_init(void)
 	kmem_cache_node = bootstrap(&boot_kmem_cache_node);
 
 	/* Now we can use the kmem_cache to allocate kmalloc slabs */
+	setup_kmalloc_cache_index_table();
 	create_kmalloc_caches(0);
 
 #ifdef CONFIG_SMP
_

Patches currently in -mm which might be from daniel.sanders@imgtec.com are

origin.patch
slab-correct-size_index-table-before-replacing-the-bootstrap-kmem_cache_node.patch

