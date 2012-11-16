From: akpm@linux-foundation.org
Subject: + res_counter-delete-res_counter_write.patch added to -mm tree
Date: Fri, 16 Nov 2012 14:54:27 -0800
Message-ID: <20121116225427.AF077100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:33380 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab2KPWy3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Nov 2012 17:54:29 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so360435vbi.1
        for <mm-commits@vger.kernel.org>; Fri, 16 Nov 2012 14:54:28 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gthelen@google.com, fweisbec@redhat.com, glommer@parallels.com, kamezawa.hiroyu@jp.fujitsu.com, tj@kernel.org


The patch titled
     Subject: res_counter: delete res_counter_write()
has been added to the -mm tree.  Its filename is
     res_counter-delete-res_counter_write.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -198,25 +198,3 @@ int res_counter_memparse_write_strategy(
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

memcg-make-it-possible-to-use-the-stock-for-more-than-one-page.patch
memcg-reclaim-when-more-than-one-page-needed.patch
memcg-change-defines-to-an-enum.patch
memcg-kmem-accounting-basic-infrastructure.patch
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
res_counter-delete-res_counter_write.patch

