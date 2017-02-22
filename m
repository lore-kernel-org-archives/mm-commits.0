From: akpm@linux-foundation.org
Subject: [patch 027/142] mm, slab: rename kmalloc-node cache to
 kmalloc-<size>
Date: Wed, 22 Feb 2017 15:41:05 -0800
Message-ID: <58ae2191.mx3hd93Do36Fxk2o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48020 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934382AbdBVXl5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:41:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vbabka@suse.cz, cl@linux.com, iamjoonsoo.kim@lge.com, mawilcox@microsoft.com, penberg@kernel.org, rientjes@google.com

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slab: rename kmalloc-node cache to kmalloc-<size>

SLAB as part of its bootstrap pre-creates one kmalloc cache that can fit the
kmem_cache_node management structure, and puts it into the generic kmalloc
cache array (e.g. for 128b objects). The name of this cache is "kmalloc-node",
which is confusing for readers of /proc/slabinfo as the cache is used for
generic allocations (and not just the kmem_cache_node struct) and it appears as
the kmalloc-128 cache is missing.

An easy solution is to use the kmalloc-<size> name when pre-creating the cache,
which we can get from the kmalloc_info array.

Example /proc/slabinfo before the patch:

...
kmalloc-256         1647   1984    256   16    1 : tunables  120   60    8 : slabdata    124    124    828
kmalloc-192         1974   1974    192   21    1 : tunables  120   60    8 : slabdata     94     94    133
kmalloc-96          1332   1344    128   32    1 : tunables  120   60    8 : slabdata     42     42    219
kmalloc-64          2505   5952     64   64    1 : tunables  120   60    8 : slabdata     93     93    715
kmalloc-32          4278   4464     32  124    1 : tunables  120   60    8 : slabdata     36     36    346
kmalloc-node        1352   1376    128   32    1 : tunables  120   60    8 : slabdata     43     43     53
kmem_cache           132    147    192   21    1 : tunables  120   60    8 : slabdata      7      7      0

After the patch:

...
kmalloc-256         1672   2160    256   16    1 : tunables  120   60    8 : slabdata    135    135    807
kmalloc-192         1992   2016    192   21    1 : tunables  120   60    8 : slabdata     96     96    203
kmalloc-96          1159   1184    128   32    1 : tunables  120   60    8 : slabdata     37     37    116
kmalloc-64          2561   4864     64   64    1 : tunables  120   60    8 : slabdata     76     76    785
kmalloc-32          4253   4340     32  124    1 : tunables  120   60    8 : slabdata     35     35    270
kmalloc-128         1256   1280    128   32    1 : tunables  120   60    8 : slabdata     40     40     39
kmem_cache           125    147    192   21    1 : tunables  120   60    8 : slabdata      7      7      0

[vbabka@suse.cz: export the whole kmalloc_info structure instead of just a name accessor, per Christoph Lameter]
  Link: http://lkml.kernel.org/r/54e80303-b814-4232-66d4-95b34d3eb9d0@suse.cz
Link: http://lkml.kernel.org/r/20170203181008.24898-1-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c        |    3 ++-
 mm/slab.h        |    6 ++++++
 mm/slab_common.c |    5 +----
 3 files changed, 9 insertions(+), 5 deletions(-)

diff -puN mm/slab.c~mm-slab-rename-kmalloc-node-cache-to-kmalloc-size mm/slab.c
--- a/mm/slab.c~mm-slab-rename-kmalloc-node-cache-to-kmalloc-size
+++ a/mm/slab.c
@@ -1288,7 +1288,8 @@ void __init kmem_cache_init(void)
 	 * Initialize the caches that provide memory for the  kmem_cache_node
 	 * structures first.  Without this, further allocations will bug.
 	 */
-	kmalloc_caches[INDEX_NODE] = create_kmalloc_cache("kmalloc-node",
+	kmalloc_caches[INDEX_NODE] = create_kmalloc_cache(
+				kmalloc_info[INDEX_NODE].name,
 				kmalloc_size(INDEX_NODE), ARCH_KMALLOC_FLAGS);
 	slab_state = PARTIAL_NODE;
 	setup_kmalloc_cache_index_table();
diff -puN mm/slab.h~mm-slab-rename-kmalloc-node-cache-to-kmalloc-size mm/slab.h
--- a/mm/slab.h~mm-slab-rename-kmalloc-node-cache-to-kmalloc-size
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
 
diff -puN mm/slab_common.c~mm-slab-rename-kmalloc-node-cache-to-kmalloc-size mm/slab_common.c
--- a/mm/slab_common.c~mm-slab-rename-kmalloc-node-cache-to-kmalloc-size
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
_
