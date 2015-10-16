From: akpm@linux-foundation.org
Subject: + memcg-simplify-and-inline-__mem_cgroup_from_kmem-fix-2.patch
 added to -mm tree
Date: Fri, 16 Oct 2015 15:21:29 -0700
Message-ID: <56217869.IksiGrLszJ54HsG0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56307 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbbJPWVa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Oct 2015 18:21:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, arnd@arndb.de, hannes@cmpxchg.org, mhocko@suse.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-simplify-and-inline-__mem_cgroup_from_kmem-fix-2
has been added to the -mm tree.  Its filename is
     memcg-simplify-and-inline-__mem_cgroup_from_kmem-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-simplify-and-inline-__mem_cgroup_from_kmem-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-simplify-and-inline-__mem_cgroup_from_kmem-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: memcg-simplify-and-inline-__mem_cgroup_from_kmem-fix-2

move mem_cgroup_from_kmem into list_lru.c

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   16 ----------------
 mm/list_lru.c              |   10 ++++++++++
 2 files changed, 10 insertions(+), 16 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-simplify-and-inline-__mem_cgroup_from_kmem-fix-2 include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-simplify-and-inline-__mem_cgroup_from_kmem-fix-2
+++ a/include/linux/memcontrol.h
@@ -825,16 +825,6 @@ static __always_inline void memcg_kmem_p
 	if (memcg_kmem_enabled())
 		__memcg_kmem_put_cache(cachep);
 }
-
-static __always_inline struct mem_cgroup *mem_cgroup_from_kmem(void *ptr)
-{
-	struct page *page;
-
-	if (!memcg_kmem_enabled())
-		return NULL;
-	page = virt_to_head_page(ptr);
-	return page->mem_cgroup;
-}
 #else
 #define for_each_memcg_cache_index(_idx)	\
 	for (; NULL; )
@@ -880,11 +870,5 @@ memcg_kmem_get_cache(struct kmem_cache *
 static inline void memcg_kmem_put_cache(struct kmem_cache *cachep)
 {
 }
-
-static inline struct mem_cgroup *mem_cgroup_from_kmem(void *ptr)
-{
-	return NULL;
-}
 #endif /* CONFIG_MEMCG_KMEM */
 #endif /* _LINUX_MEMCONTROL_H */
-
diff -puN mm/list_lru.c~memcg-simplify-and-inline-__mem_cgroup_from_kmem-fix-2 mm/list_lru.c
--- a/mm/list_lru.c~memcg-simplify-and-inline-__mem_cgroup_from_kmem-fix-2
+++ a/mm/list_lru.c
@@ -63,6 +63,16 @@ list_lru_from_memcg_idx(struct list_lru_
 	return &nlru->lru;
 }
 
+static __always_inline struct mem_cgroup *mem_cgroup_from_kmem(void *ptr)
+{
+	struct page *page;
+
+	if (!memcg_kmem_enabled())
+		return NULL;
+	page = virt_to_head_page(ptr);
+	return page->mem_cgroup;
+}
+
 static inline struct list_lru_one *
 list_lru_from_kmem(struct list_lru_node *nlru, void *ptr)
 {
_

Patches currently in -mm which might be from hughd@google.com are

memcg-simplify-and-inline-__mem_cgroup_from_kmem-fix-2.patch

