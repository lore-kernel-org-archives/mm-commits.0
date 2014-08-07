From: akpm@linux-foundation.org
Subject: [merged] slub-remove-kmemcg-id-from-create_unique_id.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:06:01 -0700
Message-ID: <53e3dc29.0lqWUbs/QhHSuCQ1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:50322 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004AbaHGUGC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:06:02 -0400
Received: by mail-vc0-f201.google.com with SMTP id le20so611603vcb.2
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:06:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: remove kmemcg id from create_unique_id
has been removed from the -mm tree.  Its filename was
     slub-remove-kmemcg-id-from-create_unique_id.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: slub: remove kmemcg id from create_unique_id

This function is never called for memcg caches, because they are
unmergeable, so remove the dead code.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Lameter <cl@linux.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN mm/slub.c~slub-remove-kmemcg-id-from-create_unique_id mm/slub.c
--- a/mm/slub.c~slub-remove-kmemcg-id-from-create_unique_id
+++ a/mm/slub.c
@@ -5128,12 +5128,6 @@ static char *create_unique_id(struct kme
 		*p++ = '-';
 	p += sprintf(p, "%07d", s->size);
 
-#ifdef CONFIG_MEMCG_KMEM
-	if (!is_root_cache(s))
-		p += sprintf(p, "-%08d",
-				memcg_cache_id(s->memcg_params->memcg));
-#endif
