From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_counter-pull-1-handling-out-of-page_counter_memparse.patch removed
 from -mm tree
Date: Thu, 12 Feb 2015 11:36:54 -0800
Message-ID: <54dd00d6.qeep1jJdcSn7m8wn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58143 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbbBLTgz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:36:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, gthelen@google.com, mhocko@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_counter: pull "-1" handling out of page_counter_memparse()
has been removed from the -mm tree.  Its filename was
     mm-page_counter-pull-1-handling-out-of-page_counter_memparse.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_counter: pull "-1" handling out of page_counter_memparse()

The unified hierarchy interface for memory cgroups will no longer use "-1"
to mean maximum possible resource value.  In preparation for this, make
the string an argument and let the caller supply it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: Greg Thelen <gthelen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_counter.h |    3 ++-
 mm/hugetlb_cgroup.c          |    2 +-
 mm/memcontrol.c              |    4 ++--
 mm/page_counter.c            |    7 ++++---
 net/ipv4/tcp_memcontrol.c    |    2 +-
 5 files changed, 10 insertions(+), 8 deletions(-)

diff -puN include/linux/page_counter.h~mm-page_counter-pull-1-handling-out-of-page_counter_memparse include/linux/page_counter.h
--- a/include/linux/page_counter.h~mm-page_counter-pull-1-handling-out-of-page_counter_memparse
+++ a/include/linux/page_counter.h
@@ -41,7 +41,8 @@ int page_counter_try_charge(struct page_
 			    struct page_counter **fail);
 void page_counter_uncharge(struct page_counter *counter, unsigned long nr_pages);
 int page_counter_limit(struct page_counter *counter, unsigned long limit);
-int page_counter_memparse(const char *buf, unsigned long *nr_pages);
+int page_counter_memparse(const char *buf, const char *max,
+			  unsigned long *nr_pages);
 
 static inline void page_counter_reset_watermark(struct page_counter *counter)
 {
diff -puN mm/hugetlb_cgroup.c~mm-page_counter-pull-1-handling-out-of-page_counter_memparse mm/hugetlb_cgroup.c
--- a/mm/hugetlb_cgroup.c~mm-page_counter-pull-1-handling-out-of-page_counter_memparse
+++ a/mm/hugetlb_cgroup.c
@@ -279,7 +279,7 @@ static ssize_t hugetlb_cgroup_write(stru
 		return -EINVAL;
 
 	buf = strstrip(buf);
-	ret = page_counter_memparse(buf, &nr_pages);
+	ret = page_counter_memparse(buf, "-1", &nr_pages);
 	if (ret)
 		return ret;
 
diff -puN mm/memcontrol.c~mm-page_counter-pull-1-handling-out-of-page_counter_memparse mm/memcontrol.c
--- a/mm/memcontrol.c~mm-page_counter-pull-1-handling-out-of-page_counter_memparse
+++ a/mm/memcontrol.c
@@ -3414,7 +3414,7 @@ static ssize_t mem_cgroup_write(struct k
 	int ret;
 
 	buf = strstrip(buf);
-	ret = page_counter_memparse(buf, &nr_pages);
+	ret = page_counter_memparse(buf, "-1", &nr_pages);
 	if (ret)
 		return ret;
 
@@ -3786,7 +3786,7 @@ static int __mem_cgroup_usage_register_e
 	unsigned long usage;
 	int i, size, ret;
 
-	ret = page_counter_memparse(args, &threshold);
+	ret = page_counter_memparse(args, "-1", &threshold);
 	if (ret)
 		return ret;
 
diff -puN mm/page_counter.c~mm-page_counter-pull-1-handling-out-of-page_counter_memparse mm/page_counter.c
--- a/mm/page_counter.c~mm-page_counter-pull-1-handling-out-of-page_counter_memparse
+++ a/mm/page_counter.c
@@ -166,18 +166,19 @@ int page_counter_limit(struct page_count
 /**
  * page_counter_memparse - memparse() for page counter limits
  * @buf: string to parse
+ * @max: string meaning maximum possible value
  * @nr_pages: returns the result in number of pages
  *
  * Returns -EINVAL, or 0 and @nr_pages on success.  @nr_pages will be
  * limited to %PAGE_COUNTER_MAX.
  */
-int page_counter_memparse(const char *buf, unsigned long *nr_pages)
+int page_counter_memparse(const char *buf, const char *max,
+			  unsigned long *nr_pages)
 {
-	char unlimited[] = "-1";
 	char *end;
 	u64 bytes;
 
-	if (!strncmp(buf, unlimited, sizeof(unlimited))) {
+	if (!strcmp(buf, max)) {
 		*nr_pages = PAGE_COUNTER_MAX;
 		return 0;
 	}
diff -puN net/ipv4/tcp_memcontrol.c~mm-page_counter-pull-1-handling-out-of-page_counter_memparse net/ipv4/tcp_memcontrol.c
--- a/net/ipv4/tcp_memcontrol.c~mm-page_counter-pull-1-handling-out-of-page_counter_memparse
+++ a/net/ipv4/tcp_memcontrol.c
@@ -120,7 +120,7 @@ static ssize_t tcp_cgroup_write(struct k
 	switch (of_cft(of)->private) {
 	case RES_LIMIT:
 		/* see memcontrol.c */
-		ret = page_counter_memparse(buf, &nr_pages);
+		ret = page_counter_memparse(buf, "-1", &nr_pages);
 		if (ret)
 			break;
 		mutex_lock(&tcp_limit_mutex);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
slab-embed-memcg_cache_params-to-kmem_cache.patch
slab-link-memcg-caches-of-the-same-kind-into-a-list.patch
cgroup-release-css-id-after-css_free.patch
slab-use-css-id-for-naming-per-memcg-caches.patch
memcg-free-memcg_caches-slot-on-css-offline.patch
list_lru-add-helpers-to-isolate-items.patch
memcg-reparent-list_lrus-and-free-kmemcg_id-on-css-offline.patch
memcg-cleanup-static-keys-decrement.patch
documentation-proc-add-proc-pid-numa_maps-interface-explanation-snippet.patch
fs-proc-task_mmu-show-page-size-in-proc-pid-numa_maps.patch
fs-proc-task_mmu-show-page-size-in-proc-pid-numa_maps-fix.patch

