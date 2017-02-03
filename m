From: akpm@linux-foundation.org
Subject: + mm-slab-rename-kmalloc-node-cache-to-kmalloc-size.patch added
 to -mm tree
Date: Fri, 03 Feb 2017 15:05:44 -0800
Message-ID: <58950cc8.0gThJcZLog9RbrXe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38532 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752268AbdBCXFp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2017 18:05:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slab: rename kmalloc-node cache to kmalloc-<size>
has been added to the -mm tree.  Its filename is
     mm-slab-rename-kmalloc-node-cache-to-kmalloc-size.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-rename-kmalloc-node-cache-to-kmalloc-size.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-rename-kmalloc-node-cache-to-kmalloc-size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Link: http://lkml.kernel.org/r/20170203181008.24898-1-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c        |    3 ++-
 mm/slab.h        |    1 +
 mm/slab_common.c |    5 +++++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff -puN mm/slab.c~mm-slab-rename-kmalloc-node-cache-to-kmalloc-size mm/slab.c
--- a/mm/slab.c~mm-slab-rename-kmalloc-node-cache-to-kmalloc-size
+++ a/mm/slab.c
@@ -1288,7 +1288,8 @@ void __init kmem_cache_init(void)
 	 * Initialize the caches that provide memory for the  kmem_cache_node
 	 * structures first.  Without this, further allocations will bug.
 	 */
-	kmalloc_caches[INDEX_NODE] = create_kmalloc_cache("kmalloc-node",
+	kmalloc_caches[INDEX_NODE] = create_kmalloc_cache(
+				get_kmalloc_cache_name(INDEX_NODE),
 				kmalloc_size(INDEX_NODE), ARCH_KMALLOC_FLAGS);
 	slab_state = PARTIAL_NODE;
 	setup_kmalloc_cache_index_table();
diff -puN mm/slab.h~mm-slab-rename-kmalloc-node-cache-to-kmalloc-size mm/slab.h
--- a/mm/slab.h~mm-slab-rename-kmalloc-node-cache-to-kmalloc-size
+++ a/mm/slab.h
@@ -78,6 +78,7 @@ unsigned long calculate_alignment(unsign
 /* Kmalloc array related functions */
 void setup_kmalloc_cache_index_table(void);
 void create_kmalloc_caches(unsigned long);
+const char *get_kmalloc_cache_name(int index);
 
 /* Find the kmalloc slab corresponding for a certain size */
 struct kmem_cache *kmalloc_slab(size_t, gfp_t);
diff -puN mm/slab_common.c~mm-slab-rename-kmalloc-node-cache-to-kmalloc-size mm/slab_common.c
--- a/mm/slab_common.c~mm-slab-rename-kmalloc-node-cache-to-kmalloc-size
+++ a/mm/slab_common.c
@@ -935,6 +935,11 @@ static struct {
 	{"kmalloc-67108864", 67108864}
 };
 
+const char *get_kmalloc_cache_name(int index)
+{
+	return kmalloc_info[index].name;
+}
+
 /*
  * Patch up the size_index table if we have strange large alignment
  * requirements for the kmalloc array. This is only the case for
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-slab-rename-kmalloc-node-cache-to-kmalloc-size.patch
mm-page_alloc-dont-convert-pfn-to-idx-when-merging.patch
mm-page_alloc-avoid-page_to_pfn-when-merging-buddies.patch
mm-page_alloc-remove-redundant-checks-from-alloc-fastpath.patch
mm-page_alloc-dont-check-cpuset-allowed-twice-in-fast-path.patch

