From: akpm@linux-foundation.org
Subject: + slab-common-add-functions-for-kmem_cache_node-access.patch
 added to -mm tree
Date: Tue, 17 Jun 2014 14:17:56 -0700
Message-ID: <53a0b084.krYrrpre9vo34A79%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57099 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964907AbaFQVR5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jun 2014 17:17:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, penberg@kernel.org, iamjoonsoo.kim@lge.com, cl@linux.com


The patch titled
     Subject: slab common: add functions for kmem_cache_node access
has been added to the -mm tree.  Its filename is
     slab-common-add-functions-for-kmem_cache_node-access.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-common-add-functions-for-kmem_cache_node-access.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-common-add-functions-for-kmem_cache_node-access.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

 mm/slab.h |   13 +++++++++++++
 mm/slub.c |    5 -----
 2 files changed, 13 insertions(+), 5 deletions(-)

diff -puN mm/slab.h~slab-common-add-functions-for-kmem_cache_node-access mm/slab.h
--- a/mm/slab.h~slab-common-add-functions-for-kmem_cache_node-access
+++ a/mm/slab.h
@@ -294,5 +294,18 @@ struct kmem_cache_node {
 
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
