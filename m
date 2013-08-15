From: akpm@linux-foundation.org
Subject: +
 kmemcg-dont-allocate-extra-memory-for-root-memcg_cache_params-v2.patch
 added to -mm tree
Date: Thu, 15 Aug 2013 13:45:11 -0700
Message-ID: <520d3dd7.E31qK+yEeXT+nz5R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42338 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab3HOUpM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Aug 2013 16:45:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, glommer@openvz.org, bsingharora@gmail.com, avagin@openvz.org

Subject: + kmemcg-dont-allocate-extra-memory-for-root-memcg_cache_params-v2.patch added to -mm tree
To: avagin@openvz.org,bsingharora@gmail.com,glommer@openvz.org,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz
From: akpm@linux-foundation.org
Date: Thu, 15 Aug 2013 13:45:11 -0700


The patch titled
     Subject: kmemcg: don't allocate extra memory for root memcg_cache_params
has been added to the -mm tree.  Its filename is
     kmemcg-dont-allocate-extra-memory-for-root-memcg_cache_params-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kmemcg-dont-allocate-extra-memory-for-root-memcg_cache_params-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kmemcg-dont-allocate-extra-memory-for-root-memcg_cache_params-v2.patch

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
Subject: kmemcg: don't allocate extra memory for root memcg_cache_params

The memcg_cache_params structure contains the common part and the union,
which represents two different types of data: one for root cashes and
another for child caches.

The size of child data is fixed.  The size of the memcg_caches array is
calculated in runtime.

Currently the size of memcg_cache_params for root caches is calculated
incorrectly, because it includes the size of parameters for child caches.

ssize_t size = memcg_caches_array_size(num_groups);
size *= sizeof(void *);

size += sizeof(struct memcg_cache_params);

v2: Fix a typo in calculations

Signed-off-by: Andrey Vagin <avagin@openvz.org>
Cc: Glauber Costa <glommer@openvz.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~kmemcg-dont-allocate-extra-memory-for-root-memcg_cache_params-v2 mm/memcontrol.c
--- a/mm/memcontrol.c~kmemcg-dont-allocate-extra-memory-for-root-memcg_cache_params-v2
+++ a/mm/memcontrol.c
@@ -3140,7 +3140,7 @@ int memcg_update_cache_size(struct kmem_
 		ssize_t size = memcg_caches_array_size(num_groups);
 
 		size *= sizeof(void *);
-		size += sizeof(struct memcg_cache_params);
+		size += offsetof(struct memcg_cache_params, memcg_caches);
 
 		s->memcg_params = kzalloc(size, GFP_KERNEL);
 		if (!s->memcg_params) {
@@ -3183,13 +3183,16 @@ int memcg_update_cache_size(struct kmem_
 int memcg_register_cache(struct mem_cgroup *memcg, struct kmem_cache *s,
 			 struct kmem_cache *root_cache)
 {
-	size_t size = sizeof(struct memcg_cache_params);
+	size_t size;
 
 	if (!memcg_kmem_enabled())
 		return 0;
 
-	if (!memcg)
+	if (!memcg) {
+		size = offsetof(struct memcg_cache_params, memcg_caches);
 		size += memcg_limited_groups_array_size * sizeof(void *);
+	} else
+		size = sizeof(struct memcg_cache_params);
 
 	s->memcg_params = kzalloc(size, GFP_KERNEL);
 	if (!s->memcg_params)
_

Patches currently in -mm which might be from avagin@openvz.org are

origin.patch
kmemcg-dont-allocate-extra-memory-for-root-memcg_cache_params-v2.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
procfs-remove-extra-call-of-dir_emit_dots.patch

