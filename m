From: akpm@linux-foundation.org
Subject: +
 memcg-fix-kmem_account_flags-check-in-memcg_can_account_kmem.patch added to -mm tree
Date: Tue, 03 Dec 2013 17:03:40 -0800
Message-ID: <529e7f6c.ZaWWHxS6a5PMBWsW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55589 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129Ab3LDBDl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Dec 2013 20:03:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, glommer@parallels.com, bsingharora@gmail.com, vdavydov@parallels.com

Subject: + memcg-fix-kmem_account_flags-check-in-memcg_can_account_kmem.patch added to -mm tree
To: vdavydov@parallels.com,bsingharora@gmail.com,glommer@parallels.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz
From: akpm@linux-foundation.org
Date: Tue, 03 Dec 2013 17:03:40 -0800


The patch titled
     Subject: memcg: fix kmem_account_flags check in memcg_can_account_kmem()
has been added to the -mm tree.  Its filename is
     memcg-fix-kmem_account_flags-check-in-memcg_can_account_kmem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-fix-kmem_account_flags-check-in-memcg_can_account_kmem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-fix-kmem_account_flags-check-in-memcg_can_account_kmem.patch

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
Subject: memcg: fix kmem_account_flags check in memcg_can_account_kmem()

We should start kmem accounting for a memory cgroup only after both its
kmem limit is set (KMEM_ACCOUNTED_ACTIVE) and related call sites are
patched (KMEM_ACCOUNTED_ACTIVATED).  Currently memcg_can_account_kmem()
allows kmem accounting even if only one of the conditions is true.  Fix
it.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Glauber Costa <glommer@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-fix-kmem_account_flags-check-in-memcg_can_account_kmem mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-kmem_account_flags-check-in-memcg_can_account_kmem
+++ a/mm/memcontrol.c
@@ -2959,7 +2959,8 @@ static DEFINE_MUTEX(set_limit_mutex);
 static inline bool memcg_can_account_kmem(struct mem_cgroup *memcg)
 {
 	return !mem_cgroup_disabled() && !mem_cgroup_is_root(memcg) &&
-		(memcg->kmem_account_flags & KMEM_ACCOUNTED_MASK);
+		(memcg->kmem_account_flags & KMEM_ACCOUNTED_MASK) ==
+							KMEM_ACCOUNTED_MASK;
 }
 
 /*
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
memcg-fix-kmem_account_flags-check-in-memcg_can_account_kmem.patch

