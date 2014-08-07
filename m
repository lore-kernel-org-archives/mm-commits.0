From: akpm@linux-foundation.org
Subject: [merged]
 slab-common-add-functions-for-kmem_cache_node-access.patch removed from -mm tree
Date: Thu, 07 Aug 2014 13:02:51 -0700
Message-ID: <53e3db6b.9Jlb3K/m1T2NyxPF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qg0-f73.google.com ([209.85.192.73]:36156 "EHLO
	mail-qg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100AbaHGUCx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:02:53 -0400
Received: by mail-qg0-f73.google.com with SMTP id q107so610765qgd.2
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:02:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab common: add functions for kmem_cache_node access
has been removed from the -mm tree.  Its filename was
     slab-common-add-functions-for-kmem_cache_node-access.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: slab common: add functions for kmem_cache_node access

The patchset provides two new functions in mm/slab.h and modifies SLAB and
SLUB to use these.  The kmem_cache_node structure is shared between both
allocators and the use of common accessors will allow us to move more code
into slab_common.c in the future.


This patch (of 3):

These functions allow to eliminate repeatedly used code in both SLAB and
SLUB and also allow for the insertion of debugging code that may be needed
in the development process.

Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.h |   17 ++++++++++++++++-
 mm/slub.c |    5 -----
 2 files changed, 16 insertions(+), 6 deletions(-)

diff -puN mm/slab.h~slab-common-add-functions-for-kmem_cache_node-access mm/slab.h
--- a/mm/slab.h~slab-common-add-functions-for-kmem_cache_node-access
+++ a/mm/slab.h
@@ -262,7 +262,7 @@ static inline struct kmem_cache *cache_f
 }
 #endif
 
-
+#ifndef CONFIG_SLOB
 /*
  * The slab lists for all objects.
  */
@@ -294,5 +294,20 @@ struct kmem_cache_node {
 
 };
 
+static inline struct kmem_cache_node *get_node(struct kmem_cache *s, int node)
+{
+	return s->node[node];
+}
+
+/*
+ * Iterator over all nodes. The body will be executed for each node that has
+ * a kmem_cache_node structure allocated (which is true for all online nodes)
+ */
+#define for_each_kmem_cache_node(__s, __node, __n) \
+	for (__node = 0; __n = get_node(__s, __node), __node < nr_node_ids; __node++) \
+		 if (__n)
+
+#endif
+
 void *slab_next(struct seq_file *m, void *p, loff_t *pos);
 void slab_stop(struct seq_file *m, void *p);
diff -puN mm/slub.c~slab-common-add-functions-for-kmem_cache_node-access mm/slub.c
--- a/mm/slub.c~slab-common-add-functions-for-kmem_cache_node-access
+++ a/mm/slub.c
@@ -233,11 +233,6 @@ static inline void stat(const struct kme
  * 			Core slab cache functions
  *******************************************************************/
 
-static inline struct kmem_cache_node *get_node(struct kmem_cache *s, int node)
-{
-	return s->node[node];
-}
