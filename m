From: akpm@linux-foundation.org
Subject: [merged] res_counter-delete-res_counter_write.patch removed from -mm tree
Date: Fri, 14 Dec 2012 15:28:57 -0800
Message-ID: <20121214232857.BC12982004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:55139 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932668Ab2LNX27 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Dec 2012 18:28:59 -0500
Received: by mail-yh0-f74.google.com with SMTP id 10so409283yhl.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Dec 2012 15:28:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gthelen@google.com, fweisbec@redhat.com, glommer@parallels.com, kamezawa.hiroyu@jp.fujitsu.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: res_counter: delete res_counter_write()
has been removed from the -mm tree.  Its filename was
     res_counter-delete-res_counter_write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Greg Thelen <gthelen@google.com>
Subject: res_counter: delete res_counter_write()

Since 628f423553 ("memcg: limit change shrink usage") both
res_counter_write() and write_strategy_fn have been unused.  This patch
deletes them both.

Signed-off-by: Greg Thelen <gthelen@google.com>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Tejun Heo <tj@kernel.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/res_counter.h |    5 -----
 kernel/res_counter.c        |   22 ----------------------
 2 files changed, 27 deletions(-)

diff -puN include/linux/res_counter.h~res_counter-delete-res_counter_write include/linux/res_counter.h
--- a/include/linux/res_counter.h~res_counter-delete-res_counter_write
+++ a/include/linux/res_counter.h
@@ -74,14 +74,9 @@ ssize_t res_counter_read(struct res_coun
 		const char __user *buf, size_t nbytes, loff_t *pos,
 		int (*read_strategy)(unsigned long long val, char *s));
 
-typedef int (*write_strategy_fn)(const char *buf, unsigned long long *val);
-
 int res_counter_memparse_write_strategy(const char *buf,
 					unsigned long long *res);
 
-int res_counter_write(struct res_counter *counter, int member,
-		      const char *buffer, write_strategy_fn write_strategy);
-
 /*
  * the field descriptors. one for each member of res_counter
  */
diff -puN kernel/res_counter.c~res_counter-delete-res_counter_write kernel/res_counter.c
--- a/kernel/res_counter.c~res_counter-delete-res_counter_write
+++ a/kernel/res_counter.c
@@ -192,25 +192,3 @@ int res_counter_memparse_write_strategy(
 	*res = PAGE_ALIGN(*res);
 	return 0;
 }
-
-int res_counter_write(struct res_counter *counter, int member,
-		      const char *buf, write_strategy_fn write_strategy)
-{
-	char *end;
-	unsigned long flags;
-	unsigned long long tmp, *val;
-
-	if (write_strategy) {
-		if (write_strategy(buf, &tmp))
-			return -EINVAL;
-	} else {
-		tmp = simple_strtoull(buf, &end, 10);
-		if (*end != '\0')
-			return -EINVAL;
-	}
-	spin_lock_irqsave(&counter->lock, flags);
-	val = res_counter_member(counter, member);
-	*val = tmp;
-	spin_unlock_irqrestore(&counter->lock, flags);
-	return 0;
-}
_

Patches currently in -mm which might be from gthelen@google.com are

origin.patch
memcg-make-it-possible-to-use-the-stock-for-more-than-one-page.patch
memcg-reclaim-when-more-than-one-page-needed.patch
memcg-change-defines-to-an-enum.patch
memcg-kmem-accounting-basic-infrastructure.patch
memcg-kmem-accounting-basic-infrastructure-fix.patch
mm-add-a-__gfp_kmemcg-flag.patch
memcg-kmem-controller-infrastructure.patch
mm-allocate-kernel-pages-to-the-right-memcg.patch
res_counter-return-amount-of-charges-after-res_counter_uncharge.patch
memcg-kmem-accounting-lifecycle-management.patch
memcg-use-static-branches-when-code-not-in-use.patch
memcg-allow-a-memcg-with-kmem-charges-to-be-destructed.patch
memcg-execute-the-whole-memcg-freeing-in-free_worker.patch
fork-protect-architectures-where-thread_size-=-page_size-against-fork-bombs.patch
memcg-add-documentation-about-the-kmem-controller.patch
slab-slub-struct-memcg_params.patch
slab-annotate-on-slab-caches-nodelist-locks.patch
slab-slub-consider-a-memcg-parameter-in-kmem_create_cache.patch
memcg-allocate-memory-for-memcg-caches-whenever-a-new-memcg-appears.patch
memcg-infrastructure-to-match-an-allocation-to-the-right-cache.patch
memcg-skip-memcg-kmem-allocations-in-specified-code-regions.patch
slb-always-get-the-cache-from-its-page-in-kmem_cache_free.patch
slb-allocate-objects-from-memcg-cache.patch
memcg-destroy-memcg-caches.patch
memcg-slb-track-all-the-memcg-children-of-a-kmem_cache.patch
memcg-slb-shrink-dead-caches.patch
memcg-aggregate-memcg-cache-values-in-slabinfo.patch
slab-propagate-tunable-values.patch
slub-slub-specific-propagation-changes.patch
slub-slub-specific-propagation-changes-fix.patch
kmem-add-slab-specific-documentation-about-the-kmem-controller.patch

