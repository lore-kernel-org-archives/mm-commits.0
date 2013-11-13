From: akpm@linux-foundation.org
Subject: [merged] memcg-kmem-use-is_root_cache-instead-of-hard-code.patch
 removed from -mm tree
Date: Wed, 13 Nov 2013 12:39:24 -0800
Message-ID: <5283e37c.rXpFra4cLDLbgLEk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42794 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab3KMUjZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:39:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, penberg@kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, glommer@parallels.com, h.huangqiang@huawei.com

Subject: [merged] memcg-kmem-use-is_root_cache-instead-of-hard-code.patch removed from -mm tree
To: h.huangqiang@huawei.com,glommer@parallels.com,hannes@cmpxchg.org,mhocko@suse.cz,penberg@kernel.org,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:39:24 -0800


The patch titled
     Subject: memcg, kmem: use is_root_cache instead of hard code
has been removed from the -mm tree.  Its filename was
     memcg-kmem-use-is_root_cache-instead-of-hard-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Qiang Huang <h.huangqiang@huawei.com>
Subject: memcg, kmem: use is_root_cache instead of hard code

Signed-off-by: Qiang Huang <h.huangqiang@huawei.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-kmem-use-is_root_cache-instead-of-hard-code mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-kmem-use-is_root_cache-instead-of-hard-code
+++ a/mm/memcontrol.c
@@ -59,6 +59,7 @@
 #include <net/sock.h>
 #include <net/ip.h>
 #include <net/tcp_memcontrol.h>
+#include "slab.h"
 
 #include <asm/uaccess.h>
 
@@ -3131,7 +3132,7 @@ int memcg_update_cache_size(struct kmem_
 {
 	struct memcg_cache_params *cur_params = s->memcg_params;
 
-	VM_BUG_ON(s->memcg_params && !s->memcg_params->is_root_cache);
+	VM_BUG_ON(!is_root_cache(s));
 
 	if (num_groups > memcg_limited_groups_array_size) {
 		int i;
_

Patches currently in -mm which might be from h.huangqiang@huawei.com are

origin.patch

