From: akpm@linux-foundation.org
Subject: +
 memcg-fix-mutex-not-unlocked-on-memcg_create_kmem_cache-fail-path.patch
 added to -mm tree
Date: Thu, 30 Jan 2014 13:01:41 -0800
Message-ID: <52eabdb5.9fImYN8t8WILHDo7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42752 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbaA3VBm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Jan 2014 16:01:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, glommer@parallels.com, vdavydov@parallels.com

Subject: + memcg-fix-mutex-not-unlocked-on-memcg_create_kmem_cache-fail-path.patch added to -mm tree
To: vdavydov@parallels.com,glommer@parallels.com,hannes@cmpxchg.org,mhocko@suse.cz
From: akpm@linux-foundation.org
Date: Thu, 30 Jan 2014 13:01:41 -0800


The patch titled
     Subject: memcg: fix mutex not unlocked on memcg_create_kmem_cache fail path
has been added to the -mm tree.  Its filename is
     memcg-fix-mutex-not-unlocked-on-memcg_create_kmem_cache-fail-path.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-fix-mutex-not-unlocked-on-memcg_create_kmem_cache-fail-path.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-fix-mutex-not-unlocked-on-memcg_create_kmem_cache-fail-path.patch

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
Subject: memcg: fix mutex not unlocked on memcg_create_kmem_cache fail path

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Glauber Costa <glommer@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-mutex-not-unlocked-on-memcg_create_kmem_cache-fail-path mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-mutex-not-unlocked-on-memcg_create_kmem_cache-fail-path
+++ a/mm/memcontrol.c
@@ -3400,7 +3400,7 @@ void mem_cgroup_destroy_cache(struct kme
 static struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *memcg,
 						  struct kmem_cache *s)
 {
-	struct kmem_cache *new;
+	struct kmem_cache *new = NULL;
 	static char *tmp_name = NULL;
 	static DEFINE_MUTEX(mutex);	/* protects tmp_name */
 
@@ -3416,7 +3416,7 @@ static struct kmem_cache *memcg_create_k
 	if (!tmp_name) {
 		tmp_name = kmalloc(PATH_MAX, GFP_KERNEL);
 		if (!tmp_name)
-			return NULL;
+			goto out;
 	}
 
 	rcu_read_lock();
@@ -3426,12 +3426,11 @@ static struct kmem_cache *memcg_create_k
 
 	new = kmem_cache_create_memcg(memcg, tmp_name, s->object_size, s->align,
 				      (s->flags & ~SLAB_PANIC), s->ctor, s);
-
 	if (new)
 		new->allocflags |= __GFP_KMEMCG;
 	else
 		new = s;
