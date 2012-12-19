From: akpm@linux-foundation.org
Subject: [merged] memcg-add-comments-clarifying-aspects-of-cache-attribute-propagation.patch removed from -mm tree
Date: Wed, 19 Dec 2012 12:42:24 -0800
Message-ID: <20121219204225.2A24820004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:59598 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326Ab2LSUm2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 15:42:28 -0500
Received: by mail-lb0-f202.google.com with SMTP id s4so140696lbc.5
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 12:42:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: add comments clarifying aspects of cache attribute propagation
has been removed from the -mm tree.  Its filename was
     memcg-add-comments-clarifying-aspects-of-cache-attribute-propagation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: memcg: add comments clarifying aspects of cache attribute propagation

This patch clarifies two aspects of cache attribute propagation.

First, the expected context for the for_each_memcg_cache macro in
memcontrol.h.  The usages already in the codebase are safe.  In mm/slub.c,
it is trivially safe because the lock is acquired right before the loop. 
In mm/slab.c, it is less so: the lock is acquired by an outer function a
few steps back in the stack, so a VM_BUG_ON() is added to make sure it is
indeed safe.

A comment is also added to detail why we are returning the value of the
parent cache and ignoring the children's when we propagate the attributes.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 ++++++
 mm/slab.c                  |    1 +
 mm/slub.c                  |   21 +++++++++++++++++----
 3 files changed, 24 insertions(+), 4 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-add-comments-clarifying-aspects-of-cache-attribute-propagation include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-add-comments-clarifying-aspects-of-cache-attribute-propagation
+++ a/include/linux/memcontrol.h
@@ -422,6 +422,12 @@ static inline void sock_release_memcg(st
 extern struct static_key memcg_kmem_enabled_key;
 
 extern int memcg_limited_groups_array_size;
+
+/*
+ * Helper macro to loop through all memcg-specific caches. Callers must still
+ * check if the cache is valid (it is either valid or NULL).
+ * the slab_mutex must be held when looping through those caches
+ */
 #define for_each_memcg_cache_index(_idx)	\
 	for ((_idx) = 0; i < memcg_limited_groups_array_size; (_idx)++)
 
diff -puN mm/slab.c~memcg-add-comments-clarifying-aspects-of-cache-attribute-propagation mm/slab.c
--- a/mm/slab.c~memcg-add-comments-clarifying-aspects-of-cache-attribute-propagation
+++ a/mm/slab.c
@@ -4099,6 +4099,7 @@ static int do_tune_cpucache(struct kmem_
 	if ((ret < 0) || !is_root_cache(cachep))
 		return ret;
 
+	VM_BUG_ON(!mutex_is_locked(&slab_mutex));
 	for_each_memcg_cache_index(i) {
 		c = cache_from_memcg(cachep, i);
 		if (c)
diff -puN mm/slub.c~memcg-add-comments-clarifying-aspects-of-cache-attribute-propagation mm/slub.c
--- a/mm/slub.c~memcg-add-comments-clarifying-aspects-of-cache-attribute-propagation
+++ a/mm/slub.c
@@ -5108,12 +5108,25 @@ static ssize_t slab_attr_store(struct ko
 		if (s->max_attr_size < len)
 			s->max_attr_size = len;
 
+		/*
+		 * This is a best effort propagation, so this function's return
+		 * value will be determined by the parent cache only. This is
+		 * basically because not all attributes will have a well
+		 * defined semantics for rollbacks - most of the actions will
+		 * have permanent effects.
+		 *
+		 * Returning the error value of any of the children that fail
+		 * is not 100 % defined, in the sense that users seeing the
+		 * error code won't be able to know anything about the state of
+		 * the cache.
+		 *
+		 * Only returning the error code for the parent cache at least
+		 * has well defined semantics. The cache being written to
+		 * directly either failed or succeeded, in which case we loop
+		 * through the descendants with best-effort propagation.
+		 */
 		for_each_memcg_cache_index(i) {
 			struct kmem_cache *c = cache_from_memcg(s, i);
-			/*
-			 * This function's return value is determined by the
-			 * parent cache only
-			 */
 			if (c)
 				attribute->store(c, buf, len);
 		}
_

Patches currently in -mm which might be from glommer@parallels.com are

origin.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch

