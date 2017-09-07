From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?slub-make-sure-struct-kmem=5Fcache=5Fnode-is-initialized-?=
 =?US-ASCII?Q?before-publication.patch?= removed from -mm tree
Date: Thu, 07 Sep 2017 11:37:01 -0700
Message-ID: <20170907183701.lFjirnOB4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55030 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755762AbdIGShI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:37:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, glider@google.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com


The patch titled
     Subject: slub: tidy up initialization ordering
has been removed from the -mm tree.  Its filename was
     slub-make-sure-struct-kmem_cache_node-is-initialized-before-publication.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: slub: tidy up initialization ordering

- free_kmem_cache_nodes() frees the cache node before nulling out a
  reference to it

- init_kmem_cache_nodes() publishes the cache node before initializing it

Neither of these matter at runtime because the cache nodes cannot be
looked up by any other thread.  But it's neater and more consistent to
reorder these.

Link: http://lkml.kernel.org/r/20170707083408.40410-1-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/slub.c~slub-make-sure-struct-kmem_cache_node-is-initialized-before-publication mm/slub.c
--- a/mm/slub.c~slub-make-sure-struct-kmem_cache_node-is-initialized-before-publication
+++ a/mm/slub.c
@@ -3358,8 +3358,8 @@ static void free_kmem_cache_nodes(struct
 	struct kmem_cache_node *n;
 
 	for_each_kmem_cache_node(s, node, n) {
-		kmem_cache_free(kmem_cache_node, n);
 		s->node[node] = NULL;
+		kmem_cache_free(kmem_cache_node, n);
 	}
 }
 
@@ -3389,8 +3389,8 @@ static int init_kmem_cache_nodes(struct
 			return 0;
 		}
 
-		s->node[node] = n;
 		init_kmem_cache_node(n);
+		s->node[node] = n;
 	}
 	return 1;
 }
_

Patches currently in -mm which might be from glider@google.com are


