From: akpm@linux-foundation.org
Subject: + memcg-make-memcg_update_cache_sizes-static.patch added to -mm
 tree
Date: Tue, 03 Dec 2013 17:04:35 -0800
Message-ID: <529e7fa3.qBzjXeB65KTSV3m+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55598 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab3LDBEg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Dec 2013 20:04:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, bsingharora@gmail.com, vdavydov@parallels.com

Subject: + memcg-make-memcg_update_cache_sizes-static.patch added to -mm tree
To: vdavydov@parallels.com,bsingharora@gmail.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz
From: akpm@linux-foundation.org
Date: Tue, 03 Dec 2013 17:04:35 -0800


The patch titled
     Subject: memcg: make memcg_update_cache_sizes() static
has been added to the -mm tree.  Its filename is
     memcg-make-memcg_update_cache_sizes-static.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-make-memcg_update_cache_sizes-static.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-make-memcg_update_cache_sizes-static.patch

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
Subject: memcg: make memcg_update_cache_sizes() static

This function is not used outside of memcontrol.c so make it static.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-make-memcg_update_cache_sizes-static mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-make-memcg_update_cache_sizes-static
+++ a/mm/memcontrol.c
@@ -3087,7 +3087,7 @@ int memcg_cache_id(struct mem_cgroup *me
  * But when we create a new cache, we can call this as well if its parent
  * is kmem-limited. That will have to hold set_limit_mutex as well.
  */
-int memcg_update_cache_sizes(struct mem_cgroup *memcg)
+static int memcg_update_cache_sizes(struct mem_cgroup *memcg)
 {
 	int num, ret;
 
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
memcg-fix-kmem_account_flags-check-in-memcg_can_account_kmem.patch
memcg-make-memcg_update_cache_sizes-static.patch

