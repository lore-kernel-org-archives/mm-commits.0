From: akpm@linux-foundation.org
Subject: + slub-fix-memcg_propagate_slab_attrs.patch added to -mm tree
Date: Fri, 18 Apr 2014 13:08:17 -0700
Message-ID: <53518631.cuNCoAbpOk1NRWDf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42312 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaDRUIS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Apr 2014 16:08:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penberg@kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, cl@linux.com, vdavydov@parallels.com

Subject: + slub-fix-memcg_propagate_slab_attrs.patch added to -mm tree
To: vdavydov@parallels.com,cl@linux.com,hannes@cmpxchg.org,mhocko@suse.cz,penberg@kernel.org
From: akpm@linux-foundation.org
Date: Fri, 18 Apr 2014 13:08:17 -0700


The patch titled
     Subject: slub: fix memcg_propagate_slab_attrs
has been added to the -mm tree.  Its filename is
     slub-fix-memcg_propagate_slab_attrs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slub-fix-memcg_propagate_slab_attrs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slub-fix-memcg_propagate_slab_attrs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

slub-fix-memcg_propagate_slab_attrs.patch
slb-charge-slabs-to-kmemcg-explicitly.patch
mm-get-rid-of-__gfp_kmemcg.patch
mm-get-rid-of-__gfp_kmemcg-fix.patch
slab-document-kmalloc_order.patch

