From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-slab-rename-kmalloc-node-cache-to-kmalloc-size-fix-fix.patch removed
 from -mm tree
Date: Wed, 22 Feb 2017 15:13:44 -0800
Message-ID: <58ae1b28./u9X5MGHoV1IpkaU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45328 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933116AbdBVXUx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:20:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, cl@linux.com, iamjoonsoo.kim@lge.com, mawilcox@microsoft.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slab: rename kmalloc-node cache to kmalloc-<size>-fix2
has been removed from the -mm tree.  Its filename was
     mm-slab-rename-kmalloc-node-cache-to-kmalloc-size-fix-fix.patch

This patch was dropped because it was folded into mm-slab-rename-kmalloc-node-cache-to-kmalloc-size.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slab: rename kmalloc-node cache to kmalloc-<size>-fix2

Export the whole kmalloc_info structure instead of just a name accessor,
per Christoph Lameter.

Link: http://lkml.kernel.org/r/54e80303-b814-4232-66d4-95b34d3eb9d0@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c        |    2 +-
 mm/slab.h        |    7 ++++++-
 mm/slab_common.c |   10 +---------
 3 files changed, 8 insertions(+), 11 deletions(-)

diff -puN mm/slab.c~mm-slab-rename-kmalloc-node-cache-to-kmalloc-size-fix-fix mm/slab.c
--- a/mm/slab.c~mm-slab-rename-kmalloc-node-cache-to-kmalloc-size-fix-fix
+++ a/mm/slab.c
@@ -1289,7 +1289,7 @@ void __init kmem_cache_init(void)
 	 * structures first.  Without this, further allocations will bug.
 	 */
 	kmalloc_caches[INDEX_NODE] = create_kmalloc_cache(
-				get_kmalloc_cache_name(INDEX_NODE),
+				kmalloc_info[INDEX_NODE].name,
 				kmalloc_size(INDEX_NODE), ARCH_KMALLOC_FLAGS);
 	slab_state = PARTIAL_NODE;
 	setup_kmalloc_cache_index_table();
diff -puN mm/slab.h~mm-slab-rename-kmalloc-node-cache-to-kmalloc-size-fix-fix mm/slab.h
--- a/mm/slab.h~mm-slab-rename-kmalloc-node-cache-to-kmalloc-size-fix-fix
+++ a/mm/slab.h
@@ -71,6 +71,12 @@ extern struct list_head slab_caches;
 /* The slab cache that manages slab cache information */
 extern struct kmem_cache *kmem_cache;
 
+/* A table of kmalloc cache names and sizes */
+extern const struct kmalloc_info_struct {
+	const char *name;
+	unsigned long size;
+} kmalloc_info[];
+
 unsigned long calculate_alignment(unsigned long flags,
 		unsigned long align, unsigned long size);
 
@@ -78,7 +84,6 @@ unsigned long calculate_alignment(unsign
 /* Kmalloc array related functions */
 void setup_kmalloc_cache_index_table(void);
 void create_kmalloc_caches(unsigned long);
-const char *get_kmalloc_cache_name(int index);
 
 /* Find the kmalloc slab corresponding for a certain size */
 struct kmem_cache *kmalloc_slab(size_t, gfp_t);
diff -puN mm/slab_common.c~mm-slab-rename-kmalloc-node-cache-to-kmalloc-size-fix-fix mm/slab_common.c
--- a/mm/slab_common.c~mm-slab-rename-kmalloc-node-cache-to-kmalloc-size-fix-fix
+++ a/mm/slab_common.c
@@ -915,10 +915,7 @@ struct kmem_cache *kmalloc_slab(size_t s
  * kmalloc_index() supports up to 2^26=64MB, so the final entry of the table is
  * kmalloc-67108864.
  */
-static struct {
-	const char *name;
-	unsigned long size;
-} const kmalloc_info[] __initconst = {
+const struct kmalloc_info_struct kmalloc_info[] __initconst = {
 	{NULL,                      0},		{"kmalloc-96",             96},
 	{"kmalloc-192",           192},		{"kmalloc-8",               8},
 	{"kmalloc-16",             16},		{"kmalloc-32",             32},
@@ -935,11 +932,6 @@ static struct {
 	{"kmalloc-67108864", 67108864}
 };
 
-const char *get_kmalloc_cache_name(int index)
-{
-	return kmalloc_info[index].name;
-}
