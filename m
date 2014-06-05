From: akpm@linux-foundation.org
Subject: [merged] memcg-memcg_kmem_create_cache-make-memcg_name_buf.patch
 removed from -mm tree
Date: Thu, 05 Jun 2014 12:51:39 -0700
Message-ID: <5390ca4b.PkGUh6rfApT/75AN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56180 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968AbaFETvk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:51:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, vdavydov@parallels.com

Subject: [merged] memcg-memcg_kmem_create_cache-make-memcg_name_buf.patch removed from -mm tree
To: vdavydov@parallels.com,hannes@cmpxchg.org,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:51:39 -0700


The patch titled
     Subject: memcg: memcg_kmem_create_cache: make memcg_name_buf statically allocated
has been removed from the -mm tree.  Its filename was
     memcg-memcg_kmem_create_cache-make-memcg_name_buf.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: memcg_kmem_create_cache: make memcg_name_buf statically allocated

It isn't worth complicating the code by allocating it on the first access,
because it only takes 256 bytes.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN mm/memcontrol.c~memcg-memcg_kmem_create_cache-make-memcg_name_buf mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-memcg_kmem_create_cache-make-memcg_name_buf
+++ a/mm/memcontrol.c
@@ -3135,7 +3135,8 @@ void memcg_free_cache_params(struct kmem
 static void memcg_kmem_create_cache(struct mem_cgroup *memcg,
 				    struct kmem_cache *root_cache)
 {
-	static char *memcg_name_buf;	/* protected by memcg_slab_mutex */
+	static char memcg_name_buf[NAME_MAX + 1]; /* protected by
+						     memcg_slab_mutex */
 	struct kmem_cache *cachep;
 	int id;
 
@@ -3151,12 +3152,6 @@ static void memcg_kmem_create_cache(stru
 	if (cache_from_memcg_idx(root_cache, id))
 		return;
 
-	if (!memcg_name_buf) {
-		memcg_name_buf = kmalloc(NAME_MAX + 1, GFP_KERNEL);
-		if (!memcg_name_buf)
-			return;
-	}
