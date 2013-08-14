From: akpm@linux-foundation.org
Subject: [merged]
 memcg-dont-initialize-kmem-cache-destroying-work-for-root-caches.patch
 removed from -mm tree
Date: Wed, 14 Aug 2013 12:35:29 -0700
Message-ID: <520bdc01.t1oCO35uKLZulK6L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54149 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933022Ab3HNTfa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Aug 2013 15:35:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, mhocko@suse.cz, khlebnikov@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, glommer@openvz.org, bsingharora@gmail.com, avagin@openvz.org

Subject: [merged] memcg-dont-initialize-kmem-cache-destroying-work-for-root-caches.patch removed from -mm tree
To: avagin@openvz.org,bsingharora@gmail.com,glommer@openvz.org,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,khlebnikov@openvz.org,mhocko@suse.cz,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 14 Aug 2013 12:35:29 -0700


The patch titled
     Subject: memcg: don't initialize kmem-cache destroying work for root caches
has been removed from the -mm tree.  Its filename was
     memcg-dont-initialize-kmem-cache-destroying-work-for-root-caches.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Vagin <avagin@openvz.org>
Subject: memcg: don't initialize kmem-cache destroying work for root caches

struct memcg_cache_params has a union.  Different parts of this union are
used for root and non-root caches.  A part with destroying work is used
only for non-root caches.

I fixed the same problem in another place v3.9-rc1-16204-gf101a94, but
didn't notice this one.

This patch fixes the kernel panic:

[   46.848187] BUG: unable to handle kernel paging request at 000000fffffffeb8
[   46.849026] IP: [<ffffffff811a484c>] kmem_cache_destroy_memcg_children+0x6c/0xc0
[   46.849092] PGD 0
[   46.849092] Oops: 0000 [#1] SMP
...

Signed-off-by: Andrey Vagin <avagin@openvz.org>
Cc: Glauber Costa <glommer@openvz.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: <stable@vger.kernel.org>    [3.9.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-dont-initialize-kmem-cache-destroying-work-for-root-caches mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-dont-initialize-kmem-cache-destroying-work-for-root-caches
+++ a/mm/memcontrol.c
@@ -3195,11 +3195,11 @@ int memcg_register_cache(struct mem_cgro
 	if (!s->memcg_params)
 		return -ENOMEM;
 
-	INIT_WORK(&s->memcg_params->destroy,
-			kmem_cache_destroy_work_func);
 	if (memcg) {
 		s->memcg_params->memcg = memcg;
 		s->memcg_params->root_cache = root_cache;
+		INIT_WORK(&s->memcg_params->destroy,
+				kmem_cache_destroy_work_func);
 	} else
 		s->memcg_params->is_root_cache = true;
 
_

Patches currently in -mm which might be from avagin@openvz.org are

origin.patch

