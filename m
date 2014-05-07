From: akpm@linux-foundation.org
Subject: [merged] slub-fix-memcg_propagate_slab_attrs.patch removed from
 -mm tree
Date: Wed, 07 May 2014 12:04:59 -0700
Message-ID: <536a83db.ZuGV/EA1qwpunAq1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56105 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaEGTFA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2014 15:05:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penberg@kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, cl@linux.com, vdavydov@parallels.com

Subject: [merged] slub-fix-memcg_propagate_slab_attrs.patch removed from -mm tree
To: vdavydov@parallels.com,cl@linux.com,hannes@cmpxchg.org,mhocko@suse.cz,penberg@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 07 May 2014 12:04:59 -0700


The patch titled
     Subject: slub: fix memcg_propagate_slab_attrs
has been removed from the -mm tree.  Its filename was
     slub-fix-memcg_propagate_slab_attrs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: slub: fix memcg_propagate_slab_attrs

After creating a cache for a memcg we should initialize its sysfs attrs
with the values from its parent.  That's what memcg_propagate_slab_attrs
is for.  Currently it's broken - we clearly muddled root-vs-memcg caches
there.  Let's fix it up.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN mm/slub.c~slub-fix-memcg_propagate_slab_attrs mm/slub.c
--- a/mm/slub.c~slub-fix-memcg_propagate_slab_attrs
+++ a/mm/slub.c
@@ -5071,15 +5071,18 @@ static void memcg_propagate_slab_attrs(s
 #ifdef CONFIG_MEMCG_KMEM
 	int i;
 	char *buffer = NULL;
+	struct kmem_cache *root_cache;
 
-	if (!is_root_cache(s))
+	if (is_root_cache(s))
 		return;
 
+	root_cache = s->memcg_params->root_cache;
+
 	/*
 	 * This mean this cache had no attribute written. Therefore, no point
 	 * in copying default values around
 	 */
-	if (!s->max_attr_size)
+	if (!root_cache->max_attr_size)
 		return;
 
 	for (i = 0; i < ARRAY_SIZE(slab_attrs); i++) {
@@ -5101,7 +5104,7 @@ static void memcg_propagate_slab_attrs(s
 		 */
 		if (buffer)
 			buf = buffer;
-		else if (s->max_attr_size < ARRAY_SIZE(mbuf))
+		else if (root_cache->max_attr_size < ARRAY_SIZE(mbuf))
 			buf = mbuf;
 		else {
 			buffer = (char *) get_zeroed_page(GFP_KERNEL);
@@ -5110,7 +5113,7 @@ static void memcg_propagate_slab_attrs(s
 			buf = buffer;
 		}
 
-		attr->show(s->memcg_params->root_cache, buf);
+		attr->show(root_cache, buf);
 		attr->store(s, buf, strlen(buf));
 	}
 
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
slb-charge-slabs-to-kmemcg-explicitly.patch
mm-get-rid-of-__gfp_kmemcg.patch
mm-get-rid-of-__gfp_kmemcg-fix.patch
slab-document-kmalloc_order.patch
memcg-un-export-__memcg_kmem_get_cache.patch
mem-hotplug-implement-get-put_online_mems.patch
slab-get_online_mems-for-kmem_cache_createdestroyshrink.patch
documentation-memcg-warn-about-incomplete-kmemcg-state.patch
memcg-slab-do-not-schedule-cache-destruction-when-last-page-goes-away.patch
memcg-slab-merge-memcg_bindrelease_pages-to-memcg_uncharge_slab.patch
memcg-slab-simplify-synchronization-scheme.patch

