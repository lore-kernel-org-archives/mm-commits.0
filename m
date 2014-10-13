From: akpm@linux-foundation.org
Subject: [merged] slab-fix-for_each_kmem_cache_node.patch removed from -mm tree
Date: Mon, 13 Oct 2014 11:18:50 -0700
Message-ID: <543c178a.RU9cy7YTaCPav9JN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60173 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813AbaJMSSu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:18:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpatocka@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: fix for_each_kmem_cache_node()
has been removed from the -mm tree.  Its filename was
     slab-fix-for_each_kmem_cache_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: slab: fix for_each_kmem_cache_node()

Fix a bug (discovered with kmemcheck) in for_each_kmem_cache_node().  The
for loop reads the array "node" before verifying that the index is within
the range.  This results in kmemcheck warning.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/slab.h~slab-fix-for_each_kmem_cache_node mm/slab.h
--- a/mm/slab.h~slab-fix-for_each_kmem_cache_node
+++ a/mm/slab.h
@@ -338,8 +338,8 @@ static inline struct kmem_cache_node *ge
  * a kmem_cache_node structure allocated (which is true for all online nodes)
  */
 #define for_each_kmem_cache_node(__s, __node, __n) \
-	for (__node = 0; __n = get_node(__s, __node), __node < nr_node_ids; __node++) \
-		 if (__n)
+	for (__node = 0; __node < nr_node_ids; __node++) \
+		 if ((__n = get_node(__s, __node)))
 
 #endif
 
_

Patches currently in -mm which might be from mpatocka@redhat.com are

origin.patch
linux-next.patch

