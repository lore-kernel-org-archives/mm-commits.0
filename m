From: akpm@linux-foundation.org
Subject: +
 memcg-dont-initialize-kmem-cache-destroying-work-for-root-caches.patch
 added to -mm tree
Date: Mon, 05 Aug 2013 13:05:42 -0700
Message-ID: <52000596.PaFYoOeTZYatCvLY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42373 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305Ab3HEUFn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Aug 2013 16:05:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, mhocko@suse.cz, khlebnikov@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, glommer@openvz.org, bsingharora@gmail.com, avagin@openvz.org

Subject: + memcg-dont-initialize-kmem-cache-destroying-work-for-root-caches.patch added to -mm tree
To: avagin@openvz.org,bsingharora@gmail.com,glommer@openvz.org,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,khlebnikov@openvz.org,mhocko@suse.cz,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 05 Aug 2013 13:05:42 -0700


The patch titled
     Subject: memcg: don't initialize kmem-cache destroying work for root caches
has been added to the -mm tree.  Its filename is
     memcg-dont-initialize-kmem-cache-destroying-work-for-root-caches.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-dont-initialize-kmem-cache-destroying-work-for-root-caches.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-dont-initialize-kmem-cache-destroying-work-for-root-caches.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Vagin <avagin@openvz.org>
Subject: memcg: don't initialize kmem-cache destroying work for root caches

struct memcg_cache_params has a union.  Different parts of this union are
used for root and non-root caches.  A part with destroying work is used
only for non-root caches.

I fixed the same problem in another place v3.9-rc1-16204-gf101a94, but
didn't notice this one.

Signed-off-by: Andrey Vagin <avagin@openvz.org>
Cc: Glauber Costa <glommer@openvz.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
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

memcg-dont-initialize-kmem-cache-destroying-work-for-root-caches.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
procfs-remove-extra-call-of-dir_emit_dots.patch
linux-next.patch

