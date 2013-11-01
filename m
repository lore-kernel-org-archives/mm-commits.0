From: akpm@linux-foundation.org
Subject: + memcg-kmem-use-is_root_cache-instead-of-hard-code.patch added
 to -mm tree
Date: Fri, 01 Nov 2013 13:12:16 -0700
Message-ID: <52740b20./+nJ+YuRGGdSDM+C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53615 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab3KAUMR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Nov 2013 16:12:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, penberg@kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, glommer@parallels.com, h.huangqiang@huawei.com

Subject: + memcg-kmem-use-is_root_cache-instead-of-hard-code.patch added to -mm tree
To: h.huangqiang@huawei.com,glommer@parallels.com,hannes@cmpxchg.org,mhocko@suse.cz,penberg@kernel.org,rientjes@google.com
From: akpm@linux-foundation.org
Date: Fri, 01 Nov 2013 13:12:16 -0700


The patch titled
     Subject: memcg, kmem: Use is_root_cache instead of hard code
has been added to the -mm tree.  Its filename is
     memcg-kmem-use-is_root_cache-instead-of-hard-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-kmem-use-is_root_cache-instead-of-hard-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-kmem-use-is_root_cache-instead-of-hard-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Qiang Huang <h.huangqiang@huawei.com>
Subject: memcg, kmem: Use is_root_cache instead of hard code

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

mm-add-a-helper-function-to-check-may-oom-condition.patch
memcg-kmem-use-is_root_cache-instead-of-hard-code.patch
memcg-kmem-rename-cache_from_memcg-to-cache_from_memcg_idx.patch
memcg-kmem-use-cache_from_memcg_idx-instead-of-hard-code.patch

